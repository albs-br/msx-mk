FNAME "msx-mk.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB
Seg_P8000_SW:	equ	0x7000	        ; Segment switch for page 0x8000-BFFFh (ASCII 16k Mapper)

; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

    INCLUDE "Include/dzx0_standard.asm"

    INCLUDE "GameLogic/ReadInput.s"
    INCLUDE "GameLogic/Player_Logic.s"
    INCLUDE "GameLogic/Players_Init.s"
    INCLUDE "GameLogic/CheckCollision.s"

    INCLUDE "TripleBuffer/DrawSprite.s" 
    INCLUDE "TripleBuffer/RestoreBg.s" 
    INCLUDE "TripleBuffer/SetActivePage.s" 
    INCLUDE "TripleBuffer/GetCurrentFrameAndGoToNext.s"
    INCLUDE "TripleBuffer/DrawHurtAndHitBox.s"

    INCLUDE "Screens/TitleScreen.s"
    INCLUDE "Screens/ChooseFighterScreen.s"

    INCLUDE "Sounds/OPL4.s"

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



    ; call    TitleScreen ; [debug]



    ; call    ChooseFighterScreen ; [debug]



    ; -------------- Init Gameplay

    call    BIOS_DISSCR

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

   
    ; --- Load background on page 3, finish and copy it to the ther pages

    ; ; SC 5 - page 0
    ; ld      a, 0000 0000 b
    ; ld      hl, 0x0000
    ; call    LoadImageTo_SC5_Page

    ; ; SC 5 - page 1
    ; ld      a, 0000 0000 b
    ; ld      hl, 0x8000
    ; call    LoadImageTo_SC5_Page

    ; ; SC 5 - page 2
    ; ld      a, 0000 0001 b
    ; ld      hl, 0x0000
    ; call    LoadImageTo_SC5_Page

    ; SC 5 - page 3
    ld      a, 0000 0001 b
    ld      hl, 0x8000
    call    LoadImageTo_SC5_Page



    call    DrawLifeBars


    ; copy screen from page 3 after finished to pages 0, 1 and 2
    call    CopyFromPage3ToOthers


    call    OPL4_Init


    call    BIOS_ENASCR

    ; ---- Triple buffer logic

    ; init vars
    ld      hl, VDP_Cmd_HMMM_Parameters
    ld      de, TripleBuffer_Vars_RestoreBG_HMMM_Command
    ld      bc, VDP_Cmd_HMMM_Parameters_size
    ldir

    ld      hl, LINE_Parameters
    ld      de, TripleBuffer_Vars_LINE_Command
    ld      bc, LINE_Parameters_size
    ldir

    xor     a
    ld      (TripleBuffer_Vars.Step), a
    ld      (IsDebugModeActivated), a


    call    Players_Init
    

Triple_Buffer_Loop:


    ; ---------------------------------------------------------------
    ; FPS counter

    ; if (Jiffy >= LastJiffy + 60) resetFpsCounter
    ld      hl, (Jiffy_Saved)
    ld      de, (BIOS_JIFFY)
    rst     BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE); Destroys A
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

    call    CheckCollision_Hurtboxes
    call    CheckCollision_Hitboxes
    
  

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
    ld      hl, Y_BASE_PAGE_1
    call    DrawSprite



    ; ------ player 2
    
    ld      ix, Player_2_Vars

    ; restore bg on page 2 (first we trigger VDP command to get some parallel access to VRAM)
    ld      hl, Y_BASE_PAGE_2
    call    RestoreBg
    
    ; draw sprites on page 1
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_1
    ld      hl, Y_BASE_PAGE_1
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
    ld      hl, Y_BASE_PAGE_2
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 0
    ld      hl, Y_BASE_PAGE_0
    call    RestoreBg
    
    ; draw sprites on page 2
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_2
    ld      hl, Y_BASE_PAGE_2
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
    ld      hl, Y_BASE_PAGE_0
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 1
    ld      hl, Y_BASE_PAGE_1
    call    RestoreBg
    
    ; draw sprites on page 0
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_0
    ld      hl, Y_BASE_PAGE_0
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
        ld	    a, MEGAROM_PAGE_BG_GOROS_LAIR_0
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
        ld	    a, MEGAROM_PAGE_BG_GOROS_LAIR_1
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



; --------------------------------------------------
; Input:
;   A:  Number of MegaROM page
;   HL: Addr of ZX0 file
;   DE: 17-bit VRAM address
Decompress_ZX0_8kb_and_Load_SC8:
    
    ld	    (Seg_P8000_SW), a   ; set MegaROM page

    push    de
        ; decompress zx0 file using standard decompressor
        ;ld      hl, Bg_Choose_Fighter_Screen_Part_0
        ld      de, UncompressedData
        call    dzx0_standard
    pop     de

NAMTBL_SC8:     equ 0x00000

    ; load uncompressed data to screen     
    ld		hl, UncompressedData   			        ; RAM address (source)
    ld      a, 0                                    ; VRAM address (destiny, bit 16)
    ;ld		de, NAMTBL_SC8                          ; VRAM address (destiny, bits 15-0)
    ld		c, 0 + (UncompressedData.size / 256)    ; Block length * 256
    call    LDIRVM_MSX2    
    
    ret


; --------------------------------------------------

Palette:
    INCBIN "Images/mk.pal"
; TODO: change color 4 of the bg to color 0, so this color 4 can be used to red (blood/lifebars)


; ----- bg palette usage (goro's lair scenario):

; Size: 30336 bytes
; Number of pixels: 60608
; Lines: 236.75
; Color 0: 21097 pixels (34.81%)
; Color 1: 10569 pixels (17.44%)
; Color 2: 5606 pixels (9.25%)
; Color 3: 8056 pixels (13.29%)
; Color 4: 5129 pixels (8.46%)
; Color 5: 2002 pixels (3.30%)
; Color 6: 4495 pixels (7.42%)
; Color 7: 861 pixels (1.42%)
; Color 8: 878 pixels (1.45%)
; Color 9: 1490 pixels (2.46%)
; Color 10: 214 pixels (0.35%)
; Color 11: 0 pixels (0.00%)        scorpion/subzero
; Color 12: 6 pixels (0.01%)        scorpion/subzero/lifebars
; Color 13: 0 pixels (0.00%)        subzero
; Color 14: 203 pixels (0.33%)      scorpion/subzero
; Color 15: 2 pixels (0.00%)        scorpion/lifebars/eyes on cave
; Unique colors: 14


; --------------------------------------------------------

; size: 90x12 pixels
; left bar position: 23, 31

LeftBar:
    .X:             equ 11 ; 22/2
    .Y:             equ 14
    .size:          equ 45

; Color:
;     .Yellow_Green:    equ 0xf7
;     .Double_Yellow:   equ 0xff
;     .Double_Green:    equ 0x77
;     .Double_Red:      equ 0x44

; LifeBar_Line_Yellow: 
;     db  Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow
;     db  Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow
;     db  Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow
;     db  Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow
;     db  Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow, Color.Double_Yellow

; LifeBar_Line_Middle: 
;     db  Color.Yellow_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green
;     db  Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green
;     db  Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green
;     db  Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green
;     db  Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green
;     db  Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green, Color.Double_Green

DrawLifeBars:

    ; --- put base image of bars on bottom of page 3
    ld	    a, MEGAROM_PAGE_LIFEBARS
    ld	    (Seg_P8000_SW), a

    ld      a, 0 + (((1024 - (256-212)) * 128) AND 0x10000) >> 16  ; bit 16 of VRAM addr
    ld      hl, 0 + ((1024 - (256-212)) * 128) AND 0x0ffff         ; bits 0-15 of VRAM addr
    call    SetVdp_Write
    ld      hl, Lifebars_SC5
    ld      c, PORT_0
    ld      de, 0 + (Lifebars_SC5_size)
    xor     a
.loop:    
    outi
    dec     de
    cp      e
    jp      nz, .loop
    cp      d
    jp      nz, .loop


    ; --- copy to screen on page 3 (restore bg screen) using vdp cmd
    ld      hl, VDP_Cmd_HMMM_Parameters
    ld      de, Parameters_HMMM_Command
    ld      bc, VDP_Cmd_HMMM_Parameters_size
    ldir

    ; left lifebar
    ld      hl, 0
    ld      (Parameters_HMMM_Command.Source_X), hl

    ld      hl, Y_BASE_PAGE_3 + 212
    ld      (Parameters_HMMM_Command.Source_Y), hl

    ld      hl, 23
    ld      (Parameters_HMMM_Command.Destiny_X), hl

    ld      hl, Y_BASE_PAGE_3 + 16 ; 31
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, 90
    ld      (Parameters_HMMM_Command.Cols), hl

    ld      hl, 12
    ld      (Parameters_HMMM_Command.Lines), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM


    ; right lifebar
    ld      hl, 255 - 23 - 90
    ld      (Parameters_HMMM_Command.Destiny_X), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM


    ; subzero over right lifebar: 90, 0; w: 48, h: 10
    ld      hl, 90
    ld      (Parameters_HMMM_Command.Source_X), hl

    ld      hl, Y_BASE_PAGE_3 + 212
    ld      (Parameters_HMMM_Command.Source_Y), hl

    ld      hl, 255 - 23 - 48 - 5
    ld      (Parameters_HMMM_Command.Destiny_X), hl

    ld      hl, Y_BASE_PAGE_3 + 16 + 1
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, 48
    ld      (Parameters_HMMM_Command.Cols), hl

    ld      hl, 10
    ld      (Parameters_HMMM_Command.Lines), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM



    ; scorpion over left lifebar: 90, 0; w: 46, h: 10
    ld      hl, 140
    ld      (Parameters_HMMM_Command.Source_X), hl

    ld      hl, Y_BASE_PAGE_3 + 212
    ld      (Parameters_HMMM_Command.Source_Y), hl

    ld      hl, 23 + 5
    ld      (Parameters_HMMM_Command.Destiny_X), hl

    ld      hl, Y_BASE_PAGE_3 + 16 + 1
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, 46
    ld      (Parameters_HMMM_Command.Cols), hl

    ld      hl, 10
    ld      (Parameters_HMMM_Command.Lines), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM


    ret

CopyFromPage3ToOthers:

    ; --- Copy entire screen form page 3 to page 0
    ld      hl, 0
    ld      (Parameters_HMMM_Command.Source_X), hl

    ld      hl, Y_BASE_PAGE_3
    ld      (Parameters_HMMM_Command.Source_Y), hl

    ld      hl, 0
    ld      (Parameters_HMMM_Command.Destiny_X), hl

    ld      hl, Y_BASE_PAGE_0
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, 256
    ld      (Parameters_HMMM_Command.Cols), hl

    ld      hl, 212
    ld      (Parameters_HMMM_Command.Lines), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM



    ; --- Copy entire screen form page 3 to page 1
    ld      hl, Y_BASE_PAGE_1
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM



    ; --- Copy entire screen form page 3 to page 2
    ld      hl, Y_BASE_PAGE_2
    ld      (Parameters_HMMM_Command.Destiny_Y), hl

    ld      hl, Parameters_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM

    ret




; --------------------------------------------------------

VDP_Cmd_HMMM_Parameters:
    .Source_X:   dw    0 	    ; Source X (9 bits)
    .Source_Y:   dw    0        ; Source Y (10 bits)
    .Destiny_X:  dw    0 	    ; Destiny X (9 bits)
    .Destiny_Y:  dw    0 	    ; Destiny Y (10 bits)
    .Cols:       dw    0        ; number of cols (9 bits)
    .Lines:      dw    0        ; number of lines (10 bits)
    .NotUsed:    db    0
    .Options:    db    0        ; select destination memory and direction from base coordinate
    .Command:    db    VDP_COMMAND_HMMM
VDP_Cmd_HMMM_Parameters_size: equ $ - VDP_Cmd_HMMM_Parameters



LINE_Parameters:
    .Start_X:    dw    0      ; Starting point X (9 bits)
    .Start_Y:    dw    0      ; Starting point Y (10 bits)
    .LongSide:   dw    0      ; long side (9 bits)
    .ShortSide:  dw    0      ; short side (10 bits)
    .Color:      db    15     ; 4 bits (G4, G5), 2 bits (G6), 8 bits (G7)
    .Options:    db    0000 0000 b     ; bit 0: defines short and long side
    .Command:    db    VDP_COMMAND_LINE
LINE_Parameters_size: equ $ - LINE_Parameters





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
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_animation.s"
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_backwards_left_animation.s"
    INCLUDE "Data/scorpion/kick/left/scorpion_low_kick_left_animation.s"
    INCLUDE "Data/scorpion/kick/left/scorpion_high_kick_left_animation.s"
    INCLUDE "Data/scorpion/block/left/scorpion_block_left_animation.s"
    INCLUDE "Data/scorpion/crouching/left/scorpion_crouching_left_animation.s"
    INCLUDE "Data/scorpion/crouching-block/left/scorpion_crouching_block_left_animation.s"
    ; INCLUDE "Data/scorpion/hurt-1/left/scorpion_hurt_1_left_animation.s"
    INCLUDE "Data/scorpion/uppercut/left/scorpion_uppercut_left_animation.s"

    ; --- Right
    ; INCLUDE "Data/scorpion/stance/right/scorpion_stance_right_animation.s"
    ; INCLUDE "Data/scorpion/walking/right/scorpion_walking_right_animation.s"
    ; INCLUDE "Data/scorpion/walking/right/scorpion_walking_backwards_right_animation.s"
    ; INCLUDE "Data/scorpion/jumping-up/right/scorpion_jumping_up_right_animation.s"
    ; INCLUDE "Data/scorpion/jumping-forward/right/scorpion_jumping_forward_right_animation.s"
    ; INCLUDE "Data/scorpion/jumping-forward/right/scorpion_jumping_backwards_right_animation.s"
    ; INCLUDE "Data/scorpion/kick/right/scorpion_low_kick_right_animation.s"
    ; INCLUDE "Data/scorpion/kick/right/scorpion_high_kick_right_animation.s"
    ; INCLUDE "Data/scorpion/block/right/scorpion_block_right_animation.s"
    ; INCLUDE "Data/scorpion/crouching/right/scorpion_crouching_right_animation.s"
    ; INCLUDE "Data/scorpion/crouching-block/right/scorpion_crouching_block_right_animation.s"
    ; INCLUDE "Data/scorpion/hurt-1/right/scorpion_hurt_1_right_animation.s"
    ; INCLUDE "Data/scorpion/uppercut/right/scorpion_uppercut_right_animation.s"



    ; ------------------------ Subzero

    ; --- Left
    ; INCLUDE "Data/subzero/stance/left/subzero_stance_left_animation.s"
    ; INCLUDE "Data/subzero/walking/left/subzero_walking_left_animation.s"
    ; INCLUDE "Data/subzero/walking/left/subzero_walking_backwards_left_animation.s"
    ; INCLUDE "Data/subzero/jumping-up/left/subzero_jumping_up_left_animation.s"
    ; INCLUDE "Data/subzero/jumping-forward/left/subzero_jumping_forward_left_animation.s"
    ; INCLUDE "Data/subzero/jumping-forward/left/subzero_jumping_backwards_left_animation.s"
    ; INCLUDE "Data/subzero/kick/left/subzero_low_kick_left_animation.s"
    ; INCLUDE "Data/subzero/kick/left/subzero_high_kick_left_animation.s"
    ; INCLUDE "Data/subzero/block/left/subzero_block_left_animation.s"
    ; INCLUDE "Data/subzero/crouching/left/subzero_crouching_left_animation.s"
    ; INCLUDE "Data/subzero/crouching-block/left/subzero_crouching_block_left_animation.s"
    ; INCLUDE "Data/subzero/hurt-1/left/subzero_hurt_1_left_animation.s"
    ; INCLUDE "Data/subzero/uppercut/left/subzero_uppercut_left_animation.s"

    ; --- Right
    INCLUDE "Data/subzero/stance/right/subzero_stance_right_animation.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_right_animation.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_backwards_right_animation.s"
    INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_animation.s"
    INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_animation.s"
    INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_backwards_right_animation.s"
    ; INCLUDE "Data/subzero/kick/right/subzero_low_kick_right_animation.s"
    ; INCLUDE "Data/subzero/kick/right/subzero_high_kick_right_animation.s"
    ; INCLUDE "Data/subzero/block/right/subzero_block_right_animation.s"
    ; INCLUDE "Data/subzero/crouching/right/subzero_crouching_right_animation.s"
    ; INCLUDE "Data/subzero/crouching-block/right/subzero_crouching_block_right_animation.s"
    INCLUDE "Data/subzero/hurt-1/right/subzero_hurt_1_right_animation.s"
    ; INCLUDE "Data/subzero/uppercut/right/subzero_uppercut_right_animation.s"



    db      "End ROM started at 0x4000"

Page_0x4000_size: equ $ - Execute ; 0x04ba

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF






; -----------------------------------------------------------------

; MegaROM pages at 0x8000

    INCLUDE "MegaRomPages.s"




; -----------------------------------------------------------------

; RAM

	; org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)

    INCLUDE "Variables.s"


; -----------------------------------------------------------------
