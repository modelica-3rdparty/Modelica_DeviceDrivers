/** TCP/IP socket support (header-only library).
 *
 * @file
 * @author tbeu (Windows)
 * @author bernhard-thiele (Linux adaption)
 * @since 2015-04-18
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 */

#ifndef MDDTCPIPSocket_H_
#define MDDTCPIPSocket_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

#if defined(_MSC_VER) || defined(__MINGW32__)

#include <ws2tcpip.h>
#include <stdio.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"

#pragma comment( lib, "Ws2_32.lib" )

typedef struct MDDTCPIPSocket_s MDDTCPIPSocket;

struct MDDTCPIPSocket_s {
    SOCKET SocketID;
};

DllExport void * MDD_TCPIPClient_Constructor(void) {
    MDDTCPIPSocket** tcpip = (MDDTCPIPSocket **)calloc(sizeof(MDDTCPIPSocket*), 1);
    if (tcpip) {
        *tcpip = (MDDTCPIPSocket *)calloc(sizeof(MDDTCPIPSocket), 1);
        if (*tcpip) {
            int rc; /* Error variable */
            WSADATA wsa;

            (*tcpip)->SocketID = INVALID_SOCKET;

            /* Initialize Winsock */
            rc = WSAStartup(MAKEWORD(2,2), &wsa);
            if (rc != NO_ERROR) {
                ModelicaFormatError("MDDTCPIPSocket.h: WSAStartup failed with error: %d\n", rc);
            }
        }
    }

    return (void *) tcpip;
}

DllExport int MDD_TCPIPClient_Connect(void * p_tcpip, const char* ipaddress, int port) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    int ret = 0;
    if (tcpip && *tcpip) {
        if ((*tcpip)->SocketID == INVALID_SOCKET) {
            int rc; /* Error variable */
            struct addrinfo *result = NULL;
            struct addrinfo *ptr = NULL;
            struct addrinfo hints;
            char port_str[21];

            memset(&hints, 0, sizeof(hints));
            hints.ai_family = AF_UNSPEC;
            hints.ai_socktype = SOCK_STREAM;
            hints.ai_protocol = IPPROTO_TCP;

            /* Resolve the server address and port */
            _snprintf(port_str, 20, "%d", port);
            rc = getaddrinfo(ipaddress, port_str, &hints, &result);
            if (rc != NO_ERROR) {
                free(*tcpip);
                *tcpip = NULL;
                WSACleanup();
                ModelicaFormatError("MDDTCPIPSocket.h: getaddrinfo failed with error: %d\n", rc);
            }

            /* Attempt to connect to an address until one succeeds */
            for (ptr = result; ptr != NULL; ptr = ptr->ai_next) {

                /* Create a SOCKET for connecting to server */
                (*tcpip)->SocketID = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
                if ((*tcpip)->SocketID == INVALID_SOCKET) {
                    free(*tcpip);
                    *tcpip = NULL;
                    rc = WSAGetLastError();
                    WSACleanup();
                    ModelicaFormatError("MDDTCPIPSocket.h: socket failed with error: %d\n", rc);
                }

                /* Connect to server */
                rc = connect((*tcpip)->SocketID, ptr->ai_addr, (int)ptr->ai_addrlen);
                if (rc == SOCKET_ERROR) {
                    closesocket((*tcpip)->SocketID);
                    (*tcpip)->SocketID = INVALID_SOCKET;
                    continue;
                }
                break;
            }

            freeaddrinfo(result);

            if ((*tcpip)->SocketID == INVALID_SOCKET) {
                free(*tcpip);
                *tcpip = NULL;
                WSACleanup();
                ModelicaFormatError("MDDTCPIPSocket.h: Unable to connect to server!\n");
            }

            ret = 1;
        }
        else {
            ret = 1;
        }
    }
    return ret;
}

DllExport void MDD_TCPIPClient_Destructor(void * p_tcpip) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    if (tcpip) {
        if (*tcpip) {
            if ((*tcpip)->SocketID != INVALID_SOCKET) {
                shutdown((*tcpip)->SocketID, SD_BOTH);
                closesocket((*tcpip)->SocketID);
            }
            free(*tcpip);
            WSACleanup();
        }
        free(tcpip);
    }
}

DllExport int MDD_TCPIPClient_Send(void * p_tcpip, const char * data, int dataSize) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    int rc = 0;
    if (tcpip && *tcpip) {
        rc = send((*tcpip)->SocketID, data, dataSize, 0);
        if (rc == SOCKET_ERROR) {
            ModelicaFormatMessage("MDDTCPIPSocket.h: send failed with error: %d\n", WSAGetLastError());
            rc = 1;
        }
    }
    return rc;
}

DllExport int MDD_TCPIPClient_SendP(void * p_tcpip, void* p_package, int dataSize) {
    return MDD_TCPIPClient_Send(p_tcpip, MDD_SerialPackagerGetData(p_package), dataSize);
}

DllExport const char * MDD_TCPIPClient_Read(void * p_tcpip, int recvbuflen) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    if (tcpip && *tcpip) {
        char* tcpBuf = ModelicaAllocateString(recvbuflen);
        if (tcpBuf) {
            int rc = recv((*tcpip)->SocketID, tcpBuf, recvbuflen, 0);
            if (rc == SOCKET_ERROR) {
                ModelicaFormatMessage("MDDTCPIPSocket.h: recv failed with error: %d\n", WSAGetLastError());
            }
            return (const char*) tcpBuf;
        }
    }
    return "";
}

DllExport void MDD_TCPIPClient_ReadP(void * p_tcpip, void* p_package, int recvbuflen) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    if (tcpip && *tcpip) {
        char* tcpBuf = (char*) malloc(recvbuflen);
        if (tcpBuf) {
            int rc = recv((*tcpip)->SocketID, tcpBuf, recvbuflen, 0);
            if (rc == SOCKET_ERROR) {
                ModelicaFormatMessage("MDDTCPIPSocket.h: recv failed with error: %d\n", WSAGetLastError());
            }
            rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, tcpBuf, rc);
            free(tcpBuf);
            if (rc) {
                ModelicaError("MDDTCPIPSocket.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
            }
        }
    }
}

#elif defined(__linux__) || defined(__CYGWIN__)

#include <stdlib.h>
#include <string.h> /* memset(..) */
#include <errno.h>
#include <unistd.h> /* close */
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include "../src/include/CompatibilityDefs.h"

typedef struct MDDTCPIPSocket_s MDDTCPIPSocket;

/** TCPIP socket object */
struct MDDTCPIPSocket_s {
    int sfd;  /**< socket file descriptor. */
};

/** Create a TCPIP socket.
 */
void * MDD_TCPIPClient_Constructor(void) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)malloc(sizeof(MDDTCPIPSocket));

    tcpip->sfd = socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    if (tcpip->sfd < 0) {
        ModelicaFormatError("MDDTCPIPSocket.h: socket(..) failed (%s)\n",
                            strerror(errno));
    }
    ModelicaFormatMessage("Created server socket handle: %d\n", tcpip->sfd);

    return (void *)tcpip;
}

/** Close socket and free memory.
 * @param p_tcpip pointer address to the tcpip socket data structure
 */
void MDD_TCPIPClient_Destructor(void *p_tcpip) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)p_tcpip;

    if (close(tcpip->sfd) == -1) {
        ModelicaFormatError("MDDTCPIPSocket.h: close() failed (%s)\n",
                            strerror(errno));
    }

    ModelicaFormatMessage("Closed TCP/IP socket with socket handle %d\n", tcpip->sfd);
    free(tcpip);
}

/** Connect client to server
 * @param p_tcpip pointer address to the tcpip socket data structure
 * @param ipaddress (Remote) IP address to connect to
 * @param port (Remote) port to connect to
 * @return returns 1
 */
int MDD_TCPIPClient_Connect(void *p_tcpip, const char *ipaddress, int port) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)p_tcpip;
    struct addrinfo hints;
    struct addrinfo *result, *rp;
    int s;
    char port_str[21];
    // socklen_t clilen;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_UNSPEC;    /* Allow IPv4 or IPv6 */
    hints.ai_socktype = SOCK_STREAM; /* TCP/IP socket */
    hints.ai_protocol = IPPROTO_TCP; /* TCP/IP protocol */

    /* Resolve the server address and port */
    ModelicaFormatMessage("Resolving server address  %s:%d ...\n", ipaddress, port);
    snprintf(port_str, 20, "%d", port);
    s = getaddrinfo(ipaddress, port_str, &hints, &result);
    if (s != 0) {
        ModelicaFormatError("MDDTCPIPSocket.h: getaddrinfo(..) failed (%s) \n",
                            gai_strerror(s));
    }

    /* getaddrinfo() returns a list of address structures.
       Attempt to connect to an address until one succeeds */
    for (rp = result; rp != NULL; rp = rp->ai_next) {
        tcpip->sfd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (tcpip->sfd == -1)
            continue;

        if (connect(tcpip->sfd, rp->ai_addr, rp->ai_addrlen) != -1)
            break;  /* Success */

        close(tcpip->sfd);
    }

    if (rp == NULL) {  /* No address succeeded */
        ModelicaFormatError("MDDTCPIPSocket.h: Unable to connect to server.\n");
    } else {
      ModelicaFormatMessage("Connected to  %s:%d ...\n", ipaddress, port);
    }

    freeaddrinfo(result); /* No longer needed */

    return 1;
}

/** Send data via TCP/IP socket.
 * @param p_tcpip pointer address to the tcpip socket data structure
 * @param data pointer to data that should be sent
 * @param dataSize size of data to be sent in byte
 * @return returns 1
 */
int MDD_TCPIPClient_Send(void *p_tcpip, const char *data, int dataSize) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)p_tcpip;
    int amt, sent = 0;

    /* Repeatedly call write until the entire buffer is sent. */
    while (sent < dataSize) {
        amt = write(tcpip->sfd, data+sent, dataSize-sent);

        if (amt <= 0) {
            /* Zero-byte writes are OK if they are caused by signals (EINTR).
            Otherwise they mean the socket has been closed. */
            if (errno == EINTR) {
                continue;
            } else {
                ModelicaFormatError("MDDTCPIPSocket.h: write(..) failed (%s).\n",
                                    strerror(errno));
            }
        }

        /* Update position by the number of bytes that were sent. */
        sent += amt;
    }
    return 1;
}

/** Send data via TCP/IP socket.
 * @param p_tcpip pointer address to the tcpip socket data structure
 * @param p_package pointer to the SerialPackager
 * @param dataSize size of message to be sent in byte
 * @return returns 1
 */
int MDD_TCPIPClient_SendP(void *p_tcpip, void *p_package, int dataSize) {
    return MDD_TCPIPClient_Send(p_tcpip, MDD_SerialPackagerGetData(p_package), dataSize);
}

/** Read data from TCP/IP socket.
 *
 * @note No Modelica interface for this function, yet.
 *
 * @param p_tcpip pointer address to the tcpip socket data structure
 * @param recvbuflen length of message buffer
 * @return pointer to the message buffer
 */
const char * MDD_TCPIPClient_Read(void *p_tcpip, int recvbuflen) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)p_tcpip;
    ssize_t nread;
    char *tcpBuf = ModelicaAllocateString(recvbuflen);

    nread = read(tcpip->sfd, tcpBuf, recvbuflen);
    if (nread == -1) {
        ModelicaFormatError("MDDTCPIPSocket.h: read(..) failed (%s).\n",
                            strerror(errno));
    } else { /* Success */
        return (const char *)tcpBuf;
    }

    return "";
}

/** Read data from TCP/IP socket.
 *
 * @param p_tcpip pointer address to the tcpip socket data structure
 * @param p_package pointer to the SerialPackager
 * @param recvbuflen length of message buffer
 */
void MDD_TCPIPClient_ReadP(void *p_tcpip, void *p_package, int recvbuflen) {
    MDDTCPIPSocket *tcpip = (MDDTCPIPSocket *)p_tcpip;
    ssize_t nread;
    int rc;
    char *tcpBuf = (char *)malloc(recvbuflen);

    nread = read(tcpip->sfd, tcpBuf, recvbuflen);
    if (nread == -1) {
        ModelicaFormatError("MDDTCPIPSocket.h: read(..) failed (%s).\n",
                            strerror(errno));
    }
    rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, tcpBuf, nread);
    free(tcpBuf);
    if (rc) {
        ModelicaError("MDDTCPIPSocket.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
    }
}

#else

#error "Modelica_DeviceDrivers: No support of TCP/IP Socket for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDTCPIPSocket_H_ */
