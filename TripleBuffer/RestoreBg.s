

; Input:
;   HL: Y of base of page (constants: Y_BASE_PAGE_n)
;   IX: Player Vars base addr
RestoreBg:

    ; Set HMMM command parameters based on Player Vars (frame n - 2) and execute it

    ; Destiny_Y = Y of base of page + Player.Restore_BG_Y
    ld      d, 0
    ld      a, (ix + Player_Struct.Restore_BG_1_Y)
    ld      e, a
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_Y), hl

    
    ; X is the same for both source and destiny
    ld      h, 0
    ld      a, (ix + Player_Struct.Restore_BG_1_X)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_X), hl
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Destiny_X), hl

    ; Source_Y is always on the page 3
    ; Source_Y = (256 * 3) + Player.Restore_BG_Y
    ld      h, 0
    ld      a, (ix + Player_Struct.Restore_BG_1_Y) ; TODO: this can come from register E
    ld      l, a
    ld      de, 768
    add     hl, de
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Source_Y), hl


    ld      h, 0
    ld      a, (ix + Player_Struct.Restore_BG_1_WidthInPixels)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Cols), hl

    ld      h, 0
    ld      a, (ix + Player_Struct.Restore_BG_1_HeightInPixels)
    ld      l, a
    ld      (TripleBuffer_Vars_RestoreBG_HMMM_Command.Lines), hl

    ; .Source_X:   dw    0 	              ; Source X (9 bits)
    ; .Source_Y:   dw    0 + (256*3)      ; Source Y (10 bits)
    ; .Destiny_X:  dw    0 	              ; Destiny X (9 bits)
    ; .Destiny_Y:  dw    0 	              ; Destiny Y (10 bits)
    ; .Cols:       dw    58               ; number of cols (9 bits)
    ; .Lines:      dw    97               ; number of lines (10 bits)
    ; .NotUsed:    db    0
    ; .Options:    db    0        ; select destination memory and direction from base coordinate
    ; .Command:    db    VDP_COMMAND_HMMM





    ld      hl, TripleBuffer_Vars_RestoreBG_HMMM_Command
    call    Execute_VDP_HMMM	    ; High speed move VRAM to VRAM



    


    ret
