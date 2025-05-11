Scorpion_Low_Kick_Left_Animation_Headers:
	dw Scorpion_Kick_Left_Frame_0_Header, Scorpion_Kick_Left_Frame_0_Header, Scorpion_Kick_Left_Frame_0_Header
	dw Scorpion_Kick_Left_Frame_1_Header, Scorpion_Kick_Left_Frame_1_Header, Scorpion_Kick_Left_Frame_1_Header
	; dw Scorpion_Kick_Left_Frame_2_Header, Scorpion_Kick_Left_Frame_2_Header, Scorpion_Kick_Left_Frame_2_Header
	dw Scorpion_Kick_Left_Frame_3_Header, Scorpion_Kick_Left_Frame_3_Header, Scorpion_Kick_Left_Frame_3_Header
	; dw Scorpion_Kick_Left_Frame_4_Header, Scorpion_Kick_Left_Frame_4_Header, Scorpion_Kick_Left_Frame_4_Header
	; dw Scorpion_Kick_Left_Frame_5_Header, Scorpion_Kick_Left_Frame_5_Header, Scorpion_Kick_Left_Frame_5_Header
	dw Scorpion_Kick_Left_Frame_6_Header, Scorpion_Kick_Left_Frame_6_Header, Scorpion_Kick_Left_Frame_6_Header
	dw Scorpion_Kick_Left_Frame_3_Header, Scorpion_Kick_Left_Frame_3_Header, Scorpion_Kick_Left_Frame_3_Header
	dw Scorpion_Kick_Left_Frame_1_Header, Scorpion_Kick_Left_Frame_1_Header, Scorpion_Kick_Left_Frame_1_Header
	dw Scorpion_Kick_Left_Frame_0_Header, Scorpion_Kick_Left_Frame_0_Header, Scorpion_Kick_Left_Frame_0_Header

    ; frame headers are all stored on MegaROM pages at address 0x8000, 
    ; so the high byte will never be 0x00 or 0x01

	dw 0x0100 ; end of data (end animation)

    ; dw Scorpion_Kick_Left_Frame_0_Header ; TODO: this frame is not showing, it`s a side effect of 0x0000 working only for looping animations (stance)

	; dw 0x0000 ; end of data (loop animation, return to first frame)
