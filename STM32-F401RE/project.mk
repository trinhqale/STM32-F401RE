# project.mk — F401RE
override TARGET    = STM32-F401RE
override C_DEFS    = -DUSE_HAL_DRIVER -DSTM32F401xE
override CPU       = -mcpu=cortex-m4
override FPU       = -mfpu=fpv4-sp-d16
override FLOAT-ABI = -mfloat-abi=hard
override LDSCRIPT  = STM32F401XX_FLASH.ld
# HAL/CMSIS include dirs for F4:
override C_INCLUDES = \
  -ICore/Inc \
  -IDrivers/STM32F4xx_HAL_Driver/Inc \
  -IDrivers/STM32F4xx_HAL_Driver/Inc/Legacy \
  -IDrivers/CMSIS/Device/ST/STM32F4xx/Include \
  -IDrivers/CMSIS/Include
# If your startup filename differs:
# override ASM_SOURCES = startup_stm32f401xe.s
