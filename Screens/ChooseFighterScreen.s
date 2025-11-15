ChooseFighterScreen:

    ; -------------- Show choose fighter screen

    ; change to screen 8
    ld      a, 8
    call    BIOS_CHGMOD

    call    BIOS_DISSCR

    call    ClearVram_MSX2

    call    Set212Lines

    call    SetColor0ToNonTransparent

    call    DisableSprites
    
    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0
    ld      hl, Bg_Choose_Fighter_Screen_Part_0     ; ZX0 file addr
    ld		de, NAMTBL_SC8                          ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0
    ld      hl, Bg_Choose_Fighter_Screen_Part_1     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 1)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0
    ld      hl, Bg_Choose_Fighter_Screen_Part_2     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 2)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0
    ld      hl, Bg_Choose_Fighter_Screen_Part_3     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 3)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_1
    ld      hl, Bg_Choose_Fighter_Screen_Part_4     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 4)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_1
    ld      hl, Bg_Choose_Fighter_Screen_Part_5     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 5)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_1
    ld      hl, Bg_Choose_Fighter_Screen_Part_6     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 6)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8



    call    BIOS_ENASCR


    ld      b, 240  ; wait 4 seconds
    call    Wait_B_Vblanks


    
    ret