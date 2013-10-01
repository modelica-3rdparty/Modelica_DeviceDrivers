/** Basic logging stuff (not ready, not used, yet).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-06-19
 * @copyright Modelica License 2
 *
*/

#include <stdio.h>
#include <stdarg.h>

#define UTIL_LOG_DEBUG
#define UTIL_LOG_INFO
#define UTIL_LOG_STDOUT

#ifdef __cplusplus
extern "C" {
#endif

int util_debug(const char *format, ...)
{
#ifdef UTIL_LOG_DEBUG

#ifdef UTIL_LOG_MODELICA
  /* TODO... */
#else
   va_list p_arg;
   int ret;
   printf("MefiCANL2 debug: ");
   va_start(p_arg,format);
   ret = vprintf(format,p_arg);
   va_end(p_arg);
   return ret;
#endif /* end log sink */

#else
   return 0;
#endif  /* end log level */
}


int util_info(const char *format, ...)
{
#ifdef UTIL_LOG_INFO

#ifdef UTIL_LOG_MODELICA
  /* TODO... */
#else
   va_list p_arg;
   int ret;
   printf("MefiCANL2: ");
   va_start(p_arg,format);
   ret = vprintf(format,p_arg);
   va_end(p_arg);
   return ret;
#endif /* end log sink */

#else
   return 0;
#endif  /* end log level */
}

#if defined(__linux__)
#include <time.h>
void msleep(unsigned long millisec) {
    struct timespec req={0},rem={0};
    time_t sec=(int)(millisec/1000);
    millisec=millisec-(sec*1000);
    req.tv_sec=sec;
    req.tv_nsec=millisec*1000000L;
    nanosleep(&req,&rem);
}
#elif defined(_MSC_VER)
#include <windows.h>
void msleep(unsigned long millisec) {
	Sleep(millisec); /* windows specific funktion to sleep some milliseconds */
}


#endif // defined(__linux__)

#ifdef __cplusplus
}
#endif

/* End file util.c */
