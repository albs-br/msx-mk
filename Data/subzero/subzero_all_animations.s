Subzero_All_Animations_Left:
    dw      0 ; Subzero_Stance_Left_Animation_Headers
    dw      0 ; Subzero_Walking_Left_Animation_Headers
    dw      0 ; Subzero_Walking_Backwards_Left_Animation_Headers
    dw      0 ; Subzero_Jumping_Up_Left_Animation_Headers
    dw      0 ; Subzero_Jumping_Forward_Left_Animation_Headers
    dw      0 ; Subzero_Jumping_Backwards_Left_Animation_Headers
    dw      0 ; Subzero_Low_Kick_Left_Animation_Headers
    dw      0 ; Subzero_High_Kick_Left_Animation_Headers
    dw      0 ; Subzero_Block_Left_Animation_Headers
    dw      0 ; Subzero_Crouching_Left_Animation_Headers
    dw      0 ; Subzero_Crouching_Block_Left_Animation_Headers
    dw      0 ; Subzero_Hurt_1_Left_Animation_Headers
    dw      0 ; Subzero_Uppercut_Left_Animation_Headers
    dw      0 ; Subzero_Falling_Left_Animation_Headers

Subzero_All_Animations_Right:
; TODO: pointers to all animations

    dw      Subzero_Stance_Right_Animation_Headers              ; POSITION.STANCE = 0
    dw      Subzero_Walking_Right_Animation_Headers             ; POSITION.WALKING_FORWARD = 2
    dw      Subzero_Walking_Backwards_Right_Animation_Headers   ; POSITION.WALKING_BACKWARDS = 4
    dw      Subzero_Jumping_Up_Right_Animation_Headers          ; POSITION.JUMPING_UP = 6
    dw      Subzero_Jumping_Forward_Right_Animation_Headers     ; POSITION.JUMPING_FORWARD = 8
    dw      Subzero_Jumping_Backwards_Right_Animation_Headers   ; POSITION.JUMPING_BACKWARDS = 10
    dw      0 ; Subzero_Low_Kick_Right_Animation_Headers        ; POSITION.LOW_KICK = 12
    dw      0 ; Subzero_High_Kick_Right_Animation_Headers       ; POSITION.HIGH_KICK = 14
    dw      0 ; Subzero_Block_Right_Animation_Headers           ; POSITION.BLOCK = 16
    dw      0 ; Subzero_Crouching_Right_Animation_Headers       ; POSITION.CROUCHING = 18
    dw      0 ; Subzero_Crouching_Block_Right_Animation_Headers ; POSITION.CROUCHING_BLOCK = 20
    dw      Subzero_Hurt_1_Right_Animation_Headers              ; POSITION.HURT_1 = 22
    dw      0 ; Subzero_Uppercut_1_Right_Animation_Headers      ; POSITION.UPPERCUT = 24
    dw      Subzero_Falling_Right_Animation_Headers             ; POSITION.FALLING = 26