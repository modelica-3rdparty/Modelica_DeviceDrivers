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

/** Test for MDDMapIntInt.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-12-22
 * @test Test for MDDMapIntInt.h.
 *
*/

#include <stdio.h>
#include <string.h>
#include "../../src/include/MDDMapIntInt.h"

int test_mapIntInt() {
    void * p_mDDMap;
    int failed = 0, i, res, keys[10];

    p_mDDMap = MDD_mapIntIntConstructor();
    failed = p_mDDMap == NULL ? 1 : failed;

    for (i=0; i<10; i++) {
        MDD_mapIntIntInsert(p_mDDMap, i*2, i*3);
    }

    for (i=0; i<10; i++) {
        res = MDD_mapIntIntLookup(p_mDDMap, i*2);
        failed = res == i*3 ? failed : 1;
    }

    failed = MDD_mapIntIntSize(p_mDDMap) == 10 ? failed : 1;

    MDD_mapIntIntGetKeys(p_mDDMap, keys);
    printf("retrieved keys: ");
    for (i=0; i<10; i++) {
        printf("%d, ", keys[i]);
    }
    printf("\n");

    MDD_mapIntIntDestructor(p_mDDMap);

    return failed;
}

int main() {
    int failed = 0;
    printf("Testing MDDMapIntInt from the Util module ...\n");

    failed = test_mapIntInt();

    printf("Testing MDDMapIntInt from the Util module ...");
    failed == 0 ? printf("\tOK.\n") : printf("\tFAILED");
    return failed;
}
