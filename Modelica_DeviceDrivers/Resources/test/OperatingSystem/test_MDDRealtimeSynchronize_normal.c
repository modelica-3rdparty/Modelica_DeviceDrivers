#include <stdio.h>
#include "../../Include/MDDRealtimeSynchronize.h"

int main(void) {
  double simTime, availableTime, calculationTime;
  double Ts = 0.1;
  int alwaysInTime = 1;
  void* procPrio = MDD_ProcessPriorityConstructor();
  void* rtSync = MDD_realtimeSynchronizeConstructor();

  printf("Priority \"Normal\" with Ts=%lf...\n", Ts);
  MDD_setPriority(procPrio, 0);
  for (simTime=Ts; simTime < 1.0; simTime += Ts) {
    calculationTime = MDD_realtimeSynchronize(rtSync, simTime, &availableTime);
    printf("simTime: %lf, availableTime: %lf, calculationTime: %lf\n", simTime, availableTime, calculationTime);
    alwaysInTime = alwaysInTime && availableTime > 0;
  }
  printf("Priority \"Normal\", alwaysInTime: %s\n", alwaysInTime ? "true" : "false");
  MDD_realtimeSynchronizeDestructor(rtSync);
  MDD_ProcessPriorityDestructor(procPrio);

  return !(alwaysInTime  > 0); /* Need to invert boolean value since a zero return value indicates success */
}

