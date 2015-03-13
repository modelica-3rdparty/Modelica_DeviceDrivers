/** Shared memory support (header-only library).
 *
 * @file
 * @author  Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author  Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @since   2012-06-04
 * @copyright Modelica License 2
 *
 */

#ifndef MDDSHAREDMEMORY_H_
#define MDDSHAREDMEMORY_H_

#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

#include <windows.h>
#include "../src/include/CompatibilityDefs.h"
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

/** Shared memory object */
typedef struct {
    char * smBuf;
    char * smBufExport;
    HANDLE hMapFile;
} MDDSharedMemory;

#define MDDSM_PLOCK ((long*)smb->smBuf)
#define MDDSM_PLEN (MDDSM_PLOCK + sizeof(long))
#define MDDSM_DATA (MDDSM_PLEN + sizeof(int))
#define MDDSM_LOCK() while (InterlockedExchange(MDDSM_PLOCK, 1L) != 0) Sleep(0)
#define MDDSM_UNLOCK() InterlockedExchange(MDDSM_PLOCK, 0)

DllExport void* MDD_SharedMemoryConstructor(const char * name, int bufSize) {
    MDDSharedMemory * smb = (MDDSharedMemory *)malloc(sizeof(MDDSharedMemory));
    smb->hMapFile = CreateFileMappingA(
                        INVALID_HANDLE_VALUE,    /* use paging file */
                        NULL,                    /* default security */
                        PAGE_READWRITE,          /* read/write access */
                        0,                       /* maximum object size (high-order DWORD) */
                        sizeof(long) + sizeof(int) + bufSize, /* maximum object size (low-order DWORD) */
                        name);                 /* name of mapping object */
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        smb->hMapFile = OpenFileMappingA(
                            FILE_MAP_ALL_ACCESS,   /* read/write access */
                            FALSE,                 /* do not inherit the name */
                            name);                 /* name of mapping object */
        /* printf(\"Opening existing FileMapping\\n\"); */
    }

    if (smb->hMapFile == NULL) {
        free(smb);
        ModelicaFormatError("MDDSharedMemory.h: Could not create file mapping object (%d).\n", GetLastError());
        return NULL;
    }
    smb->smBuf = (char*) MapViewOfFile(
                           smb->hMapFile, /* handle to map object */
                           FILE_MAP_ALL_ACCESS, /* read/write permission */
                           0,
                           0,
                           sizeof(long) + sizeof(int) + bufSize);

    if (smb->smBuf == NULL) {
        CloseHandle(smb->hMapFile);
        free(smb);
        ModelicaFormatError("MDDSharedMemory.h: Could not map view of file (%d).\n", GetLastError());
        return NULL;
    }
    smb->smBufExport = (char*) calloc(bufSize, 1);

    return smb;
}

DllExport void MDD_SharedMemoryDestructor(void* p_smb) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        if (smb->smBufExport) {
            free(smb->smBufExport);
        }
        UnmapViewOfFile(smb->smBuf);
        CloseHandle(smb->hMapFile);
        free(smb);
    }
}

DllExport int MDD_SharedMemoryGetDataSize(void * p_smb) {
    int len = 0;
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        MDDSM_LOCK();
        memcpy(&len, MDDSM_PLEN, sizeof(int));
        MDDSM_UNLOCK();
    }
    return len;
}

DllExport const char * MDD_SharedMemoryRead(void * p_smb) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        int len;
        MDDSM_LOCK();
        memcpy(&len, MDDSM_PLEN, sizeof(int));
        memcpy(smb->smBufExport, MDDSM_DATA, len);
        MDDSM_UNLOCK();
    }
    return (const char*) smb->smBufExport;
}

DllExport void MDD_SharedMemoryWrite(void * p_smb, const char * buffer, int len) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    MDDSM_LOCK();
    memcpy(MDDSM_DATA, buffer, len);
    memcpy(MDDSM_PLEN, &len, sizeof(int));
    MDDSM_UNLOCK();
}

#elif defined(__linux__)

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <semaphore.h>
#include <sys/fcntl.h>
#include <sys/mman.h>
#include "../src/include/CompatibilityDefs.h"

typedef struct MDDMmap_struct MDDMmap;

/** External object structure keeping track of persistent data
 */
struct MDDMmap_struct {
    char shmname[30]; /**< name of memory partition */
    char semname[33]; /**< name of semaphore derived from shmname */
    int shm_size; /**< size of shared memory partition in bytes */
    int shmdes;  /**< shared memory file descriptor */
    caddr_t shmptr;  /**< pointer to shared memory partition */
    char * shmReadBuffer; /**< pointer to dedicated read buffer */
    sem_t *semdes; /**< address of semaphore */
};

void * MDD_SharedMemoryConstructor(const char * name, int bufSize) {
    int sval;
    MDDMmap* smb = (MDDMmap*) malloc(sizeof(MDDMmap));
    smb->shm_size = bufSize;
    smb->shmReadBuffer = (char *) malloc(smb->shm_size);
    strncpy(smb->shmname, name, (30 - 1));
    strcpy(smb->semname, smb->shmname);
    strcat(smb->semname, "sem");

    ModelicaFormatMessage("Create semaphore '%s' in free state.\n", smb->semname);
    /*Note: If O_CREAT is specified, and a semaphore with the given name already
      exists, then mode and value are ignored. */
    smb->semdes = sem_open(smb->semname, O_CREAT, 0644, 1);
    if(smb->semdes == SEM_FAILED) {
        ModelicaFormatError("MDDSharedMemory.h: sem_open failure (%s)\n", strerror(errno));
    }

    sem_getvalue(smb->semdes, &sval);
    if (sval < 1) {
        ModelicaFormatMessage("Attention: Semaphore '%s' is locked (has currently value %d).\n"
                              "Attention: Will have to wait until it is released (this may lock forever!)\n", smb->semname, sval);
    }

    /* Lock the semaphore */
    if (!sem_wait(smb->semdes)) {
        int ret;

        if (sem_getvalue(smb->semdes, &sval)) {
            ModelicaFormatError("MDDSharedMemory.h: sem_getvalue failed (%s)\n", strerror(errno));
        }

        ModelicaFormatMessage("Open shared memory object '%s' for r/w\n", smb->shmname);
        smb->shmdes = shm_open(smb->shmname, O_CREAT|O_RDWR|O_TRUNC, 0644);
        if ( smb->shmdes == -1 ) {
            ModelicaFormatError("MDDSharedMemory.h: shm_open failure (%s)", strerror(errno));
        }

        /* 'truncate' shared memory object to needed size
         * (preallocate the shared memory area) */
        ret = ftruncate(smb->shmdes, smb->shm_size);
        if (ret == -1) {
            ModelicaFormatError("MDDSharedMemory.h: ftruncate failure (%s)\n", strerror(errno));
        }

        /* Attach shared memory object to pointer (read/write) */
        smb->shmptr = mmap(0, smb->shm_size, PROT_WRITE|PROT_READ, MAP_SHARED,
                           smb->shmdes,0);

        if (smb->shmptr == MAP_FAILED) {
            ModelicaFormatError("MDDSharedMemory.h: mmap failure (%s)\n", strerror(errno));
        }

        /* Release the semaphore lock */
        sem_post(smb->semdes);
        if (sem_getvalue(smb->semdes, &sval)) {
            ModelicaFormatError("MDDSharedMemory.h: sem_getvalue failed (%s)\n", strerror(errno));
        }
    }

    return (void*) smb;
}

void MDD_SharedMemoryDestructor(void * p_smb) {
    MDDMmap* smb = (MDDMmap*) p_smb;
    int ret;

    munmap(smb->shmptr, smb->shm_size);

    ModelicaFormatMessage("Closing shared memory object '%s' and semaphore '%s'  ...\n", smb->shmname, smb->semname);
    /* Close the shared memory object */
    ret = close(smb->shmdes);
    if(ret) {
        ModelicaFormatError("MDDSharedMemory.h: close failed (%s)\n", strerror(errno));
    }
    /* Close the semaphore */
    ret = sem_close(smb->semdes);
    if(ret) {
        ModelicaFormatError("MDDSharedMemory.h: sem_close failed (%s)\n", strerror(errno));
    }

    ModelicaFormatMessage("Unlinking shared memory object '%s' and semaphore '%s' ...\n", smb->shmname, smb->semname);
    /* Delete the shared memory object */
    ret = shm_unlink(smb->shmname);
    if(ret) {
        if (errno == ENOENT) {
            ModelicaFormatMessage("Shared memory object '%s' seems to be already removed (possibly by remote process)\n");
        }
        else {
            ModelicaFormatError("MDDSharedMemory.h: shm_unlink failed (%s)\n", strerror(errno));
        }
    }
    else {
        ModelicaFormatMessage("Shared memory object '%s' successfully unlinked\n", smb->shmname);
    }
    /* Unlink the semaphore */
    ret = sem_unlink(smb->semname);
    if(ret) {
        if (errno == ENOENT) {
            ModelicaFormatMessage("Semaphore '%s' seems to be already removed (possibly by remote process)\n");
        }
        else {
            ModelicaFormatError("MDDSharedMemory.h: sem_unlink failed (%s)\n", strerror(errno));
        }
    }
    else {
        ModelicaFormatMessage("Semaphore '%s' successfully unlinked\n", smb->semname);
    }

    free(smb);
}

const char * MDD_SharedMemoryRead(void* p_smb) {
    MDDMmap* smb = (MDDMmap*) p_smb;

    /* Lock the semaphore */
    if(!sem_wait(smb->semdes)) {
        /* Access to the shared memory area */
        memcpy(smb->shmReadBuffer, smb->shmptr, smb->shm_size);
        /* Release the semaphore lock */
        sem_post(smb->semdes);
    }
    return smb->shmReadBuffer;
}

void MDD_SharedMemoryWrite(void* p_smb, const char * buffer, unsigned int len) {
    MDDMmap* smb = (MDDMmap*) p_smb;

    /* Lock the semaphore */
    if(!sem_wait(smb->semdes)) {
        /* Access to the shared memory area */
        memcpy(smb->shmptr, buffer, len);
        /* Release the semaphore lock */
        sem_post(smb->semdes);
    }
}

int MDD_SharedMemoryGetDataSize(void * p_smb) {
    MDDMmap* smb = (MDDMmap*) p_smb;
    return smb->shm_size;
}

#else

#error "Modelica_DeviceDrivers: No support of shared memory for your platform"

#endif /* defined(_MSC_VER) */

#endif /* MDDSHAREDMEMORY_H_ */
