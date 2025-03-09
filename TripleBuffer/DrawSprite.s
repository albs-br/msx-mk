
; Input:
;   A: value of R#14 to set VDP to write/read VRAM (constants: R14_PAGE_n)
;   HL: addr of frame list
;   IY: addr of frame data
;   DE: VRAM NAMTBL addr position
;   IX: Player Vars base addr (already pointing to next frame)
DrawSprite:

    push    af
        ; ld      a, (Player_1_Vars.CurrentFrame_MegaRomPage)
        ld      a, (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars))
        ld	    (Seg_P8000_SW), a
    pop     af

    ; ; get megaROM page number from header, save to player vars and switch to the page
    ; dec     hl
    ;     ld      a, (hl)
    ;     ld      (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars)), a
    ;     ld	    (Seg_P8000_SW), a
    ; inc     hl
    
    push    af, hl
        
        ; header: ;		yOffset (word), width (byte), height (byte), megaROM page

        ;push    hl
            ; HL -= 5
            ld      bc, 5 ; frame header is 5 bytes before frame list
            xor     a
            sbc     hl, bc
            
            ; --- adjust VRAM NAMTBL address based on yOffset
        
            ; HL = (HL)     (yOffset)
            ld      a, (hl)
            ld      c, a
            inc     hl
            ld      a, (hl)
            ld      h, a
            ld      l, c

            ; ---- DE += HL         NAMTBL_Addr += yOffset
            add     hl, de ; HL = HL + DE
            ex      de, hl ; DE = HL
        ;pop     hl

        ; ; get megaROM page number from header, save to player vars and switch to the page
        ; dec     hl
        ; ld      a, (hl)
        ; ld      (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars)), a
        ; ;ld	    (Seg_P8000_SW), a
; JP $
    pop     hl, af

    ld      (TripleBuffer_Vars.BaseDataAddr), iy

    ld      (TripleBuffer_Vars.R14_Value), a
    ; set R#14
    ; ld a, 0000 0000 b ; page 0
    ; ld a, 0000 0010 b ; page 1
    ; ld a, 0000 0100 b ; page 2
    ; ld a, 0000 0110 b ; page 3
    di
        ; write bits a14-16 of address to R#14
        out     (PORT_1), a ; data
        ld      a, 14 + 128
        out     (PORT_1), a ; register #
    ei

    ; init vars
    ; ld      de, 0+(128*100) ;0x0000
    ; ld      d, 0100 0000 b ; set bit 6 of VRAM high addr (read/write flag) to avoid OR 64 after
    ; ld      e, 0
    ld      (Last_NAMTBL_Addr), de

    ld      iyl, 0 ; reset flag
    ; ld      hl, Frame_0.List
    
.loop:


    ld      a, (hl)     ; C = increment
    or      a
    jp      z, .endFrame ; if (increment == 0) endFrame
    ld      c, a

    inc     hl
    ld      a, (hl)     ; A = length

    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)     ; DE = slice data address

    inc     hl
    push    hl
        ; --- set VRAM addr

        ; HL = (Last_NAMTBL_Addr) + increment
        ld      hl, (Last_NAMTBL_Addr)
        ld      b, 0
        add     hl, bc  ; BC = increment
        ld      (Last_NAMTBL_Addr), hl

        ld      b, a    ; B = length

        ; set R#14 to 0
        ; set remaining bits of VRAM addr to HL
        ; ld a, 0000 0000 b ; page 0
        ; ld a, 0000 0010 b ; page 1
        ; ld a, 0000 0100 b ; page 2
        ; ld a, 0000 0110 b ; page 3
        di
            ; ; write bits a14-16 of address to R#14
            ; out     (PORT_1), a ; data
            ; ld      a, 14 + 128
            ; out     (PORT_1), a ; register #

            ; write the other address bits to VDP PORT_1
            ld      a, l
            
            ;nop
            ld      c, PORT_0 ; do this instead of nop to save cycles


            out     (PORT_1), a ; addr low
            ld      a, h

            or      64
        ei
        out     (PORT_1), a ; addr high

        ld      a, iyl
        or      a
        jp      nz, .continue

        ;bit     6, h
        ld      a, h
        and     0100 0000 b
        jr      nz, .cross16kb
.continue:


        ; HL = Data + slice addr
        ; ld      hl, Frame_0.Data
        ld      hl, (TripleBuffer_Vars.BaseDataAddr)
        add     hl, de

        ; ld      c, PORT_0
        otir
    pop     hl
    jp      .loop


    ; ---

.endFrame:

    ; ; get megaROM page of next frame from IX
    ; ld      l, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars))
    ; ld      h, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1)

    ; dec     hl ; back one address to the last position of header
    ; ld      a, (hl)

    ; ; save it to player vars
    ; ld      (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars)), a

    ret

.cross16kb:

    ld      a, (TripleBuffer_Vars.R14_Value)
    ;or      0000 0001 b
    inc     a

    ; set R#14
    di
        ; write bits a14-16 of address to R#14
        out     (PORT_1), a ; data
        ld      a, 14 + 128
        out     (PORT_1), a ; register #
    ei

    ld      iyl, 1 ; set flag (to not set R#14 again)

    jp      .continue