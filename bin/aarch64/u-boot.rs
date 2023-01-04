#![no_std]
#![no_main]

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
#[link_section = ".text.boot"]
pub extern "C" fn _start() -> ! {
    const UART_ADDR: usize = 0x0900_0000;
    const UART0: *mut u8 = UART_ADDR as *mut u8;
    let out_str = b"Hello aarch64 kernel\n";
    for byte in out_str {
        unsafe {
            core::ptr::write_volatile(UART0, *byte);
        }
    }

    loop {}
}
