/** 3Dconnexion Space mouse support.
 *
 * @file
 * @author      tbellmann (Windows)
 * @author      bernhard-thiele (Linux)
 * @since       2012-06-05
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
*/

#ifndef MDDSPACEMOUSE_H_
#define MDDSPACEMOUSE_H_

#if !defined(ITI_COMP_SIM)

#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

/** Get space mouse data
* @param[out] pdAxes array with 6 elements (value range [-1 1])
* @param[out] piButtons array with 16 elements
*/
DllExport void MDD_spaceMouseGetData(double * pdAxes, int * piButtons);

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDSPACEMOUSE_H_ */
