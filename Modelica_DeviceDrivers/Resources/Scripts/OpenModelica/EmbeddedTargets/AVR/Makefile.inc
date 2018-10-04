###############################################################################
# (LINUX) Include Makefile for all AVR boards
###############################################################################

CC=avr-gcc

CFLAGS = -Os -std=c11 -ffunction-sections -fdata-sections -DF_CPU=16000000UL

LDFLAGS = -Wl,--gc-sections

## Include Directories
INCLUDES = -I"/usr/include/omc/c" -I"../../../../../../../../Include"
