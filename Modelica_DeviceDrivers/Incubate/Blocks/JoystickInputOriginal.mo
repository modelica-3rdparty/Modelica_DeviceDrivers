within Modelica_DeviceDrivers.Incubate.Blocks;
block JoystickInputOriginal
  "Original block without OM related work-around (won't instantiate in 2017-05-12 OM). Joystick input implementation for interactive simulations"
  extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
  import Modelica_DeviceDrivers.InputDevices.GameController;
  parameter Modelica.Units.SI.Period sampleTime=0.01
    "sample time for input update";
  parameter Real gain[6] = ones(6) "gain of axis output";
  parameter Integer ID= 0
    "ID number of the joystick (0 = first joystick attached to the system)";
  Modelica.Blocks.Interfaces.RealOutput axes[6](start=-ones(6), each fixed=false)
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  discrete Modelica.Blocks.Interfaces.RealOutput pOV(start=0, fixed=true) annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  discrete Modelica.Blocks.Interfaces.IntegerOutput buttons[32](start=zeros(32), each fixed=true)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
protected
  GameController joystick = GameController(ID);
  discrete Real AxesRaw[6](start=zeros(6), each fixed=true) "unscaled joystick input";
equation
  when sample(0,sampleTime) then
    (AxesRaw,buttons,pOV) = Modelica_DeviceDrivers.InputDevices.GameController_.getData(joystick);
  end when;
  axes = (AxesRaw .- 32768)/32768 ./gain;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Bitmap(extent={{-86,-88},{88,88}},
            fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/joystick.png"), Text(extent={
              {-150,140},{150,100}}, textString="%name")}),
              preferredView="info",Documentation(info="<html> This block reads data from the joystick ID (0 = first joystick appearing in windows control panel).
                                Multiple blocks can be used in order to retrieve data from more than one joysticks.
                                Up to six axes and 32 buttons are supported. The input values ranges between -1 and 1 and can be scaled by the
                                vector <b>gain</b>. Via the parameter <b>sampleTime</b> the input sampling rate is chosen.</html>"));
end JoystickInputOriginal;
