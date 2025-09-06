# project.mk — H743
override TARGET    = MyApp-H743
override C_DEFS    = -DUSE_HAL_DRIVER -DSTM32H743xx
override CPU       = -mcpu=cortex-m7
override FPU       = -mfv5-d16
override FLOAT-ABI = -mfloat-abi=hard
override LDSCRIPT  = toolchain/STM32H743_FLASH.ld
override C_INCLUDES = \
  -ICore/Inc \
  -IDrivers/STM32H7xx_HAL_Driver/Inc \
  -IDrivers/STM32H7xx_HAL_Driver/Inc/Legacy \
  -IDrivers/CMSIS/Device/ST/STM32H7xx/Include \
  -IDrivers/CMSIS/Include
# Match your startup file:
override ASM_SOURCES = startup_stm32h743xx.s
