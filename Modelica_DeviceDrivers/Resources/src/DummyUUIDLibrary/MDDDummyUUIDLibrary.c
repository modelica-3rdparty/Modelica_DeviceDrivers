/** Dummy library for uniform treatment of Modelica external function in windows and linux.
 *
 * @file
 * @author		bernhard-thiele
 * @since		2012-05-25
 * For linux, the functions uuid_generate_random and uuid_unparse need to link the libuuid library.
 * However, MS Windows neither provides nor requires this library for the implemented functions.
 *
 * - <B>The problem</B>: We need to specify in Modelica to link the libuuid library if running on Linux, but
 *   it is not needed for Windows (and results in a linking error if specified in the
 *   annotation).
 * - <B>The workaround</B>: We provide a dummy uuid.lib library for Windows, so that linking won't result in an
 *   error. This is not nice for several reasons and good suggestions how to solve that
 *   differently are welcome.
*/

static void MDD_dummy(void);
