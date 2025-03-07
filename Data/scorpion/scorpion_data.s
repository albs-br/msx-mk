

Scorpion_Stance_Left_Animation_List:
    dw Scorpion_Stance_Left_Frame_0.List, Scorpion_Stance_Left_Frame_0.List, Scorpion_Stance_Left_Frame_0.List
    dw Scorpion_Stance_Left_Frame_1.List, Scorpion_Stance_Left_Frame_1.List, Scorpion_Stance_Left_Frame_1.List
    dw Scorpion_Stance_Left_Frame_2.List, Scorpion_Stance_Left_Frame_2.List, Scorpion_Stance_Left_Frame_2.List
    dw Scorpion_Stance_Left_Frame_3.List, Scorpion_Stance_Left_Frame_3.List, Scorpion_Stance_Left_Frame_3.List
    dw Scorpion_Stance_Left_Frame_4.List, Scorpion_Stance_Left_Frame_4.List, Scorpion_Stance_Left_Frame_4.List
    dw Scorpion_Stance_Left_Frame_5.List, Scorpion_Stance_Left_Frame_5.List, Scorpion_Stance_Left_Frame_5.List
    dw Scorpion_Stance_Left_Frame_6.List, Scorpion_Stance_Left_Frame_6.List, Scorpion_Stance_Left_Frame_6.List
    dw 0 ; end of data

Scorpion_Stance_Left_Animation_Data:
    dw Scorpion_Stance_Left_Frame_0.Data, Scorpion_Stance_Left_Frame_0.Data, Scorpion_Stance_Left_Frame_0.Data
    dw Scorpion_Stance_Left_Frame_1.Data, Scorpion_Stance_Left_Frame_1.Data, Scorpion_Stance_Left_Frame_1.Data
    dw Scorpion_Stance_Left_Frame_2.Data, Scorpion_Stance_Left_Frame_2.Data, Scorpion_Stance_Left_Frame_2.Data
    dw Scorpion_Stance_Left_Frame_3.Data, Scorpion_Stance_Left_Frame_3.Data, Scorpion_Stance_Left_Frame_3.Data
    dw Scorpion_Stance_Left_Frame_4.Data, Scorpion_Stance_Left_Frame_4.Data, Scorpion_Stance_Left_Frame_4.Data
    dw Scorpion_Stance_Left_Frame_5.Data, Scorpion_Stance_Left_Frame_5.Data, Scorpion_Stance_Left_Frame_5.Data
    dw Scorpion_Stance_Left_Frame_6.Data, Scorpion_Stance_Left_Frame_6.Data, Scorpion_Stance_Left_Frame_6.Data
    dw 0 ; end of data

; --- Slice index list
; increment in bytes, length in bytes, address of the slice on the Data

Scorpion_Stance_Left_Frame_0:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_header.s" ; dw yOffset; db width; db height; db MEgaROM page number
    .List:      INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_list.s"
    .Data:      INCLUDE "Data/scorpion/stance/left/scorpion_frame_0_data.s"
Scorpion_Stance_Left_Frame_1:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_1_data.s"
Scorpion_Stance_Left_Frame_2:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_2_data.s"
Scorpion_Stance_Left_Frame_3:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_3_data.s"
Scorpion_Stance_Left_Frame_4:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_4_data.s"
Scorpion_Stance_Left_Frame_5:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_5_data.s"
Scorpion_Stance_Left_Frame_6:
    .Header:    INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_header.s"
    .List:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_list.s"
    .Data:  INCLUDE "Data/scorpion/stance/left/scorpion_frame_6_data.s"