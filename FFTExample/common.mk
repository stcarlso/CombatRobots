# Universal C Makefile for MCU targets
# Top-level template file to configure build

-include stlink.mk

# Makefile for STM32F4 series via STM32F4 Discovery board
DEVICE=STM32F4
# Libraries to include in the link (use -L and -l) e.g. -lm, -lmyLib
LIBRARIES=-L$(ROOT) -lSTMMath -lm
# Prefix for ARM tools (must be on the path)
MCUPREFIX=arm-none-eabi-
# Flags for the assembler
MCUAFLAGS=
# Use Cortex-M4 with FPU and Thumb instruction set
MCUCFLAGS=-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard
# Flags for the linker
MCULFLAGS=-nostartfiles -Wl,-T -Xlinker stm32_flash.ld -static -Wl,-u,Reset_Handler -Wl,--defsym=malloc_getpagesize_P=0x1000
# Prepares for compiling
MCUPREPARE=$(OBJCOPY) $(OUT) -O binary $(BINDIR)/output.bin
# Advanced sizing flags
SIZEFLAGS=
# Uploads program using flash utility
UPLOAD=cd $(BINDIR) && $(STLINK)/ST-LINK_CLI.exe -c SWD -P output.bin 0x08000000 -V -Rst

# Advanced options
ASMEXT=s
CEXT=c
CPPEXT=cpp
HEXT=h
INCLUDE=-I$(ROOT)/include -I$(ROOT)/stm
OUTNAME=output.elf

# Flags for programs
AFLAGS:=$(MCUCFLAGS) $(MCUAFLAGS)
ARFLAGS:=$(MCUCFLAGS)
CCFLAGS:=-c -Wall -Wno-strict-aliasing $(MCUCFLAGS) -Os -ffunction-sections \
-DARM_MATH_CM4 -DSTM32F303xE -Werror=implicit-function-declaration
CFLAGS:=$(CCFLAGS) -std=gnu99
CPPFLAGS:=$(CCFLAGS) -fno-exceptions -fno-rtti -felide-constructors
LDFLAGS:=-Wall $(MCUCFLAGS) $(MCULFLAGS) -Wl,--gc-sections

# Tools used in program
AR:=$(MCUPREFIX)ar
AS:=$(MCUPREFIX)as
CC:=$(MCUPREFIX)gcc
CPPCC:=$(MCUPREFIX)g++
OBJCOPY:=$(MCUPREFIX)objcopy
