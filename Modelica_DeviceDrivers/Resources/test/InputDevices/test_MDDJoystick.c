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

/** Test for MDDJoystick.
 *
 * @file
 * @author	bernhard-thiele
 * @since	2012-05-27
 * @test Interactive test for MDDJoystick.c.
*/

#include <stdio.h>
#include "../../src/include/util.h"
#include "../../Include/MDDJoystick.h"

int main(void) {

    double pdAxis[6];
    int piButtons[32];
    int piPOV, i;
    void* js = MDD_joystickConstructor(0);
    printf("Interactive test for MDDJoystick. Stop with Ctrl-c.\n");
    while (1) {
        MDD_joystickGetData(js, pdAxis, piButtons, &piPOV);
        printf("X: %.1lf, Y: %.1lf, Z: %.1lf, ", pdAxis[0], pdAxis[1], pdAxis[2]);
        printf("R: %.1lf, U: %.1lf, V: %.1lf", pdAxis[3], pdAxis[4], pdAxis[5]);
        for (i=0; i < 8; i++) {
            printf(", B%d: %d", i, piButtons[i]);
        }
        printf(" \r");
        fflush(stdout);
        MDD_msleep(100);
    }
    return 0;
}
