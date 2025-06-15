RamStart:


; ----------------------------



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


; TripleBuffer_Vars_LINE_Command:
;     .Source_X:   rw 1
;     .Source_Y:   rw 1
;     .Destiny_X:  rw 1
;     .Destiny_Y:  rw 1
;     .Cols:       rw 1
;     .Lines:      rw 1
;     .NotUsed:    rb 1
;     .Options:    rb 1
;     .Command:    rb 1

; ----------------------------

Object_Struct:
    .X:                                 equ 0
    .Y:                                 equ 1
    .Width:                             equ 2
    .Height:                            equ 3



Player_Struct:
    .X:                                 equ Player_1_Vars.X                              - Player_1_Vars
    .Y:                                 equ Player_1_Vars.Y                              - Player_1_Vars
    .Width:                             equ Player_1_Vars.Width                          - Player_1_Vars
    .Height:                            equ Player_1_Vars.Height                         - Player_1_Vars
    .HurtBox:                           equ Player_1_Vars.HurtBox                        - Player_1_Vars
        .HurtBox_X:                     equ Player_1_Vars.HurtBox_X                      - Player_1_Vars
        .HurtBox_Y:                     equ Player_1_Vars.HurtBox_Y                      - Player_1_Vars
        .HurtBox_Width:                 equ Player_1_Vars.HurtBox_Width                  - Player_1_Vars
        .HurtBox_Height:                equ Player_1_Vars.HurtBox_Height                 - Player_1_Vars
    .HitBox:                            equ Player_1_Vars.HitBox                         - Player_1_Vars
        .HitBox_X:                      equ Player_1_Vars.HitBox_X                       - Player_1_Vars
        .HitBox_Y:                      equ Player_1_Vars.HitBox_Y                       - Player_1_Vars
        .HitBox_Width:                  equ Player_1_Vars.HitBox_Width                   - Player_1_Vars
        .HitBox_Height:                 equ Player_1_Vars.HitBox_Height                  - Player_1_Vars
    .Animation_Current_Frame_Number:    equ Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars
    .Animation_CurrentFrame_Header:     equ Player_1_Vars.Animation_CurrentFrame_Header  - Player_1_Vars
    .Animation_FirstFrame_Header:       equ Player_1_Vars.Animation_FirstFrame_Header    - Player_1_Vars
    .VRAM_NAMTBL_Addr:                  equ Player_1_Vars.VRAM_NAMTBL_Addr               - Player_1_Vars
    .Restore_BG_0:                      equ Player_1_Vars.Restore_BG_0                   - Player_1_Vars
        .Restore_BG_0_X:                equ Player_1_Vars.Restore_BG_0_X                 - Player_1_Vars
        .Restore_BG_0_Y:                equ Player_1_Vars.Restore_BG_0_Y                 - Player_1_Vars
        .Restore_BG_0_WidthInPixels:    equ Player_1_Vars.Restore_BG_0_WidthInPixels     - Player_1_Vars
        .Restore_BG_0_HeightInPixels:   equ Player_1_Vars.Restore_BG_0_HeightInPixels    - Player_1_Vars
    .Restore_BG_1:                      equ Player_1_Vars.Restore_BG_1                   - Player_1_Vars
        .Restore_BG_1_X:                equ Player_1_Vars.Restore_BG_1_X                 - Player_1_Vars
        .Restore_BG_1_Y:                equ Player_1_Vars.Restore_BG_1_Y                 - Player_1_Vars
        .Restore_BG_1_WidthInPixels:    equ Player_1_Vars.Restore_BG_1_WidthInPixels     - Player_1_Vars
        .Restore_BG_1_HeightInPixels:   equ Player_1_Vars.Restore_BG_1_HeightInPixels    - Player_1_Vars
    .Side:                              equ Player_1_Vars.Side                           - Player_1_Vars
    .Position:                          equ Player_1_Vars.Position                       - Player_1_Vars
    .IsGrounded:                        equ Player_1_Vars.IsGrounded                     - Player_1_Vars
    .IsAnimating:                       equ Player_1_Vars.IsAnimating                    - Player_1_Vars
    .IsBlocking:                        equ Player_1_Vars.IsBlocking                     - Player_1_Vars
    .IsCrouching:                       equ Player_1_Vars.IsCrouching                    - Player_1_Vars
    .AllAnimations_Addr:                equ Player_1_Vars.AllAnimations_Addr             - Player_1_Vars

Player_1_Vars:
    .X:                                 rb 1
    .Y:                                 rb 1
    .Width:                             rb 1
    .Height:                            rb 1
    .HurtBox:
        .HurtBox_X:                     rb 1
        .HurtBox_Y:                     rb 1
        .HurtBox_Width:                 rb 1
        .HurtBox_Height:                rb 1
    .HitBox:
        .HitBox_X:                      rb 1
        .HitBox_Y:                      rb 1
        .HitBox_Width:                  rb 1
        .HitBox_Height:                 rb 1
    .Animation_Current_Frame_Number:    rb 1
    .Animation_CurrentFrame_Header:     rw 1
    .Animation_FirstFrame_Header:       rw 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_0:
        .Restore_BG_0_X:                rb 1 ; restore bg 0 gets the frame n - 1
        .Restore_BG_0_Y:                rb 1
        .Restore_BG_0_WidthInPixels:    rb 1
        .Restore_BG_0_HeightInPixels:   rb 1
    .Restore_BG_1:
        .Restore_BG_1_X:                rb 1 ; restore bg 1 gets the frame n - 2 (the one that will be used to restore bg)
        .Restore_BG_1_Y:                rb 1
        .Restore_BG_1_WidthInPixels:    rb 1
        .Restore_BG_1_HeightInPixels:   rb 1
    .Side:                              rb 1
    .Position:                          rb 1
    .IsGrounded:                        rb 1
    .IsAnimating:                       rb 1
    .IsBlocking:                        rb 1
    .IsCrouching:                       rb 1
    .AllAnimations_Addr:                rw 1

Player_Struct_size: equ $ - Player_1_Vars



Player_2_Vars:
    .X:                                 rb 1
    .Y:                                 rb 1
    .Width:                             rb 1
    .Height:                            rb 1
    .HurtBox:
        .HurtBox_X:                     rb 1
        .HurtBox_Y:                     rb 1
        .HurtBox_Width:                 rb 1
        .HurtBox_Height:                rb 1
    .HitBox:
        .HitBox_X:                      rb 1
        .HitBox_Y:                      rb 1
        .HitBox_Width:                  rb 1
        .HitBox_Height:                 rb 1
    .Animation_Current_Frame_Number:    rb 1
    .Animation_CurrentFrame_Header:     rw 1
    .Animation_FirstFrame_Header:       rw 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_0:
        .Restore_BG_0_X:                rb 1 ; restore bg 0 gets the frame n - 1
        .Restore_BG_0_Y:                rb 1
        .Restore_BG_0_WidthInPixels:    rb 1
        .Restore_BG_0_HeightInPixels:   rb 1
    .Restore_BG_1:
        .Restore_BG_1_X:                rb 1 ; restore bg 1 gets the frame n - 2 (the one that will be used to restore bg)
        .Restore_BG_1_Y:                rb 1
        .Restore_BG_1_WidthInPixels:    rb 1
        .Restore_BG_1_HeightInPixels:   rb 1
    .Side:                              rb 1
    .Position:                          rb 1
    .IsGrounded:                        rb 1
    .IsAnimating:                       rb 1
    .IsBlocking:                        rb 1
    .IsCrouching:                       rb 1
    .AllAnimations_Addr:                rw 1

; ----------------------------

; Constants:

SIDE:
    .LEFT:      equ 0   ; can be tested with OR A, saving 3 cycles
    .RIGHT:     equ 255 ; can be tested with INC A, saving 3 cycles

POSITION:
    .STANCE:                equ  0       ; these values will be used as offset from base AllAnimations_Addr
    .WALKING_FORWARD:       equ  2       ; so, position matter and there should be a step of 2 between each of them
    .WALKING_BACKWARDS:     equ  4
    .JUMPING_UP:            equ  6
    .JUMPING_FORWARD:       equ  8
    .JUMPING_BACKWARDS:     equ 10
    .LOW_KICK:              equ 12
    .HIGH_KICK:             equ 14
    .BLOCK:                 equ 16
    .CROUCHING:             equ 18
    .CROUCHING_BLOCK:       equ 20
    .HURT_1:                equ 22
    .UPPERCUT:              equ 24
    
; ----------------------------


OldSP:              rw 1


; --- ReadInput temp vars:
TempVars:
    .PlayerInput:        rb 1
    .PlayerInput_Block:  rb 1
    .yOffset:            rw 1

SNSMAT_Line_2:      rb 1
SNSMAT_Line_3:      rb 1
SNSMAT_Line_4:      rb 1
SNSMAT_Line_5:      rb 1
SNSMAT_Line_8:      rb 1


; ----------------------------

; Debug:
Jiffy_Saved:            rw 1
LastFps:                rb 1
CurrentCounter:         rb 1

Var_IsOPL4Available:    rb 1


RamEnd: