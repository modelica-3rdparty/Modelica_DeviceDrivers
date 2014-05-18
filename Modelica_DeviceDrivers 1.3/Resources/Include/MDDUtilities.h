/** Utility functions (header-only library).
 *
 * @file
 * @author		Tobias Bellmann <tobias.bellmann@dlr.de>
 * @version	        $Id:$
 * @since		2013-05-24
 * @copyright Modelica License 2
 *
 * Little handy functions offered in the Utilities package.
 */

#ifndef MDDUTILITIES_H_
#define MDDUTILITIES_H_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

DllExport double MDD_utilitiesLoadRealParameter(const char * file, const char * name)
{
  FILE * pFile;
  char line[512];
  char * namePos;
  double u;
  pFile = fopen (file,"r");

  //file existent?
  if (pFile==NULL)
  {
    ModelicaFormatError("Could not open file %s.\n",file);
  }

  //read every line of file one after another:
  while(fgets (line , 512 , pFile) != NULL )
  {

    //find the name of the variable in string
    namePos = strstr (line,name);

    //if variable name found and the next character after the name is a space, tabulator or = then it is a valid name.
    if(namePos && (namePos[strlen(name)] == ' ' || namePos[strlen(name)] == '=' || namePos[strlen(name)] == '\t'))
    {

      //find the =
      namePos=strchr(namePos+1,'=');

      if(namePos)
      {
        u = atof(namePos+1);
        fclose (pFile);
        return u;

      }
    }

  }

  fclose (pFile);
  ModelicaFormatError("Parameter name not found: %s",name);
  return 0;
}


#endif /* MDDUTILITIES_H_ */
