Dummy library for Visual C.

For linux, the functions uuid_generate_random and uuid_unparse need to link the libuuid library.
However, MS Windows neither provides nor requires this library for the implemented functions.

The problem: We need to specify in Modelica to link the libuuid library if running on Linux, but
             it is not needed for Windows (and results in a linking error if specified in the
             annotation).

The workaround: We provide a dummy uuid.lib library for Windows, so that linking won't result in an
                error. This is not nice for several reasons and good suggestions how to solve it
                differently are welcome.
