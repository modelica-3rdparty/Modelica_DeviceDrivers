/** Synchronize execution with real-time (header-only library).
 *
 * @file
 * @author      tbellmann
 * @author      bernhard-thiele
 * @author      tbeu
 * @since       2012-05-29
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
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

/** @DEPRECATED. Real-time synchronization object */
typedef struct {
    LARGE_INTEGER frequency;
    LARGE_INTEGER startTime;
    LARGE_INTEGER lastTime;
    double lastSimTime;
    double lastIntegratorTimeStep;
    double lastCalculationTime;
    double lastSyncTime; /* last (potentially scaled) synchronization time */
} RTSync;

/** @DEPRECATED. */
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

/** @DEPRECATED. */
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

/** @DEPRECATED. Slow down task so that simulation time == real-time.
 *
 * @param[in] Real-time synchronization object
 * @param[in] simTime (s) simulation time
 * @param[in] enableScaling if true enable real-time scaling, else disable scaling
 * @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
 * @param[out] availableTime time that is left before real-time deadline is reached BUG Windows-Linux implementation differ!
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

            /* scaled synchronization time. "scaling > 1" means the simulation takes longer than real-time.
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

/** @DEPRECATED. Slow down sampling period so that simulation time == real-time.
*
* Goal: If a real-time deadline in one frame was missed, don't shorten the next frame for catching up.
*
* Problem: Seems to gradually build up a delay due to finite instruction processing,
*          i.e., will slightly fall behind real-time even if all individual deadlines are met.
*
* @param[in] Real-time synchronization object
* @param[in] simTime (s) simulation time
* @param[in] lastSimTime (s) simulation time at the last sample
* @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
* @param[out] wallClockTime (s) wall clock time that elapsed since initialization of the real-time synchronization object
* @param[out] remainingTime (s) time that is left before real-time deadline is reached
* @return (s) Time between invocations of this function, i.e. "computing time" in seconds
*/
DllExport double MDD_sampledRealtimeSynchronize(void* rtSyncObj, double simTime, double lastSimTime, double scaling, double * wallClockTime, double * remainingTime) {
    RTSync* rtSync = (RTSync*)rtSyncObj;
    double calculationTime = 0, samplingPeriod = 0, timeLeft = 0, syncTime = 0;
    LARGE_INTEGER now, elapsedMicroseconds;
    if (rtSync == NULL || remainingTime == NULL) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: NULL pointer arguments to MDD_sampledRealtimeSynchronize\n");
    }

    if (simTime < 1e-4) {
        /* Apparently first sample, skip synchronization */
    }
    else if (simTime < lastSimTime) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: simTime=%lf < lastSimTime=%lf\n", simTime, lastSimTime);
    }
    else {
        samplingPeriod = simTime - lastSimTime;
        if (samplingPeriod < 1e-4) {
            ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING requesting unrealistic small real-time synchronization period of %lf s\n", samplingPeriod);
        }
        QueryPerformanceCounter(&now);

        /* Compute calculation time*/
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->lastTime.QuadPart;
        /* Convert elapsed number of ticks to microseconds. Guard against loss of precision. */
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        calculationTime = 1e-6 * elapsedMicroseconds.QuadPart;

        /* Compute syncTime*/
        elapsedMicroseconds.QuadPart = rtSync->lastTime.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        syncTime = samplingPeriod*scaling + 1e-6*elapsedMicroseconds.QuadPart;

        /* Time left*/
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        timeLeft = syncTime - 1e-6*elapsedMicroseconds.QuadPart;
        *remainingTime = timeLeft;
        while (timeLeft >= 0.) {
            if (timeLeft > 0.003)
                Sleep(1);
            else if (timeLeft > 0.001)
                Sleep(0);
            else
                ;
            QueryPerformanceCounter(&now);
            elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
            elapsedMicroseconds.QuadPart *= 1000000;
            elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
            timeLeft = syncTime - 1e-6*elapsedMicroseconds.QuadPart;
        }

        /* wall clock time since start */
        QueryPerformanceCounter(&now);
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        *wallClockTime = 1e-6 * elapsedMicroseconds.QuadPart;

        QueryPerformanceCounter(&rtSync->lastTime);
        rtSync->lastSimTime = simTime;
        rtSync->lastIntegratorTimeStep = simTime - lastSimTime; /* not used */
        rtSync->lastCalculationTime = calculationTime; /* not used */
    }
    return calculationTime;
}

/******************************************************/
/* NEXT GENERATION RT-SYNC */
/******************************************************/

/** Real-time synchronization object. */
typedef struct {
    LARGE_INTEGER frequency;          /**< Frequency of the performance counter */
    LARGE_INTEGER startTime;          /**< Performance counter time stamp at simulation start */
    LARGE_INTEGER lastTime;           /**< Last performance counter time stamp */
    double startSimTime;              /**< (s) simulation time at simulation start */
    double lastSimTime;               /**< (s) last simulation time */
    double idealWallClockTime;        /**< (s) ideal wall clock synchronization time including scaling effects (time without overrun errors) */
    int shouldCatchupTime;            /**< (boolean flag) if catchupTime != 0 then try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not */
} MDD_RTSync;


/** MDD_RTSync constructor.
*
* @param[in] startSimTime (s) simulation start time (usually 0)
* @param[in] shouldCatchupTime (boolean flag) if catchupTime != 0 then try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not.
* @return MDD_RTSync object
*/
DllExport void* MDD_RTSyncConstructor(double startSimTime, int shouldCatchupTime) {
    MDD_RTSync* rtSync = (MDD_RTSync*)malloc(sizeof(MDD_RTSync));
    if (rtSync) {
        if (0 == QueryPerformanceFrequency(&rtSync->frequency)) {
            free(rtSync);
            rtSync = NULL;
            ModelicaFormatError("MDDRealtimeSynchronize.h: QueryPerformanceFrequency "
                "not supported (%d)\n", GetLastError());
        }
        QueryPerformanceCounter(&rtSync->startTime);
        rtSync->lastTime = rtSync->startTime;
        rtSync->startSimTime = startSimTime;
        rtSync->lastSimTime = startSimTime;
        rtSync->idealWallClockTime = 0;
        rtSync->shouldCatchupTime = shouldCatchupTime;
    }
    timeBeginPeriod(1);
    return (void*)rtSync;
}

/** MDD_RTSync destructor. */
DllExport void MDD_RTSyncDestructor(void* rtSyncObj) {
    MDD_RTSync* rtSync = (MDD_RTSync*)rtSyncObj;
    if (rtSync) {
        free(rtSync);
    }
    timeEndPeriod(1);
}

/** Slow down sampling period so that simulation time == real-time.
*
*
* @param[in] rtSyncObj pointer to MDD_RTSync object
* @param[in] simTime (s) simulation time
* @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
* @param[out] wallClockTime (s) wall clock time that elapsed since initialization of the real-time synchronization object
* @param[out] remainingTime (s) wall clock time that is left before real-time deadline is reached
* @param[out] computingTime (s) wall clock time between invocations of this function, i.e. "computing time" in seconds
* @param[out] lastSimTime (s) simulation time at the previous invocation of this function, the simulation start time at the first function invocation
*/
DllExport void MDD_RTSyncSynchronize(void * rtSyncObj, double simTime, double scaling, double * wallClockTime, double * remainingTime, double * computingTime, double * lastSimTime) {
    MDD_RTSync* rtSync = (MDD_RTSync*)rtSyncObj;
    double samplingPeriod = 0, timeLeft = 0, syncWallClockTime = 0, deltaT = 0;
    LARGE_INTEGER now, elapsedMicroseconds;
    if (rtSync == NULL || wallClockTime == NULL || remainingTime == NULL || computingTime == NULL || lastSimTime == NULL) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: NULL pointer arguments to MDD_sampledRealtimeSynchronize\n");
    }
    *lastSimTime = rtSync->lastSimTime;

    if ((simTime - rtSync->startSimTime) < 1e-4) {
        /* Apparently first sample, skip synchronization. */
        *wallClockTime = rtSync->idealWallClockTime;
        *remainingTime = 0;
        *computingTime = 0;
        /* NOTE:
        * It could make sense to (re)initialize the rtSync->startTime and related variables in this
        * if-branch: Doing that, computation time during simulation initialization would not add to the wall-clock time.
        */
    }
    else if (simTime < rtSync->lastSimTime) {
        ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING simTime=%lf < lastSimTime=%lf (possibly due to solver step-size adaption)\n", simTime, rtSync->lastSimTime);
    }
    else {
        QueryPerformanceCounter(&now);

        /* Determine computation time*/
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->lastTime.QuadPart;
        /* Convert elapsed number of ticks to microseconds. Guard against loss of precision. */
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        *computingTime = 1e-6 * elapsedMicroseconds.QuadPart;

        /* Determine syncWallClockTime*/
        elapsedMicroseconds.QuadPart = rtSync->lastTime.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        samplingPeriod = simTime - rtSync->lastSimTime;
        if (samplingPeriod < 1e-4) {
            /* Commented out the message since this case is happening very often in practice if this function is called in a non-sampled continuous-time context. Reason: At any event the continuous-time equations are usually evaluated several times. */
            /* ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING requesting unrealistic small real-time synchronization period of %lf s at simTime=%f\n", samplingPeriod, simTime); */
        }
        syncWallClockTime = samplingPeriod * scaling + 1e-6*elapsedMicroseconds.QuadPart;


        /* Ideal wall clock synchronization time */
        rtSync->idealWallClockTime = samplingPeriod * scaling + rtSync->idealWallClockTime;

        /* Time left*/
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        timeLeft = syncWallClockTime - 1e-6*elapsedMicroseconds.QuadPart;
        *remainingTime = timeLeft;
        if (rtSync->shouldCatchupTime) {
            deltaT = syncWallClockTime - rtSync->idealWallClockTime;
            if (deltaT > 0) {
                timeLeft = deltaT > timeLeft ? 0 : timeLeft - deltaT;
            }
        }

        while (timeLeft >= 0.) {
            if (timeLeft > 0.003)
                Sleep(1);
            else if (timeLeft > 0.001)
                Sleep(0);
            else
                ;
            QueryPerformanceCounter(&now);
            elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
            elapsedMicroseconds.QuadPart *= 1000000;
            elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
            timeLeft = syncWallClockTime - 1e-6*elapsedMicroseconds.QuadPart;
        }

        /* wall clock time since start */
        QueryPerformanceCounter(&now);
        elapsedMicroseconds.QuadPart = now.QuadPart - rtSync->startTime.QuadPart;
        elapsedMicroseconds.QuadPart *= 1000000;
        elapsedMicroseconds.QuadPart /= rtSync->frequency.QuadPart;
        *wallClockTime = 1e-6 * elapsedMicroseconds.QuadPart;

        QueryPerformanceCounter(&rtSync->lastTime);
        rtSync->lastSimTime = simTime;
    }
}


#elif defined(__linux__)

/* Make CLOCK_MONOTONIC available if compiled with flag -std=c89, e.g., g++ -x c -std=c89 -m64 -fPIC -c MDDRealtimeSynchronize.h
 * https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/383
 * hack(bernhard-thiele): After some experiments with gcc and clang and different flags (e.g., -std=gnu99 or without specifying -std),
 *                        below seems to work robustly for a range of flags. (Probably can be improved, just don't know how...)
 */
#if !defined(linux) && !defined(unix) && !defined(_POSIX_C_SOURCE)
#define _POSIX_C_SOURCE 199309L
#endif


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

/** @DEPRECATED Real-time synchronization object */
typedef struct {
    struct timespec t_start;
    struct timespec t_clockRealtime; /* current/last time of real time clock */
    double lastSimTime; /* last simulation time */
    double lastSyncTime; /* last (potentially scaled) syncronization time */
} RTSync;



/** @DEPRECATED RTSync constructor
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

/** @DEPRECATED Slow down task so that simulation time == real-time.
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

/** Subtract the ‘struct timeval’ values X and Y, storing the result in RESULT. Return 1 if the difference is negative, otherwise 0.
*
* @param[out] result stores the difference between x and y
* @param[in] x minuend
* @param[in,out] y subtrahend. Might be modified for performing a carry (however, mathematical sum "y->tv_sec*NSEC_PER_SEC + y->tf_sec" is invariant)
* @return 1 if the difference is negative, otherwise 0.
*/
int timespec_subtract (struct timespec *result, struct timespec *x, struct timespec *y)
{
  /* Perform the carry for the later subtraction by updating y. */
  if (x->tv_nsec < y->tv_nsec) {
    int nsec = (y->tv_nsec - x->tv_nsec) / NSEC_PER_SEC + 1;
    y->tv_nsec -= NSEC_PER_SEC * nsec;
    y->tv_sec += nsec;
  }
  if (x->tv_nsec - y->tv_nsec > NSEC_PER_SEC) {
    int nsec = (x->tv_nsec - y->tv_nsec) / NSEC_PER_SEC;
    y->tv_nsec += NSEC_PER_SEC * nsec;
    y->tv_sec -= nsec;
  }

  /* Compute the time remaining to wait.
     tv_nsec is certainly positive. */
  result->tv_sec = x->tv_sec - y->tv_sec;
  result->tv_nsec = x->tv_nsec - y->tv_nsec;

  /* Return 1 if result is negative. */
  return x->tv_sec < y->tv_sec;
}

/** DELETE as soon as MDD_RTSyncSynchronize has been successfully tested ! * FIXME 2019-05-23: Needs careful review and revision, since coded quickly without much thought. */
DllExport double MDD_sampledRealtimeSynchronize(void* rtSyncObj, double simTime, double lastSimTime, double scaling, double * wallClockTime, double * remainingTime) {
    double calculationTime = 0, samplingPeriod = 0, timeLeft = 0;

    double deltaTime = 0;
    RTSync* rtSync = (RTSync*) rtSyncObj;
    struct timespec t_abs; /* Absolute time until which execution will be delayed (to catch up with real-time) */
    double fractpart, intpart, syncTime = 0;
    int ret;

    if (rtSync == NULL || remainingTime == NULL) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: NULL pointer arguments to MDD_sampledRealtimeSynchronize\n");
    }
    else if (simTime < 1e-4) {
        /* Apparently first sample, skip synchronization */
    }
    else if (simTime < lastSimTime) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: simTime=%lf < lastSimTime=%lf\n", simTime, lastSimTime);
    }
    else {
        samplingPeriod = simTime - lastSimTime;
        if (samplingPeriod < 1e-4) {
            ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING requesting unrealistic small real-time synchronization period of %lf s\n", samplingPeriod);
        }
        /* Determine real-time clock value for syncing */
        fractpart = modf(samplingPeriod*scaling, &intpart);
        t_abs.tv_sec = rtSync->t_clockRealtime.tv_sec + (time_t) intpart;
        t_abs.tv_nsec = rtSync->t_clockRealtime.tv_nsec + (long) floor(fractpart*NSEC_PER_SEC);
        while (t_abs.tv_nsec >= NSEC_PER_SEC) {
            t_abs.tv_nsec -= NSEC_PER_SEC;
            t_abs.tv_sec++;
        }


        /* save away value of last time that the real-time clock was inquired */
        deltaTime = rtSync->t_clockRealtime.tv_sec + (double)rtSync->t_clockRealtime.tv_nsec/NSEC_PER_SEC;
        /* get value the current time of the real-time clock */
        clock_gettime(CLOCK_MONOTONIC, &rtSync->t_clockRealtime);
        /* Calculate the deltaTime (=calculation time) by subtracting the
         * old value of the real-time clock from the current (new) value of the real-time clock */
        deltaTime = (rtSync->t_clockRealtime.tv_sec + (double)rtSync->t_clockRealtime.tv_nsec/NSEC_PER_SEC) - deltaTime;

        *remainingTime = ( t_abs.tv_sec - rtSync->t_clockRealtime.tv_sec )
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
        rtSync->lastSyncTime = syncTime; /* TODO: Implement */


        /* wall clock time since start */
        struct timespec t_elapsed;
        /* FIXME: Introduce a tmp (pseudo code struct timespec t_tmp = rtSync->t_start) for doing the carry?; */
        ret = timespec_subtract(&t_elapsed, &(rtSync->t_clockRealtime), &(rtSync->t_start));
        if (ret == 1) {
            ModelicaError("MDDRealtimeSynchronize.h: timespec_subtract returned negative number\n");
        }
        *wallClockTime = (double)t_elapsed.tv_sec + (double)t_elapsed.tv_nsec/NSEC_PER_SEC;
    }

    return deltaTime;
}

DllExport double MDD_getTimeMS(double dummy) {
    struct timespec ts;
    int ret = clock_gettime(CLOCK_MONOTONIC, &ts);
    if (ret) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: clock_gettime failed (%s)\n", strerror(errno));
    }
    double epoch_ms = (double)ts.tv_sec*1000.0 + floor( (double)ts.tv_nsec/1e6 + 0.5);
    return epoch_ms;
}

/******************************************************/
/* NEXT GENERATION RT-SYNC */
/******************************************************/

/** Real-time synchronization object. */
typedef struct {
    struct timespec t_start;    /**< Time of real-time clock at simulation start */
    struct timespec t_last;     /**< Last time of real-time clock */
    struct timespec t_ideal;    /**< (s) ideal wall clock synchronization time including scaling effects (time without overrun errors) */
    double startSimTime;        /**< (s) simulation time at simulation start */
    double lastSimTime;         /**< (s) last simulation time */
    int shouldCatchupTime;      /**< (boolean flag) if catchupTime != 0 then try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not */
} MDD_RTSync;

/** MDD_RTSync constructor.
*
* @param[in] startSimTime (s) simulation start time (usually 0)
* @param[in] shouldCatchupTime (boolean flag) if catchupTime != 0 then try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not.
* @return MDD_RTSync object
*/
DllExport void* MDD_RTSyncConstructor(double startSimTime, int shouldCatchupTime) {
    int ret;
    MDD_RTSync* rtSync = (MDD_RTSync*)malloc(sizeof(MDD_RTSync));
    if (rtSync) {
        ret = clock_gettime(CLOCK_MONOTONIC, &rtSync->t_start);
        if (ret) {
            free(rtSync);
            rtSync = NULL;
            ModelicaFormatError("MDDRealtimeSynchronize.h: clock_gettime(..) failed (%s)\n", strerror(errno));
        }
        rtSync->t_last = rtSync->t_start;
        rtSync->t_ideal = rtSync->t_start;
        rtSync->startSimTime = startSimTime;
        rtSync->lastSimTime = startSimTime;
        rtSync->shouldCatchupTime = shouldCatchupTime;
    }
    return (void*) rtSync;
}

/** MDD_RTSync destructor. */
DllExport void MDD_RTSyncDestructor(void* rtSyncObj) {
    MDD_RTSync* rtSync = (MDD_RTSync*)rtSyncObj;
    if (rtSync) {
        free(rtSync);
    }
}

/**  Slow down sampling period so that simulation time == real-time.
*
*
* @param[in] rtSyncObj pointer to MDD_RTSync object
* @param[in] simTime (s) simulation time
* @param[in] scaling real-time scaling factor; > 1 means the simulation is made slower than real-time
* @param[out] wallClockTime (s) wall clock time that elapsed since initialization of the real-time synchronization object
* @param[out] remainingTime (s) wall clock time that is left before real-time deadline is reached
* @param[out] computingTime (s) wall clock time between invocations of this function, i.e. "computing time" in seconds
* @param[out] lastSimTime (s) simulation time at the previous invocation of this function, the simulation start time at the first function invocation
*/
DllExport void MDD_RTSyncSynchronize(void * rtSyncObj, double simTime, double scaling, double * wallClockTime, double * remainingTime, double * computingTime, double * lastSimTime) {
    MDD_RTSync* rtSync = (MDD_RTSync*)rtSyncObj;
    struct timespec t_now;
    struct timespec t_elapsed;
    struct timespec t_abs; /* Absolute time until which execution will be delayed (to catch up with real-time) */
    struct timespec t_subtrahend_might_be_modified_for_carry; /* TODO consider changing `timespec_subtract(...)` for less surprising code */
    double samplingPeriod = 0, fractpart = 0, intpart = 0;
    int ret = 0;

    if (rtSync == NULL || wallClockTime == NULL || remainingTime == NULL || computingTime == NULL || lastSimTime == NULL) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: NULL pointer arguments to MDD_sampledRealtimeSynchronize\n");
    }
    *lastSimTime = rtSync->lastSimTime;

    if (simTime - rtSync->startSimTime < 1e-4) {
        /* Apparently first sample, skip synchronization. */
        *wallClockTime = 0;
        *remainingTime = 0;
        *computingTime = 0;
        /* NOTE:
        * It could make sense to (re)initialize the rtSync->startTime and related variables in this
        * if-branch: Doing that, computation time during simulation initialization would not add to the wall-clock time.
        */
    }
    else if (simTime < rtSync->lastSimTime) {
        ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING simTime=%lf < lastSimTime=%lf (possibly due to solver step-size adaption)\n", simTime, rtSync->lastSimTime);
    }
    else {
        samplingPeriod = simTime - rtSync->lastSimTime;
        if (samplingPeriod < 1e-4) {
            /* Commented out the message since this case is happening very often in practice if this function is called in a non-sampled continuous-time context. Reason: At any event the continuous-time equations are usually evaluated several times. */
            /* ModelicaFormatMessage("MDDRealtimeSynchronize.h: WARNING requesting unrealistic small real-time synchronization period of %lf s at simTime=%f\n", samplingPeriod, simTime); */
        }

        ret = clock_gettime(CLOCK_MONOTONIC, &t_now);
        if (ret) {
            ModelicaFormatError("MDDRealtimeSynchronize.h: clock_gettime(..) failed (%s)\n", strerror(errno));
        }

        /* Determine computation time */
        t_subtrahend_might_be_modified_for_carry = rtSync->t_last;
        ret = timespec_subtract(&t_elapsed, &t_now, &t_subtrahend_might_be_modified_for_carry);
        if (ret) {
            ModelicaError("MDDRealtimeSynchronize.h: Uups, negative computing time?!\n");
        }
        *computingTime = t_elapsed.tv_sec + (double)(t_elapsed.tv_nsec/NSEC_PER_SEC);


        /* Determine real-time clock value for syncing */
        fractpart = modf(samplingPeriod*scaling, &intpart);
        if (rtSync->shouldCatchupTime) {
            rtSync->t_ideal.tv_sec = rtSync->t_ideal.tv_sec + (time_t) intpart;
            rtSync->t_ideal.tv_nsec = rtSync->t_ideal.tv_nsec + (long) floor(fractpart*NSEC_PER_SEC);
            while (rtSync->t_ideal.tv_nsec >= NSEC_PER_SEC) {
                rtSync->t_ideal.tv_nsec -= NSEC_PER_SEC;
                rtSync->t_ideal.tv_sec++;
            }
            t_abs.tv_sec = rtSync->t_ideal.tv_sec;
            t_abs.tv_nsec = rtSync->t_ideal.tv_nsec;
        }
        else {
            t_abs.tv_sec = rtSync->t_last.tv_sec + (time_t) intpart;
            t_abs.tv_nsec = rtSync->t_last.tv_nsec + (long) floor(fractpart*NSEC_PER_SEC);
        }
        while (t_abs.tv_nsec >= NSEC_PER_SEC) {
            t_abs.tv_nsec -= NSEC_PER_SEC;
            t_abs.tv_sec++;
        }

        *remainingTime = ( t_abs.tv_sec - t_now.tv_sec )
                         + (double)(t_abs.tv_nsec - t_now.tv_nsec)/NSEC_PER_SEC;

        /* wait until (scaled) simulation time == real-time */
        ret = clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &t_abs, NULL);
        if (ret) {
            ModelicaFormatError("MDDRealtimeSynchronize.h: clock_nanosleep(..) failed\n");
        }

        /* get value the current time of the real-time clock (should be equal to t_abs if everything is OK) */
        clock_gettime(CLOCK_MONOTONIC, &rtSync->t_last);
        rtSync->lastSimTime = simTime;

        /* wall clock time since start */
        t_subtrahend_might_be_modified_for_carry = rtSync->t_start;
        ret = timespec_subtract(&t_elapsed, &(rtSync->t_last), &t_subtrahend_might_be_modified_for_carry);
        if (ret == 1) {
            ModelicaFormatError("MDDRealtimeSynchronize.h: timespec_subtract returned negative number\n");
        }
        *wallClockTime = (double)t_elapsed.tv_sec + (double)t_elapsed.tv_nsec/NSEC_PER_SEC;
    }

}

#else

#error "Modelica_DeviceDrivers: No support of real-time synchronization for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDREALTIMESYNCHRONIZE_H_ */
