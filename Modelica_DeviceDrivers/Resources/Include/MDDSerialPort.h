/** Serial port driver support (header-only library).
 *
 * @file
 * @author bernhard-thiele (Linux)
 * @author Dominik Sommer (Linux)
 * @author Rangarajan Varadan (Windows)
 * @author tbeu
 * @since 2012-05-29
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 */

#ifndef MDDSERIALPORT_H_
#define MDDSERIALPORT_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include "../src/include/CompatibilityDefs.h"

/** Serial port object */
typedef struct {
    HANDLE hComm;
    HANDLE hThread;
    int receiving;
    char* receiveBuffer;
    size_t bufferSize;
    DWORD receivedBytes;
    CRITICAL_SECTION receiveLock;
} MDDSerialPort;

DWORD WINAPI MDD_serialPortReceivingThread(LPVOID p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    DWORD rxCount;
    DWORD fdwEventMask;
    HANDLE commEvnt;
    OVERLAPPED commSync;
    DWORD commError;
    COMSTAT commStat;
    size_t rxIdx = 0;
    char *receiveBufferTmp;

    memset(&commSync, 0, sizeof(OVERLAPPED));
    commEvnt = CreateEvent(NULL, TRUE, FALSE, NULL);
    if (commEvnt == INVALID_HANDLE_VALUE) {
        ExitThread(1);
    }
    commSync.hEvent = commEvnt;
    ClearCommError(serial->hComm, &commError, &commStat);
    receiveBufferTmp = (char*)calloc(serial->bufferSize, 1);

    while (serial->hComm != INVALID_HANDLE_VALUE && serial->receiving == 1) {
        BOOL waitState = WaitCommEvent(serial->hComm, &fdwEventMask, &commSync);
        if (!waitState) {
            if (GetLastError() == ERROR_IO_PENDING) {
                WaitForSingleObject(commEvnt, 1000);
                GetOverlappedResult(serial->hComm, &commSync, &rxCount, TRUE);
            }
            else {
                CloseHandle(commEvnt);
                free(receiveBufferTmp);
                receiveBufferTmp = NULL;
                ExitThread(0);
            }
        }

        if (fdwEventMask & (EV_RXCHAR | EV_BREAK | EV_ERR | EV_TXEMPTY)) {
            COMSTAT curStatus;
            DWORD rxError;

            ClearCommError(serial->hComm, &rxError, &curStatus);
            rxError &= CE_BREAK + CE_RXOVER + CE_OVERRUN + CE_RXPARITY + CE_FRAME + CE_IOE;
            if (rxError) {
                if (rxError & (CE_BREAK | CE_IOE)) {
                    PurgeComm(serial->hComm, PURGE_TXABORT | PURGE_TXCLEAR);
                    PurgeComm(serial->hComm, PURGE_RXABORT | PURGE_RXCLEAR);
                }
                else {
                    COMSTAT commStat;
                    ClearCommError(serial->hComm, &commError, &commStat);
                    PurgeComm(serial->hComm, PURGE_RXCLEAR);
                    rxError = 0;
                    EnterCriticalSection(&serial->receiveLock);
                    serial->receivedBytes = 0;
                    memset(serial->receiveBuffer, 0, serial->bufferSize);
                    LeaveCriticalSection(&serial->receiveLock);
                }
            }
            else {
                HANDLE rdEvnt;
                OVERLAPPED rdSync;
                DWORD x;

                memset(&rdSync, 0, sizeof(OVERLAPPED));
                rdEvnt = CreateEvent(NULL, TRUE, FALSE, NULL);
                rdSync.hEvent = rdEvnt;
                x = curStatus.cbInQue;
                if (x > 0) {
                    BOOL rdRslt;
                    if (x + rxIdx > serial->bufferSize) {
                        x = (DWORD)(serial->bufferSize - rxIdx);
                    }
                    rdRslt = ReadFile(serial->hComm, &receiveBufferTmp[rxIdx], x, &rxCount, &rdSync);
                    rxIdx += rxCount;
                    if (rxIdx == serial->bufferSize) {
                        EnterCriticalSection(&serial->receiveLock);
                        serial->receivedBytes = serial->bufferSize;
                        memcpy(serial->receiveBuffer, receiveBufferTmp, serial->bufferSize);
                        LeaveCriticalSection(&serial->receiveLock);
                        rxIdx = 0;
                    }
                    if (!rdRslt && GetLastError() == ERROR_IO_PENDING) {
                        GetOverlappedResult(serial->hComm, &rdSync, &rxCount, TRUE);
                    }
                }
                CloseHandle(rdEvnt);
            }
        }
    }
    CloseHandle(commEvnt);
    free(receiveBufferTmp);
    return 0;
}

DllExport void * MDD_serialPortConstructor(const char * deviceName, int bufferSize, int parity, int receiver, int baud) {
    /* Allocation of data structure memory */
    MDDSerialPort* serial = (MDDSerialPort*) calloc(sizeof(MDDSerialPort), 1);
    if (serial) {
        DCB dcb;
        DWORD fdwEventMask;
        serial->hComm = CreateFileA(deviceName, GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
        if (serial->hComm == INVALID_HANDLE_VALUE) {
            free(serial);
            serial = NULL;
            ModelicaFormatError("MDDSerialPort.h: CreateFileA of serial port %s failed with error: %lu\n", deviceName, GetLastError());
        }
        ModelicaFormatMessage("Created serial port for device %s\n", deviceName);

        memset(&dcb, 0, sizeof(dcb));
        dcb.DCBlength = sizeof(dcb);
        if (!GetCommState(serial->hComm, &dcb)) {
            CloseHandle(serial->hComm);
            free(serial);
            serial = NULL;
            ModelicaFormatError("MDDSerialPort.h: GetCommState of serial port %s failed with error: %lu\n", deviceName, GetLastError());
        }

        switch (baud) {
            case 1:
                dcb.BaudRate = CBR_115200;
                break;
            case 2:
                dcb.BaudRate = CBR_57600;
                break;
            case 3:
                dcb.BaudRate = CBR_38400;
                break;
            case 4:
                dcb.BaudRate = CBR_19200;
                break;
            case 5:
                dcb.BaudRate = CBR_9600;
                break;
            case 6:
                dcb.BaudRate = CBR_4800;
                break;
            case 7:
                dcb.BaudRate = CBR_2400;
                break;
            default:
                dcb.BaudRate = CBR_57600;
                break;
        }

        ModelicaFormatMessage("Set serial port %s to speed: %d\n", deviceName, baud);
        switch (parity) {
            case 1:
                /* even parity */
                dcb.Parity = EVENPARITY;
                ModelicaFormatMessage("Set even Parity of serial port %s\n", deviceName);
                break;
            case 2:
                /* odd parity */
                dcb.Parity = ODDPARITY;
                ModelicaFormatMessage("Set odd Parity of serial port %s\n", deviceName);
                break;
            default:
                /* no parity */
                dcb.Parity = NOPARITY;
                ModelicaFormatMessage("Set no Parity of serial port %s\n", deviceName);
                break;
        }

        dcb.fBinary = 1;
        dcb.ByteSize = 8;
        dcb.StopBits = ONESTOPBIT;
        dcb.fDsrSensitivity = FALSE;
        dcb.fOutX = FALSE;
        dcb.fInX = FALSE;
        dcb.fErrorChar = FALSE;
        dcb.fRtsControl = RTS_CONTROL_ENABLE;
        dcb.fAbortOnError = TRUE;
        dcb.fOutxCtsFlow = FALSE;
        dcb.fOutxDsrFlow = FALSE;

        if (!SetCommState(serial->hComm, &dcb)) {
            CloseHandle(serial->hComm);
            free(serial);
            serial = NULL;
            ModelicaFormatError("MDDSerialPort.h: SetCommState of serial port %s failed with error: %lu\n", deviceName, GetLastError());
        }

        if (!GetCommMask(serial->hComm, &fdwEventMask)) {
            fdwEventMask = 0;
        }
        fdwEventMask |= EV_RXCHAR | EV_TXEMPTY | EV_BREAK | EV_ERR | EV_RING | EV_RLSD | EV_CTS | EV_DSR;
        SetCommMask(serial->hComm, fdwEventMask);
        EscapeCommFunction(serial->hComm, SETDTR);
        PurgeComm(serial->hComm, PURGE_TXABORT | PURGE_TXCLEAR);
        PurgeComm(serial->hComm, PURGE_RXABORT | PURGE_RXCLEAR);

        serial->bufferSize = (size_t)bufferSize;
        serial->receiving = 1;
        serial->receivedBytes = 0;
        if (receiver) {
            DWORD id1;
            serial->receiveBuffer = (char*)calloc(bufferSize, 1);
            InitializeCriticalSection(&serial->receiveLock);
            serial->hThread = CreateThread(0, 0, MDD_serialPortReceivingThread, serial, 0, &id1);
            if (!serial->hThread) {
                DeleteCriticalSection(&serial->receiveLock);
                CloseHandle(serial->hComm);
                free(serial->receiveBuffer);
                free(serial);
                serial = NULL;
                ModelicaError("MDDSerialPort.h: Error creating receiver thread for serial communication.\n");
            }
        }
    }
    return (void*)serial;
}

DllExport const char * MDD_serialPortRead(void * p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    if (serial && serial->hThread && serial->hComm != INVALID_HANDLE_VALUE) {
        char* spBuf;
        EnterCriticalSection(&serial->receiveLock);
        spBuf = ModelicaAllocateStringWithErrorReturn(serial->receivedBytes);
        if (spBuf) {
            memcpy(spBuf, serial->receiveBuffer, serial->receivedBytes);
            serial->receivedBytes = 0;
            LeaveCriticalSection(&serial->receiveLock);
            return (const char*) spBuf;
        }
        else {
            LeaveCriticalSection(&serial->receiveLock);
            ModelicaError("MDDSerialPort.h: ModelicaAllocateString failed\n");
        }
    }
    return "";
}

DllExport void MDD_serialPortReadP(void * p_serial, void* p_package) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    if (serial && serial->hThread && serial->hComm != INVALID_HANDLE_VALUE) {
        int rc;
        EnterCriticalSection(&serial->receiveLock);
        rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, serial->receiveBuffer, serial->receivedBytes);
        serial->receivedBytes = 0;
        LeaveCriticalSection(&serial->receiveLock);
        if (rc) {
           ModelicaError("MDDSerialPort.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
        }
    }
}

DllExport void MDD_serialPortSend(void * p_serial, const char * data, int dataSize) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    if (serial && serial->hComm != INVALID_HANDLE_VALUE) {
        HANDLE writeEvnt = CreateEvent(NULL, TRUE, FALSE, NULL);
        if (writeEvnt != INVALID_HANDLE_VALUE) {
            DWORD bWritten;
            OVERLAPPED writeSync;
            BOOL ret;
            memset(&writeSync, 0, sizeof(OVERLAPPED));
            writeSync.hEvent = writeEvnt;
            ret = WriteFile(serial->hComm, data, dataSize, &bWritten, &writeSync);
            if (!ret) {
                if (GetLastError() == ERROR_IO_PENDING) {
                    GetOverlappedResult(serial->hComm, &writeSync, &bWritten, TRUE);
                }
            }
            CloseHandle(writeEvnt);
        }
    }
}

DllExport void MDD_serialPortSendP(void * p_serial, void* p_package, int dataSize) {
   MDD_serialPortSend(p_serial, MDD_SerialPackagerGetData(p_package), dataSize);
}

DllExport void MDD_serialPortDestructor(void * p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    if (serial) {
        char c = 0;
        serial->receiving = 0;
        EscapeCommFunction(serial->hComm, CLRDTR);
        PurgeComm(serial->hComm, PURGE_TXABORT | PURGE_TXCLEAR);
        PurgeComm(serial->hComm, PURGE_RXABORT | PURGE_RXCLEAR);
        MDD_serialPortSend(p_serial, &c, 1);
        if (serial->hThread) {
            DWORD dwEc = 1;
            WaitForSingleObject(serial->hThread, 1000);
            if (GetExitCodeThread(serial->hThread, &dwEc) && dwEc == STILL_ACTIVE) {
                TerminateThread(serial->hThread, 1);
            }
            CloseHandle(serial->hThread);
            DeleteCriticalSection(&serial->receiveLock);
            free(serial->receiveBuffer);
        }
        CloseHandle(serial->hComm);
        free(serial);
    }
}

DllExport int MDD_serialPortGetReceivedBytes(void * p_serial) {
    int receivedBytes = 0;
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    if (serial && serial->hThread) {
        EnterCriticalSection(&serial->receiveLock);
        receivedBytes = (int)serial->receivedBytes;
        LeaveCriticalSection(&serial->receiveLock);
    }
    return receivedBytes;
}

#elif defined(__linux__)

#include <stdlib.h>
#include <string.h> /* memset(..) */
#include <errno.h>

#include <sys/poll.h> /* pThread specific */
#include <netdb.h> /* pThread specific */
#include <pthread.h> /* pThread specific */

#include <unistd.h> /* Serial specific */
#include <fcntl.h> /* Serial specific */
#include <termios.h> /* Serial specific */
#include "../src/include/CompatibilityDefs.h"

/** Serial port object */
typedef struct {
    int fd; /** Device identifier */
    int speed; /** Device Baudrate */
    int parity; /** Device Parity Configuration */
    struct termios serial;
    size_t messageLength; /**< message length (only relevant for reading) */
    unsigned char* msgInternal; /**< Internal serial message buffer (only relevant for reading) */
    unsigned char* msgLastComplete; /**< Last *complete* received message (only relevant for reading) */
    ssize_t nReceivedBytes; /**< Number of received bytes (only kept for backwards compatiblity) */
    int runReceive; /**< Run receiving thread as long as runReceive != 0 */
    pthread_t thread;
    pthread_mutex_t messageMutex; /**< Exclusive access to msgLastComplete and nReceivedBytes */
} MDDSerialPort;

void* MDD_serialPortReceivingThread(void * p_serial);

/** @deprecated Returns the number of bytes received during the last read.
 *
 * Kept for backward compatiblity. Only very limited use since due to thread parallism
 * the returned value may already be outdated when it is returned or when a later
 * conditional action is based on the return value.
 */
int MDD_serialPortGetReceivedBytes(void * p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    int nReceivedByte;
    pthread_mutex_lock(&(serial->messageMutex));
    nReceivedByte = (int) serial->nReceivedBytes;
    pthread_mutex_unlock(&(serial->messageMutex));
    return nReceivedByte;
}

/** Function to set serial device to blocking or non-blocking.
 *
 * @param fd file descriptor of opened serial port
 * @param should_block @arg 0 if the serial device shall be non-blocking
 * @arg 1 if the serial device shall be blocked
 */
static void MDD_serialPortSetBlocking (int fd, int should_block) {

    struct termios ser;
    int ret;
    memset (&ser, 0, sizeof(ser));
    ret = tcgetattr (fd, &ser);
    if (ret != 0) {
        ModelicaFormatError("MDDSerialPort.h: Error %d from tcgetattr\n",ret);
        return;
    }

    ser.c_cc[VMIN] = should_block ? 1 : 0;
    ser.c_cc[VTIME] = 1;

    ret = tcsetattr (fd, TCSANOW, &ser);
    if (ret != 0) {
        ModelicaFormatError("MDDSerialPort.h: Error %d setting term attributes\n",ret);
        return;
    }

}

/** Function to set serial device attributes
 *
 * @param @param fd file descriptor of opened serial port
 * @param speed set speed of the serial port interface in baud starting with "B" e.g.B115200
 * @param parity @arg 0 set no parity
 * @arg 1 set parity
 */
static void MDD_serialPortSetInterfaceAttributes (int fd, int speed, int parity) {

    struct termios ser;
    int ret;
    memset (&ser, 0, sizeof(ser));
    ret = tcgetattr (fd, &ser);
    if (ret != 0) {
        ModelicaFormatError("MDDSerialPort.h: Error %d from tcgetattr\n",ret);
        return;
    }

    cfsetospeed (&ser, speed); /* set output speed */
    cfsetispeed (&ser, speed); /* set input speed */

    ser.c_cflag = ( ser.c_cflag & ~CSIZE) | CS8; /* 8 bit characters shall be used */
    ser.c_iflag &= ~IGNBRK; /* ignore break signal */
    /*ser.c_iflag |= IGNBRK; // ignore break signal*/
    ser.c_lflag = 0; /* no signaling characters, no echo */
    ser.c_oflag = 0; /* no remapping, no delays */
    ser.c_cc[VMIN] = 0; /* read does not block */
    ser.c_cc[VTIME] = 5; /* 0.5 second read timeout */
    ser.c_iflag &= ~(IXON | IXOFF | IXANY); /* shut off xon/xoff control */
    ser.c_cflag |= (CLOCAL | CREAD); /*ignore modem controls, enable reading*/

    switch (parity) {
        case 1:
            /* even parity */
            ser.c_cflag |= PARENB; /* enable parity */
            ser.c_cflag &= ~PARODD; /* set even parity */
            ModelicaFormatMessage("Set even Parity of serial port handle: %d\n",fd);
            break;
        case 2:
            /* odd parity */
            ser.c_cflag |= PARENB; /* enable parity */
            ser.c_cflag |= PARODD; /* set even parity */
            ModelicaFormatMessage("Set odd Parity of serial port handle: %d\n",fd);
            break;
        default:
            /* no parity */
            ser.c_cflag &= ~(PARENB | PARODD); /* switch off any parity */
            ser.c_cflag |= parity; /* set parity */
            ModelicaFormatMessage("Set no Parity of serial port handle: %d\n",fd);
            break;
    }

    ser.c_cflag &= ~CSTOPB;
    ser.c_cflag &= ~CRTSCTS;

    ret = tcsetattr (fd, TCSANOW, &ser);
    if (ret != 0) {
        ModelicaFormatError("MDDSerialPort.h: Error %d setting term attributes\n",ret);
        return;
    }

}

/** Create a serial port from a serial device
 *
 * @param bufferSize size of the buffer used by a receiving socket (not needed for sending socket)
 */
void * MDD_serialPortConstructor(const char * deviceName, int bufferSize, int parity, int receiver, int baud) {
    /* Allocation of data structure memory */
    MDDSerialPort* serial = (MDDSerialPort*) malloc(sizeof(MDDSerialPort));
    int ret;
    speed_t speed;
    serial->messageLength = bufferSize;
    serial->nReceivedBytes = 0;
    serial->runReceive = 0;
    serial->msgInternal = calloc(serial->messageLength,1);
    serial->msgLastComplete = calloc(serial->messageLength,1);
    ret = pthread_mutex_init(&(serial->messageMutex), NULL); /* Init mutex with defaults */
    if (ret != 0) {
        ModelicaFormatError("MDDSerialPort.h: pthread_mutex_init() failed (%s)\n",
                            strerror(errno));
    }

    /* Create a serial port. */
    serial->fd = open (deviceName, O_RDWR | /* sets device to read/write operation */
                       O_NOCTTY | /* sets device not to be the controlling terminal for that port */
                       O_NDELAY); /* sets device to do not care about state of DCD signal line */
    /*O_SYNC); */
    if (serial->fd < 0) {
        ModelicaFormatError("MDDSerialPort.h: open(..) of serial port %s failed (%s)\n", deviceName,
                            strerror(errno));
    }

    switch (baud) {
        case 1:
            speed = B115200;
            break;
        case 2:
            speed = B57600;
            break;
        case 3:
            speed = B38400;
            break;
        case 4:
            speed = B19200;
            break;
        case 5:
            speed = B9600;
            break;
        case 6:
            speed = B4800;
            break;
        case 7:
            speed = B2400;
            break;
        default:
            speed = B57600;
            break;
    }

    ModelicaFormatMessage("Created serial port handle: %d \n",serial->fd);
    ModelicaFormatMessage("Created serial port for device %s\n",deviceName);
    ModelicaFormatMessage("Set serial port %s to speed: %d\n",deviceName,(baud));

    MDD_serialPortSetInterfaceAttributes (serial->fd, speed, parity);
    MDD_serialPortSetBlocking (serial->fd,0);

    if (receiver) {
        /* Start dedicated receiver thread */
        serial->runReceive = 1;
        ret = pthread_create(&serial->thread, 0, MDD_serialPortReceivingThread, serial);
        if (ret) {
            ModelicaFormatError("MDDSerialPort.h: pthread (MDD_serialPortReceivingThread) failed\n");
        }
    }

    return (void *) serial;
}

/** Dedicated thread to receive data from serial ports.
 *
 * @param p_serial pointer address to the serial socket data structure
 */
void* MDD_serialPortReceivingThread(void * p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;

    struct pollfd serial_poll;

    ModelicaFormatMessage("Started dedicated serial port receiving thread listening at port %d\n",
                          serial->fd);

    serial_poll.fd = serial->fd;
    serial_poll.events = POLLIN | POLLHUP;
    ssize_t messageByteCounter = 0;

    while (serial->runReceive) {
        int ret = poll(&serial_poll, 1, 100);

        switch (ret) {
            case -1:
                ModelicaFormatError("MDDSerialPort.h: poll(..) failed (%s) \n",
                                    strerror(errno));
                break;
            case 0: /* no new data available. Just check if serial->runReceive still true and go on */
                break;
            case 1: /* new data available */
                if(serial_poll.revents & POLLHUP) {
                    ModelicaMessage("The serial port was disconnected.\n");
                }
                else {


                    if (messageByteCounter == serial->messageLength) {
                        messageByteCounter = 0; /* reset counter */
                    }

                    /* Receive the next message */
                    ssize_t bytesRead =
                        read(serial->fd, /* serial port file handle*/
                            serial->msgInternal + messageByteCounter, /* receive buffer */
                            serial->messageLength - messageByteCounter /* max bytes to receive */
                            );
                    if (bytesRead < 0) {
                        ModelicaFormatError("MDDSerialPort.h: read(..) failed (%s)\n", strerror(errno));
                    }
                    messageByteCounter += bytesRead;

                    pthread_mutex_lock(&(serial->messageMutex));
                    /* set number of read bytes (not really useful but kept for backwards compatiblity) */
                    serial->nReceivedBytes = bytesRead;
                    /* Read complete message? => update last complete message buffer */
                    if (messageByteCounter == serial->messageLength) {
                        memcpy(serial->msgLastComplete, serial->msgInternal, serial->messageLength);
                    }
                    pthread_mutex_unlock(&(serial->messageMutex));

                }
                break;
            default:
                ModelicaFormatError("MDDSerialPort.h: Poll returned %d. That should not happen.\n", ret);
        }
    }
    return NULL;
}

/** Read data from serial port.
 *
 * @param p_serial pointer address to the serial port data structure
 * @return pointer to the message buffer
 */
const char * MDD_serialPortRead(void * p_serial) {

    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    char* spBuf;

    /* Lock access to serial->msgLastComplete */
    pthread_mutex_lock(&(serial->messageMutex));
    spBuf = ModelicaAllocateStringWithErrorReturn(serial->messageLength);
    if (spBuf) {
        /* Copy last completely transmitted message to message buffer */
        memcpy(spBuf, serial->msgLastComplete, serial->messageLength);
        pthread_mutex_unlock(&(serial->messageMutex));
        return (const char*) spBuf;
    }
    else {
        pthread_mutex_unlock(&(serial->messageMutex));
        ModelicaError("MDDSerialPort.h: ModelicaAllocateString failed\n");
    }
    return "";
}

/** Read data from serial port.
 *
 * @param p_serial pointer address to the serial port data structure
 * @param p_package pointer to the SerialPackager
 */
void MDD_serialPortReadP(void * p_serial, void* p_package) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    int rc;

    /* Lock access to serial->msgLastComplete */
    pthread_mutex_lock(&(serial->messageMutex));
    /* Set package to last completely transmitted message */
    rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, serial->msgLastComplete, serial->messageLength);
    pthread_mutex_unlock(&(serial->messageMutex));
    if (rc) {
        ModelicaError("MDDSerialPort.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
    }
}

/** Send data via serial port
 *
 * @param p_serial pointer address to the serial port data structure
 * @param data data to be sent
 * @param dataSize size of data
 */
void MDD_serialPortSend(void * p_serial, const char * data, int dataSize) {

    MDDSerialPort * serial = (MDDSerialPort *) p_serial;

    int ret = write(serial->fd, data, dataSize); /* write to serial port */
    if (ret < dataSize) {
        ModelicaFormatError("MDDSerialPort.h: Expected to send: %d bytes, but was: %d\n"
                            "sendto(..) failed (%s)\n", dataSize, ret, strerror(errno));
    }

}

/** Send data via serial port
 *
 * @param p_serial pointer address to the serial port data structure
 * @param p_package pointer to the SerialPackager
 * @param dataSize size of data
 */
void MDD_serialPortSendP(void * p_serial, void* p_package, int dataSize) {
   MDD_serialPortSend(p_serial, MDD_SerialPackagerGetData(p_package), dataSize);
}

/** Close serial port and free memory.
 * @param p_serial pointer address to the serial port data structure
 */
void MDD_serialPortDestructor(void * p_serial) {
    MDDSerialPort * serial = (MDDSerialPort *) p_serial;
    void * pRet;

    /* stop receiving thread if any */
    if (serial->runReceive) {
        serial->runReceive = 0;
        pthread_join(serial->thread, &pRet);
        pthread_detach(serial->thread);
    }

    if (pthread_mutex_destroy(&(serial->messageMutex)) != 0) {
        ModelicaFormatMessage("MDDSerialPort.h: pthread_mutex_destroy() failed (%s)\n", strerror(errno));
    }

    if (close(serial->fd) == -1) {
        ModelicaFormatMessage("MDDSerialPort.h: close() failed (%s)\n", strerror(errno));
    }
    ModelicaFormatMessage("Closed serial port handle %d\n", serial->fd);
    free(serial->msgInternal);
    free(serial->msgLastComplete);
    free(serial);
}

#else

#error "Modelica_DeviceDrivers: No serial port support for your platform"

#endif /* defined(__linux__) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDSERIALPORT_H_ */
