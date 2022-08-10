/** Map/Dictionary support for int key and int value.
 *
 * @file
 * @author      bernhard-thiele
 * @author      tbeu
 * @since       2012-12-22
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * @note 2012-12-22: Provided function *not* (yet) used anywhere (except unit testing).
*/

#ifndef MDDMAPINTINT_H_
#define MDDMAPINTINT_H_

#include <stdlib.h>

#include "ModelicaUtilities.h"

#define uthash_fatal(msg) ModelicaFormatMessage("Error: %s\n", msg); break
#include "../../thirdParty/uthash/uthash.h"

typedef struct MapIntInt {
    int first;
    int second;
    UT_hash_handle hh; /* Hashable structure */
} MapIntInt;

void* MDD_mapIntIntConstructor() {
    MapIntInt** mapIntInt = (MapIntInt**) malloc(sizeof(MapIntInt*));
    if (mapIntInt) {
        *mapIntInt = NULL;
    }
    return (void*) mapIntInt;
}

void MDD_mapIntIntDestructor(void* p_mapIntInt) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        MapIntInt* m;
        MapIntInt* tmp;
        HASH_ITER(hh, *mapIntInt, m, tmp) {
            HASH_DEL(*mapIntInt, m);
            free(m);
        }
        free(mapIntInt);
    }
}

void MDD_mapIntIntInsert(void* p_mapIntInt, int key, int value) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        MapIntInt* m;
        HASH_FIND_INT(*mapIntInt, &key, m);
        if (!m) {
            m = (MapIntInt*) malloc(sizeof(MapIntInt));
            if (m) {
                m->first = key;
                m->second = value;
                HASH_ADD_INT(*mapIntInt, first, m);
            }
        }
        else {
            m->second = value;
        }
    }
}

int MDD_mapIntIntCount(void*p_mapIntInt, int key) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        MapIntInt* m;
        HASH_FIND_INT(*mapIntInt, &key, m);
        return m ? 1 : 0;
    }
    return 0;
}

int MDD_mapIntIntLookup(void* p_mapIntInt, int key) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        MapIntInt* m;
        HASH_FIND_INT(*mapIntInt, &key, m);
        if (!m) {
            ModelicaFormatError("MDD_mapIntIntLookup: Key '%d' not found\n", key);
        }
        return m->second;
    }
    ModelicaFormatError("MDD_mapIntIntLookup: Key '%d' not found\n", key);
    return 0;
}

int MDD_mapIntIntSize(void* p_mapIntInt) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        return (int) HASH_COUNT(*mapIntInt);
    }
    return 0;
}

void MDD_mapIntIntGetKeys(void* p_mapIntInt, int keys[]) {
    MapIntInt** mapIntInt = (MapIntInt**) p_mapIntInt;
    if (mapIntInt) {
        MapIntInt* m;
        MapIntInt* tmp;
        int i = 0;
        HASH_ITER(hh, *mapIntInt, m, tmp) {
            keys[i] = m->first;
            i++;
        }
    }
}

#endif /* MDDMAPINTINT_H_ */
