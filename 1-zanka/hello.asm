jmp $ ; neskončna zanka

times 510-($-$$) db 0 ; Poskrbi za pravilno obliko datoteke.
dw 0xaa55             ; Število po katerem BIOS zazna 
                      ; datoteko kot zagonski sektor.