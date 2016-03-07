within Modelica_DeviceDrivers.Communication;
class SharedMemory
  "A driver for shared memory access for inter-process communication."
extends ExternalObject;
  encapsulated function constructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input String memoryName;
    input Integer bufferSize = 16* 1024;
    output SharedMemory sm;
    external "C" sm =  MDD_SharedMemoryConstructor(memoryName,bufferSize)
    annotation(Include = "#include \"MDDSharedMemory.h\" ",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end constructor;

  encapsulated function destructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    external "C" MDD_SharedMemoryDestructor(sm)
    annotation(Include = "#include \"MDDSharedMemory.h\" ",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end destructor;
end SharedMemory;
