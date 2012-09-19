within Modelica_DeviceDrivers.OperatingSystem;
function sleep
 input Real sleepingTime
    "time (in seconds) during the simulation does nothing.";
external "C" OS_Sleep(sleepingTime);
 annotation(Include = "
#ifndef SLEEPWINDOWSLINUX
#define SLEEPWINDOWSLINUX

#if defined(_MSC_VER)
  #define VOID void
  typedef char CHAR;
  typedef short SHORT;
  typedef long LONG;
  typedef unsigned char   u_char;
  typedef unsigned short  u_short;
  typedef unsigned int    u_int;
  typedef unsigned long   u_long;
  typedef unsigned __int64 u_int64;
  #include <winsock2.h>//for compatibility reasons 
  #include <windows.h>
  #include  \"ModelicaUtilities.h\"  
   
  void OS_Sleep(double sleepingTime)
  {
    
    int time_ms = (int)(sleepingTime*1000);
    Sleep(time_ms);
   
  } 
#else
  #include <unistd.h>
  void OS_Sleep(double sleepingTime)
  {
    sleep((int)sleepingTime);
  } 
#endif 
 
#endif 
");
end sleep;
