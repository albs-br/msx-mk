RamStart:


; ----------------------------

; Debug:
Jiffy_Saved:            rw 1
LastFps:                rb 1
CurrentCounter:         rb 1



; ----------------------------


OldSP:              rw 1
; Last_NAMTBL_Addr:   rw 1

Keyboard_Value:     rb 1

;   step      page            page drawing            page
;   value     active          sprites                 restoring bg
;   -----     -------         ---------------         ------------
;   0         0 x=100         1  x=102                2 x=100
;   1         1 x=102         2  x=104                0 x=102
;   2         2               0                       1
TripleBuffer_Vars:
    .Step:                  rb 1
    .R14_Value:             rb 1

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

Player_Struct:
    .X:                                 equ Player_1_Vars.X - Player_1_Vars
    ;TODO: continue

Player_1_Vars:
    .X:                                 rb 1
    .Y:                                 rb 1
    .Width:                             rb 1
    .Height:                            rb 1
    .Animation_Current_Frame_Number:    rb 1
    .Animation_CurrentFrame_Header:     rw 1
    .Animation_FirstFrame_Header:       rw 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_X:                      rb 1
    .Restore_BG_Y:                      rb 1
    .Restore_BG_WidthInPixels:          rb 1
    .Restore_BG_HeightInPixels:         rb 1
    .Side:                              rb 1
    .Position:                          rb 1
    .AllAnimations_Addr:                rw 1

Player_Struct_size: equ $ - Player_1_Vars



Player_2_Vars:
    ; rb Player_Struct_size
    .X:                                 rb 1
    .Y:                                 rb 1
    .Width:                             rb 1
    .Height:                            rb 1
    .Animation_Current_Frame_Number:    rb 1
    .Animation_CurrentFrame_Header:     rw 1
    .Animation_FirstFrame_Header:       rw 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_X:                      rb 1
    .Restore_BG_Y:                      rb 1
    .Restore_BG_WidthInPixels:          rb 1
    .Restore_BG_HeightInPixels:         rb 1
    .Side:                              rb 1
    .Position:                          rb 1
    .AllAnimations_Addr:                rw 1

; ----------------------------

; Constants:

SIDE:
    .LEFT:      equ 1
    .RIGHT:     equ 2

POSITION:
    .STANCE:                equ 0       ; these values will be used as offset from base AllAnimations_Addr
    .WALKING_FORWARD:       equ 2       ; so, position matter and there should be a step of 2 between each of them
    .WALKING_BACKWARDS:     equ 4



; ----------------------------



RamEnd: