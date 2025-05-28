;		yOffset	width	height	megaROM page	List Address
	dw	512	db	56,	106,	MEGAROM_PAGE_SUBZERO_WALKING_RIGHT_DATA_0	dw	Subzero_Walking_Right_Frame_8.List

    ; 255 = ignore
    db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
    db  255, 255, 255, 255 ; HitBox (X, Y, Width, Height)