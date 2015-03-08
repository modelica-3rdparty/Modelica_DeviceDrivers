/** Little utility functions.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @since       2012-06-06
 * @copyright Modelica License 2
 *
 */

#ifndef UTIL_H_
#define UTIL_H_

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_MSC_VER)

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
