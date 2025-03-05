

Player_1_Animation_List:
    dw Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List, Frame_0.List
    dw Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List, Frame_1.List
    dw Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List, Frame_2.List
    dw Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List, Frame_3.List
    dw Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List, Frame_4.List
    dw Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List, Frame_5.List
    dw Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List, Frame_6.List
    dw 0 ; end of data

Player_1_Animation_Data:
    dw Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data, Frame_0.Data
    dw Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data, Frame_1.Data
    dw Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data, Frame_2.Data
    dw Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data, Frame_3.Data
    dw Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data, Frame_4.Data
    dw Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data, Frame_5.Data
    dw Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data, Frame_6.Data
    dw 0 ; end of data

; --- Slice index list
; increment in bytes, length in bytes, address of the slice on the Data

Frame_0:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_header.s" ; dw yOffset; db width; db height; db MEgaROM page number
    .List:      INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_list.s"
    .Data:      INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_data.s"
Frame_1:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_data.s"
Frame_2:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_data.s"
Frame_3:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_data.s"
Frame_4:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_data.s"
Frame_5:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_data.s"
Frame_6:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_data.s"