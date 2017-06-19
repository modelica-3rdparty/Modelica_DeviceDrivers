within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
encapsulated package RealTimeSynchronization
extends .Modelica.Icons.Package;

function wait
  extends .Modelica.Icons.Function;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
  input Init rt;
  input Integer tick;
  external "C" MDD_stm32f4_rt_wait(rt, tick)
  annotation (Include="#include \"MDDSTM32F4RealTime.h\"");
end wait;








class Init "Initialize STM32F4 real-time synchronization on the given clock.
  Note that the simulation step size must correspond to the given timer."
  extends ExternalObject;

  function constructor
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Timers;
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
    extends .Modelica.Icons.Function;
    input HAL.Init init;
    output Init rt;
    external "C" rt = MDD_stm32f4_rt_init(init)
    annotation (Include="#include \"MDDSTM32F4RealTime.h\"");
  end constructor;

  function destructor
    extends .Modelica.Icons.Function;
    input Init rt "Device handle";
    external "C" MDD_stm32f4_rt_close(rt)
    annotation (Include="#include \"MDDSTM32F4RealTime.h\"");
  end destructor;
end Init;






end RealTimeSynchronization;
