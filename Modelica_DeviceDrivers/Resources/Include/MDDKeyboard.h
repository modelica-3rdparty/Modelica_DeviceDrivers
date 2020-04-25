/** Keyboard support (header-only library).
 *
 * @file
 * @author		tbellmann (Windows)
 * @author		bernhard-thiele (Linux)
 * @since		2012-06-01
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 *
 * @par About the linux implementation:
 * While the windows implementation is straight forward, the implementation for linux
 * is more involved in order to implement the interface given by the windows implementation. @n
 * <i>References:</i> @n
 * References followed include: http://www.ypass.net/blog/2009/06/detecting-xlibs-keyboard-auto-repeat-functionality-and-how-to-fix-it/, http://stackoverflow.com/questions/4037230/global-hotkey-with-x11-xlib and the documentation of the X11 library found at http://tronche.com/gui/x/xlib/. @n
 * <i>List of defined symbols:</i> Look at X11/keysymdef.h
 * <i>Alternative Implementations:</i>@n
 * The chosen implementation is not the only conceivable and might well not be the best one.
 * Suggestions for improvements are happily welcome by the author. @n
 * Actually I (Bernhard) also tried following approaches:
 * @arg Low level implementation searching for the keyboard file descriptor, putting
 *      the keyboard into "mediumraw" mode and working at that level. This was
 *      implemented in the library "<i>Modelica_EmbeddedSystems</i>." Disadvantage: Needed
 *      root privileges.
 * @arg Global hotkey listening approach based around @c XGrabKey(..). That needed quite some
 *      special treatment due to the default key auto-repeat behaviour of Xlib. The best
 *      bet seemed to be to turn that behaviour off (@c XAutoRepeatOff(display)). At the
 *      end that seemed to be less straight forward than the current approach, although
 *      forum postings suggest that it could be more efficient than the current approach.
*/

#ifndef MDDKEYBOARD_H_
#define MDDKEYBOARD_H_

#if !defined(ITI_COMP_SIM)

#include "ModelicaUtilities.h"

#if defined(_MSC_VER) || defined(__CYGWIN__) || defined(__MINGW32__)

#if !defined(WIN32_LEAN_AND_MEAN)
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <stdio.h>
#include "../src/include/CompatibilityDefs.h"

#pragma comment( lib, "User32.lib" )

DllExport void MDD_keyboardGetKey(int iKeyCode,int * piKeyState) {
    /* getting state of interesting keys */
    if(GetAsyncKeyState(iKeyCode)) {
        piKeyState[0] = 1;
    }
    else {
        piKeyState[0] = 0;
    }
}

DllExport void MDD_keyboardGetData(int * piKeyState) {
    /* getting state of interesting keys */
    if(GetAsyncKeyState(VK_UP)) {
        piKeyState[0] = 1;
    }
    else {
        piKeyState[0] = 0;
    }
    if(GetAsyncKeyState(VK_DOWN)) {
        piKeyState[1] = 1;
    }
    else {
        piKeyState[1] = 0;
    }
    if(GetAsyncKeyState(VK_RIGHT)) {
        piKeyState[2] = 1;
    }
    else {
        piKeyState[2] = 0;
    }
    if(GetAsyncKeyState(VK_LEFT)) {
        piKeyState[3] = 1;
    }
    else {
        piKeyState[3] = 0;
    }
    if(GetAsyncKeyState(VK_RETURN)) {
        piKeyState[4] = 1;
    }
    else {
        piKeyState[4] = 0;
    }
    if(GetAsyncKeyState(VK_SPACE)) {
        piKeyState[5] = 1;
    }
    else {
        piKeyState[5] = 0;
    }
    if(GetAsyncKeyState(VK_F9)) {
        piKeyState[6] = 1;
    }
    else {
        piKeyState[6] = 0;
    }
    if(GetAsyncKeyState(VK_F10)) {
        piKeyState[7] = 1;
    }
    else {
        piKeyState[7] = 0;
    }
    if(GetAsyncKeyState(VK_F11)) {
        piKeyState[8] = 1;
    }
    else {
        piKeyState[8] = 0;
    }
    if(GetAsyncKeyState(VK_F12)) {
        piKeyState[9] = 1;
    }
    else {
        piKeyState[9] = 0;
    }
}

#elif defined(__linux__)

/* This #define is a hack needed since X11 declares "Time" and
 * also Dymola declares "Time" which then results in a compile
 * error. So we temporarily rename Time to MDDTime and hope
 * for the best.
*/
#define Time MDDTime
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysymdef.h>
#undef Time
#include "../src/include/CompatibilityDefs.h"
#include <string.h>

/** mapping from windows key code to linux key code */
int w2lKey[124];

void MDD_keyboardInitialize() {
    Display* display;
    int i;

    display = XOpenDisplay(0);
    for (i=0; i<124; i++) {
        w2lKey[i] = 0;
    }

    if (display == NULL) {
        return;
    }
    /* Windows seems not to distinguish between upper/lower case. We decide to map to lower */
    w2lKey[65] = XKeysymToKeycode(display, XK_a);
    w2lKey[66] = XKeysymToKeycode(display, XK_b);
    w2lKey[67] = XKeysymToKeycode(display, XK_c);
    w2lKey[68] = XKeysymToKeycode(display, XK_d);
    w2lKey[69] = XKeysymToKeycode(display, XK_e);
    w2lKey[70] = XKeysymToKeycode(display, XK_f);
    w2lKey[71] = XKeysymToKeycode(display, XK_g);
    w2lKey[72] = XKeysymToKeycode(display, XK_h);
    w2lKey[73] = XKeysymToKeycode(display, XK_i);
    w2lKey[74] = XKeysymToKeycode(display, XK_j);
    w2lKey[75] = XKeysymToKeycode(display, XK_k);
    w2lKey[76] = XKeysymToKeycode(display, XK_l);
    w2lKey[77] = XKeysymToKeycode(display, XK_m);
    w2lKey[78] = XKeysymToKeycode(display, XK_n);
    w2lKey[79] = XKeysymToKeycode(display, XK_o);
    w2lKey[80] = XKeysymToKeycode(display, XK_p);
    w2lKey[81] = XKeysymToKeycode(display, XK_q);
    w2lKey[82] = XKeysymToKeycode(display, XK_r);
    w2lKey[83] = XKeysymToKeycode(display, XK_s);
    w2lKey[84] = XKeysymToKeycode(display, XK_t);
    w2lKey[85] = XKeysymToKeycode(display, XK_u);
    w2lKey[86] = XKeysymToKeycode(display, XK_v);
    w2lKey[87] = XKeysymToKeycode(display, XK_w);
    w2lKey[88] = XKeysymToKeycode(display, XK_x);
    w2lKey[89] = XKeysymToKeycode(display, XK_y);
    w2lKey[90] = XKeysymToKeycode(display, XK_z);

    w2lKey[48] = XKeysymToKeycode(display, XK_0);
    w2lKey[49] = XKeysymToKeycode(display, XK_1);
    w2lKey[50] = XKeysymToKeycode(display, XK_2);
    w2lKey[51] = XKeysymToKeycode(display, XK_3);
    w2lKey[52] = XKeysymToKeycode(display, XK_4);
    w2lKey[53] = XKeysymToKeycode(display, XK_5);
    w2lKey[54] = XKeysymToKeycode(display, XK_6);
    w2lKey[55] = XKeysymToKeycode(display, XK_7);
    w2lKey[56] = XKeysymToKeycode(display, XK_8);
    w2lKey[57] = XKeysymToKeycode(display, XK_9);

    w2lKey[13] = XKeysymToKeycode(display, XK_Return);
    /* left control key is set, right would be XK_Control_R */
    w2lKey[17] = XKeysymToKeycode(display, XK_Control_L);
    w2lKey[32] = XKeysymToKeycode(display, XK_space);
    /* left alt key is set, right would be XK_Alt_R */
    w2lKey[18] = XKeysymToKeycode(display, XK_Alt_L);
    w2lKey[36] = XKeysymToKeycode(display, XK_Home);
    w2lKey[35] = XKeysymToKeycode(display, XK_End);
    w2lKey[37] = XKeysymToKeycode(display, XK_Left);
    w2lKey[39] = XKeysymToKeycode(display, XK_Right);
    w2lKey[38] = XKeysymToKeycode(display, XK_Up);
    w2lKey[40] = XKeysymToKeycode(display, XK_Down);
    w2lKey[33] = XKeysymToKeycode(display, XK_Page_Up);
    w2lKey[34] = XKeysymToKeycode(display, XK_Page_Down);
    w2lKey[9]  = XKeysymToKeycode(display, XK_Tab);
    /* Keypad numbers */
    w2lKey[96]  = XKeysymToKeycode(display, XK_KP_0);
    w2lKey[97]  = XKeysymToKeycode(display, XK_KP_1);
    w2lKey[98]  = XKeysymToKeycode(display, XK_KP_2);
    w2lKey[99]  = XKeysymToKeycode(display, XK_KP_3);
    w2lKey[100]  = XKeysymToKeycode(display, XK_KP_4);
    w2lKey[101]  = XKeysymToKeycode(display, XK_KP_5);
    w2lKey[102]  = XKeysymToKeycode(display, XK_KP_6);
    w2lKey[103]  = XKeysymToKeycode(display, XK_KP_7);
    w2lKey[104]  = XKeysymToKeycode(display, XK_KP_8);
    w2lKey[105]  = XKeysymToKeycode(display, XK_KP_9);
    /* Keypad functions hopefully map unambiguously to respective windows virtual keys ... */
    w2lKey[107]  = XKeysymToKeycode(display, XK_KP_Add);
    w2lKey[109]  = XKeysymToKeycode(display, XK_KP_Subtract);
    w2lKey[106]  = XKeysymToKeycode(display, XK_KP_Multiply);
    w2lKey[111]  = XKeysymToKeycode(display, XK_KP_Divide);
    /* Note that XK_F1 - XK_F4 might also be at the keypad in which
     * they have the code XK_KP_F1 - XK_KP_F4 */
    w2lKey[112] = XKeysymToKeycode(display, XK_F1);
    w2lKey[113] = XKeysymToKeycode(display, XK_F2);
    w2lKey[114] = XKeysymToKeycode(display, XK_F3);
    w2lKey[115] = XKeysymToKeycode(display, XK_F4);
    w2lKey[116] = XKeysymToKeycode(display, XK_F6);
    w2lKey[117] = XKeysymToKeycode(display, XK_F7);
    w2lKey[118] = XKeysymToKeycode(display, XK_F8);
    w2lKey[119] = XKeysymToKeycode(display, XK_F9);
    w2lKey[120] = XKeysymToKeycode(display, XK_F10);
    w2lKey[121] = XKeysymToKeycode(display, XK_F11);
    w2lKey[122] = XKeysymToKeycode(display, XK_F12);

    XCloseDisplay(display);
}

/** Get state of the specified key.
 * @param[in] ikeyCode Windows key code of the symbol
 * @param[out] piKeyState state of the key
 *             @arg 0: released
 *             @arg 1: pressed
*/
void MDD_keyboardGetKey(int iKeyCode, int * piKeyState) {
    static Display* display = NULL;
    char pressed_keys[32];
    int isPressed = 0;
    if (display == NULL) {
        display = XOpenDisplay(0);
        MDD_keyboardInitialize();
    }

    if (display == NULL) {
        return;
    }

    XQueryKeymap(display, pressed_keys);
    /* Well, well, well.
     * http://tronche.com/gui/x/xlib/input/XQueryKeymap.html
     * Got a 32 bytes vector representing whether a key is pressed.
     * "Byte N (from 0) contains the bits for keys 8N to 8N + 7 with the least-significant bit in the
     * byte representing key 8N" ->
     *   (1) Divide key code through 8 using a shift of 3 to determine encoding byte in vector
     *       "w2lKey[iKeyCode] >> 3",
     *   (2) The lower 3 bits of the key code represent the remainder of a division through 8
     *       "w2lKey[iKeyCode] & 0x07"
     *   (3) Single out the encoding bit by shifting the encoding byte by the remainder
     *       determined in (2).
     *   (4) Check whether the singled out bit is set.
     */
    isPressed = (pressed_keys[w2lKey[iKeyCode] >> 3] >> (w2lKey[iKeyCode] & 0x07)) & 0x01;
    if (isPressed) {
        *piKeyState = 1;
    }
    else {
        *piKeyState = 0;
    }
}

void MDD_keyboardGetData(int * piKeyState) {
    static Display* display = NULL;
    char pressed_keys[32];
    int keyCode;

    if (display == NULL) {
        display = XOpenDisplay(0);
    }

    if (display == NULL) {
        memset(piKeyState, 0, sizeof(int)*10);
        return;
    }

    /* See function MDD_keyboardGetKey(..) for more details about what is going on */
    XQueryKeymap(display, pressed_keys);
    /* getting state of interesting keys */
    keyCode = XKeysymToKeycode(display, XK_Up);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[0] = 1;
    }
    else {
        piKeyState[0] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_Down);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[1] = 1;
    }
    else {
        piKeyState[1] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_Right);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[2] = 1;
    }
    else {
        piKeyState[2] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_Left);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[3] = 1;
    }
    else {
        piKeyState[3] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_Return);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[4] = 1;
    }
    else {
        piKeyState[4] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_space);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[5] = 1;
    }
    else {
        piKeyState[5] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_F9);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[6] = 1;
    }
    else {
        piKeyState[6] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_F10);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[7] = 1;
    }
    else {
        piKeyState[7] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_F11);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[8] = 1;
    }
    else {
        piKeyState[8] = 0;
    }
    keyCode = XKeysymToKeycode(display, XK_F12);
    if ( (pressed_keys[keyCode >> 3] >> (keyCode & 0x07)) & 0x01 ) {
        piKeyState[9] = 1;
    }
    else {
        piKeyState[9] = 0;
    }

}

#else

#error "Modelica_DeviceDrivers: No Keyboard support for your platform"

#endif /* defined(_MSC_VER) */

#endif /* !defined(ITI_COMP_SIM) */

#endif /* MDDKEYBOARD_H_ */
