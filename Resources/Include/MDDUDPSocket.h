/** UDP socket support (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version	$Id: MDDUDPSocket.h 16392 2012-07-24 11:23:25Z thie_be $
 * @since		2012-05-29
 * @copyright Modelica License 2
 *
 * @note Linux version: Using recvfrom(..) seems to be tricky, especially
 * in mixed 64 and 32 bit environments. Had the problem that (sporadically!) an
 * "Invalid Argument" error was generated. Fixed it, but not sure whether it is now
 * used really correct.
 * If problems persist consider passing "NULL" as the second last argument. In this
 * case "sa_len" is ignored and the sender's address will not be provided by
 * recvfrom(..). Since it is not really needed, one could live with that.
 *
 * @todo The windows version doesn't use a mechanism to protect against
 * concurrently accessing the UDP message (received in a dedicated thread).
 * That should be done.
 */

#ifndef MDDUDPSocket_H_
#define MDDUDPSocket_H_

#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

#include <winsock2.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

#pragma comment( lib, "Ws2_32.lib" )

typedef struct MDDUDPSocket_s MDDUDPSocket;

struct MDDUDPSocket_s
{
	char * receiveBuffer;
	int bufferSize;
	SOCKET SocketID;
	int recieving;
	int receivedBytes;
};

DWORD WINAPI MDD_udpReceivingThread(LPVOID pUdp)
{

	SOCKADDR remoteAddr;
	int remoteAddrLen;
	MDDUDPSocket * udp = (MDDUDPSocket *)pUdp;
	while(udp->recieving)
	{

		remoteAddrLen=sizeof(SOCKADDR);
		udp->receivedBytes=recvfrom(udp->SocketID,udp->receiveBuffer,udp->bufferSize,0,&remoteAddr,&remoteAddrLen);
		if(udp->receivedBytes==SOCKET_ERROR)
		{
			ModelicaFormatMessage("UDPSocket: recieving not possible, Socket not valid.\n");
		}
	}
	return 0;
}

void * MDD_udpConstructor(int port, int bufferSize)
{

	int rc;                /* Fehlervariable */
	WSADATA wsa;
	SOCKADDR_IN addr;
	DWORD id1;
	MDDUDPSocket * udp = (MDDUDPSocket *)malloc(sizeof(MDDUDPSocket));

	udp->receiveBuffer = (char*)malloc(bufferSize);
	udp->recieving = 1;
	udp->bufferSize = bufferSize;
	udp->receivedBytes = 0;

	rc = WSAStartup(MAKEWORD(2,0),&wsa);
	udp->SocketID=socket(AF_INET,SOCK_DGRAM,0);
	addr.sin_family=AF_INET;
	addr.sin_port=htons(port);
	addr.sin_addr.s_addr=INADDR_ANY;
	memset(udp->receiveBuffer,0,bufferSize);

	if(port)
		rc = bind(udp->SocketID,(SOCKADDR*)&addr,sizeof(SOCKADDR_IN));
	if(rc==INVALID_SOCKET && port !=0)
	{
		ModelicaFormatMessage("MDDUDPSocket.h: Error at bind(..) to port %d\n", port);
	}
	else
	{

                if(port)
                {
			ModelicaFormatMessage("MDDUDPSocket.h:: Waiting for data on port %d.\n",port);
			CreateThread(0,1024,MDD_udpReceivingThread,udp,0,&id1);
                }
                else
			ModelicaFormatMessage("MDDUDPSocket.h: Opened socket for sending.\n");

	}
	return (void *) udp;
}
void MDD_udpDestructor(void * p_udp)
{
        MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	udp->recieving = 0;
	closesocket(udp->SocketID);
	free(udp->receiveBuffer);
	free(udp);
}
void MDD_udpSend(void * p_udp, const char * ipAddress, int port,
		 const char * data, int dataSize)
{
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	SOCKADDR_IN addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(port);
	addr.sin_addr.s_addr=inet_addr(ipAddress);
	sendto(udp->SocketID,data,dataSize,0,(SOCKADDR*)&addr,sizeof(SOCKADDR_IN));

}
const char * MDD_udpRead(void * p_udp)
{
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	udp->receivedBytes = 0;
	return (const char*) udp->receiveBuffer;

}

int MDD_udpGetReceivedBytes(void * p_udp)
{
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	return udp->receivedBytes;
}

#elif defined(__linux__)

#include <stdlib.h>
#include <string.h> /* memset(..) */
#include <errno.h>

#include <sys/poll.h>
#include <netdb.h>
#include <pthread.h>



struct hostent *hostlist;   /* List of hosts returned
			       by gethostbyname. */

typedef struct MDDUDPSocket_s MDDUDPSocket;


/** UDP socket object */
struct MDDUDPSocket_s {
	int sock;  /**< connection socket. */
	struct sockaddr_in sa;   /**< Target connection address.*/
        /* int socketMode; */  /**< Mode of socket, e.g. sender or receiver */
	size_t messageLength; /**< message length (only relevant for read socket) */
	void* msgInternal;  /**< Internal UDP message buffer (only relevant for read socket) */
	void* msgExport;  /**< UDP message buffer exported to Modelica (only relevant for read socket) */
	ssize_t nReceivedBytes; /**< Number of received bytes (only relevant for read socket) */
	char targetIPAddress[20];
	int runReceive; /**< Run receiving thread as long as runReceive != 0  */
	pthread_t thread;
        pthread_mutex_t messageMutex; /**< Exclusive access to message buffer */
};

void MDD_udpDestructor(void * p_udp);


/** Dedicated thread for receiving UDP messages.
 *
 * @param p_udp pointer address to the udp socket data structure
 */
int MDD_udpReceivingThread(void * p_udp) {
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	socklen_t sa_len = sizeof(struct sockaddr_in);  /*  Size of sa. */
        struct pollfd sock_poll;
        int ret;

	ModelicaFormatMessage("Started dedicted UDP receiving thread listening at port %d\n",
			      udp->sock);

        sock_poll.fd = udp->sock;
        sock_poll.events = POLLIN | POLLHUP;

        while (udp->runReceive) {
                ret = poll(&sock_poll, 1, 100);

                switch (ret) {
                case -1:
                        ModelicaFormatError("MDDUDPSocket.h: poll(..) failed (%s) \n",
                                        strerror(errno));
                        break;
                case 0: /* no new data available. Just check if udp->runReceive still true and go on */
                        break;
                case 1: /* new data available */
                        if(sock_poll.revents & POLLHUP) {
                                ModelicaMessage("The UDP socket was disconnected. Exiting.\n");
                                exit(1);
                        } else {
                                /* Lock acces to udp->msgInternal  */
				pthread_mutex_lock(&(udp->messageMutex));
				/* Receive the next datagram  */
                                udp->nReceivedBytes =
                                        recvfrom(udp->sock,                   /* UDP socket */
                                                udp->msgInternal,             /* receive buffer */
                                                udp->messageLength,           /* max bytes to receive */
                                                0,                            /* no special flags */
                                                (struct sockaddr*) &(udp->sa),/* sender’s address */
                                                &sa_len
                                                );
				pthread_mutex_unlock(&(udp->messageMutex));

                                if (udp->nReceivedBytes < 0) {
                                        ModelicaFormatError("MDDUDPSocket.h: recfrom(..) failed (%s)\n",
                                                        strerror(errno));
                                }
                                break;
                        }
                default:
                        ModelicaFormatError("MDDUDPSocket.h: Poll returnd %d. That should not happen. Exiting\n", ret);
                        exit(1);
                }

	}
	return 0;
}

/** Read data from UDP socket.
 *
 * @param p_udp pointer address to the udp socket data structure
 * @return pointer to the message buffer
 */
const char * MDD_udpRead(void * p_udp) {
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;

	/* Lock acces to udp->msgInternal  */
	pthread_mutex_lock(&(udp->messageMutex));
	memcpy(udp->msgExport, udp->msgInternal, udp->messageLength);
	pthread_mutex_unlock(&(udp->messageMutex));



	return (const char*) udp->msgExport;
}


/** Nonblocking read data from UDP socket.
 *
 * @note No Modelica interface for this function, yet.
 *
 * @param p_udp pointer address to the udp socket data structure
 * @return pointer to the message buffer
 */
const char * MDD_udpNonBlockingRead(void * p_udp) {
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	socklen_t sa_len = sizeof(struct sockaddr_in);  /*  Size of sa. */
	struct pollfd sock_poll;
	int ret;

	sock_poll.fd = udp->sock;
	sock_poll.events = POLLIN | POLLHUP;

	ret = poll(&sock_poll, 1, 0);

	switch (ret) {

	case -1:
		ModelicaFormatError("MDDUDPSocket.h: poll(..) failed (%s) \n",
				    strerror(errno));
		break;

	case 0: /* no new data available */
		ModelicaMessage("No new data at socket available\n");
		break;

	case 1: /* new data available */
		if(sock_poll.revents & POLLHUP) {
			ModelicaMessage("The UDP socket was disconnected. Exiting.\n");
			exit(1);
		} else {

			/* Receive the next datagram. */
			udp->nReceivedBytes =
				recvfrom(udp->sock,                    /* UDP socket */
					 udp->msgExport,               /* receive buffer */
					 udp->messageLength,               /* max bytes to receive */
					 0,                            /* no special flags */
					 (struct sockaddr*) &(udp->sa),/* sender’s address */
					 &sa_len
					);

			if (udp->nReceivedBytes < 0) {
				ModelicaFormatError("MDDUDPSocket.h: recfrom(..) failed (%s)\n",
						    strerror(errno));
			}

			break;
		}
	default:
		ModelicaFormatError("MDDUDPSocket.h: Poll returnd %d. That should not happen. Exiting\n", ret);
		exit(1);
	}

	return (const char*) udp->msgExport;
}

/** Sent data via UDP socket.
 * @todo Information about ipAddress and port seems to be better suited to be given in the
 *       MDD_udpCreateSocket(..) functions for performance reasons, e.g., extensive tests about
 *       validity of passed in address and so on could be done once and for all time.
 * @param p_udp pointer address to the udp socket data structure
 * @param ipAddress (Remote) IP address to connect to
 * @param port (Remote) Port to connect to
 * @param data pointer to data that should be sent
 * @param dataSize size of message to be sent in byte
 */
void MDD_udpSend(void * p_udp, const char * ipAddress, int port,
		 const char * data, int dataSize) {

	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;

	int ret;
	/* Buffer for converting the resolved address to a readable format. */
	char dotted_ip[15];

	/* Look up the hostname with DNS. gethostbyname
	   (at least most UNIX versions of it) properly
	   handles dotted IP addresses as well as hostnames. */
	/*util_debug("Looking up %s...\n", ipAddress);*/
	hostlist = gethostbyname(ipAddress);
	if (hostlist == NULL) {
		ModelicaFormatError("MDDUDPSocket.h: gethostbyname(..) failed. Unable to resolve %s.\n", ipAddress);
		exit(1);
	}

	/* Good, we have an address. However, some sites
	   are moving over to IPv6 (the newer version of
	   IP), and we’re not ready for it (since it uses
	   a new address format). It’s a good idea to check
	   for this. */
	if (hostlist->h_addrtype != AF_INET) {
		ModelicaFormatError("MDDUDPSocket.h: Error, %s doesn’t seem to be an IPv4 address.\n",
				    ipAddress);
		exit(1);
	}

	/* inet_ntop converts a 32-bit IP address to
	   the dotted string notation (suitable for printing).
	   hostlist->h_addr_list is an array of possible addresses
	   (in case a name resolves to more than one IP). In most
	   cases we just want the first. */
	/* inet_ntop(AF_INET, hostlist->h_addr_list[0], dotted_ip, 15);
	   util_debug("Resolved %s to %s.\n", ipAddress, dotted_ip); */

	/* need to convert the target port number with the htons macro
	   to network byte order */
	udp->sa.sin_port = htons(port);
	/* The IP address is already
	   in network byte order (from the gethostbyname call)
	   The IP address was returned as a char * for various reasons.
	   Just memcpy it into the sockaddr_in structure. */
	memcpy(&(udp->sa.sin_addr), hostlist->h_addr_list[0],
	       hostlist->h_length);


	/* ModelicaFormatMessage("udp->sock: %d data: %s\n dataSize: %d\n",udp, data, dataSize); */


	ret = sendto(udp->sock,          /* initialized UDP socket */
		     data,               /* data to send */
		     dataSize,           /* message length */
		     0,                  /* no special flags */
		     (struct sockaddr*) &(udp->sa),  /* destination */
		     sizeof(struct sockaddr_in));
	if (ret < dataSize) {
		ModelicaFormatError("MDDUDPSocket.h: Expected to send: %d bytes, but was: %d\n"
				    "sendto(..) failed (%s)\n", dataSize, ret, strerror(errno));
		MDD_udpDestructor((void *) udp);
		exit(1);
	}

}

int MDD_udpGetReceivedBytes(void * p_udp) {
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	return udp->nReceivedBytes;
}


/** Create an UDP socket.
 * @todo Redesign in order to properly specify what kind of socket (receiving or sending)
 *       should be created and everything that can be checked once (e.g., validity of
 *       IP addresses) should be done here.
 * @param port @arg 0 if a sending socket shall be generated,
 *             @arg otherwise the number of the port at which the socket shall listen.
 * @param bufferSize size of the buffer used by a receiving socket (not needed for sending socket)
 */
void * MDD_udpConstructor(int port, int bufferSize) {
	MDDUDPSocket* udp = (MDDUDPSocket*) malloc(sizeof(MDDUDPSocket));
	int i, ret;

	udp->messageLength = bufferSize;
	udp->runReceive = 0;
	udp->msgInternal = calloc(udp->messageLength,1);
	udp->msgExport = calloc(udp->messageLength,1);
	ret = pthread_mutex_init(&(udp->messageMutex), NULL); /* Init mutex with defaults */
	if (ret != 0) {
		ModelicaFormatError("MDDUDPSocket.h: pthread_mutex_init() failed (%s)\n",
				    strerror(errno));
		exit(1);
	}

	/* Create a SOCK_DGRAM socket. */
	udp->sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
	if (udp->sock < 0) {
		ModelicaFormatError("MDDUDPSocket.h: socket(..) failed (%s)\n",
				    strerror(errno));
		exit(1);
	}
	ModelicaFormatMessage("Created socket handle: %d (%s socket)\n",
			      udp->sock, port == 0 ? "sending" : "receiving");

	/* Zero out the entire sockaddr_in structure. */
	memset(&(udp->sa), 0, sizeof(struct sockaddr_in));

	/* This is an Internet socket. */
	udp->sa.sin_family = AF_INET;

	/* We have a different setup, depending on the chosen mode (which depends on the value
	 * of the port argument */
	if(port) {
		ModelicaFormatMessage("Binding receiving UDP socket to port %d ...\n", port);
		/* need to convert the listening port number with the htons macro
		   to network byte order */
		udp->sa.sin_port = htons(port);
		udp->sa.sin_addr.s_addr = htonl(INADDR_ANY);  /* listen on
								 all interfaces */

		/* Bind to a port so the networking software will know
		   which port we’re interested in receiving packets from. */
		if (bind(udp->sock, (struct sockaddr *)&(udp->sa),
			 sizeof(udp->sa)) < 0) {
			ModelicaFormatError("MDDUDPSocket.h: bind(..) failed (%s)\n",
					    port,
					    strerror(errno));
			exit(1);
		}

		/* Start dedicated receiver thread */
		udp->runReceive = 1;
		ret = pthread_create(&udp->thread, 0, (void *) MDD_udpReceivingThread, udp);
		if (ret) {
			ModelicaFormatError("MDDUDPSocket: pthread(..) failed\n");
			exit (1);
		}
	}

	return (void *) udp;
}

/** Close socket and free memory.
 *  @param p_udp pointer address to the udp socket data structure
 */
void MDD_udpDestructor(void * p_udp) {
	MDDUDPSocket * udp = (MDDUDPSocket *) p_udp;
	void * pRet;

	/* stop receiving thread if any */
	if (udp->runReceive) {
		udp->runReceive = 0;
		pthread_join(udp->thread, &pRet);
		pthread_detach(udp->thread);
	}

	if (close(udp->sock) == -1) {
		ModelicaFormatError("MDDUDPSocket.h: close() failed (%s)\n", strerror(errno));
	}
	ModelicaFormatMessage("Closed UDP socket with socket handle %d\n", udp->sock);
	free(udp->msgInternal);
	free(udp->msgExport);
	free(udp);
}


#else

#error "Modelica_DeviceDrivers: No support of UDPSocket for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDUDPSocket_H_ */
