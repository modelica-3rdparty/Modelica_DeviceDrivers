/** Support of joysticks and alike (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version	$Id: MDDJoystick.h 15734 2012-06-06 17:58:52Z thie_be $
 * @since		2012-05-25
 * @copyright Modelica License 2
 * @remark The Linux implementation mimics the interface of the windows version, that's
 *         why it is somewhat odd.
*/

#ifndef MDDJOYSTICK_H_
#define MDDJOYSTICK_H_

#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

#include <windows.h>
#include "../src/include/CompatibilityDefs.h"
#pragma comment( lib, "Winmm.lib" )

/** Get data from joystick device.
 * @remark The linux implementation must have the interface of the windows version, that's
 *         why its implementation might seem somewhat odd. The @iJSID argument has no effect
 *         in linux. Actually we should hand in the string of the device file in linux. Since
 *         we do not, we just guess.
 * @warning Don't know how to get POV in linux, defaulting to 7 in linux.
 */
DllExport void MDD_joystickGetData(int iJSID,double * pdAxes, int * piButtons, int * piPOV) {
    JOYINFOEX JoyInfo; /* joystick data structure */
    JoyInfo.dwFlags = JOY_RETURNALL;
    JoyInfo.dwSize = sizeof(JOYINFOEX);

    /* load data from joystick into data structure */
    joyGetPosEx(iJSID,&JoyInfo);


    /* output axes: */
    pdAxes[0] = (double)JoyInfo.dwXpos;
    pdAxes[1] = (double)JoyInfo.dwYpos;
    pdAxes[2] = (double)JoyInfo.dwZpos;
    pdAxes[3] = (double)JoyInfo.dwRpos;
    pdAxes[4] = (double)JoyInfo.dwUpos;
    pdAxes[5] = (double)JoyInfo.dwVpos;

    /* output buttons: */
    if(JoyInfo.dwButtons&1) {
        piButtons[0] = 1;
    }
    else {
        piButtons[0] = 0;
    }
    if(JoyInfo.dwButtons&2) {
        piButtons[1] = 1;
    }
    else {
        piButtons[1] = 0;
    }
    if(JoyInfo.dwButtons&4) {
        piButtons[2] = 1;
    }
    else {
        piButtons[2] = 0;
    }
    if(JoyInfo.dwButtons&8) {
        piButtons[3] = 1;
    }
    else {
        piButtons[3] = 0;
    }
    if(JoyInfo.dwButtons&16) {
        piButtons[4] = 1;
    }
    else {
        piButtons[4] = 0;
    }
    if(JoyInfo.dwButtons&32) {
        piButtons[5] = 1;
    }
    else {
        piButtons[5] = 0;
    }
    if(JoyInfo.dwButtons&64) {
        piButtons[6] = 1;
    }
    else {
        piButtons[6] = 0;
    }
    if(JoyInfo.dwButtons&128) {
        piButtons[7] = 1;
    }
    else {
        piButtons[7] = 0;
    }
    /* output POV */
    if(JoyInfo.dwPOV != JOY_POVCENTERED) {
        *piPOV=JoyInfo.dwPOV/100;
    }
    else {
        *piPOV=7;
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


void MDD_joystickGetData(int iJSID,double * pdAxes, int * piButtons, int * piPOV) {
    /* Need some global variables to save away the state: */
    static int initialized=0, fd=0, *axis=NULL, nAxis=0, nButtons=0;
    static char *button = NULL;
    static char deviceName[80]="";

    struct js_event js;
    int i;

    if (!initialized) {
        fd = open("/dev/input/js0", O_RDONLY);
        if (fd == -1) { /* Failed. OK, try another device */
            fd = open("/dev/js0", O_RDONLY);
        }
        if (fd == -1) { /* Failed again, giving up */
            ModelicaError("MDDJoystic: Neither could open /dev/input/js0, nor /dev/js0. Have the required privileges?\n");
        }

        ioctl(fd, JSIOCGAXES, &nAxis);
        ioctl(fd, JSIOCGBUTTONS, &nButtons);
        ioctl(fd, JSIOCGNAME(80), deviceName);

        axis = (int *) calloc( nAxis, sizeof( int ) );
        button = (char *) calloc( nButtons, sizeof( char ) );

        ModelicaFormatMessage("Found joystick: %s\n\taxis: %d, buttons: %d\n",
                              deviceName, nAxis, nButtons);

        /* use non-blocking mode */
        fcntl( fd, F_SETFL, O_NONBLOCK );
        initialized = 1;
    }

    while (read(fd, &js, sizeof(struct js_event)) == sizeof(struct js_event)) {
        /*printf("Event: type %d, time %d, number %d, value %d\n",
        js.type, js.time, js.number, js.value);*/
        switch (js.type & ~JS_EVENT_INIT) {
            case JS_EVENT_AXIS:
                axis[js.number] = js.value;
                break;
            case JS_EVENT_BUTTON:
                button[js.number] = js.value;
                break;
        }
    }

    if (errno != EAGAIN) {
        ModelicaError("\nMDDJoystic: error reading\n");
    }

    /* output axes (default to 0): */
    for (i = 0; i < 6; i++) {
        pdAxes[i] = nAxis >= i ? (double) axis[i] : 0;
    }

    /* output buttons (default to 0): */
    for (i = 0; i < 8; i++) {
        piButtons[i] = nButtons >= i ? button[i] : 0;
    }

    /* output POV */
    *piPOV=7;
}


#else

#error "Modelica_DeviceDrivers: No support of MDD_joystickGetData(..) for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDJOYSTICK_H_ */
