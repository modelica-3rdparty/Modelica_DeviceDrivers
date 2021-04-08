within Modelica_DeviceDrivers.Communication;
package SharedMemoryNoCleanup_
  "Accompanying functions for the SharedMemoryNoCleanup object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SharedMemoryNoCleanup;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SharedMemoryNoCleanup sm;
    input SerialPackager pkg "Data package to be read";
    external "C" MDD_SharedMemoryReadP(sm, pkg)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end read;

  encapsulated function write
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SharedMemoryNoCleanup;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SharedMemoryNoCleanup sm;
    input SerialPackager pkg "Data package to be written";
    input Integer len;
    external "C" MDD_SharedMemoryWriteP(sm, pkg, len)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           Library = {"rt", "pthread"},
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end write;

  encapsulated function getDataSize
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SharedMemoryNoCleanup;
    input SharedMemoryNoCleanup sm;
    output Integer length;
    external "C" length =  MDD_SharedMemoryGetDataSize(sm)
    annotation(Include = "#include \"MDDSharedMemory.h\"",
           __iti_dll = "ITI_MDD.dll",
           __iti_dllNoExport = true);
  end getDataSize;
end SharedMemoryNoCleanup_;
