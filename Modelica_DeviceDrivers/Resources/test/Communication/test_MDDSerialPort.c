/*
 *  Copyright (c) 2012-2016, DLR Institute of System Dynamics and Control
 *  Copyright (c) 2015-2016, Linkoeping University (PELAB) and ESI ITI GmbH
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

/** Test for MDDSerialPort.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2015-03-23
 * @test Test for MDDSerialPort.h.
*/

#include <stdio.h>
#include "../../Include/MDDSerialPort.h"

#define M_LENGTH (80)

int main(void) {
    void *sp1, *sp2;
    int i;
#if defined(WIN32)
    const char* sendName = "\\\\.\\COM6";
    const char* recName = "\\\\.\\COM7";
#else
    const char* sendName = "/dev/pts/1";
    const char* recName = "/dev/pts/3";
#endif
    char sendMessage[M_LENGTH];
    const char *recMessage;
    int recBytes;

    printf("Testing MDDSerialPort\n");

    sp1 = MDD_serialPortConstructor(sendName, M_LENGTH, 0, 0, 5);
    if (sp1 == 0) {
        perror("sp1 == NULL\n");
        exit(1);
    }

    sp2 = MDD_serialPortConstructor(recName, M_LENGTH, 0, 1, 5);
    if (sp2 == 0) {
        MDD_serialPortDestructor(sp1);
        perror("sp2 == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_serialPortSend(sp1, sendMessage, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        usleep(100); /* Need to give receiving thread a chance to read what was written */
        recBytes = MDD_serialPortGetReceivedBytes(sp2);
        recMessage = MDD_serialPortRead(sp2);
        printf("Received %d bytes: %s\n", recBytes, recMessage);
    }

    MDD_serialPortDestructor(sp1);
    MDD_serialPortDestructor(sp2);

    return 0;
}
