
; Input:
;   A: value of R#2 to set active page (constants: R2_PAGE_n)
SetActivePage:
    ; set VDP R#2 (NAMTBL base address; bits a10-16)
    ; bits:    16 15        7
    ;           | |         |
    ; 0x08000 = 0 1000 0000 0000 0000
    ; R#2 : 0 a16 a15 1 1 1 1 1

    ; ld      a, 0001 1111 b  ; page 0 (0x00000)
    ; ld      a, 0011 1111 b  ; page 1 (0x08000)
    ; ld      a, 0101 1111 b  ; page 2 (0x10000)
    ; ld      a, 0111 1111 b  ; page 3 (0x18000)
    di
        ; write bits a10-16 of address to R#2
        out     (PORT_1), a ; data
        ld      a, 2 + 128
        out     (PORT_1), a ; register #
    ei

    ret