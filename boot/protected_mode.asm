[bits 16]
switch_to_pm:
    cli                     ; izklopimo prekinitve
    lgdt [GDT_descriptor]  ; naložimo globalno tabelo deskriptorjev

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG ; vse segmentne registerje
    mov ds, ax       ; nastavimo na isto vrednost,
    mov ss, ax       ; saj jih v 32 bitnem načinu ne
    mov es, ax       ; bomo uporabljali
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM