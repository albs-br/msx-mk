; MegaROM pages at 0x8000

; ------------------------------------------------- Page 1 -------------------------------------------------

MEGAROM_PAGE_BG_0: equ 1

	org	0x8000, 0xBFFF
Bg_Top:
    INCBIN "Images/mk-bg-top.sc5"
.size:      equ $ - Bg_Top
	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 2 -------------------------------------------------

MEGAROM_PAGE_BG_1: equ 2

	org	0x8000, 0xBFFF
Bg_Bottom:
    INCBIN "Images/mk-bg-bottom.sc5"
.size:      equ $ - Bg_Bottom
	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 3 -------------------------------------------------

MEGAROM_PAGE_SCORPION_DATA_0: equ 3

	org	0x8000, 0xBFFF
Scorpion_Data_Start:
    INCLUDE "Data/scorpion/scorpion_data.s"
Scorpion_Data_Start_size:      equ $ - Scorpion_Data_Start ; 0x3270

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 4 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_DATA_0: equ 4

	org	0x8000, 0xBFFF
Subzero_Data_Start:
    INCLUDE "Data/subzero/subzero_data.s"
Subzero_Data_Start_size:      equ $ - Subzero_Data_Start ; 0x2F5A (only 7 frames)

	ds PageSize - ($ - 0x8000), 255