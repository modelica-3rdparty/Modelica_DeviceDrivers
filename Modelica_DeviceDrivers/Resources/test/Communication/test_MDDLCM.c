/*
 *  Copyright (c) 2016, Linkoeping University (PELAB) and ESI ITI GmbH
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

/** Test for MDDLCM.
 *
 * @file
 * @author      tbeu
 * @since       2016-05-05
 * @test Test for MDDLCM.h.
*/

#include <stdio.h>
#include "../../Include/MDDLCM.h"

#define M_LENGTH (80)
#define CHANNEL "test5"
#define Q_SIZE (10)

int main(void) {
    void *lcm1, *lcm2;
    int i;
    char sendMessage[M_LENGTH];
    const char *recMessage;

    printf("Testing MDDLCM %s\n", MDD_lcmGetVersion(NULL));

    lcm1 = MDD_lcmConstructor("udpm://", "127.0.0.1", 10002, 0, NULL, 0, 0);
    if (NULL == lcm1) {
        perror("lcm1 == NULL\n");
        exit(1);
    }

    lcm2 = MDD_lcmConstructor("udpm://", "127.0.0.1", 10002, 1, CHANNEL, M_LENGTH, Q_SIZE);
    if (NULL == lcm2) {
        MDD_lcmDestructor(lcm1);
        perror("lcm2 == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_lcmSend(lcm1, CHANNEL, sendMessage, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        recMessage = MDD_lcmRead(lcm2);
        printf("Received %s\n", recMessage);
    }

    MDD_lcmDestructor(lcm1);
    MDD_lcmDestructor(lcm2);

    return 0;
}
