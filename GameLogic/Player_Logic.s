Player_Jump_Delta_Y: 
    db -24, -16, -16,  -8,  -8, -8, -4, -4, -2,  -2,   0,   0
    db   0,   0,   2,   2,   4,  4,  8,  8,  8,  16,  16,  24
.size: equ $ - Player_Jump_Delta_Y

; Inputs:
;   IX: Player Vars base addr
Player_Logic:
    
    ; switch (Player.Position)
    ld      a, (ix + Player_Struct.Position)

    ; case POSITION.JUMPING_UP:
    cp      POSITION.JUMPING_UP
    jp      z, .jumpingUp

    ; case POSITION.JUMPING_FORWARD:
    cp      POSITION.JUMPING_FORWARD
    jp      z, .jumpingForward

    ; case POSITION.JUMPING_BACKWARDS:
    cp      POSITION.JUMPING_BACKWARDS
    jp      z, .jumpingBackwards

    ret

.jumpingUp:

    ; ---- Update Y

    ; --- get Player_Jump_Delta_Y from Animation_Current_Frame_Number
    ld      hl, Player_Jump_Delta_Y
    ld      c, (ix + Player_Struct.Animation_Current_Frame_Number)
    ld      b, 0
    ld      a, c
    cp      Player_Jump_Delta_Y.size
    jp      z, .endJump ; if (Animation_Current_Frame_Number == 24) endJump()
    add     hl, bc
    ld      a, (hl)

    ; update Y with this Delta_Y
    ld      b, (ix + Player_Struct.Y)
    add     b
    ld      (ix + Player_Struct.Y), a

    call    Update_VRAM_NAMTBL_Addr

    ret

.endJump:
    call    Player_SetPosition_Stance
    ret

.jumpingForward:
    call    .jumpingUp

    ld      a, 255
    sub     (ix + Player_Struct.Width)
    ld      b, a
    ld      a, (ix + Player_Struct.X)
    cp      b       ; if (X >= (255-width)) ret
    ret     nc

    add     4 ; TODO: not sure if 4 or 6 is the right increment here
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr

    ret

.jumpingBackwards:
    call    .jumpingUp

    ld      a, (ix + Player_Struct.X)
    cp      4       ; if (X < 4) ret
    ret     c

    sub     4 ; TODO: not sure if 4 or 6 is the right increment here
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr

    ret

; Input:
;   IX: Player Vars base addr
Update_VRAM_NAMTBL_Addr:

    ; ld      hl, 0 + ((192 - (58/2))/2) + (128*100) ; column number 192 - (58/2); line number 100

    ; VRAM_NAMTBL_Addr = (X/2) + (128*Y)
    ld      c, (ix + Player_Struct.X)         ; C = X
    srl     c                                                   ; shift right C (divide by 2, as X is stored in pixels, but should be converted to bytes)
    ld      b, 0

    ld      h, 0
    ld      l, (ix + Player_Struct.Y)         ; HL = Y

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


    ld      (ix + Player_Struct.VRAM_NAMTBL_Addr), l
    ld      (ix + Player_Struct.VRAM_NAMTBL_Addr + 1), h

    ret

Player_Input_Left:

    ld      a, (ix + Player_Struct.X)
    cp      2       ; if (X < 2) ret
    ret     c

    sub     2
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr


    ; The position should be checked instead of checking IsGround because walking is possible only
    ; when player is in Stance position (IsGrounded can be crouch, fallen, etc)
    ; if(position == STANCE)
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      nz, .return



    ; if (side == right) position = WALKING_FORWARD
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.RIGHT
    jp      nz, .sideLeft

    ld      bc, POSITION.WALKING_FORWARD
    call    GetAnimationAddr

    ld      a, POSITION.WALKING_FORWARD
    call    Player_SetAnimation
    
    jp      .skip_2

.sideLeft:
    ld      bc, POSITION.WALKING_BACKWARDS
    call    GetAnimationAddr

    ld      a, POSITION.WALKING_BACKWARDS
    call    Player_SetAnimation

.skip_2:



.return:


    ret

Player_Input_Right:

    ld      a, 255
    sub     (ix + Player_Struct.Width)
    ld      b, a
    ld      a, (ix + Player_Struct.X)
    cp      b       ; if (X >= (255-width)) ret
    ret     nc

    add     2
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr


    ; The position should be checked instead of checking IsGround because walking is possible only
    ; when player is in Stance position (IsGrounded can be crouch, fallen, etc)
    ; if(position == STANCE)
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      nz, .return



    ; if (side == right) position = WALKING_BACKWARDS
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.RIGHT
    jp      nz, .sideLeft

    ld      bc, POSITION.WALKING_BACKWARDS
    call    GetAnimationAddr

    ld      a, POSITION.WALKING_BACKWARDS
    call    Player_SetAnimation

    jp      .skip_10

.sideLeft:

    ld      bc, POSITION.WALKING_FORWARD
    call    GetAnimationAddr

    ld      a, POSITION.WALKING_FORWARD
    call    Player_SetAnimation

.skip_10:

.return:

    ret

Player_SetPosition_Stance:

    ; if(position != STANCE)
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      z, .skip_10

    ; Player.IsGrounded = true
    ld      a, 1
    ld      (ix + Player_Struct.IsGrounded), a

    ; --- get addr of animation
    ld      bc, POSITION.STANCE
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.STANCE
    ; ld      hl, Subzero_Stance_Right_Animation_Headers
    call    Player_SetAnimation





.skip_10:

    ret

Player_Input_Up:

    ; Player.IsGrounded = false
    xor     a
    ld      (ix + Player_Struct.IsGrounded), a

    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_UP
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_UP
    call    Player_SetAnimation

    ret

Player_Input_Up_Right:

    ; Player.IsGrounded = false
    xor     a
    ld      (ix + Player_Struct.IsGrounded), a

    ; TODO: check side to trigger jump forward/backwards

    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_FORWARD
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_FORWARD
    call    Player_SetAnimation

    ret

Player_Input_Up_Left:

    ; Player.IsGrounded = false
    xor     a
    ld      (ix + Player_Struct.IsGrounded), a

    ; TODO: check side to trigger jump forward/backwards

    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_BACKWARDS
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_BACKWARDS
    call    Player_SetAnimation

    ret

; Inputs:
;   IX: Player Vars base addr
;   A:  Position (constant POSITION.?)
;   HL: Addr of animation
Player_SetAnimation:
    ; ld      a, POSITION.STANCE
    ld      (ix + Player_Struct.Position), a

    xor     a
    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a
    
    ; ld      hl, Subzero_Stance_Right_Animation_Headers
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    ld      (ix + Player_Struct.Animation_FirstFrame_Header), l
    ld      (ix + Player_Struct.Animation_FirstFrame_Header + 1), h

    ret

; Inputs:
;   IX: Player Vars base addr
;   BC: Offset from base AllAnimations_Addr (constant POSITION.?)
; Outputs:
;   HL: Addr of animation
GetAnimationAddr:
    ld      l, (ix + Player_Struct.AllAnimations_Addr)
    ld      h, (ix + Player_Struct.AllAnimations_Addr + 1)
    ; ld      bc, POSITION.WALKING_FORWARD
    add     hl, bc
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl ; HL = DE

    ret