
; Inputs:
;   IX: Player Vars base addr
GetCurrentFrameAndGoToNext:

    ld      a, (Player_1_Vars.CurrentFrame_MegaRomPage)
    ; ld      a, (ix + (Player_1_Vars.CurrentFrame_MegaRomPage - Player_1_Vars))
    ld	    (Seg_P8000_SW), a

    ;ld      hl, Frame_0.List
    ld      hl, (Player_1_Vars.CurrentFrame_List_Addr)
    ; ld      l, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars))
    ; ld      h, (ix + (Player_1_Vars.CurrentFrame_List_Addr - Player_1_Vars) + 1)
    
    ;ld      ix, Frame_0.Data
    ld      ix, (Player_1_Vars.CurrentFrame_Data_Addr)


    
    ; go to next frame
    push    hl
        ld      hl, (Player_1_Vars.Animation_CurrentFrame_List)
        inc     hl
        inc     hl

        ld      de, (Player_1_Vars.Animation_CurrentFrame_Data)
        inc     de
        inc     de

        ld      a, (hl)
        or      a
        jp      z, .returnToFirstFrame

        jp      .continue
.returnToFirstFrame:
        ld      hl, Player_1_Animation_List
        ld      de, Player_1_Animation_Data

.continue:

        ; save new frame
        ld      (Player_1_Vars.Animation_CurrentFrame_List), hl
        ld      (Player_1_Vars.Animation_CurrentFrame_Data), de

        ; get value on addr pointed by HL
        ; Player_1_Vars.CurrentFrame_List_Addr = (HL)
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        ld      (Player_1_Vars.CurrentFrame_List_Addr), bc


        ; get value on addr pointed by DE
        ; Player_1_Vars.CurrentFrame_Data_Addr = (DE)
        ld      a, (de)
        ld      l, a
        inc     de
        ld      a, (de)
        ld      h, a
        ld      (Player_1_Vars.CurrentFrame_Data_Addr), hl

    pop     hl

    ret