within Modelica_DeviceDrivers.Communication;
class SharedMemory
  "A driver for shared memory access for inter-process communication."
extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
extends ExternalObject;
  encapsulated function constructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input String memoryName;
    input Integer bufferSize = 16* 1024;
    output SharedMemory sm;
    external "C" sm=   MDD_SharedMemoryConstructor(memoryName,bufferSize);
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt");
  end constructor;

  encapsulated function destructor
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    external "C" MDD_SharedMemoryDestructor(sm);
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt");
  end destructor;

  encapsulated function read
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    output String data;
    external "C" data=  MDD_SharedMemoryRead(sm);
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt");
  end read;

  encapsulated function write
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    input String data;
    input Integer len;
    external "C" MDD_SharedMemoryWrite(sm,data,len);
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ",
           Library = "rt");
  end write;

  encapsulated function getDataSize
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    output Integer length;
    external "C" length=  MDD_SharedMemoryGetDataSize(sm);
    annotation(IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
           Include = "#include \"MDDSharedMemory.h\" ");
  end getDataSize;

end SharedMemory;
