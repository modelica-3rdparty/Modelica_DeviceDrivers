/** MQTT client support (header-only library).
 *
 * @file
 * @author    tbeu
 * @since     2018-08-13
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 */

#ifndef MDDMQTT_H_
#define MDDMQTT_H_

#if !defined(ITI_COMP_SIM)

#include <stdlib.h>
#include <stdio.h>
#if defined(_MSC_VER) && _MSC_VER < 1900
#define snprintf _snprintf
#endif
#if defined(_MSC_VER) || defined(__MINGW32__)
#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#endif
#include "../src/include/CompatibilityDefs.h"
#include "../thirdParty/paho.mqtt.c/MQTTClient.h"
#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

#if defined(__linux__) || defined(__CYGWIN__)
#include <errno.h>
#include <pthread.h>
#endif

#define MDD_SSL_ERROR_MSG_LENGTH_MAX (512)

typedef struct {
    MQTTClient* client;
    char* receiveBuffer;
    char* receiveChannel;
    char sslErrorMsg[MDD_SSL_ERROR_MSG_LENGTH_MAX];
    int bufferSize;
    int nReceivedBytes;
    int QoS;
    int disconnectTimeout;
#if defined(_MSC_VER) || defined(__MINGW32__)
    CRITICAL_SECTION lock;
#elif defined(__linux__) || defined(__CYGWIN__)
    pthread_mutex_t mutex;
#else
#warning "No thread syncronization available for your platform"
#endif
} MQTT;

static int MDD_mqttSSLErrorHandler(const char *str, size_t len, void *p_mqtt) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
#if defined(_MSC_VER) || defined(__MINGW32__)
        EnterCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_lock(&mqtt->mutex);
#endif
        if (NULL == strstr(mqtt->sslErrorMsg, str) && strlen(mqtt->sslErrorMsg) + len + 1 < MDD_SSL_ERROR_MSG_LENGTH_MAX) {
            strcat(mqtt->sslErrorMsg, str);
            strcat(mqtt->sslErrorMsg, "\n");
        }
#if defined(_MSC_VER) || defined(__MINGW32__)
        LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_unlock(&mqtt->mutex);
#endif
    }
    return 1;
}

static int MDD_mqttMsgArrivedHandler(void* p_mqtt, char* channel, int len, MQTTClient_message* message) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
#if defined(_MSC_VER) || defined(__MINGW32__)
        EnterCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_lock(&mqtt->mutex);
#endif
        if (message->payloadlen <= mqtt->bufferSize) {
            memcpy(mqtt->receiveBuffer, message->payload, message->payloadlen);
            mqtt->nReceivedBytes = message->payloadlen;
        }
        if (message->payloadlen < mqtt->bufferSize) {
            mqtt->receiveBuffer[message->payloadlen] = '\0';
        }
#if defined(_MSC_VER) || defined(__MINGW32__)
        LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_unlock(&mqtt->mutex);
#endif
    }
    MQTTClient_freeMessage(&message);
    MQTTClient_free(channel);
    return 1;
}

static void MDD_mqttDisconnectedHandler(void* p_mqtt, char* cause) {
#ifndef ITI_MDD
    ModelicaMessage("MDDMQTT.h: The MQTT client was disconnected\n");
#endif
}

static void MDD_mqttTraceHandler(enum MQTTCLIENT_TRACE_LEVELS level, char* message) {
    ModelicaFormatMessage("%s\n", message);
}

DllExport void * MDD_mqttConstructor(const char* provider, const char* address,
                                     int port, int receiver, int QoS,
                                     const char* channel, int bufferSize,
                                     const char* clientID, const char* userName,
                                     const char* password, const char* trustStore,
                                     const char* keyStore, const char* privateKey,
                                     int keepAliveInterval, int cleanSession,
                                     int reliable, int connectTimeout,
                                     int MQTTVersion, int disconnectTimeout,
                                     int enableServerCertAuth, int verify, int sslVersion,
                                     int traceLevel) {
    MQTT* mqtt = (MQTT*) calloc(1, sizeof(MQTT));
    if (NULL != mqtt) {
        int rc;
        char url[201];
        MQTTClient_SSLOptions ssl_opts = MQTTClient_SSLOptions_initializer;
        MQTTClient_SSLOptions* p_ssl_opts;
        char* receiveBuffer = NULL;
        char* receiveChannel = NULL;

        if (receiver) {
            receiveBuffer = (char*)calloc(bufferSize, 1);
            if (NULL == receiveBuffer) {
                free(mqtt);
                mqtt = NULL;
                ModelicaError("MDDMQTT.h: Could not allocate MQTT client receive buffer\n");
                return mqtt;
            }
            receiveChannel = (char*)malloc(strlen(channel) + 1);
            if (NULL == receiveChannel) {
                free(receiveBuffer);
                free(mqtt);
                mqtt = NULL;
                ModelicaError("MDDMQTT.h: Could not allocate MQTT client receive channel name\n");
                return mqtt;
            }
            strcpy(receiveChannel, channel);
        }

        snprintf(url, 200, "%s%s:%d", provider, address, port);
        if (0 == strcmp("ssl://", provider) || 0 == strcmp("wss://", provider)) {
            /* SSL/TLS */
            p_ssl_opts = &ssl_opts;
            ssl_opts.enableServerCertAuth = enableServerCertAuth;
            ssl_opts.verify = verify;
            ssl_opts.sslVersion = sslVersion;
            ssl_opts.ssl_error_cb = MDD_mqttSSLErrorHandler;
            ssl_opts.ssl_error_context = mqtt;
            if ('\0' != trustStore[0]) {
                ssl_opts.trustStore = trustStore;
            }
            if ('\0' != keyStore[0]) {
                ssl_opts.keyStore = keyStore;
            }
            if ('\0' != privateKey[0]) {
                ssl_opts.privateKey = privateKey;
            }
        }
        else {
            p_ssl_opts = NULL;
        }

        mqtt->client = (MQTTClient*) malloc(sizeof(MQTTClient));
        if (NULL == mqtt->client) {
            free(receiveBuffer);
            free(receiveChannel);
            free(mqtt);
            mqtt = NULL;
            ModelicaError("MDDMQTT.h: Could not allocate MQTT client object\n");
            return mqtt;
        }

        if (0 != traceLevel) {
            MQTTClient_setTraceLevel((enum MQTTCLIENT_TRACE_LEVELS) traceLevel);
            MQTTClient_setTraceCallback(MDD_mqttTraceHandler);
        }
        else {
            MQTTClient_setTraceCallback(NULL);
        }

        mqtt->bufferSize = bufferSize;
        mqtt->receiveBuffer = receiveBuffer;
        mqtt->receiveChannel = receiveChannel;
        mqtt->QoS = QoS;
        mqtt->disconnectTimeout = disconnectTimeout;
        rc = MQTTClient_create(mqtt->client, url, clientID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
        if (MQTTCLIENT_SUCCESS == rc) {
            MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
            conn_opts.keepAliveInterval = keepAliveInterval;
            conn_opts.cleansession = cleanSession;
            conn_opts.reliable = reliable;
            conn_opts.connectTimeout = connectTimeout;
            conn_opts.MQTTVersion = MQTTVersion;
            conn_opts.ssl = p_ssl_opts;
            if ('\0' != userName[0]) {
                conn_opts.username = userName;
            }
            if ('\0' != password[0]) {
                conn_opts.password = password;
            }
            if (receiver) {
                MQTTClient_setCallbacks(*mqtt->client, mqtt, MDD_mqttDisconnectedHandler, MDD_mqttMsgArrivedHandler, NULL);
            }
#if defined(_MSC_VER) || defined(__MINGW32__)
            InitializeCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
            int ret = pthread_mutex_init(&mqtt->mutex, NULL);
            if (ret != 0) {
                MQTTClient_destroy(mqtt->client);
                free(receiveBuffer);
                free(receiveChannel);
                free(mqtt);
                mqtt = NULL;
                ModelicaFormatError("MDDMQTT.h: pthread_mutex_init() failed (%s)\n", strerror(errno));
            }
#endif
            rc = MQTTClient_connect(*mqtt->client, &conn_opts);
            if (MQTTCLIENT_SUCCESS == rc) {
                if (receiver) {
                    rc = MQTTClient_subscribe(*mqtt->client, receiveChannel, QoS);
                }
            }
            else {
                const char* errString = rc != MQTTCLIENT_FAILURE ? MQTTClient_strerror(rc) : NULL;
                char msg[MDD_SSL_ERROR_MSG_LENGTH_MAX];
#if defined(_MSC_VER) || defined(__MINGW32__)
                EnterCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
                pthread_mutex_lock(&mqtt->mutex);
#endif
                strcpy(msg, mqtt->sslErrorMsg);
#if defined(_MSC_VER) || defined(__MINGW32__)
                LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
                pthread_mutex_unlock(&mqtt->mutex);
#endif
#if defined(_MSC_VER) || defined(__MINGW32__)
                DeleteCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
                pthread_mutex_destroy(&mqtt->mutex);
#endif
                MQTTClient_destroy(mqtt->client);
                free(receiveBuffer);
                free(receiveChannel);
                free(mqtt);
                mqtt = NULL;
                if (NULL != errString) {
                    ModelicaFormatError("MDDMQTT.h: Could not connect to server \"%s\" "
                        "with client ID \"%s\": %s\n", url, clientID, errString);
                }
                else if ('\0' != msg[0]) {
                    ModelicaFormatError("MDDMQTT.h: Could not connect to server \"%s\" "
                        "with client ID \"%s\":\n%s", url, clientID, msg);
                }
                else {
                    ModelicaFormatError("MDDMQTT.h: Could not connect to server \"%s\" "
                        "with client ID \"%s\"\n", url, clientID);
                }
            }
        }
        else {
            const char* errString = rc != MQTTCLIENT_FAILURE ? MQTTClient_strerror(rc) : NULL;
            free(receiveBuffer);
            free(receiveChannel);
            free(mqtt);
            mqtt = NULL;
            if (NULL != errString) {
                ModelicaFormatError("MDDMQTT.h: Could not create MQTT client object for "
                    "server \"%s\" with client ID \"%s\": %s\n", url, clientID, errString);
            }
            else {
                ModelicaFormatError("MDDMQTT.h: Could not create MQTT client object for "
                    "server \"%s\" with client ID \"%s\"\n", url, clientID);
            }
        }
    }
    return (void*) mqtt;
}

DllExport void MDD_mqttDestructor(void* p_mqtt) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
        if (NULL != mqtt->client) {
            if (NULL != mqtt->receiveChannel) {
                int rc = MQTTClient_unsubscribe(*mqtt->client, mqtt->receiveChannel);
                if (MQTTCLIENT_SUCCESS != rc) {
                    ModelicaFormatMessage("MDDMQTT.h: MQTTClient_unsubscribe() failed (%s)\n", strerror(errno));
                }
                free(mqtt->receiveBuffer);
                free(mqtt->receiveChannel);
            }
            MQTTClient_disconnect(*mqtt->client, 1000*mqtt->disconnectTimeout);
            MQTTClient_destroy(mqtt->client);
#if defined(_MSC_VER) || defined(__MINGW32__)
            DeleteCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
            if (0 != pthread_mutex_destroy(&mqtt->mutex)) {
                ModelicaFormatMessage("MDDMQTT.h: pthread_mutex_destroy() failed (%s)\n", strerror(errno));
            }
#endif
        }
        free(mqtt);
    }
}

DllExport void MDD_mqttSend(void* p_mqtt, const char* channel, const char* data, int retained, int deliveryTimeout, int dataSize) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
        int rc;
        MQTTClient_deliveryToken token;
        MQTTClient_message pubmsg = MQTTClient_message_initializer;
        pubmsg.payload = (void*)data;
        pubmsg.payloadlen = dataSize;
        pubmsg.qos = mqtt->QoS;
        pubmsg.retained = retained;

        rc = MQTTClient_publishMessage(*mqtt->client, channel, &pubmsg, &token);
        if (MQTTCLIENT_SUCCESS == rc) {
            if (0 < mqtt->QoS) {
                rc = MQTTClient_waitForCompletion(*mqtt->client, token, deliveryTimeout);
            }
        }
        else {
            const char* errString = rc != MQTTCLIENT_FAILURE ? MQTTClient_strerror(rc) : NULL;
            if (NULL != errString) {
                ModelicaFormatError("MDDMQTT.h: MQTTClient_publishMessage failed: %s\n", errString);
            }
            else {
                ModelicaError("MDDMQTT.h: MQTTClient_publishMessage failed\n");
            }
        }
    }
}

DllExport void MDD_mqttSendP(void * p_mqtt, const char* channel, void* p_package, int retained, int deliveryTimeout, int dataSize) {
    MDD_mqttSend(p_mqtt, channel, MDD_SerialPackagerGetData(p_package), retained, deliveryTimeout, dataSize);
}

DllExport const char* MDD_mqttRead(void* p_mqtt) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
        char* mqttBuf;
#if defined(_MSC_VER) || defined(__MINGW32__)
        EnterCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_lock(&mqtt->mutex);
#endif
        mqttBuf = ModelicaAllocateStringWithErrorReturn(mqtt->bufferSize);
        if (mqttBuf) {
            memcpy(mqttBuf, mqtt->receiveBuffer, mqtt->nReceivedBytes);
            if (mqtt->nReceivedBytes < mqtt->bufferSize) {
                /* Which strategy to use if the new data size is less than the old size, e.g., in case of disconnection? */
                /* Strategy: Return previous values */
                memcpy(mqttBuf + mqtt->nReceivedBytes, mqtt->receiveBuffer + mqtt->nReceivedBytes, mqtt->bufferSize - mqtt->nReceivedBytes);
            }
            mqtt->nReceivedBytes = 0;
#if defined(_MSC_VER) || defined(__MINGW32__)
            LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
            pthread_mutex_unlock(&mqtt->mutex);
#endif
            return (const char*) mqttBuf;
        }
        else {
#if defined(_MSC_VER) || defined(__MINGW32__)
            LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
            pthread_mutex_unlock(&mqtt->mutex);
#endif
            ModelicaError("MDDMQTT.h: ModelicaAllocateString failed\n");
        }
    }
    return "";
}

DllExport void MDD_mqttReadP(void* p_mqtt, void* p_package) {
    MQTT* mqtt = (MQTT*) p_mqtt;
    if (NULL != mqtt) {
        int rc;
#if defined(_MSC_VER) || defined(__MINGW32__)
        EnterCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_lock(&mqtt->mutex);
#endif
        rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, mqtt->receiveBuffer, mqtt->nReceivedBytes);
        mqtt->nReceivedBytes = 0;
#if defined(_MSC_VER) || defined(__MINGW32__)
        LeaveCriticalSection(&mqtt->lock);
#elif defined(__linux__) || defined(__CYGWIN__)
        pthread_mutex_unlock(&mqtt->mutex);
#endif
        if (rc) {
           ModelicaError("MDDMQTT.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
        }
    }
}

DllExport const char* MDD_mqttGetVersionInfo(void * p_mqtt) {
    MQTTClient_nameValue* verInfo = MQTTClient_getVersionInfo();
    if (NULL != verInfo) {
        const char* name = NULL;
        const char* ver = NULL;
        while (NULL != verInfo->name) {
            if (0 == strcmp(verInfo->name, "Product name")) {
                name = verInfo->value;
            }
            else if (0 == strcmp(verInfo->name, "Version")) {
                ver = verInfo->value;
            }
            verInfo++;
        }
        if (NULL != name && NULL != ver) {
            size_t len = strlen(name) + strlen(ver) + 1;
            char* buf = ModelicaAllocateString(len + 1);
            snprintf(buf, len + 1, "%s %s", name, ver);
            buf[len] = '\0';
            return (const char*) buf;
        }
    }
    return "";
}

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDMQTT_H_ */
