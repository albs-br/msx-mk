
; Inputs:
;   IX: Player Vars base addr
; Outputs:
;   IY: Player current frame header addr
GetCurrentFrameAndGoToNext:

    ; IY = current frame header addr
    ld      l, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars))
    ld      h, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars) + 1)
    ld      a, (hl)
    ld      iyl, a
    inc     hl
    ld      a, (hl)
    ld      iyh, a


    ; HL = (Animation_CurrentFrame_Header)
    ld      l, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars))
    ld      h, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars) + 1)


    ; HL++
    inc     hl
    inc     hl

    ; Animation_Current_Frame_Number++
    inc      (ix + (Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars))

    inc     hl      ; read high byte
    ld      a, (hl)
    dec     hl      ; go back
    or      a ; if (next frame high byte == 0) returnToFirstFrame
    jp      z, .returnToFirstFrame

    jp      .continue
.returnToFirstFrame:
    ; HL = (Animation_FirstFrame_Header)
    ld      l, (ix + (Player_1_Vars.Animation_FirstFrame_Header - Player_1_Vars))
    ld      h, (ix + (Player_1_Vars.Animation_FirstFrame_Header - Player_1_Vars) + 1)

    ; Animation_Current_Frame_Number = 0
    xor     a
    ld      (ix + (Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars)), a

.continue:

    ; save new frame
    ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars)), l
    ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars) + 1), h
        


    ret