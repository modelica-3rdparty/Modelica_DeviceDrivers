/** Functions which provide an interface to some handy OS calls  (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de>
 * @since		2014-04-13
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * Little handy functions offered in the OperatingSystem package.
 */

#ifndef MDDOPERATINGSYSTEM_H_
#define MDDOPERATINGSYSTEM_H_

#if !defined(ITI_COMP_SIM)

#include <stdlib.h>
#include <time.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

DllExport double MDD_OS_getRandomNumberDouble(double minValue, double maxValue) {
    static int _randomGeneratorInitialized = 0;
    int randomInteger;
    double randomDouble;
    if(!_randomGeneratorInitialized) {
        srand ( (unsigned int)(clock() * time(NULL)) );
        _randomGeneratorInitialized = 1;
    }
    randomInteger = rand();
    randomDouble = ((double)randomInteger/(double)RAND_MAX) * (maxValue - minValue) + minValue;
    return randomDouble;
}

#if defined(_MSC_VER)
#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
DllExport void MDD_OS_Sleep(double sleepingTime) {

    int time_ms = (int)(sleepingTime*1000);
    Sleep(time_ms);

}
#else
#include <unistd.h>
void MDD_OS_Sleep(double sleepingTime) {
    sleep((int)sleepingTime);
}
#endif /* _MSC_VER */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDOPERATINGSYSTEM_H_ */
