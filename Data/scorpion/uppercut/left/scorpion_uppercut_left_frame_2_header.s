;		yOffset	        width	height	megaROM page	List Address
	dw	256 - (128 * 2) db	82,	107,	MEGAROM_PAGE_SCORPION_UPPERCUT_LEFT_DATA_0	dw	Scorpion_Uppercut_Left_Frame_2.List

	; 255 = ignore
	db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
	db  72, 11, 13, 13     ; HitBox (X, Y, Width, Height)           ; 192 x 11 ; 192 --> 192 - 120 = 72  --> (72, 11)
