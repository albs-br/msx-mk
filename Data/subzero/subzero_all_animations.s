Subzero_All_Animations_Left:
    dw      0 ; Subzero_Stance_Left_Animation_Headers
    dw      0 ; Subzero_Walking_Left_Animation_Headers
    dw      0 ; Subzero_Walking_Backwards_Left_Animation_Headers

Subzero_All_Animations_Right:
; TODO: pointers to all animations

    dw      Subzero_Stance_Right_Animation_Headers              ; POSITION.STANCE = 0
    dw      Subzero_Walking_Right_Animation_Headers             ; POSITION.WALKING_FORWARD = 2
    dw      Subzero_Walking_Backwards_Right_Animation_Headers   ; POSITION.WALKING_BACKWARDS = 4