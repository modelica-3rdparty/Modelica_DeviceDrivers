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

/** Test for MDDMapIntpVoid.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-12-22
 * @test Test for MDDMapIntpVoid.h.
 *
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../src/include/MDDMapIntpVoid.h"

int test_mapIntpVoid() {
    void * p_mDDMap;
    char* data, cmp[10];
    int failed = 0, i, keys[10];

    p_mDDMap = MDD_mapIntpVoidConstructor();
    failed = p_mDDMap == NULL ? 1 : failed;

    for (i=0; i<10; i++) {
        data = malloc(10);
        sprintf(data, "%d", i*3);
        MDD_mapIntpVoidInsert(p_mDDMap, i*2, data);
    }

    for (i=0; i<10; i++) {
        data = MDD_mapIntpVoidLookup(p_mDDMap, i*2);
        if (data) {
            sprintf(cmp, "%d", i*3);
            failed = strcmp(data, cmp) ? 1 : failed;
            free(data);
        }
        else {
            failed = 1;
        }
    }

    failed = MDD_mapIntpVoidSize(p_mDDMap) == 10 ? failed : 1;

    MDD_mapIntpVoidGetKeys(p_mDDMap, keys);
    printf("retrieved keys: ");
    for (i=0; i<10; i++) {
        printf("%d, ", keys[i]);
    }
    printf("\n");

    MDD_mapIntpVoidDestructor(p_mDDMap);

    return failed;
}

int main() {
    int failed = 0;
    printf("Testing MDDMapIntpVoid from the Util module ...\n");

    failed = test_mapIntpVoid();

    printf("Testing MDDMapIntpVoid from the Util module ...");
    failed == 0 ? printf("\tOK.\n") : printf("\tFAILED\n");
    return failed;
}
