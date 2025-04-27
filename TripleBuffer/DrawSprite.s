
; Inputs:
;   A: value of R#14 to set VDP to write/read VRAM (constants: R14_PAGE_n)
;   IY: addr of current frame header
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



    ; get width and height and save to player vars
    ld      a, (iy + FrameHeader_Struct.Width)
    ld      (ix + Player_Struct.Width), a
    ld      a, (iy + FrameHeader_Struct.Height)
    ld      (ix + Player_Struct.Height), a




    ; ----- check screen right limit
    ; if (x >= (255-width)) x = 255 - width
    ld      a, 255
    sub     (ix + Player_Struct.Width)
    ld      b, a ; B = max_valid_X
    ld      a, (ix + Player_Struct.X)
    cp      b       
    jp      c, .notOutsideOfScreen

    ld      (ix + Player_Struct.X), b ; x = max_valid_X
    call    Update_VRAM_NAMTBL_Addr
.notOutsideOfScreen:


    ; --- adjust VRAM NAMTBL address based on yOffset

    ld      e, (ix + Player_Struct.VRAM_NAMTBL_Addr)
    ld      d, (ix + Player_Struct.VRAM_NAMTBL_Addr + 1)

    ;  HL = yOffset
    ld      l, (iy + FrameHeader_Struct.yOffset)
    ld      h, (iy + FrameHeader_Struct.yOffset + 1)



    call    UpdateHurtbox


    ; ---- DE += HL         NAMTBL_Addr += yOffset
    add     hl, de ; HL = HL + DE
    ex      de, hl ; DE = HL



    ; HL = frame first list addr
    ld      l, (iy + FrameHeader_Struct.FirstFrameList_Addr)
    ld      h, (iy + FrameHeader_Struct.FirstFrameList_Addr + 1)


    ; get megaROM page number (for data and list of the frame) from header and switch to the page
    ld      a, (iy + FrameHeader_Struct.MegaRomPage)
    ld	    (Seg_P8000_SW), a



    
    di
        ld      (OldSP), sp
        ld      sp, hl

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
            ld      b, 0
            add     hl, bc  ; BC = increment

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

    ; --------- Update RestoreBG vars

    ; --- RestoreBG_1 = RestoreBG_0
    ld      a, (ix + Player_Struct.Restore_BG_0_X)
    ld      (ix + Player_Struct.Restore_BG_1_X), a

    ld      a, (ix + Player_Struct.Restore_BG_0_Y)
    ld      (ix + Player_Struct.Restore_BG_1_Y), a

    ld      a, (ix + Player_Struct.Restore_BG_0_WidthInPixels)
    ld      (ix + Player_Struct.Restore_BG_1_WidthInPixels), a

    ld      a, (ix + Player_Struct.Restore_BG_0_HeightInPixels)
    ld      (ix + Player_Struct.Restore_BG_1_HeightInPixels), a


    ; --- RestoreBG_0 = current
    ld      a, (ix + Player_Struct.X)
    ld      (ix + Player_Struct.Restore_BG_0_X), a

    ld      a, (ix + Player_Struct.Y)
    ld      (ix + Player_Struct.Restore_BG_0_Y), a

    ld      a, (ix + Player_Struct.Width)
    ld      (ix + Player_Struct.Restore_BG_0_WidthInPixels), a

    ld      a, (ix + Player_Struct.Height)
    ld      (ix + Player_Struct.Restore_BG_0_HeightInPixels), a



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
            
    set     6, h ; set bit 6 (write flag)

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
        ; or      0100 0000 b ; set bit 6 (write flag) ; Removed, cos it's already set
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

; possible speed improvement:
;
; HL: VRAM NAMTBL addr
; C = PORT_1
; pop DE: length, increment; no need to pop slice data addr (addr of first slice will go to frame header)
; HL': slice data address (value correct after OTIR)
; C' = PORT_0


; ; -------- improved version

; ; ------------------------------------------------------------------------------
; ; code repeated (used after the 16kb crossed)
; DrawSprite_After16kb_new:

;     ; set C and C' 

;     ; pop first length/increment
;     pop     de              ; D = length, E = increment


; .loop: ; slice loop = ?/? cycles with all these (many) optimizations

;         ; -----------------------------------------------------------
;         ; Read list

;         ; --- set VRAM addr

;         ld      d, 0
;         add     hl, de  ; BC = increment

;         ; write the lower 14 bits of the address to VDP PORT_1
;         out     (c), l ; addr low
;         out     (c), h ; addr high

; .continue:

;         ; HL' = slice data address
;         ; HL = VRAM NAMTBL addr
;         exx

;             otir ; B' must be set !!!!

;         exx

;         pop     de              ; D = length, E = increment
;         ; xor     a
;         ; or      e
;         dec     e ; increment must be stored as increment + 1 (1 means endFrame)

;     jp  nz, .loop

;     jp  .endFrame