within Modelica_DeviceDrivers.ClockedBlocks;
package InputDevices
  extends Modelica.Icons.Package;
  block JoystickInput
    "Joystick input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;

    parameter Real gain[6] = ones(6) "gain of axis output";
    parameter Integer ID= 0
      "ID number of the joystick (0 = first joystick attached to the system)";

    Modelica.Blocks.Interfaces.RealOutput axes[6]
      annotation (Placement(transformation(extent={{100,50},{120,70}})));
    Modelica.Blocks.Interfaces.RealOutput pOV annotation (Placement(
          transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput buttons[8]
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  protected
    Real AxesRaw[6] "unscaled joystick input";
  equation
    when Clock() then
      (AxesRaw,buttons,pOV) = Modelica_DeviceDrivers.InputDevices.GameController.getData(ID);
      axes = (AxesRaw .- 32768)/32768 ./gain;
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Bitmap(extent={{-86,88},{88,-88}},
              fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/joystick.png"),
                                                                  Text(extent={
                {-150,140},{150,100}}, textString="%name")}),
                preferredView="info",Documentation(info="<html>
<p>This block reads data from the joystick ID (0 = first joystick appearing in windows control panel). Multible blocks can be used in order to retrieve data from more than one joysticks. Up to six axes and eight buttons are supported. The input values ranges between -1 and 1 and can be scaled by the vector <b>gain</b>.</p>
</html>"));
  end JoystickInput;

  block KeyboardKeyInput
    "Keyboard input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;

    parameter Modelica_DeviceDrivers.ClockedBlocks.InputDevices.Types.keyCodes keyCode="Return"
      "Monitored Key";
    parameter Boolean useKeyKombination=false
      "if true, an additional key can be selected to a combination"
       annotation (choices(checkBox=true));
    parameter Modelica_DeviceDrivers.ClockedBlocks.InputDevices.Types.keyCodes
      additionalKeyCode="Control"
      "Additional monitored key for key combination" annotation(Dialog(enable=useKeyKombination));

    Modelica.Blocks.Interfaces.BooleanOutput keyState
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    encapsulated function getKeyCode
      input String keyCode;
      output Integer keyCodeInt;
    algorithm
      keyCodeInt := if (keyCode == "A") then 65 else if (keyCode == "B") then 66
         else if (keyCode == "C") then 67 else if (keyCode == "D") then 68 else
        if (keyCode == "E") then 69 else if (keyCode == "F") then 70 else if (
        keyCode == "G") then 71 else if (keyCode == "H") then 72 else if (keyCode == "I")
         then 73 else if (keyCode == "J") then 74 else if (keyCode == "K") then 75
         else if (keyCode == "L") then 76 else if (keyCode == "M") then 77 else
        if (keyCode == "N") then 78 else if (keyCode == "O") then 79 else if (
        keyCode == "P") then 80 else if (keyCode == "Q") then 81 else if (keyCode == "R")
         then 82 else if (keyCode == "S") then 83 else if (keyCode == "T") then 84
         else if (keyCode == "U") then 85 else if (keyCode == "V") then 86 else
        if (keyCode == "W") then 87 else if (keyCode == "X") then 88 else if (
        keyCode == "Y") then 89 else if (keyCode == "Z") then 90 else if (keyCode == "0")
         then 48 else if (keyCode == "1") then 49 else if (keyCode == "2") then 50
         else if (keyCode == "3") then 51 else if (keyCode == "4") then 52 else
        if (keyCode == "5") then 53 else if (keyCode == "6") then 54 else if (
        keyCode == "7") then 55 else if (keyCode == "8") then 56 else if (keyCode == "9")
         then 57 else if (keyCode == "Return") then 13 else if (keyCode == "Control")
         then 17 else if (keyCode == "Space") then 32 else if (keyCode == "Alt")
         then 18 else if (keyCode == "Home") then 36 else if (keyCode == "End")
         then 35 else if (keyCode == "Left") then 37 else if (keyCode == "Right")
         then 39 else if (keyCode == "Up") then 38 else if (keyCode == "Down")
         then 40 else if (keyCode == "Page Up") then 33 else if (keyCode == "Page Down")
         then 34 else if (keyCode == "Tab") then 9 else if (keyCode == "Num0")
         then 96 else if (keyCode == "Num1") then 97 else if (keyCode == "Num2")
         then 98 else if (keyCode == "Num3") then 99 else if (keyCode == "Num4")
         then 100 else if (keyCode == "Num5") then 101 else if (keyCode == "Num6")
         then 102 else if (keyCode == "Num7") then 103 else if (keyCode == "Num8")
         then 104 else if (keyCode == "Num9") then 105 else if (keyCode == "Add")
         then 107 else if (keyCode == "Sub") then 109 else if (keyCode == "Mult")
         then 106 else if (keyCode == "Div") then 111 else if (keyCode == "F1")
         then 112 else if (keyCode == "F2") then 113 else if (keyCode == "F3")
         then 114 else if (keyCode == "F4") then 115 else if (keyCode == "F5")
         then 116 else if (keyCode == "F6") then 117 else if (keyCode == "F7")
         then 118 else if (keyCode == "F8") then 119 else if (keyCode == "F9")
         then 120 else if (keyCode == "F10") then 121 else if (keyCode == "F11")
         then 122 else if (keyCode == "F12") then 123 else 13;
    end getKeyCode;

    final parameter Integer keyCodeInt=getKeyCode(keyCode);
    final parameter Integer additionalKeyCodeInt=getKeyCode(additionalKeyCode);
    Integer keyStateInt(start=0);
    Integer additionalKeyStateInt(start=0);

  equation
    when Clock() then
      keyStateInt = Modelica_DeviceDrivers.InputDevices.Keyboard.getKey(keyCodeInt); //getting the KeyCode
      additionalKeyStateInt = Modelica_DeviceDrivers.InputDevices.Keyboard.getKey(additionalKeyCodeInt);
      keyState = if (not useKeyKombination and keyStateInt == 1 and additionalKeyStateInt == 0) then true else
        if (useKeyKombination and keyStateInt == 1 and additionalKeyStateInt == 1) then true else false;
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
              preferredView="info",Documentation(info="<html>
<p>This block reads data from the keyboard. The monitored key is selected via the parameter <b>keyCode</b>. Note, that keystrokes will not be captured and the focused window will process them.</p>
</html>"));
  end KeyboardKeyInput;

  block SpaceMouseInput
    "SpaceMouse input implementation for interactive simulations"
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends
      Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;

    parameter Real gain[6] = ones(6) "gain of axis output";
    Modelica.Blocks.Interfaces.RealOutput axes[6]
      annotation (Placement(transformation(extent={{100,50},{120,70}})));
    Modelica.Blocks.Interfaces.IntegerOutput buttons[16]
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  protected
    Real AxesRaw[6] "unscaled SpaceMouse input";
  equation
    when Clock() then
      (AxesRaw,buttons) = Modelica_DeviceDrivers.InputDevices.SpaceMouse.getData();
      // Note that the original SpaceMouse block used PT1-Filtering for the axis. Not yet implemented for the clocked block.
      axes = AxesRaw;
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,140},{150,100}},
              textString="%name"), Bitmap(extent={{-86,88},{88,-88}}, fileName=
                "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Spacemouse.png")}),
              preferredView="info",Documentation(info="<html>
<p>This block reads data from the 3Dconnexion SpaceMouse. It provides the six axis and up to sixteen button inputs. Note, that only the first SpaceMouse attached on the system can be read.The input values ranges between approx. -1 and 1 and can be scaled by the vector <b>gain</b>.</p>
<h4><font color=\"#008000\">Note for Linux</font></h4>
<p>Using the SpaceMouse in Linux is possible, but requires that the Linux drivers offered by 3Dconnexion are installed and active (<a href=\"http://www.3dconnexion.com/\">http://www.3dconnexion.com/</a>).</p>
</html>"));
  end SpaceMouseInput;

  block KeyboardInput
    "Keyboard input implementation for interactive simulations"

    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    parameter Real sampleTime = 0.01 "sample time for input update";
    Modelica.Blocks.Interfaces.BooleanOutput keyUp
      annotation (Placement(transformation(extent={{100,50},{120,70}})));
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
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput keySpace
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  protected
    Integer KeyCode[10](each start=0, each fixed=true);
  equation
    when Clock() then
      KeyCode = Modelica_DeviceDrivers.InputDevices.Keyboard.getData(); //getting the KeyCode
    end when;
    keyUp = if (KeyCode[1]==1) then true else false;
    keyDown = if (KeyCode[2]==1) then true else false;
    keyRight = if (KeyCode[3]==1) then true else false;
    keyLeft = if (KeyCode[4]==1) then true else false;
    keyReturn = if (KeyCode[5]==1) then true else false;
    keySpace = if (KeyCode[6]==1) then true else false;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
              preferredView="info",Documentation(info="<html>
<p>This block reads data from the keyboard. The arrow keys, space and return are monitored. Note, that keystrokes will not be captured and the focused window will process them.</p>
</html>"));
  end KeyboardInput;

  package Types
    extends Modelica.Icons.Package;
    type keyCodes =  Modelica.Icons.TypeString
    annotation (
      preferedView="text",
      Evaluate=true,
      choices(
        choice="0" "0",
        choice="1" "1",
        choice="2" "2",
        choice="3" "3",
        choice="4" "4",
        choice="5" "5",
        choice="6" "6",
        choice="7" "7",
        choice="8" "8",
        choice="9" "9",
        choice="A" "A",
        choice="B" "B",
        choice="C" "C",
        choice="D" "D",
        choice="E" "E",
        choice="F" "F",
        choice="G" "G",
        choice="H" "H",
        choice="I" "I",
        choice="J" "J",
        choice="K" "K",
        choice="L" "L",
        choice="M" "M",
        choice="N" "N",
        choice="O" "O",
        choice="P" "P",
        choice="Q" "Q",
        choice="R" "R",
        choice="S" "S",
        choice="T" "T",
        choice="U" "U",
        choice="V" "V",
        choice="W" "W",
        choice="X" "X",
        choice="Y" "Y",
        choice="Z" "Z",
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
        choice="Num0" "Num0",
        choice="Num1" "Num1",
        choice="Num2" "Num2",
        choice="Num3" "Num3",
        choice="Num4" "Num4",
        choice="Num5" "Num5",
        choice="Num6" "Num6",
        choice="Num7" "Num7",
        choice="Num8" "Num8",
        choice="Num9" "Num9",
        choice="Add" "Add",
        choice="Sub" "Sub",
        choice="Mult" "Mult",
        choice="Div" "Div",
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
