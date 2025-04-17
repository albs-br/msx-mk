
#ram_watch   add     0xc021      -type word      -desc Total_Frames      -format dec
#ram_watch   add     0xc015      -type word      -desc Animation_CurrentFrame_List      -format hex
#ram_watch   add     0xc023      -type byte      -desc Frame_Counter      -format dec
#ram_watch   add     0xc002      -type byte      -desc Step      -format dec

#ram_watch   add     0xc006      -type word      -desc HMMM.S_X      -format dec
#ram_watch   add     0xc008      -type word      -desc HMMM.S_Y      -format dec
#ram_watch   add     0xc00a      -type word      -desc HMMM.D_X      -format dec
#ram_watch   add     0xc00c      -type word      -desc HMMM.D_Y      -format dec
#ram_watch   add     0xc00e      -type word      -desc HMMM.Cols      -format dec
#ram_watch   add     0xc010      -type word      -desc HMMM.Lines     -format dec


#ram_watch   add     0xc01f      -type byte      -desc P2_curr_frame     -format dec

ram_watch   add     0xc002      -type byte      -desc LastFps     -format dec


ram_watch   add     0xc006      -type byte      -desc PlayerInput     -format hex
#PlayerInput: equ 0C006h ; last def. pass 3


#ram_watch   add     0xc02f      -type byte      -desc P2.CurrFrame     -format dec
#Player_2_Vars.Animation_Current_Frame_Number: equ 0C02Fh ; last def. pass 3


ram_watch   add     0xc011      -type byte      -desc P1_X     -format dec
ram_watch   add     0xc012      -type byte      -desc P1_Y     -format dec
#ram_watch   add     0xc031      -type byte      -desc P1_Position     -format dec
#ram_watch   add     0xc029      -type byte      -desc P1_IsGrounded     -format dec
#ram_watch   add     0xc01c      -type byte      -desc P1_Anim_CurrFrame     -format dec

#Player_1_Vars.X: equ 0C018h ; last def. pass 3
#Player_1_Vars.Y: equ 0C019h ; last def. pass 3
#Player_1_Vars.IsGrounded: equ 0C029h ; last def. pass 3
#Player_1_Vars.Position: equ 0C028h ; last def. pass 3
#Player_1_Vars.Animation_Current_Frame_Number: equ 0C01Ch ; last def. pass 3
