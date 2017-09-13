within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Examples.STM32F4_Discovery;
model Blink
  extends .Modelica.Icons.Example;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  inner Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks.Microcontroller mcu(desiredPeriod = 0.01, platform = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Platform.STM32F4DISC)
  annotation(Placement(visible = true, transformation(origin={-70,70},    extent={{-10,-10},
            {10,10}},                                                                                      rotation = 0)));
 // STM32F4.Functions.HAL.Init HALinit = STM32F4.Functions.HAL.Init();
  Blocks.Led led(led = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED.LED3)  annotation(Placement(visible = true, transformation(origin={-36,38},  extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression boolExp(y=mod(time, 1) >= 0.5)
    annotation (Placement(visible=true, transformation(
        origin={-68,38},
        extent={{-12,-10},{12,10}},
        rotation=0)));
  Blocks.SynchronizeRealtime synchronizeRealtime(ahbPre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.AHBPre.DIV_1, apb1Pre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.APBPre.DIV_4, apb2Pre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.APBPre.DIV_2, clock = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Clock.HSE_PLL, overdrive = false, pllM = 8, pllN = 336, pllP = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.PLLP.DIV_2, pllQ = 7, preFlash = true, pwrRegVoltage = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.PWRRegulatorVoltage.SCALE1)  annotation (
    Placement(visible = true, transformation(origin={-36,70},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boolExp.y, led.u)
    annotation (Line(points={{-54.8,38},{-48,38}}, color={255,0,255}));
             /* synchronizeRealtime1.actualInterval is not legal in experiment annotation*/
  annotation (                                                                             Experiment(Interval = 0.01), Documentation(info = "<html>
<h1>Blink</h1>
<p>Blink is a very simple STM model, which simply toggles the built-in LED on the board on and off at the given frequency (this version blinks at a frequency given by the model using single precision floating point; it is also possible to simply flip the LED bit in each time step which gives a more accurate result). Use this model to see if your Modelica tool can export code for STM32F4 MCUs.</p>
<p>STM digital pin 12 on port D corresponds to digital pin D12 on the STM32F4-Discovery. The user LED's are accessed via convinient LED Block. If desired, you can connect an external LED to this PIN, with a suitable resistor in-between (perhaps 220&#8486;). Connect the other PIN on the LED to ground.</p>

</html>"));
end Blink;
