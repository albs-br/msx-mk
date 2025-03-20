KEYBOARD:   equ 0
;JOYSTICK:   equ 1

ReadInput:


    ; ---- read keyboard for player 1
    ld      a, 2                    ; 2nd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ; ld      (Keyboard_Value), a     ; save value

    ld      ix, Player_1_Vars

    bit     6, a                    ; 6th bit (key A)
    call    z, .player_Left
    
    ; TODO: no need to check right if left was pressed
    ld      a, 3                    ; 3rd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ; ld      (Keyboard_Value), a     ; save value

    ; ld      a, (Keyboard_Value)
    bit     1, a                    ; 1st bit (key D)
    call    z, .player_Right




    ; ---- read keyboard for player 2
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (Keyboard_Value), a     ; save value

    ld      ix, Player_2_Vars

    bit     4, a                    ; 4th bit (key left)
    call    z, .player_Left
    
    ld      a, (Keyboard_Value)
    bit     7, a                    ; 7th bit (key right)
    call    z, .player_Right

    ; ld      a, (Keyboard_Value)
    ; bit     5, e                    ; 5th bit (key up)
    ; call    z, .playerUp

    ; ld      a, (Keyboard_Value)
    ; bit     6, e                    ; 6th bit (key down)
    ; call    z, .playerDown

    ret

.player_Left:

    ld      a, (ix + (Player_1_Vars.X - Player_1_Vars))
    cp      2       ; if (X < 2) ret
    ret     c

    sub     2
    ld      (ix + (Player_1_Vars.X - Player_1_Vars)), a

    call    Update_VRAM_NAMTBL_Addr

    ret

.player_Right:

    ld      a, 255
    sub     (ix + (Player_1_Vars.Width - Player_1_Vars))
    ld      b, a
    ld      a, (ix + (Player_1_Vars.X - Player_1_Vars))
    cp      b       ; if (X > (255-width)) ret
    ret     nc

    add     2
    ld      (ix + (Player_1_Vars.X - Player_1_Vars)), a

    call    Update_VRAM_NAMTBL_Addr

    ret
