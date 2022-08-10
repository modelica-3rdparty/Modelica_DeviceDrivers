within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Examples.STM32F4_Discovery;
model BlinkGPIO_EXTI
  extends .Modelica.Icons.Example;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  inner Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Blocks.Microcontroller mcu(desiredPeriod = 0.5, platform = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Platform.STM32F4DISC)
  annotation(Placement(visible = true, transformation(origin = {-67, 67}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Blocks.SynchronizeRealtime synchronizeRealtime1(ahbPre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.AHBPre.DIV_1, apb1Pre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.APBPre.DIV_4, apb2Pre = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.APBPre.DIV_2, clock = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Clock.HSE_PLL, overdrive = false, pllM = 8, pllN = 336, pllP = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.PLLP.DIV_2, pllQ = 7, preFlash = true, pwrRegVoltage = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.PWRRegulatorVoltage.SCALE1)  annotation (
    Placement(visible = true, transformation(origin = {18, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  /* synchronizeRealtime1.actualInterval is not legal in experiment annotation*/
  Blocks.ExtInt extInt1(mode = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Mode.FALLING, pin = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Pin.'0', port = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.Port.A, preemtPrio = 2, subPrio = 0)  annotation (
    Placement(visible = true, transformation(origin = {36, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Functions.Digital.InitLed p1 = Functions.Digital.InitLed(handle =  mcu.hal, led = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED.LED3);
  Functions.Digital.InitLed p2 = Functions.Digital.InitLed(handle =  mcu.hal, led = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED.LED4);
  Functions.Digital.InitLed p3 = Functions.Digital.InitLed(handle =  mcu.hal, led = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED.LED5);
  Functions.Digital.InitLed p4 = Functions.Digital.InitLed(handle =  mcu.hal, led = Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types.LED.LED6);
  annotation (                                                                             Experiment(Interval = 0.01), Documentation(info="<html>
<h4>BlinkGPIO_EXTI</h4>
<p>BlinkGPIO_EXTI is a model configuring interrupt on falling edge on GPIO Line 0. Since Modelica is not able to generate code for the <a href=\"modelica://Modelica_DeviceDrivers/Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery/BlinkGPIO_EXITI/ext_callback.c\">callback function</a>, the user has to edit code here manually. In the callback function all User LEDs (port D pin 12 - 15) are toggled. As a result, the LEDs are toggled when the blue user button is released. Use this model to see if your Modelica tool can export code for STM32F4 MCUs..</p>
<p>STM digital pins 12 - 15 on port D corresponds to digital pin D12 - D15 on the STM32F4-Discovery. If desired, you can connect an external LEDs to this PINs, with a suitable resistor in-between (perhaps 220&#8486;). Connect the other PIN on the LED to ground.</p>
</html>"));  /* synchronizeRealtime1.actualInterval is not legal in experiment annotation*/
end BlinkGPIO_EXTI;
