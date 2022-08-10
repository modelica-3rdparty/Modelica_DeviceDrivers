/** Use system beep (header-only library).
 *
 * @file
 * @author		tbellmann (Windows)
 * @author		bernhard-thiele (Linux)
 * @since		2012-05-25
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 */

#ifndef MDDBEEP_H_
#define MDDBEEP_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include "../src/include/CompatibilityDefs.h"

/** Raise system beep.
 *
 * @param[in] frequency the tone frequency
 * @param[in] duration (s) sound duration
 * @return Dummy return value
 */
DllExport double MDD_beep(double frequency, double duration) {
    int freq = (int)frequency;
    int duration_ms = (int)(duration * 1000);
    Beep(freq,duration_ms);
    return 0;
}

#elif defined(__linux__)

#include "../src/include/CompatibilityDefs.h"
#include <X11/Xlib.h>
#warning "MDD_beep(..) not necessarily working under linux (known bug)"

double MDD_beep(double frequency, double duration) {
    Display* display = XOpenDisplay(0);
    XKeyboardControl value;
    int ret;
    value.bell_percent = 50;
    value.bell_pitch = frequency;
    value.bell_duration = duration;

    ret = XChangeKeyboardControl(display, KBBellPercent | KBBellPitch | KBBellDuration, &value);
    if ( !ret ) {
        ModelicaFormatError("MDDBeep.h: XChangeKeyboardControl failed.\n");
    }

    ret = XBell(display, 0);
    if ( !ret ) {
        ModelicaFormatError("MDDBeep.h: XBell failed.\n");
    }
}

#else

#error "Modelica_DeviceDrivers: No support of MDD_beep(..) for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDBEEP_H_ */
