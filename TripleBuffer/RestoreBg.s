

; Input:
;   HL: Y of base of page (constants: Y_BASE_PAGE_n)
;   IX: Player Vars base addr
RestoreBg:

    ; Set HMMM command parameters based on Player Vars (previous frame) and execute it

    ; ; Destiny_Y = Y of base of page + Player.Restore_BG_Y
    ld      d, 0
    ; ld      a, (Player_1_Vars.Restore_BG_Y)
    ld      a, (ix + (Player_1_Vars.Restore_BG_Y - Player_1_Vars))
    ld      e, a
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_Y), hl

    
    ; X is the same for both source and destiny
    ld      h, 0
    ; ld      a, (Player_1_Vars.Restore_BG_X)
    ld      a, (ix + (Player_1_Vars.Restore_BG_X - Player_1_Vars))
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_X), hl
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_X), hl

    ; Source_Y is always on the page 3
    ; Source_Y = (256 * 3) + Player.Restore_BG_Y
    ld      h, 0
    ; ld      a, (Player_1_Vars.Restore_BG_Y)
    ld      a, (ix + (Player_1_Vars.Restore_BG_Y - Player_1_Vars))
    ld      l, a
    ld      de, 768
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_Y), hl


    ld      h, 0
    ; ld      a, (Player_1_Vars.Restore_BG_WidthInPixels)
    ld      a, (ix + (Player_1_Vars.Restore_BG_WidthInPixels - Player_1_Vars))
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Cols), hl

    ld      h, 0
    ; ld      a, (Player_1_Vars.Restore_BG_HeightInPixels)
    ld      a, (ix + (Player_1_Vars.Restore_BG_HeightInPixels - Player_1_Vars))
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Lines), hl

    ; .Source_X:   dw    0 	            ; Source X (9 bits)
    ; .Source_Y:   dw    0 + (256*3)      ; Source Y (10 bits)
    ; .Destiny_X:  dw    0 	    ; Destiny X (9 bits)
    ; .Destiny_Y:  dw    0 	    ; Destiny Y (10 bits)
    ; .Cols:       dw    58       ; number of cols (9 bits)
    ; .Lines:      dw    97       ; number of lines (10 bits)
    ; .NotUsed:    db    0
    ; .Options:    db    0        ; select destination memory and direction from base coordinate
    ; .Command:    db    VDP_COMMAND_HMMM




    ; set destiny_Y to value in HL
    ; ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_Y), hl

    ld      hl, TripleBuffer_Vars_RestoreBG_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM


    ; ---- Update Player Restore BG vars after BG is restored with previous frame
    ld      b, 0 ; B will be added to width
    ld      a, (ix + (Player_1_Vars.X - Player_1_Vars))
    ld      c, a ; save original X
    ; if(x >= 2) x -= 2
    cp      2
    jp      c, .skip_1
    sub     2 ; 2px left to be on the safe side
    ld      b, 2 ; width += 2 ; compensate for the x-2
.skip_1:
    ld      (ix + (Player_1_Vars.Restore_BG_X - Player_1_Vars)), a

    ld      a, (ix + (Player_1_Vars.Y - Player_1_Vars))
    ld      (ix + (Player_1_Vars.Restore_BG_Y - Player_1_Vars)), a

    ld      a, (ix + (Player_1_Vars.Width - Player_1_Vars))
    ld      d, a ; save original width
    add     b
    ld      e, a ; save new width
    
    ; if(x + width < 254) width += 2
    ; if((C + D) < 254) E += 2
    ld      a, c
    add     d
    cp      254
    ld      a, e ; restore new width
    jp      nc, .skip_2

    add     2 ; 2px right to be on the safe side
.skip_2:
    ld      (ix + (Player_1_Vars.Restore_BG_WidthInPixels - Player_1_Vars)), a
    
    ld      a, (ix + (Player_1_Vars.Height - Player_1_Vars))
    ld      (ix + (Player_1_Vars.Restore_BG_HeightInPixels - Player_1_Vars)), a
    


    ret
