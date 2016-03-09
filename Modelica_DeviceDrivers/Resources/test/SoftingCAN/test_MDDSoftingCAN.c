/*
 *  Copyright (c) 2012-2016, DLR Institute of System Dynamics and Control
 *  Copyright (c) 2015-2016, Linkoeping University (PELAB) and ITI GmbH
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

/** Test for CAN support.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-18
 * @test Test for MDDSoftingCAN.c.
 *
*/

#include <stdio.h>
#define MDDSOFTINGCANUSECMAKE
#include "../../Include/MDDSoftingCAN.h"
/* #include "../../Include/MDDCANMessage.h" // already used in MDDSoftingCAN library */
#include "../../Include/MDDSerialPackager.h"
#include "../../src/include/util.h"

int test_Constructor() {
    void * mDDCan;
    int failed;

    mDDCan = MDD_softingCANConstructor("CANusb_1", 1);
    failed = mDDCan == NULL ? 1 : 0;
    MDD_softingCANStartChip(mDDCan);

    MDD_softingCANDestructor(mDDCan);

    return failed;
}

int test_Startup() {
    void * mDDCan;
    int failed, obj1, obj2, obj3;

    mDDCan = MDD_softingCANConstructor("CANusb_1", 1);
    failed = mDDCan == NULL ? 1 : 0;

    obj1 = MDD_softingCANDefineObject(mDDCan, 0x01, 1);
    obj2 = MDD_softingCANDefineObject(mDDCan, 0x02, 2);
    obj3 = MDD_softingCANDefineObject(mDDCan, 0x03, 2);
    printf("Defined receive message %d, got obj: %d\n"
           "Defined transmit message %d, got obj: %d\n"
           "Defined transmit message %d, got obj: %d\n",
           0x01, obj1, 0x02, obj2, 0x03, obj3);

    MDD_softingCANStartChip(mDDCan);

    MDD_softingCANDestructor(mDDCan);

    return failed;
}

int test_SendMessage() {
    void * mDDCan;
    void * msg1;
    int failed, obj1, i;

    mDDCan = MDD_softingCANConstructor("CANusb_1", 3);
    failed = mDDCan == NULL ? 1 : 0;

    obj1 = MDD_softingCANDefineObject(mDDCan, 0x01, 2);
    printf("Defined transmit message %d, got obj: %d\n",
           0x01, obj1);
    MDD_softingCANStartChip(mDDCan);

    msg1 = MDD_SerialPackagerConstructor(8);

    for (i=0; i < 10; i++) {
        printf("Transmitting message 0x01 ..");
        MDD_SerialPackagerClear(msg1);
        MDD_SerialPackagerIntegerBitpack(msg1, 0, 8, i*2);
        MDD_softingCANWriteObjectP(mDDCan, obj1, 8, msg1);
        printf(" OK.\n");
        MDD_SerialPackagerPrint(msg1);
        MDD_msleep(1000);
    }

    MDD_SerialPackagerDestructor(msg1);
    MDD_softingCANDestructor(mDDCan);

    return failed;
}

int test_ReadMessage() {
    void * mDDCan;
    void * msg1;
    int failed, obj1, i, msgdata;

    mDDCan = MDD_softingCANConstructor("CANusb_1", 3);
    failed = mDDCan == NULL ? 1 : 0;

    obj1 = MDD_softingCANDefineObject(mDDCan, 0x10, 1);
    printf("Defined receive message %d, got obj: %d\n",
           0x01, obj1);
    MDD_softingCANStartChip(mDDCan);

    msg1 = MDD_SerialPackagerConstructor(8);

    for (i=0; i < 10; i++) {
        printf("Receiving message 0x01 ..\n");
        MDD_SerialPackagerSetPos(msg1, 0);
        MDD_softingCANReadRcvDataP(mDDCan, obj1, msg1);

        MDD_SerialPackagerPrint(msg1);
        msgdata = MDD_SerialPackagerIntegerBitunpack(msg1, 0, 32);
        printf(" Got: %d.\n", msgdata);
        MDD_msleep(1000);
    }

    MDD_CANMessageDestructor(msg1);
    MDD_softingCANDestructor(mDDCan);

    return failed;
}

int main() {
    int failed = 0;
    printf("Testing CAN Support\n");

    // failed = test_Constructor(); if (failed) return failed;
    //failed = test_Startup(); if (failed) return failed;
    failed = test_SendMessage();
    if (failed) {
        return failed;
    }
    //failed = test_ReadMessage(); if (failed) return failed;

    return 0;
}
