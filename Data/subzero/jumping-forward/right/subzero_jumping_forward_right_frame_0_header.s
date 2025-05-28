;		yOffset	width	height	megaROM page	List Address
	dw	128	db	44,	104,	MEGAROM_PAGE_SUBZERO_JUMPING_FORWARD_RIGHT_DATA_0	dw	Subzero_Jumping_Forward_Right_Frame_0.List

    ; 255 = ignore
    db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
    db  255, 255, 255, 255 ; HitBox (X, Y, Width, Height)