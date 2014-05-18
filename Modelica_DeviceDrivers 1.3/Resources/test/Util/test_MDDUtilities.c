/** Test for MDDUtilities.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2013-05-24
 * @copyright Modelica License 2
 * @test Test for MDDUtilities.h .
 *
*/

#include <stdio.h>
#include <string.h>
#include "../../Include/MDDUtilities.h"

int test_MDD_utilitiesLoadRealParameter() {
  int failed = 0;
  double result;
  const double expected = 13;

  result = MDD_utilitiesLoadRealParameter("parameterInitValues.txt", "var1");
  failed = (result == expected ? 0 : 1);

  return failed;
}

int main() {
  int failed = 0;
  printf("Testing parseParameter() from MDDUtilities.h ...");
  failed = test_MDD_utilitiesLoadRealParameter();

  failed == 0 ? printf("\tOK.\n") : printf("\tFAILED\n");
  return failed;
}
