KEYBOARD:   equ 0
;JOYSTICK:   equ 1

ReadInput:


    ; read keyboard for player 2
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      a, (Keyboard_Value)     ; save value

    ld      ix, Player_2_Vars

    bit     4, e                    ; 4th bit (key left)
    call    z, .player2_Left
    
    ld      a, (Keyboard_Value)
    bit     7, e                    ; 7th bit (key right)
    call    z, .player2_Right

    ; ld      a, (Keyboard_Value)
    ; bit     5, e                    ; 5th bit (key up)
    ; call    z, .playerUp

    ; ld      a, (Keyboard_Value)
    ; bit     6, e                    ; 6th bit (key down)
    ; call    z, .playerDown

    ret

.player2_Left:


    ret

.player2_Right:

    ret
