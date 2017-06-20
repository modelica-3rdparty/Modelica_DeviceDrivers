within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;
package Utilities
extends .Modelica.Icons.UtilitiesPackage;

function getClockCounterValue "Function to calculate a clock counter value for PWM or interrupts at a specific frequency"
  extends .Modelica.Icons.Function;
  import Modelica.SIunits;
  input SIunits.Frequency prescaledFrequency, desiredFrequency;
  input Real allowedError;
  output Integer i;
protected
  String msg = "Could not get a good 8-bit counter value for the prescaled ("+String(prescaledFrequency)+"Hz) and desired ("+String(desiredFrequency)+"Hz) frequencies.";
algorithm
  i := integer(prescaledFrequency / desiredFrequency);
  assert(i > 1, msg);
  if i <= 256 then
    assert((prescaledFrequency/i-desiredFrequency)/desiredFrequency < allowedError, "Could not get a good 8-bit counter value for the prescaled ("+String(prescaledFrequency)+"Hz) and desired ("+String(desiredFrequency)+"Hz) frequencies.");
    i := i-1;
    return;
  end if;
  for j in 256:-1:3 loop
    if mod(i,j)==0 then
      i := j-1;
      return;
    end if;
  end for;
end getClockCounterValue;

function reasonableClockSelect "Function to calculate a reasonable prescaler for PWM or interrupts at a specific frequency"
  extends .Modelica.Icons.Function;
  import Modelica.SIunits;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  input SIunits.Frequency cpu, desired;
  input Real allowedError;
  input SIunits.Frequency prescalerConstants[Types.TimerPrescaler];
  output Types.TimerPrescaler prescaler;
protected
  Real n;

  function isReasonableClock
    extends .Modelica.Icons.Function;
    input Real cpu, desired, prescaler, allowedError;
    output Boolean b=true;
  protected
    Integer n = integer(cpu / (prescaler * desired));
    Real error;
    Integer factors[:];
  algorithm
    if n < 2 then
      b := false;
    elseif n > 256 then
      if n > 65536 then
        b := false;
        return;
      end if;
      factors := .Modelica_DeviceDrivers.Utilities.Functions.primeDecomposition(n);
      if size(factors,1) >= 3 then
        b := not (factors[1]==2 and factors[2]==2 and factors[3]==2);
      end if;
    else
      error := abs((cpu/prescaler/n)-desired)/desired;
      b := error < allowedError;
    end if;
  end isReasonableClock;

algorithm
  n := integer(cpu / desired);
  for p in Types.TimerPrescaler loop
    if if prescalerConstants[p]>0 then isReasonableClock(cpu, desired, prescalerConstants[p], allowedError) else false then
      prescaler := p;
      return;
    end if;
  end for;
  assert(false, "Could not select a reasonable pre-scaler for CPU-frequency " + String(cpu) + "Hz trying to perform ticks @" + String(desired) + "Hz. Try changing the desired frequency or manually setting the frequency.");
end reasonableClockSelect;

function getAnalogPrescaler
  extends .Modelica.Icons.Function;
  import Modelica.SIunits;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
  input SIunits.Frequency cpuFrequency, minFrequency, maxFrequency;
  output STM32F4.Types.AnalogPrescaler prescaler;
protected
  Real tmp;
algorithm
  for p in STM32F4.Types.AnalogPrescaler loop
    tmp := cpuFrequency / STM32F4.Constants.prescalerAnalog[p];
    if tmp >= minFrequency and tmp <= maxFrequency then
      prescaler := p;
      return;
    end if;
  end for;
  assert(false, "Could not find an analog prescaler that puts the CPU frequency " + String(cpuFrequency) + " within the bounds of " + String(minFrequency) + " and " + String(maxFrequency));
end getAnalogPrescaler;

end Utilities;
