/** Serial port driver support (header-only library).
 *
 * @file
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @author		Dominik Sommer <dominik.sommer@dlr.de> (Linux)
 * @version	$Id$
 * @since		2012-05-29
 * @copyright Modelica License 2
 *
 * @note Currently only available for Linux.
 *
 */

#ifndef MDDSERIALPORT_H_
#define MDDSERIALPORT_H_

#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

#include <winsock2.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

#pragma comment( lib, "Ws2_32.lib" )

#error "Modelica_DeviceDrivers: Serial port not yet supported for MS Windows"

/* TODO: Implement Windows Driver */

#elif defined(__linux__)

#include <stdlib.h>
#include <string.h> /* memset(..) */
#include <errno.h>

#include <sys/poll.h>	/* pThread specific */
#include <netdb.h>	    /* pThread specific */
#include <pthread.h>	/* pThread specific */

#include <unistd.h>  	/* Serial specific */
#include <fcntl.h>	    /* Serial specific */
#include <termios.h>	/* Serial specific */


/** Serial port object */
typedef struct {
	int fd;		/** Device identifier */	
	int speed; 	/** Device Baudrate */
	int parity;	/** Device Parity Configuration */
	struct termios serial;
	size_t messageLength; /**< message length (only relevant for read socket) */
	void* msgInternal;  /**< Internal serial message buffer (only relevant for read socket) */
	void* msgExport;  /**< Serial message buffer exported to Modelica (only relevant for read socket) */
	ssize_t nReceivedBytes; /**< Number of received bytes (only relevant for read serial) */
	int runReceive; /**< Run receiving thread as long as runReceive != 0  */
	pthread_t thread;
    pthread_mutex_t messageMutex; /**< Exclusive access to message buffer */
} MDDSerialPort;

void MDD_serialPortDestructor(void * p_udp); 
int MDD_serialPortReceivingThread(void * p_serial);


int MDD_serialPortGetReceivedBytes(void * p_serial) {
	MDDSerialPort * serial = (MDDSerialPort *) p_serial;
	return serial->nReceivedBytes;
}


/** Function to set serial device to blocking or non-blocking.
 * 
 * @param fd file descriptor of opened serial port
 * @param should_block  @arg 0 if the serial device shall be non-blocking
 * 		                @arg 1 if the serial device shall be blocked
 */
void MDD_serialPortSetBlocking (int fd, int should_block) {
  
  struct termios ser;
  memset (&ser, 0, sizeof(ser));
  int ret = tcgetattr (fd, &ser); 
  if (ret != 0) {
    ModelicaFormatError("MDDSerialPort.h: Error %d from tcgetattr\n",ret);
    return;
    }
  
  ser.c_cc[VMIN] = should_block ? 1 : 0;
  ser.c_cc[VTIME] = 1;
  
  ret = tcsetattr (fd, TCSANOW, &ser);
  if (ret != 0) {
    ModelicaFormatError("MDDSerialPort.h: Error %d setting term attributes\n",ret);
    return;
    }
  
}

/** Function to set serial device attributes
 * 
 * @param @param fd file descriptor of opened serial port
 * @param speed set speed of the serial port interface in baud starting with "B" e.g.B115200	
 * @param parity  @arg 0 set no parity 
 * 		          @arg 1 set parity 
 */
void MDD_serialPortSetInterfaceAttributes (int fd, int speed, int parity) {
  
  struct termios ser;
  memset (&ser, 0, sizeof(ser));
  int ret = tcgetattr (fd, &ser); 
  if (ret != 0) {
    ModelicaFormatError("MDDSerialPort.h: Error %d from tcgetattr\n",ret);
    return;
    }
  
  cfsetospeed (&ser, speed);			// set output speed
  cfsetispeed (&ser, speed);			// set input speed
  
  ser.c_cflag = ( ser.c_cflag & ~CSIZE) | CS8;	// 8 bit characters shall be used
  ser.c_iflag &= ~IGNBRK;			// ignore break signal
  //ser.c_iflag |= IGNBRK;			// ignore break signal
  ser.c_lflag = 0;				// no signaling characters, no echo
  ser.c_oflag = 0;				// no remapping, no delays
  ser.c_cc[VMIN] = 0;				// read does not block
  ser.c_cc[VTIME] = 5;				// 0.5 second read timeout
  ser.c_iflag &= ~(IXON | IXOFF | IXANY);	// shut off xon/xoff control
  ser.c_cflag |= (CLOCAL | CREAD);		//ignore modem controls, enable reading
  
  switch (parity) {
    case 1:
	  /* even parity */
	  ser.c_cflag |= PARENB;			// enable parity 
	  ser.c_cflag &= ~PARODD;			// set even parity
	  ModelicaFormatMessage("Set even Parity of serial port handle: %d\n",fd);
	  break;
    case 2:
	  /* odd parity */
	  ser.c_cflag |= PARENB;			// enable parity 
	  ser.c_cflag |= PARODD;			// set even parity
	  ModelicaFormatMessage("Set odd Parity of serial port handle: %d\n",fd);
	  break;
    default:
   	  /* no parity */ 
	  ser.c_cflag &= ~(PARENB | PARODD);		// switch off any parity 
	  ser.c_cflag |= parity;			// set parity
	  ModelicaFormatMessage("Set no Parity of serial port handle: %d\n",fd);
	  break;
    }
      
  ser.c_cflag &= ~CSTOPB;
  ser.c_cflag &= ~CRTSCTS;
  
  ret = tcsetattr (fd, TCSANOW, &ser);
  if (ret != 0) {
    ModelicaFormatError("MDDSerialPort.h: Error %d setting term attributes\n",ret);
    return;
    }
  
}



/** Create a serial port from a serial device
 *
 * @param bufferSize size of the buffer used by a receiving socket (not needed for sending socket)
 */
void * MDD_serialPortConstructor(const char * deviceName, int bufferSize, int parity, int receiver, int baud) {    
	/* Allocation of data structure memory */
	MDDSerialPort* serial = (MDDSerialPort*) malloc(sizeof(MDDSerialPort)); 
	int i, ret;
	speed_t speed;
	serial->messageLength = bufferSize;
	serial->runReceive = 0;
	serial->msgInternal = calloc(serial->messageLength,1);
	serial->msgExport = calloc(serial->messageLength,1);
	ret = pthread_mutex_init(&(serial->messageMutex), NULL); /* Init mutex with defaults */
	if (ret != 0) {
		ModelicaFormatError("MDDSerialPort.h: pthread_mutex_init() failed (%s)\n",
				    strerror(errno));
		exit(1);
	}

	/* Create a serial port. */
	serial->fd = open (deviceName, O_RDWR |   /* sets device to read/write operation */
				       O_NOCTTY | /* sets device not to be the controlling terminal for that port */
				       O_NDELAY); /* sets device to do not care about state of DCD signal line */
				       /*O_SYNC); */ 
	if (serial->fd < 0) {
		ModelicaFormatError("MDDSerialPort.h: open(..) of serial port %s failed (%s)\n", deviceName,
				    strerror(errno));
		exit(1);
	}
	
	switch (baud) {
	  case 1:
	     speed = B115200; break;
	  case 2:
	     speed = B57600; break;
	  case 3:
	     speed = B38400; break;
	  case 4:
	     speed = B19200; break;
	  case 5:
	     speed = B9600; break;
	  case 6:
	     speed = B4800; break;
	  case 7:
	     speed = B2400; break;
	  default:
	     speed = B57600; break;
	}
	
	ModelicaFormatMessage("Created serial port handle: %d \n",serial->fd);
	ModelicaFormatMessage("Created serial port for device %s\n",deviceName);
	ModelicaFormatMessage("Set serial port %s to speed: %d\n",deviceName,(baud));
	
	MDD_serialPortSetInterfaceAttributes (serial->fd, speed, parity);
	MDD_serialPortSetBlocking (serial->fd,0);	
	
	if (receiver) {
	/* Start dedicated receiver thread */
	serial->runReceive = 1;
	ret = pthread_create(&serial->thread, 0, (void *) MDD_serialPortReceivingThread, serial);
	if (ret) {
		ModelicaFormatError("MDDSerialPort.h: pthread (MDD_serialPortReceivingThread) failed\n");
		exit (1);
	}
	}

	return (void *) serial;
}

/** Dedicated thread to receive data from serial ports.
 *
 * @param p_udp pointer address to the udp socket data structure
 */
int MDD_serialPortReceivingThread(void * p_serial) {
	MDDSerialPort * serial = (MDDSerialPort *) p_serial;
	
    struct pollfd serial_poll;
    int ret;

	ModelicaFormatMessage("Started dedicated serial port receiving thread listening at port %d\n",
			      serial->fd);

    serial_poll.fd = serial->fd;
	serial_poll.events = POLLIN | POLLHUP;
	
    while (serial->runReceive) {
            ret = poll(&serial_poll, 1, 100);

            switch (ret) {
            case -1:
                ModelicaFormatError("MDDSerialPort.h: poll(..) failed (%s) \n",
                                strerror(errno));
                break;
            case 0: /* no new data available. Just check if serial->runReceive still true and go on */
                break;
            case 1: /* new data available */
                if(serial_poll.revents & POLLHUP) {
                        ModelicaMessage("The serial port was disconnected. Exiting.\n");
                        exit(1);
                } else {
                    /* Lock acces to serial->msgInternal  */
            		pthread_mutex_lock(&(serial->messageMutex));
            		/* Receive the next datagram  */
                    serial->nReceivedBytes =
                            read(serial->fd,           /* serial port file handle*/
                                serial->msgInternal,   /* receive buffer */
                                serial->messageLength  /* max bytes to receive */
                                );
            		pthread_mutex_unlock(&(serial->messageMutex));

                    if (serial->nReceivedBytes < 0) {
                        ModelicaFormatError("MDDSerialPort.h: read(..) failed (%s)\n", strerror(errno));
                    }
                }
                break;
            default:
                ModelicaFormatError("MDDSerialPort.h: Poll returnd %d. That should not happen. Exiting\n", ret);
                exit(1);
            }
	}
	return 0;
}


/** Read data from serial port.
 *
 * @param p_serial pointer address to the serial port data structure
 * @return pointer to the message buffer
 */
const char * MDD_serialPortRead(void * p_serial) {
	
	MDDSerialPort * serial = (MDDSerialPort *) p_serial;
	
	/* Lock acces to serial->msgInternal  */
	pthread_mutex_lock(&(serial->messageMutex));
	memcpy(serial->msgExport, serial->msgInternal, serial->messageLength);
	pthread_mutex_unlock(&(serial->messageMutex));
	return (const char*) serial->msgExport;
}

/** Send data via serial port
 *
 *  @param p_serial pointer address to the serial port data structure
 *  @param data data to be sent
 *  @param dataSize size of data 
 */
void MDD_serialPortSend(void * p_serial, const char * data, int * dataSize) {

	MDDSerialPort * serial = (MDDSerialPort *) p_serial;

	int ret;
	ret = write(serial->fd, data, dataSize); // write to serial port
	if (ret < dataSize) {
		ModelicaFormatError("MDDSerialPort.h: Expected to send: %d bytes, but was: %d\n"
				    "sendto(..) failed (%s)\n", dataSize, ret, strerror(errno));
		MDD_serialPortDestructor((void *) serial);
		exit(1);
	}

}


/** Close serial port and free memory.
 *  @param p_serial pointer address to the serial port data structure
 */
void MDD_serialPortDestructor(void * p_serial) {
 	MDDSerialPort * serial = (MDDSerialPort *) p_serial;
	void * pRet;

	/* stop receiving thread if any */
	if (serial->runReceive) {
		serial->runReceive = 0;
		pthread_join(serial->thread, &pRet);
		pthread_detach(serial->thread);
	}

 	if (close(serial->fd) == -1) {
 		ModelicaFormatError("MDDSerialPort.h: close() failed (%s)\n", strerror(errno));
 	}
 	ModelicaFormatMessage("Closed serial port handle %d\n", serial->fd);
 	free(serial->msgInternal);
 	free(serial->msgExport);
 	free(serial);
}


#else

#error "Modelica_DeviceDrivers: No serial port support for your platform"

#endif /* defined(__linux__) */

#endif /* MDDSERIALPORT_H_ */
