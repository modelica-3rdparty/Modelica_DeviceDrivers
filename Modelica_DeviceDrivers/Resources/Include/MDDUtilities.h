/** Utility functions (header-only library).
 *
 * @file
 * @author		tbellmann
 * @author    tbeu
 * @since		2013-05-24
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 * Little handy functions offered in the Utilities package.
 */

#ifndef MDDUTILITIES_H_
#define MDDUTILITIES_H_

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

DllExport double MDD_utilitiesLoadRealParameter(const char * file, const char * name) {
    FILE * pFile;
    char line[512];
    double u;
    pFile = fopen (file,"r");

    //file existent?
    if (pFile==NULL) {
        ModelicaFormatError("MDDUtilities.h: Could not open file %s.\n",file);
    }

    //read every line of file one after another:
    while(fgets (line , 512 , pFile) != NULL ) {

        //find the name of the variable in string
        char * namePos = strstr (line,name);

        //if variable name found and the next character after the name is a space, tabulator or = then it is a valid name.
        if(namePos && (namePos[strlen(name)] == ' ' || namePos[strlen(name)] == '=' || namePos[strlen(name)] == '\t')) {

            //find the =
            namePos=strchr(namePos+1,'=');

            if(namePos) {
                u = atof(namePos+1);
                fclose (pFile);
                return u;

            }
        }

    }

    fclose (pFile);
    ModelicaFormatError("MDDUtilities.h: Parameter name not found: %s",name);
    return 0;
}

#if defined(_MSC_VER) || defined(__MINGW32__)

DllExport const char* MDD_generateUUID(void) {
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
                ModelicaError("MDDUtilities.h: ModelicaAllocateString failed\n");
            }
        }
    }
    return "";
}

#elif defined(__linux__) || defined(__CYGWIN__)

const char* MDD_generateUUID(void) {
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

#endif /* MDDUTILITIES_H_ */
