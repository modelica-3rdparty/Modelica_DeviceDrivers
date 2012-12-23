/** Map/Dictionary support for int key and int value.
 * 
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 *
 * @note 2012-12-22: Provided function *not* (yet) used anywhere (except unit testing).
*/

#include <map>
#include <iostream>
#include <cstdlib>

extern "C" {
#include "ModelicaUtilities.h"
}


typedef std::map<int, int> MapIntInt;

extern "C" {
	void* MDD_mapIntIntConstructor() {
		MapIntInt* mapIntInt = new MapIntInt;
		return (void*) mapIntInt;
	}

	void MDD_mapIntIntDestructor(void* p_mapIntInt) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		delete mapIntInt;
	}

	void MDD_mapIntIntInsert(void* p_mapIntInt, int key, int value) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		mapIntInt->insert(std::pair<int, int>(key, value));
		//(*mapIntInt)[key] = value;
	}

	int MDD_mapIntIntCount(void*p_mapIntInt, int key) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		return mapIntInt->count(key);
	}


	int MDD_mapIntIntLookup(void* p_mapIntInt, int key) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		MapIntInt::iterator pos = mapIntInt->find(key);

		if (pos == mapIntInt->end()) {
			ModelicaFormatError("MDD_mapIntIntLookup: Key '%d' not found\n", key);
			exit(-1);
		}
		return pos->second;
	}

	int MDD_mapIntIntSize(void* p_mapIntInt) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		return mapIntInt->size();
	}

	void MDD_mapIntIntGetKeys(void* p_mapIntInt, int keys[]) {
		MapIntInt* mapIntInt = (MapIntInt*) p_mapIntInt;
		int i=0;
		for (MapIntInt::iterator pos = mapIntInt->begin(); pos != mapIntInt->end(); pos++) {
			keys[i] = pos->first;
			i++;
		}
	}
	
}
