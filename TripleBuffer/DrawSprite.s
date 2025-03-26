
; Input:
;   A: value of R#14 to set VDP to write/read VRAM (constants: R14_PAGE_n)
;   IY: addr of current frame header
;   DE: VRAM NAMTBL addr position
;   IX: Player Vars base addr (already pointing to next frame)
DrawSprite:

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



    ; -----------------------------------------------------------
    ; Read header

    ld      a, MEGAROM_PAGE_FRAME_HEADERS
    ld	    (Seg_P8000_SW), a


    ; header: ;		yOffset (word), width (byte), height (byte), megaROM page, list addr

    ; go to current frame header and get values, updating player vars (width, height, megarom, list addr)

    ; --- adjust VRAM NAMTBL address based on yOffset

    ;  HL = yOffset
    ld      l, (iy)
    ld      h, (iy + 1)



    ; ---- DE += HL         NAMTBL_Addr += yOffset
    add     hl, de ; HL = HL + DE
    ex      de, hl ; DE = HL


    ; get width and height and save to player vars
    ld      a, (iy + 2) ; width
    ld      (ix + (Player_1_Vars.Width - Player_1_Vars)), a
    ld      a, (iy + 3) ; height
    ld      (ix + (Player_1_Vars.Height - Player_1_Vars)), a


    ; HL = frame first list addr
    ld      l, (iy + 5)
    ld      h, (iy + 6)


    ; get megaROM page number from header and switch to the page
    ld      a, (iy + 4)
    ; ld      (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars)), a
    ld	    (Seg_P8000_SW), a


    ; init vars
    ; ld      (Last_NAMTBL_Addr), de

    ; ld      iyl, 0 ; reset 16kb boundary flag
    
    di
        ld      (OldSP), sp
        ld      sp, hl

        ; ld      hl, (Last_NAMTBL_Addr)
        ld      l, e
        ld      h, d

.loop:

            ; -----------------------------------------------------------
            ; Read list

            pop     bc              ; B = length, C = increment
            xor     a
            or      c
            jr      z, .endFrame ; if (increment == 0) endFrame

            ld      a, b

            pop     de              ; DE = slice data address

            ; --- set VRAM addr

            ; HL = (Last_NAMTBL_Addr) + increment
            ; ld      hl, (Last_NAMTBL_Addr)
            ld      b, 0
            add     hl, bc  ; BC = increment
            ; ld      (Last_NAMTBL_Addr), hl

            ld      b, a    ; B = length

            ; write the lower 14 bits of the address to VDP PORT_1
            ld      a, l
            out     (PORT_1), a ; addr low

            ld      a, h
            or      0100 0000 b ; set bit 6 (write flag)
            out     (PORT_1), a ; addr high

            ; ; check "crossed 16 kb boundary" flag
            ; ld      a, iyl
            ; or      a
            ; jp      nz, .continue

            bit     6, h
            jr      nz, .cross16kb
    ;.continue:


            ; HL = DE (slice data address)
            ; DE = HL (VRAM NAMTBL addr)
            ex      de, hl

            ld      c, PORT_0
            otir

            ; HL = DE (VRAM NAMTBL addr)
            ; DE = HL (slice data address)
            ex      de, hl

        jp      .loop


        ; ---

.endFrame:

        ld  sp, (OldSP)
    ei



    ret

.cross16kb:

    ld      a, (TripleBuffer_Vars.R14_Value)
    inc     a

    ; set R#14
    ; di
        ; write bits a14-16 of address to R#14
        out     (PORT_1), a ; data
        ld      a, 14 + 128
        out     (PORT_1), a ; register #
    ; ei

    ; ld      iyl, 1 ; set flag (to not set R#14 again)

    jp      DrawSprite_After16kb.continue


; ------------------------------------------------------------------------------
; code repeated (used after the 16kb crossed)
DrawSprite_After16kb:
.loop:

        ; -----------------------------------------------------------
        ; Read list

        pop     bc              ; B = length, C = increment
        xor     a
        or      c
        jr      z, DrawSprite.endFrame ; if (increment == 0) endFrame

        ld      a, b

        pop     de              ; DE = slice data address

        ; --- set VRAM addr

        ld      b, 0
        add     hl, bc  ; BC = increment

        ld      b, a    ; B = length

        ; write the lower 14 bits of the address to VDP PORT_1
        ld      a, l
        out     (PORT_1), a ; addr low

        ld      a, h
        or      0100 0000 b ; set bit 6 (write flag)
        out     (PORT_1), a ; addr high

        ; Removed. Not necessary after R#14 already updated for the second 16kb of NAMTBL
        ; ; check "crossed 16 kb boundary" flag
        ; ld      a, iyl
        ; or      a
        ; jp      nz, .continue

        ; bit     6, h
        ; jr      nz, .cross16kb
.continue:


        ; HL = DE (slice data address)
        ; DE = HL (VRAM NAMTBL addr)
        ex      de, hl

        ld      c, PORT_0
        otir

        ; HL = DE (VRAM NAMTBL addr)
        ; DE = HL (slice data address)
        ex      de, hl

    jp      .loop