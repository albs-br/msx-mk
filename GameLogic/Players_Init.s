Players_Init:
    ; ------------ init player 1

    ld      ix, Player_1_Vars
    ld      hl, Scorpion_Stance_Left_Animation_Headers
    ld      b, 36 ;64 - (58/2)      ; X coord
    ld      c, 100              ; Y coord
    ld      de, Scorpion_All_Animations_Left
    ld      a, SIDE.LEFT
    call    Player_Init



    ; ------------ init player 2

    ld      ix, Player_2_Vars
    ld      hl, Subzero_Stance_Right_Animation_Headers
    ld      b, 162 ; 192 - (58/2)     ; X coord
    ld      c, 100              ; Y coord
    ld      de, Subzero_All_Animations_Right
    ld      a, SIDE.RIGHT
    call    Player_Init


  
    ret


; Inputs:
;   IX: Player Vars base addr (already pointing to next frame)
;   HL: Animation frame header addr
;   B:  X coordinate in pixels
;   C:  Y coordinate in pixels
;   DE: All animations addr
;   A:  Side (constant SIDE.LEFT / RIGHT)
Player_Init:

    ; ld      a, SIDE.LEFT
    ld      (ix + Player_Struct.Side), a

    ld      a, POSITION.STANCE
    ld      (ix + Player_Struct.Position), a

    ; Player.IsGrounded = true
    ld      a, 1
    ld      (ix + Player_Struct.IsGrounded), a

    
    xor     a
    ld      (ix + Player_Struct.IsAnimating), a ; Player.IsAnimating = false
    ld      (ix + Player_Struct.IsBlocking), a  ; Player.IsBlocking = false
    ld      (ix + Player_Struct.IsCrouching), a  ; Player.IsCrouching = false

    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a ; Player.Animation_Current_Frame_Number = 0

    ; TODO: this addr can be get from All Animations First Addr
    ; ld      hl, Scorpion_Stance_Left_Animation_Headers
    ; ld      (Player_1_Vars.Animation_CurrentFrame_Header), hl
    ; ld      (Player_1_Vars.Animation_FirstFrame_Header), hl
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h
    ld      (ix + Player_Struct.Animation_FirstFrame_Header), l
    ld      (ix + Player_Struct.Animation_FirstFrame_Header + 1), h




    ; ld      a, 64 - (58/2)
    ld      (ix + Player_Struct.X), b
    ld      (ix + Player_Struct.Restore_BG_0_X), b
    ld      (ix + Player_Struct.Restore_BG_1_X), b
    ; ld      a, 100
    ld      (ix + Player_Struct.Y), c
    ld      (ix + Player_Struct.Restore_BG_0_Y), c
    ld      (ix + Player_Struct.Restore_BG_1_Y), c


    ; TODO: get these values from frame header
    ld      a, 58
    ld      (ix + Player_Struct.Width), a
    ld      (ix + Player_Struct.Restore_BG_0_WidthInPixels), a
    ld      (ix + Player_Struct.Restore_BG_1_WidthInPixels), a

    ld      a, 105
    ld      (ix + Player_Struct.Height), a
    ld      (ix + Player_Struct.Restore_BG_0_HeightInPixels), a
    ld      (ix + Player_Struct.Restore_BG_1_HeightInPixels), a



    ; ld      ix, Player_1_Vars
    call    Update_VRAM_NAMTBL_Addr
    ; ld      hl, 0 + ((64 - (58/2))/2) + (128*100) ; column number 64 - (58/2); line number 100
    ; ld      (Player_1_Vars.VRAM_NAMTBL_Addr), hl

    call    UpdateHurtbox



    ; ld      de, Scorpion_All_Animations_Left
    ld      (ix + Player_Struct.AllAnimations_Addr), e
    ld      (ix + Player_Struct.AllAnimations_Addr + 1), d

    ret