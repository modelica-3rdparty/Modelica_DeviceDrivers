/** Synchronize execution with real-time (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version	$Id: MDDRealtimeSynchronize.h 15720 2012-06-05 21:32:39Z thie_be $
 * @since		2012-05-29
 * @copyright Modelica License 2
 */

#ifndef MDDREALTIMESYNCHRONIZE_H_
#define MDDREALTIMESYNCHRONIZE_H_

#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

  #include <windows.h>
  #include "../src/include/CompatibilityDefs.h"
  #pragma comment( lib, "Winmm.lib" )

DllExport void MDD_setPriority(int priority)
  {
    ModelicaFormatMessage("ProcessPriority: %d!!\n",priority);
    switch(priority)
    {
      case -2:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),IDLE_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to idle.\n");
      break;

      case -1:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),BELOW_NORMAL_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to below normal.\n");
      break;

      case 0:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),NORMAL_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to normal.\n");
      break;

      case 1:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),HIGH_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to high.\n");
      break;

      case 2:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),REALTIME_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to realtime.\n");
      break;

      default:
        ModelicaFormatMessage("setting...\n");
        if(SetPriorityClass(GetCurrentProcess(),NORMAL_PRIORITY_CLASS))
          ModelicaFormatMessage("ProcessPriority set to normal.\n");
      break;
    }

    ModelicaFormatMessage("LastError: %d\n",GetLastError());
  }

  /** Request time from a monotonic increasing real-time clock.
   *
   * @param[in] resolution windows specific clock resolution (ignored in linux).
   * @return (ms) time in milliseconds.
   */
DllExport double MDD_getTimeMS(int resolution)
  {
    DWORD ms;

    if(timeBeginPeriod(resolution))
      ModelicaFormatError("realtimeSynchronize: Resolution not supported by hardware!");
    ms = timeGetTime();
    timeEndPeriod(resolution);
    return (double)ms;

  };

DllExport double MDD_realtimeSynchronize(double simTime, int resolution, double * availableTime)
  {
    static LARGE_INTEGER MDD_lastTime = {0};
    static LARGE_INTEGER MDD_startTime = {0};
    static double MDD_lastSimTime = 0;
    static double MDD_lastAvailableTime = 0;
    double calculationTime = 0;
    LARGE_INTEGER now;
    LARGE_INTEGER f;

    if(MDD_startTime.QuadPart == 0) QueryPerformanceCounter(&MDD_startTime);
    if(MDD_lastTime.QuadPart == 0) QueryPerformanceCounter(&MDD_lastTime);

    *availableTime = MDD_lastAvailableTime;
    if(simTime != MDD_lastSimTime)
    {
      QueryPerformanceFrequency(&f); /* This actually is a constant (that should be moved to a constructor of an external object) */
      QueryPerformanceCounter(&now);
      calculationTime = (double)(now.QuadPart - MDD_lastTime.QuadPart)/(double)f.QuadPart;
      *availableTime = simTime - MDD_lastSimTime;
      while((double)(now.QuadPart - MDD_startTime.QuadPart)/(double)f.QuadPart <= simTime)
      {
        QueryPerformanceCounter(&now);
      }
      QueryPerformanceCounter(&MDD_lastTime);
      MDD_lastSimTime = simTime;
      MDD_lastAvailableTime = *availableTime;
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
  #include <sys/mman.h>
  #include "../src/include/CompatibilityDefs.h"
  #define MY_RT_PRIORITY (49) /**< we use 49 since PRREMPT_RT use 50
                                 as the priority of kernel tasklets
                                 and interrupt handlers by default */
  #define NSEC_PER_SEC    (1000000000) /* The number of nsecs per sec. */

  /** Set process priority.
   *
   * Function maps directly on windows API. For linux a mapping was chosen that seemed
   * seemed to be sensible.
   * @param[in] priority range: (-2: idle, -1: below normal, 0: normal, 1: high, 2: realtime)
   */
  void MDD_setPriority(int priority) {
    int ret;
    struct sched_param param;
    errno = 0; /* zero out errno since -1 may be a valid return value for nice(..) and not necessarily indicate error */

    ModelicaFormatMessage("Trying to set ProcessPriority: %d.\n",priority);

    switch(priority) {
      case -2:
        ret = nice(20);
        if (ret == -1 && errno != 0) {
          ModelicaError("MDDRealtimeSynchronize.h: nice(20) failed\n");
          exit(-1);
        } else {
          ModelicaFormatMessage("ProcessPriority set to %d=nice(20) \"idle\".\n", ret);
        }
      break;

      case -1:
        ret = nice(10);
        if (ret == -1 && errno != 0) {
          ModelicaError("MDDRealtimeSynchronize.h: nice(10) failed\n");
          exit(-1);
        } else {
          ModelicaFormatMessage("ProcessPriority set to %d=nice(10) \"below normal\".\n", ret);
        }
      break;

      case 0:
        ret = nice(0);
        if (ret == -1 && errno != 0) {
          ModelicaError("MDDRealtimeSynchronize.h: nice(0) failed\n");
          exit(-1);
        } else {
          ModelicaFormatMessage("ProcessPriority set to %d=nice(0) \"normal\".\n", ret);
        }
      break;

      case 1:
        ModelicaFormatMessage("ProcessPriority \"high\" needs generally *root* privileges! Trying..\n");
        ret = nice(-20);
        if (ret == -1 && errno != 0) {
          ModelicaError("MDDRealtimeSynchronize.h: nice(-20) failed\n");
          exit(-1);
        } else {
          ModelicaFormatMessage("ProcessPriority set to %d=nice(-20) \"high\".\n", ret);
        }
      break;

      case 2:
        ModelicaFormatMessage("ProcessPriority \"Realtime\" needs generally *root* privileges and a real-time kernel (PRREMPT_RT) for hard realtime! Trying..\n");

         /* Lock entire address space into physical memory */
        if(mlockall(MCL_CURRENT | MCL_FUTURE) == -1) {
          ModelicaError("MDDRealtimeSynchronize.h: mlockall failed\n");
          exit(-1);
        }

        /* Declare ourself as a real time task */
        param.sched_priority = MY_RT_PRIORITY;
        if(sched_setscheduler(0, SCHED_FIFO, &param) == -1) {
          ModelicaError("MDDRealtimeSynchronize.h: sched_setscheduler failed\n");
          exit(-1);
        } else {
          ModelicaFormatMessage("ProcessPriority set to \"Realtime\"!\n");
        }
      break;

      default:
        ModelicaFormatMessage("Using default process priority\n");
      break;
    }

  }

  /** Slow down task so that simulation time == real-time.
   *
   * @param[in] simTime (s) simulation time
   * @param[in] resolution windows specific clock resolution. Ignored in linux.
   * @param[out] availableTime time that is left before realtime deadline is reached.
   * @return (s) Time between invocation of this function, i.e. "computing time" in seconds
   */
  double MDD_realtimeSynchronize(double simTime, int resolution, double * availableTime) {
    static int initialized = 0;
    static struct timespec t_start = { .tv_sec = 0, .tv_nsec = 0 };
    static struct timespec t_clockRealtime = { .tv_sec = 0, .tv_nsec = 0 }; /* current/last time of real time clock */
    struct timespec t_abs; /* Absolute time until which execution will be delayed (to catch up with real-time) */
    double fractpart, intpart, deltaTime;
    int ret;

    if (!initialized) {
      ret = clock_gettime(CLOCK_MONOTONIC, &t_start);
      if (ret) {
	ModelicaError("MDDRealtimeSynchronize.h: clock_gettime(..) failed\n");
	exit(-1);

      }
      t_clockRealtime = t_start;
      initialized = 1;
    }

   /* save away value of last time that the real-time clock was inquired */
   deltaTime = t_clockRealtime.tv_sec + (double)t_clockRealtime.tv_nsec/NSEC_PER_SEC;
   /* get value the current time of the real-time clock */
   clock_gettime(CLOCK_MONOTONIC, &t_clockRealtime);
   /* Calculate the deltaTime (=calculation time) by subtracting the
    * old value of the real-time clock from the current (new) value of the real-time clock */
   deltaTime = (t_clockRealtime.tv_sec + (double)t_clockRealtime.tv_nsec/NSEC_PER_SEC) - deltaTime;

   /* convert simulation time to corresponding real-time clock value */
   fractpart = modf(simTime, &intpart);
   t_abs.tv_sec = t_start.tv_sec + (time_t) intpart;
   t_abs.tv_nsec = t_start.tv_nsec + (long) floor(fractpart*NSEC_PER_SEC);
   while (t_abs.tv_nsec >= NSEC_PER_SEC) {
     t_abs.tv_nsec -= NSEC_PER_SEC;
     t_abs.tv_sec++;
   }


   *availableTime = ( t_abs.tv_sec - t_clockRealtime.tv_sec )
      + ((double)t_abs.tv_nsec - (double)t_clockRealtime.tv_nsec)/NSEC_PER_SEC;
   /* printf("t_abs.tv_sec: %d, t_cr.tv_sec: %d, t_abs.tv_nsec: %d, t_cr.tv_nsec: %d\n", t_abs.tv_sec, t_clockRealtime.tv_sec, t_abs.tv_nsec, t_clockRealtime.tv_nsec); */

   /* wait until simulation time == real-time */
   ret = clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &t_abs, NULL);
   if (ret) {
      ModelicaError("MDDRealtimeSynchronize.h: clock_nanosleep(..) failed\n");
      exit(1);
   }

   /* get value the current time of the real-time clock (should be equal to t_abs if everything is OK) */
   clock_gettime(CLOCK_MONOTONIC, &t_clockRealtime);

   return deltaTime;
  }


  double MDD_getTimeMS(int resolution) {
    /* argument resolution is ignored */
    struct timespec ts;
    int ret, ms;

    ret = clock_gettime(CLOCK_MONOTONIC, &ts);
    if (ret) {
        ModelicaFormatError("MDDRealtimeSynchronize.h: clock_gettime failed (%s)\n", strerror(errno));
        exit(-1);
    }

    ms = ts.tv_sec*1000 + floor( (double)ts.tv_nsec/1000.0 + 0.5);

    return (double)ms;

  };

#else

  #error "Modelica_DeviceDrivers: No support of real-time synchronization for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDREALTIMESYNCHRONIZE_H_ */
