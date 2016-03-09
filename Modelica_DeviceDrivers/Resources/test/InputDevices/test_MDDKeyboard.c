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

/** Test for MDDKeyboard.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-01
 * @test Interactive test for MDDKeyboard.h.
*/

#include <stdio.h>
#include "../../Include/MDDKeyboard.h"

int main(void) {
    int piKeyState;
    int iKeyCode;

    piKeyState = 0;
    iKeyCode = 32;
    printf("Please press iKeyCode %d (Space)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    piKeyState = 0;
    iKeyCode = 13;
    printf("Please press iKeyCode %d (return)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    piKeyState = 0;
    iKeyCode = 38;
    printf("Please press iKeyCode %d (Up)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    piKeyState = 0;
    iKeyCode = 40;
    printf("Please press iKeyCode %d (Down)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    piKeyState = 0;
    iKeyCode = 37;
    printf("Please press iKeyCode %d (Left)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    piKeyState = 0;
    iKeyCode = 39;
    printf("Please press iKeyCode %d (Right)\n", iKeyCode);
    while (!piKeyState) {
        MDD_keyboardGetKey(iKeyCode, &piKeyState);
    }
    printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

    printf("End of interactive Test\n");
    return 0;
}
