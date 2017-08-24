/** Shared memory support (header-only library).
 *
 * @file
 * @author  tbellmann (Windows)
 * @author  bernhard-thiele (Linux)
 * @author  tbeu
 * @since   2012-06-04
 * @copyright see Modelica_DeviceDrivers project's License.txt file
 *
 */

#ifndef MDDSHAREDMEMORY_H_
#define MDDSHAREDMEMORY_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"
#include "MDDSerialPackager.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "../src/include/CompatibilityDefs.h"

/** Shared memory object */
typedef struct {
    char * smBuf;
    HANDLE hMapFile;
    int size;
    HANDLE hSemaphore;
} MDDSharedMemory;

DllExport void* MDD_SharedMemoryConstructor(const char * name, int bufSize) {
    MDDSharedMemory * smb = (MDDSharedMemory *)malloc(sizeof(MDDSharedMemory));
    char semName[MAX_PATH];

    strncpy(semName, name, MAX_PATH - 4);
    strcat(semName, "sem");
    smb->hSemaphore = CreateSemaphoreA(NULL, 1, 1, semName);
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        smb->hMapFile = OpenSemaphoreA(SYNCHRONIZE | SEMAPHORE_MODIFY_STATE, FALSE, semName);
    }
    if (smb->hSemaphore == NULL) {
        free(smb);
        ModelicaFormatError("MDDSharedMemory.h: Could not create semaphore object: %lu.\n", GetLastError());
        return NULL;
    }

    smb->hMapFile = CreateFileMappingA(INVALID_HANDLE_VALUE,  NULL, PAGE_READWRITE, 0, bufSize, name);
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        smb->hMapFile = OpenFileMappingA(FILE_MAP_ALL_ACCESS, FALSE, name);
    }
    if (smb->hMapFile == NULL) {
        CloseHandle(smb->hSemaphore);
        free(smb);
        ModelicaFormatError("MDDSharedMemory.h: Could not create file mapping object: %lu.\n", GetLastError());
        return NULL;
    }

    smb->smBuf = (char*) MapViewOfFile(smb->hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, bufSize);
    if (smb->smBuf == NULL) {
        CloseHandle(smb->hMapFile);
        CloseHandle(smb->hSemaphore);
        free(smb);
        ModelicaFormatError("MDDSharedMemory.h: Could not map view of file: %lu.\n", GetLastError());
        return NULL;
    }

    smb->size = bufSize;

    return smb;
}

DllExport void MDD_SharedMemoryDestructor(void* p_smb) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        UnmapViewOfFile(smb->smBuf);
        CloseHandle(smb->hMapFile);
        CloseHandle(smb->hSemaphore);
        free(smb);
    }
}

DllExport int MDD_SharedMemoryGetDataSize(void * p_smb) {
    int len = 0;
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        len = smb->size;
    }
    return len;
}

DllExport const char * MDD_SharedMemoryRead(void * p_smb) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        char* smBuf;
        smBuf = ModelicaAllocateStringWithErrorReturn(smb->size);
        if (smBuf) {
            while (WAIT_OBJECT_0 != WaitForSingleObject(smb->hSemaphore, 0));
            memcpy(smBuf, smb->smBuf, smb->size);
            ReleaseSemaphore(smb->hSemaphore, 1L, NULL);
            return (const char*) smBuf;
        }
        else {
            ModelicaError("MDDSharedMemory.h: ModelicaAllocateString failed\n");
        }
    }
    return "";
}

DllExport void MDD_SharedMemoryReadP(void * p_smb, void* p_package) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    if (smb) {
        int rc;
        while (WAIT_OBJECT_0 != WaitForSingleObject(smb->hSemaphore, 0));
        rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, smb->smBuf, smb->size);
        ReleaseSemaphore(smb->hSemaphore, 1L, NULL);
        if (rc) {
            ModelicaError("MDDSharedMemory.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
        }
    }
}

DllExport void MDD_SharedMemoryWrite(void * p_smb, const char * buffer, int len) {
    MDDSharedMemory * smb = (MDDSharedMemory *) p_smb;
    while (WAIT_OBJECT_0 != WaitForSingleObject(smb->hSemaphore, 0));
    memcpy(smb->smBuf, buffer, len);
    ReleaseSemaphore(smb->hSemaphore, 1L, NULL);
}

DllExport void MDD_SharedMemoryWriteP(void * p_smb, void* p_package, int len) {
    MDD_SharedMemoryWrite(p_smb, MDD_SerialPackagerGetData(p_package), len);
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
    sem_t *semdes; /**< address of semaphore */
};

void * MDD_SharedMemoryConstructor(const char * name, int bufSize) {
    int sval;
    MDDMmap* smb = (MDDMmap*) malloc(sizeof(MDDMmap));
    smb->shm_size = bufSize;
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
        char* smBuf = ModelicaAllocateStringWithErrorReturn(smb->shm_size);
        if (smBuf) {
            /* Access to the shared memory area */
            memcpy(smBuf, smb->shmptr, smb->shm_size);
            /* Release the semaphore lock */
            sem_post(smb->semdes);
            return (const char*) smBuf;
        }
        else {
            /* Release the semaphore lock */
            sem_post(smb->semdes);
            ModelicaError("MDDSharedMemory.h: ModelicaAllocateString failed\n");
        }
    }
    return "";
}

void MDD_SharedMemoryReadP(void* p_smb, void* p_package) {
    MDDMmap* smb = (MDDMmap*) p_smb;

    /* Lock the semaphore */
    if(!sem_wait(smb->semdes)) {
        /* Access to the shared memory area */
        int rc = MDD_SerialPackagerSetDataWithErrorReturn(p_package, smb->shmptr, smb->shm_size);
        /* Release the semaphore lock */
        sem_post(smb->semdes);
        if (rc) {
            ModelicaError("MDDSharedMemory.h: MDD_SerialPackagerSetData failed. Buffer overflow.\n");
        }
    }
}

void MDD_SharedMemoryWrite(void* p_smb, const char * buffer, int len) {
    MDDMmap* smb = (MDDMmap*) p_smb;

    /* Lock the semaphore */
    if(!sem_wait(smb->semdes)) {
        /* Access to the shared memory area */
        memcpy(smb->shmptr, buffer, len);
        /* Release the semaphore lock */
        sem_post(smb->semdes);
    }
}

void MDD_SharedMemoryWriteP(void* p_smb, void* p_package, int len) {
    MDD_SharedMemoryWrite(p_smb, MDD_SerialPackagerGetData(p_package), len);
}

int MDD_SharedMemoryGetDataSize(void * p_smb) {
    MDDMmap* smb = (MDDMmap*) p_smb;
    return smb->shm_size;
}

#else

#error "Modelica_DeviceDrivers: No support of shared memory for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDSHAREDMEMORY_H_ */
