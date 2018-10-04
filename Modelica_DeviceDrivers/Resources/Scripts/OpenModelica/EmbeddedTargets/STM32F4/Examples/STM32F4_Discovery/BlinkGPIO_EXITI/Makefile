#
#	File: Makefile
#
#	Description: Makefile for building Blink Openmodelica Blink example "Blink_main.elf"
#
#	Author: Lutz Berger (Berger IT-COSMOS GmbH)
#
#	Date: 14.06.2017
#
#	Required:
#		- http://www.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32cube-embedded-software/stm32cubef4.html, HAL interface for STM32F4 boards
#		- arm-none-eabi-gcc
#		- arm-none-eabi-gdb
#		- arm-none-eabi-binutils
#		- openocd -- install above packages with "aptitude install ..."
#		- set the environment variable "STM23F4CUBEROOT" to the root of the installed STM32F4CUBE directory
#
#	Debugging the example:
#		arm-none-eabi-gdb
#		target remote localhost:3333
#		monitor reset halt
#		file Blink_main.elf
#		load
#		monitor reset
#		continue
#
#	Running with OpenOcd in current directory:
#		openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg
#		run in new terminal "telnet localhost 4444"
#		> reset halt
#		> flash write_image erase Blink_main.hex
#		> reset run
#

include ../../../Makefile.inc

3RDPARTY_BLINK_DIR=../../../../../../../thirdParty/STM/STM32F4/Examples/STM32F4_Discovery/Blink

MODELICA_STM32F4_DISCOVERY_EXAMPLE_DIR=../../../../../../../../EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery

INC_DIR+= $$STM23F4CUBEROOT/Drivers/BSP/STM32F4-Discovery $(3RDPARTY_BLINK_DIR)/Inc

CFLAGS+= -g -DSTM32F407xx -DUSE_STM32F4_DISCO $(addprefix -I,$(INC_DIR))


LDFLAGS+=-DSTM32F407xx -T$(3RDPARTY_BLINK_DIR)/TrueSTUDIO/STM32F4-Discovery/STM32F407VG_FLASH.ld


.PHONY: checkenv clean cleanall

all: Debug/BSP/STM32F4-Discovery Debug/Drivers/STM32F4xx_HAL_Driver \
	Debug/Example/User Debug/Example/TrueSTUDIO BlinkGPIO_EXTI_main.hex
checkenv:
	@echo
ifndef STM23F4CUBEROOT
	@echo "STM23F4CUBEROOT not defined"
endif

Debug/BSP/STM32F4-Discovery: checkenv
	@mkdir -p $@

Debug/Drivers/STM32F4xx_HAL_Driver: checkenv
	@mkdir -p $@

Debug/Example/User:
	@mkdir -p $@

Debug/Example/TrueSTUDIO:
	@mkdir -p $@

BlinkGPIO_EXTI_main.c: $(MODELICA_STM32F4_DISCOVERY_EXAMPLE_DIR)/BlinkGPIO_EXTI.mo blinkGPIO_EXTI.mos
	omc --simCodeTarget=ExperimentalEmbeddedC blinkGPIO_EXTI.mos
	if [ -e "$@" ]; then cat $@ | sed 's/#include <stdio.h>/#include <stdio.h>\n#include <stdarg.h>/' > tmp.c; \
	mv tmp.c $@;fi #TODO to be fixed in omc

OBJ=Debug/Example/BlinkGPIO_EXTI_main.o \
    Debug/Example/ext_callback.o \
    Debug/BSP/STM32F4-Discovery/stm32f4_discovery.o \
    Debug/Example/User/system_stm32f4xx.o \
    Debug/Example/User/stm32f4xx_it.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_cortex.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_dma.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_flash.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_flash_ex.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_gpio.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_i2c.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_i2c_ex.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_pwr.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_pwr_ex.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_rcc.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_rcc_ex.o \
    Debug/Drivers/STM32F4xx_HAL_Driver/stm32f4xx_hal_spi.o \
    Debug/Example/TrueSTUDIO/startup_stm32f407xx.o

Debug/BSP/STM32F4-Discovery/%.o: $(STM23F4CUBEROOT)/Drivers/BSP/STM32F4-Discovery/%.c
	$(CC) $(CFLAGS) $< -o $@

Debug/Example/User/%.o: $(3RDPARTY_BLINK_DIR)/Src/%.c
	$(CC) $(CFLAGS) $< -o $@

Debug/Example/%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

Debug/Drivers/STM32F4xx_HAL_Driver/%.o: $(STM23F4CUBEROOT)/Drivers/STM32F4xx_HAL_Driver/Src/%.c
	$(CC) $(CFLAGS) $< -o $@

Debug/Example/TrueSTUDIO/%.o: $(3RDPARTY_BLINK_DIR)/TrueSTUDIO/%.s
	$(CC) $(ASFLAGS) $< -o $@

BlinkGPIO_EXTI_main.elf: $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

BlinkGPIO_EXTI_main.hex: BlinkGPIO_EXTI_main.elf
	arm-none-eabi-objcopy -Oihex $< $@

clean:
	@$(RM) Debug/Example/BlinkGPIO_EXTI_main.o
	@$(RM) BlinkGPIO_EXTI_main.*

cleanall: clean
	@$(RM) -r Debug

