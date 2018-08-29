/*
 *  Copyright (c) 2018, Linkoeping University (PELAB) and ESI ITI GmbH
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

/** Test for MDDMQTT.
 *
 * @file
 * @author      tbeu
 * @since       2018-08-15
 * @test Test for MDDMQTT.h.
*/

#include <stdio.h>
#include "../../Include/MDDMQTT.h"

#define M_LENGTH (80)
#define CHANNEL "test-mqtt"
#define CLIENTID1 "testClient-M_DD-1"
#define CLIENTID2 "testClient-M_DD-2"

int main(void) {
    void *mqtt1, *mqtt2;
    int i;
    char sendMessage[M_LENGTH];
    const char *recMessage;

    printf("Testing MDDMQTT %s\n", MDD_mqttGetVersionInfo(NULL));

    mqtt1 = MDD_mqttConstructor("tcp://", "test.mosquitto.org", 1883, 0, 1, CHANNEL, M_LENGTH, CLIENTID1, "", "", "", "", "", 20, 1, 1, 30, 20, 0, 10, 1, 1, 0);
    if (NULL == mqtt1) {
        perror("mqtt1 == NULL\n");
        exit(1);
    }

    mqtt2 = MDD_mqttConstructor("tcp://", "test.mosquitto.org", 1883, 1, 1, CHANNEL, M_LENGTH, CLIENTID2, "", "", "", "", "", 20, 1, 1, 30, 20, 0, 10, 1, 1, 0);
    if (NULL == mqtt2) {
        MDD_mqttDestructor(mqtt1);
        perror("mqtt2 == NULL\n");
        exit(1);
    }

    memset(sendMessage, 0, M_LENGTH);
    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_mqttSend(mqtt1, CHANNEL, sendMessage, 1, 10, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        recMessage = MDD_mqttRead(mqtt2);
        printf("Received %s\n", recMessage);
    }

    MDD_mqttDestructor(mqtt1);
    MDD_mqttDestructor(mqtt2);

    return 0;
}
