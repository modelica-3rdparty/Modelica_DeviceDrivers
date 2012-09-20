#include <stdio.h>
#include "../../src/include/util.h"
#include "../../Include/MDDRealtimeSynchronize.h"

int main(void) {
  double a, b;

  printf("Testing MDD_getTimeMS ..\n");
  a = MDD_getTimeMS(0);
  MDD_msleep(1000);
  b = MDD_getTimeMS(0);
  printf("Time before sleep(1):        %lf\n", a);
  printf("Time after sleep(1):         %lf\n", b);
  printf("Measured time passed in ms : %lf\n", b - a);

  return 0;
}

