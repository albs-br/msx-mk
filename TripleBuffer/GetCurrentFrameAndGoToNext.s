
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

    inc     hl      
    ld      a, (hl) ; read high byte
    dec     hl      ; go back

    ; if (next frame high byte == 0x00) returnToFirstFrame();
    or      a
    jp      z, .returnToFirstFrame

    ; if (next frame high byte == 0x01) endOfAnimation();
    cp      0x01
    jp      z, .endOfAnimation

    ; if (next frame high byte == 0x02) stopAnimation();
    cp      0x02
    jp      z, .stopAnimation

    ; TODO: debug trap (all frame headers should be between 0x8000 and 0xbf00)
    ;cp      0x80
    ;jp     c, .Error
    ;cp      0xc0
    ;jp     nc, .Error


    jp      .continue

.returnToFirstFrame:
    ; HL = (Animation_FirstFrame_Header)
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ; Animation_Current_Frame_Number = 0
    xor     a
    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a

    jp      .continue

.endOfAnimation:

    ; Player.IsAnimating = false
    xor     a
    ld      (ix + Player_Struct.IsAnimating), a

    ; if (player.IsGrounded) Player_SetPosition_Stance()
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    ; push    hl
        call    nz, Player_SetPosition_Stance
    ; pop     hl

    jp      .continue

.stopAnimation:

    ; return to previous frame
    dec     hl
    dec     hl

.continue:

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h
        
    ; IY = current frame header addr
    ld      a, (hl)
    ld      iyl, a
    inc     hl
    ld      a, (hl)
    ld      iyh, a


    ret