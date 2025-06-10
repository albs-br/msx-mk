;		yOffset	            width	height	megaROM page	List Address
	dw	1152 - (128 * 20)	db	48,	124,	MEGAROM_PAGE_SCORPION_UPPERCUT_LEFT_DATA_0	dw	Scorpion_Uppercut_Left_Frame_4.List

	; 255 = ignore
	db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
	db  255, 255, 255, 255 ; HitBox (X, Y, Width, Height)
