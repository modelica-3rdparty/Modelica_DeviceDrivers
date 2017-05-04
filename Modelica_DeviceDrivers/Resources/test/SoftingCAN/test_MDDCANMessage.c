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

/** Test CAN message encoding/decoding.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-18
 * @test Test for MDDCANMessage.h.
 *
*/

#include <stdio.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include "MDDCANMessage.h"

int test_packAndUnpackFloatAtByteBoundary() {
    CANMessage* msg1;
    double value1;
    int failed;

    printf("Pack and unpack IEEE float value at byte boundary:\n");
    msg1 = (CANMessage*) MDD_CANMessageConstructor();
    MDD_CANMessageFloatBitpacking(msg1, 24, 3.2);
    value1 = MDD_CANMessageFloatBitunpacking(msg1, 24);
    failed = fabs(value1 - 3.2) < 2*FLT_EPSILON ? 0 : 1;
    MDD_CANMessageDestructor(msg1);
    printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 3.2, value1);

    return failed;
}

int test_packAndUnpackFloatWithOffsetToByteBoundary() {
    CANMessage* msg1;
    double value1;
    int failed;

    printf("Pack and unpack IEEE float value with offset to byte boundary:\n");
    msg1 = (CANMessage*) MDD_CANMessageConstructor();
    MDD_CANMessageFloatBitpacking(msg1, 9, 3.3);
    value1 = MDD_CANMessageFloatBitunpacking(msg1, 9);
    failed = fabs(value1 - 3.3) < 2*FLT_EPSILON ? 0 : 1;
    MDD_CANMessageDestructor(msg1);
    printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 3.3, value1);
    return failed;
}

int test_packAndUnpackDouble() {
    CANMessage* msg1;
    double value1;
    int failed;

    printf("Pack and unpack IEEE double value:\n");
    msg1 = (CANMessage*) MDD_CANMessageConstructor();
    MDD_CANMessageDoubleBitpacking(msg1, 4.4);
    value1 = MDD_CANMessageDoubleBitunpacking(msg1);
    failed = fabs(value1 - 4.4) < 2*DBL_EPSILON ? 0 : 1;
    MDD_CANMessageDestructor(msg1);
    printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 4.4, value1);
    return failed;
}

int main() {
    int failed, value1;
    void * msg1;
    CANMessage* msg2 = (CANMessage*) malloc(sizeof(CANMessage));
    int myIntValueIn = 1073741824; // 2^30
    int myIntValueOut=0;

    printf("Testing CAN message encoding/decoding\n");

    /* Is intel endianness correctly supported? */
    memcpy(msg2->data+1, &myIntValueIn, sizeof(int));
    myIntValueOut = MDD_CANMessageIntegerBitunpacking((void*)msg2, 8, 32);
    printf("myIntValueIn (2^30): %d, myIntValueOut (2^30): %d\n", myIntValueIn, myIntValueOut);
    failed = myIntValueIn == myIntValueOut ? 0 : 1;

    printf("Pack and unpack integer value\n");
    msg1 = MDD_CANMessageConstructor();
    MDD_CANMessageIntegerBitpacking(msg1, 0, 8, 20);
    value1 = MDD_CANMessageIntegerBitunpacking(msg1, 0, 8);
    failed = failed || value1 == 20 ? 0 : 1;
    printf("Packed value: %d, got value: %d\n", 20, value1);

    failed = failed || test_packAndUnpackFloatAtByteBoundary();

    failed = failed || test_packAndUnpackFloatWithOffsetToByteBoundary();

    failed = failed || test_packAndUnpackDouble();

    return failed;
}
