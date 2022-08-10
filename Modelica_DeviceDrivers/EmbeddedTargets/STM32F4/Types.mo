within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4;
package Types
extends .Modelica.Icons.TypesPackage;
type Platform = enumeration(
      unknown
          "Unknown STM32F4 Board",
      STM32F4DISC
              "STM32F4 Discovery",
      ARMCR4
         "STM32F4 ...")
  "The microcontroller platform used";
                       //TODO add platforms



type LED = enumeration(
      LED3,
      LED4,
      LED5,
      LED6)
  "LED";
type Port = enumeration(
      A
    "PORTA",
      B
    "PORTB",
      C
    "PORTC",
      D
    "PORTD",
      E
    "PORTE",
      F
    "PORTF",
      G
    "PORTG",
      H
    "PORTH",
      I
    "PORTI")
  "Digital port";
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
      ALL)
  "Digital pin";
type Mode = enumeration(
      RISING,
      FALLING,
      RISING_FALLING)
  "Interrupt mode";
type Prio = Integer(min=0, max=15);
type Clock = enumeration(
      HSI
      "HSI clock",
      HSE
      "HSE clock",
      HSI_PLL
          "HSI with PLL",
      HSE_PLL
          "HSE with PLL")
  "Clock";
type PLLM = Integer(min=2, max=63) "Division factor for main PLL and audio input clock";
type PLLN = Integer(min=50, max=432) "Main PLL multiplication factor for VCO";
type PLLP = enumeration(
      DIV_2,
      DIV_4,
      DIV_6,
      DIV_8)
  "Main PLL devision factor for system clock";
type PLLQ = Integer(min=2, max=15) "Main PLL devision factor for USB OTG FS, SDIO and random number generator clocks";
type AHBPre = enumeration(
      DIV_1,
      DIV_2,
      DIV_4,
      DIV_8,
      DIV_16,
      DIV_64,
      DIV_128,
      DIV_256,
      DIV_512)
  "AHB Prescaler";

type APBPre = enumeration(
      DIV_1,
      DIV_2,
      DIV_4,
      DIV_16)
  "APB prescaler";
type PWRRegulatorVoltage = enumeration(
      SCALE1
         "Max fHCLK frequency 168 MHz with overdrive 180 Hz",
      SCALE2
         "Max fHCLK frequency 144 MHz with overdrive 168 Hz",
      SCALE3
         "Max fKCLK frequency 120 MHz")
  "Power Regulator Voltage Scale";


end Types;
