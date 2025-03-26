Players_Init:
    ; ------------ init player 1

    xor     a
    ld      (Player_1_Vars.Animation_Current_Frame_Number), a
    ld      hl, Scorpion_Stance_Left_Animation_Headers
    ld      (Player_1_Vars.Animation_CurrentFrame_Header), hl
    ld      (Player_1_Vars.Animation_FirstFrame_Header), hl



    ; TODO: get these values from frame header

    ld      a, 64 - (58/2)
    ld      (Player_1_Vars.X), a
    ld      (Player_1_Vars.Restore_BG_X), a
    ld      a, 100
    ld      (Player_1_Vars.Y), a
    ld      (Player_1_Vars.Restore_BG_Y), a
    ld      a, 58
    ld      (Player_1_Vars.Width), a
    ld      (Player_1_Vars.Restore_BG_WidthInPixels), a
    ld      a, 105
    ld      (Player_1_Vars.Height), a
    ld      (Player_1_Vars.Restore_BG_HeightInPixels), a

    ld      ix, Player_1_Vars
    call    Update_VRAM_NAMTBL_Addr
    ; ld      hl, 0 + ((64 - (58/2))/2) + (128*100) ; column number 64 - (58/2); line number 100
    ; ld      (Player_1_Vars.VRAM_NAMTBL_Addr), hl

    ld      a, SIDE.LEFT
    ld      (Player_1_Vars.Side), a

    ld      a, POSITION.STANCE
    ld      (Player_1_Vars.Position), a

    ld      hl, Scorpion_All_Animations_Left
    ld      (Player_1_Vars.AllAnimations_Addr), hl
    
    ; ------------ init player 2

    xor     a
    ld      (Player_2_Vars.Animation_Current_Frame_Number), a
    ld      hl, Subzero_Stance_Right_Animation_Headers
    ld      (Player_2_Vars.Animation_CurrentFrame_Header), hl
    ld      (Player_2_Vars.Animation_FirstFrame_Header), hl



    ; TODO: get these values from frame header

    ld      a, 192 - (58/2)
    ld      (Player_2_Vars.X), a
    ld      (Player_2_Vars.Restore_BG_X), a
    ld      a, 100
    ld      (Player_2_Vars.Y), a
    ld      (Player_2_Vars.Restore_BG_Y), a
    ld      a, 58
    ld      (Player_2_Vars.Width), a
    ld      (Player_2_Vars.Restore_BG_WidthInPixels), a
    ld      a, 105
    ld      (Player_2_Vars.Height), a
    ld      (Player_2_Vars.Restore_BG_HeightInPixels), a


    ; ld      hl, 0 + ((192 - (58/2))/2) + (128*100) ; column number 192 - (58/2); line number 100
    ; ld      (Player_2_Vars.VRAM_NAMTBL_Addr), hl
    ld      ix, Player_2_Vars
    call    Update_VRAM_NAMTBL_Addr

    ld      a, SIDE.RIGHT
    ld      (Player_2_Vars.Side), a

    ld      a, POSITION.STANCE
    ld      (Player_2_Vars.Position), a

    ld      hl, Subzero_All_Animations_Right
    ld      (Player_2_Vars.AllAnimations_Addr), hl





    
    ret