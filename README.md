# STM32-F401RE Template

This repository provides a starting point for STM32 projects targeting the **STM32F401RE**.  
It uses a `Makefile`-based build system with optional **Docker** support for a reproducible toolchain on Linux, macOS, and Windows.

---

## Features
- STM32F401RE bare-metal firmware template
- Build with local **arm-none-eabi-gcc** or Docker
- `project.mk` overrides to switch MCU/board easily (not yet tested)
- Provide ready to use binaries to flash on microcontroller 
- Flash microcontroller through the host PC from docker (not yet implemented)
- Compatible with STM32CubeMX (regenerate into `STM32-F401RE/` folder)
- Clean `.gitignore` and `.gitattributes` setup for cross-platform use

---

## Requirements
- [ARM GCC toolchain](https://developer.arm.com/downloads/-/gnu-rm) (if building locally)  
- [Docker](https://www.docker.com/) (if using container builds)  
- [stlink](https://github.com/stlink-org/stlink) or [OpenOCD](http://openocd.org/) (for flashing/debugging)

---

## Build

### Local
```bash
make

```

## Docker

```bash
docker build -t stm32-builder ./docker

docker run --rm -v "$PWD:/work" -w /work stm32-builder make
```

## Project Configuration (not yet tested, use with caution)

Customize settings in project.mk. Example:

```
TARGET        := STM32-F401RE
MCU_DEFINE    := STM32F401xE
CPU_FLAGS     := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard
LD_SCRIPT     := STM32-F401RE/STM32F401RETX_FLASH.ld
```
When switching MCUs:

Update MCU_DEFINE, CPU_FLAGS, and linker script

Ensure the correct startup file and HAL/CMSIS headers are included


## Notes

CubeMX can safely regenerate code into STM32-F401RE/ without breaking Git history
Line endings normalized to LF for cross-platform safety:
```
git add --renormalize .
git commit -m "Normalize line endings"
```

## GitHub Actions CI (Optional)

You can add a workflow to build automatically on pushes:
```
name: firmware-ci
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build toolchain image
        run: docker build -t stm32-builder ./docker
      - name: Build firmware
        run: docker run --rm -v "$PWD:/work" -w /work stm32-builder make
      - name: Publish artifacts
        uses: actions/upload-artifact@v4
        with:
          name: firmware
          path: build/
```
