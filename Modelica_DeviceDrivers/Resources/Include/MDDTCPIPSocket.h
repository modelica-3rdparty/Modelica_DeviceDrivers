/** TCP/IP socket support (header-only library).
 *
 * @file
 * @author Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @since 2015-04-18
 * @copyright Modelica License 2
 *
 */

#ifndef MDDTCPIPSocket_H_
#define MDDTCPIPSocket_H_

#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__MINGW32__)

#if !defined(ITI_COMP_SIM)

#include <ws2tcpip.h>
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
            char port_str[20];

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
                    ModelicaFormatError("MDDTCPIPSocket.h: socket failed with error: %ld\n", WSAGetLastError());
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
    int rc = EXIT_SUCCESS;
    if (tcpip && *tcpip) {
        rc = send((*tcpip)->SocketID, data, dataSize, 0);
        if (rc == SOCKET_ERROR) {
            ModelicaFormatMessage("MDDTCPIPSocket.h: send failed with error: %d\n", WSAGetLastError());
            rc = EXIT_FAILURE;
        }
    }
    return rc;
}

DllExport const char * MDD_TCPIPClient_Read(void * p_tcpip, int recvbuflen) {
    MDDTCPIPSocket ** tcpip = (MDDTCPIPSocket **) p_tcpip;
    if (tcpip && *tcpip) {
        char* recvbuf = ModelicaAllocateString(recvbuflen);
        int rc = recv((*tcpip)->SocketID, recvbuf, recvbuflen, 0);
        return recvbuf;
    }
    return "";
}

#endif /* !defined(ITI_COMP_SIM) */

#else

#error "Modelica_DeviceDrivers: No support of TCP/IP Socket for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDTCPIPSocket_H_ */
