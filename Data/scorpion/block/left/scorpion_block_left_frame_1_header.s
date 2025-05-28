;		yOffset	width	height	megaROM page	List Address
	dw	384	db	52,	104,	MEGAROM_PAGE_SCORPION_BLOCK_LEFT_DATA_0	dw	Scorpion_Block_Left_Frame_1.List

    ; 255 = ignore
    db  255, 255, 255, 255 ; HurtBox (X, Y, Width, Height)
    db  255, 255, 255, 255 ; HitBox (X, Y, Width, Height)