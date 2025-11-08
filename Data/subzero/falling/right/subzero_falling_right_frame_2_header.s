;		yOffset	width	height	megaROM page	List Address
	dw	1920	db	56,	104,	MEGAROM_PAGE_SUBZERO_FALLING_RIGHT_DATA_0	dw	Subzero_Falling_Right_Frame_2.List

	; 255 = ignore
	db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
	db  255, 255, 255, 255 ; HitBox (X, Y, Width, Height)
