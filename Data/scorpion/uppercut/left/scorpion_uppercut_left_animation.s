Scorpion_Uppercut_Left_Animation_Headers:
	dw Scorpion_Uppercut_Left_Frame_0_Header, Scorpion_Uppercut_Left_Frame_0_Header, Scorpion_Uppercut_Left_Frame_0_Header
	dw Scorpion_Uppercut_Left_Frame_1_Header, Scorpion_Uppercut_Left_Frame_1_Header, Scorpion_Uppercut_Left_Frame_1_Header
	dw Scorpion_Uppercut_Left_Frame_2_Header, Scorpion_Uppercut_Left_Frame_2_Header, Scorpion_Uppercut_Left_Frame_2_Header
	dw Scorpion_Uppercut_Left_Frame_3_Header, Scorpion_Uppercut_Left_Frame_3_Header, Scorpion_Uppercut_Left_Frame_3_Header
	dw Scorpion_Uppercut_Left_Frame_4_Header, Scorpion_Uppercut_Left_Frame_4_Header, Scorpion_Uppercut_Left_Frame_4_Header
	dw Scorpion_Uppercut_Left_Frame_5_Header, Scorpion_Uppercut_Left_Frame_5_Header, Scorpion_Uppercut_Left_Frame_5_Header

    ; frame headers are all stored on MegaROM pages at address 0x8000, 
    ; so the high byte will never be 0x00 or 0x01

	dw 0x0100 ; end of data (end animation)

	; dw 0x0000 ; end of data (loop animation, return to first frame)
	; dw 0x0200 ; end of data (stop animation, keeps the frame while key is pressed, for example during block)
