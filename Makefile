# $@ = target file
# $< = first dependency
# $^ = all dependencies
CPP_SOURCES = $(wildcard src/kernel/*.cpp src/cpu/*.cpp src/drivers/*.cpp src/libc/*.cpp)
C_SOURCES = $(wildcard src/kernel/*.c src/cpu/*.c src/drivers/*.c src/libc/*.c)
HEADERS = $(wildcard kernel/*.h)
# Nice syntax for file extension replacement
OBJC = ${CPP_SOURCES:.cpp=.o}
OBJ = ${C_SOURCES:.c=.o}
BOOT = $(src/bootloader/print.asm src/bootloader/diskread.asm)

CFLAGS = -Ttext 0x8000 -ffreestanding -mno-red-zone -m64 -c -g

# First rule is run by default
Nate-OS.bin: src/bootloader/bootloader.bin kernel.bin
	cat $^ > Nate-OS.bin

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
kernel.bin: kernel.elf
	objcopy -O binary kernel.elf kernel.bin

kernel.elf: ${OBJ} ${OBJC} src/bootloader/loader.o src/resources/binaries.o
	x86_64-elf-ld -T "linker.ld"

kernel.sym: kernel.elf
	objcopy --only-keep-debug kernel.elf kernel.sym

src/bootloader/bootloader.bin: src/bootloader/bootloader.asm src/bootloader/print.asm src/bootloader/diskread.asm
	nasm $< -f bin -i src -o $@

src/bootloader/loader.o: src/bootloader/loader.asm src/cpu/interupt.asm src/bootloader/GDT.asm src/bootloader/DetectMemory.asm src/bootloader/CPUID.asm src/bootloader/simplePaging.asm
	nasm $< -f elf64 -i src -o $@

run: Nate-OS.bin
	qemu-system-x86_64 -fda Nate-OS.bin

debug: Nate-OS.bin kernel.sym
	qemu-system-x86_64 -fda $< -s -S&
	gdb --symbols=kernel.sym --readnow --command=gdb.txt

# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	x86_64-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.cpp ${HEADERS}
	x86_64-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf64 -i src -o $@

%.bin: %.asm
	nasm $< -f bin -i src -o $@

clean:
	rm -rf *.bin *.o Nate-OS.bin *.elf *.sym
	rm -rf src/kernel/*.o src/bootloader/*.bin src/resources/*.o src/bootloader/*.o src/resources/*.o src/cpu/*.o src/drivers/*.o src/libc/*.o


#OUTPUT
#(
#	kernel.bin
#)