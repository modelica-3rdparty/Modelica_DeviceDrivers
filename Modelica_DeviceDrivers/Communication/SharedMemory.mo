within Modelica_DeviceDrivers.Communication;
class SharedMemory
  "A driver for shared memory access for inter-process communication."
extends ExternalObject;
  encapsulated function constructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input String memoryName;
    input Integer bufferSize = 16* 1024;
    output SharedMemory sm;
    external "C" sm=   MDD_SharedMemoryConstructor(memoryName,bufferSize)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
  end constructor;

  encapsulated function destructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    external "C" MDD_SharedMemoryDestructor(sm)
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt",
           __iti_dll = "ITI_MDD.dll");
  end destructor;
end SharedMemory;
