Dummy library for Visual C.

For linux, various functions need to link against the X11 library 
However, MS Windows neither provides nor requires this library for the implemented functions.

The problem: We need to specify in Modelica to link the X11 library if running on Linux, but
             it is not needed for Windows (and results in a linking error if specified in the 
             annotation).

The workaround: We provide a dummy X11.lib library for Windows, so that linking won't result in an
                error. This is not nice for several reasons and good suggestions how to solve it
                differently are welcome.