within Modelica_DeviceDrivers.Communication;
package SharedMemory_ "Accompanying functions for the SharedMemory object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SharedMemory sm;
    input SerialPackager pkg "Data package to be read";
    external "C" MDD_SharedMemoryReadP(sm, pkg)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function write
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SharedMemory sm;
    input SerialPackager pkg "Data package to be written";
    input Integer len;
    external "C" MDD_SharedMemoryWriteP(sm, pkg, len)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end write;

  encapsulated function getDataSize
    import Modelica_DeviceDrivers.Communication.SharedMemory;
    input SharedMemory sm;
    output Integer length;
    external "C" length =  MDD_SharedMemoryGetDataSize(sm)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end getDataSize;
end SharedMemory_;
