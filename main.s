FNAME "msx-mk.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB
Seg_P8000_SW:	equ	0x7000	        ; Segment switch for page 0x8000-BFFFh (ASCII 16k Mapper)

; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

    INCLUDE "ReadInput.s"
    INCLUDE "GameLogic/Player_Logic.s"
    INCLUDE "GameLogic/Players_Init.s"

    INCLUDE "TripleBuffer/DrawSprite.s" 
    INCLUDE "TripleBuffer/RestoreBg.s" 
    INCLUDE "TripleBuffer/SetActivePage.s" 
    INCLUDE "TripleBuffer/GetCurrentFrameAndGoToNext.s" 

Execute:
    ; init interrupt mode and stack pointer (in case the ROM isn't the first thing to be loaded)
	di                          ; disable interrupts
	im      1                   ; interrupt mode 1
    ld      sp, (BIOS_HIMEM)    ; init SP

    call    ClearRam

    ; PSG: silence
	call	BIOS_GICINI

    ; disable keyboard click
    xor     a
    ld 		(BIOS_CLIKSW), a     ; Key Press Click Switch 0:Off 1:On (1B/RW)

    call    EnableRomPage2

	; enable page 1
    ld	    a, 1
	ld	    (Seg_P8000_SW), a

    ; change to screen 5
    ld      a, 5
    call    BIOS_CHGMOD

    call    BIOS_DISSCR

    call    ClearVram_MSX2

    call    Set212Lines

    call    SetColor0ToNonTransparent

    call    DisableSprites


    
    ; load 32-byte palette data
    ld      hl, Palette
    call    LoadPalette

   
    ; --- Load background on all 4 pages

    ; SC 5 - page 0
    ld      a, 0000 0000 b
    ld      hl, 0x0000
    call    LoadImageTo_SC5_Page

    ; SC 5 - page 1
    ld      a, 0000 0000 b
    ld      hl, 0x8000
    call    LoadImageTo_SC5_Page

    ; SC 5 - page 2
    ld      a, 0000 0001 b
    ld      hl, 0x0000
    call    LoadImageTo_SC5_Page

    ; SC 5 - page 3
    ld      a, 0000 0001 b
    ld      hl, 0x8000
    call    LoadImageTo_SC5_Page








    call    BIOS_ENASCR

    ; ---- Triple buffer logic

    ; init vars
    ld      hl, Restore_BG_HMMM_Parameters
    ld      de, TripleBuffer_Vars_RestoreBG_HMMM_Command
    ld      bc, Restore_BG_HMMM_Parameters_size
    ldir

    xor     a
    ld      (TripleBuffer_Vars.Step), a



    call    Players_Init
    

Triple_Buffer_Loop:


    ; ---------------------------------------------------------------
    ; FPS counter

    ; if (Jiffy >= LastJiffy + 60) resetFpsCounter
    ld      hl, (Jiffy_Saved)
    ld      de, (BIOS_JIFFY)
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      nc, .doNotResetFpsCounter

    ; save current Jiffy + 60
    ex      de, hl  ; HL = DE
    ld      de, 60
    add     hl, de
    ld      (Jiffy_Saved), hl

    ; save last fps and reset fps counter
    ld      a, (CurrentCounter)
    ld      (LastFps), a

    xor     a
    ld      (CurrentCounter), a



.doNotResetFpsCounter:

    ld      hl, CurrentCounter
    inc     (hl)

    ; ---------------------------------------------------------------

    call    ReadInput

    ld      ix, Player_1_Vars
    call    Player_Logic

    ld      ix, Player_2_Vars
    call    Player_Logic

    ; -------

    ld      a, (TripleBuffer_Vars.Step)
    or      a
    jp      z, Triple_Buffer_Step_0 ; if(Step == 0) Triple_Buffer_Step_0();
    dec     a
    jp      z, Triple_Buffer_Step_1 ; else if(Step == 1) Triple_Buffer_Step_1();
    jp      Triple_Buffer_Step_2    ; else Triple_Buffer_Step_2();


;--------------------------------------------------------------------


    INCLUDE "TripleBuffer/TripleBuffer_Constants.s"

;--------------------------------------------------------------------

Triple_Buffer_Step_0:

    ; --- set active page 0
    ld      a, R2_PAGE_0
    call    SetActivePage





    ; ------ player 1
    
    ld      ix, Player_1_Vars

    ; restore bg on page 2 (first we trigger VDP command to get some parallel access to VRAM)
    ld      hl, Y_BASE_PAGE_2
    call    RestoreBg
    
    ; draw sprites on page 1
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_1
    ; ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2
    
    ld      ix, Player_2_Vars

    ; restore bg on page 2 (first we trigger VDP command to get some parallel access to VRAM)
    ld      hl, Y_BASE_PAGE_2
    call    RestoreBg
    
    ; draw sprites on page 1
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_1
    ; ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite





    ; --- update triple buffer vars
    ld      a, 1
    ld      (TripleBuffer_Vars.Step), a
    


    jp      Triple_Buffer_Loop


;--------------------------------------------------------------------
Triple_Buffer_Step_1:

    ; --- set active page 1
    ld      a, R2_PAGE_1
    call    SetActivePage






    ; ------ player 1

    ld      ix, Player_1_Vars

    ; restore bg on page 0
    ld      hl, Y_BASE_PAGE_0
    call    RestoreBg
    
    ; draw sprites on page 2
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_2
    ; ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 0
    ld      hl, Y_BASE_PAGE_0
    call    RestoreBg
    
    ; draw sprites on page 2
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_2
    ; ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite






    ; --- update triple buffer vars
    ld      a, 2
    ld      (TripleBuffer_Vars.Step), a
    
    jp      Triple_Buffer_Loop

;--------------------------------------------------------------------

Triple_Buffer_Step_2:

    ; --- set active page 2
    ld      a, R2_PAGE_2
    call    SetActivePage





    ; ------ player 1

    ld      ix, Player_1_Vars

    ; restore bg on page 1
    ld      hl, Y_BASE_PAGE_1
    call    RestoreBg
    
    ; draw sprites on page 0
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_0
    ; ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 1
    ld      hl, Y_BASE_PAGE_1
    call    RestoreBg
    
    ; draw sprites on page 0
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_0
    ; ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite





    ; --- update triple buffer vars
    xor     a
    ld      (TripleBuffer_Vars.Step), a
    
    jp      Triple_Buffer_Loop

;--------------------------------------------------------------------


; Input:
;   AHL: 17-bit VRAM address
LoadImageTo_SC5_Page:
	; enable megarom page with top of bg
    push    af
        ld	    a, MEGAROM_PAGE_BG_0
        ld	    (Seg_P8000_SW), a
    pop     af

    ; first 16kb (top 128 lines)
    push    af, hl
        call    SetVdp_Write
        ld      hl, Bg_Top
        ld      c, PORT_0
        ld      d, 0 + (Bg_Top.size / 256)
        ld      b, 0 ; 256 bytes
    .loop_10:    
        otir
        dec     d
        jp      nz, .loop_10
    pop     hl, af

	; enable megarom page with bottom of bg
    push    af
        ld	    a, MEGAROM_PAGE_BG_1
        ld	    (Seg_P8000_SW), a
    pop     af

    ; lines below 128
    ld      bc, 16 * 1024
    add     hl, bc

    call    SetVdp_Write
    ld      hl, Bg_Bottom
    ld      c, PORT_0
    ld      d, 0 + (Bg_Bottom.size / 256)
    ld      b, 0 ; 256 bytes
.loop_20:    
    otir
    dec     d
    jp      nz, .loop_20


    ret



Palette:
    INCBIN "Images/mk.pal"





; --------------------------------------------------------

Restore_BG_HMMM_Parameters:
.Source_X:   dw    0 	    ; Source X (9 bits)
.Source_Y:   dw    0        ; Source Y (10 bits)
.Destiny_X:  dw    0 	    ; Destiny X (9 bits)
.Destiny_Y:  dw    0 	    ; Destiny Y (10 bits)
.Cols:       dw    0        ; number of cols (9 bits)
.Lines:      dw    0        ; number of lines (10 bits)
.NotUsed:    db    0
.Options:    db    0        ; select destination memory and direction from base coordinate
.Command:    db    VDP_COMMAND_HMMM
Restore_BG_HMMM_Parameters_size: equ $ - Restore_BG_HMMM_Parameters

; ----------------------------------------------------------

; ------- All animation pointers

    INCLUDE "Data/scorpion/scorpion_all_animations.s"
    INCLUDE "Data/subzero/subzero_all_animations.s"



; ------- Animation frame headers

    ; ------------------------ Scorpion

    ; --- Left
    INCLUDE "Data/scorpion/stance/left/scorpion_stance_left_animation.s"
    INCLUDE "Data/scorpion/walking/left/scorpion_walking_left_animation.s"
    INCLUDE "Data/scorpion/walking/left/scorpion_walking_backwards_left_animation.s"
    INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_animation.s"

    ; --- Right
    ; INCLUDE "Data/scorpion/stance/right/scorpion_stance_right_animation.s"
    ; INCLUDE "Data/scorpion/walking/right/scorpion_walking_right_animation.s"
    ; INCLUDE "Data/scorpion/walking/right/scorpion_walking_backwards_right_animation.s"
    ; INCLUDE "Data/scorpion/jumping-up/right/scorpion_jumping_up_right_animation.s"



    ; ------------------------ Subzero

    ; --- Left
    ; INCLUDE "Data/subzero/stance/left/subzero_stance_left_animation.s"
    ; INCLUDE "Data/subzero/walking/left/subzero_walking_left_animation.s"
    ; INCLUDE "Data/subzero/walking/left/subzero_walking_backwards_left_animation.s"
    ; INCLUDE "Data/subzero/jumping-up/left/subzero_jumping_up_left_animation.s"

    ; --- Right
    INCLUDE "Data/subzero/stance/right/subzero_stance_right_animation.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_right_animation.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_backwards_right_animation.s"
    ; INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_animation.s"



    db      "End ROM started at 0x4000"

Page_0x4000_size: equ $ - Execute ; 0x033d

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF






; MegaROM pages at 0x8000
    INCLUDE "MegaRomPages.s"






; RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)

    INCLUDE "Variables.s"

