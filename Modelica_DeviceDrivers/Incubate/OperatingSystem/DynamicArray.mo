within Modelica_DeviceDrivers.Incubate.OperatingSystem;
class DynamicArray
  "An dynamically allocated array able to hold unspecified numbers of matrices"
  extends ExternalObject;

  encapsulated function constructor
  import Modelica;
  import Modelica_DeviceDrivers.Incubate.OperatingSystem.DynamicArray;

    input Integer m "row dim of matrix size";
    input Integer n "column dim of matrix";
    output DynamicArray ArrayID
      "ID to access internal memory that holds animation data";

  external"C" ArrayID=  MDD_initMemory(m, n);
    annotation (Include="
    #include <stdio.h>
    #include <stdlib.h>
    #include <ModelicaUtilities.h>
    typedef struct
    {
      double * data;
      int m;
      int n;
      int maxIndex;
    }MDD_Array;

    void * MDD_initMemory(int m, int n)
    {
      MDD_Array * array = malloc(sizeof(MDD_Array));
      array->data = (double*) malloc(n * m * sizeof (double));
      array->m = m;
      array->n = n;
      array->maxIndex = 1;
      ModelicaFormatMessage(\"Allocating Memory. m-dim: %i, n-dim: %i \\n\",array->m, array->n);
      return array;
    }

    void MDD_freeMemory(void * arrayPtr)
    {
      MDD_Array * array = (MDD_Array*)arrayPtr;
      free(array->data);
      free(array);
      ModelicaFormatMessage(\"Memory freed\\n\");
    }

    void MDD_setMatrix(void * arrayPtr, const double * u, int index)
    {
      MDD_Array * array = (MDD_Array*)arrayPtr;
      double * newData=NULL;
      size_t newArraySize = 0;
      int newIndex;
      if(index>array->maxIndex)
      {
        if(index > 2*array->maxIndex)
          newIndex = 2*index;
        else
          newIndex =  2*array->maxIndex;

        ModelicaFormatMessage(\"Reallocating Memory. Old Index: %i, new Index: %i \\n\",array->maxIndex, newIndex);
        newArraySize = newIndex * sizeof(double) * (array->m * array->n);
        newData = (double*) realloc(array->data,newArraySize);
        ModelicaFormatMessage(\"Memory reallocated. New size (bytes):%d \\n\", newArraySize);

        if(newData!=NULL)
          array->data = newData;
        else
          ModelicaFormatError(\"Error allocating more memory for dynamic Array. Used memory: %i\\n\",  newIndex * sizeof(double) * array->m * array->n);

        array->maxIndex = newIndex;
      }


      memcpy( array->data +  ( index - 1 )  * array->m * array->n, u, sizeof(double) * array->m * array->n );

    }

    void MDD_getMatrix(void * arrayPtr, double * u, int index)
    {
      MDD_Array * array = (MDD_Array*)arrayPtr;
      if (index > array->maxIndex)
            ModelicaFormatError(\"Error: Memory access out of range. Inquired index: %i, maxIndex: %i \\n \",index, array->maxIndex);

      memcpy(u, array->data + (index-1)  * array->m * array->n ,sizeof(double) *  array->m * array->n);
    }

    int MDD_getSize(void * arrayPtr)
    {
      MDD_Array * array = (MDD_Array*)arrayPtr;
      return array->maxIndex;
    }
    ");

  end constructor;

  encapsulated function destructor
  import Modelica;
  import Modelica_DeviceDrivers.Incubate.OperatingSystem.DynamicArray;
    input DynamicArray arrayID;
  external"C" MDD_freeMemory(arrayID);
  end destructor;
end DynamicArray;
