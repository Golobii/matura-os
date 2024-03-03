[bits 32]
; Uporabne konstante.
VIDEO_MEMORY equ 0xb8000 ; začetek video spomina
WHITE_ON_BLACK equ 0x0f  ; barva (bela na črni)

; Na ekran zapiše besedilo v 32-bitnem zaščitenem načinu.
print_string_pm:
    pusha

    mov edx, VIDEO_MEMORY
print_string_loop:
    mov al, [ebx]
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je print_string_done

    mov [edx], ax

    add ebx, 1
    add edx, 2

    jmp print_string_loop

print_string_done:
    popa
    ret

; Na ekran zapiše besedilo s pomočjo BIOS prekinitev.
; Deluje samo v 16-bitnem načinu.
[bits 16]
print_string:
    pusha

    mov bx, ax
    mov ah, 0x0e
loop:
    mov al, [bx]
    int 0x10
    add bx, 1
    cmp al, 0
    jne loop

    popa
    ret


