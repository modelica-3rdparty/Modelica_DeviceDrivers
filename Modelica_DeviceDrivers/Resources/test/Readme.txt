This is the directory for the C (unit)-tests.



==================================================

Using CTest from the CMake package is described at:
http://www.cmake.org/Wiki/CMake_Testing_With_CTest

For using ctest you can do either
 make test
or
 ctest
in the build directory of the library.

For choosing individual test in a regexp-like style do for example
 ctest -R SoftSync

