; TODO: pointers to all animations


Scorpion_All_Animations_Left:
    dw      Scorpion_Stance_Left_Animation_Headers
    dw      Scorpion_Walking_Left_Animation_Headers
    dw      Scorpion_Walking_Backwards_Left_Animation_Headers
    dw      Scorpion_Jumping_Up_Left_Animation_Headers
    dw      Scorpion_Jumping_Forward_Left_Animation_Headers
    dw      Scorpion_Jumping_Backwards_Left_Animation_Headers
    dw      Scorpion_Low_Kick_Left_Animation_Headers
    dw      Scorpion_High_Kick_Left_Animation_Headers

Scorpion_All_Animations_Right:

    dw      0 ; Scorpion_Stance_Right_Animation_Headers              ; POSITION.STANCE = 0
    dw      0 ; Scorpion_Walking_Right_Animation_Headers             ; POSITION.WALKING_FORWARD = 2
    dw      0 ; Scorpion_Walking_Backwards_Right_Animation_Headers   ; POSITION.WALKING_BACKWARDS = 4
    dw      0 ; Scorpion_Jumping_Up_Right_Animation_Headers          ; POSITION.JUMPING_UP = 6
    dw      0 ; Scorpion_Jumping_Forward_Right_Animation_Headers     ; POSITION.JUMPING_FORWARD = 8
    dw      0 ; Scorpion_Jumping_Backwards_Right_Animation_Headers   ; POSITION.JUMPING_BACKWARDS = 10
    dw      0 ; Scorpion_Low_Kick_Right_Animation_Headers            ; POSITION.LOW_KICK = 12
    dw      0 ; Scorpion_High_Kick_Right_Animation_Headers           ; POSITION.HIGH_KICK = 14
