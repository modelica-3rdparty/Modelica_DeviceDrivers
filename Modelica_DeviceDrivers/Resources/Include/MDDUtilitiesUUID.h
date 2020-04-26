/** UUID utility functions (header-only library).
 *
 * @file
 * @author      tbeu
 * @since       2018-08-29
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * Little handy functions offered in the Utilities package.
 */

#ifndef MDDUTILITIESUUID_H_
#define MDDUTILITIESUUID_H_

#if !defined(ITI_COMP_SIM)

#if defined(_MSC_VER) || defined(__MINGW32__)

#include <Rpc.h>

#pragma comment( lib, "Rpcrt4.lib" )

#elif defined(__linux__) || defined(__CYGWIN__)

#include <uuid/uuid.h>

#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__MINGW32__)

DllExport const char* MDD_utilitiesGenerateUUID(void) {
    UUID uuid;

    if (RPC_S_OK == UuidCreate(&uuid)) {
        unsigned char* str;
        if (RPC_S_OK == UuidToStringA(&uuid, &str)) {
            char* ret = ModelicaAllocateStringWithErrorReturn(strlen((const char*)str));
            if (NULL != ret) {
                strcpy(ret, (const char*)str);
                RpcStringFreeA(&str);
                return (const char*)ret;
            }
            else {
                RpcStringFreeA(&str);
                ModelicaError("MDDUtilitiesUUID.h: ModelicaAllocateString failed\n");
            }
        }
    }
    return "";
}

#elif defined(__linux__) || defined(__CYGWIN__)

const char* MDD_utilitiesGenerateUUID(void) {
    uuid_t uuid;
    char* ret = ModelicaAllocateString(36);
    uuid_generate_random(uuid);
    uuid_unparse(uuid, ret);
    return (const char*)ret;
}

#else

#error "Modelica_DeviceDrivers: No support of UUID generation for your platform"

#endif

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDUTILITIESUUID_H_ */
