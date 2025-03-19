    .section .text.entry # 于.text段声明子段，作为入口
    .globl _start # 声明全局符号用作链接脚本设置的入口点
_start:
    li x1, 100

    la sp, boot_stack_top # 初始化栈顶指针sp

    call rust_main # 调用rust_main()

    .section .bss.stack # 于.bss段声明子段，模拟栈
    .globl boot_stack_lower_bound # 栈顶边界
boot_stack_lower_bound:
    .space 4096 * 16 # 64KB可用
    .globl boot_stack_top # 栈顶初始位置
boot_stack_top: