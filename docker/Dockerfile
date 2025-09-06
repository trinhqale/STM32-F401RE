# docker/Dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-lc"]

RUN apt-get update && apt-get install -y \
    ca-certificates curl unzip tar \
    build-essential git make cmake \
    # CubeProgrammer runtime deps:
    libglib2.0-0 libusb-1.0-0 libpcsclite1 \
    libx11-6 libxext6 libxrender1 libxtst6 libxi6 \
    libfontconfig1 libfreetype6 \
 && rm -rf /var/lib/apt/lists/*



# 1) Copy the ZIP you have, e.g. st-stm32cubeclt_1.19.0_..._amd64.sh.zip
COPY st-stm32cubeclt_*.sh.zip /tmp/stm32clt.zip

# 2) Unzip -> find the self-extracting .sh -> extract (noexec) -> untar payload to /opt/stm32cubeclt
RUN set -euo pipefail; \
    unzip -q /tmp/stm32clt.zip -d /tmp/stm32clt_zip; \
    shopt -s nullglob; \
    shfiles=(/tmp/stm32clt_zip/*.sh); \
    if (( ${#shfiles[@]} != 1 )); then echo "Expected 1 .sh inside ZIP; found ${#shfiles[@]}"; ls -lah /tmp/stm32clt_zip; exit 1; fi; \
    chmod +x "${shfiles[0]}"; \
    "${shfiles[0]}" --noexec --target /tmp/stm32clt_extracted; \
    # Find the inner tarball
    tgz=(/tmp/stm32clt_extracted/*.tar.gz); \
    if (( ${#tgz[@]} != 1 )); then echo "Expected 1 tar.gz after extraction; found ${#tgz[@]}"; ls -lah /tmp/stm32clt_extracted; exit 1; fi; \
    mkdir -p /opt/stm32cubeclt; \
    # Some archives have a top-level directory; strip it if present
    tar -xzf "${tgz[0]}" -C /opt/stm32cubeclt --strip-components=1 || \
      tar -xzf "${tgz[0]}" -C /opt/stm32cubeclt; \
    # Clean up
    rm -rf /tmp/stm32clt.zip /tmp/stm32clt_zip /tmp/stm32clt_extracted

# 3) Put tools on PATH
ENV PATH="/opt/stm32cubeclt/GNU-tools-for-STM32/bin:/opt/stm32cubeclt/STM32CubeProgrammer/bin:/opt/stm32cubeclt/bin:${PATH}"

# 4) Optional sanity check (will fail build if paths are wrong)
RUN arm-none-eabi-gcc --version || (echo 'arm-none-eabi-gcc not found'; ls -lah /opt/stm32cubeclt; false) && \
    STM32_Programmer_CLI --version || (echo 'STM32_Programmer_CLI not found'; ls -lah /opt/stm32cubeclt; false)

WORKDIR /workspace
