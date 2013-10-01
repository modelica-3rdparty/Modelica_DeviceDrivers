within Modelica_DeviceDrivers.Communication;
package SharedMemory_ "Accompanying functions for the SharedMemory object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
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
end SharedMemory_;
