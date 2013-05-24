within Modelica_DeviceDrivers.Blocks;
package InputDevices
    extends Modelica.Icons.Package;
  block JoystickInput
    "Joystick input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Real sampleTime = 0.01 "sample time for input update";
    parameter Real gain[6] = ones(6) "gain of axis output";
    parameter Integer ID= 0
      "ID number of the joystick (0 = first joystick attached to the system)";
    Modelica.Blocks.Interfaces.RealOutput axes[6](start=zeros(6))
      annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput pOV annotation (Placement(
          transformation(extent={{100,-10},{120,10}}, rotation=0)));
    Modelica.Blocks.Interfaces.IntegerOutput buttons[8]
      annotation (Placement(transformation(extent={{100,-70},{120,-50}}, rotation=
             0)));
  protected
    Real AxesRaw[6] "unscaled joystick input";
  equation
    when
        (sample(0,sampleTime)) then
      (AxesRaw,buttons,pOV) =
        Modelica_DeviceDrivers.InputDevices.GameController.getData(ID);
    end when;
    axes = (AxesRaw .- 32768)/32768 ./gain;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}),
                        graphics),
                         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Bitmap(extent={{-86,88},{88,-88}},
              fileName="../Resources/Images/Icons/joystick.png"), Text(extent={
                {-150,140},{150,100}}, textString="%name")}),
                preferredView="info",Documentation(info="<html> This block reads data from the joystick ID (0 = first joystick appearing in windows control panel).
                                Multible blocks can be used in order to retrieve data from more than one joysticks.
                                Up to six axes and eight buttons are supported. The input values ranges between -1 and 1 and can be scaled by the
                                vector <b>gain</b>. Via the parameter <b>sampleTime</b> the input sampling rate is chosen.</html>"));
  end JoystickInput;

  block KeyboardKeyInput
    "Keyboard input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Real sampleTime = 0.01 "sample time for input update";
    parameter Modelica_DeviceDrivers.Blocks.InputDevices.Types.keyCodes keyCode="Return"
      "Monitored Key";
    Modelica.Blocks.Interfaces.BooleanOutput keyState
      annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
              0)));
  protected
    Integer keyStateInt(start=0,fixed=true);
    Integer keyCodeInt =   if (keyCode == "Return") then 13 else
                           if (keyCode == "Control") then 17 else
                           if (keyCode == "Space") then 32 else
                           if (keyCode == "Alt") then 18 else
                           if (keyCode == "Home") then 36 else
                           if (keyCode == "End") then 35 else
                           if (keyCode == "Left") then 37 else
                           if (keyCode == "Right") then 39 else
                           if (keyCode == "Up") then 38 else
                           if (keyCode == "Down") then 40 else
                           if (keyCode == "Page Up") then 33 else
                           if (keyCode == "Page Down") then 34 else
                           if (keyCode == "Tab") then 9 else
                           if (keyCode == "F1") then 112 else
                           if (keyCode == "F2") then 113 else
                           if (keyCode == "F3") then 114 else
                           if (keyCode == "F4") then 115 else
                           if (keyCode == "F5") then 116 else
                           if (keyCode == "F6") then 117 else
                           if (keyCode == "F7") then 118 else
                           if (keyCode == "F8") then 119 else
                           if (keyCode == "F9") then 120 else
                           if (keyCode == "F10") then 121 else
                           if (keyCode == "F11") then 122 else
                           if (keyCode == "F12") then 123 else 13;
  equation
    when
        (sample(0,sampleTime)) then
      keyStateInt = Modelica_DeviceDrivers.InputDevices.Keyboard.getKey(keyCodeInt);
                                              //getting the KeyCode
    end when;
    keyState = if (keyStateInt==1) then true else false;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics),
                         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Text(extent={{-150,140},{150,100}}, textString="%name"),
          Rectangle(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,80},{-60,78},{-60,-60},{-80,-80},{-80,80}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{80,80},{60,78},{60,-60},{80,-80},{80,80}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,-80},{-60,-60},{60,-60},{80,-80},{-80,-80}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{100,-12},{164,-38}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            textString="keyState"),
          Polygon(
            points={{-80,80},{80,80},{60,78},{-60,78},{-80,80}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={236,236,236},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,20},{100,-20}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={236,236,236},
            fillPattern=FillPattern.Solid,
            textString="%keyCode")}),
              preferredView="info",Documentation(info="<html> This block reads data from the keyboard. The monitored key is selected via the parameter <b>keyCode</b>.
                                       Note, that keystrokes will not be captured and the focused window will process them.
                                       Via the parameter <b>sampleTime</b> the input sampling rate is chosen.</html>"));
  end KeyboardKeyInput;

  block SpaceMouseInput
    "SpaceMouse input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Real sampleTime = 0.01 "sample time for input update";
    parameter Real gain[6] = ones(6) "gain of axis output";
    Modelica.Blocks.Interfaces.RealOutput axes[6]
      annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
    Modelica.Blocks.Interfaces.IntegerOutput buttons[16]
      annotation (Placement(transformation(extent={{100,-70},{120,-50}}, rotation=
             0)));
  protected
    Real AxesRaw[6] "unscaled SpaceMouse input";
  public
    Modelica.Blocks.Continuous.FirstOrder firstOrder[6](each T=0.1)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={50,60})));
  equation
    when
        (sample(0,sampleTime)) then
      (AxesRaw,buttons) = Modelica_DeviceDrivers.InputDevices.SpaceMouse.getData();
    end when;
    firstOrder.u = AxesRaw/400 .*gain;
    connect(firstOrder.y, axes) annotation (Line(
        points={{61,60},{110,60}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}),
                        graphics),
                         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,140},{150,100}},
              textString="%name"), Bitmap(extent={{-86,88},{88,-88}}, fileName=
                "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Spacemouse.png")}),
              preferredView="info",Documentation(info="<html>
<p>This block reads data from the 3Dconnexion SpaceMouse. It provides the six axis and up to sixteen button inputs. Note, that only the first SpaceMouse attached on the system can be read.The input values ranges between approx. -1 and 1 and can be scaled by the vector <b>gain</b>. Via the parameter <b>sampleTime</b> the input sampling rate is chosen.</p>
<h4><font color=\"#008000\">Note for Linux</font></h4>
<p>Using the SpaceMouse in Linux is possible, but requires that the Linux drivers offered by 3Dconnexion are installed and active (<a href=\"http://www.3dconnexion.com/\">http://www.3dconnexion.com/</a>).</p>
</html>"));
  end SpaceMouseInput;

  block KeyboardInput
    "Keyboard input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Real sampleTime = 0.01 "sample time for input update";
    Modelica.Blocks.Interfaces.BooleanOutput keyUp
      annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
    Modelica.Blocks.Interfaces.BooleanOutput keyDown
      annotation (Placement(transformation(
          origin={0,-110},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    Modelica.Blocks.Interfaces.BooleanOutput keyRight
      annotation (Placement(transformation(
          origin={60,-110},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    Modelica.Blocks.Interfaces.BooleanOutput keyLeft
      annotation (Placement(transformation(
          origin={-60,-110},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    Modelica.Blocks.Interfaces.BooleanOutput keyReturn
      annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
              0)));
    Modelica.Blocks.Interfaces.BooleanOutput keySpace
      annotation (Placement(transformation(extent={{100,-70},{120,-50}}, rotation=
             0)));
  protected
    Integer KeyCode[10](each start=0, each fixed=true);
  equation
    when
        (sample(0,sampleTime)) then
      KeyCode = Modelica_DeviceDrivers.InputDevices.Keyboard.getData();
                                              //getting the KeyCode
    end when;
    keyUp = if (KeyCode[1]==1) then true else false;
    keyDown = if (KeyCode[2]==1) then true else false;
    keyRight = if (KeyCode[3]==1) then true else false;
    keyLeft = if (KeyCode[4]==1) then true else false;
    keyReturn = if (KeyCode[5]==1) then true else false;
    keySpace = if (KeyCode[6]==1) then true else false;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics),
                         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Text(extent={{-150,140},{150,100}}, textString="%name"),
          Rectangle(
            extent={{-28,58},{28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,58},{-20,58},{-20,18},{-28,2},{-28,58}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{28,58},{18,58},{18,18},{28,2},{28,58}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,2},{-20,18},{18,18},{28,2},{-28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-28,2},{28,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{28,2},{84,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-84,2},{-28,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-84,-54},{-76,-38},{-38,-38},{-28,-54},{-84,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-84,2},{-76,2},{-76,-38},{-84,-54},{-84,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,2},{-38,2},{-38,-38},{-28,-54},{-28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,2},{-20,2},{-20,-38},{-28,-54},{-28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{28,2},{18,2},{18,-38},{28,-54},{28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,-54},{-20,-38},{18,-38},{28,-54},{-28,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{28,2},{36,2},{36,-38},{28,-54},{28,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{84,2},{74,2},{74,-38},{84,-54},{84,2}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{28,-54},{36,-38},{74,-38},{84,-54},{28,-54}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-2,50},{-2,28}}, color={95,95,95}),
          Polygon(
            points={{-2,50},{-6,42},{2,42},{-2,50}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-2,-6},{-2,-28}}, color={95,95,95}),
          Polygon(
            points={{-2,-28},{-6,-20},{2,-20},{-2,-28}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-46,-18},{-68,-18}}, color={95,95,95}),
          Polygon(
            points={{-60,-22},{-68,-18},{-60,-14},{-60,-22}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{66,-18},{44,-18}}, color={95,95,95}),
          Polygon(
            points={{58,-22},{66,-18},{58,-14},{58,-22}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{-60,-60},{-60,-100}}, color={255,0,255}),
          Line(points={{0,-60},{0,-100}}, color={255,0,255}),
          Line(points={{60,-60},{60,-100}}, color={255,0,255}),
          Line(points={{0,60},{100,60}}, color={255,0,255}),
          Text(
            extent={{100,-72},{164,-98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            textString="space"),
          Text(
            extent={{100,-12},{164,-38}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            textString="return")}),
              preferredView="info",Documentation(info="<html> This block reads data from the keyboard. The arrow keys, space and return are monitored.
                                       Note, that keystrokes will not be captured and the focused window will process them.
                                       Via the parameter <b>sampleTime</b> the input sampling rate is chosen.</html>"));
  end KeyboardInput;

  package Types
      extends Modelica.Icons.Package;
    type keyCodes =  Modelica.Icons.TypeString
    annotation (
      preferredView="text",
      Evaluate=true,
      choices(
        choice="Return" "Return",
        choice="Control" "Control",
        choice="Space" "Space",
        choice="Alt" "Alt",
        choice="Home" "Home",
        choice="End" "End",
        choice="Left" "Left",
        choice="Right" "Right",
        choice="Up" "Up",
        choice="Down" "Down",
        choice="Page Up" "Page Up",
        choice="Page Down" "Page Down",
        choice="Tab" "Tab",
        choice="F1" "F1",
        choice="F2" "F2",
        choice="F3" "F3",
        choice="F4" "F4",
        choice="F5" "F5",
        choice="F6" "F6",
        choice="F7" "F7",
        choice="F8" "F8",
        choice="F9" "F9",
        choice="F10" "F10",
        choice="F11" "F11",
        choice="F12" "F12"));
  end Types;
end InputDevices;
