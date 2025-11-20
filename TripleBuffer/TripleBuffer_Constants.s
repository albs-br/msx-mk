; Triple buffer constants:


R2_PAGE_0:      equ 0001 1111 b     ; page 0 (0x00000)
R2_PAGE_1:      equ 0011 1111 b     ; page 1 (0x08000)
R2_PAGE_2:      equ 0101 1111 b     ; page 2 (0x10000)
R2_PAGE_3:      equ 0111 1111 b     ; page 3 (0x18000)

R14_PAGE_0:     equ 0000 0000 b ; page 0
R14_PAGE_1:     equ 0000 0010 b ; page 1
R14_PAGE_2:     equ 0000 0100 b ; page 2
R14_PAGE_3:     equ 0000 0110 b ; page 3

Y_BASE_PAGE_0:      equ 0   ; page 0
Y_BASE_PAGE_1:      equ 256 ; page 1
Y_BASE_PAGE_2:      equ 512 ; page 2
Y_BASE_PAGE_3:      equ 768 ; page 3


NAMTBL_ADRR_PAGE_3:     equ Y_BASE_PAGE_3 * 128


FrameHeader_Struct:
    .yOffset:               equ 0   ; signed word
    .Width:                 equ 2   ; byte
    .Height:                equ 3   ; byte
    .MegaRomPage:           equ 4   ; byte
    .FirstFrameList_Addr:   equ 5   ; word

    .HurtBox_X:             equ 7   ; byte
    .HurtBox_Y:             equ 8   ; byte
    .HurtBox_Width:         equ 9   ; byte
    .HurtBox_Height:        equ 10  ; byte

    .HitBox_X:              equ 11  ; byte
    .HitBox_Y:              equ 12  ; byte
    .HitBox_Width:          equ 13  ; byte
    .HitBox_Height:         equ 14  ; byte
