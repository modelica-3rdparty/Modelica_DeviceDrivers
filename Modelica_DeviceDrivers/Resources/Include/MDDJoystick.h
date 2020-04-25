/** Support of joysticks and alike (header-only library).
 *
 * @file
 * @author		tbellmann (Windows)
 * @author		bernhard-thiele (Linux)
 * @author		tbeu
 * @since		2012-05-25
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * @remark The Linux implementation mimics the interface of the windows version, that's
 *         why it is somewhat odd.
*/

#ifndef MDDJOYSTICK_H_
#define MDDJOYSTICK_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <mmsystem.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"

#pragma comment( lib, "Winmm.lib" )

/** Joystick object */
typedef struct {
    int iJSID;
} MDDJoystick;

DllExport void* MDD_joystickConstructor(int iJSID) {
    MDDJoystick* js = (MDDJoystick*) malloc(sizeof(MDDJoystick));
    if (js) {
        js->iJSID = iJSID;
    }
    return (void*) js;
}

DllExport void MDD_joystickDestructor(void* jsObj) {
    MDDJoystick* js = (MDDJoystick*) jsObj;
    if (js) {
        free(js);
    }
}

/** Get data from joystick device.
 * @remark The linux implementation must have the interface of the windows version, that's
 *         why its implementation might seem somewhat odd. The @iJSID argument has no effect
 *         in linux. Actually we should hand in the string of the device file in linux. Since
 *         we do not, we just guess.
 * @warning Don't know how to get POV in linux, defaulting to 7 in linux.
 */
DllExport void MDD_joystickGetData(void* jsObj, double * pdAxes, int * piButtons, int * piPOV) {
    MDDJoystick* js = (MDDJoystick*) jsObj;
    if (js) {
        JOYINFOEX JoyInfo = {0}; /* joystick data structure */
        JoyInfo.dwFlags = JOY_RETURNALL;
        JoyInfo.dwSize = sizeof(JOYINFOEX);

        /* load data from joystick into data structure */
        joyGetPosEx(js->iJSID, &JoyInfo);

        /* output axes: */
        pdAxes[0] = (double)JoyInfo.dwXpos;
        pdAxes[1] = (double)JoyInfo.dwYpos;
        pdAxes[2] = (double)JoyInfo.dwZpos;
        pdAxes[3] = (double)JoyInfo.dwRpos;
        pdAxes[4] = (double)JoyInfo.dwUpos;
        pdAxes[5] = (double)JoyInfo.dwVpos;

        /* output buttons: */
        piButtons[0] = (JoyInfo.dwButtons & JOY_BUTTON1) ? 1 : 0;
        piButtons[1] = (JoyInfo.dwButtons & JOY_BUTTON2) ? 1 : 0;
        piButtons[2] = (JoyInfo.dwButtons & JOY_BUTTON3) ? 1 : 0;
        piButtons[3] = (JoyInfo.dwButtons & JOY_BUTTON4) ? 1 : 0;
        piButtons[4] = (JoyInfo.dwButtons & JOY_BUTTON5) ? 1 : 0;
        piButtons[5] = (JoyInfo.dwButtons & JOY_BUTTON6) ? 1 : 0;
        piButtons[6] = (JoyInfo.dwButtons & JOY_BUTTON7) ? 1 : 0;
        piButtons[7] = (JoyInfo.dwButtons & JOY_BUTTON8) ? 1 : 0;
        piButtons[8] = (JoyInfo.dwButtons & JOY_BUTTON9) ? 1 : 0;
        piButtons[9] = (JoyInfo.dwButtons & JOY_BUTTON10) ? 1 : 0;
        piButtons[10] = (JoyInfo.dwButtons & JOY_BUTTON11) ? 1 : 0;
        piButtons[11] = (JoyInfo.dwButtons & JOY_BUTTON12) ? 1 : 0;
        piButtons[12] = (JoyInfo.dwButtons & JOY_BUTTON13) ? 1 : 0;
        piButtons[13] = (JoyInfo.dwButtons & JOY_BUTTON14) ? 1 : 0;
        piButtons[14] = (JoyInfo.dwButtons & JOY_BUTTON15) ? 1 : 0;
        piButtons[15] = (JoyInfo.dwButtons & JOY_BUTTON16) ? 1 : 0;
        piButtons[16] = (JoyInfo.dwButtons & JOY_BUTTON17) ? 1 : 0;
        piButtons[17] = (JoyInfo.dwButtons & JOY_BUTTON18) ? 1 : 0;
        piButtons[18] = (JoyInfo.dwButtons & JOY_BUTTON19) ? 1 : 0;
        piButtons[19] = (JoyInfo.dwButtons & JOY_BUTTON20) ? 1 : 0;
        piButtons[20] = (JoyInfo.dwButtons & JOY_BUTTON21) ? 1 : 0;
        piButtons[21] = (JoyInfo.dwButtons & JOY_BUTTON22) ? 1 : 0;
        piButtons[22] = (JoyInfo.dwButtons & JOY_BUTTON23) ? 1 : 0;
        piButtons[23] = (JoyInfo.dwButtons & JOY_BUTTON24) ? 1 : 0;
        piButtons[24] = (JoyInfo.dwButtons & JOY_BUTTON25) ? 1 : 0;
        piButtons[25] = (JoyInfo.dwButtons & JOY_BUTTON26) ? 1 : 0;
        piButtons[26] = (JoyInfo.dwButtons & JOY_BUTTON27) ? 1 : 0;
        piButtons[27] = (JoyInfo.dwButtons & JOY_BUTTON28) ? 1 : 0;
        piButtons[28] = (JoyInfo.dwButtons & JOY_BUTTON29) ? 1 : 0;
        piButtons[29] = (JoyInfo.dwButtons & JOY_BUTTON30) ? 1 : 0;
        piButtons[30] = (JoyInfo.dwButtons & JOY_BUTTON31) ? 1 : 0;
        piButtons[31] = (JoyInfo.dwButtons & JOY_BUTTON32) ? 1 : 0;

        /* output POV */
        if (JoyInfo.dwPOV != JOY_POVCENTERED) {
            *piPOV=JoyInfo.dwPOV/100;
        }
        else {
            *piPOV=7;
        }
    }
}

#elif defined(__linux__)

#include <stdio.h>
#include <sys/time.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/joystick.h>
#include <errno.h>

#define MDD_MAX_BUTTONS (32)

/** Joystick object */
typedef struct {
    int fd;
    int nAxis;
    int nButtons;
    int nMaxButtons;
    int* axis;
    char* button;
    char deviceName[80];
} MDDJoystick;

void* MDD_joystickConstructor(int iJSID) {
    MDDJoystick* js = (MDDJoystick*) calloc(sizeof(MDDJoystick), 1);
    if (js) {
        js->fd = open("/dev/input/js0", O_RDONLY);
        if (js->fd == -1) { /* Failed. OK, try another device */
            js->fd = open("/dev/js0", O_RDONLY);
        }
        if (js->fd == -1) { /* Failed again, giving up */
            ModelicaError("MDDJoystick.h: Neither could open /dev/input/js0, nor /dev/js0. Have the required privileges?\n");
        }

        ioctl(js->fd, JSIOCGAXES, &js->nAxis);
        ioctl(js->fd, JSIOCGBUTTONS, &js->nButtons);
        ioctl(js->fd, JSIOCGNAME(80), js->deviceName);

        js->axis = (int *) calloc( js->nAxis, sizeof( int ) );
        js->button = (char *) calloc( js->nButtons, sizeof( char ) );

        ModelicaFormatMessage("Found joystick: %s\n\taxis: %d, buttons: %d\n",
                              js->deviceName, js->nAxis, js->nButtons);

        /* use non-blocking mode */
        fcntl( js->fd, F_SETFL, O_NONBLOCK );

        js->nMaxButtons = (js->nButtons > MDD_MAX_BUTTONS) ? MDD_MAX_BUTTONS : js->nButtons;
    }
    return (void*) js;
}

void MDD_joystickDestructor(void* jsObj) {
    MDDJoystick* js = (MDDJoystick*) jsObj;
    if (js) {
        free(js->axis);
        free(js->button);
        free(js);
    }
}

void MDD_joystickGetData(void* jsObj, double * pdAxes, int * piButtons, int * piPOV) {
    int i;
    MDDJoystick* js = (MDDJoystick*) jsObj;
    if (js) {
        struct js_event jse;

        while (read(js->fd, &jse, sizeof(struct js_event)) == sizeof(struct js_event)) {
            /*printf("Event: type %d, time %d, number %d, value %d\n",
            jse.type, jse.time, jse.number, jse.value);*/
            switch (jse.type & ~JS_EVENT_INIT) {
                case JS_EVENT_AXIS:
                    js->axis[jse.number] = jse.value;
                    break;
                case JS_EVENT_BUTTON:
                    js->button[jse.number] = jse.value;
                    break;
            }
        }

        if (errno != EAGAIN) {
            ModelicaError("MDDJoystick.h: error reading\n");
        }

        /* output axes (default to 0): */
        for (i = 0; i < 6; i++) {
            pdAxes[i] = js->nAxis >= i ? (double) js->axis[i] : 0;
        }

        /* output buttons (default to 0): */
        for (i = 0; i < js->nMaxButtons; i++) {
            piButtons[i] = js->button[i];
        }
        for (i = js->nButtons; i < MDD_MAX_BUTTONS; i++) {
            piButtons[i] = 0;
        }
    }
    else {
        /* output axes (default to 0): */
        for (i = 0; i < 6; i++) {
            pdAxes[i] = 0;
        }

        /* output buttons (default to 0): */
        for (i = 0; i < MDD_MAX_BUTTONS; i++) {
            piButtons[i] = 0;
        }
    }

    /* output POV */
    *piPOV=7;
}

#else

#error "Modelica_DeviceDrivers: No support of MDDJoystick for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDJOYSTICK_H_ */
