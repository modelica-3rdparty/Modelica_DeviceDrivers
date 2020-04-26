/** Map/Dictionary support for int key and void* value.
 *
 * @file
 * @author      bernhard-thiele
 * @author      tbeu
 * @since       2012-12-22
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
*/

#ifndef MDDMAPINTPVOID_H_
#define MDDMAPINTPVOID_H_

#include <stdlib.h>

#include "ModelicaUtilities.h"

#define uthash_fatal(msg) ModelicaFormatMessage("Error: %s\n", msg); break
#include "../thirdParty/uthash/uthash.h"

typedef struct MapIntpVoid {
    int first;
    void* second;
    UT_hash_handle hh; /* Hashable structure */
} MapIntpVoid;

void* MDD_mapIntpVoidConstructor() {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) malloc(sizeof(MapIntpVoid*));
    if (mapIntpVoid) {
        *mapIntpVoid = NULL;
    }
    return (void*) mapIntpVoid;
}

void MDD_mapIntpVoidDestructor(void* p_mapIntpVoid) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        MapIntpVoid* m;
        MapIntpVoid* tmp;
        HASH_ITER(hh, *mapIntpVoid, m, tmp) {
            HASH_DEL(*mapIntpVoid, m);
            free(m);
        }
        free(mapIntpVoid);
    }
}

void MDD_mapIntpVoidInsert(void* p_mapIntpVoid, int key, void* value) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        MapIntpVoid* m;
        HASH_FIND_INT(*mapIntpVoid, &key, m);
        if (!m) {
            m = (MapIntpVoid*) malloc(sizeof(MapIntpVoid));
            if (m) {
                m->first = key;
                m->second = value;
                HASH_ADD_INT(*mapIntpVoid, first, m);
            }
        }
        else {
            m->second = value;
        }
    }
}

int MDD_mapIntpVoidCount(void* p_mapIntpVoid, int key) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        MapIntpVoid* m;
        HASH_FIND_INT(*mapIntpVoid, &key, m);
        return m ? 1 : 0;
    }
    return 0;
}

void* MDD_mapIntpVoidLookup(void* p_mapIntpVoid, int key) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        MapIntpVoid* m;
        HASH_FIND_INT(*mapIntpVoid, &key, m);
        if (!m) {
            ModelicaFormatError("MDD_mapIntpVoidLookup: Key '%d' not found\n", key);
        }
        return m->second;
    }
    ModelicaFormatError("MDD_mapIntpVoidLookup: Key '%d' not found\n", key);
    return 0;
}

int MDD_mapIntpVoidSize(void* p_mapIntpVoid) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        return (int) HASH_COUNT(*mapIntpVoid);
    }
    return 0;
}

void MDD_mapIntpVoidGetKeys(void* p_mapIntpVoid, int keys[]) {
    MapIntpVoid** mapIntpVoid = (MapIntpVoid**) p_mapIntpVoid;
    if (mapIntpVoid) {
        MapIntpVoid* m;
        MapIntpVoid* tmp;
        int i = 0;
        HASH_ITER(hh, *mapIntpVoid, m, tmp) {
            keys[i] = m->first;
            i++;
        }
    }
}

#endif /* MDDMAPINTPVOID_H_ */
