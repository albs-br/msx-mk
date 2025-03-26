; Input:
;   IX: Player Vars base addr
Update_VRAM_NAMTBL_Addr:

    ; ld      hl, 0 + ((192 - (58/2))/2) + (128*100) ; column number 192 - (58/2); line number 100

    ; VRAM_NAMTBL_Addr = (X/2) + (128*Y)
    ld      c, (ix + (Player_1_Vars.X - Player_1_Vars))         ; C = X
    srl     c                                                   ; shift right C (divide by 2, as X is stored in pixels, but should be converted to bytes)
    ld      b, 0

    ld      h, 0
    ld      l, (ix + (Player_1_Vars.Y - Player_1_Vars))         ; HL = Y

    ; shift left HL 7 times (multiply by 128)
    ; T-Cycles: 32
    ; Bytes: 8
    ; Trashed: A
    xor     a
    srl     h
    rr      l
    rra
    ld      h, l
    ld      l, a


    add     hl, bc


    ld      (ix + (Player_1_Vars.VRAM_NAMTBL_Addr - Player_1_Vars)), l
    ld      (ix + (Player_1_Vars.VRAM_NAMTBL_Addr - Player_1_Vars + 1)), h

    ret

Player_Input_Left:

    ld      a, (ix + (Player_1_Vars.X - Player_1_Vars))
    cp      2       ; if (X < 2) ret
    ret     c

    sub     2
    ld      (ix + (Player_1_Vars.X - Player_1_Vars)), a

    call    Update_VRAM_NAMTBL_Addr

    ; if(position == STANCE)
    ld      a, (ix + (Player_1_Vars.Position - Player_1_Vars))
    cp      POSITION.STANCE
    jp      nz, .skip_1

    ; --- get addr of animation
    ; ld      hl, Subzero_Walking_Right_Animation_Headers
    ld      bc, POSITION.WALKING_FORWARD
    call    GetAnimationAddr


    ; --- set animation
    ld      a, POSITION.WALKING_FORWARD
    call    Player_SetAnimation

.skip_1:


    ret

Player_Input_Right:

    ld      a, 255
    sub     (ix + (Player_1_Vars.Width - Player_1_Vars))
    ld      b, a
    ld      a, (ix + (Player_1_Vars.X - Player_1_Vars))
    cp      b       ; if (X > (255-width)) ret
    ret     nc

    add     2
    ld      (ix + (Player_1_Vars.X - Player_1_Vars)), a

    call    Update_VRAM_NAMTBL_Addr

    ; if(position == STANCE)
    ld      a, (ix + (Player_1_Vars.Position - Player_1_Vars))
    cp      POSITION.STANCE
    jp      nz, .skip_2

    ; --- get addr of animation
    ld      bc, POSITION.WALKING_BACKWARDS
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.WALKING_BACKWARDS
    call    Player_SetAnimation

.skip_2:

    ret

Player_Input_None:

    ; if(position != STANCE)
    ld      a, (ix + (Player_1_Vars.Position - Player_1_Vars))
    cp      POSITION.STANCE
    jp      z, .skip_10

    ; --- get addr of animation
    ld      bc, POSITION.STANCE
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.STANCE
    ; ld      hl, Subzero_Stance_Right_Animation_Headers
    call    Player_SetAnimation

.skip_10:

    ret

; Inputs:
;   IX: Player Vars base addr
;   A:  Position (constant POSITION.?)
;   HL: Addr of animation
Player_SetAnimation:
    ; ld      a, POSITION.STANCE
    ld      (ix + (Player_1_Vars.Position - Player_1_Vars)), a

    xor     a
    ld      (ix + (Player_1_Vars.Animation_Current_Frame_Number - Player_1_Vars)), a
    
    ; ld      hl, Subzero_Stance_Right_Animation_Headers
    ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars)), l
    ld      (ix + (Player_1_Vars.Animation_CurrentFrame_Header - Player_1_Vars + 1)), h

    ld      (ix + (Player_1_Vars.Animation_FirstFrame_Header - Player_1_Vars)), l
    ld      (ix + (Player_1_Vars.Animation_FirstFrame_Header - Player_1_Vars + 1)), h

    ret

; Inputs:
;   IX: Player Vars base addr
;   BC: Offset from base AllAnimations_Addr (constant POSITION.?)
; Outputs:
;   HL: Addr of animation
GetAnimationAddr:
    ld      l, (ix + Player_1_Vars.AllAnimations_Addr - Player_1_Vars)
    ld      h, (ix + Player_1_Vars.AllAnimations_Addr - Player_1_Vars + 1)
    ; ld      bc, POSITION.WALKING_FORWARD
    add     hl, bc
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl ; HL = DE

    ret