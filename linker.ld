OUTPUT_FORMAT(elf64-x86-64	)

ENTRY(kernel_main)

INPUT(
	src/bootloader/loader.o
	src/kernel/kernel.o
		src/cpu/idt.o
		src/cpu/isr.o
		src/cpu/ports.o
		src/cpu/timer.o
		src/drivers/keyboard.o
		src/drivers/screen.o
		src/libc/mem.o
		src/libc/string.o
	src/resources/binaries.o
)

OUTPUT
(
	kernel.elf
)

SECTIONS
{
	. = 0x8000;

	.text : ALIGN(0x1000)
	{
		*(.text)
	}

	.idt BLOCK(0x1000) : ALIGN(0x1000)
	{
		_idt = .;
		. = . + 0x1000;
	}

	.data : ALIGN(0x1000)
	{
		*(.data)
	}

	.rodata : ALIGN(0x1000)
	{
		*(.rodata)
	}

	.bss : ALIGN(0x1000)
	{
		*(COMMON)
		*(.bss)
	}
}