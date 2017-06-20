within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
package Constants
extends .Modelica.Icons.Package;
import Modelica.SIunits;
constant SIunits.Frequency cpuFrequency[Types.Platform] = {0, 8e6, 16e6} "Default frequency on the given microcontroller. Returns 0 if unknown.";
constant SIunits.Frequency prescalerTimer[Types.Platform, Types.TimerSelect, Types.TimerPrescaler] =
  {
    timerUnknown,
    timerATmega16,
    timerATmega328P
  } "Lookup-table from pre-scaler enumeration (and platform/timer tuple) to the corresponding value (0 means this prescaler is not available on the MCU)";
constant SIunits.Frequency prescalerAnalog[Types.AnalogPrescaler] = {2, 4, 8, 16, 32, 64, 128} "Lookup-table from analog pre-scaler enumeration to the corresponding value";
constant SIunits.Frequency minADCFrequency[Types.Platform] = {0, 50e3, 50e3} "Minimum recommended frequency of the ADC";
constant SIunits.Frequency maxADCFrequency[Types.Platform] = {0, 200e3, 200e3} "Maximum recommended frequency of the ADC";
constant Integer adcResolution[Types.Platform] = {0, 10, 10} "Bits of resolution in the ADC";
constant String spaces_16="                " "16 spaces";
protected
  constant SIunits.Frequency timerDisabled[Types.TimerPrescaler] = {0, 0, 0, 0, 0, 0, 0};
  constant SIunits.Frequency timerUnknown[Types.TimerSelect, Types.TimerPrescaler] = {timerDisabled, timerDisabled, timerDisabled};
  constant SIunits.Frequency[Types.TimerSelect, Types.TimerPrescaler] timerATmega328P = {timerWithEdge, timerWithEdge, timerNoEdge}, timerATmega16=timerATmega328P;
  constant SIunits.Frequency timerNoEdge[Types.TimerPrescaler] = {1, 8, 32, 64, 128, 256, 1024};
  constant SIunits.Frequency timerWithEdge[Types.TimerPrescaler] = {1, 8, 0, 64, 0, 256, 1024};
end Constants;
