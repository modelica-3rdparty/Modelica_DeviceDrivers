#include <stdio.h>
#include "../../Include/MDDTCPIPSocketServer.h"
#include "../../Include/MDDTCPIPSocket.h"
#include "../include/util.h" /* MDD_msleep(..) */

#define DEFAULT_BUFLEN 512
#define DEFAULT_PORT 10001
#define MAX_CLIENTS 10

int main(void) {
	void* server = MDD_TCPIPServer_Constructor(DEFAULT_PORT, MAX_CLIENTS, 1);
    const char* recvbuf_server;
    int nRecvBytes;
    int nSentBytes;
    char sendbuf_server[DEFAULT_BUFLEN] = { 0 };
    unsigned int i = 0;
    int acceptedClients[MAX_CLIENTS];

    /***********************************************************************/
    /* Set up TCP/IP client so that the server has something that connects */
    /***********************************************************************/
    void * client;
    char sendbuf_client[DEFAULT_BUFLEN] = { 0 };
    const char* recvbuf_client;
    MDD_msleep(1000); // Allow some time to pass before trying to connect with TCP/IP client
    client = MDD_TCPIPClient_Constructor();
    if (client == NULL) {
        perror("client == NULL\n");
        exit(EXIT_FAILURE);
    }
    if (!MDD_TCPIPClient_Connect(client, "localhost", DEFAULT_PORT)) {
        perror("MDD_TCPIPClient_Connect() == 0\n");
        exit(EXIT_FAILURE);
    }

    memset(acceptedClients, 0, sizeof(acceptedClients));
    while (acceptedClients[0] != 1) {
        MDD_TCPIPServer_acceptedClients(server, acceptedClients, MAX_CLIENTS);
        MDD_msleep(100);
    }

    for (i = 0; i < 6; i++) {
        sprintf(sendbuf_client, "Current i is %d", i);
        MDD_TCPIPClient_Send(client, sendbuf_client, DEFAULT_BUFLEN);
        MDD_msleep(100);
        recvbuf_server = MDD_TCPIPServer_read(server, 1, DEFAULT_BUFLEN, &nRecvBytes);
        printf("%d: nReceivedBytes: %d\n", i, nRecvBytes);
        printf("%d: recvbuf: %s\n", i, recvbuf_server);
        if (nRecvBytes > DEFAULT_BUFLEN) {
            printf("%d: Buffer overflow. Got %d bytes\n", i, nRecvBytes);
        }
        else if (nRecvBytes > 0) {
            memcpy(sendbuf_server, recvbuf_server, nRecvBytes);
            printf("%d: sendbuf_server: %s\n", i, sendbuf_server);
            nSentBytes = MDD_TCPIPServer_send(server, sendbuf_server, nRecvBytes, 1);
            //nSentBytes = TCPIPServer_send(server, "QoK", 4, 1);
            printf("%d: nSentBytes: %d\n", i, nSentBytes);
        }
        MDD_msleep(100);
        recvbuf_client = MDD_TCPIPClient_Read(client, DEFAULT_BUFLEN);
        printf("Client Received: %s\n", recvbuf_client);
    }

    MDD_TCPIPClient_Destructor(client);
    MDD_TCPIPServer_Destructor(server);

    return EXIT_SUCCESS;
}
