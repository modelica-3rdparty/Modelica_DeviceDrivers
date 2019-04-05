# Dummy libraries

Modelica has the `Library` annotation for specifying library dependencies of
external C code, for example:

```
annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"});
```

When trying to find the library, Modelica tools will automatically adapt the
name to typical naming conventions on the respective platform (e.g., libX.lib or
libX.so on Linux, but X.lib or X.dll on Windows).

*The problem:* If system libraries need to be linked, different platforms often have
completely _different_ platform specific library dependencies and this cannot be
expressed in the annotation (at least as of Modelica 3.4).

*The workaround:* Collect the dependencies of all platforms in the `Library`
annotation and provide dummy libraries ("empty" libraries with no exported functions)
for the platforms on which certain libraries don't exist (and are not needed).
This ensures that the linker will always find a library with the specified name,
and no linker error (due to missing libraries) occurs.
