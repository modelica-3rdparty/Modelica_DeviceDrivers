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

/** Test for Socket CAN support.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-12-22
 * @test Test for MDDSocketCAN.h
 *
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../../Include/MDDSocketCAN.h"
#include "../../src/include/util.h"

/** Bring up the necessary virtual can devices
 *
 * (At least this works for Ubuntu)
 */
void setup_VirtualCANDevices() {
    int failed;
    failed = system("sudo modprobe vcan");
    if (failed)  fprintf(stderr, "Error: 'sudo modprobe vcan'");

    failed = system("sudo ip link add type vcan"); /* gives vcan0 */
    if (failed)  fprintf(stderr, "Error: 'sudo ip link add type vcan'");

    failed = system("sudo ifconfig vcan0 up");
    if (failed)  fprintf(stderr, "Error: 'sudo ifconfig vcan0 up'");
}

int test_Constructor() {
    void * mDDSocketCan;
    int failed;

    mDDSocketCan = MDD_socketCANConstructor("vcan0");
    failed = mDDSocketCan == NULL ? 1 : 0;

    MDD_socketCANDestructor(mDDSocketCan);

    return failed;
}

int test_CANWrite() {
    void * mDDSocketCan;
    char data[8];
    int failed;

    mDDSocketCan = MDD_socketCANConstructor("vcan0");
    failed = mDDSocketCan == NULL ? 1 : 0;

    strcpy(data, "Hello C");
    MDD_socketCANWrite(mDDSocketCan, 1, sizeof(data), data);

    MDD_socketCANDestructor(mDDSocketCan);

    return failed;
}

int test_CANWriteRead() {
    void * mDDSocketCan0;
    void * mDDSocketCan1;
    char data_w[8];
    const char * data_r;
    int failed, i;

    mDDSocketCan0 = MDD_socketCANConstructor("vcan0");
    failed = mDDSocketCan0 == NULL ? 1 : 0;
    /* Need to bind *different* socket to *same* device in order
       to receive sent messages.
       Note that unless the flag CAN_RAW_RECV_OWN_MSGS is set
       (default is not set!) a socket won't receive the
       messages it sent (that's why we use two different sockets).
    */
    mDDSocketCan1 = MDD_socketCANConstructor("vcan0");
    failed = mDDSocketCan1 == NULL ? 1 : 0;

    MDD_socketCANDefineObject(mDDSocketCan1, 1, 8);

    for(i=0; i < 10; i++) {
        sprintf(data_w, "Hi %d", i*2);
        MDD_socketCANWrite(mDDSocketCan0, 1, 8, data_w);
        MDD_msleep(10);
        data_r = MDD_socketCANRead(mDDSocketCan1, 1,  8);
        failed = strcmp(data_w, data_r) == 0 ? failed : 1;
    }

    MDD_socketCANDestructor(mDDSocketCan0);
    MDD_socketCANDestructor(mDDSocketCan1);

    return failed;
}

int main() {
    int failed = 0;
    printf("Testing Socket CAN Support ..\n");
    printf("PLEASE NOTE: the virtual can device vcan0 must be up in order to run tests!\n");
    /* Setting up vcan0 can be done by uncommenting the line below, or manually by
       typing the commands in setup_VirtualCANDevices() in a console */
    //setup_VirtualCANDevices();

    //failed = test_Constructor(); if (failed) goto END;
    //failed = test_CANWrite(); if (failed) goto END;
    failed = test_CANWriteRead();
    if (failed) {
        goto END;
    }

END:
    printf("\nTesting Socket CAN Support %s\n", (failed != 0) ? "FAILED" : "OK");
    return failed;
}
