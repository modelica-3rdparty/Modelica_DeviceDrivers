#include "ModelicaUtilities.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

/* Implementation of the external Modelica utility functions to allow C-level testing.

*/

void ModelicaMessage(const char *string) {
    printf("%s", string);
}

void ModelicaFormatMessage(const char *string, ...) {
    va_list p_arg;
    va_start(p_arg,string);
    vprintf(string,p_arg);
    va_end(p_arg);
}

void ModelicaError(const char *string) {
    fprintf (stderr, "%s", string);
    exit(1);
}

void ModelicaFormatError(const char *string, ...) {
    va_list p_arg;
    va_start(p_arg,string);
    vfprintf(stderr, string,p_arg);
    va_end(p_arg);
    exit(1);
}

char* ModelicaAllocateString(size_t len) {
    char *res = ModelicaAllocateStringWithErrorReturn(len);
    if (!res) {
        ModelicaFormatError("%s:%d: ModelicaAllocateString failed\n", __FILE__, __LINE__);
    }
    return res;
}

char* ModelicaAllocateStringWithErrorReturn(size_t len) {
    char* res = (char*) malloc(len + 1);
    if (res != NULL) {
        res[len] = '\0';
    }
    return res;
}
