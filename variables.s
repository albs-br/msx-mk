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

;   step      page         page              page drawing         value saved to  value saved to      
;   value     active       restoring bg      sprites              restore bg 0    restore bg 1      
;   -----     ---------    ------------      ---------------      --------------  --------------      
;   0         0  x=100     2  x=98           1  x=102             x=102           x=100               after DrawSprites: RestoreBG_1 = RestoreBG_0; RestoreBG_0 = current
;   1         1  x=102     0  x=100          2  x=104             x=104           x=102               RestoreBG uses RestoreBG_1
;   2         2  x=104     1  x=102          0  x=106             x=106           x=104                 
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
    .X:                                 equ Player_1_Vars.X                              - Player_1_Vars
    .Y:                                 equ Player_1_Vars.Y                              - Player_1_Vars
    .Width:                             equ Player_1_Vars.Width                          - Player_1_Vars
    .Height:                            equ Player_1_Vars.Height                         - Player_1_Vars
    .Animation_Current_Frame_Number:    equ Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars
    .Animation_CurrentFrame_Header:     equ Player_1_Vars.Animation_CurrentFrame_Header  - Player_1_Vars
    .Animation_FirstFrame_Header:       equ Player_1_Vars.Animation_FirstFrame_Header    - Player_1_Vars
    .VRAM_NAMTBL_Addr:                  equ Player_1_Vars.VRAM_NAMTBL_Addr               - Player_1_Vars
    .Restore_BG_0_X:                    equ Player_1_Vars.Restore_BG_0_X                 - Player_1_Vars
    .Restore_BG_0_Y:                    equ Player_1_Vars.Restore_BG_0_Y                 - Player_1_Vars
    .Restore_BG_0_WidthInPixels:        equ Player_1_Vars.Restore_BG_0_WidthInPixels     - Player_1_Vars
    .Restore_BG_0_HeightInPixels:       equ Player_1_Vars.Restore_BG_0_HeightInPixels    - Player_1_Vars
    .Restore_BG_1_X:                    equ Player_1_Vars.Restore_BG_1_X                 - Player_1_Vars
    .Restore_BG_1_Y:                    equ Player_1_Vars.Restore_BG_1_Y                 - Player_1_Vars
    .Restore_BG_1_WidthInPixels:        equ Player_1_Vars.Restore_BG_1_WidthInPixels     - Player_1_Vars
    .Restore_BG_1_HeightInPixels:       equ Player_1_Vars.Restore_BG_1_HeightInPixels    - Player_1_Vars
    .Side:                              equ Player_1_Vars.Side                           - Player_1_Vars
    .Position:                          equ Player_1_Vars.Position                       - Player_1_Vars
    .IsGrounded:                        equ Player_1_Vars.IsGrounded                     - Player_1_Vars
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
    .Restore_BG_0_X:                    rb 1 ; restore bg 0 gets the frame n - 1
    .Restore_BG_0_Y:                    rb 1
    .Restore_BG_0_WidthInPixels:        rb 1
    .Restore_BG_0_HeightInPixels:       rb 1
    .Restore_BG_1_X:                    rb 1 ; restore bg 1 gets the frame n - 2 (the one that will be used to restore bg)
    .Restore_BG_1_Y:                    rb 1
    .Restore_BG_1_WidthInPixels:        rb 1
    .Restore_BG_1_HeightInPixels:       rb 1
    .Side:                              rb 1
    .Position:                          rb 1
    .IsGrounded:                        rb 1
    .AllAnimations_Addr:                rw 1

Player_Struct_size: equ $ - Player_1_Vars



Player_2_Vars:
    rb Player_Struct_size
    ; .X:                                 rb 1
    ; .Y:                                 rb 1
    ; .Width:                             rb 1
    ; .Height:                            rb 1
    ; .Animation_Current_Frame_Number:    rb 1
    ; .Animation_CurrentFrame_Header:     rw 1
    ; .Animation_FirstFrame_Header:       rw 1
    ; .VRAM_NAMTBL_Addr:                  rw 1
    ; .Restore_BG_X:                      rb 1
    ; .Restore_BG_Y:                      rb 1
    ; .Restore_BG_WidthInPixels:          rb 1
    ; .Restore_BG_HeightInPixels:         rb 1
    ; .Side:                              rb 1
    ; .Position:                          rb 1
    ; .AllAnimations_Addr:                rw 1

; ----------------------------

; Constants:

SIDE:
    .LEFT:      equ 1
    .RIGHT:     equ 2

POSITION:
    .STANCE:                equ 0       ; these values will be used as offset from base AllAnimations_Addr
    .WALKING_FORWARD:       equ 2       ; so, position matter and there should be a step of 2 between each of them
    .WALKING_BACKWARDS:     equ 4
    .JUMPING_UP:            equ 6



; ----------------------------



RamEnd: