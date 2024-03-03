ASM=nasm
LINKER=ld
CC=gcc
EMULATOR=qemu-system-x86_64

BUILD_DIR=build

all: build

run: $(BUILD_DIR)/image.bin
	$(EMULATOR) $^

build: $(BUILD_DIR)/image.bin

$(BUILD_DIR)/image.bin: $(BUILD_DIR)/boot_sector.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $@

$(BUILD_DIR)/boot_sector.bin: boot/boot_sector.asm
	$(ASM) $^ -I boot/ -f bin -o $@

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o
	$(LINKER) -o $@ -Ttext 0x1000 $^ --oformat binary

$(BUILD_DIR)/kernel_entry.o: kernel/kernel_entry.asm
	$(ASM) $^ -f elf64 -o $@

$(BUILD_DIR)/kernel.o: kernel/kernel.c
	$(CC) -ffreestanding -c $^ -o $@

clean:
	rm *.o *.bin
	rm build/*
