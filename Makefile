# Compilerji
CC=gcc
ASM=nasm
LINKER=ld
EMULATOR=qemu-system-x86_64

# Zastavice za compiler
CFLAGS = -m32 -fno-pie -g -nostdlib -Wall -Wextra -ffreestanding
# Zastavice za emulator
EFLAGS = -s -fda
# Zastavice za linker
LFLAGS = -m elf_i386 -Ttext 0x1000 --entry kernel --oformat binary

KERNEL_SRC_DIR=kernel
LIBC_SRC_DIR=libc
BUILD_DIR=build
BOOT_DIR=boot

# Seznam vseh izvornih datotek jedra
KERNEL_SRC_FILES = $(wildcard $(KERNEL_SRC_DIR)/*.c)
LIBC_SRC_FILES = $(wildcard $(LIBC_SRC_DIR)/*c)
KERNEL_DEPS = $(wildcard $(KERNEL_SRC_DIR)/*.h)
LIBC_DEPS = $(wildcard $(LIBC_SRC_DIR)/*.h)

# Seznam vseh imen datotek objektov
OBJ_FILES = $(patsubst $(KERNEL_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(KERNEL_SRC_FILES))
OBJ_FILES += $(patsubst $(LIBC_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(LIBC_SRC_FILES))

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
	# gcc -m32 -c -o $@ -Ttext 0x1000 --entry kernel $^
	$(LINKER) $(LFLAGS) -T linker.ld -o $@ $^

$(BUILD_DIR)/kernel_entry.o: $(BOOT_DIR)/kernel_entry.asm
	$(ASM) $^ -f elf -o $@

$(BUILD_DIR)/%.o: $(KERNEL_SRC_DIR)/%.c $(KERNEL_DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(LIBC_SRC_DIR)/%.c $(LIBC_DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(IMAGE)

$(shell mkdir -p $(BUILD_DIR))
