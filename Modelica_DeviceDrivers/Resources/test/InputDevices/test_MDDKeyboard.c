/** Test for MDDKeyboard.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-06-01
 * @copyright Modelica License 2
 * @test Interactive test for MDDKeyboard.h.
*/

#include <stdio.h>
#include "../../Include/MDDKeyboard.h"


int main(void) {
  int piKeyState;
  int iKeyCode;


  piKeyState = 0; iKeyCode = 32;
  printf("Please press iKeyCode %d (Space)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  piKeyState = 0; iKeyCode = 13;
  printf("Please press iKeyCode %d (return)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  piKeyState = 0; iKeyCode = 38;
  printf("Please press iKeyCode %d (Up)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  piKeyState = 0; iKeyCode = 40;
  printf("Please press iKeyCode %d (Down)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  piKeyState = 0; iKeyCode = 37;
  printf("Please press iKeyCode %d (Left)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  piKeyState = 0; iKeyCode = 39;
  printf("Please press iKeyCode %d (Right)\n", iKeyCode);
  while (!piKeyState) MDD_keyboardGetKey(iKeyCode, &piKeyState);
  printf("Got iKeyCode: %d, piKeyState: %d\n", iKeyCode, piKeyState);

  printf("End of interactive Test\n");
  return 0;
}

