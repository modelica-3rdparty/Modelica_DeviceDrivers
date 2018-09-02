/** MAC address utility functions (header-only library).
 *
 * @file
 * @author      tbeu
 * @since       2018-08-29
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 * Little handy functions offered in the Utilities package.
 */

#ifndef MDDUTILITIESMAC_H_
#define MDDUTILITIESMAC_H_

#if !defined(ITI_COMP_SIM)

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__CYGWIN__)

#ifndef WINVER
#define WINVER 0x0501
#endif
#include <winsock2.h>
#include <IPHlpApi.h>

#pragma comment( lib, "IPHlpApi.lib" )

#elif defined(__linux__)

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netdb.h>

#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__MINGW32__) || defined(__CYGWIN__)

DllExport const char* MDD_utilitiesGetMACAddress(int idx) {
    PIP_ADAPTER_ADDRESSES pAddresses = NULL;
    ULONG outBufLen = 0;
    int i = 0;
    DWORD rc;

    do {
        pAddresses = (IP_ADAPTER_ADDRESSES *) malloc(outBufLen);
        if (NULL == pAddresses) {
            ModelicaError("MDDUtilitiesMAC.h: Memory allocation failed for IP_ADAPTER_ADDRESSES struct\n");
        }
        rc = GetAdaptersAddresses(AF_UNSPEC, GAA_FLAG_INCLUDE_PREFIX, NULL, pAddresses, &outBufLen);
        if (ERROR_BUFFER_OVERFLOW == rc) {
            free(pAddresses);
            pAddresses = NULL;
        }
        else {
            break;
        }
        i++;
    } while (ERROR_BUFFER_OVERFLOW == rc && i < 3);

    if (NO_ERROR == rc) {
        PIP_ADAPTER_ADDRESSES pAddress = pAddresses;
        i = 1;
        while (i < idx && NULL != pAddress->Next) {
            pAddress = pAddress->Next;
            i++;
        }
        if (i == idx) {
            if (0 != pAddress->PhysicalAddressLength) {
                char* ret = ModelicaAllocateStringWithErrorReturn(3*pAddress->PhysicalAddressLength);
                if (NULL != ret) {
                    ret[0] = '\0';
                    for (i = 0; i < (int) pAddress->PhysicalAddressLength; ++i) {
                        char buf[4];
                        if (i == pAddress->PhysicalAddressLength - 1) {
                            sprintf(buf, "%.2X", (int) pAddress->PhysicalAddress[i]);
                        }
                        else {
                            sprintf(buf, "%.2X-", (int) pAddress->PhysicalAddress[i]);
                        }
                        strncat(ret, buf, 3);
                    }
                    free(pAddresses);
                    return (const char*)ret;
                }
                else {
                    free(pAddresses);
                    ModelicaError("MDDUtilitiesMAC.h: ModelicaAllocateString failed\n");
                    return "";
                }
            }
        }
        free(pAddresses);
    }
    else {
        if (pAddresses) {
            free(pAddresses);
        }
        ModelicaFormatError("MDDUtilitiesMAC.h: Call to GetAdaptersAddresses failed with error code: %lu\n", rc);
    }

    return "";
}

#elif defined(__linux__)

const char* MDD_utilitiesGetMACAddress(int idx) {
    struct ifreq s;
    int fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);

    strcpy(s.ifr_name, "eth0");
    if (0 == ioctl(fd, SIOCGIFHWADDR, &s)) {
        char* ret = ModelicaAllocateStringWithErrorReturn(18);
        if (NULL != ret) {
            int i;
            ret[0] = '\0';
            for (i = 0; i < 6; ++i) {
                char buf[4];
                if (i == 5) {
                    snprintf(buf, 4, "%.2X", (int) s.ifr_addr.sa_data[i]);
                }
                else {
                    snprintf(buf, 4, "%.2X-", (int) s.ifr_addr.sa_data[i]);
                }
                strncat(ret, buf, 3);
            }
            close(fd);
            return (const char*)ret;
        }
        else {
            close(fd);
            ModelicaError("MDDUtilitiesMAC.h: ModelicaAllocateString failed\n");
            return "";
        }
    }
    close(fd);

    return "";
}

#else

#error "Modelica_DeviceDrivers: No support of MAC address retrieval for your platform"

#endif

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDUTILITIESMAC_H_ */
