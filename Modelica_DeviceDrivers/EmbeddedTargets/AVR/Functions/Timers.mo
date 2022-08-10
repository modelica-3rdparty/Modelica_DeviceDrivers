within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions;
package Timers
extends .Modelica.Icons.Package;

class Timer
  "Global initializer for an AVR timer."
  extends ExternalObject;

  function constructor "Initialize timer"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Types;
    input Types.TimerSelect timerSelect;
    input Types.TimerPrescaler clockSelect;
    input Boolean clearTimerOnMatch "CTC1/WGM12, for periodic tasks. If using PWM, does fast PWM";
    output Timer timer;
    external "C" timer = MDD_avr_timer_init(timerSelect, clockSelect, clearTimerOnMatch)
    annotation (Include="#include \"MDDAVRTimer.h\"");
  end constructor;

  function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    input Timer timer "Device handle";
    external "C" MDD_avr_timer_close(timer)
    annotation (Include="#include \"MDDAVRTimer.h\"");
  end destructor;

end Timer;
end Timers;
