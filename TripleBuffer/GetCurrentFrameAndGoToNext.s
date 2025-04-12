
; Inputs:
;   IX: Player Vars base addr
; Outputs:
;   IY: Player current frame header addr
GetCurrentFrameAndGoToNext:

    ; IY = current frame header addr
    ld      l, (ix + Player_Struct.Animation_CurrentFrame_Header)
    ld      h, (ix + Player_Struct.Animation_CurrentFrame_Header + 1)
    ld      a, (hl)
    ld      iyl, a
    inc     hl
    ld      a, (hl)
    ld      iyh, a


    ; HL = (Animation_CurrentFrame_Header)
    ld      l, (ix + Player_Struct.Animation_CurrentFrame_Header)
    ld      h, (ix + Player_Struct.Animation_CurrentFrame_Header + 1)


    ; HL++
    inc     hl
    inc     hl

    ; Animation_Current_Frame_Number++
    inc      (ix + Player_Struct.Animation_Current_Frame_Number)

    inc     hl      ; read high byte
    ld      a, (hl)
    dec     hl      ; go back
    or      a ; if (next frame high byte == 0) returnToFirstFrame
    jp      z, .returnToFirstFrame

    ; TODO: implement end of animation marking (0x0000 means looping animation, 0xff00 could be end of animation)

    jp      .continue
.returnToFirstFrame:
    ; HL = (Animation_FirstFrame_Header)
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ; Animation_Current_Frame_Number = 0
    xor     a
    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a

.continue:

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h
        


    ret