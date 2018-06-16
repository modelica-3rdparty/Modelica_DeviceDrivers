###############################################################################
# (LINUX) Makefile for building Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.Arduino.UNO.Blink
#
# Flash example:
#   make flash
#
###############################################################################

include ../../../../Makefile.inc

MCU = atmega328p

CFLAGS += -mmcu=$(MCU)

LDFLAGS += -mmcu=$(MCU)

OBJ=Blink_main.o \

.PHONY: clean flash

all: Blink_main.elf Blink_main.hex

Blink_main.c: Blink.mos
	omc --simCodeTarget=ExperimentalEmbeddedC Blink.mos

Blink_main.o: Blink_main.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

Blink_main.elf: $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

Blink_main.hex: Blink_main.elf
	avr-objcopy -O ihex -R .eeprom $< $@

# flash to target. Adapt settings as needed
flash: Blink_main.hex
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:$<

clean:
	@$(RM) Blink_main.o
	@$(RM) Blink_main.*
