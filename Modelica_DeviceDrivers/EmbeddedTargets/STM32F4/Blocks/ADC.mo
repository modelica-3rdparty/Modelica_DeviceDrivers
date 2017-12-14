within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks;

model ADC
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
  import Modelica_DeviceDrivers.EmbeddedTargets.FTM32F4.Types;
  import Modelica.SIunits;
  outer Microcontroller mcu;
  /* constant Types.ADCChannel channel annotation(
      Dialog(enable = true, tab = "General", group = "Constants"));*/
  Modelica.Blocks.Interfaces.IntegerOutput pb0 annotation(
    Placement(visible = true, transformation(origin = {112, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput pb1 annotation(
    Placement(visible = true, transformation(origin = {112, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {112, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Functions.Analog.InitADC hadc = Functions.Analog.InitADC(mcu.hal);
equation
  pb0 = Functions.Analog.read(hadc, Types.ADCChannel.CHANNEL1);
  pb1 = Functions.Analog.read(hadc, Types.ADCChannel.CHANNEL2);
  annotation(
    Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "Analog %channel", fontName = "Arial")}));
  annotation(
    defaultComponentName = "adc",
    Documentation(info = "<html>
<h1>ADC</h1>

<p>The AVR ADC (analog-to-digital converter) takes as parameters a selection of which voltage reference input to use (<em>voltageReferenceSelect</em>), what voltage this reference voltage has (<em>voltageReference</em>), the <em>analogPort</em> (which analog input to convert to a digital value) and which prescaler to use (<em>prescaler</em>, might be automatically chosen if the used AVR platform had known constants for this). The output is continuously read (at each time step), producing a voltage between 0 and 
<em>voltageReference</em>.</p>
</html>"),
    Icon(graphics = {Text(extent = {{-95, -95}, {95, 95}}, textString = "ADC %analogPort\n0..%voltageReference [V]", fontName = "Arial")}));
end ADC;