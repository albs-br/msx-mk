;		yOffset	width	height	megaROM page	List Address
	dw	1664	db	78,	104,	MEGAROM_PAGE_SCORPION_KICK_LEFT_DATA_0	dw	Scorpion_Kick_Left_Frame_4.List

    ; 255 = ignore
    db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
    db  64, 116-104, 13, 13 ; HitBox (X, Y, Width, Height)