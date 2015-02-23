/** Little utility functions.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-06-06
 * @copyright Modelica License 2
 *
 */

#ifndef UTIL_H_
#define UTIL_H_




#ifdef __cplusplus
extern "C" {
#endif


#if defined(_MSC_VER)

  #include <windows.h>
  #include "CompatibilityDefs.h"
  /** Sleep for some milliseconds
  *
  * @param ms  milliseconds to sleep
  */
  void MDD_msleep(unsigned long ms) {
    Sleep(ms);
  }

#else
  #include <unistd.h>
  #include "CompatibilityDefs.h"

  void MDD_msleep(unsigned long ms) {
    usleep(ms*1000);
  }

#endif /* _MSC_VER */

/* C wrapper functions to C++ std::map<int,int> */

void* MDD_mapIntIntConstructor();

void MDD_mapIntIntDestructor(void* p_mapIntInt);

void MDD_mapIntIntInsert(void* p_mapIntInt, int key, int value);

int MDD_mapIntIntCount(void* p_mapIntInt, int key);

int MDD_mapIntIntLookup(void* p_mapIntInt, int key);

void MDD_mapIntIntGetKeys(void* p_mapIntInt, int* keys);

int MDD_mapIntIntSize(void* p_mapIntInt);

/* C wrapper functions to C++ std::map<int,void*> */

void* MDD_mapIntpVoidConstructor();

void MDD_mapIntpVoidDestructor(void* p_mapIntpVoid);

void MDD_mapIntpVoidInsert(void* p_mapIntpVoid, int key, void* value);

int MDD_mapIntpVoidCount(void* p_mapIntpVoid, int key);

void* MDD_mapIntpVoidLookup(void* p_mapIntpVoid, int key);

void MDD_mapIntpVoidGetKeys(void* p_mapIntpVoid, int* keys);

int MDD_mapIntpVoidSize(void* p_mapIntpVoid);

#ifdef __cplusplus
}
#endif

#endif /* UTIL_H_ */
