within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
package Types
extends .Modelica.Icons.TypesPackage;
type Platform = enumeration(
  unknown "Unknown STM32F4 Board",
  STM32F4DISC "STM32F4 Discovery",
  ARMCR4 "STM32F4 ..." //TODO add pattforms
) "The microcontroller platform used";



type LED = enumeration(
  LED3,
  LED4,
  LED5,
  LED6
) "LED";

type Port = enumeration(
  A "PORTA",
  B "PORTB",
  C "PORTC",
  D "PORTD",
  E "PORTE",
  F "PORTF",
  G "PORTG",
  H "PORTH",
  I "PORTI"
) "Digital port";

type Pin = enumeration(
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
   ALL  
) "Digital pin";

end Types;
