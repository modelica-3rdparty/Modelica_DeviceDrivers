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

/** Test for MDDUtilities.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2013-05-24
 * @test Test for MDDUtilities.h .
 *
*/

#include <stdio.h>
#include <string.h>
#include "../../Include/MDDUtilities.h"

int test_MDD_utilitiesLoadRealParameter() {
    int failed = 0;
    double result;
    const double expected = 13;

    result = MDD_utilitiesLoadRealParameter("parameterInitValues.txt", "var1");
    failed = (result == expected ? 0 : 1);

    return failed;
}

int main() {
    int failed = 0;
    printf("Testing parseParameter() from MDDUtilities.h ...");
    failed = test_MDD_utilitiesLoadRealParameter();

    failed == 0 ? printf("\tOK.\n") : printf("\tFAILED\n");
    return failed;
}
