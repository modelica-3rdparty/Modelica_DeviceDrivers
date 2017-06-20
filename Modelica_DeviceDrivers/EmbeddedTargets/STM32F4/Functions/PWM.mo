within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
encapsulated package PWM
extends .Modelica.Icons.Package;

function set
  extends .Modelica.Icons.Function;
  input Init pwm;
  input Integer value;
  external "C" MDD_avr_pwm_set(pwm, value)
  annotation (Include="#include \"MDDARMAnalog.h\"");
end set;

class Init
  "Global initializer for an STM32F4 8-bit PWM output. Takes an already setup timer as input."
extends ExternalObject;

function constructor "Initialize PWM timer. Note that if you setup both
  A and B pins, you need to use the same settings for both or you randomly
  get the settings for one of them controlling the same timer."
  extends .Modelica.Icons.Function;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  input Functions.Timers.Timer timer;
  input Types.TimerNumber pin=Types.TimerNumber.A;
  input Integer initialValue=0;
  input Boolean inverted=false;
  output Init pwm;
  external "C" pwm = MDD_avr_pwm_init(timer, pin, initialValue, inverted)
  annotation (Include="#include \"MDDARMAnalog.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input Init pwm "Device handle";
  external "C" MDD_avr_pwm_close(pwm)
  annotation (Include="#include \"MDDARMAnalog.h\"");
end destructor;

end Init;

end PWM;
