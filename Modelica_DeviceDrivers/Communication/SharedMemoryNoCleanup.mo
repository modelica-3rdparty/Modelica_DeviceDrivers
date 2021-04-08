within Modelica_DeviceDrivers.Communication;
class SharedMemoryNoCleanup
  "Hack. Linux Only. Variant which doesn't close shared memory object and semaphore."
extends ExternalObject;
  encapsulated function constructor
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SharedMemoryNoCleanup;
    input String memoryName;
    input Integer bufferSize = 16* 1024;
    output SharedMemoryNoCleanup sm;
    external "C" sm =  MDD_SharedMemoryConstructor(memoryName,bufferSize)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end constructor;

  encapsulated function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SharedMemoryNoCleanup;
    input SharedMemoryNoCleanup sm;
    external "C" MDD_SharedMemoryNoCleanupDestructor(sm)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end destructor;
end SharedMemoryNoCleanup;
