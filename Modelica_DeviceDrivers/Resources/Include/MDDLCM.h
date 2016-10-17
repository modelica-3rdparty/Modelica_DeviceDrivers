/** LCM support (header-only library).
 *
 * @file
 * @author tbeu
 * @since 2016-05-05
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 */

#ifndef MDDLCM_H_
#define MDDLCM_H_

#if !defined(ITI_COMP_SIM)

#include <stdlib.h>
#include <stdio.h>
#if defined(_MSC_VER) && _MSC_VER < 1900
#define snprintf _snprintf
#endif
#include "../src/include/CompatibilityDefs.h"
#include "../thirdParty/lcm/include/lcm/lcm.h"
#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

typedef struct {
    lcm_t* lcm;
    lcm_subscription_t* s; /**< handler subscription (only relevant for read lcm) */
    void* pkg; /**< pointer to SerialPackager (only relevant for read lcm) */
} LCM;

static void MDD_lcmHandler(const lcm_recv_buf_t* buf, const char* channel, void* p_lcm) {
    LCM* lcm = (LCM*) p_lcm;
    if (NULL != lcm) {
        if (NULL != lcm->pkg) {
            int rc = MDD_SerialPackagerSetDataWithErrorReturn(lcm->pkg,
                buf->data, buf->data_size);
            if (rc) {
               ModelicaError("MDDLCM.h: MDD_SerialPackagerSetData failed. "
                   "Buffer overflow.\n");
            }
        }
        else {
            char* lcmBuf = ModelicaAllocateStringWithErrorReturn(buf->data_size);
            if (NULL != lcmBuf) {
                memcpy(lcmBuf, buf->data, buf->data_size);
                lcm->pkg = lcmBuf;
            }
        }
    }
}

DllExport void * MDD_lcmConstructor(const char* provider, const char* address,
                                    int port, int receiver, const char* receiveChannel,
                                    int receiveBufferSize, int maxQueueSize) {
    LCM* lcm = (LCM*) calloc(1, sizeof(LCM));
    if (NULL != lcm) {
        char url[201];
        if (0 == strcmp("udpm://", provider)) {
            /* UDP multicast */
            if (receiver && receiveBufferSize > 0) {
                snprintf(url, 200, "udpm://%s:%d?recv_buf_size=%d", address,
                    port, receiveBufferSize);
            }
            else {
                snprintf(url, 200, "udpm://%s:%d", address, port);
            }
        }
        else if (0 == strcmp("file://", provider)) {
            /* Logfile */
            if (receiver) {
                snprintf(url, 200, "file://%s?mode=r", address);
            }
            else {
                snprintf(url, 200, "file://%s?mode=w", address);
            }
        }
        else if (0 == strcmp("memq://", provider)) {
            /* Memory queue */
            strcpy(url, "memq://");
        }
        else {
            free(lcm);
            lcm = NULL;
            ModelicaFormatError("MDDLCM.h: Invalid LCM network provider \"%s\"\n", provider);
        }
        lcm->lcm = lcm_create(url);
        if (NULL != lcm->lcm) {
            if (receiver) {
                if (strlen(receiveChannel) <= LCM_MAX_CHANNEL_NAME_LENGTH) {
                    lcm->s = lcm_subscribe(lcm->lcm, receiveChannel, MDD_lcmHandler, lcm);
                    if (NULL != lcm->s) {
                        lcm_subscription_set_queue_capacity(lcm->s, maxQueueSize);
                    }
                    else {
                        lcm_destroy(lcm->lcm);
                        free(lcm);
                        lcm = NULL;
                        ModelicaFormatError("MDDLCM.h: Could not subscribe callback "
                            "function to receiver channel \"%s\"\n", receiveChannel);
                    }
                }
                else {
                    lcm_destroy(lcm->lcm);
                    free(lcm);
                    lcm = NULL;
                    ModelicaFormatError("MDDLCM.h: Channel name \"%s\" exceeds the maximal "
                        "channel name length (%u)\n", receiveChannel, LCM_MAX_CHANNEL_NAME_LENGTH);
                }
            }
        }
        else {
            free(lcm);
            lcm = NULL;
            ModelicaFormatError("MDDLCM.h: Could not allocate LCM object for "
                "network provider \"%s\"\n", provider);
        }
    }
    return (void*) lcm;
}

DllExport void MDD_lcmDestructor(void* p_lcm) {
    LCM* lcm = (LCM*) p_lcm;
    if (NULL != lcm) {
        if (NULL != lcm->s) {
            lcm_unsubscribe(lcm->lcm, lcm->s);
        }
        lcm_destroy(lcm->lcm);
        free(lcm);
    }
}

DllExport void MDD_lcmSend(void* p_lcm, const char* channel, const char* data, int dataSize) {
    LCM* lcm = (LCM*) p_lcm;
    if (NULL != lcm) {
        if (strlen(channel) <= LCM_MAX_CHANNEL_NAME_LENGTH) {
            int rc = lcm_publish(lcm->lcm, channel, data, (unsigned int)dataSize);
            if (rc == -1) {
                ModelicaError("MDDLCM.h: lcm_publish failed\n");
            }
        }
        else {
            ModelicaFormatError("MDDLCM.h: Channel name \"%s\" exceeds the maximal "
                "channel name length (%u)\n", channel, LCM_MAX_CHANNEL_NAME_LENGTH);
        }
    }
}

DllExport void MDD_lcmSendP(void * p_lcm, const char* channel, void* p_package, int dataSize) {
    MDD_lcmSend(p_lcm, channel, MDD_SerialPackagerGetData(p_package), dataSize);
}

DllExport const char * MDD_lcmRead(void * p_lcm) {
    LCM* lcm = (LCM*) p_lcm;
    if (NULL != lcm) {
        int rc;
        lcm->pkg = NULL;
        rc = lcm_handle_timeout(lcm->lcm, 0);
        if (rc < 0) {
            ModelicaError("MDDLCM.h: lcm_handle_timeout failed\n");
        }
        if (NULL != lcm->pkg) {
            return (const char*) lcm->pkg;
        }
    }
    return "";
}

DllExport void MDD_lcmReadP(void * p_lcm, void* p_package) {
    LCM* lcm = (LCM*) p_lcm;
    if (NULL != lcm) {
        int rc;
        MDD_SerialPackagerSetPos(p_package, 0);
        lcm->pkg = p_package;
        rc = lcm_handle_timeout(lcm->lcm, 0);
        if (rc < 0) {
            ModelicaError("MDDLCM.h: lcm_handle_timeout failed\n");
        }
    }
}

DllExport const char* MDD_lcmGetVersion(void * p_lcm) {
    char* buf = ModelicaAllocateString(60);
    snprintf(buf, 60, "%d.%d.%d", LCM_MAJOR_VERSION, LCM_MINOR_VERSION,
        LCM_MICRO_VERSION);
    return (const char*) buf;
}

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDLCM_H_ */
