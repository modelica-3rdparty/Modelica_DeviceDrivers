within Modelica_DeviceDrivers.Communication;
class MQTT "A driver for Message Queue Telemetry Transport."
  extends ExternalObject;
  encapsulated function constructor "Creates an MQTT instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.MQTT;
    input String provider "\"tcp://\" - TCP, \"ssl://\" - encrypted TCP, \"ws://\" - websocket, , \"wss://\" - encrypted websocket";
    input String address "IP address";
    input Integer port = 1883 "Port";
    input Boolean receiver "false - sender, true - receiver";
    input String channel "Receive channel";
    input Integer bufferSize = 16*1024 "Size of receive buffer";
    input Integer QoS = 1 "Quality of service for receiver: 0 - at most once, 1 - at least once, 2 - exactly once";
    input String clientID "Unique client identifier";
    input String userName = "" "User name for authentication and authorisation";
    input String password = "" "Password for authentication and authorisation";
    input String trustStore = "" "Public digital certificates trusted by the client";
    input String keyStore = "" "Public certificate chain of the client";
    input String privateKey = "" "Private key of the client";
    input Integer keepAliveInterval = 60 "Maximum time (in seconds) that should pass without communication between the client and the server";
    input Boolean cleanSession = true "false - keep session state for this client at disconnect, true - discard session state at connect and disconnect";
    input Boolean reliable = true "false - increase number of messages that can be in-flight simultaneously to 10, true - a published message must be completed (acknowledgements received) before another message can be sent";
    input Integer connectTimeout = 30 "Connection timeout (in seconds)";
    input Integer MQTTVersion = 0 "MQTT version: 0 - default: start with 3.1.1, and if that fails, fall back to 3.1, 3 - only try version 3.1, 4 - only try version 3.1.1, 5 - only try version 5.0";
    input Integer disconnectTimeout = 10 "Disconnect timeout (in seconds)";
    input Boolean enableServerCertAuth = true "false - disable verification of the server certificate, true - enable verification of the server certificate";
    input Boolean verify = false "false - disable post-connect checks, true - enable post-connect checks, including that a certificate matches the given host name";
    input Integer sslVersion = 0 "SSL/TLS version: 0 - default, 1 - TLS 1.0, 2 - TLS 1.1, 3 - TLS 1.2";
    output MQTT mqtt;
    external "C" mqtt = MDD_mqttConstructor(provider, address, port, receiver, QoS, channel, bufferSize, clientID, userName, password, trustStore, keyStore, privateKey, keepAliveInterval, cleanSession, reliable, connectTimeout, MQTTVersion, disconnectTimeout, enableServerCertAuth, verify, sslVersion)
      annotation (
        Include = "#include \"MDDMQTT.h\"",
        Library = {"paho-mqtt3cs", "pthread", "ssl", "crypto"},
        __iti_dll = "ITI_MDDMQTT.dll",
        __iti_dllNoExport = true);
  end constructor;

  encapsulated function destructor "Destroys an MQTT instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.MQTT;
    input MQTT mqtt;
    external "C" MDD_mqttDestructor(mqtt)
      annotation (
        Include = "#include \"MDDMQTT.h\"",
        Library = {"paho-mqtt3cs", "pthread", "ssl", "crypto"},
        __iti_dll = "ITI_MDDMQTT.dll",
        __iti_dllNoExport = true);
  end destructor;
end MQTT;
