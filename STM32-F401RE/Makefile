##########################################################################################################################
# CubeMX-generated base, lightly generalized for reusability
##########################################################################################################################

# Allow per-project overrides without editing this file
-include project.mk

######################################
# target
######################################
TARGET = STM32-F401RE

######################################
# building variables
######################################
DEBUG ?= 1
OPT   ?= -Og

#######################################
# paths
#######################################
BUILD_DIR    = build
ARTIFACT_DIR ?= out
ELF  := $(ARTIFACT_DIR)/$(TARGET).elf
BINf := $(ARTIFACT_DIR)/$(TARGET).bin
HEXf := $(ARTIFACT_DIR)/$(TARGET).hex
MAP  := $(ARTIFACT_DIR)/$(TARGET).map

#######################################
# sources
#######################################
C_SOURCES =  \
Core/Src/main.c \
Core/Src/stm32f4xx_it.c \
Core/Src/stm32f4xx_hal_msp.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c \
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c \
Core/Src/system_stm32f4xx.c \
Core/Src/sysmem.c \
Core/Src/syscalls.c

ASM_SOURCES = startup_stm32f401xe.s

#######################################
# toolchain
#######################################
PREFIX = arm-none-eabi-
ifdef GCC_PATH
  CC = $(GCC_PATH)/$(PREFIX)gcc
  AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
  CP = $(GCC_PATH)/$(PREFIX)objcopy
  SZ = $(GCC_PATH)/$(PREFIX)size
else
  CC = $(PREFIX)gcc
  AS = $(PREFIX)gcc -x assembler-with-cpp
  CP = $(PREFIX)objcopy
  SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# flags
#######################################
CPU = -mcpu=cortex-m4
FPU = -mfpu=fpv4-sp-d16
FLOAT_ABI = -mfloat-abi=hard
MCU = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)

C_DEFS = -DUSE_HAL_DRIVER -DSTM32F401xE

C_INCLUDES = \
-ICore/Inc \
-IDrivers/STM32F4xx_HAL_Driver/Inc \
-IDrivers/STM32F4xx_HAL_Driver/Inc/Legacy \
-IDrivers/CMSIS/Device/ST/STM32F4xx/Include \
-IDrivers/CMSIS/Include

ASFLAGS = $(MCU) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
ifeq ($(DEBUG),1)
  CFLAGS += -g -gdwarf-2
endif
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#######################################
# link
#######################################
LDSCRIPT = STM32F401XX_FLASH.ld
LIBS  = -lc -lm -lnosys
LIBDIR =
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) \
          -Wl,-Map=$(MAP),--cref -Wl,--gc-sections

#######################################
# objects
#######################################
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

#######################################
# default target (elf + bin; hex optional)
#######################################
MAKE_HEX ?= 0
ALL_TARGETS := $(ELF) $(BINf)
ifeq ($(MAKE_HEX),1)
  ALL_TARGETS += $(HEXf)
endif
all: $(ALL_TARGETS)

#######################################
# rules
#######################################
.PHONY: all clean help

$(BUILD_DIR) $(ARTIFACT_DIR):
	mkdir -p $@

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) $< -o $@

$(ELF): $(OBJECTS) | $(ARTIFACT_DIR)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BINf): $(ELF) | $(ARTIFACT_DIR)
	$(BIN) $< $@

$(HEXf): $(ELF) | $(ARTIFACT_DIR)
	$(HEX) $< $@

clean:
	-rm -rf $(BUILD_DIR) $(ARTIFACT_DIR)

help:
	@echo "make [DEBUG=0|1] [ARTIFACT_DIR=out] [MAKE_HEX=1]"
	@echo "Outputs: $(ARTIFACT_DIR)/$(TARGET).elf + .bin (and .hex if MAKE_HEX=1)"
