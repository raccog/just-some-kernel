/* Multiboot 2 magic number */
.set MAGIC, 0xe85250d6
/* Multiboot 2 still uses the i386 architecture flag for x86_64 */
.set ARCH_I386, 0
.set ARCH, ARCH_I386
/* Length of the multiboot 2 header in bytes */
.set HEADER_LENGTH, HEADER_TOP - HEADER_BOTTOM
/* Multiboot 2 checksum, where (CHECKSUM + MAGIC + ARCH + HEADER_LENGTH == 0x00000000) */
/* I would use the 2's complement negation operator (-), but for some reason, the assembler used by Rust
/* (LLVM?) turns a u32 into a u64 when that operator is used. Insead, I've calculated the checksum with only
/* addition and subtraction */
.set CHECKSUM, 0xffffffff - (MAGIC + ARCH + HEADER_LENGTH) + 1

/* Multiboot 2 header */
.section .multiboot
.align 4
HEADER_BOTTOM:
.long MAGIC
.long ARCH
.long HEADER_LENGTH
.long CHECKSUM

/* Multiboot 2 tags */

/* Null tag */
.long 0
.long 8
HEADER_TOP:

/* Pre-allocated stack of 16KB */
.section .bss
.align 16
STACK_BOTTOM:
.skip 16384
STACK_TOP:

/* Multiboot 2 start */
.section .text
.global _start
.type _start, @function
_start:
    mov STACK_TOP, rsp

    call multiboot2_entry

    cli
1:  hlt
    jmp 1b

.size _start, . - _start
