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

/** Test for MDDSerialPackager.
*
* @file
* @author      bernhard-thiele
* @since       2012-07-10
* @test Test for MDDSerialPackager.h.
*
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include "../../Include/MDDSerialPackager.h"

int test_createPgk() {
    void* pkg;
    int ret, failure = 0, size = 8;
    printf("START test_creatPkg: Creating SerialPackager of size %d .. \n", size);
    pkg = MDD_SerialPackagerConstructor(size);
    MDD_SerialPackagerPrint(pkg);

    MDD_SerialPackagerSetPos(pkg, 4);
    ret = MDD_SerialPackagerGetPos(pkg);
    failure =  ret == 4 ? 0 : 1;
    MDD_SerialPackagerDestructor(pkg);
    printf("END test_creatPkg .. ");
    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int test_add2Pkg() {
    void* pkg;
    int ret, failure = 0, size = 64;
    int a[3] = {1,2,3}, b[3];
    double c[3] = {0.5, 1.5, 2.5}, d[3];
    printf("test_add2Pkg: Adding and getting from SerialPackager of size %d .. ", size);
    pkg = MDD_SerialPackagerConstructor(size);
    MDD_SerialPackagerAddInteger(pkg, a, 3, 0);
    MDD_SerialPackagerAddDouble(pkg, c, 3, 0);

    MDD_SerialPackagerSetPos(pkg, 0);
    MDD_SerialPackagerGetInteger(pkg, b, 3, 0);
    MDD_SerialPackagerGetDouble(pkg, d, 3, 0);

    failure = (d[0] == 0.5 && d[1] == 1.5 && d[2] == 2.5) ? 0 : 1;
    failure = failure | (b[0] == 1 && b[1] == 2 && b[2] == 3) ? 0 : 1;
    MDD_SerialPackagerDestructor(pkg);
    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int test_add2PkgBoundary() {
    void* pkg;
    int ret, failure = 0, size = 4;
    int a = 100, b;
    printf("test_add2PkgBoundary: Adding and getting from SerialPackager of size %d .. ", size);
    pkg = MDD_SerialPackagerConstructor(size);
    MDD_SerialPackagerAddInteger(pkg, &a, 1, 0);

    MDD_SerialPackagerSetPos(pkg, 0);
    MDD_SerialPackagerGetInteger(pkg, &b, 1, 0);

    failure = failure | b == 100 ? 0 : 1;
    MDD_SerialPackagerDestructor(pkg);
    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int test_bitPack2Pkg() {
    void* pkg;
    int a, b, failure = 0, size = 64;
    printf("test_bitPack2Pkg: Packing and unpacking bit data ..");
    pkg = MDD_SerialPackagerConstructor(size);
    MDD_SerialPackagerIntegerBitpack(pkg, 3, 2, 3);
    MDD_SerialPackagerIntegerBitpack(pkg, 5, 12, 4095);

    MDD_SerialPackagerSetPos(pkg, 0);
    a = MDD_SerialPackagerIntegerBitunpack(pkg, 3, 2);
    b = MDD_SerialPackagerIntegerBitunpack(pkg, 5, 12);
    failure = (a == 3 && b == 4095) ? 0 : 1;

    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int test_addString() {
    void* pkg;
    char* a = "Hey";
    int b = 4;
    char* c = "you ";
    char* d = "pkg";
    const char* a_;
    int b_;
    const char* c_;
    const char* d_;
    int failure = 0, size = 64;
    printf("test_addString: Adding and retrieving strings ..");
    pkg = MDD_SerialPackagerConstructor(size);
    MDD_SerialPackagerAddString(pkg, a, 5);
    MDD_SerialPackagerAddInteger(pkg, &b, 1, 0);
    MDD_SerialPackagerAddString(pkg, c, 5);
    MDD_SerialPackagerAddString(pkg, d, 5);

    MDD_SerialPackagerSetPos(pkg, 0);
    a_ = MDD_SerialPackagerGetString(pkg, 5);
    MDD_SerialPackagerGetInteger(pkg, &b_, 1, 0);
    c_ = MDD_SerialPackagerGetString(pkg, 5);
    d_ = MDD_SerialPackagerGetString(pkg, 5);

    failure = strcmp(a,a_) == 0 ? 0 : 1;
    failure = failure || b == b_ ? 0 : 1;
    failure = failure || strcmp(c,c_) == 0 ? 0 : 1;
    failure = failure || strcmp(d,d_) == 0 ? 0 : 1;

    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int test_addDoubleAsFloat() {
    void* pkg;
    double doublesIn[4] = {0.003, 0.001, 00.2, 1.1};
    double doublesOut[4];
    int i;
    int failure = 0;
    printf("test_addDoubleAsFloat: Adding and retrieving doubles that are casted to float to save memory/bandwidth ..");
    pkg = MDD_SerialPackagerConstructor(4*sizeof(float));
    MDD_SerialPackagerAddDoubleAsFloat(pkg, doublesIn, 4, 0);
    MDD_SerialPackagerSetPos(pkg, 0);
    MDD_SerialPackagerGetFloatAsDouble(pkg, doublesOut, 4, 0);
    for (i=0; i < 4; i++) {
        /* Thats not a good way to compare floating points, but should be enough for us */
        failure = failure || fabs(doublesOut - doublesIn) < FLT_EPSILON ? 0 : 1;
    }
    if (failure) {
        printf("\tFAILED\n");
    }
    else {
        printf("\tOk\n");
    }
    return failure;
}

int main(void) {
    int failure = 0;

    failure = test_createPgk();
    failure = failure || test_add2PkgBoundary();
    failure = failure || test_add2Pkg();
    failure = failure || test_bitPack2Pkg();
    failure = failure || test_addString();
    failure = failure || test_addDoubleAsFloat();
    return failure;
}
