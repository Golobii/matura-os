mov ah, 0x0E ; v register "ah" zapiše število 0x0E
mov al, 'P'  ; v register "al" zapiše ascii 'P'
int 0x10     ; zažene prekinitev 0x10

mov al, 'o'  ; v register "al" zapiše ascii 'o'
int 0x10

mov al, 'z'
int 0x10
mov al, 'd'
int 0x10
mov al, 'r'
int 0x10
mov al, 'a'
int 0x10
mov al, 'v'
int 0x10
mov al, ','
int 0x10
mov al, ' '
int 0x10
mov al, 's'
int 0x10
mov al, 'v'
int 0x10
mov al, 'e'
int 0x10
mov al, 't'
int 0x10
mov al, '!'
int 0x10

jmp $ ; neskončna zanka

times 510-($-$$) db 0 ; Poskrbi za pravilno obliko datoteke.
dw 0xaa55             ; Število po katerem BIOS zazna 
                      ; datoteko kot zagonski sektor.