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

    ; UNNECESSARY:
    ; ; case POSITION.LOW_KICK:
    ; cp      POSITION.LOW_KICK
    ; jp      z, .lowKick

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

    ; if (side == left) jumping_Increase_X else jumping_Decrease_X
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.LEFT
    jp      z, .jumping_Increase_X
    jp      .jumping_Decrease_X

.jumpingBackwards:
    call    .jumpingUp

    ; if (side == left) jumping_Decrease_X else jumping_Increase_X
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.LEFT
    jp      z, .jumping_Decrease_X
    ; jp      .jumping_Increase_X

.jumping_Increase_X:

    ; ----- check screen right limit
    ; ld      a, 255
    ; sub     (ix + Player_Struct.Width)
    ; ld      b, a
    ; ld      a, (ix + Player_Struct.X)
    ; cp      b       ; if (X >= (255-width)) ret
    call    Player_CheckScreenLimitRight
    ret     nc

    add     4 ; TODO: not sure if 4 or 6 is the right increment here
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr

    ret

.jumping_Decrease_X:

    ; ----- check screen left limit
    ld      a, (ix + Player_Struct.X)
    cp      4       ; if (X < 4) ret
    ret     c

    sub     4 ; TODO: not sure if 4 or 6 is the right increment here
    ld      (ix + Player_Struct.X), a

    call    Update_VRAM_NAMTBL_Addr

    ret

.lowKick:
;jp $;[debug]
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

    ; ----- check screen left limit
    ld      a, (ix + Player_Struct.X)
    cp      2       ; if (X < 2) ret
    ret     c

    sub     2
    ld      (ix + Player_Struct.X), a
    call    UpdateHurtbox
    
;     push    ix, iy
;         ld      ix, Player_1_Vars.HurtBox
;         ld      iy, Player_2_Vars.HurtBox
;         call    CheckCollision_Obj1xObj2
;     pop     iy, ix
;     jp      c, .collision
;     jp      .noCollision

; .collision:
;     ld      a, (ix + Player_Struct.X)
;     add     2
;     ld      (ix + Player_Struct.X), a
;     call    UpdateHurtbox

; .noCollision:

    call    Update_VRAM_NAMTBL_Addr


    ; The position should be checked instead of checking IsGround because walking is possible only
    ; when player is in Stance position (IsGrounded can be crouch, fallen, etc)
    ; if(position == STANCE)
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      nz, .return



    ; if (side == right) position = WALKING_FORWARD else WALKING_BACKWARDS
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

    ; ----- check screen right limit
    ; ld      a, 255
    ; sub     (ix + Player_Struct.Width)
    ; ld      b, a
    ; ld      a, (ix + Player_Struct.X)
    ; cp      b       ; if (X >= (255-width)) ret
    call    Player_CheckScreenLimitRight
    ret     nc

    add     2
    ld      (ix + Player_Struct.X), a
    call    UpdateHurtbox

;     push    ix, iy
;         ld      ix, Player_1_Vars.HurtBox
;         ld      iy, Player_2_Vars.HurtBox
;         call    CheckCollision_Obj1xObj2
;     pop     iy, ix
;     jp      c, .collision
;     jp      .noCollision

; .collision:
;     ld      a, (ix + Player_Struct.X)
;     sub     2
;     ld      (ix + Player_Struct.X), a
;     call    UpdateHurtbox

; .noCollision:

    call    Update_VRAM_NAMTBL_Addr


    ; The position should be checked instead of checking IsGround because walking is possible only
    ; when player is in Stance position (IsGrounded can be crouch, fallen, etc)
    ; if(position == STANCE)
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      nz, .return



    ; if (side == right) position = WALKING_BACKWARDS else WALKING_FORWARD
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

    ; if(position == STANCE) return
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      z, .return


    ; check if there is an ongoing animation
    ld      a, (ix + Player_Struct.IsAnimating)
    or      a
    jp      nz, .return

.withoutChecks:

    ; Player.IsGrounded = true
    ld      a, 1
    ld      (ix + Player_Struct.IsGrounded), a

    
    xor     a
    ld      (ix + Player_Struct.IsAnimating), a     ; Player.IsAnimating = false
    ld      (ix + Player_Struct.IsBlocking), a      ; Player.IsBlocking = false
    ld      (ix + Player_Struct.IsCrouching), a     ; Player.IsCrouching = false

    ; --- get addr of animation
    ld      bc, POSITION.STANCE
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.STANCE
    call    Player_SetAnimation





.return:

    ret

Player_Input_Up:

    
    xor     a
    ld      (ix + Player_Struct.IsGrounded), a  ; Player.IsGrounded = false
    ld      (ix + Player_Struct.IsAnimating), a ; Player.IsAnimating = false
    ld      (ix + Player_Struct.IsBlocking), a  ; Player.IsBlocking = false
    ld      (ix + Player_Struct.IsCrouching), a ; Player.IsCrouching = false

    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_UP
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_UP
    call    Player_SetAnimation

    ret

Player_Input_Up_Right:

    xor     a
    ld      (ix + Player_Struct.IsGrounded), a  ; Player.IsGrounded = false
    ld      (ix + Player_Struct.IsAnimating), a ; Player.IsAnimating = false
    ld      (ix + Player_Struct.IsBlocking), a  ; Player.IsBlocking = false
    ld      (ix + Player_Struct.IsCrouching), a ; Player.IsCrouching = false

    ; if (side == right) position = JUMPING_BACKWARDS else JUMPING_FORWARD
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.RIGHT
    jp      z, .sideRight

.sideLeft:
    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_FORWARD
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_FORWARD
    call    Player_SetAnimation

    jp      .skip_10

.sideRight:
    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_BACKWARDS
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_BACKWARDS
    call    Player_SetAnimation

.skip_10:

.return:

    ret

Player_Input_Up_Left:

    xor     a
    ld      (ix + Player_Struct.IsGrounded), a  ; Player.IsGrounded = false
    ld      (ix + Player_Struct.IsAnimating), a ; Player.IsAnimating = false
    ld      (ix + Player_Struct.IsBlocking), a  ; Player.IsBlocking = false
    ld      (ix + Player_Struct.IsCrouching), a ; Player.IsCrouching = false

    ; if (side == left) position = JUMPING_BACKWARDS else JUMPING_FORWARD
    ld      a, (ix + Player_Struct.Side)
    cp      SIDE.LEFT
    jp      z, .sideLeft

.sideRight:
    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_FORWARD
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_FORWARD
    call    Player_SetAnimation

    jp      .skip_10

.sideLeft:
    ; --- get addr of animation
    ld      bc, POSITION.JUMPING_BACKWARDS
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.JUMPING_BACKWARDS
    call    Player_SetAnimation

.skip_10:

.return:

    ret

Player_Input_LowKick:

    ; if (player.Position != STANCE) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    ret     nz

    ; Player.IsAnimating = true
    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a

    ; ; Player.IsGrounded = false
    ; xor     a
    ; ld      (ix + Player_Struct.IsGrounded), a

    ; --- get addr of animation
    ld      bc, POSITION.LOW_KICK
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.LOW_KICK
    call    Player_SetAnimation

    ; play sound on OPL4
    ld	   d, SOUND_FX_1
    call   PlaySound


    ret


Player_Input_HighKick:

    ; if (player.Position != STANCE) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    ret     nz

    ; Player.IsAnimating = true
    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a

    ; ; Player.IsGrounded = false
    ; xor     a
    ; ld      (ix + Player_Struct.IsGrounded), a

    ; --- get addr of animation
    ld      bc, POSITION.HIGH_KICK
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.HIGH_KICK
    call    Player_SetAnimation


    ; play sound on OPL4
    ld	   d, SOUND_FX_2
    call   PlaySound


    ret



Player_Input_Uppercut:

    ; if (player.Position != STANCE && player.Position != CROUCHING) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    jp      z, .cont
    cp      POSITION.CROUCHING
    ret     nz

.cont:
    ; Player.IsAnimating = true
    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a

    ; ; Player.IsGrounded = false
    ; xor     a
    ; ld      (ix + Player_Struct.IsGrounded), a

    ; --- get addr of animation
    ld      bc, POSITION.UPPERCUT
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.UPPERCUT
    call    Player_SetAnimation

    ; ; play sound on OPL4
    ; ld	   d, SOUND_FX_1
    ; call   PlaySound

    ret



Player_Input_Down:

    ; if (player.IsCrouching) ret
    ld      a, (ix + Player_Struct.IsCrouching)
    or      a
    ret     nz

    ; if (player.Position != STANCE) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    ret     nz

.skipChecks:

    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a     ; Player.IsAnimating = true
    ld      (ix + Player_Struct.IsCrouching), a     ; Player.IsCrouching = true
    ld      (ix + Player_Struct.IsGrounded), a      ; Player.IsGrounded = true

    xor     a
    ld      (ix + Player_Struct.IsBlocking), a      ; Player.IsBlocking = false

    ; --- get addr of animation
    ld      bc, POSITION.CROUCHING
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.CROUCHING
    call    Player_SetAnimation


    ret



Player_Input_Block:

    ; if (player.IsBlocking) ret
    ld      a, (ix + Player_Struct.IsBlocking)
    or      a
    ret     nz

    ; if (player.Position != STANCE) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.STANCE
    ret     nz

.skipChecks:

    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a     ; Player.IsAnimating = true
    ld      (ix + Player_Struct.IsBlocking), a      ; Player.IsBlocking = true
    ld      (ix + Player_Struct.IsGrounded), a      ; Player.IsGrounded = true

    xor     a
    ld      (ix + Player_Struct.IsCrouching), a     ; Player.IsCrouching = false

    ; --- get addr of animation
    ld      bc, POSITION.BLOCK
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.BLOCK
    call    Player_SetAnimation



    ret



Player_Input_Down_Block:

    ; if (player.IsBlocking) ret
    ld      a, (ix + Player_Struct.IsBlocking)
    or      a
    ret     nz

    ; if (player.Position != CROUCHING) ret
    ld      a, (ix + Player_Struct.Position)
    cp      POSITION.CROUCHING
    ret     nz

    
    ld      a, 1
    ld      (ix + Player_Struct.IsAnimating), a     ; Player.IsAnimating = true
    ld      (ix + Player_Struct.IsBlocking), a      ; Player.IsBlocking = true
    ld      (ix + Player_Struct.IsCrouching), a     ; Player.IsCrouching = true
    ld      (ix + Player_Struct.IsGrounded), a      ; Player.IsGrounded = true


    ; --- get addr of animation
    ld      bc, POSITION.CROUCHING_BLOCK
    call    GetAnimationAddr

    ; --- set animation
    ld      a, POSITION.CROUCHING_BLOCK
    call    Player_SetAnimation



    ret



; Inputs:
;   IX: Player Vars base addr
;   A:  Position (constant POSITION.?)
;   HL: Addr of animation
Player_SetAnimation:
    ld      (ix + Player_Struct.Position), a

    xor     a
    ld      (ix + Player_Struct.Animation_Current_Frame_Number), a
    
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    ld      (ix + Player_Struct.Animation_FirstFrame_Header), l
    ld      (ix + Player_Struct.Animation_FirstFrame_Header + 1), h

    ret


; TODO: Routine to call GetAnimationAddr and Player_SetAnimation (these two are always used together)

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

; Inputs:
;   IX: Player Vars base addr
UpdateHurtbox:

    ; check width <= 16
    ld      a, (ix + Player_Struct.Width)
    cp      16 + 1
    jp      c, .widthSmallerThan_17



    ;---- width > 16

    ; HurtBox_X = Player.X + 8
    ld      a, (ix + Player_Struct.X)
    add     8
    ld      (ix + Player_Struct.HurtBox_X), a

    ; HurtBox_Y = Player.Y
    ld      a, (ix + Player_Struct.Y)
    ld      (ix + Player_Struct.HurtBox_Y), a

    ; HurtBox_Width = Player.Width - 16
    ld      a, (ix + Player_Struct.Width)
    sub     16
    ld      (ix + Player_Struct.HurtBox_Width), a

    ; HurtBox_Height = Player.Height
    ld      a, (ix + Player_Struct.Height)
    ld      (ix + Player_Struct.HurtBox_Height), a

    ret

.widthSmallerThan_17:

    ; HurtBox_X = Player.X
    ld      a, (ix + Player_Struct.X)
    ld      (ix + Player_Struct.HurtBox_X), a

    ; HurtBox_Y = Player.Y
    ld      a, (ix + Player_Struct.Y)
    ld      (ix + Player_Struct.HurtBox_Y), a

    ; HurtBox_Width = Player.Width
    ld      a, (ix + Player_Struct.Width)
    ld      (ix + Player_Struct.HurtBox_Width), a

    ; HurtBox_Height = Player.Height
    ld      a, (ix + Player_Struct.Height)
    ld      (ix + Player_Struct.HurtBox_Height), a

    ret

; Inputs:
;   IX: Player Vars base addr
; Return:
;   carry: inside screen
;   not carry: outside screen
Player_CheckScreenLimitRight:
    ; ----- check screen right limit
    ; if (x >= (255-width)) x = 255 - width
    ld      a, 255
    sub     (ix + Player_Struct.Width)
    ld      b, a ; B = max_valid_X
    ld      a, (ix + Player_Struct.X)
    cp      b       

    ret