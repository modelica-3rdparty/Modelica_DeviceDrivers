within Modelica_DeviceDrivers.Communication;
package LCM_ "Accompanying functions for the LCM object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.LCM;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input LCM lcm;
    input SerialPackager pkg;
    external "C" MDD_lcmReadP(lcm, pkg)
      annotation (
        Include = "#include \"MDDLCM.h\"",
        Library = {"lcm", "glib-2.0", "pthread"},
        __iti_dll = "ITI_MDDLCM.dll",
        __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.LCM;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input LCM lcm;
    input String channel "Transmit Channel";
    input SerialPackager pkg;
    input Integer dataSize "Size of data";
    external "C" MDD_lcmSendP(lcm, channel, pkg, dataSize)
      annotation (
        Include = "#include \"MDDLCM.h\"",
        Library = {"lcm", "glib-2.0", "pthread"},
        __iti_dll = "ITI_MDDLCM.dll",
        __iti_dllNoExport = true);
  end sendTo;

  encapsulated function getLCMVersion
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.LCM;
    input LCM lcm;
    output String ver "LCM version";
    external "C" ver = MDD_lcmGetVersion(lcm)
      annotation (
        Include = "#include \"MDDLCM.h\"",
        Library = {"lcm", "glib-2.0", "pthread"},
        __iti_dll = "ITI_MDDLCM.dll",
        __iti_dllNoExport = true);
  end getLCMVersion;
end LCM_;
