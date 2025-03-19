OUTPUT_ARCH(riscv) /* 目标架构 */
ENTRY(_start) /* 指定_start的值为入口地址 */
BASE_ADDRESS = 0x80200000; /* 内核装载起始物理地址 */

SECTIONS
{
    /* 定义的skernel, stext等符号会被导出至输出文件的符号表 */
    /* 由低到高指定输出节.text, .rodata, .data, .bss段包含的内容 */
    /* 输出节 : {输入文件(输入节)...} */
    . = BASE_ADDRESS; /* 将当前地址设置为基址 */
    skernel = .;

    stext = .;
    .text : {
        *(.text.entry)
        *(.text .text.*)
    }

    /* 4KB对齐地址 */
    . = ALIGN(4K);
    etext = .;
    srodata = .;
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }

    . = ALIGN(4K);
    erodata = .;
    sdata = .;
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
    }

    . = ALIGN(4K);
    edata = .;
    .bss : {
        *(.bss.stack)
        sbss = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    . = ALIGN(4K);
    ebss = .;
    ekernel = .;

    /* 丢弃eh_frame段 */
    /DISCARD/ : {
        *(.eh_frame)
    }
}