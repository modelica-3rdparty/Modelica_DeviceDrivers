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

/** Test for MDDUtilities.
 *
 * @file
 * @author      bernhard-thiele
 * @author      tbeu
 * @since       2013-05-24
 * @test Test for MDDUtilities.h, MDDUtilitiesMAC.h and MDDUtilitiesUUID.h .
 *
*/

#include <stdio.h>
#include <string.h>
#include "../../Include/MDDUtilities.h"
#include "../../Include/MDDUtilitiesMAC.h"
#include "../../Include/MDDUtilitiesUUID.h"

static int test_MDD_utilitiesLoadRealParameter(void) {
    int failed = 0;
    double result;
    const double expected = 13;

    result = MDD_utilitiesLoadRealParameter("parameterInitValues.txt", "var1");
    failed = (result == expected ? 0 : 1);

    return failed;
}

static int test_MDD_generateUUID(void) {
    int failed = 0;
    int i;

    for (i = 0; i < 10; i++) {
        const char* uuid = MDD_utilitiesGenerateUUID();
        if (36 != strlen(uuid)) {
            failed = 1;
            break;
        }
    }

    return failed;
}

static int test_MDD_getMACAddress(int i) {
    int failed = 0;

    const char* mac = MDD_utilitiesGetMACAddress(i);

    return failed;
}

int main(void) {
    int failed1 = 0;
    int failed2 = 0;
    int failed3 = 0;

    printf("Testing parseParameter() from MDDUtilities.h ...");
    failed1 = test_MDD_utilitiesLoadRealParameter();
    printf(failed1 == 0 ? "\tOK.\n" : "\tFAILED\n");

    printf("Testing generateUUID() from MDDUtilitiesUUID.h ...");
    failed2 = test_MDD_generateUUID();
    printf(failed2 == 0 ? "\tOK.\n" : "\tFAILED\n");

    printf("Testing getMACAddress() from MDDUtilitiesMAC.h ...");
    failed3 = test_MDD_getMACAddress(1);
    printf(failed3 == 0 ? "\tOK.\n" : "\tFAILED\n");

    return failed1 + failed2 + failed3;
}
