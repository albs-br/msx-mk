; MegaROM pages at 0x8000

; ------------------------------------------------- Page 1 -------------------------------------------------

MEGAROM_PAGE_BG_GOROS_LAIR_0: equ 1

	org	0x8000, 0xBFFF
Bg_Top:
    INCBIN "Images/mk-bg-top.sc5"
.size:      equ $ - Bg_Top
	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 2 -------------------------------------------------

MEGAROM_PAGE_BG_GOROS_LAIR_1: equ 2

	org	0x8000, 0xBFFF
Bg_Bottom:
    INCBIN "Images/mk-bg-bottom.sc5"
.size:      equ $ - Bg_Bottom



MEGAROM_PAGE_FRAME_HEADERS: equ 2

    ; -------------- Scorpion

    INCLUDE "Data/scorpion/stance/left/scorpion_stance_left_frame_headers.s"
    INCLUDE "Data/scorpion/walking/left/scorpion_walking_left_frame_headers.s"
    INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frame_headers.s"
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frame_headers.s"
    INCLUDE "Data/scorpion/kick/left/scorpion_kick_left_frame_headers.s"
    INCLUDE "Data/scorpion/block/left/scorpion_block_left_frame_headers.s"
    INCLUDE "Data/scorpion/crouching/left/scorpion_crouching_left_frame_headers.s"
    INCLUDE "Data/scorpion/crouching-block/left/scorpion_crouching_block_left_frame_headers.s"
    ; INCLUDE "Data/scorpion/hurt-1/left/scorpion_hurt_1_left_frame_headers.s"
    INCLUDE "Data/scorpion/uppercut/left/scorpion_uppercut_left_frame_headers.s"
    ; INCLUDE "Data/subzero/falling/left/subzero_falling_left_frame_headers.s"
    
    ; TODO: repeat for right


    
    ; -------------- Subzero

    ; TODO: repeat for left
    
    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frame_headers.s"
    INCLUDE "Data/subzero/walking/right/subzero_walking_right_frame_headers.s"
    INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frame_headers.s"
    INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frame_headers.s"
    ; INCLUDE "Data/subzero/kick/right/subzero_kick_right_frame_headers.s"
    ; INCLUDE "Data/subzero/block/right/subzero_block_right_frame_headers.s"
    ; INCLUDE "Data/subzero/crouching/right/subzero_crouching_right_frame_headers.s"
    ; INCLUDE "Data/subzero/crouching-block/right/subzero_crouching_block_right_frame_headers.s"
    INCLUDE "Data/subzero/hurt-1/right/subzero_hurt_1_right_frame_headers.s"
    ; INCLUDE "Data/subzero/uppercut/right/subzero_uppercut_right_frame_headers.s"
    INCLUDE "Data/subzero/falling/right/subzero_falling_right_frame_headers.s"

MegaRom_Page_2_size: equ $ - 0x8000 ; 0x3b12

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 3 -------------------------------------------------

MEGAROM_PAGE_SCORPION_STANCE_LEFT_DATA_0: equ 3

	org	0x8000, 0xBFFF

    INCLUDE "Data/scorpion/stance/left/scorpion_stance_left_frames_0_to_6_data_and_list.s"

MegaRom_Page_3_size: equ $ - 0x8000 ; 0x31a1

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 4 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_STANCE_RIGHT_DATA_0: equ 4

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frames_0_to_8_data_and_list.s"

MegaRom_Page_4_size: equ $ - 0x8000 ; 0x3cd5

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 5 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_STANCE_RIGHT_DATA_1: equ 5

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/stance/right/subzero_stance_right_frames_9_to_12_data_and_list.s"

MegaRom_Page_5_size: equ $ - 0x8000 ; 0x1afd

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 6 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_WALKING_RIGHT_DATA_0: equ 6

	org	0x8000, 0xBFFF

    INCLUDE "Data/subzero/walking/right/subzero_walking_right_frames_0_to_8_data_and_list.s"

MegaRom_Page_6_size: equ $ - 0x8000 ; 0x3a2b

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 7 -------------------------------------------------

MEGAROM_PAGE_SCORPION_WALKING_LEFT_DATA_0: equ 7

	org	0x8000, 0xBFFF

    INCLUDE "Data/scorpion/walking/left/scorpion_walking_left_frames_0_to_8_data_and_list.s"

MegaRom_Page_7_size: equ $ - 0x8000 ; 0x3a2b

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 8 -------------------------------------------------

MEGAROM_PAGE_SCORPION_JUMPING_UP_LEFT_DATA_0: equ 8
MEGAROM_PAGE_SCORPION_JUMPING_FORWARD_LEFT_DATA_0: equ 8

	org	0x8000, 0xBFFF

    ; ------------ Data ---------------
	INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frames_0_to_2_data.s"
	INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frames_0_to_7_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/scorpion/jumping-up/left/scorpion_jumping_up_left_frames_0_to_2_list.s"
    INCLUDE "Data/scorpion/jumping-forward/left/scorpion_jumping_forward_left_frames_0_to_7_list.s"

MegaRom_Page_8_size: equ $ - 0x8000 ; 0x2bcd

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 9 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_JUMPING_UP_RIGHT_DATA_0: equ 9
MEGAROM_PAGE_SUBZERO_JUMPING_FORWARD_RIGHT_DATA_0: equ 9

	org	0x8000, 0xBFFF

    ; ------------ Data ---------------
	INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frames_0_to_2_data.s"
	INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frames_0_to_7_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/subzero/jumping-up/right/subzero_jumping_up_right_frames_0_to_2_list.s"
    INCLUDE "Data/subzero/jumping-forward/right/subzero_jumping_forward_right_frames_0_to_7_list.s"

MegaRom_Page_9_size: equ $ - 0x8000 ; 0x2be0

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 10 -------------------------------------------------

MEGAROM_PAGE_SCORPION_KICK_LEFT_DATA_0: equ 10


	org	0x8000, 0xBFFF

    ; ------------ Data ---------------
	INCLUDE "Data/scorpion/kick/left/scorpion_kick_left_frames_0_to_6_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/scorpion/kick/left/scorpion_kick_left_frames_0_to_6_list.s"

MegaRom_Page_10_size: equ $ - 0x8000 ; 0x27c7

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 11 -------------------------------------------------

MEGAROM_PAGE_SCORPION_BLOCK_LEFT_DATA_0: equ 11
MEGAROM_PAGE_SCORPION_CROUCHING_LEFT_DATA_0: equ 11
MEGAROM_PAGE_SCORPION_CROUCHING_BLOCK_LEFT_DATA_0: equ 11


	org	0x8000, 0xBFFF

    ; ------------ Data ---------------

	INCLUDE "Data/scorpion/block/left/scorpion_block_left_frames_0_to_2_data.s"
	INCLUDE "Data/scorpion/crouching/left/scorpion_crouching_left_frames_0_to_2_data.s"
	INCLUDE "Data/scorpion/crouching-block/left/scorpion_crouching_block_left_frames_0_to_0_data.s"

data_size: equ $ - 0x8000 ; 0x1a84

list_start:
    ; ------------ List ---------------
    INCLUDE "Data/scorpion/block/left/scorpion_block_left_frames_0_to_2_list.s"
    INCLUDE "Data/scorpion/crouching/left/scorpion_crouching_left_frames_0_to_2_list.s"
    INCLUDE "Data/scorpion/crouching-block/left/scorpion_crouching_block_left_frames_0_to_0_list.s"
list_size: equ $ - list_start ; 0x0d53


MegaRom_Page_11_size: equ $ - 0x8000 ; 0x27d7 = ?       ;  16384 - ? = ?

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 12 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_HURT_1_RIGHT_DATA_0: equ 12


	org	0x8000, 0xBFFF

    ; ------------ Data ---------------
	INCLUDE "Data/subzero/hurt-1/right/subzero_hurt_1_right_frames_0_to_3_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/subzero/hurt-1/right/subzero_hurt_1_right_frames_0_to_3_list.s"


MegaRom_Page_12_size: equ $ - 0x8000 ; 0x176b = 5995 bytes       ;  16384 - 5995 = 10309 bytes free

	ds PageSize - ($ - 0x8000), 255




; ------------------------------------------------- Pages 13 to 16 -------------------------------------------------

MEGAROM_PAGE_SOUNDS_HEADERS: equ 13
MEGAROM_PAGES_SOUNDS_DATA: equ 13


	org	0x00
    INCLUDE "Sounds/Headers.s"
SoundsHeaders_size: equ $ - 0x00 ; 0x30 = ? bytes


    org    0x201200
    INCLUDE "Sounds/Data.s"
SoundsData_size: equ $ - 0x201200 ; 0x5460 = ? bytes


    ds     0x201200 + (PageSize * 4) - $ - SoundsHeaders_size ; fill with zeroes

SoundsTotal_size: equ SoundsHeaders_size + SoundsData_size ; 0x05490 = 21648 bytes ; this value must be less than 64 kb (4 megarom pages)
; WARNING: currently loading only the first 48 kb


; ------------------------------------------------- Page 17 -------------------------------------------------

MEGAROM_PAGE_SUBZERO_FALLING_RIGHT_DATA_0: equ 17

	org	0x8000, 0xBFFF


    ; ------------ Data ---------------
	INCLUDE "Data/subzero/falling/right/subzero_falling_right_frames_0_to_10_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/subzero/falling/right/subzero_falling_right_frames_0_to_10_list.s"


MegaRom_Page_17_size: equ $ - 0x8000 ; 0x3312 = ? bytes       ;  16384 - ? = ?

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 18 -------------------------------------------------

MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0: equ 18

	org	0x8000, 0xBFFF
Bg_Choose_Fighter_Screen_Part_0:
    INCBIN "Images/choose-fighter-screen-parts_aa.sr8.zx0"
;.size:      equ $ - Bg_Choose_Fighter_Screen_Part_0

Bg_Choose_Fighter_Screen_Part_1:
    INCBIN "Images/choose-fighter-screen-parts_ab.sr8.zx0"

Bg_Choose_Fighter_Screen_Part_2:
    INCBIN "Images/choose-fighter-screen-parts_ac.sr8.zx0"

Bg_Choose_Fighter_Screen_Part_3:
    INCBIN "Images/choose-fighter-screen-parts_ad.sr8.zx0"

MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_0_size:      equ $ - Bg_Choose_Fighter_Screen_Part_0

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 19 -------------------------------------------------

MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_1: equ 19
MEGAROM_PAGE_BG_TITLE_0: equ 19

	org	0x8000, 0xBFFF
Bg_Choose_Fighter_Screen_Part_4:
    INCBIN "Images/choose-fighter-screen-parts_ae.sr8.zx0"

Bg_Choose_Fighter_Screen_Part_5:
    INCBIN "Images/choose-fighter-screen-parts_af.sr8.zx0"

Bg_Choose_Fighter_Screen_Part_6:
    INCBIN "Images/choose-fighter-screen-parts_ag.sr8.zx0"

Bg_Title_Part_0:
    INCBIN "Images/mk-title-parts_aa.zx0"

Bg_Title_Part_1:
    INCBIN "Images/mk-title-parts_ab.zx0"

MEGAROM_PAGE_BG_CHOOSE_FIGHTER_SCREEN_1_size:      equ $ - Bg_Choose_Fighter_Screen_Part_4

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 20 -------------------------------------------------
MEGAROM_PAGE_BG_TITLE_1: equ 20
MEGAROM_PAGE_LIFEBARS: equ 20

	org	0x8000, 0xBFFF

Bg_Title_Part_2:
    INCBIN "Images/mk-title-parts_ac.zx0"

Bg_Title_Part_3:
    INCBIN "Images/mk-title-parts_ad.zx0"

Bg_Title_Part_4:
    INCBIN "Images/mk-title-parts_ae.zx0"

Bg_Title_Part_5:
    INCBIN "Images/mk-title-parts_af.zx0"

Bg_Title_Part_6:
    INCBIN "Images/mk-title-parts_ag.zx0"

Lifebars_SC5:
    INCBIN "Images/lifebars.sc5"
Lifebars_SC5_size: equ $ - Lifebars_SC5

MEGAROM_PAGE_20_size:      equ $ - 0x8000

	ds PageSize - ($ - 0x8000), 255

; ------------------------------------------------- Page 21 -------------------------------------------------

MEGAROM_PAGE_SCORPION_UPPERCUT_LEFT_DATA_0: equ 21


	org	0x8000, 0xBFFF

    ; ------------ Data ---------------
	INCLUDE "Data/scorpion/uppercut/left/scorpion_uppercut_left_frames_0_to_5_data.s"

    ; ------------ List ---------------
    INCLUDE "Data/scorpion/uppercut/left/scorpion_uppercut_left_frames_0_to_5_list.s"

MegaRom_Page_21_size: equ $ - 0x8000 ; 0x2779 = ? bytes       ;  16384 - ? = ?

	ds PageSize - ($ - 0x8000), 255