
; Inputs:
;   IX: Player Vars base addr
; Outputs:
;   IY: Player current frame header addr
GetCurrentFrameAndGoToNext:



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

    ; if (next frame high byte == 0x00) returnToFirstFrame();
    or      a
    jp      z, .returnToFirstFrame

    ; if (next frame high byte == 0x01) endOfAnimation();
    cp      0x01
    jp      z, .endOfAnimation

    ; TODO: implement end of animation marking (0x0000 means looping animation, 0xff00 could be end of animation)

    jp      .continue

.returnToFirstFrame:
    ; HL = (Animation_FirstFrame_Header)
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ; Animation_Current_Frame_Number = 0
    xor     a
    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a

    ; shouldn't we have to update IY here (current frame header?)
    jp      .continue

.endOfAnimation:

    ; Player.IsAnimating = false
    xor     a
    ld      (ix + Player_Struct.IsAnimating), a

    ; if (player.IsGrounded) Player_SetPosition_Stance()
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    call    nz, Player_SetPosition_Stance


.continue:

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h
        
    ; IY = current frame header addr
    ; ld      l, (ix + Player_Struct.Animation_CurrentFrame_Header)
    ; ld      h, (ix + Player_Struct.Animation_CurrentFrame_Header + 1)
    ld      a, (hl)
    ld      iyl, a
    inc     hl
    ld      a, (hl)
    ld      iyh, a


    ret