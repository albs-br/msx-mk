
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

;jp $ ; debug
; IY value here is 0xB680 (= Subzero_Stance_Right_Frame_0_Header) OK

    ; ; HL = current frame list addr
    ; ld      l, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars))
    ; ld      h, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1)
    
    
    ; go to next frame
    ; push    hl
        ; HL = (Animation_CurrentFrame_Header)
        ld      l, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars))
        ld      h, (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars) + 1)

; jp $ ; debug
; HL here = 0x45af (= Subzero_Stance_Right_Animation_Headers) OK

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
        


        ; ; ?????????

        ; ; set MegaROM page to Headers

        ; ; get value on addr pointed by HL
        ; ; Player_1_Vars.CurrentFrame_List_Addr = (HL)
        ; ld      c, (hl)
        ; inc     hl
        ; ld      b, (hl)
        ; ; ld      (Player_1_Vars.CurrentFrame_List_Addr), bc
        ; ld      (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars)), c
        ; ld      (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1), b




    ; pop     hl

    ret