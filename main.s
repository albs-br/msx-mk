FNAME "msx-mk.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB
Seg_P8000_SW:	equ	0x7000	        ; Segment switch for page 0x8000-BFFFh (ASCII 16k Mapper)

; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"


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

    ; ------------ init player 1

    ld      hl, Scorpion_Stance_Left_Frame_0.List
    ld      (Player_1_Vars.CurrentFrame_List_Addr), hl

    ld      hl, Scorpion_Stance_Left_Frame_0.Data
    ld      (Player_1_Vars.CurrentFrame_Data_Addr), hl

    xor     a
    ld      (Player_1_Vars.Animation_Current_Frame_Number), a
    ld      hl, Scorpion_Stance_Left_Animation_List
    ld      (Player_1_Vars.Animation_CurrentFrame_List), hl
    ld      (Player_1_Vars.Animation_FirstFrame_List), hl
    ld      hl, Scorpion_Stance_Left_Animation_Data
    ld      (Player_1_Vars.Animation_CurrentFrame_Data), hl
    ld      (Player_1_Vars.Animation_FirstFrame_Data), hl



    ; TODO: get these values from frame header

    ld      a, MEGAROM_PAGE_SCORPION_DATA_0
    ld      (Player_1_Vars.CurrentFrame_MegaRomPage), a

    ld      a, 64 - (58/2)
    ld      (Player_1_Vars.Restore_BG_X), a
    ld      a, 100
    ld      (Player_1_Vars.Restore_BG_Y), a
    ld      a, 58
    ld      (Player_1_Vars.Restore_BG_WidthInPixels), a
    ld      a, 105
    ld      (Player_1_Vars.Restore_BG_HeightInPixels), a


    ld      hl, 0 + ((64 - (58/2))/2) + (128*100) ; column number 64 - (58/2); line number 100
    ld      (Player_1_Vars.VRAM_NAMTBL_Addr), hl


    ; ------------ init player 2

    ld      hl, Subzero_Stance_Right_Frame_0.List
    ld      (Player_2_Vars.CurrentFrame_List_Addr), hl

    ld      hl, Subzero_Stance_Right_Frame_0.Data
    ld      (Player_2_Vars.CurrentFrame_Data_Addr), hl

    xor     a
    ld      (Player_2_Vars.Animation_Current_Frame_Number), a
    ld      hl, Subzero_Stance_Right_Animation_List
    ld      (Player_2_Vars.Animation_CurrentFrame_List), hl
    ld      (Player_2_Vars.Animation_FirstFrame_List), hl
    ld      hl, Subzero_Stance_Right_Animation_Data
    ld      (Player_2_Vars.Animation_CurrentFrame_Data), hl
    ld      (Player_2_Vars.Animation_FirstFrame_Data), hl



    ; TODO: get these values from frame header

    ld      a, MEGAROM_PAGE_SUBZERO_DATA_0
    ld      (Player_2_Vars.CurrentFrame_MegaRomPage), a

    ld      a, 192 - (58/2)
    ld      (Player_2_Vars.Restore_BG_X), a
    ld      a, 100
    ld      (Player_2_Vars.Restore_BG_Y), a
    ld      a, 58
    ld      (Player_2_Vars.Restore_BG_WidthInPixels), a
    ld      a, 105
    ld      (Player_2_Vars.Restore_BG_HeightInPixels), a


    ld      hl, 0 + ((192 - (58/2))/2) + (128*100) ; column number 192 - (58/2); line number 100
    ld      (Player_2_Vars.VRAM_NAMTBL_Addr), hl


Triple_Buffer_Loop:

    ; call    Wait_VBlank

    ; -------
    ; ld      hl, (BIOS_JIFFY)
    ; ld      de, (Jiffy_FrameStart)
    ; xor     a
    ; sbc     hl, de
    ; ld      (Total_Frames), hl

    ; ld      hl, (BIOS_JIFFY)
    ; ld      (Jiffy_FrameStart), hl

    ; ld      hl, Frame_Counter
    ; inc     (hl)

    ; -------


    ld      a, (TripleBuffer_Vars.Step)
    or      a
    jp      z, Triple_Buffer_Step_0 ; if(Step == 0) Triple_Buffer_Step_0();
    dec     a
    jp      z, Triple_Buffer_Step_1 ; else if(Step == 1) Triple_Buffer_Step_1();
    jp      Triple_Buffer_Step_2    ; else Triple_Buffer_Step_2();


;--------------------------------------------------------------------
; Constants:
R2_PAGE_0:      equ 0001 1111 b     ; page 0 (0x00000)
R2_PAGE_1:      equ 0011 1111 b     ; page 1 (0x08000)
R2_PAGE_2:      equ 0101 1111 b     ; page 2 (0x10000)
R2_PAGE_3:      equ 0111 1111 b     ; page 3 (0x18000)

R14_PAGE_0:     equ 0000 0000 b ; page 0
R14_PAGE_1:     equ 0000 0010 b ; page 1
R14_PAGE_2:     equ 0000 0100 b ; page 2
R14_PAGE_3:     equ 0000 0110 b ; page 3

Y_BASE_PAGE_0:      equ 0   ; page 0
Y_BASE_PAGE_1:      equ 256 ; page 1
Y_BASE_PAGE_2:      equ 512 ; page 2
Y_BASE_PAGE_3:      equ 768 ; page 3

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
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2
    
    ld      ix, Player_2_Vars

    ; restore bg on page 2 (first we trigger VDP command to get some parallel access to VRAM)
    ld      hl, Y_BASE_PAGE_2
    call    RestoreBg
    
    ; draw sprites on page 1
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_1
    ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
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
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 0
    ld      hl, Y_BASE_PAGE_0
    call    RestoreBg
    
    ; draw sprites on page 2
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_2
    ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
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
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite



    ; ------ player 2

    ld      ix, Player_2_Vars

    ; restore bg on page 1
    ld      hl, Y_BASE_PAGE_1
    call    RestoreBg
    
    ; draw sprites on page 0
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_0
    ld      de, (Player_2_Vars.VRAM_NAMTBL_Addr)
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
.Source_X:   dw    0 	            ; Source X (9 bits)
.Source_Y:   dw    0 + (256*3)      ; Source Y (10 bits)
.Destiny_X:  dw    0 	    ; Destiny X (9 bits)
.Destiny_Y:  dw    0 	    ; Destiny Y (10 bits)
.Cols:       dw    58       ; number of cols (9 bits)
.Lines:      dw    105       ; number of lines (10 bits)
.NotUsed:    db    0
.Options:    db    0        ; select destination memory and direction from base coordinate
.Command:    db    VDP_COMMAND_HMMM
Restore_BG_HMMM_Parameters_size: equ $ - Restore_BG_HMMM_Parameters

; ----------------------------------------------------------


Scorpion_Stance_Left_Animation_List:
    dw Scorpion_Stance_Left_Frame_0.List, Scorpion_Stance_Left_Frame_0.List, Scorpion_Stance_Left_Frame_0.List
    dw Scorpion_Stance_Left_Frame_1.List, Scorpion_Stance_Left_Frame_1.List, Scorpion_Stance_Left_Frame_1.List
    dw Scorpion_Stance_Left_Frame_2.List, Scorpion_Stance_Left_Frame_2.List, Scorpion_Stance_Left_Frame_2.List
    dw Scorpion_Stance_Left_Frame_3.List, Scorpion_Stance_Left_Frame_3.List, Scorpion_Stance_Left_Frame_3.List
    dw Scorpion_Stance_Left_Frame_4.List, Scorpion_Stance_Left_Frame_4.List, Scorpion_Stance_Left_Frame_4.List
    dw Scorpion_Stance_Left_Frame_5.List, Scorpion_Stance_Left_Frame_5.List, Scorpion_Stance_Left_Frame_5.List
    dw Scorpion_Stance_Left_Frame_6.List, Scorpion_Stance_Left_Frame_6.List, Scorpion_Stance_Left_Frame_6.List
    dw 255 ; end of data

Scorpion_Stance_Left_Animation_Data:
    dw Scorpion_Stance_Left_Frame_0.Data, Scorpion_Stance_Left_Frame_0.Data, Scorpion_Stance_Left_Frame_0.Data
    dw Scorpion_Stance_Left_Frame_1.Data, Scorpion_Stance_Left_Frame_1.Data, Scorpion_Stance_Left_Frame_1.Data
    dw Scorpion_Stance_Left_Frame_2.Data, Scorpion_Stance_Left_Frame_2.Data, Scorpion_Stance_Left_Frame_2.Data
    dw Scorpion_Stance_Left_Frame_3.Data, Scorpion_Stance_Left_Frame_3.Data, Scorpion_Stance_Left_Frame_3.Data
    dw Scorpion_Stance_Left_Frame_4.Data, Scorpion_Stance_Left_Frame_4.Data, Scorpion_Stance_Left_Frame_4.Data
    dw Scorpion_Stance_Left_Frame_5.Data, Scorpion_Stance_Left_Frame_5.Data, Scorpion_Stance_Left_Frame_5.Data
    dw Scorpion_Stance_Left_Frame_6.Data, Scorpion_Stance_Left_Frame_6.Data, Scorpion_Stance_Left_Frame_6.Data
    dw 255 ; end of data



Subzero_Stance_Right_Animation_List:
    dw Subzero_Stance_Right_Frame_0.List, Subzero_Stance_Right_Frame_0.List, Subzero_Stance_Right_Frame_0.List
    dw Subzero_Stance_Right_Frame_1.List, Subzero_Stance_Right_Frame_1.List, Subzero_Stance_Right_Frame_1.List
    dw Subzero_Stance_Right_Frame_2.List, Subzero_Stance_Right_Frame_2.List, Subzero_Stance_Right_Frame_2.List
    dw Subzero_Stance_Right_Frame_3.List, Subzero_Stance_Right_Frame_3.List, Subzero_Stance_Right_Frame_3.List
    dw Subzero_Stance_Right_Frame_4.List, Subzero_Stance_Right_Frame_4.List, Subzero_Stance_Right_Frame_4.List
    dw Subzero_Stance_Right_Frame_5.List, Subzero_Stance_Right_Frame_5.List, Subzero_Stance_Right_Frame_5.List
    dw Subzero_Stance_Right_Frame_6.List, Subzero_Stance_Right_Frame_6.List, Subzero_Stance_Right_Frame_6.List
    dw Subzero_Stance_Right_Frame_7.List, Subzero_Stance_Right_Frame_7.List, Subzero_Stance_Right_Frame_7.List
    dw Subzero_Stance_Right_Frame_8.List, Subzero_Stance_Right_Frame_8.List, Subzero_Stance_Right_Frame_8.List
    dw 255 ; end of data
    ; dw Subzero_Stance_Right_Frame_9.List, Subzero_Stance_Right_Frame_9.List, Subzero_Stance_Right_Frame_9.List
    ; dw Subzero_Stance_Right_Frame_10.List, Subzero_Stance_Right_Frame_10.List, Subzero_Stance_Right_Frame_10.List
    ; dw Subzero_Stance_Right_Frame_11.List, Subzero_Stance_Right_Frame_11.List, Subzero_Stance_Right_Frame_11.List
    ; dw Subzero_Stance_Right_Frame_12.List, Subzero_Stance_Right_Frame_12.List, Subzero_Stance_Right_Frame_12.List
    ; dw 255 ; end of data

Subzero_Stance_Right_Animation_Data:
    dw Subzero_Stance_Right_Frame_0.Data, Subzero_Stance_Right_Frame_0.Data, Subzero_Stance_Right_Frame_0.Data
    dw Subzero_Stance_Right_Frame_1.Data, Subzero_Stance_Right_Frame_1.Data, Subzero_Stance_Right_Frame_1.Data
    dw Subzero_Stance_Right_Frame_2.Data, Subzero_Stance_Right_Frame_2.Data, Subzero_Stance_Right_Frame_2.Data
    dw Subzero_Stance_Right_Frame_3.Data, Subzero_Stance_Right_Frame_3.Data, Subzero_Stance_Right_Frame_3.Data
    dw Subzero_Stance_Right_Frame_4.Data, Subzero_Stance_Right_Frame_4.Data, Subzero_Stance_Right_Frame_4.Data
    dw Subzero_Stance_Right_Frame_5.Data, Subzero_Stance_Right_Frame_5.Data, Subzero_Stance_Right_Frame_5.Data
    dw Subzero_Stance_Right_Frame_6.Data, Subzero_Stance_Right_Frame_6.Data, Subzero_Stance_Right_Frame_6.Data
    dw Subzero_Stance_Right_Frame_7.Data, Subzero_Stance_Right_Frame_7.Data, Subzero_Stance_Right_Frame_7.Data
    dw Subzero_Stance_Right_Frame_8.Data, Subzero_Stance_Right_Frame_8.Data, Subzero_Stance_Right_Frame_8.Data
    dw 255 ; end of data
    ; dw Subzero_Stance_Right_Frame_9.Data, Subzero_Stance_Right_Frame_9.Data, Subzero_Stance_Right_Frame_9.Data
    ; dw Subzero_Stance_Right_Frame_10.Data, Subzero_Stance_Right_Frame_10.Data, Subzero_Stance_Right_Frame_10.Data
    ; dw Subzero_Stance_Right_Frame_11.Data, Subzero_Stance_Right_Frame_11.Data, Subzero_Stance_Right_Frame_11.Data
    ; dw Subzero_Stance_Right_Frame_12.Data, Subzero_Stance_Right_Frame_12.Data, Subzero_Stance_Right_Frame_12.Data
    ; dw 255 ; end of data


    db      "End ROM started at 0x4000"

Page_0x4000_size: equ $ - Execute ; 0x0216

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF






; MegaROM pages at 0x8000
    INCLUDE "MegaRomPages.s"






; RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)

    INCLUDE "Variables.s"

