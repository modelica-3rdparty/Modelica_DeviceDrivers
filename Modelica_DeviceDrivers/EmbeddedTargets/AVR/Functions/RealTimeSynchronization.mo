within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions;
encapsulated package RealTimeSynchronization
extends .Modelica.Icons.Package;

function wait
  extends .Modelica.Icons.Function;
  input Init rt;
  external "C" MDD_avr_rt_wait(rt)
  annotation (Include="#include \"MDDAVRRealTime.h\"");
end wait;

class Init "Initialize AVR real-time synchronization on the given clock.
  Note that the simulation step size must correspond to the given timer."
  extends ExternalObject;

  function constructor
    import Modelica_DeviceDrivers.EmbeddedTargets.AVR.Functions.Timers;
    extends .Modelica.Icons.Function;
    input Timers.Timer timer;
    input Integer timerValue "Note that 9 = every 10 cycles. So if you want to divide by 250, pass 249.";
    input Integer numTimerInterruptsPerCycle;
    output Init rt;
    external "C" rt = MDD_avr_rt_init(timer, timerValue, numTimerInterruptsPerCycle)
    annotation (Include="#include \"MDDAVRRealTime.h\"");
  end constructor;

  function destructor
    extends .Modelica.Icons.Function;
    input Init rt "Device handle";
    external "C" MDD_avr_rt_close(rt)
    annotation (Include="#include \"MDDAVRRealTime.h\"");
  end destructor;
end Init;
end RealTimeSynchronization;
