/** Map/Dictionary support (for CAN messages).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id: MDDObjectDict.cpp 5522 2012-09-20 22:39:25Z thiele $
 * @since       2012-06-19
 * @copyright Modelica License 2
 *
*/

#include <stdlib.h>
#include <map>
#include <iostream>

extern "C" {
#include "ModelicaUtilities.h"
}


typedef std::map<int, int> ObjectDict;


extern "C" {
	void* MDD_objectDictConstructor() {
		ObjectDict* objectDict = new ObjectDict;
		return (void*) objectDict;
	}

	void MDD_objectDictDestructor(void* p_objectDict) {
		ObjectDict* objectDict = (ObjectDict*) p_objectDict;
		delete objectDict;
	}

	void MDD_objectDictInsert(void* p_objectDict, int msgId, int objectId) {
		ObjectDict* objectDict = (ObjectDict*) p_objectDict;
		objectDict->insert(std::pair<int, int>(msgId, objectId));
		//(*objectDict)[msgId] = objectId;
	}

	int MDD_objectDictLookup(void* p_objectDict, int msgId) {
		ObjectDict* objectDict = (ObjectDict*) p_objectDict;
		ObjectDict::iterator pos = objectDict->find(msgId);

		if (pos == objectDict->end()) {
			ModelicaFormatError("MDD_objectDictLookup: Key '%d' not found\n", msgId);
			exit(-1);
		}
		return pos->second;
	}

	int MDD_objectDictSize(void* p_objectDict) {
		ObjectDict* objectDict = (ObjectDict*) p_objectDict;
		return objectDict->size();
	}

	void MDD_objectDictGetKeys(void* p_objectDict, int keys[]) {
		ObjectDict* objectDict = (ObjectDict*) p_objectDict;
		int i=0;
		for (ObjectDict::iterator pos = objectDict->begin(); pos != objectDict->end(); pos++) {
			keys[i] = pos->first;
			i++;
		}
	}

}
