#include "ModelicaUtilities.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

/* Implementation of the external Modelica utility functions to allow C-level testing.

*/

void ModelicaMessage(const char *string) {
	printf("%s", string);
}


void ModelicaFormatMessage(const char *string,...) {
   va_list p_arg;
   va_start(p_arg,string);
   vprintf(string,p_arg);
   va_end(p_arg);
}



void ModelicaError(const char *string) {
   fprintf (stderr, "%s", string);
}


void ModelicaFormatError(const char *string,...) {
   va_list p_arg;
   va_start(p_arg,string);
   vfprintf(stderr, string,p_arg);
   va_end(p_arg);
}


char* ModelicaAllocateString(size_t len) {
  char* str = (char*) malloc(len);
  return str;
}

char* ModelicaAllocateStringWithErrorReturn(size_t len) {
  /* TODO: Implementation with correct behaviour */
  char* str = (char*) malloc(len);
  return str;
}



