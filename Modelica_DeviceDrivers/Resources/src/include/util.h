/** Little utility functions.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-06
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 */

#ifndef MDD_UTIL_H_
#define MDD_UTIL_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <string.h>
const char* MDD_utilitiesGetLastFileName(const char* pathname) {
    const char * pch1 = strrchr(pathname, '/');
    const char * pch2 = strrchr(pathname, '\\');
    size_t pos_ch1 = pch1 != NULL ? pch1 - pathname + 1 : 0;
    size_t pos_ch2 = pch2 != NULL ? pch2 - pathname + 1 : 0;
    return pos_ch1 == 0 && pos_ch2 == 0 ? pathname : pos_ch1 > pos_ch2 ? pch1 + 1 : pch2 + 1;
}
#define MDD_FILE() MDD_utilitiesGetLastFileName(__FILE__)


#if defined(_MSC_VER) || defined(__MINGW32__)

#include <windows.h>
#include "CompatibilityDefs.h"
/** Sleep for some milliseconds
*
* @param ms  milliseconds to sleep
*/
void MDD_msleep(unsigned long ms) {
    Sleep(ms);
}

#else
#include <unistd.h>
#include "CompatibilityDefs.h"

void MDD_msleep(unsigned long ms) {
    usleep(ms*1000);
}

#endif /* _MSC_VER */


#ifdef __cplusplus
}
#endif

#endif /* MDD_UTIL_H_ */
