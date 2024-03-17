# Compilerji
CC=gcc
ASM=nasm
LINKER=ld
EMULATOR=qemu-system-x86_64

# Zastavice za compiler
CFLAGS = -m32 -fno-pie -g -nostdlib -Wall -Wextra -Werror -ffreestanding
# Zastavice za emulator
EFLAGS = -s -fda

KERNEL_SRC_DIR=kernel
BUILD_DIR=build
BOOT_DIR=boot

# Seznam vseh izvornih datotek jedra
KERNEL_SRC_FILES = $(wildcard $(KERNEL_SRC_DIR)/*.c)
DEPS = $(wildcard $(KERNEL_SRC_DIR)/*.h)

# Seznam vseh imen datotek objektov
OBJ_FILES = $(patsubst $(KERNEL_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(KERNEL_SRC_FILES))

KERNEL=$(BUILD_DIR)/kernel.bin
IMAGE=image.bin

all: build

run: $(IMAGE)
	$(EMULATOR) $(EFLAGS) $^

build: $(IMAGE)

$(IMAGE): $(BUILD_DIR)/boot_sector.bin $(KERNEL)
	cat $^ > $@

$(BUILD_DIR)/boot_sector.bin: $(BOOT_DIR)/boot_sector.asm
	$(ASM) $^ -I $(BOOT_DIR) -f bin -o $@

$(KERNEL): $(BUILD_DIR)/kernel_entry.o $(OBJ_FILES)
	$(LINKER) -m elf_i386 -o $@ -Ttext 0x1000 --entry kernel $^ --oformat binary

$(BUILD_DIR)/kernel_entry.o: $(BOOT_DIR)/kernel_entry.asm
	$(ASM) $^ -f elf -o $@

$(BUILD_DIR)/%.o: $(KERNEL_SRC_DIR)/%.c $(DEPS)
	$(CC) $(CFLAGS) -I/$(BUILD_DIR) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(IMAGE)

$(shell mkdir -p $(BUILD_DIR))
