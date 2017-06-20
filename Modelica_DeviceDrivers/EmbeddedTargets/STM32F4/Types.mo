within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
package Types
extends .Modelica.Icons.TypesPackage;
type Platform = enumeration(
  unknown "Unknown STM32F4 Board",
  STM32DISC "STM32F4 Discovery",
  ARMCR4 "STM32F4 ..." //TODO add pattforms
) "The microcontroller platform used";





type Port = enumeration(
  A "PORTA",
  B "PORTB",
  C "PORTC",
  D "PORTD"
) "Digital port";
type Pin = enumeration(
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7'
) "Digital pin";
type AnalogPort = enumeration(
  A0,
  A1,
  A2,
  A3,
  A4,
  A5,
  A6,
  A7
) "Analog port";
type TimerPrescaler = enumeration(
  SystemClock "No prescaler",
  '1/8',
  '1/32' "No always available",
  '1/64',
  '1/128' "No always available",
  '1/256',
  '1/1024'
) "Prescaler for the system clock";
type TimerSelect = enumeration(
  Timer0 "Usually an 8-bit timer",
  Timer1 "Usually a 16-bit timer",
  Timer2 "Usually an 8-bit timer"
) "Selecting the timer on the chip. Some may have multiple counters associated with it (see TimerNumber)";
type TimerNumber = enumeration(
  A "Use this when the timer only has 1 clock associated with it",
  B
) "Combine with TimerSelect to get for example Timer1B";
type AnalogPrescaler = enumeration(
  '1/2',
  '1/4',
  '1/8',
  '1/16',
  '1/32',
  '1/64',
  '1/128'
) "The analog prescaler. System clock divided by the prescaler is used by the analog-digital converter. A value of 50-200 kHz is usually good (but check the data sheet).";
type VRefSelect = enumeration(
  AREF "AREF used as VRef and internal VRef is turned off",
  AVCC "AVCC with external capacitor at the AREF pin is used as VRef (5V on Arduino)",
  Internal2 "This is a reserved setting in most ARMs. On ATmega1280, it is 1.1 internal reference voltage",
  Internal "Internal reference voltage (1.1V (ATmega168/328) or 2.56V on (ATmega8, ATmega1280))"
) "Analog reference voltage";
end Types;
