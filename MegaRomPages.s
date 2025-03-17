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



MEGAROM_PAGE_FRAME_HEADERS: equ 2

    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frame_headers.s"

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 3 -------------------------------------------------

MEGAROM_PAGE_SCORPION_DATA_0: equ 3

	org	0x8000, 0xBFFF

    ; INCLUDE "Data/scorpion/scorpion_data.s"

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 4 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_DATA_0: equ 4

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frames_0_to_8_data_and_list.s"

MegaROM_Page_4_size: equ $ - 0x8000

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 5 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_DATA_1: equ 5

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frames_9_to_12_data_and_list.s"

	ds PageSize - ($ - 0x8000), 255