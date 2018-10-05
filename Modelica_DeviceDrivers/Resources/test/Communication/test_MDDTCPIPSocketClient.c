/*
 *  Copyright (c) 2015-2018, DLR, ESI ITI, and Linkoeping University (PELAB)
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

/** Test for MDDTCPIPSocket.
 *
 * @file
 * @author      tbeu
 * @since       2015-04-21
 * @test Test for MDDTCPIPSocket.h.
*/

#define WINVER 0x0501

#include <stdio.h>
#include "../../Include/MDDTCPIPSocket.h"
#include "../../src/include/util.h" /* MDD_msleep(..) */

int main(void) {
    void * client;
    char sendMessage[80];
    const char *recMessage;
    int i;

    client = MDD_TCPIPClient_Constructor();
    if (client == 0) {
        perror("client == NULL\n");
        exit(EXIT_FAILURE);
    }

    if (MDD_TCPIPClient_Connect(client, "localhost", 27015)) {
        for (i=0; i < 10; i++) {
            sprintf(sendMessage, "Current i is %i", i);
            MDD_TCPIPClient_Send(client, sendMessage, 80);
            MDD_msleep(250);
            recMessage = MDD_TCPIPClient_Read(client, 80);
            printf("Received: %s\n", recMessage);
        }
    }

    MDD_TCPIPClient_Destructor(client);

    return EXIT_SUCCESS;
}
