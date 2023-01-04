#!/bin/bash

if [[ "$1" = "aarch64" ]]; then
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

    # Build kernel for aarch64
    cargo build --target=./meta/target-specs/aarch64-unknown-none.json --bin some-kernel-u-boot-aarch64

    # Run u-boot and kernel
    qemu-system-aarch64 -machine virt -cpu cortex-a57 -bios toolchain/u-boot/u-boot.bin -nographic -device loader,file=target/aarch64-unknown-none/debug/some-kernel-u-boot-aarch64,addr=0x42200000,force-raw=on
else
    # Build kernel for x86_64
    cargo build --target=./meta/target-specs/x86_64-unknown-none.json --bin some-kernel-multiboot-x86_64

    # Create ISO with grub
    mkdir -p target/isodir/boot/grub
    cp meta/grub.cfg target/isodir/boot/grub
    cp target/x86_64-unknown-none/debug/some-kernel-multiboot-x86_64 target/isodir/boot
    grub-mkrescue -o target/some-kernel-grub.iso target/isodir

    # Run grub and kernel
    qemu-system-x86_64 -cdrom target/some-kernel-grub.iso
fi
