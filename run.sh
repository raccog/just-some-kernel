#!/bin/bash

# Clone u-boot
if [[ ! -d toolchain/u-boot ]]; then
    mkdir -p toolchain
    git clone --depth 1 git@github.com:u-boot/u-boot.git toolchain/u-boot
fi

# Build u-boot
cp u-boot-config toolchain/u-boot/.config
pushd toolchain/u-boot
CROSS_COMPILE=aarch64-linux-gnu- make -j$(nproc)
popd

# Build kernel
cargo build --target=./aarch64-unknown-none.json

# Run u-boot and kernel
qemu-system-aarch64 -machine virt -cpu cortex-a57 -bios toolchain/u-boot/u-boot.bin -nographic -device loader,file=target/aarch64-unknown-none/debug/just-some-kernel,addr=0x42200000,force-raw=on
