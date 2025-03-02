FNAME "triple-buffer.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB
Seg_P8000_SW:	equ	0x7000	        ; Segment switch for page 0x8000-BFFFh (ASCII 16k Mapper)

; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

Execute:
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

    ld      hl, Frame_0.List
    ld      (Player_1_Vars.CurrentFrame_List_Addr), hl

    ld      hl, Frame_0.Data
    ld      (Player_1_Vars.CurrentFrame_Data_Addr), hl

    ld      hl, Player_1_Animation_List
    ld      (Player_1_Vars.Animation_CurrentFrame_List), hl
    ld      hl, Player_1_Animation_Data
    ld      (Player_1_Vars.Animation_CurrentFrame_Data), hl


    ld      a, 128 - (58/2)
    ld      (Player_1_Vars.Restore_BG_X), a
    ld      a, 100
    ld      (Player_1_Vars.Restore_BG_Y), a
    ld      a, 58
    ld      (Player_1_Vars.Restore_BG_WidthInPixels), a
    ld      a, 105
    ld      (Player_1_Vars.Restore_BG_HeightInPixels), a


    ld      hl, 0 + ((128 - (58/2))/2) + (128*100) ; column number 128 - (58/2); line number 100
    ; ld      hl, 0x0000
    ld      (Player_1_Vars.VRAM_NAMTBL_Addr), hl

    xor     a
    ld      (TripleBuffer_Vars.Step), a

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

    ; --- restore bg on page 2 (first we trigger VDP command to get some parallel access to VRAM)
    ld      hl, Y_BASE_PAGE_2
    call    RestoreBg
    
    ; --- draw sprites on page 1
    
    ; ;ld      hl, Frame_0.List
    ; ld      a, (Player_1_Vars.CurrentFrame_List_Addr)
    ; ld      l, a
    ; ld      a, (Player_1_Vars.CurrentFrame_List_Addr + 1)
    ; ld      h, a
    
    ; ;ld      ix, Frame_0.Data ; TODO: fix
    ; ld      a, (Player_1_Vars.CurrentFrame_Data_Addr)
    ; ld      ixl, a
    ; ld      a, (Player_1_Vars.CurrentFrame_Data_Addr + 1)
    ; ld      ixh, a
    
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_1
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
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

    ; --- restore bg on page 0
    ld      hl, Y_BASE_PAGE_0
    call    RestoreBg
    
    ; --- draw sprites on page 2
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_2
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
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

    ; --- restore bg on page 1
    ld      hl, Y_BASE_PAGE_1
    call    RestoreBg
    
    ; --- draw sprites on page 0
    call    GetCurrentFrameAndGoToNext
    
    ld      a, R14_PAGE_0
    ld      de, (Player_1_Vars.VRAM_NAMTBL_Addr)
    call    DrawSprite

    ; --- update triple buffer vars
    xor     a
    ld      (TripleBuffer_Vars.Step), a
    
    jp      Triple_Buffer_Loop

;--------------------------------------------------------------------

GetCurrentFrameAndGoToNext:

    ;ld      hl, Frame_0.List
    ld      hl, (Player_1_Vars.CurrentFrame_List_Addr)
    
    ;ld      ix, Frame_0.Data
    ld      ix, (Player_1_Vars.CurrentFrame_Data_Addr)


    
    ; go to next frame
    push    hl
        ld      hl, (Player_1_Vars.Animation_CurrentFrame_List)
        inc     hl
        inc     hl

        ld      de, (Player_1_Vars.Animation_CurrentFrame_Data)
        inc     de
        inc     de

        ld      a, (hl)
        or      a
        jp      z, .returnToFirstFrame

        jp      .continue
.returnToFirstFrame:
        ld      hl, Player_1_Animation_List
        ld      de, Player_1_Animation_Data

.continue:

        ; save new frame
        ld      (Player_1_Vars.Animation_CurrentFrame_List), hl
        ld      (Player_1_Vars.Animation_CurrentFrame_Data), de

        ; get value on addr pointed by HL
        ; Player_1_Vars.CurrentFrame_List_Addr = (HL)
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        ld      (Player_1_Vars.CurrentFrame_List_Addr), bc


        ; get value on addr pointed by DE
        ; Player_1_Vars.CurrentFrame_Data_Addr = (DE)
        ld      a, (de)
        ld      l, a
        inc     de
        ld      a, (de)
        ld      h, a
        ld      (Player_1_Vars.CurrentFrame_Data_Addr), hl

    pop     hl

    ret

;--------------------------------------------------------------------

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

;--------------------------------------------------------------------


; Input:
;   A: value of R#14 to set VDP to write/read VRAM (constants: R14_PAGE_n)
;   HL: addr of frame list
;   IX: addr of frame data
;   DE: VRAM NAMTBL addr position
DrawSprite:

    
    push    af, hl
        
        ; HL -= 5
        ld      bc, 5 ; frame header is 5 bytes before frame list
        xor     a
        sbc     hl, bc
        
        ; --- adjust VRAM NAMTBL address based on yOffset
        
        ; HL = (HL)
        ld      a, (hl)
        ld      c, a
        inc     hl
        ld      a, (hl)
        ld      h, a
        ld      l, c

        ; ---- DE -= HL
        add     hl, de ; HL = HL + DE
        ; DE = HL
        ex      de, hl
        

    pop     hl, af

    ld      (TripleBuffer_Vars.BaseDataAddr), ix

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
        ; push    ix
        ; pop     hl
        ld      hl, (TripleBuffer_Vars.BaseDataAddr)
        add     hl, de

        ; ld      c, PORT_0
        otir
    pop     hl
    jp      .loop


    ; ---

.endFrame:

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

; ----------


; Input:
;   HL: Y of base of page (constants: Y_BASE_PAGE_n)
RestoreBg:

    ; ; Destiny_Y = Y of base of page + Player.Restore_BG_Y
    ld      d, 0
    ld      a, (Player_1_Vars.Restore_BG_Y)
    ld      e, a
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_Y), hl

    
    ; X is the same for both source and destiny
    ld      h, 0
    ld      a, (Player_1_Vars.Restore_BG_X)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_X), hl
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_X), hl

    ; Source_Y is always on the page 3
    ; Source_Y = (256 * 3) + Player.Restore_BG_Y
    ld      h, 0
    ld      a, (Player_1_Vars.Restore_BG_Y)
    ld      l, a
    ld      de, 768
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_Y), hl


    ld      h, 0
    ld      a, (Player_1_Vars.Restore_BG_WidthInPixels)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Cols), hl

    ld      h, 0
    ld      a, (Player_1_Vars.Restore_BG_HeightInPixels)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Lines), hl

    ; .Source_X:   dw    0 	            ; Source X (9 bits)
    ; .Source_Y:   dw    0 + (256*3)      ; Source Y (10 bits)
    ; .Destiny_X:  dw    0 	    ; Destiny X (9 bits)
    ; .Destiny_Y:  dw    0 	    ; Destiny Y (10 bits)
    ; .Cols:       dw    58       ; number of cols (9 bits)
    ; .Lines:      dw    97       ; number of lines (10 bits)
    ; .NotUsed:    db    0
    ; .Options:    db    0        ; select destination memory and direction from base coordinate
    ; .Command:    db    VDP_COMMAND_HMMM




    ; set destiny_Y to value in HL
    ; ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_Y), hl

    ld      hl, TripleBuffer_Vars_RestoreBG_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM
    ret


; ----------

; Input:
;   AHL: 17-bit VRAM address
LoadImageTo_SC5_Page:
	; enable page 1
    push    af
        ld	    a, 1
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

	; enable page 2
    push    af
        ld	    a, 2
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

Player_1_Animation_List:
    dw Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List
    dw Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List
    dw Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List
    dw Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List
    dw Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List
    dw Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List
    dw Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List
    dw 0 ; end of data

Player_1_Animation_Data:
    dw Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data
    dw Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data
    dw Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data
    dw Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data
    dw Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data
    dw Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data
    dw Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data
    dw 0 ; end of data

; --- Slice index list
; increment in bytes, length in bytes, address of the slice on the Data

Frame_0:
    .Header:    INCLUDE "Images/scorpion_frame_0_header.s" ; dw yOffset; db width; db height; db MEgaROM page number
    .List:      INCLUDE "Images/scorpion_frame_0_list.s"
    .Data:      INCLUDE "Images/scorpion_frame_0_data.s"
Frame_1:
    .Header:    INCLUDE "Images/scorpion_frame_1_header.s"
    .List:  INCLUDE "Images/scorpion_frame_1_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_1_data.s"
Frame_2:
    .Header:    INCLUDE "Images/scorpion_frame_2_header.s"
    .List:  INCLUDE "Images/scorpion_frame_2_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_2_data.s"
Frame_3:
    .Header:    INCLUDE "Images/scorpion_frame_3_header.s"
    .List:  INCLUDE "Images/scorpion_frame_3_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_3_data.s"
Frame_4:
    .Header:    INCLUDE "Images/scorpion_frame_4_header.s"
    .List:  INCLUDE "Images/scorpion_frame_4_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_4_data.s"
Frame_5:
    .Header:    INCLUDE "Images/scorpion_frame_5_header.s"
    .List:  INCLUDE "Images/scorpion_frame_5_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_5_data.s"
Frame_6:
    .Header:    INCLUDE "Images/scorpion_frame_6_header.s"
    .List:  INCLUDE "Images/scorpion_frame_6_list.s"
    .Data:  INCLUDE "Images/scorpion_frame_6_data.s"

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



    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF








; MegaROM pages at 0x8000
; ------- Page 1
	org	0x8000, 0xBFFF
Bg_Top:
    INCBIN "Images/mk-bg-top.sc5"
.size:      equ $ - Bg_Top
	ds PageSize - ($ - 0x8000), 255

; ------- Page 2
	org	0x8000, 0xBFFF
Bg_Bottom:
    INCBIN "Images/mk-bg-bottom.sc5"
.size:      equ $ - Bg_Bottom
	ds PageSize - ($ - 0x8000), 255



; RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)

Last_NAMTBL_Addr:   rw 1

;   step      page            page drawing            page
;   value     active          sprites                 restoring bg
;   -----     -------         ---------------         ------------
;   0         0               1                       2
;   1         1               2                       0
;   2         2               0                       1
TripleBuffer_Vars:
    .Step:                  rb 1
    .BaseDataAddr:          rw 1
    .R14_Value:             rb 1
    ; .PageActive:            rb 1
    ; .PageDrawingSprites:    rb 1
    ; .PageRefreshingBg_Y_Base:   rw 1    ; page 0: 0;    page 1: 256;    page 2: 512

TripleBuffer_Vars_RestoreBG_HMMM_Command:
    .Source_X:   rw 1
    .Source_Y:   rw 1
    .Destiny_X:  rw 1
    .Destiny_Y:  rw 1
    .Cols:       rw 1
    .Lines:      rw 1
    .NotUsed:    rb 1
    .Options:    rb 1
    .Command:    rb 1


; ----------------------------
Player_1_Vars:
    .Animation_CurrentFrame_List:       rw 1
    .Animation_CurrentFrame_Data:       rw 1
    .CurrentFrame_List_Addr:            rw 1
    .CurrentFrame_Data_Addr:            rw 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_X:                      rb 1
    .Restore_BG_Y:                      rb 1
    .Restore_BG_WidthInPixels:          rb 1
    .Restore_BG_HeightInPixels:         rb 1

; ;frame data
; ;.frame_data_slices:     rb (Frame_Data_Slice.size) * 256



; ; ----------------------------

; Debug:
Jiffy_FrameStart:   rw 1
Total_Frames:       rw 1
Frame_Counter:      rb 1


; ; for each slice:
; Frame_Data_Slice:
; .offset:    rb 1 ; offset in bytes from top left of frame/last slice start
; .length:    rb 1 ; length in bytes (can be changed to pointer to unrolled OUTI's)
; .address:   rw 1 ; address of bytes to be plotted to screen

; .size: $ - Frame_Data_Slice