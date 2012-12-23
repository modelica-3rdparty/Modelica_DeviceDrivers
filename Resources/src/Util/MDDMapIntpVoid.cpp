/** Map/Dictionary support for int key and void* value.
 * 
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 *
*/

#include <map>
#include <iostream>
#include <cstdlib>
#include <cstdio>

extern "C" {
#include "ModelicaUtilities.h"
}


typedef std::map<int, void*> MapIntpVoid;

extern "C" {
	void* MDD_mapIntpVoidConstructor() {
		MapIntpVoid* mapIntpVoid = new MapIntpVoid;
		return (void*) mapIntpVoid;
	}

	void MDD_mapIntpVoidDestructor(void* p_mapIntpVoid) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		delete mapIntpVoid;
	}

	void MDD_mapIntpVoidInsert(void* p_mapIntpVoid, int key, void* value) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		mapIntpVoid->insert(std::pair<int, void*>(key, value));
		//(*mapIntpVoid)[key] = value;
	}

	int MDD_mapIntpVoidCount(void* p_mapIntpVoid, int key) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		return mapIntpVoid->count(key);
	}

	void* MDD_mapIntpVoidLookup(void* p_mapIntpVoid, int key) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		MapIntpVoid::iterator pos = mapIntpVoid->find(key);

		if (pos == mapIntpVoid->end()) {
			ModelicaFormatError("MDD_mapIntpVoidLookup: Key '%d' not found\n", key);
			exit(-1);
		}
		return pos->second;
	}

	int MDD_mapIntpVoidSize(void* p_mapIntpVoid) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		return mapIntpVoid->size();
	}

	void MDD_mapIntpVoidGetKeys(void* p_mapIntpVoid, int keys[]) {
		MapIntpVoid* mapIntpVoid = (MapIntpVoid*) p_mapIntpVoid;
		int i=0;
		for (MapIntpVoid::iterator pos = mapIntpVoid->begin(); pos != mapIntpVoid->end(); pos++) {
			keys[i] = pos->first;
			i++;
		}
	}
}
