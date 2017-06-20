within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
package SerialPort
extends .Modelica.Icons.Package;

class Init "Initializes the STM32F4 UART."
  extends ExternalObject;

  function constructor "Initialize UART"
    import Modelica;
    import Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate;
    extends Modelica.Icons.Function;
    input SerialBaudRate baudRate;
    output Init serialPort;
    external "C" serialPort = MDD_avr_uart_init(baudRate)
    annotation (Include="#include \"MDDARMSerial.h\"");
  end constructor;

  function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    input Init serialPort "Device handle";
    external "C" MDD_avr_uart_close(serialPort)
    annotation (Include="#include \"MDDARMSerial.h\"");
  end destructor;
end Init;

class MapStandardIO "Maps stdin/stdout to the STM32F4 UART."
  extends ExternalObject;

  function constructor "Initialize UART"
    import Modelica;
    extends Modelica.Icons.Function;
    input SerialPort.Init serialPort;
    input Boolean stdin=true, stdout=true;
    output MapStandardIO io;
    external "C" io = MDD_avr_uart_stdio_init(serialPort, stdin, stdout)
    annotation (Include="#include \"MDDARMSerialStdio.h\"");
  end constructor;

  function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    input MapStandardIO io "Device handle";
    external "C" MDD_avr_uart_stdio_close(io)
    annotation (Include="#include \"MDDARMSerialStdio.h\"");
  end destructor;
end MapStandardIO;

end SerialPort;
