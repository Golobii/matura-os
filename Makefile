# Prevajalniki, povezovalniki in emulator
CC=gcc
ASM=nasm
LINKER=ld
EMULATOR=qemu-system-x86_64

# Zastavice za prevajalnik
CFLAGS = -m32 -fno-pie -g -nostdlib -Wall -Wextra -ffreestanding
# Zastavice za emulator
EFLAGS = -s -fda
# Zastavice za povezovalnik
LFLAGS = -m elf_i386 -Ttext 0x1000 --entry kernel --oformat binary

# Pomembne poti datotek
KERNEL_SRC_DIR=kernel
LIBC_SRC_DIR=libc
DRIVERS_SRC_DIR=drivers
BUILD_DIR=build
BOOT_DIR=boot

# Seznam vseh izvornih datotek
KERNEL_SRC_FILES = $(wildcard $(KERNEL_SRC_DIR)/*.c)
LIBC_SRC_FILES = $(wildcard $(LIBC_SRC_DIR)/*.c)
DRIVERS_SRC_FILES = $(wildcard $(DRIVERS_SRC_DIR)/*.c)
KERNEL_DEPS = $(wildcard $(KERNEL_SRC_DIR)/*.h)
LIBC_DEPS = $(wildcard $(LIBC_SRC_DIR)/*.h)
DRIVERS_DEPS = $(wildcard $(DRIVERS_SRC_DIR)/*.h)

# Seznam vseh imen datotek objektov
OBJ_FILES = $(patsubst $(KERNEL_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(KERNEL_SRC_FILES))
OBJ_FILES += $(patsubst $(LIBC_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(LIBC_SRC_FILES))
OBJ_FILES += $(patsubst $(DRIVERS_SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(DRIVERS_SRC_FILES))

# Pomembni datoteki
KERNEL=$(BUILD_DIR)/kernel.bin
IMAGE=image.bin

# To pravilo se zažene privzeto
all: build

build: $(IMAGE)

# Zgradi projekt in avtomatično zažene emulator
run: $(IMAGE)
	$(EMULATOR) $(EFLAGS) $^

# To pravilo združi "boot_sector" in jedro
$(IMAGE): $(BUILD_DIR)/boot_sector.bin $(KERNEL)
	cat $^ > $@

# To pravilo prevede vse izvorne datoteke
$(BUILD_DIR)/boot_sector.bin: $(BOOT_DIR)/boot_sector.asm
	$(ASM) $^ -I $(BOOT_DIR) -f bin -o $@

# To pravilo poveže vse prevedene datoteke v eno
$(KERNEL): $(BUILD_DIR)/kernel_entry.o $(OBJ_FILES)
	# gcc -m32 -c -o $@ -Ttext 0x1000 --entry kernel $^
	$(LINKER) $(LFLAGS) -T linker.ld -o $@ $^

$(BUILD_DIR)/kernel_entry.o: $(BOOT_DIR)/kernel_entry.asm
	$(ASM) $^ -f elf -o $@

# To pravilo prevede vse .c datoteke, ki spadajo k jedru
$(BUILD_DIR)/%.o: $(KERNEL_SRC_DIR)/%.c $(KERNEL_DEPS)
	$(CC) $(CFLAGS) -I/$(KERNEL_SRC_DIR) -c $< -o $@

# To pravilo prevede vse .c datoteke, ki spadajo k standardni knjižnici
$(BUILD_DIR)/%.o: $(LIBC_SRC_DIR)/%.c $(LIBC_DEPS)
	$(CC) $(CFLAGS) -I/$(LIBC_SRC_DIR) -c $< -o $@

# To pravilo prevede vse .c datoteke, ki spadajo h gonilnikom
$(BUILD_DIR)/%.o: $(DRIVERS_SRC_DIR)/%.c $(DRIVERS_DEPS)
	$(CC) $(CFLAGS) -I/$(DRIVERS_SRC_DIR) -c $< -o $@

# Počisti projekt
clean:
	rm -rf $(BUILD_DIR) $(IMAGE)

# Ustvari potreben direktorij
$(shell mkdir -p $(BUILD_DIR))
