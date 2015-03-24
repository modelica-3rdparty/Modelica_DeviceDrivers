/** Test for MDDJoystick.
 *
 * @file
 * @author	Bernhard Thiele <bernhard.thiele@dlr.de>
 * @since	2012-05-27
 * @copyright Modelica License 2
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
