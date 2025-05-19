GoToNextFrame:

    ; HL = (Animation_CurrentFrame_Header)
    ld      l, (ix + Player_Struct.Animation_CurrentFrame_Header)
    ld      h, (ix + Player_Struct.Animation_CurrentFrame_Header + 1)


    ; HL++
    inc     hl
    inc     hl


    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    ret