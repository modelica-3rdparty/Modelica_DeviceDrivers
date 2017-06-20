#
#	File: Makefile.inc
#
#	Description: Include file for all Makefiles for STM32F4 Boards"
#
#	Author: Lutz Berger (Berger IT-COSMOS GmbH)
#
#	Date: 14.06.2017
#
CC=/usr/bin/arm-none-eabi-gcc
INC_DIR=$$STM23F4CUBEROOT/Drivers/CMSIS/Device/ST/STM32F4xx/Include \
        $$STM23F4CUBEROOT/Drivers/CMSIS/Include \
	$$STM23F4CUBEROOT/Drivers/STM32F4xx_HAL_Driver/Inc \
	../../../../../Resources/Include /usr/include/omc/c
	
CFLAGS= -c -mthumb -mcpu=cortex-m4 -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -std=gnu11 -DUSE_HAL_DRIVER \
	       -Os -ffunction-sections -fdata-sections -fstack-usage -Wall -Wno-unused-but-set-variable \
	       -Wno-unused-variable -specs=nano.specs

ASFLAGS=-c -mthumb -mcpu=cortex-m4 -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -g -Wa,--no-warn \
		-x assembler-with-cpp -specs=nano.specs

LDFLAGS=-mcpu=cortex-m4 -mlittle-endian -mthumb -Wl,--gc-sections --specs=nosys.specs