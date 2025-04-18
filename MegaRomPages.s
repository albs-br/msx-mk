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

    INCLUDE "Data/scorpion/stance/left/scorpion_stance_left_frame_headers.s"
    INCLUDE "Data/scorpion/walking/left/scorpion_walking_left_frame_headers.s"
    INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frame_headers.s"
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frame_headers.s"
    ; TODO: repeat for right

    ; TODO: repeat for left
    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frame_headers.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_right_frame_headers.s"
    INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frame_headers.s"
    ; INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frame_headers.s"


	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 3 -------------------------------------------------

MEGAROM_PAGE_SCORPION_DATA_0: equ 3

	org	0x8000, 0xBFFF

    INCLUDE "Data/scorpion/stance/left/scorpion_stance_left_frames_0_to_6_data_and_list.s"

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

; ------------------------------------------------- Page 6 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_WALKING_RIGHT_DATA_0: equ 6

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/walking/right/subzero_walking_right_frames_0_to_8_data_and_list.s"

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 7 -------------------------------------------------

MEGAROM_PAGE_SCORPION_WALKING_LEFT_DATA_0: equ 7

	org	0x8000, 0xBFFF

    INCLUDE "Data/scorpion/walking/left/scorpion_walking_left_frames_0_to_8_data_and_list.s"

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 8 -------------------------------------------------

MEGAROM_PAGE_SCORPION_JUMPING_UP_LEFT_DATA_0: equ 8
MEGAROM_PAGE_SCORPION_JUMPING_FORWARD_LEFT_DATA_0: equ 8

	org	0x8000, 0xBFFF

; ------------------------------------------------------------------------

    ; Data
	INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frames_0_to_2_data.s"
	INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frames_0_to_7_data.s"

; ------------------------------------------------------------------------

    ; List
    INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frames_0_to_2_data_and_list.s"
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frames_0_to_7_data_and_list.s"

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 9 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_JUMPING_UP_RIGHT_DATA_0: equ 9
MEGAROM_PAGE_SUBZERO_JUMPING_FORWARD_RIGHT_DATA_0: equ 9

	org	0x8000, 0xBFFF

; ------------------------------------------------------------------------

    ; Data
	INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frames_0_to_2_data.s"
	; INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frames_0_to_7_data.s"

; ------------------------------------------------------------------------

    ; List
    INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frames_0_to_2_data_and_list.s"
    ; INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frames_0_to_7_data_and_list.s"

	ds PageSize - ($ - 0x8000), 255
