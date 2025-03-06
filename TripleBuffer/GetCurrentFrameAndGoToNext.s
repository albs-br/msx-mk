
; Inputs:
;   IX: Player Vars base addr
; Outputs:
;   HL: Player current frame list addr
;   IY: Player current frame data addr
GetCurrentFrameAndGoToNext:

    ; ld      a, (Player_1_Vars.CurrentFrame_MegaRomPage)
    ld      a, (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars))
    ld	    (Seg_P8000_SW), a

    ;ld      hl, Frame_0.List
    ; ld      hl, (Player_1_Vars.CurrentFrame_List_Addr)
    ld      l, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars))
    ld      h, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1)
    
    ;ld      iy, Frame_0.Data
    ; ld      iy, (Player_1_Vars.CurrentFrame_Data_Addr)
    ld      a, (ix + (Player_1_Vars.CurrentFrame_Data_Addr - Player_1_Vars))
    ld      iyl, a
    ld      a, (ix + (Player_1_Vars.CurrentFrame_Data_Addr - Player_1_Vars) + 1)
    ld      iyh, a


    
    ; go to next frame
    push    hl
        ; ld      hl, (Player_1_Vars.Animation_CurrentFrame_List)
        ld      l, (ix + (Player_1_Vars.Animation_CurrentFrame_List - Player_1_Vars))
        ld      h, (ix + (Player_1_Vars.Animation_CurrentFrame_List - Player_1_Vars) + 1)
        inc     hl
        inc     hl

        ; ld      de, (Player_1_Vars.Animation_CurrentFrame_Data)
        ld      e, (ix + (Player_1_Vars.Animation_CurrentFrame_Data - Player_1_Vars))
        ld      d, (ix + (Player_1_Vars.Animation_CurrentFrame_Data - Player_1_Vars) + 1)
        inc     de
        inc     de

        ld      a, (hl)
        or      a
        jp      z, .returnToFirstFrame

        jp      .continue
.returnToFirstFrame:
        ; ld      hl, Player_1_Animation_List
        ld      l, (ix + (Player_1_Vars.Animation_FirstFrame_List - Player_1_Vars))
        ld      h, (ix + (Player_1_Vars.Animation_FirstFrame_List - Player_1_Vars) + 1)

        ; ld      de, Player_1_Animation_Data
        ld      e, (ix + (Player_1_Vars.Animation_FirstFrame_Data - Player_1_Vars))
        ld      d, (ix + (Player_1_Vars.Animation_FirstFrame_Data - Player_1_Vars) + 1)

.continue:

        ; save new frame
        ; ld      (Player_1_Vars.Animation_CurrentFrame_List), hl
        ld      (ix + (Player_1_Vars.Animation_CurrentFrame_List - Player_1_Vars)), l
        ld      (ix + (Player_1_Vars.Animation_CurrentFrame_List - Player_1_Vars) + 1), h
        
        ; ld      (Player_1_Vars.Animation_CurrentFrame_Data), de
        ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Data - Player_1_Vars)), e
        ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Data - Player_1_Vars) + 1), d

        ; get value on addr pointed by HL
        ; Player_1_Vars.CurrentFrame_List_Addr = (HL)
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        ; ld      (Player_1_Vars.CurrentFrame_List_Addr), bc
        ld      (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars)), c
        ld      (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1), b


        ; get value on addr pointed by DE
        ; Player_1_Vars.CurrentFrame_Data_Addr = (DE)
        ld      a, (de)
        ld      l, a
        inc     de
        ld      a, (de)
        ld      h, a
        ; ld      (Player_1_Vars.CurrentFrame_Data_Addr), hl
        ld      (ix + (Player_1_Vars.CurrentFrame_Data_Addr - Player_1_Vars)), l
        ld      (ix + (Player_1_Vars.CurrentFrame_Data_Addr - Player_1_Vars) + 1), h

    pop     hl

    ret