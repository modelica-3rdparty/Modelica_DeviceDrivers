within Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.SBHS;
model Controller
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput degC(final unit="degC") annotation(Placement(visible = true, transformation(origin = {-120, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setpoint(final unit="degC") annotation(Placement(visible = true, transformation(origin = {-120, -36}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput fan(start=0, fixed=true) annotation(Placement(visible = true, transformation(origin = {110, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Real fan_real;
  Integer fan_tmp;
  Real ierror(start=0, fixed=true) "Integrated error";
equation
  fan_real = max(30*(degC-setpoint-2*der(degC))+5*ierror,0);
  fan_tmp = integer(max(0,min(fan_real,190)));
  fan = if fan_tmp > 0 then fan_tmp+60 else 0;
  der(ierror) = if ierror > -4 then max(degC-setpoint, -2) else 0;
annotation(Icon(graphics={
    Text(origin = {-123, 81}, extent = {{-17, 11}, {17, -11}}, textString = "°C", fontName = "Arial"), Text(origin = {-122, -14}, extent = {{-20, 18}, {20, -18}}, textString = "Setpoint", fontName = "Arial"),
    Text(origin = {117, 23}, extent = {{-17, 7}, {17, -7}}, textString = "Fan", fontName = "Arial")}));
end Controller;
