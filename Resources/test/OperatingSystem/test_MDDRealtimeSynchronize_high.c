#include <stdio.h>
#include "../../Include/MDDRealtimeSynchronize.h"

int main(void) {
  double simTime, availableTime, calculationTime;
  double Ts = 0.1;
  int alwaysInTime = 1;

  printf("Priority \"high\" with Ts=%lf...\n", Ts);
  MDD_setPriority(1);
  for (simTime=Ts; simTime < 1.0; simTime += Ts) {
    calculationTime = MDD_realtimeSynchronize(simTime, 0, &availableTime);
    printf("simTime: %lf, availableTime: %lf, calculationTime: %lf\n", simTime, availableTime, calculationTime);
    alwaysInTime = alwaysInTime && availableTime > 0;
  }
  printf("Priority \"high\", alwaysInTime: %s\n", alwaysInTime ? "true" : "false");

  return !(alwaysInTime  > 0); /* Need to invert boolean value since a zero return value indicates success */
}

