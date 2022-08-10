/** MAC address utility functions (header-only library).
 *
 * @file
 * @author      tbeu
 * @since       2018-08-29
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * Little handy functions offered in the Utilities package.
 */

#ifndef MDDUTILITIESMAC_H_
#define MDDUTILITIESMAC_H_

#if !defined(ITI_COMP_SIM)

#if defined(_MSC_VER) || defined(__MINGW32__)

#ifndef WINVER
#define WINVER 0x0501
#endif
#include <winsock2.h>
#include <IPHlpApi.h>

#pragma comment( lib, "IPHlpApi.lib" )

#elif defined(__linux__) || defined(__CYGWIN__)

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netdb.h>
#include <errno.h>

#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__MINGW32__)

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
                            sprintf(buf, "%.2X", (unsigned char) pAddress->PhysicalAddress[i]);
                        }
                        else {
                            sprintf(buf, "%.2X-", (unsigned char) pAddress->PhysicalAddress[i]);
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

#elif defined(__linux__) || defined(__CYGWIN__)

#include <stdio.h>
#include <string.h>
#include <ifaddrs.h>
#include <netpacket/packet.h>

/* Adapted https://stackoverflow.com/a/35242525 */
const char* MDD_utilitiesGetMACAddress(int idx) {
    struct ifaddrs *ifaddr=NULL;
    struct ifaddrs *ifa = NULL;
    int i = 0;
    int n = 0;
    char cbuf[1024];

    if (getifaddrs(&ifaddr) == -1) {
        ModelicaFormatError("MDDUtilitiesMAC.h: getifaddrs() failed (%s)\n", strerror(errno));
    }
    else {
        for ( ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
            if ( (ifa->ifa_addr) && (ifa->ifa_addr->sa_family == AF_PACKET) ) {
                struct sockaddr_ll *s = (struct sockaddr_ll*)ifa->ifa_addr;
                /* ModelicaFormatMessage("%-8s ", ifa->ifa_name); */
                if (strcmp("lo", ifa->ifa_name) == 0) {
                    /* Skip loopback device */
                    continue;
                }
                else {
                    n++;
                }
                if (n == idx) {
                    char* ret = ModelicaAllocateStringWithErrorReturn(180);
                    if (NULL != ret) {
                        ret[0] = '\0';
                        for (i=0; i <s->sll_halen; i++) {
                            sprintf(ret + (3*i), "%02x%c", (s->sll_addr[i]), (i+1!=s->sll_halen)?'-':'\0');
                        }
                        return (const char*)ret;
                    }
                    else {
                        ModelicaError("MDDUtilitiesMAC.h: ModelicaAllocateString() failed\n");
                        return "";
                    }
                }
            }
        }
        freeifaddrs(ifaddr);
    }
    return "";
}



#else

#error "Modelica_DeviceDrivers: No support of MAC address retrieval for your platform"

#endif

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDUTILITIESMAC_H_ */
