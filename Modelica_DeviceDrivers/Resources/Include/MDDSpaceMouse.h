/** 3Dconnexion Space mouse support.
 *
 * @file
 * @author      Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version     $Id: MDDSpaceMouse.h 15830 2012-06-18 08:07:26Z thie_be $
 * @since       2012-06-05
 * @copyright Modelica License 2
 *
 *
*/

#ifndef MDDSPACEMOUSE_H_
#define MDDSPACEMOUSE_H_

#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

/** Get space mouse data
* @param[out] pdAxes array with 6 elements (value range [-1 1])
* @param[out] piButtons array with 16 elements
*/
DllExport void MDD_spaceMouseGetData(double * pdAxes, int * piButtons);


#endif /* MDDSPACEMOUSE_H_ */
