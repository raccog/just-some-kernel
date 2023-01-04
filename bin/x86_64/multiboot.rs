#![no_std]
#![no_main]

use core::arch::global_asm;

global_asm!(include_str!("multiboot.S"));

#[panic_handler]
fn panic_handler(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
#[link_section = ".text"]
pub extern "C" fn multiboot2_entry() -> ! {
    // To be sure that this runs, the kernel will crash here; if it doesn't crash it's not working :)
    unsafe { core::ptr::write_volatile(0xB8000 as *mut u8, 0x64) };
    loop {}
}
