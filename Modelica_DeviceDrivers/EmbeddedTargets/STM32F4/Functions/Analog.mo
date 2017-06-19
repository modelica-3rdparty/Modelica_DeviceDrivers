within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
package Analog
extends .Modelica.Icons.Package;

function read_8bit
  extends .Modelica.Icons.Function;
  input Types.AnalogPort analogPort;
  output Integer value;
  external "C" value=MDD_avr_analog_read_8bit(analogPort)
  annotation (Include="#include \"MDDARMAnalog.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end read_8bit;

function read_float
  extends .Modelica.Icons.Function;
  input Types.AnalogPort analogPort;
  output Real value;
  external "C" value=MDD_avr_analog_read_float(analogPort)
  annotation (Include="#include \"MDDARMAnalog.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end read_float;

function read_voltage
  extends .Modelica.Icons.Function;
  import Modelica.SIunits.Voltage;
  input .Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.AnalogPort analogPort;
  input Voltage vref "We need to pass a reference voltage in order to read a voltage";
  input Integer voltageResolution "In bits; 10 bit resolution.";
  output Voltage value "The voltage on the selected PIN";
  external "C" value=MDD_avr_analog_read(analogPort, vref, voltageResolution)
  annotation (Include="#include \"MDDARMAnalog.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end read_voltage;

class Init
  "Global initializer for STM32F4 analog IO. Only used in order
  to be initialize ports before any I/O functions are called."
  extends ExternalObject;

  function constructor "Initialize device"
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
    extends .Modelica.Icons.Function;
    input Types.AnalogPrescaler divisionFactor;
    input Types.VRefSelect referenceVoltage;
    output Analog.Init avr "Dummy handle (always 0)";
    external "C" avr = MDD_avr_analog_init(divisionFactor, referenceVoltage)
    annotation (Include="#include \"MDDARMAnalog.h\"");
  end constructor;

  function destructor
    extends .Modelica.Icons.Function;
    input Analog.Init avr "Device handle";
    external "C" MDD_avr_analog_close(avr)
    annotation (Include="#include \"MDDARMAnalog.h\"");
  end destructor;

end Init;

end Analog;
