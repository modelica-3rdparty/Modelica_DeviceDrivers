/** Support for Linux Socket CAN API (header-only library).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 *
 * Modelica external function interface to use the CAN socket interface
 * of the Linux kernel (http://svn.berlios.de/wsvn/socketcan/trunk/kernel/2.6/Documentation/networking/can.txt).
 * Tested with the virtual CAN interface "vcan".
  - Create a virtual CAN network interface (vcan0):
       $ modprobe vcan
       $ ip link add type vcan

  - Create a virtual CAN network interface with a specific name 'vcan42':

       $ ip link add dev vcan42 type vcan

  - Remove a (virtual CAN) network interface 'vcan42':

       $ ip link del vcan42

  - Bring them up

       $ ifconfig vcan0 up
       $ ifconfig vcan1 up

  - Show statistics about device

      $ ip -det -stat link show vcan0

  - CAN utilities
    https://gitorious.org/linux-can/can-utils
      $ ./candump can0
      $ ./cangen can0
      $ ./cansend can0 123#abcd

  - Please also have a look into the kernel documentation (Documentation/networking/can.txt) for further info
    Especially section "6.5.1 Netlink interface to set/get devices properties" and
    "6.5.2 Setting the CAN bit-timing" that describes how to setup CAN hardware using the netlink interface
    e.g., for setting the bitrate:
      $ ip link set canX type can bitrate 125000

  - An alternative implementation that suggests itself is an approach that uses a dedicated socket for each
    (RX) message of interest and takes advantage of the kernel filtering lists
    ("4.1 RAW protocol sockets with can_filters (SOCK_RAW)") to subscribe to exactly that message.
    Reading would be realized by non-blocking reads called directly from the Modelica execution thread
    (instead of using a dedicated receiving thread and IPC techniques).
*/
#ifndef MDDSOCKETCAN_H_
#define MDDSOCKETCAN_H_

#if defined(__linux__)

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <net/if.h>

#include <linux/can.h>
#include <linux/can/raw.h>

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include <unistd.h>

#include "ModelicaUtilities.h"
#include "../src/include/util.h"

/* At time of writing, these constants are not defined in the headers */
#ifndef PF_CAN
#define PF_CAN 29
#endif

#ifndef AF_CAN
#define AF_CAN PF_CAN
#endif

/** External Object data structure. */
typedef struct {
  int skt;
  struct ifreq ifr;
  struct sockaddr_can addr;
  void * p_mDDMapIntpVoid; /**< pointer to MDDMapIntpVoid map (util.h) associating CAN
                              identifier (key) to corresponding frame payload data (value) */
  pthread_mutex_t mapMutex; /**< Exclusive access to p_mDDMapIntpVoid */
  pthread_t thread;
  int runReceive; /**< Run receiving thread as long as runReceive != 0  */
} MDDSocketCAN;

int MDD_socketCANRxThread(MDDSocketCAN * mDDSocketCAN);

/** Create RAW can socket and bind it to the CAN network interface ifname
 *
 * Also, a dedicated CAN frame receiver thread is started for the
 * interface (regardless whether we are interested in receiving some frames
 * or not!).
 *
 * @param[in] ifname name of the interface (as displayed by ifconfig).
 * @return Modelica external object (MDDSocketCAN)
 */
void* MDD_socketCANConstructor(const char* ifname) {
  MDDSocketCAN* mDDSocketCAN = (MDDSocketCAN*) malloc(sizeof(MDDSocketCAN));
  int ret;

  ModelicaFormatMessage("SocketCAN (%s): Creating CAN_RAW socket ...", ifname);
  mDDSocketCAN->skt = socket(PF_CAN, SOCK_RAW, CAN_RAW);
  if(mDDSocketCAN->skt == -1) {
    ModelicaFormatError("MDDSocketCAN.h: socket failure (%s)\n", strerror(errno));
    exit(-1);
  } else {
	  ModelicaFormatMessage("\tOK (socket descriptor %d)\n", mDDSocketCAN->skt);
  }

  /* Locate the interface you wish to use */
  ModelicaFormatMessage("SocketCAN (%s): Searching for CAN interface %s ...", ifname, ifname);
  strcpy(mDDSocketCAN->ifr.ifr_name, ifname);
  /* ifr.ifr_ifindex gets filled with that device's index: */
  if (ioctl(mDDSocketCAN->skt, SIOCGIFINDEX, &(mDDSocketCAN->ifr)) == -1) {
    ModelicaFormatError("MDDSocketCAN.h: ioctl failure (%s)\n", strerror(errno));
    exit(-1);
  }
  ModelicaFormatMessage("\tOK\n", ifname);

  /* Select that CAN interface, and bind the socket to it. */
  ModelicaFormatMessage("SocketCAN (%s): Bind socket (descriptor %d) to interface %s ...",
			ifname, mDDSocketCAN->skt, ifname);
  struct sockaddr_can addr;
  mDDSocketCAN->addr.can_family = AF_CAN;
  mDDSocketCAN->addr.can_ifindex = mDDSocketCAN->ifr.ifr_ifindex;
  if ( bind( mDDSocketCAN->skt, (struct sockaddr*)&(mDDSocketCAN->addr), sizeof(mDDSocketCAN->addr) ) == -1) {
    ModelicaFormatError("MDDSocketCAN.h: bind failure (%s)\n", strerror(errno));
  } else {
    ModelicaFormatMessage("\tOK\n");
  }

  /* Create map for storing frame identifiers as keys and pointers to the corresponding frame payload data
   * as values */
  mDDSocketCAN->p_mDDMapIntpVoid = MDD_mapIntpVoidConstructor();
  /* Init mutex with defaults */
  ret = pthread_mutex_init(&(mDDSocketCAN->mapMutex), NULL);
  if (ret != 0) {
    ModelicaFormatError("MDDSocketCAN.h: pthread_mutex_init() failed (%s)\n",
			strerror(errno));
    exit(1);
  }

  /* Start dedicated receiver thread */
  mDDSocketCAN->runReceive = 1;
  ret = pthread_create(&mDDSocketCAN->thread, 0, (void *) MDD_socketCANRxThread, mDDSocketCAN);
  if (ret) {
	  ModelicaFormatError("MDDSocketCAN.h: pthread(..) failed\n");
	  exit (1);
  }

  return mDDSocketCAN;
}

void MDD_socketCANDestructor(void* p_mDDSocketCAN) {
  MDDSocketCAN * mDDSocketCAN = (MDDSocketCAN *) p_mDDSocketCAN;
  int * keys, nKeys, i;
  void * pRet;
  char * data;

  /* stop receiving thread if any */
  if (mDDSocketCAN->runReceive) {
  	  mDDSocketCAN->runReceive = 0;
  	  pthread_join(mDDSocketCAN->thread, &pRet);
  	  pthread_detach(mDDSocketCAN->thread);
  }

  ModelicaFormatMessage("SocketCAN (%s): Closing descriptor %d and cleaning up ...",
    mDDSocketCAN->ifr.ifr_name, mDDSocketCAN->skt);
	if (close(mDDSocketCAN->skt) == -1) {
    ModelicaFormatError("MDDSocketCAN.h: close() failed (%s)\n", strerror(errno));
  }
  nKeys = MDD_mapIntpVoidSize(mDDSocketCAN->p_mDDMapIntpVoid);
  keys = calloc(sizeof(int), nKeys);
  MDD_mapIntpVoidGetKeys(mDDSocketCAN->p_mDDMapIntpVoid, keys);
  for (i=0; i < nKeys; i++) {
    data = MDD_mapIntpVoidLookup(mDDSocketCAN->p_mDDMapIntpVoid, keys[i]);
    free(data);
  }
  MDD_mapIntpVoidDestructor(mDDSocketCAN->p_mDDMapIntpVoid);

  free(mDDSocketCAN);
  ModelicaFormatMessage("\tOK.\n");
}

/** Define key/value pair for map associating identifiers to frame payload data.
 *
 * @param p_mDDSocketCAN pointer to external object (MDDSocketCAN struct)
 * @param[in] can_id CAN frame identifier
 * @param[in] can_dlc length of data in bytes (min=0, max=8)
 */
void MDD_socketCANDefineObject(void* p_mDDSocketCAN, int can_id, int can_dlc) {
	MDDSocketCAN * mDDSocketCAN = (MDDSocketCAN *) p_mDDSocketCAN;
	char * data;

	data = calloc(sizeof(char), can_dlc);

        /* Exclusive access to map */
	pthread_mutex_lock(&(mDDSocketCAN->mapMutex));
	MDD_mapIntpVoidInsert(mDDSocketCAN->p_mDDMapIntpVoid, can_id, data);
	pthread_mutex_unlock(&(mDDSocketCAN->mapMutex));

	ModelicaFormatMessage("SocketCAN (%s): Defined %d byte buffer slot for frame id %d.\n",
		mDDSocketCAN->ifr.ifr_name, can_dlc, can_id);
}


/** Write CAN frame/message to CAN interface
 * @param[in] p_mDDSocketCAN pointer to external object (MDDSocketCAN struct)
 * @param[in] can_id CAN frame identifier
 * @param[in] can_dlc length of data in bytes (min=0, max=8)
 * @param[in] data the data that shall be transmitted
 */
void MDD_socketCANWrite(void* p_mDDSocketCAN, int can_id, int can_dlc,
			     const char* data) {
  MDDSocketCAN * mDDSocketCAN = (MDDSocketCAN *) p_mDDSocketCAN;
  ssize_t bytes_sent;
  struct can_frame txframe;
  txframe.can_id = can_id;
  memcpy(txframe.data, data, can_dlc);
  txframe.can_dlc = can_dlc;

  bytes_sent = write( mDDSocketCAN->skt, &txframe, sizeof(txframe) );
  if (bytes_sent != sizeof(txframe)) {
    if (bytes_sent == -1)
      ModelicaFormatError("MDDSocketCAN.h: write() of CAN ID %d to %s failed (%s)\n",
        can_id, mDDSocketCAN->ifr.ifr_name, strerror(errno));
    else
      ModelicaFormatError("MDDSocketCAN.h: write() CAN ID %d to %s only wrote %d of %d bytes\n",
        can_id, mDDSocketCAN->ifr.ifr_name, bytes_sent, sizeof(txframe));
  }
}

/** Read CAN frame/message from CAN interface.
 *
 * @TODO Not sure whether memcpy to data is possible in external Modelica functions. Check.
 *
 * In the moment this function will always return data (given an existing key/value entry)
 * @TODO Should have a warning if the function is called and no *new* data is available
 *
 * @param[in] p_mDDSocketCAN pointer to external object (MDDSocketCAN struct)
 * @param[in] can_id CAN frame identifier
 * @param[in] can_dlc length of data in bytes (min=0, max=8)
 * @param[out] data up-to-date payload data for corresponding can_id
 * @return pointer to the up-to-date payload data (== data)
 */
const char * MDD_socketCANRead(void* p_mDDSocketCAN, int can_id,  int can_dlc, char* data) {
	MDDSocketCAN * mDDSocketCAN = (MDDSocketCAN *) p_mDDSocketCAN;
	void * value;

	/* Ensure exclusive access to map */
	pthread_mutex_lock(&(mDDSocketCAN->mapMutex));
	value = MDD_mapIntpVoidLookup(mDDSocketCAN->p_mDDMapIntpVoid, can_id);
	memcpy(data, value, can_dlc);
	pthread_mutex_unlock(&(mDDSocketCAN->mapMutex));
	return data;
}

/** Dedicated thread for receiving CAN frames.
 *
 * @param[in] mDDSocketCAN pointer to external object (MDDSocketCAN struct)
 * @return 0 (if thread stopped by mDDSocketCAN->runReceive == 0)
 */
int MDD_socketCANRxThread(MDDSocketCAN * mDDSocketCAN) {
   struct can_frame rxframe;
   int bytes_read, ret;
   void * data;
   struct pollfd sock_poll;

   ModelicaFormatMessage("SocketCAN (%s): Started dedicted CAN frames receiving thread (socket descriptor %d).\n",
   			 mDDSocketCAN->ifr.ifr_name, mDDSocketCAN->skt);


   sock_poll.fd = mDDSocketCAN->skt;
   sock_poll.events = POLLIN | POLLHUP;

   while (mDDSocketCAN->runReceive) {
     ret = poll(&sock_poll, 1, 100);
     switch (ret) {
       case -1:
         ModelicaFormatError("MDDSocketCAN.h: poll(..) failed (%s) \n",
			     strerror(errno));
	 break;
       case 0: /* no new data available. Just check if mDDSocketCAN->runReceive still true and go on */
	 break;
       case 1: /* new data available */
	 if(sock_poll.revents & POLLHUP) {
	   ModelicaFormatMessage("SocketCAN (%s): The CAN socket was disconnected. Exiting.\n",
			   mDDSocketCAN->ifr.ifr_name);
	   exit(1);
	 } else {
	   /* Receive the next CAN frame  */
	   bytes_read = read( mDDSocketCAN->skt, &rxframe, sizeof(rxframe) );
	   if (bytes_read < 0) {
	     ModelicaFormatError("MDDSocketCAN.h: read(..) failed (%s)\n",
				 strerror(errno));
	   } else if (bytes_read == 0) {
	     ModelicaFormatError("MDDSocketCAN.h: Error (zero bytes read): %s\n",
				 strerror(errno));
	   } else {
	     /* Lock access to map  */
	     pthread_mutex_lock(&(mDDSocketCAN->mapMutex));
	     /* Check if can identifier exists in map before accessing the element.
                If it doesn't exist, just silently ignore the frame */
	     if (MDD_mapIntpVoidCount(mDDSocketCAN->p_mDDMapIntpVoid,  rxframe.can_id) > 0) {
	       data = MDD_mapIntpVoidLookup(mDDSocketCAN->p_mDDMapIntpVoid, rxframe.can_id);
	       memcpy(data, rxframe.data, rxframe.can_dlc);
	     }
	     pthread_mutex_unlock(&(mDDSocketCAN->mapMutex));
	   }
	   break;
	 }
       default:
	 ModelicaFormatError("MDDSocketCAN.h: Poll returnd %d. That should not happen. Exiting\n", ret);
	 exit(1);
     }
   }
   return 0;
}

/** Dedicated thread for receiving CAN frames.
 *
 * @deprecated Since the used read() blocks, the thread can not be stopped in a clean way
 * from the destructor of the module.
 *
 * @param[in] mDDSocketCAN pointer to external object (MDDSocketCAN struct)
 * @return 0 (if thread stopped by mDDSocketCAN->runReceive == 0)
 */
int MDD_socketCANRxThread_DEPRECATED(MDDSocketCAN * mDDSocketCAN) {
   struct can_frame rxframe;
   int bytes_read, ret;
   void * data;
   ModelicaFormatMessage("SocketCAN (%s): Started dedicted CAN frames receiving thread, (socket descriptor %d).\n",
   			 mDDSocketCAN->ifr.ifr_name,  mDDSocketCAN->skt);

   while (mDDSocketCAN->runReceive) {
	   /* Receive the next CAN frame  */
	   bytes_read = read( mDDSocketCAN->skt, &rxframe, sizeof(struct can_frame) );
	   if (bytes_read < 0) {
	     ModelicaFormatError("MDDSocketCAN.h: read(..) failed (%s)\n",
				 strerror(errno));
	   } else if (bytes_read == 0) {
	     ModelicaFormatError("MDDSocketCAN.h: Error (zero bytes read): %s\n",
				 strerror(errno));
	   } else {
	     /* Lock access to map  */
	     pthread_mutex_lock(&(mDDSocketCAN->mapMutex));
	     /* Check if can identifier exists in map before accessing the element.
                If it doesn't exist, just silently ignore the frame */
	     if (MDD_mapIntpVoidCount(mDDSocketCAN->p_mDDMapIntpVoid,  rxframe.can_id) > 0) {
	       data = MDD_mapIntpVoidLookup(mDDSocketCAN->p_mDDMapIntpVoid, rxframe.can_id);
	       memcpy(data, rxframe.data, rxframe.can_dlc);
	     }
	     pthread_mutex_unlock(&(mDDSocketCAN->mapMutex));
	   }
     }
   return 0;
}

#else

  #error "Modelica_DeviceDrivers: Socket CAN driver only supported on linux!"

#endif /* defined(__linux__) */

#endif /* MDDSOCKETCAN_H_ */
