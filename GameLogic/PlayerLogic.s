; Input:
;   IX: Player Vars base addr
Update_VRAM_NAMTBL_Addr:

    ; ld      hl, 0 + ((192 - (58/2))/2) + (128*100) ; column number 192 - (58/2); line number 100

    ; VRAM_NAMTBL_Addr = (X/2) + (128*Y)
    ld      c, (ix + (Player_1_Vars.X - Player_1_Vars))         ; C = X
    srl     c                                                   ; shift right C
    ld      b, 0

    ld      h, 0
    ld      l, (ix + (Player_1_Vars.Y - Player_1_Vars))         ; HL = Y

    ; shift left HL 7 times (multiply by 128)
    ; T-Cycles: 32
    ; Bytes: 8
    ; Trashed: A
    xor     a
    srl     h
    rr      l
    rra
    ld      h, l
    ld      l, a


    add     hl, bc


    ld      (ix + (Player_1_Vars.VRAM_NAMTBL_Addr - Player_1_Vars)), l
    ld      (ix + (Player_1_Vars.VRAM_NAMTBL_Addr - Player_1_Vars + 1)), h

    ret