/** Test for MDDSpaceMouse.
 *
 * @file
 * @author	Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version	$Id$
 * @since	2012-06-05
 * @copyright Modelica License 2
 * @test Interactive test for MDDSpaceMouse.c.
 *
*/

#include <stdio.h>

#include "../../src/include/util.h"
#include "../../Include/MDDSpaceMouse.h"


int main(void) {
  double pdAxes[6];
  int piButtons[16], i;

  while (1) {
    MDD_spaceMouseGetData(pdAxes, piButtons);

    printf("x=%+5.0lf y=%+5.0lf z=%+5.0lf a=%+5.0lf b=%+5.0lf c=%+5.0lf   ",
           pdAxes[0], pdAxes[1], pdAxes[2], pdAxes[3], pdAxes[4], pdAxes[5]);

    for (i=0; i < 16; i++) printf("B%d: %d ", i, piButtons[i]);
    printf(" \r");

    MDD_msleep(1);
  }

  return 0;
}
