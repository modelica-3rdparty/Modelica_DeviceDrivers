/** Synchronize execution with real-time (header-only library).
 *
 * @file
 * @author      tbellmann (Windows)
 * @author      bernhard-thiele (Linux)
 * @author    tbeu
 * @since       2012-05-29
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 */

#ifndef MDDREALTIMESYNCHRONIZE_H_
#define MDDREALTIMESYNCHRONIZE_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <mmsystem.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"

#pragma comment( lib, "Winmm.lib" )

#if !defined(BELOW_NORMAL_PRIORITY_CLASS)
#define BELOW_NORMAL_PRIORITY_CLASS 0x00004000
#endif

/** Process priority object */
typedef struct {
    DWORD lastPrio;
} ProcPrio;

DllExport void* MDD_ProcessPriorityConstructor(void) {
    ProcPrio* prio = (ProcPrio*) malloc(sizeof(ProcPrio));
    if (prio) {
        prio->lastPrio = GetPriorityClass(GetCurrentProcess());
    }
    return (void*) prio;
}

DllExport void MDD_ProcessPriorityDestructor(void* prioObj) {
    ProcPrio* prio = (ProcPrio*) prioObj;
    if (prio) {
        DWORD currentPrio = GetPriorityClass(GetCurrentProcess());
        if (currentPrio != prio->lastPrio) {
            BOOL ret = 1;
            ModelicaFormatMessage("setting...\n");
            switch (prio->lastPrio) {
                case IDLE_PRIORITY_CLASS:
                    ret = SetPriorityClass(GetCurrentProcess(), IDLE_PRIORITY_CLASS);
                    if (ret) {
                        ModelicaFormatMessage("ProcessPriority set to idle.\n");
                    }
                    break;

                case BELOW_NORMAL_PRIORITY_CLASS:
                    ret = SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);
                    if (ret) {
                        ModelicaFormatMessage("ProcessPriority set to below normal.\n");
                    }
                    break;

                case HIGH_PRIORITY_CLASS:
                    ret = SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
                    if (ret) {
                        ModelicaFormatMessage("ProcessPriority set to high.\n");
                    }
                    break;

                case REALTIME_PRIORITY_CLASS:
                    ret = SetPriorityClass(GetCurrentProcess(), REALTIME_PRIORITY_CLASS);
                    if (ret) {
                        ModelicaFormatMessage("ProcessPriority set to realtime.\n");
                    }
                    break;

                default:
                    ret = SetPriorityClass(GetCurrentProcess(), NORMAL_PRIORITY_CLASS);
                    if (ret) {
                        ModelicaFormatMessage("ProcessPriority set to normal.\n");
                    }
                    break;
            }

            if (ret == 0) {
                DWORD dw = GetLastError();
                if (dw) {
                    ModelicaFormatMessage("LastError: %lu\n", dw);
                }
            }
        }

        free(prio);
    }
}

DllExport void MDD_setPriority(void* dummyPrioObj, int priority) {
    BOOL ret = 1;
    DWORD currentPrio = GetPriorityClass(GetCurrentProcess());
    switch (priority) {
        case -2:
            if (currentPrio != IDLE_PRIORITY_CLASS) {
                ModelicaFormatMessage("setting...\n");
                ret = SetPriorityClass(GetCurrentProcess(), IDLE_PRIORITY_CLASS);
                if (ret) {
                    ModelicaFormatMessage("ProcessPriority set to idle.\n");
                }
            }
            break;

        case -1:
            if (currentPrio != BELOW_NORMAL_PRIORITY_CLASS) {
                ModelicaFormatMessage("setting...\n");
                ret = SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);
                if (ret) {
                    ModelicaFormatMessage("ProcessPriority set to below normal.\n");
                }
            }
            break;

        case 1:
            if (currentPrio != HIGH_PRIORITY_CLASS) {
                ModelicaFormatMessage("setting...\n");
                ret = SetPriorityClass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
                if (ret) {
                    ModelicaFormatMessage("ProcessPriority set to high.\n");
                }
            }
            break;

        case 2:
            if (currentPrio != REALTIME_PRIORITY_CLASS) {
                ModelicaFormatMessage("setting...\n");
                ret = SetPriorityClass(GetCurrentProcess(), REALTIME_PRIORITY_CLASS);
                if (ret) {
                    ModelicaFormatMessage("ProcessPriority set to realtime.\n");
                }
            }
            break;

        default:
            if (currentPrio != NORMAL_PRIORITY_CLASS) {
                ModelicaFormatMessage("setting...\n");
                ret = SetPriorityClass(GetCurrentProcess(), NORMAL_PRIORITY_CLASS);
                if (ret) {
                    ModelicaFormatMessage("ProcessPriority set to normal.\n");
                }
            }
            break;
    }

    if (ret == 0) {
        DWORD dw = GetLastError();
        if (dw) {
            ModelicaFormatMessage("LastError: %d\n", dw);
        }
    }
}

/** Real-time synchronization object */
typedef struct {
    LARGE_INTEGER frequency;
    LARGE_INTEGER startTime;
    LARGE_INTEGER lastTime;
    double lastSimTime;
    double lastIntegratorTimeStep;
    double lastCalculationTime;
    double lastSyncTime; /* last (potentially scaled) syncronization time */
} RTSync;

DllExport void* MDD_realtimeSynchronizeConstructor(void) {
    RTSync* rtSync = (RTSync*) malloc(sizeof(RTSync));
    if (rtSync) {
        if (0 == QueryPerformanceFrequency(&rtSync->frequency)) {
            free(rtSync);
            rtSync = NULL;
            ModelicaFormatError("MDDRealtimeSynchronize.h: QueryPerformanceFrequency "
                "not supported (%d)\n", GetLastError());
        }
        QueryPerformanceCounter(&rtSync->startTime);
        rtSync->lastTime = rtSync->startTime;
        rtSync->lastSimTime = 0.;
        rtSync->lastIntegratorTimeStep = 0.;
        rtSync->lastCalculationTime = 0.;
        rtSync->lastSyncTime = 0.;
    }
    timeBeginPeriod(1);
    return (void*) rtSync;
}

DllExport void MDD_realtimeSynchronizeDestructor(void* rtSyncObj) {
    RTSync* rtSync = (RTSync*) rtSyncObj;
    if (rtSync) {
        free(rtSync);
    }
    timeEndPeriod(1);
}

/** Request time from a monotonic increasing real-time clock.
 *
 * @param[in] unused dummy parameter.
 * @return (ms) time in milliseconds.
 */
DllExport double MDD_getTimeMS(double dummy) {
    LARGE_INTEGER ticks, frequency;
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&ticks);
    return (double)(ticks.QuadPart * 1e6)/(double)frequency.QuadPart/1000.;
}

/** Slow down task so that simulation time == real-time.
 *
 * @param[in] Real-time synchronization object
 * @param[in] simTime (s) simulation time
 * @param[in] enableScaling if true enable real-time scaling, else disable scaling
 * @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
 * @param[out] availableTime time that is left before realtime deadline is reached BUG Windows-Linux implementation differ!
 * @return (s) Time between invocation of this function, i.e. "computing time" in seconds
 */
DllExport double MDD_realtimeSynchronize(void* rtSyncObj, double simTime, int enableScaling, double scaling, double * integratorTimeStep) {
    double calculationTime = 0.;
    RTSync* rtSync = (RTSync*) rtSyncObj;
    if (rtSync && integratorTimeStep) {
        *integratorTimeStep = rtSync->lastIntegratorTimeStep;
        if (simTime != rtSync->lastSimTime) {
            LARGE_INTEGER now;
            double timeLeft, syncTime;
            QueryPerformanceCounter(&now);
            calculationTime = (double)(now.QuadPart * 1e6 - rtSync->lastTime.QuadPart * 1e6)/(double)rtSync->frequency.QuadPart*1.e-6;

            *integratorTimeStep = simTime - rtSync->lastSimTime;

            /* scaled syncronization time. "scaling > 1" means the simulation takes longer than real-time.
               No scaling => syncTime == simTime */
            syncTime = enableScaling ? rtSync->lastSyncTime + (simTime - rtSync->lastSimTime)*scaling : simTime;

            do {
                QueryPerformanceCounter(&now);
                timeLeft = syncTime - (double)(now.QuadPart - rtSync->startTime.QuadPart)/(double)rtSync->frequency.QuadPart;
                if (timeLeft > 0) {
                    if (timeLeft > 0.002) {
                        Sleep(1);
                    }
                    else {
                        int i;
                        for (i = 0; i < 10; i++) {
                            Sleep(0);
                        }
                    }
                }
            } while (timeLeft >= 0.);
            QueryPerformanceCounter(&rtSync->lastTime);
            rtSync->lastSimTime = simTime;
            rtSync->lastIntegratorTimeStep = *integratorTimeStep;
            rtSync->lastCalculationTime = calculationTime;
            rtSync->lastSyncTime = syncTime;
        }
        else {
            calculationTime = rtSync->lastCalculationTime;
        }
    }
    return calculationTime;
}

#elif defined(__linux__)

#include <time.h>
#include <sched.h>
#include <math.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/mman.h>
#include "../src/include/CompatibilityDefs.h"
#define MY_RT_PRIORITY (49) /**< we use 49 since PRREMPT_RT use 50
                                 as the priority of kernel tasklets
                                 and interrupt handlers by default */
#define NSEC_PER_SEC    (1000000000) /* The number of nsecs per sec. */

typedef struct {
    int prio; /* dummy */
} ProcPrio;

void* MDD_ProcessPriorityConstructor(void) {
    ProcPrio* prio = (ProcPrio*) malloc(sizeof(ProcPrio));
    return (void*) prio;
}

void MDD_ProcessPriorityDestructor(void* prioObj) {
    ProcPrio* prio = (ProcPrio*) prioObj;
    if (prio) {
        free(prio);
    }
}

/** Set process priority.
 *
 * Function maps directly on windows API. For linux a mapping was chosen that seemed
 * to be reasonable.
 * @param[in] Process priority external object (dummy)
 * @param[in] priority range: (-2: idle, -1: below normal, 0: normal, 1: high, 2: realtime)
 */
void MDD_setPriority(void* dummyPrioObj, int priority) {
    int ret;
    struct sched_param param;
    errno = 0; /* zero out errno since -1 may be a valid return value for nice(..) and not necessarily indicate error */

    ModelicaFormatMessage("Trying to set ProcessPriority: %d.\n", priority);

    switch(priority) {
        case -2:
            ret = nice(20);
            if (ret == -1 && errno != 0) {
                ModelicaError("MDDRealtimeSynchronize.h: nice(20) failed\n");
            }
            else {
                ModelicaFormatMessage("ProcessPriority set to %d=nice(20) \"idle\".\n", ret);
            }
            break;

        case -1:
            ret = nice(10);
            if (ret == -1 && errno != 0) {
                ModelicaError("MDDRealtimeSynchronize.h: nice(10) failed\n");
            }
            else {
                ModelicaFormatMessage("ProcessPriority set to %d=nice(10) \"below normal\".\n", ret);
            }
            break;

        case 0:
            ret = nice(0);
            if (ret == -1 && errno != 0) {
                ModelicaError("MDDRealtimeSynchronize.h: nice(0) failed\n");
            }
            else {
                ModelicaFormatMessage("ProcessPriority set to %d=nice(0) \"normal\".\n", ret);
            }
            break;

        case 1:
            ModelicaFormatMessage("ProcessPriority \"high\" needs generally *root* privileges! Trying..\n");
            ret = nice(-20);
            if (ret == -1 && errno != 0) {
                ModelicaError("MDDRealtimeSynchronize.h: nice(-20) failed\n");
            }
            else {
                ModelicaFormatMessage("ProcessPriority set to %d=nice(-20) \"high\".\n", ret);
            }
            break;

        case 2:
            ModelicaFormatMessage("ProcessPriority \"Realtime\" needs generally *root* privileges "
                 "and a real-time kernel (PRREMPT_RT) for hard realtime! Trying..\n");

            /* Lock entire address space into physical memory */
            if(mlockall(MCL_CURRENT | MCL_FUTURE) == -1) {
                ModelicaError("MDDRealtimeSynchronize.h: mlockall failed\n");
            }

            /* Declare ourself as a real time task */
            param.sched_priority = MY_RT_PRIORITY;
            if(sched_setscheduler(0, SCHED_FIFO, &param) == -1) {
                ModelicaError("MDDRealtimeSynchronize.h: sched_setscheduler failed\n");
            }
            else {
                ModelicaFormatMessage("ProcessPriority set to \"Realtime\"!\n");
            }
            break;

        default:
            ModelicaFormatMessage("Using default process priority\n");
            break;
    }

}

/** Real-time synchronization object */
typedef struct {
    struct timespec t_start;
    struct timespec t_clockRealtime; /* current/last time of real time clock */
    double lastSimTime; /* last simulation time */
    double lastSyncTime; /* last (potentially scaled) syncronization time */
} RTSync;

/** RTSync constructor
 *
 * @return RTSync object
 */
void* MDD_realtimeSynchronizeConstructor() {
    RTSync* rtSync = (RTSync*) malloc(sizeof(RTSync));
    if (rtSync) {
        int ret = clock_gettime(CLOCK_MONOTONIC, &rtSync->t_start);
        if (ret) {
            free(rtSync);
            rtSync = NULL;
            ModelicaError("MDDRealtimeSynchronize.h: clock_gettime(..) failed\n");
        }
        rtSync->t_clockRealtime = rtSync->t_start;
        rtSync->lastSimTime = 0; /* Presume we start from initial time = 0 */
        rtSync->lastSyncTime = 0; /* Presume we start from initial time = 0 */
    }
    return (void*) rtSync;
}

void MDD_realtimeSynchronizeDestructor(void* rtSyncObj) {
    RTSync* rtSync = (RTSync*) rtSyncObj;
    if (rtSync) {
        free(rtSync);
    }
}

/** Slow down task so that simulation time == real-time.
 *
 * @param[in] Real-time synchronization object
 * @param[in] simTime (s) simulation time
 * @param[in] enableScaling if true enable real-time scaling, else disable scaling
 * @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
 * @param[out] availableTime time that is left before realtime deadline is reached BUG Windows-Linux implementation differ!
 * @return (s) Time between invocation of this function, i.e. "computing time" in seconds
 */
double MDD_realtimeSynchronize(void* rtSyncObj, double simTime, int enableScaling, double scaling, double * availableTime) {
    double deltaTime = 0.;
    RTSync* rtSync = (RTSync*) rtSyncObj;
    if (rtSync && availableTime) {
        struct timespec t_abs; /* Absolute time until which execution will be delayed (to catch up with real-time) */
        double fractpart, intpart, syncTime;
        int ret;

        /* save away value of last time that the real-time clock was inquired */
        deltaTime = rtSync->t_clockRealtime.tv_sec + (double)rtSync->t_clockRealtime.tv_nsec/NSEC_PER_SEC;
        /* get value the current time of the real-time clock */
        clock_gettime(CLOCK_MONOTONIC, &rtSync->t_clockRealtime);
        /* Calculate the deltaTime (=calculation time) by subtracting the
         * old value of the real-time clock from the current (new) value of the real-time clock */
        deltaTime = (rtSync->t_clockRealtime.tv_sec + (double)rtSync->t_clockRealtime.tv_nsec/NSEC_PER_SEC) - deltaTime;

        /* scaled syncronization time. "scaling > 1" means the simulation takes longer than real-time.
           No scaling => syncTime == simTime */
        syncTime = enableScaling ? rtSync->lastSyncTime + (simTime - rtSync->lastSimTime)*scaling : simTime;

        /* convert (scaled) simulation time to corresponding real-time clock value */
        fractpart = modf(syncTime, &intpart);
        t_abs.tv_sec = rtSync->t_start.tv_sec + (time_t) intpart;
        t_abs.tv_nsec = rtSync->t_start.tv_nsec + (long) floor(fractpart*NSEC_PER_SEC);
        while (t_abs.tv_nsec >= NSEC_PER_SEC) {
            t_abs.tv_nsec -= NSEC_PER_SEC;
            t_abs.tv_sec++;
        }

        *availableTime = ( t_abs.tv_sec - rtSync->t_clockRealtime.tv_sec )
                         + ((double)t_abs.tv_nsec - (double)rtSync->t_clockRealtime.tv_nsec)/NSEC_PER_SEC;
        /* printf("t_abs.tv_sec: %d, t_cr.tv_sec: %d, t_abs.tv_nsec: %d, t_cr.tv_nsec: %d\n",
            t_abs.tv_sec, rtSync->t_clockRealtime.tv_sec, t_abs.tv_nsec, rtSync->t_clockRealtime.tv_nsec); */

        /* wait until (scaled) simulation time == real-time */
        ret = clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &t_abs, NULL);
        if (ret) {
            ModelicaError("MDDRealtimeSynchronize.h: clock_nanosleep(..) failed\n");
        }

        /* get value the current time of the real-time clock (should be equal to t_abs if everything is OK) */
        clock_gettime(CLOCK_MONOTONIC, &rtSync->t_clockRealtime);
        rtSync->lastSimTime = simTime;
        rtSync->lastSyncTime = syncTime;
    }

    return deltaTime;
}

double MDD_getTimeMS(double dummy) {
    struct timespec ts;
    int ret, ms;

    ret = clock_gettime(CLOCK_MONOTONIC, &ts);
    if (ret) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: clock_gettime failed (%s)\n", strerror(errno));
    }

    ms = ts.tv_sec*1000 + floor( (double)ts.tv_nsec/1000.0 + 0.5);

    return (double)ms;
}

#else

#error "Modelica_DeviceDrivers: No support of real-time synchronization for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDREALTIMESYNCHRONIZE_H_ */
