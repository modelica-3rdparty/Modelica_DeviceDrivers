within Modelica_DeviceDrivers.Communication;
class LCM "A driver for Lightweight Communications and Marshalling."
  extends ExternalObject;
  encapsulated function constructor "Creates an LCM instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.LCM;
    input String provider "\"udp://\" - UDP multicast, \"file://\" - logfile, \"memq://\" - memory queue";
    input String address "IP address or logfile name";
    input Integer port "Port (only relevant for UDP multicast provider)";
    input Integer receiver = 1 "0 - sender, 1 - receiver";
    input String channel "Receive channel";
    input Integer bufferSize = 16*1024 "Size of receive buffer";
    input Integer queueSize = 30 "Size of message queue";
    output LCM lcm;
    external "C" lcm = MDD_lcmConstructor(provider, address, port, receiver, channel, bufferSize, queueSize)
      annotation (
        Include = "#include \"MDDLCM.h\"",
        Library = {"lcm", "glib-2.0", "pthread"},
        __iti_dll = "ITI_MDDLCM.dll",
        __iti_dllNoExport = true);
  end constructor;

  encapsulated function destructor "Destroys an LCM instance."
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.Communication.LCM;
    input LCM lcm;
    external "C" MDD_lcmDestructor(lcm)
      annotation (
        Include = "#include \"MDDLCM.h\"",
        Library = {"lcm", "glib-2.0", "pthread"},
        __iti_dll = "ITI_MDDLCM.dll",
        __iti_dllNoExport = true);
  end destructor;
end LCM;
