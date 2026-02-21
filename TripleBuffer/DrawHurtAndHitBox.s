; This one is for debug purposes
DrawHurtAndHitBox:
    ; -------------- draw HurtBox using LINE cmd
    
    ; reset LINE cmd parameters
    ld      hl, LINE_Parameters
    ld      de, TripleBuffer_Vars_LINE_Command
    ld      bc, LINE_Parameters_size
    ldir

    ; set color
    ld      a, 15
    ld      (TripleBuffer_Vars_LINE_Command.Color), a

    ; top line
    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_X)
    ld      (TripleBuffer_Vars_LINE_Command.Start_X), hl


    ld      de, (TripleBuffer_Vars.DrawingPage_Y)

    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_Y)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_Width)
    ld      (TripleBuffer_Vars_LINE_Command.LongSide), hl

    ; ld      h, 0
    ; ld      l, (ix + Player_Struct.HurtBox_Height)
    ld      hl, 0
    ld      (TripleBuffer_Vars_LINE_Command.ShortSide), hl


    ld      a, 0000 0000 b ; bit 0: defines short and long side
    ld      (TripleBuffer_Vars_LINE_Command.Options), a

    ; ld      a, 7 ; color
    ; ld      (TripleBuffer_Vars_LINE_Command + 8), a

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; bottom line
    ld      de, (TripleBuffer_Vars.DrawingPage_Y)
    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_Y)
    add     hl, de

    ld      d, 0
    ld      e, (ix + Player_Struct.HurtBox_Height)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; left line
    ld      de, (TripleBuffer_Vars.DrawingPage_Y)

    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_Y)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_Height)
    ; ld      hl, 10
    ld      (TripleBuffer_Vars_LINE_Command.LongSide), hl

    ; ld      h, 0
    ; ld      l, (ix + Player_Struct.HurtBox_Height)
    ld      hl, 0
    ld      (TripleBuffer_Vars_LINE_Command.ShortSide), hl

    ld      a, 0000 0001 b ; bit 0: defines short and long side
    ld      (TripleBuffer_Vars_LINE_Command.Options), a

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; right line
    ld      d, 0
    ld      e, (ix + Player_Struct.HurtBox_Width)

    ld      h, 0
    ld      l, (ix + Player_Struct.HurtBox_X)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_X), hl


    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; -------------- draw HitBox using LINE cmd

    ; if (Player_Struct.HitBox_X == 255) ret
    ld      a, (ix + Player_Struct.HitBox_X)
    inc     a
    ret     z


    ; reset LINE cmd parameters
    ld      hl, LINE_Parameters
    ld      de, TripleBuffer_Vars_LINE_Command
    ld      bc, LINE_Parameters_size
    ldir

    ; set color
    ld      a, 8
    ld      (TripleBuffer_Vars_LINE_Command.Color), a

    ; top line
    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_X)
    ld      (TripleBuffer_Vars_LINE_Command.Start_X), hl


    ld      de, (TripleBuffer_Vars.DrawingPage_Y)

    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_Y)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_Width)
    ld      (TripleBuffer_Vars_LINE_Command.LongSide), hl

    ld      hl, 0
    ld      (TripleBuffer_Vars_LINE_Command.ShortSide), hl


    ld      a, 0000 0000 b ; bit 0: defines short and long side
    ld      (TripleBuffer_Vars_LINE_Command.Options), a

    ; ld      a, 7 ; color
    ; ld      (TripleBuffer_Vars_LINE_Command + 8), a

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; bottom line
    ld      de, (TripleBuffer_Vars.DrawingPage_Y)
    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_Y)
    add     hl, de

    ld      d, 0
    ld      e, (ix + Player_Struct.HitBox_Height)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; left line
    ld      de, (TripleBuffer_Vars.DrawingPage_Y)

    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_Y)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_Y), hl

    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_Height)
    ; ld      hl, 10
    ld      (TripleBuffer_Vars_LINE_Command.LongSide), hl

    ld      hl, 0
    ld      (TripleBuffer_Vars_LINE_Command.ShortSide), hl

    ld      a, 0000 0001 b ; bit 0: defines short and long side
    ld      (TripleBuffer_Vars_LINE_Command.Options), a

    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE



    ; right line
    ld      d, 0
    ld      e, (ix + Player_Struct.HitBox_Width)

    ld      h, 0
    ld      l, (ix + Player_Struct.HitBox_X)
    add     hl, de
    ld      (TripleBuffer_Vars_LINE_Command.Start_X), hl


    ld      hl, TripleBuffer_Vars_LINE_Command
    call    Execute_VDP_LINE


    ret