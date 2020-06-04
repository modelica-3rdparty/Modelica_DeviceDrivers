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







class Init "Initialize STM32F4 real-time synchronization"
  extends ExternalObject;

  function constructor
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Timers;
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
    import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.HAL;
    extends .Modelica.Icons.Function;
    input HAL.Init init;
    input Types.Clock clock;
    input Types.PLLM pllM;
    input Types.PLLN pllN;
    input Types.PLLP pllP;
    input Types.PLLQ pllQ;
    input Types.AHBPre ahbPre;
    input Types.APBPre apb1Pre;
    input Types.APBPre apb2Pre;
    input Types.PWRRegulatorVoltage voltageScale;
    input Boolean overdrive;
    input Boolean prefetchBufferEnable;

    output Init rt;
    external "C" rt = MDD_stm32f4_rt_init(init, clock, pllM, pllN, pllP, pllQ, ahbPre, apb1Pre, apb2Pre, voltageScale, overdrive, prefetchBufferEnable)
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
