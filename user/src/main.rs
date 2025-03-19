#![no_std]
#![no_main]
#[macro_use]
mod console;
mod lang_item;
mod sbi;
mod logging;

use sbi::shutdown;
use core::arch::global_asm;

global_asm!(include_str!("entry.asm"));

#[unsafe(no_mangle)]
fn rust_main() {
    use log::{debug, error, info, trace, warn};
    unsafe extern "C" {
        safe fn stext();
        safe fn etext();
        safe fn srodata();
        safe fn erodata();
        safe fn sdata();
        safe fn edata();
        safe fn sbss();
        safe fn ebss();
        safe fn boot_stack_lower_bound();
        safe fn boot_stack_top();
    }

    clear_bss();
    println!("Hello, world!");
    logging::init();
    trace!(
        ".text [{:#x}, {:#x})",
        stext as usize, etext as usize
    );
    debug!(
        ".rodata [{:#x}, {:#x})",
        srodata as usize, erodata as usize
    );
    info!(
        ".data [{:#x}, {:#x})",
        sdata as usize, edata as usize
    );
    warn!(
        ".bss.stack [{:#x}, {:#x})",
        boot_stack_top as usize, boot_stack_lower_bound as usize
    );
    error!(".bss [{:#x}, {:#x})", sbss as usize, ebss as usize);
    shutdown(false);
}

fn clear_bss() {
    unsafe extern "C" {
        safe fn sbss();
        safe fn ebss();
    }
    (sbss as usize..ebss as usize).for_each(|a| unsafe { (a as *mut u8).write_volatile(0) });
}