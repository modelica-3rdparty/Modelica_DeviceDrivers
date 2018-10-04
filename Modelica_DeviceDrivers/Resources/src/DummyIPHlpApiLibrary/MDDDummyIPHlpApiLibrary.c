/** Dummy library for uniform treatment of Modelica external function in windows and linux.
 *
 * @file
 * @author		Bernhard Thiele
 * @since		2015-04-18
 * For windows, various functions need to link the IPHlpApi.lib library.
 * However, Linux neither provides nor requires this library for the implemented functions.
 *
 * - <B>The problem</B>: We need to specify in Modelica to link the IPHlpApi.lib library if running on Windows, but
 *   it is not needed for Linux (and results in a linking error if specified in the
 *   annotation).
 * - <B>The workaround</B>: We provide a dummy libIPHlpApi.a library for Linux, so that linking won't result in an
 *   error. This is not nice for several reasons and good suggestions how to solve that
 *   differently are welcome.
*/

static void MDD_dummy(void);
