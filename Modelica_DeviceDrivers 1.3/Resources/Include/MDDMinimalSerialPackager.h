/** Minimal serial packager (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de>
 * @author		Bernhard Thiele <bernhard.thiele@dlr.de> (little adaptions)
 * @version	$Id: MDDMinimalSerialPackager.h 16375 2012-07-23 12:01:12Z thie_be $
 * @since		2012-05-30
 * @copyright Modelica License 2
 *
 * @deprecated This packager has been replaced by MDDSerialPackager.h
 */

#ifndef MDDMinimalSerialPackager_H_
#define MDDMinimalSerialPackager_H_

#include <stdlib.h>
#include <string.h>
#include "ModelicaUtilities.h"

struct MSP_PackagerData
{
  char * buffer;
  int pos;
  int bufferSize;

};

void * MSP_createPackager(int bufferSize)
{
  struct MSP_PackagerData * MSP_PackagerData = (struct MSP_PackagerData *)malloc(sizeof(struct MSP_PackagerData));
  MSP_PackagerData->buffer = (char*)malloc(sizeof(char) * bufferSize);
  MSP_PackagerData->bufferSize = bufferSize;
  memset(MSP_PackagerData->buffer,0, MSP_PackagerData->bufferSize);
  MSP_PackagerData->pos = 0;
  return (void*) MSP_PackagerData;
}


void MSP_destroyPackager(  int p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  free(MSP_PackagerData->buffer);
  free(MSP_PackagerData);

}
void MSP_addReal(int p_MSP_PackagerData, double * u,  int n)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  int typeSize = sizeof(double);
  /* ModelicaFormatMessage(\"addReal: pos: %d \\n\",MSP_PackagerData->pos); */
  /* check bufferSize */
  if(MSP_PackagerData->pos + typeSize*n > MSP_PackagerData->bufferSize)
    ModelicaFormatError("SimpleSerialPackager: Buffer overflow.");

  /* copy data in buffer */
  memcpy(MSP_PackagerData->buffer + MSP_PackagerData->pos, u, typeSize * n);
  MSP_PackagerData->pos += typeSize * n ;

}

void MSP_addInteger(int p_MSP_PackagerData, int * u, int n)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  int typeSize = sizeof(int);
  /* ModelicaFormatMessage(\"addInteger: pos: %d \\n\",MSP_PackagerData->pos); */
  /* check bufferSize */
  if(MSP_PackagerData->pos + typeSize*n > MSP_PackagerData->bufferSize)
    ModelicaFormatError("SimpleSerialPackager: Buffer overflow.");

  /* copy data in buffer */
  memcpy(MSP_PackagerData->buffer + MSP_PackagerData->pos, u, typeSize * n);
  MSP_PackagerData->pos += typeSize * n;

}

void MSP_addString(int p_MSP_PackagerData, char * u)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  int typeSize = sizeof(char);
  int len = 0;

  /* find zero terminated end of string */
  for( len = 0; len < MSP_PackagerData->bufferSize; len++)
    if (u[len] == 0) break;
  ModelicaFormatMessage("addString: %s \n",u);
  /* copy data in buffer */
  memcpy(MSP_PackagerData->buffer + MSP_PackagerData->pos, u, typeSize * (len+1));
  MSP_PackagerData->pos += typeSize * (len+1);

}

const char * MSP_getPackage( int p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  /* this is potentially dangerous. */
  /* ModelicaFormatMessage(\"getPackage: pointerPosition: %d\\n\",MSP_PackagerData->pos); */
  return (const char*)MSP_PackagerData->buffer;
}
void MSP_setPackage( int p_MSP_PackagerData, char * package, int bufferSize)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  memcpy(MSP_PackagerData->buffer,package,  bufferSize);
  MSP_PackagerData->bufferSize = bufferSize;
  MSP_PackagerData->pos = 0;
}

void MSP_getReal( int  p_MSP_PackagerData, double * y, int n)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  int typeSize = sizeof(double);

  /* ModelicaFormatMessage(\"readReal: pos: %d \\n\",MSP_PackagerData->pos); */
  /* get data */
  memcpy(y,MSP_PackagerData->buffer+ MSP_PackagerData->pos,typeSize * n);
  MSP_PackagerData->pos+=typeSize * n;


}

void MSP_getInteger( int p_MSP_PackagerData, int * y, int n)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  int typeSize = sizeof(int);

  /* ModelicaFormatMessage(\"readInteger: pos: %d \\n\",MSP_PackagerData->pos); */
  /* get data */
  memcpy(y,MSP_PackagerData->buffer+ MSP_PackagerData->pos,typeSize * n);
  /* printf(\"getInteger: %d \\n\",y[0]); */
  MSP_PackagerData->pos+=typeSize * n;

}

const char * MSP_getString( int p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  char * y;
  /* int len; */
  int i;

  int typeSize = sizeof(char);


  /* find zero terminated end of string */
  for( i = MSP_PackagerData->pos; i < MSP_PackagerData->bufferSize; i++)
    if (MSP_PackagerData->buffer[i] == 0) break;

  /* ModelicaFormatMessage(\"Stringlen: %d \\n\",(i - MSP_PackagerData->pos + 1)); */
  /* Allocate Memory for String */


  y = MSP_PackagerData->buffer+ MSP_PackagerData->pos;
  /* get data */
  MSP_PackagerData->pos+=typeSize *(i - MSP_PackagerData->pos + 1);
  return (const char*)y;
}

void MSP_resetPointer ( int p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  MSP_PackagerData->pos = 0;
}

void MSP_clear( int p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  memset(MSP_PackagerData->buffer,0, MSP_PackagerData->bufferSize);
  MSP_PackagerData->pos = 0;
}
int MSP_getBufferSize( int  p_MSP_PackagerData)
{
  struct MSP_PackagerData * MSP_PackagerData =
    (struct MSP_PackagerData *) p_MSP_PackagerData;
  return MSP_PackagerData->bufferSize;
}

#endif /* MDDMinimalSerialPackager_H_ */
