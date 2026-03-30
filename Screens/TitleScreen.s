TitleScreen:

    ; -------------- Show title screen


    ; change to screen 8. 
    ld      a, 0
    ld      (BIOS_BDRCLR),A                         ; Set Border Color for CHGMOD
    ld      a, 8
    call    BIOS_CHGMOD

    call    BIOS_DISSCR
    call    ClearVram_MSX2
    call    Set212Lines
    call    SetColor0ToNonTransparent
    call    DisableSprites
    
    ld	    a, MEGAROM_PAGE_BG_TITLE_0
    ld      hl, Bg_Title_Part_0                     ; ZX0 file addr
    ld		de, NAMTBL_SC8                          ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_0
    ld      hl, Bg_Title_Part_1                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 1)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_1
    ld      hl, Bg_Title_Part_2                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 2)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_1
    ld      hl, Bg_Title_Part_3                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 3)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_1
    ld      hl, Bg_Title_Part_4                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 4)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_1
    ld      hl, Bg_Title_Part_5                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 5)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld	    a, MEGAROM_PAGE_BG_TITLE_1
    ld      hl, Bg_Title_Part_6                     ; ZX0 file addr
    ld		de, NAMTBL_SC8 + (8192 * 6)             ; VRAM address (destiny, bits 15-0)
    call    Decompress_ZX0_8kb_and_Load_SC8

    ld      a,0                     ; Title Music
    call    RePlayer_PlayTrack      ; 
    
    ld      b,218                   ; Delay to show the Title Screen at the exact music point
    call    Wait_B_Vblanks          ; 


    call    BIOS_ENASCR             ; Trying a kind of improvised Fade-In
    halt                            ; Wait v-blank
    call    BIOS_DISSCR      
    halt                     

    call    BIOS_ENASCR             ; Shows Title Screen

    ld      b, 200  ; wait 
    call    Wait_B_Vblanks
    
    ret