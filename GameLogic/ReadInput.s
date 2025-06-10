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

    ; Common moves that everybody shares:

    ; Uppercut: Down+High Punch

    ; Sweep Kick: Back+Low Kick

    ; Roundhouse: Back+High Kick

    ; Throw opponent: Must be up close to enemy, hold Forward and Press Low Kick
 
    ; ------------------------ read keyboard for player 1 ------------------------

    ; WASD: walk/jump/crouch
    ; E:    block
    ; R:    high punch
    ; F:    low punch
    ; T:    high kick
    ; G:    low kick

    ld      ix, Player_1_Vars

    xor     a
    ld      (TempVars.PlayerInput), a
    ld      (TempVars.PlayerInput_Block), a


    ; TODO:
    ; if (Player.IsAnimating) .skipCheck_P1_Keys


    ld      a, (SNSMAT_Line_2)
    bit     6, a                    ; 6th bit (key A)
    call    z, .player_Input_Left
    
    ld      a, (SNSMAT_Line_3)
    bit     1, a                    ; 1st bit (key D)
    call    z, .player_Input_Right

    ; if Left and Right are pressed, cancel both
    ld      a, (TempVars.PlayerInput)
    and     INPUT_LEFT OR INPUT_RIGHT      ; keep just Left and Right bits
    cp      INPUT_LEFT OR INPUT_RIGHT
    call    z, .resetLeftAndRightBits



    ld      a, (SNSMAT_Line_5)
    bit     4, a                    ; 4th bit (key W)
    call    z, .player_Input_Up

    ld      a, (SNSMAT_Line_5)
    bit     0, a                    ; 0th bit (key S)
    call    z, .player_Input_Down

    ; if Up and Down are pressed, cancel both
    ld      a, (TempVars.PlayerInput)
    and     INPUT_UP OR INPUT_DOWN      ; keep just Up and Down bits
    cp      INPUT_UP OR INPUT_DOWN
    call    z, .resetUpAndDownBits

    
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

    ld      a, (SNSMAT_Line_3)
    bit     3, a                    ; 3th bit (key F)
    call    z, .player_Input_LowPunch



    ; if (Player.IsCrouching && Player.IsBlocking) .check_P1_Down_Block_Released
    ld      a, (ix + Player_Struct.IsCrouching)
    or      a
    jp      z, .cont_10
    ld      a, (ix + Player_Struct.IsBlocking)
    or      a
    jp      nz, .check_P1_Down_Block_Released
.cont_10:

    ; if (Player.IsCrouching) .check_P1_Down_Released
    ld      a, (ix + Player_Struct.IsCrouching)
    or      a
    jp      nz, .check_P1_Down_Released

    ; if (Player.IsBlocking) .check_P1_Block_Released
    ld      a, (ix + Player_Struct.IsBlocking)
    or      a
    jp      nz, .check_P1_Block_Released

    ; if (!Player.IsGrounded) .skipCheck_P1_Keys
    ld      a, (ix + Player_Struct.IsGrounded)
    or      a
    jp      z, .skipCheck_P1_Keys

.cont_P1:

    call    .executePlayerInput




.skipCheck_P1_Keys:




    ; ------------------------ read keyboard for player 2 ------------------------

    ; Arrows: walk/jump/crouch
    ; H:      block
    ; J:      high punch
    ; N:      low punch
    ; K:      high kick
    ; M:      low kick

    ld      ix, Player_2_Vars

    xor     a
    ld      (TempVars.PlayerInput), a
    ld      (TempVars.PlayerInput_Block), a



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

    jp      .cont_P1 ; .skipCheck_P1_Keys

.releaseDown_P1:


    ; --- go to the second part of Down animation (character standing up)

    ; get the first animation frame and add n frames
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ld      bc, RELEASE_CROUCHING_ANIMATION_HEADERS_ADDR_OFFSET
    add     hl, bc
    
    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h



    xor     a
    ld      (ix + Player_Struct.IsCrouching), a

    ret

; ----------

.check_P1_Down_Block_Released:

    ld      a, (SNSMAT_Line_5)
    bit     0, a                    ; 0th bit (key S)
    call    nz, .releaseDownBlock_P1_DownReleased

    ld      a, (SNSMAT_Line_3)
    bit     2, a                    ; 2nd bit (key E)
    call    nz, .releaseDownBlock_P1_BlockReleased

    jp      .skipCheck_P1_Keys

.releaseDownBlock_P1_DownReleased:

    call    Player_Input_Block.skipChecks
    
    ret

.releaseDownBlock_P1_BlockReleased:

    call    Player_Input_Down.skipChecks

    ; --- go to middle of Down animation (character stuck crouching)

    ; get the first animation frame and add n frames
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ld      bc, RELEASE_CROUCHING_ANIMATION_HEADERS_ADDR_OFFSET - 2 ; one addr before, to be stuck in the intermediate frame
    add     hl, bc

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h

    ret


; ----------
.check_P1_Block_Released:

    ld      a, (SNSMAT_Line_3)
    bit     2, a                    ; 2nd bit (key E)
    call    nz, .releaseBlock_P1

    jp      .skipCheck_P1_Keys

.releaseBlock_P1:

    ; --- go to the second part of Block animation (character undoing block movement)

    ; get the first animation frame and add n frames
    ld      l, (ix + Player_Struct.Animation_FirstFrame_Header)
    ld      h, (ix + Player_Struct.Animation_FirstFrame_Header + 1)

    ld      bc, RELEASE_BLOCK_ANIMATION_HEADERS_ADDR_OFFSET
    add     hl, bc

    ; save new frame
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header), l
    ld      (ix + Player_Struct.Animation_CurrentFrame_Header + 1), h



    xor     a
    ld      (ix + Player_Struct.IsBlocking), a

    ret

; -----------------

.player_Input_Up:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_UP
    ld      (TempVars.PlayerInput), a
    ret

.player_Input_Down:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_DOWN
    ld      (TempVars.PlayerInput), a
    ret

.resetUpAndDownBits:
    ld      a, (TempVars.PlayerInput)
    and     0011 1111 b ; NOT (INPUT_UP OR INPUT_DOWN) ; don't work
    ld      (TempVars.PlayerInput), a
    ret

.player_Input_Left:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_LEFT
    ld      (TempVars.PlayerInput), a
    ret

.player_Input_Right:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_RIGHT
    ld      (TempVars.PlayerInput), a
    ret

.resetLeftAndRightBits:
    ld      a, (TempVars.PlayerInput)
    and     1100 1111 b ; NOT (INPUT_LEFT OR INPUT_RIGHT) ; don't work
    ld      (TempVars.PlayerInput), a
    ret

; --------

.player_Input_LowKick:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_LOW_KICK
    ld      (TempVars.PlayerInput), a
    ret

.player_Input_HighKick:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_HIGH_KICK
    ld      (TempVars.PlayerInput), a
    ret

.player_Input_LowPunch:
    ld      a, (TempVars.PlayerInput)
    or      INPUT_LOW_PUNCH
    ld      (TempVars.PlayerInput), a
    ret

; --------

.player_Input_Block:
    ld      a, 1
    ld      (TempVars.PlayerInput_Block), a
    ret

; --------------------------------------------------------------

.executePlayerInput:

    ; if (PlayerInput == INPUT_DOWN/LEFT/RIGHT && PlayerInput_Block) Player_Input_Down_Block();
    ld      a, (TempVars.PlayerInput)
    bit     6, a ; cp      INPUT_DOWN ; Z is set if specified bit is 0; otherwise, it is reset.
    jp      z, .cont_2
    ld      a, (TempVars.PlayerInput_Block)
    or      a
    call    nz, Player_Input_Down_Block
.cont_2:


    ; check only the bit 6 (INPUT_DOWN), so it also works with INPUT_DOWN_LEFT and INPUT_DOWN_RIGHT
    ld      a, (TempVars.PlayerInput)
    bit     6, a ; cp      INPUT_DOWN ; Z is set if specified bit is 0; otherwise, it is reset.
    call    nz, Player_Input_Down





    ld      a, (TempVars.PlayerInput)
    cp      INPUT_UP
    call    z, Player_Input_Up

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_UP_RIGHT
    call    z, Player_Input_Up_Right

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_UP_LEFT
    call    z, Player_Input_Up_Left



    ld      a, (TempVars.PlayerInput_Block)
    or      a
    call    nz, Player_Input_Block



    ld      a, (TempVars.PlayerInput)
    cp      INPUT_LEFT
    call    z, Player_Input_Left

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_RIGHT
    call    z, Player_Input_Right

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_LOW_KICK
    call    z, Player_Input_LowKick

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_HIGH_KICK
    call    z, Player_Input_HighKick

    ld      a, (TempVars.PlayerInput)
    cp      INPUT_LOW_PUNCH
    call    z, Player_Input_LowPunch

    ; if (!PlayerInput && !PlayerInput_Block) Player_SetPosition_Stance();
    ld      a, (TempVars.PlayerInput)
    ld      b, a
    ld      a, (TempVars.PlayerInput_Block)
    or      b
    call    z, Player_SetPosition_Stance
    
    ret
