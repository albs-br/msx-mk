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
INPUT_HIGH_KICK:    equ 0000 0010 b
INPUT_LOW_PUNCH:    equ 0000 0100 b
INPUT_HIGH_PUNCH:   equ 0000 1000 b



ReadInput:

    ; ----- read keyboard
    ld      a, 2                    ; 2nd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Line_2), a
    
    ld      a, 3                    ; 3rd line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Line_3), a
    
    ld      a, 5                    ; 5th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Line_5), a

    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT             ; Read Data Of Specified Line From Keyboard Matrix
    ld      (SNSMAT_Line_8), a



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
    ld      (PlayerInput_Block), a

    ; if (Player.IsCrouching) .check_P1_Down_Released
    ld      a, (ix + Player_Struct.IsCrouching)
    or      a
    jp      nz, .check_P1_Down_Released

    ; if (Player.IsBlocking) .check_P1_Block_Released
    ld      a, (ix + Player_Struct.IsBlocking)
    or      a
    jp      nz, .check_P1_Block_Released

    ; if (!Player.IsGrounded) .skipCheck_P1_Direction_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P1_Direction_Keys



    ld      a, (SNSMAT_Line_2)
    bit     6, a                    ; 6th bit (key A)
    call    z, .player_Input_Left
    
    ; TODO: no need to check right if left was pressed

    ld      a, (SNSMAT_Line_3)
    bit     1, a                    ; 1st bit (key D)
    call    z, .player_Input_Right

    ld      a, (SNSMAT_Line_5)
    bit     4, a                    ; 4th bit (key W)
    call    z, .player_Input_Up

    ld      a, (SNSMAT_Line_5)
    bit     0, a                    ; 0th bit (key S)
    call    z, .player_Input_Down


    
    ; ----- action buttons here

    ld      a, (SNSMAT_Line_3)
    bit     2, a                    ; 2nd bit (key E)
    call    z, .player_Input_Block

    ld      a, (SNSMAT_Line_5)
    bit     1, a                    ; 1st bit (key T)
    call    z, .player_Input_HighKick

    ld      a, (SNSMAT_Line_3)
    bit     4, a                    ; 4th bit (key G)
    call    z, .player_Input_LowKick






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
    ld      (PlayerInput_Block), a



    ; if (!Player.IsGrounded) .skipCheck_P2_Direction_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P2_Direction_Keys



    ld      a, (SNSMAT_Line_8)
    bit     4, a                    ; 4th bit (key left)
    call    z, .player_Input_Left
    
    ld      a, (SNSMAT_Line_8)
    bit     7, a                    ; 7th bit (key right)
    call    z, .player_Input_Right

    ld      a, (SNSMAT_Line_8)
    bit     5, a                    ; 5th bit (key up)
    call    z, .player_Input_Up

    ; ld      a, (SNSMAT_Line_8)
    ; bit     6, a                    ; 6th bit (key down)
    ; call    z, .player_Input_Down


    ; --- action buttons here



    call    .executePlayerInput




.skipCheck_P2_Direction_Keys:



    ret

; ----------

.check_P1_Down_Released:

    ld      a, (SNSMAT_Line_5)
    bit     0, a                    ; 0th bit (key S)
    call    nz, .releaseDown_P1

    jp      .skipCheck_P1_Direction_Keys

.releaseDown_P1:

    ld      hl, Scorpion_Crouching_Left_Animation_Headers.RELEASE_CROUCHING_ANIMATION_HEADERS_ADDR

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    xor     a
    ld      (ix + Player_Struct.IsCrouching), a

    ret

; ----------

.check_P1_Block_Released:

    ld      a, (SNSMAT_Line_3)
    bit     2, a                    ; 2nd bit (key E)
    call    nz, .releaseBlock_P1

    jp      .skipCheck_P1_Direction_Keys

.releaseBlock_P1:

    ld      hl, Scorpion_Block_Left_Animation_Headers.RELEASE_BLOCK_ANIMATION_HEADERS_ADDR

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    xor     a
    ld      (ix + Player_Struct.IsBlocking), a

    ret

; -----------------

.player_Input_Up:
    ld      a, (PlayerInput)
    or      INPUT_UP
    ld      (PlayerInput), a
    ret

.player_Input_Down:
    ld      a, (PlayerInput)
    or      INPUT_DOWN
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

; --------

.player_Input_LowKick:
    ld      a, (PlayerInput)
    or      INPUT_LOW_KICK
    ld      (PlayerInput), a
    ret

.player_Input_HighKick:
    ld      a, (PlayerInput)
    or      INPUT_HIGH_KICK
    ld      (PlayerInput), a
    ret

; --------

.player_Input_Block:
    ld      a, 1
    ld      (PlayerInput_Block), a
    ret

; --------------------------------------------------------------

.executePlayerInput:

    ; ld      a, (PlayerInput)
    ; cp      INPUT_UP OR INPUT_DOWN
    ; jp      z, .ignoreUpAndDown

    ld      a, (PlayerInput)
    cp      INPUT_UP
    call    z, Player_Input_Up

    ld      a, (PlayerInput)
    cp      INPUT_DOWN
    call    z, Player_Input_Down

; .ignoreUpAndDown:

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

    ld      a, (PlayerInput)
    cp      INPUT_LOW_KICK
    call    z, Player_Input_LowKick

    ld      a, (PlayerInput)
    cp      INPUT_HIGH_KICK
    call    z, Player_Input_HighKick

    ld      a, (PlayerInput_Block) ; TODO: these two labels are very similar, rename one of them
    or      a
    call    nz, Player_Input_Block ; TODO: these two labels are very similar, rename one of them

    ; if (!PlayerInput && !PlayerInput_Block) Player_SetPosition_Stance();
    ld      a, (PlayerInput)
    ld      b, a
    ld      a, (PlayerInput_Block)
    or      b
    call    z, Player_SetPosition_Stance
    
    ret
