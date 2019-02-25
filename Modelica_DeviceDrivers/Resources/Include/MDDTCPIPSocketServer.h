/** TCP/IP server support (header-only library).
*
* @file
* @author bernhard-thiele
* @since 2019-08-01
* @copyright see Modelica_DeviceDrivers project's License.txt file
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

#include <winsock2.h>
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
        // Accept a client socket
        EnterCriticalSection(&tcpip->tcpipLock);
        maxClients = tcpip->maxClients;
        for (int i = 0; i < maxClients; ++i)
            clientSockets[i] = tcpip->clientSockets[i];
        LeaveCriticalSection(&tcpip->tcpipLock);

        for (int i = 0; i < maxClients; ++i) {
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
    for (int i = 0; i < tcpip->maxClients; ++i) {
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
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: socket failed with error: %ld\n", __LINE__, WSAGetLastError());
    }

    // Non-blocking vs blocking mode
    iResult = ioctlsocket(tcpip->listenSocket, FIONBIO, &iMode);
    if (iResult != NO_ERROR) {
        freeaddrinfo(result);
        MDD_TCPIPServer_Destructor(tcpip); // Explicit call, because it won't be called automatically by Modelica, since object not constructed, yet.
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: ioctlsocket failed with error: %ld\n", __LINE__, iResult);
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
        tcpip->runAcceptingThread = 0;
        for (int i = 0; i < tcpip->maxClients; ++i) {
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
        for (int i = 0; i < tcpip->maxClients; ++i) {
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
DllExport void MDD_TCPIPServer_acceptedClients(void * p_tcpip, int* acceptedClients, size_t dim) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;

    if (dim != tcpip->maxClients) {
        ModelicaFormatError("MDDTCPIPSocketServer.h:%d: Size of acceptedClients != %d\n", __LINE__, tcpip->maxClients);
    }
    EnterCriticalSection(&tcpip->tcpipLock);
    for (int i = 0; i < tcpip->maxClients; ++i) {
        acceptedClients[i] = (tcpip->clientSockets[i] != INVALID_SOCKET) ? 1 : 0;
    }
    LeaveCriticalSection(&tcpip->tcpipLock);
}

/** Check if a client at the specified index has been accepted by the server. */
DllExport int MDD_TCPIPServer_hasAcceptedClient(void * p_tcpip, int clientIndex) {
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
* @FIXME Adapt to MDD_TCPIPServer_readP. Untested function. Lot's of code duplication with MDD_TCPIPServer_readP.
*
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @param [in] recvbuflen Size of the receiving buffer
* @param [out] nRecvBytes If 0 it means that no new data is available.
* @return Pointer to the data buffer. If no new data is available, an empty string is returned.
*/
DllExport const char* MDD_TCPIPServer_read(void * p_tcpip, int clientIndex, int recvbuflen, int* nRecvBytes) {
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
        pb = (char*)realloc(recvbuflen, sizeof(char));
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
DllExport void MDD_TCPIPServer_readP(void * p_tcpip, void* p_package, int clientIndex, int recvbuflen, int* nRecvBytes) {
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
        pb = (char*)realloc(recvbuflen, sizeof(char));
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
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_readP failed. Buffer overflow.\n", __LINE__);
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
            /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: MDD_TCPIPServer_readP WSAEWOULDBLOCK\n", __LINE__); */
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
* @return Return value of Windows 'send' function.
*/
DllExport int MDD_TCPIPServer_send(void* p_tcpip, const char* data, int dataSize, int clientIndex) {
    MDDTCPIPServer* tcpip = (MDDTCPIPServer*)p_tcpip;
    int clientIndexC = clientIndex - 1;
    SOCKET clientSocket = tcpip->clientSockets[clientIndexC];
    int iSendResult = SOCKET_ERROR;
    int wsaLastError = 0;
    int rc = 0;

    if (clientSocket == INVALID_SOCKET) {
        ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Trying to send to invalid socket at client index %d. Skipping ...\n", __LINE__, clientIndex);
        iSendResult = SOCKET_ERROR;
    }
    else {
        /* ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Send %d bytes to client at index %d. data: %s\n", __LINE__, dataSize, clientIndex, data); */
        iSendResult = send(clientSocket, data, dataSize, 0);
        if (iSendResult == SOCKET_ERROR) {
            wsaLastError = WSAGetLastError();
            if (wsaLastError == WSAEWOULDBLOCK) {
                ModelicaFormatMessage("MDDTCPIPSocketServer.h:%d: Cannot send because the socket at client index %d is marked as nonblocking and the requested operation would block.\n", __LINE__, clientIndex);
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
            }
            else {
                closesocket(tcpip->clientSockets[clientIndexC]);
                ModelicaFormatError("MDDTCPIPSocketServer.h:%d: send failed for client at index %d with error: %d\n", __LINE__, clientIndex, wsaLastError);
            }
        }
    }
    return iSendResult;
}

/** Send data via TCP/IP client socket from SerialPackager package.
* @param [inout] p_tcpip MDDTCPIPServer data structure as opaque pointer.
* @param [inout] p_package pointer to the SerialPackager
* @param [in] dataSize Size of data to be sent in byte.
* @param [in] clientIndex index of the TCP/IP client (index range [1,max])
* @return Return value of Windows 'send' function.
*/
DllExport int MDD_TCPIPServer_sendP(void* p_tcpip, void* p_package, int dataSize, int clientIndex) {
    return MDD_TCPIPServer_send(p_tcpip, MDD_SerialPackagerGetData(p_package), dataSize, clientIndex);
}


#elif defined(__linux__) || defined(__CYGWIN__)

#error "HapticsLibrary: No support of TCP/IP Socket for your platform"

#else

#error "HapticsLibrary: No support of TCP/IP Socket for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDTCPIPSOCKETSERVER_H_ */
