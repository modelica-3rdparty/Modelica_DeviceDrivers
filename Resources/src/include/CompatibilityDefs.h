/** @brief Preprocessor definitions supporting compiling Windows and Linux sources from same source.
 *
 * @file        CompatibilityDefs.h
 * @author	Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version	$Id$
 * @since	2012-05-25
 * @copyright Modelica License 2
 *
 *
 * This file is based on the article
 * "Dynamic libraries: maintaining a single source for Unix & Windows", on the FMI header definitions
 * and on DLR know-how of using the Dymola external C interface
 *
 *
 * Quoting from "Dynamic libraries: maintaining a single source for Unix & Windows":
 * - "Check whether any of your desired DLLs intents to access the global vari-
 *   ables of another one. All definitions of these external variables must be
 *   changed."
 * - "Replace all extern keywords with the uppercase EXTERN. If one wants
 *   to access the global variable of C code from the C++ code one has to define
 *   it with extern "C" additionally. Namely, the piece of the C code"
 @code
 extern int SomeCplusVar
 @endcode
 * "will look as"
 @code
 #include "CompatibilityDefs.h"
 extern "C" {
  EXTERN int SomeCplusVar
 }
 @endcode
 * - "Provide the access method for the static data-members. Access from one
 *   DLL the static data-members of the C++ classes of another DLL can
 *   be done with static access method only. So it must be provided."
 *
 */

#ifndef COMPATIBILITYDEFS_H_
#define COMPATIBILITYDEFS_H_

/* Compile dll and so from same source */
#if defined(_MSC_VER)
# define DllImport \
__declspec( dllimport )
# define DllExport \
__declspec( dllexport )
#else
# define DllImport
# define DllExport
#endif /*_MSC_VER */
# define EXTERN DllImport extern

/* Some definitions necessary in order to use <windows.h> in Dymola,
   not sure whether other tools need them as well.*/
#if defined(_MSC_VER)
  #define VOID void
  typedef char CHAR;
  typedef short SHORT;
  typedef long LONG;
  typedef unsigned char   u_char;
  typedef unsigned short  u_short;
  typedef unsigned int    u_int;
  typedef unsigned long   u_long;
  typedef unsigned __int64 u_int64;
#endif /*_MSC_VER */



#endif /* COMPATIBILITYDEFS_H_ */
