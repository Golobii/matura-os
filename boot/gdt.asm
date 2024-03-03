; Globalna tabela deskriptorjev

; Oznaka za začetek GDT
GDT_start:  ; obvezni ničelni deskriptor
    dd 0x0  ; db definira štiri bajte
    dd 0x0

; Deskriptor kodnega segmenta
GDT_code:
    ; začetek=0x0, meja=0xfffff,
    ; 1. zastavice: prisotnost -> 1; privilegij -> 00; tip deskriptorja -> 1  (1001b)
    ; zastavice vrst: koda -> 1; skladnost -> 0; berljivost -> 1; dostopnost -> 0  (1010b)
    ; 2. zastavice: granularnost -> 1; privzeto 32-bitov -> 1; 64-bitna segmentacija -> 0; AVL -> 0  (1100b)
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b ; 1. zastavice + zastavice vrst
    db 11001111b ; 2. zastavice + limita (biti 16-19)
    db 0x0

; Deskriptor podatkovnega segmenta
GDT_data:
    ; Enako kot pri kodnem segmentu, razen zastavic vrst:
    ; zastavice vrst: koda -> 0; razširi navzdol -> 0; zapisljivost -> 1; dostopnost -> 0  (0010b)
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b ; 1. zastavice + zastavice vrst
    db 11001111b ; 2. zastavice + limita (biti 16-19)
    db 0x0

; Oznaka za konec GDT
GDT_end:

; Opisnik GDT (globalne tabele deskriptorjev)
GDT_descriptor:
    dw GDT_end - GDT_start - 1     ; Velikost GDT
    dd GDT_start                   ; Začetni naslov GDT

; Uporabne konstante
CODE_SEG equ GDT_code - GDT_start ; zamik kodnega segmenta
DATA_SEG equ GDT_data - GDT_start ; zamik podatkovnega segmenta
