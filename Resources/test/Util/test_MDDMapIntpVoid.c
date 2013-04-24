/** Test for MDDMapIntpVoid.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 * @test Test for MDDMapIntpVoid.c.
 *
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../src/include/util.h"

int test_mapIntpVoid() {
  void * p_mDDMap;
  char* data, cmp[10];
  int failed = 0, i, keys[10];

  p_mDDMap = MDD_mapIntpVoidConstructor();
  failed = p_mDDMap == NULL ? 1 : failed;

  for (i=0; i<10; i++) {
    data = malloc(10);
    sprintf(data, "%d", i*3);
    MDD_mapIntpVoidInsert(p_mDDMap, i*2, data);
  }

  for (i=0; i<10; i++) {
    data = MDD_mapIntpVoidLookup(p_mDDMap, i*2);
    sprintf(cmp, "%d", i*3);
    failed = strcmp(data, cmp) ? 1 : failed;
  }

  failed = MDD_mapIntpVoidSize(p_mDDMap) == 10 ? failed : 1;

  MDD_mapIntpVoidGetKeys(p_mDDMap, keys);
  printf("retrieved keys: ");
  for (i=0; i<10; i++) printf("%d, ", keys[i]);
  printf("\n");

  MDD_mapIntpVoidDestructor(p_mDDMap);

  return failed;
}

int main() {
  int failed = 0;
  printf("Testing MDDMapIntpVoid from the Util module ...\n");

  failed = test_mapIntpVoid();

  printf("Testing MDDMapIntpVoid from the Util module ...");
  failed == 0 ? printf("\tOK.\n") : printf("\tFAILED\n");
  return failed;
}
