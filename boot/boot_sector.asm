[org 0x7c00]
KERNEL_OFFSET equ 0x1000

start:
    mov bp, 0x9000
    mov sp, bp

    mov [BOOT_DRIVE], dl

    call load_kernel

    call switch_to_pm ; ta funkcija se nikoli ne vrne,
                      ; skoči na BEGIN_PM

    jmp $             ; za vsak slučaj


%include "utils.asm"
%include "gdt.asm"
%include "protected_mode.asm"
%include "disk.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call load_from_disk
    ret

[bits 32]
BEGIN_PM:
    call KERNEL_OFFSET

    jmp $


BOOT_DRIVE db 0

times 510-($-$$) db 0x0
dw 0xaa55
