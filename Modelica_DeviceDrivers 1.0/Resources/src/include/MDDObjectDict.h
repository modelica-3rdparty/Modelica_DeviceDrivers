/** C interface to Map/Dictionary support (for CAN messages).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id: MDDObjectDict.h 5522 2012-09-20 22:39:25Z thiele $
 * @since       2012-06-19
 * @copyright Modelica License 2
 *
 * @TODO Integrate everything in util.h?
 *
*/

#ifndef MDDOBJECTDICT_H_
#define MDDOBJECTDICT_H_


void* MDD_objectDictConstructor();

void MDD_objectDictDestructor(void* p_objectDict);

void MDD_objectDictInsert(void* p_objectDict, int msgId, int objectId);

int MDD_objectDictLookup(void* p_objectDict, int msgId);

void MDD_objectDictGetKeys(void* p_objectDict, int* keys);

int MDD_objectDictSize(void* p_objectDict);

#endif /* MDDOBJECTDICT_H_ */




