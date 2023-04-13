/** TCP/IP server support (header-only library).
*
* @file
* @author bernhard-thiele
* @since 2019-08-01
* @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
*
*/

#ifndef MDDTCPIPSOCKETSERVER_H_
#define MDDTCPIPSOCKETSERVER_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

#if defined(_MSC_VER) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif

#include <ws2tcpip.h>
#include <stdio.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"

#pragma comment( lib, "Ws2_32.lib" )


typedef struct MDDTCPIPServer_s MDDTCPIPServer;

struct MDDTCPIPServer_s {
  SOCKET listenSocket;
  int maxClients;
  SOCKET* clientSockets; /**< array of clients with dimension maxClients */
  int* nRecvBytes; /**< array of number of received bytes for each client socket */
  int* recvbufslen; /**< array of receive buffer length for each client socket  */
  char** recvbufs; /**< array of receive buffer for each client socket  */
  int runAcceptingThread;
  HANDLE hThread;
  CRITICAL_SECTION tcpipLock;
};

DllExport void MDD_TCPIPServer_Destructor(void * p_tcpip);


DWORD WINAPI MDD_TCPIPServer_acceptingThread(void * p_tcpip) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    SOCKET* clientSockets = (SOCKET*)calloc(tcpip->maxClients, sizeof(SOCKET));
    int maxClients = 0;
    int wsaerror = 0;
    int isFirstLoop = 1;

    ModelicaFormatMessage("MDDTCPIPSocketServer.h: Started thread MDD_TCPIPServer_acceptingThread.\n");
    while (tcpip->runAcceptingThread == 1) {
        int i;
        // Accept a client socket
        EnterCriticalSection(&tcpip->tcpipLock);
        maxClients = tcpip->maxClients;
        for (i = 0; i < maxClients; ++i)
            clientSockets[i] = tcpip->clientSockets[i];
        LeaveCriticalSection(&tcpip->tcpipLock);

        for (i = 0; i < maxClients; ++i) {
            if (tcpip->runAcceptingThread != 1) {
                free(clientSockets);
                ModelicaFormatMessage("MDDTCPIPSocketServer.h: Exiting thread MDD_TCPIPServer_acceptingThread.\n");
                ExitThread(0);
            }
            if (clientSockets[i] == INVALID_SOCKET) {
                clientSockets[i] = accept(tcpip->listenSocket, NULL, NULL);
                while (clientSockets[i] == INVALID_SOCKET && WSAGetLastError() == WSAEWOULDBLOCK) {
                    if (tcpip->runAcceptingThread != 1) {
                        free(clientSockets);
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h: Exiting thread MDD_TCPIPServer_acceptingThread.\n");
                        ExitThread(0);
                    }
                    clientSockets[i] = accept(tcpip->listenSocket, NULL, NULL);
                    Sleep(10);
                }
                if (clientSockets[i] == INVALID_SOCKET) {
                    wsaerror = WSAGetLastError();
                    if (wsaerror == WSAENOTSOCK) {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: accept failed for client %d with error %d (WSAENOTSOCK) - Probably the MDD_TCPIPServer object destructor was called before\n", __LINE__, i + 1, wsaerror);
                    }
                    else {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: accept failed for client %d with error: %d\n", __LINE__, i + 1, WSAGetLastError());
                        closesocket(tcpip->listenSocket);
                        WSACleanup();
                    }
                    free(clientSockets);
                    ModelicaFormatMessage("MDDTCPIPSocketServer.h: Exiting thread MDD_TCPIPServer_acceptingThread.\n");
                    ExitThread(1);
                }
                EnterCriticalSection(&tcpip->tcpipLock);
                tcpip->clientSockets[i] = clientSockets[i];
                LeaveCriticalSection(&tcpip->tcpipLock);
                ModelicaFormatMessage("MDDTCPIPSocketServer.h: Server accepted a connecting client at index %d\n", i + 1);
            }
        }
        if (isFirstLoop) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h: All %d client connection slots used, periodically checking whether occupied slots get freed\n", maxClients);
            isFirstLoop = 0;
        }
        Sleep(1000);
    }
    free(clientSockets);
    ModelicaFormatMessage("MDDTCPIPSocketServer.h: MDD_TCPIPServer_acceptingThread END.\n");
    return 0;
}

/** Create a TCPIP server socket.
 * @param serverport Port at which the server listens.
 * @param maxClients Maximum number of clients that can connect simultaneously
 * @param useNonblockingMode If useNonblockingMode != 0, configure socket for non-blocking mode, otherwise blocking is enabled
 */
DllExport void * MDD_TCPIPServer_Constructor(int serverport, int maxClients, int useNonblockingMode) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*) malloc(sizeof(MDDTCPIPServer));
    WSADATA wsaData;
    int iResult;
    int i;
    struct addrinfo *result = NULL;
    struct addrinfo hints;
    DWORD threadId;
    char serverport_str[10];
    u_long iMode = useNonblockingMode != 0 ? 1 : 0; // != 0 => Nonblocking mode

    tcpip->maxClients = maxClients;
    tcpip->clientSockets = (SOCKET*)calloc(tcpip->maxClients, sizeof(SOCKET));
    tcpip->nRecvBytes = (int*)calloc(tcpip->maxClients, sizeof(int));
    tcpip->recvbufslen = (int*)calloc(tcpip->maxClients, sizeof(int));
    tcpip->recvbufs = (char**)calloc(tcpip->maxClients, sizeof(char*));
    for (i = 0; i < tcpip->maxClients; ++i) {
        tcpip->clientSockets[i] = INVALID_SOCKET;
        tcpip->nRecvBytes[i] = 0;
        tcpip->recvbufs[i] = NULL;
    }
    tcpip->listenSocket = INVALID_SOCKET;
    tcpip->runAcceptingThread = 1;

    // Initialize Winsock
    iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
    if (iResult != 0) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: WSAStartup failed with error: %d\n", __LINE__, iResult);
    }

    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    // Resolve the server address and port
    if (serverport > 65535) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: given server port number %d higher than allowable for IPv4 (maximum 65535)", __LINE__, serverport);
    }
    _snprintf(serverport_str, 9, "%d", serverport);
    iResult = getaddrinfo(NULL, serverport_str, &hints, &result);
    if ( iResult != 0 ) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: getaddrinfo failed with error: %d\n", __LINE__, iResult);
    }

    // Create a SOCKET for connecting to server
    tcpip->listenSocket = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
    if (tcpip->listenSocket == INVALID_SOCKET) {
        freeaddrinfo(result);
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: socket failed with error: %d\n", __LINE__, WSAGetLastError());
    }

    // Non-blocking vs blocking mode
    iResult = ioctlsocket(tcpip->listenSocket, FIONBIO, &iMode);
    if (iResult != NO_ERROR) {
        freeaddrinfo(result);
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: ioctlsocket failed with error: %d\n", __LINE__, iResult);
    }

    // Setup the TCP listening socket
    iResult = bind(tcpip->listenSocket, result->ai_addr, (int)result->ai_addrlen);
    if (iResult == SOCKET_ERROR) {
        freeaddrinfo(result);
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: bind failed with error: %d\n", __LINE__, WSAGetLastError());
    }

    freeaddrinfo(result);

    iResult = listen(tcpip->listenSocket, SOMAXCONN);
    if (iResult == SOCKET_ERROR) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: listen failed with error: %d\n", __LINE__, WSAGetLastError());
    }
    ModelicaFormatMessage("MDDTCPIPSocketServer.h: TCP/IP server in %s mode configured for maximal %d clients listening at port %d.\n",
        useNonblockingMode ? "non-blocking" : "blocking", tcpip->maxClients, serverport);

    InitializeCriticalSection(&tcpip->tcpipLock);
    tcpip->hThread = CreateThread(0, 1024, MDD_TCPIPServer_acceptingThread, tcpip, 0, &threadId);
    if (!tcpip->hThread) {
        DWORD dw = GetLastError();
        tcpip->runAcceptingThread = 0;
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Error creating TCP/IP client receiving thread: %lu\n", __LINE__, dw);
    }
    return (void *) tcpip;
}


DllExport void MDD_TCPIPServer_Destructor(void * p_tcpip) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*) p_tcpip;
    /* ModelicaFormatMessage("MDDTCPIPSocketServer.h: MDD_TCPIPServer_Destructor\n"); */
    if (tcpip) {
        int i;
        tcpip->runAcceptingThread = 0;
        for (i = 0; i < tcpip->maxClients; ++i) {
            if (tcpip->clientSockets[i] != INVALID_SOCKET) {
                shutdown(tcpip->clientSockets[i], SD_SEND);
                closesocket(tcpip->clientSockets[i]);
            }
        }
        if (tcpip->listenSocket != INVALID_SOCKET) {
            closesocket(tcpip->listenSocket);
        }
        if (tcpip->hThread) {
            DWORD exitCode = 1;
            WaitForSingleObject(tcpip->hThread, 1000);
            if (GetExitCodeThread(tcpip->hThread, &exitCode) && exitCode == STILL_ACTIVE) {
                TerminateThread(tcpip->hThread, 1);
            }
            CloseHandle(tcpip->hThread);
            DeleteCriticalSection(&tcpip->tcpipLock);
        }

        free(tcpip->clientSockets);
        free(tcpip->nRecvBytes);
        for (i = 0; i < tcpip->maxClients; ++i) {
            if (tcpip->recvbufs[i]) {
                free(tcpip->recvbufs[i]);
                tcpip->recvbufs[i] = NULL;
            }
        }
        free(tcpip->recvbufs);
        free(tcpip->recvbufslen);
        free(tcpip);
    }
    WSACleanup();
}

/** Check for connected clients. */
DllExport void MDD_TCPIPServer_AcceptedClients(void * p_tcpip, int* acceptedClients, size_t dim) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int i;
    if (dim != tcpip->maxClients) {
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Size of acceptedClients != %d\n", __LINE__, tcpip->maxClients);
    }
    EnterCriticalSection(&tcpip->tcpipLock);
    for (i = 0; i < tcpip->maxClients; ++i) {
        acceptedClients[i] = (tcpip->clientSockets[i] != INVALID_SOCKET) ? 1 : 0;
    }
    LeaveCriticalSection(&tcpip->tcpipLock);
}

/** Check if a client at the specified index has been accepted by the server. */
DllExport int MDD_TCPIPServer_HasAcceptedClient(void * p_tcpip, int clientIndex) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    int ret = 0;
    EnterCriticalSection(&tcpip->tcpipLock);
    ret = (tcpip->clientSockets[clientIndexC] != INVALID_SOCKET) ? 1 : 0;
    LeaveCriticalSection(&tcpip->tcpipLock);
    return ret;
}

/** Read data via TCP/IP client socket.
*
* @FIXME Adapt to MDD_TCPIPServer_ReadP. Untested function. Lot's of code duplication with MDD_TCPIPServer_ReadP.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @param [in] recvbuflen Size of the receiving buffer
* @param [out] nRecvBytes If 0 it means that no new data is available.
* @return Pointer to the data buffer. If no new data is available, an empty string is returned.
*/
DllExport const char* MDD_TCPIPServer_Read(void * p_tcpip, int clientIndex, int recvbuflen, int* nRecvBytes) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    SOCKET clientSocket = tcpip->clientSockets[clientIndexC];
    int rc = 0;
    char* stringbuf = NULL;
    char* pb = NULL;
    if (tcpip->recvbufs[clientIndexC] == NULL) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        tcpip->recvbufs[clientIndexC] = (char*)calloc(recvbuflen, sizeof(char));
        if (!tcpip->recvbufs[clientIndexC]) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: calloc failed.\n", __LINE__);
        }
    }
    else if (tcpip->recvbufslen[clientIndexC] != recvbuflen) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        pb = (char*)realloc(pb, recvbuflen*sizeof(char)); // FIXME see example http://www.cplusplus.com/reference/cstdlib/realloc/
        if (!pb) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: realloc failed.\n", __LINE__);
        }
        tcpip->recvbufs[clientIndexC] = pb;
    }
    memset(tcpip->recvbufs[clientIndexC], 0, tcpip->recvbufslen[clientIndexC]);

    if (clientSocket == INVALID_SOCKET) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to recv from invalid socket at client index %d. Skipping...\n", __LINE__, clientIndex);
        *nRecvBytes = 0;
    }
    else {
        *nRecvBytes = recv(clientSocket, tcpip->recvbufs[clientIndexC], tcpip->recvbufslen[clientIndexC], 0);
        if (*nRecvBytes > 0) {
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Got %d bytes reading: %s\n", __LINE__, *nRecvBytes, tcpip->recvbufs[clientIndexC]); */
            stringbuf = ModelicaAllocateStringWithErrorReturn(*nRecvBytes);
            if (stringbuf) {
                memcpy(stringbuf, tcpip->recvbufs[clientIndexC], *nRecvBytes);
                stringbuf[*nRecvBytes] = '\0';
            }
            else {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: ModelicaAllocateStringWithErrorReturn failed\n", __LINE__);
            }
        }
        else if (*nRecvBytes == 0) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h: Client at index %d is closing the connection\n", clientIndex);
            EnterCriticalSection(&tcpip->tcpipLock);
            rc = closesocket(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: closesocket() failed with %d. \n", __LINE__, WSAGetLastError());
            }
            tcpip->clientSockets[clientIndexC] = INVALID_SOCKET;
            LeaveCriticalSection(&tcpip->tcpipLock);
        }
        else if (WSAGetLastError() == WSAEWOULDBLOCK) {
            // Just skip and check at next sample point
            *nRecvBytes = 0;
        }
        else if (WSAGetLastError() == WSAECONNRESET) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: recv() failed with error 10054 (WSAECONNRESET) at client index %d. Close socket and continue ...\n", __LINE__, clientIndex);
            EnterCriticalSection(&tcpip->tcpipLock);
            rc = closesocket(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: closesocket() failed with %d. \n", __LINE__, WSAGetLastError());
            }
            tcpip->clientSockets[clientIndexC] = INVALID_SOCKET;
            LeaveCriticalSection(&tcpip->tcpipLock);
            *nRecvBytes = 0;
        }
        else {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: recv() failed with error: %d\n", __LINE__, WSAGetLastError());
        }
    }

    tcpip->nRecvBytes[clientIndexC] = *nRecvBytes;
    return stringbuf ? (const char*)stringbuf : "";
}


/** Read data via TCP/IP client socket into SerialPackager package.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [inout] p_package pointer to the SerialPackager
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @param [in] recvbuflen Size of the receiving buffer
* @param [out] nRecvBytes If 0 it means that no new data is available.
*/
DllExport void MDD_TCPIPServer_ReadP(void * p_tcpip, void* p_package, int clientIndex, int recvbuflen, int* nRecvBytes) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    SOCKET clientSocket = tcpip->clientSockets[clientIndexC];
    int rc = 0;
    char* pb = NULL;
    if (tcpip->recvbufs[clientIndexC] == NULL) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        tcpip->recvbufs[clientIndexC] = (char*)calloc(recvbuflen, sizeof(char));
        if (!tcpip->recvbufs[clientIndexC]) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: calloc failed.\n", __LINE__);
        }
    }
    else if (tcpip->recvbufslen[clientIndexC] != recvbuflen) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        pb = (char*)realloc(pb, recvbuflen*sizeof(char)); // FIXME see example http://www.cplusplus.com/reference/cstdlib/realloc/
        if (!pb) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: realloc failed.\n", __LINE__);
        }
        tcpip->recvbufs[clientIndexC] = pb;
    }
    memset(tcpip->recvbufs[clientIndexC], 0, tcpip->recvbufslen[clientIndexC]);

    if (clientSocket == INVALID_SOCKET) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to recv from invalid socket at client index %d. Skipping ...\n", __LINE__, clientIndex);
        *nRecvBytes = 0;
    }
    else {
        *nRecvBytes = recv(clientSocket, tcpip->recvbufs[clientIndexC], tcpip->recvbufslen[clientIndexC], 0);
        if (*nRecvBytes > 0) {
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Got %d bytes reading: %s\n", *nRecvBytes, __LINE__, tcpip->recvbuf); */
            rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, tcpip->recvbufs[clientIndexC], *nRecvBytes);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_ReadP failed. Buffer overflow.\n", __LINE__);
            }
        }
        else if (*nRecvBytes == 0) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h: Client at index %d is closing the connection.\n", clientIndex);
            EnterCriticalSection(&tcpip->tcpipLock);
            rc = closesocket(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: closesocket() failed with %d. \n", __LINE__, WSAGetLastError());
            }
            tcpip->clientSockets[clientIndexC] = INVALID_SOCKET;
            LeaveCriticalSection(&tcpip->tcpipLock);
        }
        else if (WSAGetLastError() == WSAEWOULDBLOCK) {
            // Just skip and check at next sample point
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_ReadP WSAEWOULDBLOCK\n", __LINE__); */
            *nRecvBytes = 0;
        }
        else if (WSAGetLastError() == WSAECONNRESET) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: recv() failed with error 10054 (WSAECONNRESET) at client index %d. Close socket and continue ...\n", __LINE__, clientIndex);
            EnterCriticalSection(&tcpip->tcpipLock);
            rc = closesocket(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: closesocket() failed with %d. \n", __LINE__, WSAGetLastError());
            }
            tcpip->clientSockets[clientIndexC] = INVALID_SOCKET;
            LeaveCriticalSection(&tcpip->tcpipLock);
            *nRecvBytes = 0;
        }
        else {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: recv() failed with error: %d\n", __LINE__, WSAGetLastError());
        }
    }

    tcpip->nRecvBytes[clientIndexC] = *nRecvBytes;
}

/** Send data via TCP/IP client socket.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [in] data Pointer to data that should be sent.
* @param [in] dataSize Size of data to be sent in byte.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @return On success, return the number of bytes sent, 0 if operation would block, -1 on non-fatal error.
*/
DllExport int MDD_TCPIPServer_Send(void* p_tcpip, const char* data, int dataSize, int clientIndex) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    SOCKET clientSocket = tcpip->clientSockets[clientIndexC];
    int iSendResult = SOCKET_ERROR;
    int retval = -1;
    int wsaLastError = 0;
    int rc = 0;

    if (clientSocket == INVALID_SOCKET) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to send to invalid socket at client index %d. Skipping ...\n", __LINE__, clientIndex);
        retval = -1;
    }
    else {
        /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Send %d bytes to client at index %d. data: %s\n", __LINE__, dataSize, clientIndex, data); */
        iSendResult = send(clientSocket, data, dataSize, 0);
        if (iSendResult == SOCKET_ERROR) {
            wsaLastError = WSAGetLastError();
            if (wsaLastError == WSAEWOULDBLOCK) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Cannot send because the socket at client index %d is marked as nonblocking and the requested operation would block.\n", __LINE__, clientIndex);
                retval = 0;
            }
            else if (wsaLastError == WSAESHUTDOWN || wsaLastError == WSAECONNRESET) {
                if (wsaLastError == WSAESHUTDOWN)
                    ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: send failed with error %d (WSAESHUTDOWN) at client index %d. Close socket and continue ...\n", __LINE__, WSAESHUTDOWN, clientIndex);
                if (wsaLastError == WSAECONNRESET)
                    ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: send failed with error %d (WSAECONNRESET) at client index %d. Close socket and continue ...\n", __LINE__, WSAECONNRESET, clientIndex);
                EnterCriticalSection(&tcpip->tcpipLock);
                rc = closesocket(tcpip->clientSockets[clientIndexC]);
                if (rc) {
                    ModelicaFormatError("MDDTCPIPSocketServer.h:%d: closesocket() failed with %d.\n", __LINE__, WSAGetLastError());
                }
                tcpip->clientSockets[clientIndexC] = INVALID_SOCKET;
                LeaveCriticalSection(&tcpip->tcpipLock);
                retval = -1;
            }
            else {
                closesocket(tcpip->clientSockets[clientIndexC]);
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: send failed for client at index %d with error: %d\n", __LINE__, clientIndex, wsaLastError);
            }
        }
        else {
            retval = iSendResult;
        }
    }
    return retval;
}

/** Send data via TCP/IP client socket from SerialPackager package.
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [inout] p_package pointer to the SerialPackager
* @param [in] dataSize Size of data to be sent in byte.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @return On success, return the number of bytes sent, 0 if operation would block, -1 on non-fatal error.
*/
DllExport int MDD_TCPIPServer_SendP(void* p_tcpip, void* p_package, int dataSize, int clientIndex) {
    return MDD_TCPIPServer_Send(p_tcpip, MDD_SerialPackagerGetData(p_package), dataSize, clientIndex);
}


#elif defined(__linux__) || defined(__CYGWIN__)

#include <stdio.h>
#include <stdlib.h>
#include <string.h> /* memset() */
#include <errno.h>
#include <unistd.h> /* close() */
#include <sys/types.h>
#include <sys/socket.h>
/* #include <netinet/in.h> Not needed. Probably included in netdb?*/
#include <netdb.h>
#include <fcntl.h> /* fcntl() */
#include <poll.h> /* poll() */
#include <pthread.h>
#include "../src/include/CompatibilityDefs.h"
#include "../src/include/util.h"


typedef struct MDDTCPIPServer_s MDDTCPIPServer;

struct MDDTCPIPServer_s {
  int listenSocket;
  int maxClients;
  int* clientSockets; /**< array of clients with dimension maxClients */
  int* nRecvBytes; /**< array of number of received bytes for each client socket */
  int* recvbufslen; /**< array of receive buffer length for each client socket  */
  char** recvbufs; /**< array of receive buffer for each client socket  */
  int runAcceptingThread;
  pthread_t hThread;
  pthread_mutex_t tcpipLock;
};

DllExport void MDD_TCPIPServer_Destructor(void * p_tcpip);


void * MDD_TCPIPServer_acceptingThread(void * p_tcpip) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int* clientSockets = (int*)calloc(tcpip->maxClients, sizeof(int));
    struct pollfd sock_poll;
    int maxClients = tcpip->maxClients;
    int isFirstLoop = 1;
    int i = 0, j = 0;
    int ready = 0;

    ModelicaFormatMessage("MDDTCPIPSocketServer.h: Started thread for accepting clients.\n");

    i = -1;
    while (tcpip->runAcceptingThread == 1) {
        if (i < maxClients) {
            i++;
        }
        else {
            if (isFirstLoop) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h: All %d client connection slots used, periodically checking whether occupied slots get freed\n", maxClients);
                isFirstLoop = 0;
            }
            i = 0;
            MDD_msleep(1000);
        }

        pthread_mutex_lock(&(tcpip->tcpipLock));
        for (j = 0; j < maxClients; ++j)
            clientSockets[j] = tcpip->clientSockets[j];
        pthread_mutex_unlock(&(tcpip->tcpipLock));

        while (tcpip->runAcceptingThread == 1 && clientSockets[i] == -1) {
            sock_poll.fd = tcpip->listenSocket;
            sock_poll.events = POLLIN;
            ready = poll(&sock_poll, 1, 100);
            switch (ready) {
                case -1:
                    ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: poll() failed (%s).\n", __LINE__, strerror(errno));
                    break;
                case 0: /* no event. Just check if tcpip->runAcceptingThread still true and go on */
                    break;
                case 1: /* event */
                    if (sock_poll.revents & POLLIN) {
                        clientSockets[i] = accept(tcpip->listenSocket, NULL, NULL);
                        if (clientSockets[i] == -1) {
                            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: accept() would block after poll() (unexpected) (client index %d). Continue polling.\n", __LINE__, i + 1);
                                continue;
                            }
                            else if (errno == ENOTSOCK) {
                                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: accept() failed (%s) (client index %d). Probably the MDD_TCPIPServer object destructor was called before.\n", __LINE__, strerror(errno), i + 1);
                                MDD_msleep(100);
                                continue;
                            }
                            else {
                                free(clientSockets);
                                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Error: accept() failed (%s) (client index %d)!\n", __LINE__, strerror(errno), i + 1);
                                pthread_exit(NULL); /* Unreachable code if ModelicaFormatError() works properly */
                            }
                        }
                        pthread_mutex_lock(&(tcpip->tcpipLock));
                        tcpip->clientSockets[i] = clientSockets[i];
                        pthread_mutex_unlock(&(tcpip->tcpipLock));
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h: Server accepted a connecting client at index %d\n", i + 1);
                    }
                    else if (sock_poll.revents & POLLNVAL) {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h: poll() event POLLNVAL (socket not open). Probably because server socket was orderly closed by destructor.\n");
                        MDD_msleep(100);
                        continue;
                    }
                    else if (sock_poll.revents & POLLPRI) {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: poll() event POLLPRI  (unexpected)!?\n", __LINE__);
                        MDD_msleep(100);
                        continue;
                    }
                    else if (sock_poll.revents & POLLHUP) {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: poll() event POLLHUP (unexpected)!?\n", __LINE__);
                        MDD_msleep(100);
                        continue;
                    }
                    else if (sock_poll.revents & POLLOUT) {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: poll() event POLLOUT (unexpected)!?\n", __LINE__);
                        MDD_msleep(100);
                        continue;
                    }
                    else if (sock_poll.revents & POLLERR) {
                        free(clientSockets);
                        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Error: poll() event POLLERR!\n", __LINE__);
                        pthread_exit(NULL); /* Unreachable code if ModelicaFormatError() works properly */
                    }
                    else {
                        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Unrecognized poll() event (value=%#x). Ignore and continue polling.\n", __LINE__, sock_poll.revents);
                        MDD_msleep(100);
                        continue;
                    }
                    break;
                default:
                    free(clientSockets);
                    ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Uups. poll() returned (impossible?!) value %d.\n",  __LINE__, ready);
                    pthread_exit(NULL); /* Unreachable code if ModelicaFormatError() works properly */
            }
        }
    }
    free(clientSockets);
    ModelicaFormatMessage("MDDTCPIPSocketServer.h: Stopped thread for accepting clients.\n");
    return NULL;
}

/** Create a TCPIP server socket.
 * @param serverport Port at which the server listens.
 * @param maxClients Maximum number of clients that can connect simultaneously
 * @param useNonblockingMode If useNonblockingMode != 0, configure socket for non-blocking mode, otherwise blocking is enabled
 */
DllExport void * MDD_TCPIPServer_Constructor(int serverport, int maxClients, int useNonblockingMode) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*) malloc(sizeof(MDDTCPIPServer));
    struct addrinfo *result = NULL, *rp = NULL;
    struct addrinfo hints;
    char serverport_str[10];
    long save_fd = 0;
    int iResult = 0;
    int err = 0, i =0;


    tcpip->maxClients = maxClients;
    tcpip->clientSockets = (int*)calloc(tcpip->maxClients, sizeof(int));
    tcpip->nRecvBytes = (int*)calloc(tcpip->maxClients, sizeof(int));
    tcpip->recvbufslen = (int*)calloc(tcpip->maxClients, sizeof(int));
    tcpip->recvbufs = (char**)calloc(tcpip->maxClients, sizeof(char*));
    for (i = 0; i < tcpip->maxClients; ++i) {
        tcpip->clientSockets[i] = -1; /* Denote invalid socket as value -1 (the error return value of socket(...)) */
        tcpip->nRecvBytes[i] = 0;
        tcpip->recvbufs[i] = NULL;
    }
    tcpip->listenSocket = -1; /* Denote invalid socket as value -1 (the error return value of socket(...)) */
    tcpip->runAcceptingThread = 1;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_UNSPEC;    /* Allow IPv4 or IPv6 */
    hints.ai_socktype = SOCK_STREAM; /* TCP/IP socket */
    hints.ai_protocol = IPPROTO_TCP; /* TCP/IP protocol */
    hints.ai_flags = AI_PASSIVE;

    // Resolve the server address and port
    if (serverport > 65535) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: given server port number %d higher than allowable for IPv4 (maximum 65535)", __LINE__, serverport);
    }
    snprintf(serverport_str, 9, "%d", serverport);
    iResult = getaddrinfo(NULL, serverport_str, &hints, &result);
    if ( iResult != 0 ) {
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: getaddrinfo failed (%s)\n", __LINE__, gai_strerror(iResult));
    }

    /* getaddrinfo() returns a list of address structures.
       Attempt to create a socket until one succeeds */
    for (rp = result; rp != NULL; rp = rp->ai_next) {
        tcpip->listenSocket = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (tcpip->listenSocket == -1) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: socket failed (%s). \n", __LINE__, strerror(errno));
        }
        else {
            break;
        }
    }
    if (rp == NULL) {  /* No address succeeded */
        freeaddrinfo(result);
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Unable to create server listening socket.\n", __LINE__);
    }

    // Non-blocking vs blocking mode
    if (useNonblockingMode) {
        save_fd = fcntl(tcpip->listenSocket, F_GETFL );
        if (save_fd < 0) {
            err = errno;
            freeaddrinfo(result);
            MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: fcntl failed (%s).\n", __LINE__, strerror(err));
        }
        save_fd |= O_NONBLOCK;
        iResult = fcntl(tcpip->listenSocket, F_SETFL, save_fd);
        if (iResult == -1) {
            err = errno;
            freeaddrinfo(result);
            MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: fcntl failed (%s).\n", __LINE__, strerror(err));
        }
    }

    // Setup the TCP listening socket
    iResult = bind(tcpip->listenSocket, result->ai_addr, (int)result->ai_addrlen);
    if (iResult == -1) {
        err = errno;
        freeaddrinfo(result);
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: bind failed (%s).\n", __LINE__, strerror(err));
    }

    freeaddrinfo(result);

    iResult = listen(tcpip->listenSocket, SOMAXCONN);
    if (iResult == -1) {
        err = errno;
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: listen failed (%s)\n", __LINE__, strerror(err));
    }
    ModelicaFormatMessage("MDDTCPIPSocketServer.h: TCP/IP server in %s mode configured for maximal %d clients listening at port %d.\n",
        useNonblockingMode ? "non-blocking" : "blocking", tcpip->maxClients, serverport);

    iResult = pthread_mutex_init(&(tcpip->tcpipLock), NULL); /* Init mutex with defaults */
    if (iResult != 0) {
        err = errno;
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: pthread_mutex_init failed (%s).\n", __LINE__, strerror(err));
    }

    iResult = pthread_create(&tcpip->hThread, 0, &MDD_TCPIPServer_acceptingThread, tcpip);
    if (iResult) {
        tcpip->runAcceptingThread = 0;
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: pthread_create failed (%s).\n", __LINE__, strerror(iResult));
    }

    return (void *) tcpip;
}


DllExport void MDD_TCPIPServer_Destructor(void * p_tcpip) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*) p_tcpip;
    struct timespec ts;
    int i = 0;


    /* ModelicaFormatMessage("MDDTCPIPSocketServer.h: MDD_TCPIPServer_Destructor\n"); */
    if (tcpip) {
        tcpip->runAcceptingThread = 0;
        for (i = 0; i < tcpip->maxClients; ++i) {
            if (tcpip->clientSockets[i] != -1) {
                shutdown(tcpip->clientSockets[i], SHUT_WR);
                if (close(tcpip->clientSockets[i]) == -1) {
                    ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: close socket failed for client %d (%s)\n", __LINE__, i + 1, strerror(errno));
                }
            }
        }
        if (tcpip->listenSocket != -1) {
            if (close(tcpip->listenSocket) == -1) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: close socket failed for server (%s)\n", __LINE__, strerror(errno));
            }
        }


        if (tcpip->hThread) {
            tcpip->runAcceptingThread = 0;
            pthread_join(tcpip->hThread, NULL);
            /* Due to the thread implementation, this should end the thread cleanly within bounded time.
               Alternatively, one could try s.th. with  pthread_cancel(), pthread_detach(), but this seems less clean */
        }
        if (pthread_mutex_destroy(&(tcpip->tcpipLock)) != 0) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: pthread_mutex_destroy failed (%s).\n", __LINE__, strerror(errno));
        }

        free(tcpip->clientSockets);
        free(tcpip->nRecvBytes);
        for (i = 0; i < tcpip->maxClients; ++i) {
            if (tcpip->recvbufs[i]) {
                free(tcpip->recvbufs[i]);
                tcpip->recvbufs[i] = NULL;
            }
        }
        free(tcpip->recvbufs);
        free(tcpip->recvbufslen);
        free(tcpip);
    }
}

/** Check for connected clients. */
DllExport void MDD_TCPIPServer_AcceptedClients(void * p_tcpip, int* acceptedClients, size_t dim) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int i = 0;

    if (dim != tcpip->maxClients) {
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Size of acceptedClients != %d\n", __LINE__, tcpip->maxClients);
    }

    pthread_mutex_lock(&(tcpip->tcpipLock));
    for (i = 0; i < tcpip->maxClients; ++i) {
        acceptedClients[i] = (tcpip->clientSockets[i] != -1) ? 1 : 0;
    }
    pthread_mutex_unlock(&(tcpip->tcpipLock));
}

/** Check if a client at the specified index has been accepted by the server. */
DllExport int MDD_TCPIPServer_HasAcceptedClient(void * p_tcpip, int clientIndex) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    int ret = 0;
    pthread_mutex_lock(&(tcpip->tcpipLock));
    ret = (tcpip->clientSockets[clientIndexC] != -1) ? 1 : 0;
    pthread_mutex_unlock(&(tcpip->tcpipLock));
    return ret;
}

/** Read data via TCP/IP client socket.
*
* @FIXME Adapt to MDD_TCPIPServer_ReadP. Untested function. Lot's of code duplication with MDD_TCPIPServer_ReadP.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @param [in] recvbuflen Size of the receiving buffer
* @param [out] nRecvBytes If 0 it means that no new data is available.
* @return Pointer to the data buffer. If no new data is available, an empty string is returned.
*/
DllExport const char* MDD_TCPIPServer_Read(void * p_tcpip, int clientIndex, int recvbuflen, int* nRecvBytes) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    int clientSocket = tcpip->clientSockets[clientIndexC];
    int rc = 0;
    char* stringbuf = NULL;
    char* pb = NULL;

    if (tcpip->recvbufs[clientIndexC] == NULL) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        tcpip->recvbufs[clientIndexC] = (char*)calloc(recvbuflen, sizeof(char));
        if (!tcpip->recvbufs[clientIndexC]) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: calloc failed (%s).\n", __LINE__, strerror(errno));
        }
    }
    else if (tcpip->recvbufslen[clientIndexC] != recvbuflen) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        pb = (char*)realloc(tcpip->recvbufs[clientIndexC], recvbuflen*sizeof(char));
        if (!pb) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: realloc failed (%s).\n", __LINE__, strerror(errno));
        }
        tcpip->recvbufs[clientIndexC] = pb;
    }
    memset(tcpip->recvbufs[clientIndexC], 0, tcpip->recvbufslen[clientIndexC]);

    if (clientSocket == -1) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to recv from invalid socket at client index %d. Skipping...\n", __LINE__, clientIndex);
        *nRecvBytes = 0;
    }
    else {
        *nRecvBytes = recv(clientSocket, tcpip->recvbufs[clientIndexC], tcpip->recvbufslen[clientIndexC], 0);
        if (*nRecvBytes > 0) {
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Got %d bytes reading: %s\n", __LINE__, *nRecvBytes, tcpip->recvbufs[clientIndexC]); */
            stringbuf = ModelicaAllocateStringWithErrorReturn(*nRecvBytes);
            if (stringbuf) {
                memcpy(stringbuf, tcpip->recvbufs[clientIndexC], *nRecvBytes);
                stringbuf[*nRecvBytes] = '\0';
            }
            else {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: ModelicaAllocateStringWithErrorReturn failed\n", __LINE__);
            }
        }
        else if (*nRecvBytes == 0) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h: Client at index %d is closing the connection\n", clientIndex);
            pthread_mutex_lock(&(tcpip->tcpipLock));
            rc = close(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: close socket failed for client %d (%s). \n", __LINE__, clientIndex, strerror(errno));
            }
            tcpip->clientSockets[clientIndexC] = -1;
            pthread_mutex_unlock(&(tcpip->tcpipLock));
        }
        else if (errno == EAGAIN || errno == EWOULDBLOCK) {
            // Just skip and check at next sample point
            *nRecvBytes = 0;
        }
        else if (errno == ECONNRESET) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: recv() failed with error ECONNRESET at client index %d. Close socket and continue ...\n", __LINE__, clientIndex);
            pthread_mutex_lock(&(tcpip->tcpipLock));
            rc = close(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: close socket failed for client %d (%s). \n", __LINE__, clientIndex, strerror(errno));
            }
            tcpip->clientSockets[clientIndexC] = -1;
            pthread_mutex_unlock(&(tcpip->tcpipLock));
            *nRecvBytes = 0;
        }
        else {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: recv failed for client %d (%s)\n", __LINE__, clientIndex, strerror(errno));
        }
    }

    tcpip->nRecvBytes[clientIndexC] = *nRecvBytes;
    return stringbuf ? (const char*)stringbuf : "";
}


/** Read data via TCP/IP client socket into SerialPackager package.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [inout] p_package pointer to the SerialPackager
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @param [in] recvbuflen Size of the receiving buffer
* @param [out] nRecvBytes If 0 it means that no new data is available.
*/
DllExport void MDD_TCPIPServer_ReadP(void * p_tcpip, void* p_package, int clientIndex, int recvbuflen, int* nRecvBytes) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    int clientSocket = tcpip->clientSockets[clientIndexC];
    int rc = 0;
    char* pb = NULL;
    if (tcpip->recvbufs[clientIndexC] == NULL) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        tcpip->recvbufs[clientIndexC] = (char*)calloc(recvbuflen, sizeof(char));
        if (!tcpip->recvbufs[clientIndexC]) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: calloc failed for client %d (%s).\n", __LINE__, clientIndex, strerror(errno));
        }
    }
    else if (tcpip->recvbufslen[clientIndexC] != recvbuflen) {
        tcpip->recvbufslen[clientIndexC] = recvbuflen;
        pb = (char*)realloc(tcpip->recvbufs[clientIndexC], recvbuflen*sizeof(char));
        if (!pb) {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: realloc failed for client %d (%s).\n", __LINE__, clientIndex, strerror(errno));
        }
        tcpip->recvbufs[clientIndexC] = pb;
    }
    memset(tcpip->recvbufs[clientIndexC], 0, tcpip->recvbufslen[clientIndexC]);

    if (clientSocket == -1) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to recv from invalid socket at client index %d. Skipping ...\n", __LINE__, clientIndex);
        *nRecvBytes = 0;
    }
    else {
        *nRecvBytes = recv(clientSocket, tcpip->recvbufs[clientIndexC], tcpip->recvbufslen[clientIndexC], 0);
        if (*nRecvBytes > 0) {
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Got %d bytes reading: %s\n", *nRecvBytes, __LINE__, tcpip->recvbuf); */
            rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, tcpip->recvbufs[clientIndexC], *nRecvBytes);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_ReadP failed for client %d. Buffer overflow.\n", __LINE__, clientIndex);
            }
        }
        else if (*nRecvBytes == 0) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h: Client at index %d is closing the connection.\n", clientIndex);
            pthread_mutex_lock(&(tcpip->tcpipLock));
            rc = close(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: close socket failed for client %d (%s).\n", __LINE__, clientIndex, strerror(errno));
            }
            tcpip->clientSockets[clientIndexC] = -1;
            pthread_mutex_unlock(&(tcpip->tcpipLock));
        }
        else if (errno == EAGAIN || errno == EWOULDBLOCK) {
            // Just skip and check at next sample point
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_ReadP WSAEWOULDBLOCK\n", __LINE__); */
            *nRecvBytes = 0;
        }
        else if (errno == ECONNRESET) {
            ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: recv() failed with error ECONNRESET at client index %d. Close socket and continue ...\n", __LINE__, clientIndex);
            pthread_mutex_lock(&(tcpip->tcpipLock));
            rc = close(tcpip->clientSockets[clientIndexC]);
            if (rc) {
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: close socket failed for client %d (%s).\n", __LINE__, clientIndex, strerror(errno));
            }
            tcpip->clientSockets[clientIndexC] = -1;
            pthread_mutex_unlock(&(tcpip->tcpipLock));
            *nRecvBytes = 0;
        }
        else {
            ModelicaFormatError("MDDTCPIPSocketServer.h:%d: recv failed for client %d (%s).\n", __LINE__, clientIndex, strerror(errno));
        }
    }

    tcpip->nRecvBytes[clientIndexC] = *nRecvBytes;
}

/** Send data via TCP/IP client socket.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [in] data Pointer to data that should be sent.
* @param [in] dataSize Size of data to be sent in byte.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @return On success, return the number of bytes sent, 0 if operation would block, -1 on non-fatal error.
*/
DllExport int MDD_TCPIPServer_Send(void* p_tcpip, const char* data, int dataSize, int clientIndex) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    int clientSocket = tcpip->clientSockets[clientIndexC];
    int iSendResult = -1;
    int retval = -1;
    int err = 0;
    int rc = 0;

    if (clientSocket == -1) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to send to invalid socket at client index %d. Skipping ...\n", __LINE__, clientIndex);
        retval = -1;
    }
    else {
        /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Send %d bytes to client at index %d. data: %s\n", __LINE__, dataSize, clientIndex, data); */
        iSendResult = send(clientSocket, data, dataSize, 0);
        if (iSendResult == -1) {
            if (errno == EAGAIN || errno == EWOULDBLOCK ) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Cannot send because the socket at client index %d is marked as nonblocking and the requested operation would block.\n", __LINE__, clientIndex);
                retval = 0;
            }
            else if (errno == ECONNRESET) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: send failed with error ECONNRESET at client index %d. Close socket and continue ...\n", __LINE__, clientIndex);
                pthread_mutex_lock(&(tcpip->tcpipLock));
                rc = close(tcpip->clientSockets[clientIndexC]);
                if (rc) {
                    ModelicaFormatError("MDDTCPIPSocketServer.h:%d: close socket failed at client index %d (%s).\n", __LINE__, clientIndex, strerror(errno));
                }
                tcpip->clientSockets[clientIndexC] = -1;
                pthread_mutex_unlock(&(tcpip->tcpipLock));
                retval = -1;
            }
            else {
                err = errno;
                close(tcpip->clientSockets[clientIndexC]);
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: send failed for client at index %d (%s).\n", __LINE__, clientIndex, strerror(err));
            }
        }
        else {
            retval = iSendResult;
        }
    }
    return retval;
}

/** Send data via TCP/IP client socket from SerialPackager package.
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [inout] p_package pointer to the SerialPackager
* @param [in] dataSize Size of data to be sent in byte.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @return On success, return the number of bytes sent, 0 if operation would block, -1 on non-fatal error.
*/
DllExport int MDD_TCPIPServer_SendP(void* p_tcpip, void* p_package, int dataSize, int clientIndex) {
    return MDD_TCPIPServer_Send(p_tcpip, MDD_SerialPackagerGetData(p_package), dataSize, clientIndex);
}


#else

#error "Modelica_DeviceDrivers: No support of TCP/IP Socket for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDTCPIPSOCKETSERVER_H_ */
