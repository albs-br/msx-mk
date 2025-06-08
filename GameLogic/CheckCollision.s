CheckCollision_Hurtboxes:
    push    ix, iy
        ld      ix, Player_1_Vars.HurtBox
        ld      iy, Player_2_Vars.HurtBox
        call    CheckCollision_Obj1xObj2
        jp      c, .collision
        jp      .return

    .collision:

        call    PushPlayersApart

    .return:
    
        ld      ix, Player_1_Vars
        call    UpdateHurtbox
        call    Update_VRAM_NAMTBL_Addr

        ld      ix, Player_2_Vars
        call    UpdateHurtbox
        call    Update_VRAM_NAMTBL_Addr

    pop     iy, ix

    ret



;  Calculates whether a collision occurs between two objects
; IN: 
;   IX: addr of object 1 (format: X, Y, width, height)
;   IY: addr of object 2 (format: X, Y, width, height)
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_Obj1xObj2:

        ld      a, (iy + Object_Struct.X)   ; get x2
        sub     (ix + Object_Struct.X)      ; calculate x2 - x1
        jr      c, .x1IsLarger              ; jump if x2 < x1
        sub     (ix + Object_Struct.Width)  ; compare with width 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      b, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, b
    
        sub     (iy + Object_Struct.Width)  ; compare with width 2
        ret     nc                          ; return if no collision

.checkVerticalCollision:
        ld      a, (iy + Object_Struct.Y)   ; get y2
        sub     (ix + Object_Struct.Y)      ; calculate y2 - y1
        jr      c, .y1IsLarger              ; jump if y2 < y1
        sub     (ix + Object_Struct.Height) ; compare with height 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      c, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, c
    
        sub     (iy + Object_Struct.Height) ; compare with height 2
        ret                                 ; return collision or no collision



CheckCollision_Hitboxes:
    
    ; ---- Player 1 Hitbox x Player 2 Hurtbox
    push    ix, iy

        ld      ix, Player_1_Vars
        ld      iy, Player_2_Vars

        ; if (Player_1.HitBox_X == 255) return;
        ld      a, (ix + Player_Struct.HitBox_X) ; IX: Player_1
        inc     a
        jp      z, .return

        ; if (Player_2.IsBlocking) return;
        ld      a, (iy + Player_Struct.IsBlocking) ; IY: Player_2
        or      a
        jp      nz, .return



        ld      ix, Player_1_Vars.HitBox
        ld      iy, Player_2_Vars.HurtBox
        call    CheckCollision_Obj1xObj2
        jp      c, .collision
        jp      .return

    .collision:

        ld      ix, Player_2_Vars

        ; if (!Player_2.IsGrounded) return;
        ld      a, (ix + Player_Struct.IsGrounded) ; IX: Player_2
        or      a
        jp      z, .return

        ; Player.IsAnimating = true
        ld      a, 1
        ld      (ix + Player_Struct.IsAnimating), a



        ; --- get addr of animation
        ld      bc, POSITION.HURT_1
        call    GetAnimationAddr

        ; --- set animation
        ld      a, POSITION.HURT_1
        call    Player_SetAnimation



        ; play sound on OPL4
        ld	   d, SOUND_FX_0
        call   PlaySound



        call    PushPlayersApart

        ld      ix, Player_1_Vars
        call    UpdateHurtbox
        call    Update_VRAM_NAMTBL_Addr

        ld      ix, Player_2_Vars
        call    UpdateHurtbox
        call    Update_VRAM_NAMTBL_Addr

    .return:

    pop     iy, ix

    ret




PushPlayersApart:
        ld      ix, Player_1_Vars
        ld      iy, Player_2_Vars

        ; if (Player_1.X > Player_2.X)
        ld      a, (ix + Player_Struct.X)
        cp      (iy + Player_Struct.X)
        jp      nc, .x1_isLarger

    
    ;x2_isLarger:
        ; if (x1 >= 2)
        ; ----- check screen left limit
        ld      a, (ix + Player_Struct.X)
        cp      2       ; if (X < 2) ret
        jp      c, .cont_10
        ; x1 -= 2
        ; ld      a, (ix + Player_Struct.X)
        sub     2
        ld      (ix + Player_Struct.X), a

    .cont_10:
        ; if (x2 + width2 <= 255)
        push    ix
            push    iy ; IX = IY
            pop     ix
            call    Player_CheckScreenLimitRight
        pop     ix
        jp      nc, .return
        ; x2 += 2
        ld      a, (iy + Player_Struct.X)
        add     2
        ld      (iy + Player_Struct.X), a

        jp      .return
    .x1_isLarger: ; or equal
        ; if (x1 + width1 <= 255)
        call    Player_CheckScreenLimitRight
        jp      nc, .cont_2
        ; x1 += 2
        ld      a, (ix + Player_Struct.X)
        add     2
        ld      (ix + Player_Struct.X), a
    
    .cont_2:
        ; if (x2 >= 2)
        ; ----- check screen left limit
        ld      a, (iy + Player_Struct.X)
        cp      2       ; if (X < 2) ret
        jp      c, .return
        ; x2 -= 2
        ;ld      a, (iy + Player_Struct.X)
        sub     2
        ld      (iy + Player_Struct.X), a
    
    .return:
    
        ; ld      ix, Player_1_Vars
        ; call    UpdateHurtbox
        ; call    Update_VRAM_NAMTBL_Addr

        ; ld      ix, Player_2_Vars
        ; call    UpdateHurtbox
        ; call    Update_VRAM_NAMTBL_Addr

    ret

; ;  Calculates whether a collision occurs between Player 1 and 2
; ; IN: 
; ; OUT: Carry set if collision
; ; CHANGES: AF
; CheckCollision_Player_1_x_Player_2:

;         ; not worth the trouble...

;         ; 24 cycles
;         ld      a, (Player_1_Vars.X)
;         ld      b, a
;         sub     b

;         sub     (ix + Player_Struct.X) ; 21 cycles...

;         ld      a, (Player_2_Vars.X)        ; get x2
;         sub     (Player_1_Vars.X)           ; calculate x2 - x1
;         jr      c, .x1IsLarger              ; jump if x2 < x1
;         sub     (Player_1_Vars.Width)       ; compare with width 1
;         ret     nc                          ; return if no collision
;         jp      .checkVerticalCollision
; .x1IsLarger:
;         neg                                 ; use negative value (Z80)
;         ; emulate neg instruction (Gameboy)
;         ; ld      b, a
;         ; xor     a                           ; same as ld a, 0
;         ; sub     a, b
    
;         sub     (Player_2_Vars.Width)       ; compare with width 2
;         ret     nc                          ; return if no collision

; .checkVerticalCollision:
;         ld      a, (iy + Player_Struct.Y)   ; get y2
;         sub     (ix + Player_Struct.Y)      ; calculate y2 - y1
;         jr      c, .y1IsLarger              ; jump if y2 < y1
;         sub     (ix + Player_Struct.Height) ; compare with height 1
;         ret                                 ; return collision or no collision
; .y1IsLarger:
;         neg                                 ; use negative value (Z80)
;         ; emulate neg instruction (Gameboy)
;         ; ld      c, a
;         ; xor     a                           ; same as ld a, 0
;         ; sub     a, c
    
;         sub     (iy + Player_Struct.Height) ; compare with height 2
;         ret                                 ; return collision or no collision


