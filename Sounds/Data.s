
SOUND_FX_0:     equ 0x80

sample_0:
			incbin    "Sounds/Raw/mk1-00048.raw"
.size: equ $ - sample_0


; -------------------------------------------------
SOUND_FX_1:     equ 0x81

sample_1:          
			incbin    "Sounds/Raw/mk1-00192.raw"
.size: equ $ - sample_1
		   

; -------------------------------------------------
SOUND_FX_2:     equ 0x82

sample_2:          
			incbin    "Sounds/Raw/mk1-00193.raw"
.size: equ $ - sample_2

		   
; -------------------------------------------------
SOUND_FX_3:     equ 0x83

sample_3:          
			incbin    "Sounds/Raw/mk1-00200.raw"
.size: equ $ - sample_3
