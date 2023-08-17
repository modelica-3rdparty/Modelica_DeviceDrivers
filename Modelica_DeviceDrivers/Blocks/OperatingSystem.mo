within Modelica_DeviceDrivers.Blocks;
package OperatingSystem "Blocks for miscellaneous OS API related facilities, e.g., real-time synchronization."
  extends Modelica.Icons.Package;

  block RealtimeSynchronize "Block for pseudo real-time synchronization. Supersedes \"SynchronizeRealtime\"."
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    import      Modelica.Units.SI;

    input Real scaling(min=0) = 1 "real-time scaling factor; > 1 means the simulation is made slower than real-time" annotation(Dialog(enable=true, group="Time varying input signal"));

    // Activation
    parameter Boolean enable = true "true, if real-time synchronization is enabled, otherwise it is disabled!" annotation(Dialog(group="Activation"), choices(checkBox=true));
    parameter Boolean sampled = false "true, use sample-based real-time synchronization, otherwise an approach without sampling is used. \"true\" is recommended for more deterministic, less solver sensitive behavior, but requires choosing appropriate sampling settings. Defaults to \"false\" for convenience." annotation(Dialog(group="Activation"), choices(checkBox=true));
    parameter Boolean enableExternalTrigger = false "true, enable external trigger input signal, otherwise use sample time settings below" annotation (Dialog(enable=sampled, group="Activation"));
    parameter SI.Period sampleTime = 0.01 "Sample period of component" annotation(Dialog(enable = sampled and not enableExternalTrigger, group="Activation"));
    parameter SI.Time startTime = 0 "First sample time instant" annotation(Dialog(enable = sampled and not enableExternalTrigger, group="Activation"));

    parameter Boolean showAdvancedOutputs = false "Show output for computing time and remaining time"  annotation (Dialog(group="Advanced"), choices(checkBox=true));
    parameter Boolean shouldCatchupTime = false "true, try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not" annotation (Dialog(group="Advanced"), choices(checkBox=true));

    Modelica.Blocks.Interfaces.BooleanInput trigger if sampled and enableExternalTrigger annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={0,-120})));
    Modelica.Blocks.Interfaces.RealOutput wallClockTime(unit="s") "Wall clock time that elapsed since initialization of the real-time synchronization object" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,50},
              {120,70}})));
    Modelica.Blocks.Interfaces.RealOutput remainingTime(unit="s") "Wall clock time that is left before real-time deadline is reached" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,-30},
              {120,-10}})));
    Modelica.Blocks.Interfaces.RealOutput computingTime(unit="s") "Time between invocations of real-time sync function, i.e., \"computing time\" in seconds" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,-70},
              {120,-50}})));
    Modelica.Blocks.Interfaces.RealOutput simTime(unit="s") annotation (
        Placement(visible=showAdvancedOutputs, transformation(extent={{100,10},
              {120,30}})));


    Internal.RealtimeSynchronize_Continuous rtSync_Continuous(
      final scaling=scaling,
      final showAdvancedOutputs=showAdvancedOutputs,
      final shouldCatchupTime=shouldCatchupTime) if not sampled and enable
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Internal.RealtimeSynchronize_Sampled rtSync_Sampled(
      final scaling=scaling,
      final shouldCatchupTime=shouldCatchupTime,
      final enableExternalTrigger=enableExternalTrigger,
      final sampleTime=sampleTime,
      final startTime=startTime) if sampled and enable
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

    Modelica.Blocks.Sources.RealExpression dummyOutputs[4](y={0,0,0,0})
                                                              if not enable
      annotation (Placement(transformation(extent={{-20,70},{0,90}})));
    Modelica.Blocks.Routing.Multiplex4 mux_continuous     if not sampled and enable
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Modelica.Blocks.Routing.Multiplex4 mux_sampled     if sampled and enable
      annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    Modelica.Blocks.Routing.DeMultiplex4 demux
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  equation
    connect(trigger, rtSync_Sampled.trigger) annotation (Line(points={{0,-120},{0,
            -90},{-50,-90},{-50,-62}}, color={255,0,255}));
    connect(rtSync_Continuous.wallClockTime, mux_continuous.u1[1]) annotation (
        Line(points={{-39,36},{-32,36},{-32,39},{-22,39}}, color={0,0,127}));
    connect(rtSync_Sampled.wallClockTime, mux_sampled.u1[1]) annotation (Line(
          points={{-39,-44},{-32,-44},{-32,-41},{-22,-41}}, color={0,0,127}));
    connect(demux.y1[1], wallClockTime) annotation (Line(points={{41,9},{50,9},
            {50,60},{110,60}}, color={0,0,127}));
    connect(dummyOutputs.y, demux.u) annotation (Line(points={{1,80},{10,80},{
            10,0},{18,0}}, color={0,0,127}));
    connect(mux_continuous.y, demux.u) annotation (Line(points={{1,30},{10,30},
            {10,0},{18,0}}, color={0,0,127}));
    connect(mux_sampled.y, demux.u) annotation (Line(points={{1,-50},{10,-50},{
            10,0},{18,0}}, color={0,0,127}));
    connect(demux.y2[1], simTime) annotation (Line(points={{41,3},{60,3},{60,20},
            {110,20}}, color={0,0,127}));
    connect(demux.y4[1], computingTime) annotation (Line(points={{41,-9},{50,-9},
            {50,-60},{110,-60}}, color={0,0,127}));
    connect(demux.y3[1], remainingTime) annotation (Line(points={{41,-3},{60,-3},
            {60,-20},{110,-20}}, color={0,0,127}));
    connect(rtSync_Continuous.simTime, mux_continuous.u2[1]) annotation (Line(
          points={{-39,32},{-32,32},{-32,33},{-22,33}}, color={0,0,127}));
    connect(rtSync_Continuous.remainingTime, mux_continuous.u3[1]) annotation (
        Line(points={{-39,28},{-30,28},{-30,27},{-22,27}}, color={0,0,127}));
    connect(rtSync_Continuous.computingTime, mux_continuous.u4[1]) annotation (
        Line(points={{-39,24},{-32,24},{-32,21},{-22,21}}, color={0,0,127}));
    connect(rtSync_Sampled.simTime, mux_sampled.u2[1]) annotation (Line(points=
            {{-39,-48},{-30,-48},{-30,-47},{-22,-47}}, color={0,0,127}));
    connect(rtSync_Sampled.remainingTime, mux_sampled.u3[1]) annotation (Line(
          points={{-39,-52},{-32,-52},{-32,-53},{-22,-53}}, color={0,0,127}));
    connect(rtSync_Sampled.computingTime, mux_sampled.u4[1]) annotation (Line(
          points={{-39,-56},{-30,-56},{-30,-59},{-22,-59}}, color={0,0,127}));
    annotation (Icon( coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            visible=not enable,
            extent={{-100,100},{100,-100}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward,
            pattern=LinePattern.Dash,
            lineColor={175,175,175}), Text(
            visible=not enable,
            extent={{-100,-112},{100,-136}},
            textColor={135,135,135},
            textString="Deactivated"),
          Bitmap(extent={{-60,-60},{60,60}}, fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/clock.png"),
          Text(extent={{-150,142},{150,102}}, textString="%name"),
          Text(extent={{-100,-58},{100,-98}},   textString=DynamicSelect("", if sampled then "sampled" else ""))}),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
<p>Synchronizes the simulation time of the simulation process with the operating system real-time clock.</p>
<p>Note that the provided level of real-time synchronization is &quot;soft&quot;, meaning that there are no guarantees that deadlines are met or that latencies are restricted to a predictable (low) maximum. This is often enough to satisfy requirements for interactive simulations and can be compared to the real-time experience provided by computer games. However, applications requiring &quot;hard&quot; real-time synchronization (e.g. HIL simulations) are <b>not</b> satisfied!</p>
<p>Different priority levels are supported by block <a href=\"modelica://Modelica_DeviceDrivers.Blocks.OperatingSystem.ProcessPriority\">ProcessPriority</a>. Using the &quot;High Priority&quot; and &quot;Real-Time&quot; priorities in Linux will usually require &quot;root&quot; privileges for the simulation process. Using the &quot;Real-Time&quot; priority in Linux with a low-latency kernel as provided by the PREEMPT_RT patch will even provide limited (however, implementation specific limitations given below still apply) &quot;hard&quot; real-time capabilities (see e.g., <a href=\"https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html\">https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html</a>).</p>
<p><b>IMPORTANT</b>: This real-time synchronization is a hack. <i><b>Do not rely on it in any (safety) relevant application where precise timing is mandatory</b></i>!</p>
<h4>Sampled Mode</h4>
<p>Setting parameter <code>sampled</code> to &quot;true&quot;, activates a sample-based real-time synchronization, otherwise an approach without sampling is used. &quot;true&quot; is recommended for more deterministic, less solver sensitive behavior, but requires choosing appropriate sampling settings.</p>
<h4>Implementation Notes</h4>
<p>The block introduces an equation with a call to an external C-function that takes the current simulation time as an argument. Within the C-function the simulation time is compared to the operating system real-time clock and execution of the thread is halted until the simulation time equals real-time. This equation will be added to the other model equations and sorted according to the (tool dependent) sorting algorithm. Therefore, no prediction can be made when, within the simulation cycle, the real-time synchronization function is called (e.g., it might be before, or after (external) inputs are read from a device or (external) outputs are written to a device).</p>
<h4>Final Remark</h4>
<p>If your Modelica tool provides a better mechanism to real-time synchronization, consider to use that mechanism instead of that block. E.g., Dymola provides a &quot;Synchronize with real-time&quot; option within the solver settings. If that option is ticked the &quot;SynchronizeRealtime&quot; block is not needed! However, Dymola only supports that option for Windows (at least Dymola 2013 and below). Also, experiences of the authors indicate that compile and run-time performance seems sometimes better using the &quot;hackish&quot; block, than using the &quot;official&quot; real-time synchronization of Dymola. Please test for yourself, which option works best for you.</p>
</html>"));
  end RealtimeSynchronize;

  block ProcessPriority "Set process priority"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Types.ProcessPriority priority = "Normal" "Priority of the simulation process";
    Modelica_DeviceDrivers.OperatingSystem.ProcessPriority procPrio = Modelica_DeviceDrivers.OperatingSystem.ProcessPriority();
  equation
    when initial() then
      Modelica_DeviceDrivers.OperatingSystem.setProcessPriority(procPrio,
        if
          (priority == "Idle") then -2 else
        if
          (priority == "Below normal") then -1 else
        if
          (priority == "Normal") then 0 else
        if
          (priority == "High priority") then 1 else
        if
          (priority == "Realtime") then 2 else
        0);
    end when;
  annotation (Documentation(info="<html>
<p>Sets the process priority of the current process. Different priority levels are supported:</p>
<ul>
<li>Idle</li>
<li>Below Normal</li>
<li>Normal</li>
<li>High Priority</li>
<li>Real-Time</li>
</ul>
<p>Using the &quot;High Priority&quot; and &quot;Real-Time&quot; priorities in Linux will usually require &quot;root&quot; privileges for the simulation process. Using the &quot;Real-Time&quot; priority in Linux with a low-latency kernel as provided by the PREEMPT_RT patch will even provide limited (however, implementation specific limitations given below still apply) &quot;hard&quot; real-time capabilities (see e.g., <a href=\"https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html\">https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html</a>).</p>
<p>Typically, this block will be used together with the <a href=\"modelica://Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize\">RealtimeSynchronize</a> block for improving the real-time performance.</p>
</html>"), Icon(graphics={
          Text(extent={{-100,20},{100,-20}},
            textColor={0,0,0},
            textString="%priority"),
          Text(extent={{-150,142},{150,102}}, textString="%name")}));
  end ProcessPriority;

  block RandomRealSource
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Integer n=1 "Dimension of output vector";
    parameter Modelica.Units.SI.Period sampleTime=0.01
      "Sample time of random number generation";
    input Real minValue[n]=fill(0,n) "Minimum value of random output" annotation(Dialog(enable=true));
    input Real maxValue[n]=fill(1,n) "Maximum value of random output" annotation(Dialog(enable=true));

    Modelica.Blocks.Interfaces.RealOutput y[n]
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    when sample(0, sampleTime) then
      for i in 1:n loop
        y[i] = Modelica_DeviceDrivers.OperatingSystem.randomReal(minValue[i], maxValue[i]);
      end for;
    end when;
    annotation (preferredView="info",
      Icon(graphics={
          Polygon(
            points={{-80,60},{-60,60},{-70,80},{-80,60}}),
          Line(
            points={{-70,60},{-70,-70},{60,-70}}),
          Polygon(
            points={{60,-60},{60,-80},{80,-70},{60,-60}}),
          Line(
            points={{-70,0},{-64,-20},{-58,14},{-52,-40},{-48,-8},{-42,0},{-34,-48},
                {-28,28},{-20,-28},{-14,8},{-12,50},{-6,-28},{2,22},{6,-6},{12,-52},
                {12,-50},{18,52},{22,-6},{26,32},{30,-20},{38,36},{42,-14},{48,38},
                {54,-48},{60,-18}}),
          Line(
            points={{-70,54},{62,54}},
            pattern=LinePattern.Dash),
          Line(
            points={{-70,-52},{62,-52}},
            pattern=LinePattern.Dash),
          Text(
            extent={{-100,62},{-72,46}},
            textColor={135,135,135},
            textString="max"),
          Text(
            extent={{-100,-44},{-72,-60}},
            textColor={135,135,135},
            textString="min"),
          Text(
            extent={{-100,140},{100,100}},
            textColor={0,0,255},
            textString="%name")}),
      Documentation(info="<html>
<p>Uses the <code>rand()</code>function from the C standard library for creating pseudo-random numbers. The computers real-time clock is used to obtain seed values for the sequence of pseudo-random numbers.</p>
</html>"));
  end RandomRealSource;

  block SynchronizeRealtime "Deprecated block. Use \"RealtimeSynchronize\" instead."
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica.Icons.ObsoleteModel;

    block ProcessPriority "Set process priority"
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      parameter Types.ProcessPriority priority = "Normal" "Priority of the simulation process";
      Modelica_DeviceDrivers.OperatingSystem.ProcessPriority procPrio = Modelica_DeviceDrivers.OperatingSystem.ProcessPriority();
    equation
      when initial() then
        Modelica_DeviceDrivers.OperatingSystem.setProcessPriority(procPrio,
          if
            (priority == "Idle") then -2 else
          if
            (priority == "Below normal") then -1 else
          if
            (priority == "Normal") then 0 else
          if
            (priority == "High priority") then 1 else
          if
            (priority == "Realtime") then 2 else
          0);
      end when;
    annotation (Documentation(info="<html>
<p>Sets the process priority of the current process. Different priority levels are supported:</p>
<ul>
<li>Idle</li>
<li>Below Normal</li>
<li>Normal</li>
<li>High Priority</li>
<li>Real-Time</li>
</ul>
</html>"));
    end ProcessPriority;

    parameter Boolean setPriority = true "true, if process priority is to be set, otherwise false" annotation(Evaluate=true, HideResult=true);
    parameter Types.ProcessPriority priority = "Normal" "Priority of the simulation process" annotation(Dialog(enable=setPriority));
    parameter Boolean enable = true "true, if real-time synchronization is enabled, otherwise it is disabled!" annotation(Dialog(group="Advanced"), choices(checkBox=true));
    parameter Boolean enableRealTimeScaling = false
      "true, enable external real-time scaling input signal"
      annotation(Evaluate=true, HideResult=true, Dialog(group="Advanced"), choices(checkBox=true));
    Modelica.Blocks.Interfaces.RealInput scaling if enableRealTimeScaling
      "Real-time scaling factor; > 1 means the simulation is made slower than real-time"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    output Modelica.Units.SI.Time calculationTime "Time needed for calculation";
    output Modelica.Units.SI.Time availableTime
      "Time available for calculation (integrator step size)";
  protected
    ProcessPriority procPrio(final priority = priority) if setPriority;
    Real dummyState(start = 0, fixed=true) "dummy state to be integrated, to force synchronization in every integration step";
    Modelica_DeviceDrivers.OperatingSystem.RealTimeSynchronization rtSync = Modelica_DeviceDrivers.OperatingSystem.RealTimeSynchronization();
    /* Connectors for conditional connect equations */
    Modelica.Blocks.Interfaces.RealInput defaultScaling = 1 if not enableRealTimeScaling "Default real-time scaling";
    Modelica.Blocks.Interfaces.RealInput actScaling annotation(HideResult=true);
  equation
    /* Conditional connect equations to either use external real-time scaling input or default scaling */
    connect(defaultScaling, actScaling);
    connect(scaling, actScaling);
    if enable then
      (calculationTime, availableTime) = Modelica_DeviceDrivers.OperatingSystem.realtimeSynchronize(rtSync, time, enableRealTimeScaling, actScaling);
    else
      calculationTime = 0;
      availableTime = Modelica.Constants.inf;
    end if;
    der(dummyState) = calculationTime;
  annotation (preferredView="info",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Bitmap(extent={{-60,-60},{60,60}}, fileName=
                "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/clock.png"),
          Text(
            extent={{-100,-100},{100,-140}},
            textString=DynamicSelect("", if setPriority then "%priority" else "")), Text(extent={{-150,142},{150,102}},
              textString="%name")}),
      Documentation(info="<html>
<p>Synchronizes the simulation time of the simulation process with the operating system real-time clock. Different priority levels are supported:</p>
<ul>
<li>Idle</li>
<li>Below Normal</li>
<li>Normal</li>
<li>High Priority</li>
<li>Real-Time</li>
</ul>
<p>Note that the provided level of real-time synchronization is &quot;soft&quot;, meaning that there are no guarantees that deadlines are met or that latencies are restricted to a predictable (low) maximum. This is often enough to satisfy requirements for interactive simulations and can be compared to the real-time experience provided by computer games. However, applications requiring &quot;hard&quot; real-time synchronization (e.g. HIL simulations) are <b>not</b> satisfied!</p>
<p>Using the &quot;High Priority&quot; and &quot;Real-Time&quot; priorities in Linux will usually require &quot;root&quot; privileges for the simulation process. Using the &quot;Real-Time&quot; priority in Linux with a low-latency kernel as provided by the PREEMPT_RT patch will even provide limited (however, implementation specific limitations given below still apply) &quot;hard&quot; real-time capabilities (see e.g., <a href=\"https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html\">https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html</a>).</p>
<p><b>IMPORTANT</b>: This real-time synchronization is a hack. <i><b>Do not rely on it in any (safety) relevant application where precise timing is mandatory</b></i>!</p>
<h4>Implementation Notes</h4>
<p>The block introduces an equation with a call to an external C-function that takes the current simulation time as an argument. Within the C-function the simulation time is compared to the operating system real-time clock and execution of the thread is halted until the simulation time equals real-time. This equation will be added to the other model equations and sorted according to the (tool dependent) sorting algorithm. Therefore, no prediction can be made when, within the simulation cycle, the real-time synchronization function is called (e.g., it might be before, or after (external) inputs are read from a device or (external) outputs are written to a device).</p>
<h4>Final Remark</h4>
<p>If your Modelica tool provides a better mechanism to real-time synchronization, consider to use that mechanism instead of that block. E.g., Dymola provides a &quot;Synchronize with real-time&quot; option within the solver settings. If that option is ticked the &quot;SynchronizeRealtime&quot; block is not needed! However, Dymola only supports that option for Windows (at least Dymola 2013 and below). Also, experiences of the authors indicate that compile and run-time performance seems sometimes better using the &quot;hackish&quot; block, than using the &quot;official&quot; real-time synchronization of Dymola. Please test for yourself, which option works best for you.</p>
</html>"));
  end SynchronizeRealtime;

  package Types
    extends Modelica.Icons.TypesPackage;

    type ProcessPriority = Modelica.Icons.TypeString
    annotation (
      preferredView="text",
      Evaluate=true,
      choices(
        choice="Idle" "Idle",
        choice="Below normal" "Below normal",
        choice="Normal" "Normal",
        choice="High priority" "High priority",
        choice="Realtime" "Realtime"));
  end Types;

  package Internal
    extends Modelica.Icons.InternalPackage;

    partial block PartialRealtimeSynchronize
      "An improved block for real-time synchronization. Common interface definitions."
      import SIunits =
             Modelica.Units.SI;
      input Real scaling(min=0) = 1 "real-time scaling factor; > 1 means the simulation is made slower than real-time" annotation(Dialog(enable=true));
      parameter Boolean showAdvancedOutputs = true "Show output for computing time and remaining time"  annotation (Dialog(group="Advanced"), choices(checkBox=true));
      parameter Boolean shouldCatchupTime = false "true, try to catch up delays from missed dead-lines by progressing faster than real-time, otherwise do not" annotation (Dialog(group="Advanced"), choices(checkBox=true));
      final parameter SIunits.Time startSimTime(fixed=false);

      Modelica_DeviceDrivers.OperatingSystem.RTSync rtSync =  Modelica_DeviceDrivers.OperatingSystem.RTSync(startSimTime, shouldCatchupTime);

      Modelica.Blocks.Interfaces.RealOutput wallClockTime(unit="s") "Wall clock time (= real-time) that elapsed since initialization of the real-time synchronization object" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,50},
                {120,70}})));
      Modelica.Blocks.Interfaces.RealOutput remainingTime(unit="s") "Wall clock time that is left before real-time deadline is reached" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,-30},
                {120,-10}})));
      Modelica.Blocks.Interfaces.RealOutput computingTime(unit="s") "Wall clock time between invocations of the real-time sync function, i.e., \"computing time\" in seconds" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,-70},
                {120,-50}})));
      Modelica.Blocks.Interfaces.RealOutput simTime(unit="s") "(= time) Simulation time at the the real-time sync function invocation" annotation (Placement(visible=showAdvancedOutputs,transformation(extent={{100,10},
                {120,30}})));
      output SIunits.Duration lastStepSize "(= time - lastSimTime) The last simulation time step size between invocations of the real-time sync function";
      output SIunits.Time lastSimTime "Simulation time at the previous invocation of the real-time sync function, the simulation start time at its the first invocation";
    initial equation
      startSimTime = time;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialRealtimeSynchronize;

    block RealtimeSynchronize_Continuous
      "An improved block for real-time synchronization. Continuous case."
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends
        Modelica_DeviceDrivers.Blocks.OperatingSystem.Internal.PartialRealtimeSynchronize;
    // protected
    //   Real dummyState(start = 0, fixed=true) "Dummy state to be integrated, to force synchronization in every integration step"; // FIXME: Do we need this?
    equation
      simTime = time;
      (wallClockTime, remainingTime, computingTime, lastSimTime) = Modelica_DeviceDrivers.OperatingSystem.rtSyncSynchronize(rtSync, simTime, scaling);
      lastStepSize = simTime - lastSimTime;
    //  der(dummyState) = computingTime;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Text(
              extent={{-86,32},{88,-30}},
              textColor={28,108,200},
              textString="Continuous")}),                            Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end RealtimeSynchronize_Continuous;

    block RealtimeSynchronize_Sampled
      "An improved block for real-time synchronization. Sampled Cased."
      extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
      extends
        Modelica_DeviceDrivers.Blocks.OperatingSystem.Internal.PartialRealtimeSynchronize;
      extends
        Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    equation

      when actTrigger then
       simTime = time;
       (wallClockTime, remainingTime, computingTime, lastSimTime) = Modelica_DeviceDrivers.OperatingSystem.rtSyncSynchronize(rtSync, simTime, scaling);
       lastStepSize = time - lastSimTime;
      end when;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Text(
              extent={{-88,28},{92,-30}},
              textColor={28,108,200},
              textString="Sampled")}),                               Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end RealtimeSynchronize_Sampled;
  end Internal;
end OperatingSystem;
