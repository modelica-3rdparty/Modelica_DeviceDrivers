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

end Types;
