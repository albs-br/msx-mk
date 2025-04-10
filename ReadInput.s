KEYBOARD:   equ 0
;JOYSTICK:   equ 1

ReadInput:


    ; ---- read keyboard for player 1
    ld      ix, Player_1_Vars

    ; if (!Player.IsGrounded) .skipCheck_P1_Direction_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P1_Direction_Keys

    ld      a, 5                    ; 5th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (Keyboard_Value), a     ; save value

    bit     4, a                    ; 4th bit (key W)
    jp      z, .player_1_Input_Up
;

    ld      a, 2                    ; 2nd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (Keyboard_Value), a     ; save value

    bit     6, a                    ; 6th bit (key A)
    call    z, Player_Input_Left
    
    ; TODO: no need to check right if left was pressed

    ld      a, (Keyboard_Value)
    ld      b, a

    ld      a, 3                    ; 3rd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (Keyboard_Value), a     ; save value

    ; check if both reads of SNSMAT == 255 (no key presed)
    cp      1111 1111 b
    jp      nz, .skip_1
    cp      b
    jp      z, .skip_2

.skip_1:
    ld      a, (Keyboard_Value)
    bit     1, a                    ; 1st bit (key D)
    call    z, Player_Input_Right

    jp      .continue

.skip_2:

    call    Player_Input_None

.skipCheck_P1_Direction_Keys:

.continue:





    ; ---- read keyboard for player 2
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (Keyboard_Value), a     ; save value

    ld      ix, Player_2_Vars

    cp      1111 1111 b
    call    z, Player_Input_None

    ld      a, (Keyboard_Value)
    bit     4, a                    ; 4th bit (key left)
    call    z, Player_Input_Left
    
    ld      a, (Keyboard_Value)
    bit     7, a                    ; 7th bit (key right)
    call    z, Player_Input_Right

    ; ld      a, (Keyboard_Value)
    ; bit     5, e                    ; 5th bit (key up)
    ; call    z, .playerUp

    ; ld      a, (Keyboard_Value)
    ; bit     6, e                    ; 6th bit (key down)
    ; call    z, .playerDown

    ret

.player_1_Input_Up:
    call    Player_Input_Up
    jp      .skipCheck_P1_Direction_Keys