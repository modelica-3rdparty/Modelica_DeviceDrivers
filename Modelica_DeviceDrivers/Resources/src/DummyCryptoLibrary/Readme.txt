Dummy library for Visual C.

For linux, the paho-mqtt3 functions need to link the libcrypto library (The OpenSSL Project).
However, MS Windows neither provides nor requires this library for the implemented functions.

The problem: We need to specify in Modelica to link the libcrypto library if running on Linux, but
             it is not needed for Windows (and results in a linking error if specified in the
             annotation).

The workaround: We provide a dummy crypto.lib library for Windows, so that linking won't result in an
                error. This is not nice for several reasons and good suggestions how to solve it
                differently are welcome.
