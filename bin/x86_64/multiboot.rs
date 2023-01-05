#![no_std]
#![no_main]

use core::arch::{asm, global_asm};

global_asm!(include_str!("multiboot.S"));

#[panic_handler]
fn panic_handler(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[inline(always)]
unsafe fn outb(port: u16, byte: u8) {
    asm!("out dx, al",
        in("dx") port,
        in("al") byte,
        options(nostack));
}

trait Serial {
    fn read_byte(&self) -> u8;

    fn write_byte(&mut self, byte: u8);
}

struct SerialRs232 {
    port: u16,
}

impl SerialRs232 {
    pub fn new(port: u16) -> Self {
        Self { port }
    }
}

impl Serial for SerialRs232 {
    fn read_byte(&self) -> u8 {
        unimplemented!();
    }

    fn write_byte(&mut self, byte: u8) {
        unsafe {
            outb(self.port, byte);
        };
    }
}

#[no_mangle]
pub extern "C" fn multiboot2_entry() -> ! {
    // Write 'd' to serial port
    const COM1: u16 = 0x3f8;
    let mut serial0 = SerialRs232::new(COM1);
    let b: u8 = 0x64;
    serial0.write_byte(b);
    loop {}
}
