
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

ram_watch   add     0xc03e      -type byte      -desc LastFps     -format dec


ram_watch   add     0xc02e      -type byte      -desc P2.CurrFrame     -format dec


