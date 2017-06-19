within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
package Timers
extends .Modelica.Icons.Package;

class Timer
  "Global initializer for an STM32F4 timer."
  extends ExternalObject;
  function constructor "Initialize timer"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
    input Types.TimerSelect timerSelect;
    output Timer timer;
    external "C" timer = MDD_stm32f4_timer_init(timerSelect)
    annotation (Include="#include \"MDDSTM32F4Timer.h\"");
  end constructor;

  function destructor
    import Modelica;
    extends Modelica.Icons.Function;
    input Timer timer "Device handle";
    external "C" MDD_stm32f4_timer_close(timer)
    annotation (Include="#include \"MDDSTM32F4Timer.h\"");
  end destructor;

end Timer;








end Timers;
