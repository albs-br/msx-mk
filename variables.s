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


; TODO: finish

Player_Struct:
    .X:                                 equ Player_1_Vars.X                              - Player_1_Vars
    .Y:                                 equ Player_1_Vars.Y                              - Player_1_Vars
    .Width:                             equ Player_1_Vars.Width                          - Player_1_Vars
    .Height:                            equ Player_1_Vars.Height                         - Player_1_Vars
    .Animation_Current_Frame_Number:    equ Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars
    .Animation_CurrentFrame_Header:     equ Player_1_Vars.Animation_CurrentFrame_Header  - Player_1_Vars
    .Animation_FirstFrame_Header:       equ Player_1_Vars.Animation_FirstFrame_Header    - Player_1_Vars
    .VRAM_NAMTBL_Addr:                  equ Player_1_Vars.VRAM_NAMTBL_Addr               - Player_1_Vars
    .Restore_BG_X:                      equ Player_1_Vars.Restore_BG_X                   - Player_1_Vars
    .Restore_BG_Y:                      equ Player_1_Vars.Restore_BG_Y                   - Player_1_Vars
    .Restore_BG_WidthInPixels:          equ Player_1_Vars.Restore_BG_WidthInPixels       - Player_1_Vars
    .Restore_BG_HeightInPixels:         equ Player_1_Vars.Restore_BG_HeightInPixels      - Player_1_Vars
    .Side:                              equ Player_1_Vars.Side                           - Player_1_Vars
    .Position:                          equ Player_1_Vars.Position                       - Player_1_Vars
    .AllAnimations_Addr:                equ Player_1_Vars.AllAnimations_Addr             - Player_1_Vars

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