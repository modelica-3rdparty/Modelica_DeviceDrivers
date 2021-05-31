/*
 *  Copyright (c) 2012-2020, DLR, ESI ITI, and Linkoeping University (PELAB)
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

/** Test for MDDSharedMemory.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-04
 * @test Test for MDDSharedMemory.h.
*/

#include <stdio.h>
#include <stdbool.h>
#include "../../Include/MDDSharedMemory.h"

#define M_LENGTH (80)

int main(void) {
    void *smb1, *smb2;
    int i;
    const char* semname = "/test5";
    char sendMessage[M_LENGTH];
    const char *recMessage;

    printf("Testing MDDSharedMemory\n");

    smb1 = MDD_SharedMemoryConstructor(semname, M_LENGTH, true);
    if (smb1 == 0) {
        perror("smb1 == NULL\n");
        exit(1);
    }

    smb2 = MDD_SharedMemoryConstructor(semname, M_LENGTH, true);
    if (smb2 == 0) {
        MDD_SharedMemoryDestructor(smb1);
        perror("smb2 == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_SharedMemoryWrite(smb1, sendMessage, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        recMessage = MDD_SharedMemoryRead(smb2);
        printf("Received: %s\n", recMessage);
    }

    printf("Buffer size smb1: %d\n", MDD_SharedMemoryGetDataSize(smb1));
    printf("Buffer size smb2: %d\n", MDD_SharedMemoryGetDataSize(smb2));

    MDD_SharedMemoryDestructor(smb1);
    MDD_SharedMemoryDestructor(smb2);

    return 0;
}
