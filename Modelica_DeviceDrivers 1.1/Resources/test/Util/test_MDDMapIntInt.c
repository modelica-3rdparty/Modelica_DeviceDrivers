/** Test for MDDMapIntInt.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 * @test Test for MDDMapIntInt.c.
 *
*/

#include <stdio.h>
#include <string.h>
#include "../../src/include/util.h"

int test_mapIntInt() {
  void * p_mDDMap;
  int failed = 0, i, res, keys[10];

  p_mDDMap = MDD_mapIntIntConstructor();
  failed = p_mDDMap == NULL ? 1 : failed;

  for (i=0; i<10; i++) {
    MDD_mapIntIntInsert(p_mDDMap, i*2, i*3);
  }

  for (i=0; i<10; i++) {
    res = MDD_mapIntIntLookup(p_mDDMap, i*2);
    failed = res == i*3 ? failed : 1;
  }

  failed = MDD_mapIntIntSize(p_mDDMap) == 10 ? failed : 1;

  MDD_mapIntIntGetKeys(p_mDDMap, keys);
  printf("retrieved keys: ");
  for (i=0; i<10; i++) printf("%d, ", keys[i]);
  printf("\n");

  MDD_mapIntIntDestructor(p_mDDMap);

  return failed;
}

int main() {
  int failed = 0;
  printf("Testing MDDMapIntInt from the Util module ...\n");

  failed = test_mapIntInt();

  printf("Testing MDDMapIntInt from the Util module ...");
  failed == 0 ? printf("\tOK.\n") : printf("\tFAILED");
  return failed;
}
