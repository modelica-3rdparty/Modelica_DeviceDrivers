/*
 *  Copyright (c) 2012-2018, DLR, ESI ITI, and Linkoeping University (PELAB)
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice, this
 *     list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/** Test for MDDUDPSocket.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-05-30
 * @test Test for MDDUDPSocket.h.
*/

#include <stdio.h>
#include "../../Include/MDDUDPSocket.h"
#include "../../src/include/util.h" /* MDD_msleep(..) */

int main(void) {
    void * sendSocket;
    void * recSocket;
    char sendMessage[80];
    const char *recMessage;
    int i;
    int recBytes;

    recSocket = MDD_udpConstructor(10002, 80, 1); /* Use detached  receive thread */
    if (recSocket == 0) {
        perror("recSocket == NULL\n");
        exit(1);
    }

    sendSocket = MDD_udpConstructor(0, 0, 0);
    if (sendSocket == 0) {
        MDD_udpDestructor(recSocket);
        perror("sendSocket == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        //MDD_udpSend(sendSocket, "127.0.0.1", 10002, sendMessage, strlen(sendMessage));
        MDD_udpSend(sendSocket, "127.0.0.1", 10002, sendMessage, 80);
        //MDD_msleep(1);
        recBytes = MDD_udpGetReceivedBytes(recSocket);
        recMessage = MDD_udpRead(recSocket);
        printf("Received %d bytes: %s\n", recBytes, recMessage);
    }

    MDD_udpDestructor(recSocket);
    MDD_udpDestructor(sendSocket);

    return 0;
}
