within Modelica_DeviceDrivers.Communication;
package SoftingCAN_ "Accompanying functions for the SoftingCAN object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function defineObject "Define available objects (CAN messages)"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
    import Modelica_DeviceDrivers.Utilities.Types;
    import Modelica_DeviceDrivers;
    input SoftingCAN softingCAN "Handle for device";
    input Integer ident "Identifier of CAN message (CAN Id)";
    input Modelica_DeviceDrivers.Utilities.Types.TransmissionType transType
      "transmission type (receiving or sending)";
    output Integer objectNumber
      "Object number of message. Needed for further queries regarding receiving/transmitting the message";

    external "C" objectNumber = MDD_softingCANDefineObject(softingCAN, ident, transType)
    annotation (Include="#include \"MDDSoftingCAN.h\"",
                __iti_dll = "ITI_MDDSoftingCAN.dll",
                __iti_dllNoExport = true);
  end defineObject;

  encapsulated function startChip
    "Put CAN controllers of both CAN channels into operational mode (all object definitions have to be completed before!)"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
    input SoftingCAN softingCAN "Handle for device";

    external "C" MDD_softingCANStartChip(softingCAN)
    annotation (Include="#include \"MDDSoftingCAN.h\"",
                __iti_dll = "ITI_MDDSoftingCAN.dll",
                __iti_dllNoExport = true);
  end startChip;

  encapsulated function writeObject
    "Write object (CAN message) to transmit buffer"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input SoftingCAN softingCAN "Handle for device";
    input Integer objectNumber "Object number of message (from defineObject(..))";
    input Integer dataLength "Length of message in bytes";
    input SerialPackager pkg;

    external "C" MDD_softingCANWriteObjectP(softingCAN, objectNumber, dataLength, pkg)
    annotation (Include="#include \"MDDSoftingCAN.h\"",
                __iti_dll = "ITI_MDDSoftingCAN.dll",
                __iti_dllNoExport = true);
  end writeObject;

  encapsulated function readRcvData "Read data from object (CAN message)"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.SoftingCAN;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;

    input SoftingCAN softingCAN "Handle for device";
    input Integer objectNumber "Object number of message (from defineObject(..))";
    input SerialPackager pkg "Serial packager object with data buffer which is capable to take at least 8 elements";

    external "C" MDD_softingCANReadRcvDataP(softingCAN, objectNumber, pkg)
    annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
                Include="#include \"MDDSoftingCAN.h\"",
                __iti_dll = "ITI_MDDSoftingCAN.dll",
                __iti_dllNoExport = true);

  end readRcvData;
end SoftingCAN_;
