/** Little utility functions.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-06
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 */

#ifndef UTIL_H_
#define UTIL_H_

#ifdef __cplusplus
extern "C" {
#endif

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

#endif /* UTIL_H_ */
