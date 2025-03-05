RamStart:

Last_NAMTBL_Addr:   rw 1

;   step      page            page drawing            page
;   value     active          sprites                 restoring bg
;   -----     -------         ---------------         ------------
;   0         0               1                       2
;   1         1               2                       0
;   2         2               0                       1
TripleBuffer_Vars:
    .Step:                  rb 1
    .BaseDataAddr:          rw 1
    .R14_Value:             rb 1

TripleBuffer_Vars_RestoreBG_HMMM_Command:
    .Source_X:   rw 1
    .Source_Y:   rw 1
    .Destiny_X:  rw 1
    .Destiny_Y:  rw 1
    .Cols:       rw 1
    .Lines:      rw 1
    .NotUsed:    rb 1
    .Options:    rb 1
    .Command:    rb 1


; ----------------------------
Player_1_Vars:
    .Animation_CurrentFrame_List:       rw 1
    .Animation_CurrentFrame_Data:       rw 1
    .CurrentFrame_List_Addr:            rw 1
    .CurrentFrame_Data_Addr:            rw 1
    .CurrentFrame_MegaRomPage:          rb 1
    .VRAM_NAMTBL_Addr:                  rw 1
    .Restore_BG_X:                      rb 1
    .Restore_BG_Y:                      rb 1
    .Restore_BG_WidthInPixels:          rb 1
    .Restore_BG_HeightInPixels:         rb 1
    ; CAUTION: put new vars only at the end




; ----------------------------

; Debug:
Jiffy_FrameStart:   rw 1
Total_Frames:       rw 1
Frame_Counter:      rb 1




RamEnd: