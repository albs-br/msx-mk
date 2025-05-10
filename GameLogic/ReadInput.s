KEYBOARD:   equ 0
;JOYSTICK:   equ 1


INPUT_UP:           equ 1000 0000 b
INPUT_DOWN:         equ 0100 0000 b
INPUT_LEFT:         equ 0010 0000 b
INPUT_RIGHT:        equ 0001 0000 b
INPUT_UP_RIGHT:     equ 1001 0000 b
INPUT_DOWN_RIGHT:   equ 0101 0000 b
INPUT_UP_LEFT:      equ 1010 0000 b
INPUT_DOWN_LEFT:    equ 0110 0000 b

INPUT_LOW_KICK:     equ 0000 0001 b


ReadInput:


    ; ------------------------ read keyboard for player 1 ------------------------

    ; WASD: walk/jump/crouch
    ; E:    block
    ; R:    high punch
    ; F:    low punch
    ; T:    high kick
    ; G:    low kick

    ld      ix, Player_1_Vars

    xor     a
    ld      (PlayerInput), a

    ; if (!Player.IsGrounded) .skipCheck_P1_Direction_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P1_Direction_Keys



    ld      a, 2                    ; 2nd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    bit     6, a                    ; 6th bit (key A)
    call    z, .player_Input_Left
    
    ; TODO: no need to check right if left was pressed

    ld      a, 3                    ; 3rd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Saved), a
    bit     1, a                    ; 1st bit (key D)
    call    z, .player_Input_Right

    ; ld      a, (SNSMAT_Saved)
    ; bit     4, a                    ; 4th bit (key G)
    ; call    z, .player_Input_LowKick


    ld      a, 5                    ; 5th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    bit     4, a                    ; 4th bit (key W)
    call    z, .player_Input_Up




    call    .executePlayerInput




.skipCheck_P1_Direction_Keys:


    ; ------------------------ read keyboard for player 2 ------------------------

    ; Arrows: walk/jump/crouch
    ; H:      block
    ; J:      high punch
    ; N:      low punch
    ; K:      high kick
    ; M:      low kick

    ld      ix, Player_2_Vars

    xor     a
    ld      (PlayerInput), a



    ; if (!Player.IsGrounded) .skipCheck_P2_Direction_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P2_Direction_Keys



    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Saved), a
    bit     4, a                    ; 4th bit (key left)
    call    z, .player_Input_Left
    
    ld      a, (SNSMAT_Saved)
    bit     7, a                    ; 7th bit (key right)
    call    z, .player_Input_Right

    ld      a, (SNSMAT_Saved)
    bit     5, a                    ; 5th bit (key up)
    call    z, .player_Input_Up

    ; ld      a, (SNSMAT_Saved)
    ; bit     6, a                    ; 6th bit (key down)
    ; call    z, .player_Input_Down




    call    .executePlayerInput




.skipCheck_P2_Direction_Keys:

    ; TODO: action buttons here

    ret

; -----------------

.player_Input_Up:
    ld      a, (PlayerInput)
    or      INPUT_UP
    ld      (PlayerInput), a
    ret

.player_Input_Left:
    ld      a, (PlayerInput)
    or      INPUT_LEFT
    ld      (PlayerInput), a
    ret

.player_Input_Right:
    ld      a, (PlayerInput)
    or      INPUT_RIGHT
    ld      (PlayerInput), a
    ret

; .player_Input_LowKick:
;     ld      a, INPUT_LOW_KICK
;     ld      (PlayerInput), a
;     ret

; ------------

.executePlayerInput:

    ld      a, (PlayerInput)
    cp      INPUT_UP
    call    z, Player_Input_Up

    ld      a, (PlayerInput)
    cp      INPUT_UP_RIGHT
    call    z, Player_Input_Up_Right

    ld      a, (PlayerInput)
    cp      INPUT_UP_LEFT
    call    z, Player_Input_Up_Left

    ld      a, (PlayerInput)
    cp      INPUT_LEFT
    call    z, Player_Input_Left

    ld      a, (PlayerInput)
    cp      INPUT_RIGHT
    call    z, Player_Input_Right

    ; else
    ld      a, (PlayerInput)
    or      a
    call    z, Player_SetPosition_Stance
    
    ret
