within Modelica_DeviceDrivers.Communication;
package MQTT_ "Accompanying functions for the MQTT object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
  encapsulated function read
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.MQTT;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input MQTT mqtt;
    input SerialPackager pkg;
    external "C" MDD_mqttReadP(mqtt, pkg)
      annotation (
        Include = "#include \"MDDMQTT.h\"",
        Library = {"paho-mqtt3cs", "pthread", "ssl", "crypto"},
        __iti_dll = "ITI_MDDMQTT.dll",
        __iti_dllNoExport = true);
  end read;

  encapsulated function sendTo
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.MQTT;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    input MQTT mqtt;
    input String channel "Transmit Channel";
    input SerialPackager pkg;
    input Boolean retained "Retained flag";
    input Integer deliveryTimeout "Delivery timeout";
    input Integer dataSize "Size of data";
    external "C" MDD_mqttSendP(mqtt, channel, pkg, retained, deliveryTimeout, dataSize)
      annotation (
        Include = "#include \"MDDMQTT.h\"",
        Library = {"paho-mqtt3cs", "pthread", "ssl", "crypto"},
        __iti_dll = "ITI_MDDMQTT.dll",
        __iti_dllNoExport = true);
  end sendTo;
end MQTT_;
