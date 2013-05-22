within Modelica_DeviceDrivers.ClockedBlocks;
package OperatingSystem
  extends Modelica.Icons.Package;
  block SynchronizeRealtime "A pseudo realtime synchronization"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Integer resolution(min = 1) = 1 "resolution of the timer";
    parameter
      Modelica_DeviceDrivers.ClockedBlocks.OperatingSystem.Types.ProcessPriority
      priority="Normal" "Priority of the simulation process";
    output Real calculationTime "Time needed for calculation";
    output Real availableTime
      "Time available for calculation (integrator step size)";
  protected
    Boolean initialized(start=false);
  algorithm
      if not initialized then
        Modelica_DeviceDrivers.OperatingSystem.setProcessPriority(
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
        initialized := true;
      else
        (calculationTime,availableTime) := Modelica_DeviceDrivers.OperatingSystem.realtimeSynchronize(time, resolution);
      end if;
    annotation (preferredView="info",
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}), graphics={
          Bitmap(extent={{-60,60},{60,-60}}, fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/clock.png"),
          Text(
            extent={{-100,-100},{100,-140}},
            lineColor={0,0,0},
            textString="%priority"),       Text(extent={{-150,142},{150,102}},
              textString="%name")}),   Diagram(graphics={Text(
            textString="Edit Here",
            extent={{-88,80},{100,70}},
            lineColor={0,0,255})}),
      Documentation(info="<html>
<p>Synchronizes the simulation time of the simulation process with the operating system real-time clock. Different priority levels are supported:</p>
<p><ul>
<li>Idle</li>
<li>Below Normal</li>
<li>Normal</li>
<li>High Priority</li>
<li>Real-Time</li>
</ul></p>
<p>Note that the provided level of real-time synchronization is &quot;soft&quot;, meaning that there are no guarantees that dead lines are met or that latencies are restricted to a predictable (low) maximum. This is often enough to satisfy requirements for interactive simulations and can be compared to the real-time experience provided by computer games. However, applications requiring &quot;hard&quot; real-time synchronization (e.g. HIL simulations) are <b>not</b> satisfied!</p>
<p>Using the &quot;High Priority&quot; and &quot;Real-Time&quot; priorities in Linux will usually require &quot;root&quot; privileges for the simulation process. Using the &quot;Real-Time&quot; priority in Linux with a low-latency kernel as provided by the PREEMPT_RT patch will even provide limited (however, implementation specific limitations given below still apply) &quot;hard&quot; real-time capabilities (see e.g., <a href=\"https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html\">https://www.osadl.org/Realtime-Linux.projects-realtime-linux.0.html</a>).</p>
<p><b>IMPORTANT</b>: This real-time synchronization is a hack. <i><b>Don&apos;t rely on it in any (safety) relevant applications there precise timing is mandatory</b></i>!</p>
<p><h4><font color=\"#008000\">Implementation Notes</font></h4></p>
<p>The block introduces an equation with a call to an external C-function that takes the current simulation time as an argument. Within the C-function the simulation time is compared to the operating system real-time clock and execution of the thread is halted until simulation time == real-time. This equation will be added to the other model equations and sorted according to the (tool dependent) sorting algorithm. Therefore, no prediction can be made when, within the simulation cycle, the real-time synchronization function is called (e.g., it might be before, or after (external) inputs are read from a device or (external) outputs are written to a device).</p>
<p><h4><font color=\"#008000\">Final Remark</font></h4></p>
<p>If your Modelica tool provides a better mechanism to real-time synchronization, consider to use that mechanism instead of that block. E.g., Dymola provides a &quot;Synchronize with real-time&quot; option within the solver settings. If that option is ticked the &quot;SynchronizeRealtime&quot; block is not needed! However, Dymola only supports that option for Windows (at least Dymola 2013 and below). Also, experiences of the authors indicate that compile and run-time performance seems sometimes better using the &quot;hackish&quot; block, than using the &quot;official&quot; real-time synchronization of Dymola. Please test for yourself, which option works best for you.</p>
</html>"));
  end SynchronizeRealtime;

  package Types
    extends Modelica.Icons.Package;
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

  block RandomRealSource
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
    parameter Integer n=1 "Dimension of output vector";
    input Real minValue[n]={0} "maximum Value of random output" annotation (Dialog = true);
    input Real maxValue[n]={1} "maximum Value of random output" annotation (Dialog = true);

    Modelica.Blocks.Interfaces.RealOutput y[n]
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    when Clock() then
      for i in 1:n loop
        y[i] = Modelica_DeviceDrivers.OperatingSystem.randomReal(minValue[i],
          maxValue[i]);
      end for;
    end when;
    annotation (preferredView="info",
        Diagram(graphics), Icon(graphics={
          Polygon(
            points={{-80,60},{-60,60},{-70,80},{-80,60}},
            lineColor={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-70,60},{-70,-70},{60,-70}},
            color={0,0,0},
            smooth=Smooth.None),
          Polygon(
            points={{60,-60},{60,-80},{80,-70},{60,-60}},
            lineColor={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-70,0},{-64,-20},{-58,14},{-52,-40},{-48,-8},{-42,0},{-34,-48},
                {-28,28},{-20,-28},{-14,8},{-12,50},{-6,-28},{2,22},{6,-6},{12,-52},
                {12,-50},{18,52},{22,-6},{26,32},{30,-20},{38,36},{42,-14},{48,38},
                {54,-48},{60,-18}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-70,54},{62,54}},
            color={0,0,0},
            smooth=Smooth.None,
            pattern=LinePattern.Dash),
          Line(
            points={{-70,-52},{62,-52}},
            color={0,0,0},
            smooth=Smooth.None,
            pattern=LinePattern.Dash),
          Text(
            extent={{-100,62},{-72,46}},
            lineColor={135,135,135},
            pattern=LinePattern.Dash,
            textString="max"),
          Text(
            extent={{-100,-44},{-72,-60}},
            lineColor={135,135,135},
            pattern=LinePattern.Dash,
            textString="min"),
          Text(
            extent={{-100,140},{100,100}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(info="<html>
<p>Uses the <code>rand()</code>function from the C standard library for creating pseudo-random numbers. The computers real-time clock is used to obtain seed values for the sequence of pseudo-random numbers.</p>
</html>"));
  end RandomRealSource;
end OperatingSystem;
