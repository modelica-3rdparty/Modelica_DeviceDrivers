/** Use system beep (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version	$Id: MDDBeep.h 15720 2012-06-05 21:32:39Z thie_be $
 * @since		2012-05-25
 * @copyright Modelica License 2
 */

#ifndef MDDBEEP_H_
#define MDDBEEP_H_

#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

  #include <windows.h>

  /** Raise system beep.
   *
   * @param[in] frequency the tone frequency
   * @param[in] duration (s) sound duration
   * @return Dummy return value
   */
  double MDD_beep(double frequency, double duration) {
    int freq = (int)frequency;
    int duration_ms = (int)(duration * 1000);
    Beep(freq,duration_ms);
    return 0;
  };

#elif defined(__linux__)

  #warning "MDD_beep(..) not necessarily working under linux (known bug)"

  #include <X11/Xlib.h>

  double MDD_beep(double frequency, double duration) {
    Display* display = XOpenDisplay(0);
    XKeyboardControl value;
    int ret;
    value.bell_percent = 50;
    value.bell_pitch = frequency;
    value.bell_duration = duration;

    ret = XChangeKeyboardControl(display, KBBellPercent | KBBellPitch | KBBellDuration, &value);
    if ( !ret )
      ModelicaFormatError("MDDBeep.h: XChangeKeyboardControl failed.\n");

    ret = XBell(display, 0);
    if ( !ret )
      ModelicaFormatError("MDDBeep.h: XBell failed.\n");
  }

#else

  #error "Modelica_DeviceDrivers: No support of MDD_beep(..) for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDBEEP_H_ */
