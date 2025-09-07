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

# 1) Copy the ZIP (keep your wildcard). IMPORTANT: The ZIP must be inside the build context.
#    If you run `docker buildx build ... ./docker`, put the ZIP in the ./docker/ folder.
COPY ./st-stm32cubeclt_*.sh.zip /opt/stm32clt.zip
COPY . /workspace
RUN ls -alh /opt && test -s /opt/stm32clt.zip

# 2) Unzip -> find the self-extracting .sh -> extract (noexec) -> untar payload to /opt/stm32cubeclt
RUN set -euo pipefail; \
    unzip -q /opt/stm32clt.zip -d /opt/stm32clt_zip; \
    shopt -s nullglob; \
    shfiles=(/opt/stm32clt_zip/*.sh); \
    if (( ${#shfiles[@]} != 1 )); then echo "Expected 1 .sh inside ZIP; found ${#shfiles[@]}"; ls -lah /opt/stm32clt_zip; exit 1; fi; \
    chmod +x "${shfiles[0]}"; \
    "${shfiles[0]}" --noexec --target /opt/stm32clt_extracted; \
    tgz=(/opt/stm32clt_extracted/*.tar.gz); \
    if (( ${#tgz[@]} != 1 )); then echo "Expected 1 tar.gz after extraction; found ${#tgz[@]}"; ls -lah /opt/stm32clt_extracted; exit 1; fi; \
    mkdir -p /opt/stm32cubeclt; \
    tar -xzf "${tgz[0]}" -C /opt/stm32cubeclt --strip-components=1 || \
      tar -xzf "${tgz[0]}" -C /opt/stm32cubeclt; \
    rm -rf /opt/stm32clt.zip /opt/stm32clt_zip /opt/stm32clt_extracted

# 3) Put tools on PATH
ENV PATH="/opt/stm32cubeclt/GNU-tools-for-STM32/bin:/opt/stm32cubeclt/STM32CubeProgrammer/bin:/opt/stm32cubeclt/bin:${PATH}"

# 4) Optional sanity check (will fail build if paths are wrong)
RUN arm-none-eabi-gcc --version || (echo 'arm-none-eabi-gcc not found'; ls -lah /opt/stm32cubeclt; false) && \
    STM32_Programmer_CLI --version || (echo 'STM32_Programmer_CLI not found'; ls -lah /opt/stm32cubeclt; false)

WORKDIR /workspace
