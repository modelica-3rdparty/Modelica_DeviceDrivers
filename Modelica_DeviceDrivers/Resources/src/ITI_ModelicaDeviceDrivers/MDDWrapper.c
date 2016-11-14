/** DLLWrapper library - Library wrapping most of the device driver interface functions into one dynamic link library.
 *
 * @file
 * @author	bernhard-thiele
 * @since		2014-04-11
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 * Most of the time external C code is directly "injected" into
 * the Modelica library by just including C headers that already
 * contain all the source code (header-only style).
 *
 * However, this approach is not supported by all tools. Some tools need to load an
 * DLL which provides the respective functions.
 *
 * This file just includes most (but not all) of the provided header-only files
 * in order to wrap them into one DLL.
 *
 * In the moment, some files have been omitted, since they might require some extra considerations.
 *
*/

#define ITI_MDD
#include "../../Include/MDDBeep.h"
#include "../../Include/MDDJoystick.h"
#include "../../Include/MDDKeyboard.h"
#include "../../Include/MDDOperatingSystem.h"
#include "../../Include/MDDRealtimeSynchronize.h"
#include "../../Include/MDDSerialPackager.h"
#include "../../Include/MDDSerialPort.h"
#include "../../Include/MDDSharedMemory.h"
#include "../../Include/MDDUDPSocket.h"
#include "../../Include/MDDUtilities.h"
#include "../../Include/MDDTCPIPSocket.h"
#undef ITI_MDD
