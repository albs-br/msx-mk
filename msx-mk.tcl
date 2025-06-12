
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

ram_watch   add     0xc063      -type byte      -desc LastFps     -format dec

ram_watch   add     0xc065      -type byte      -desc IsOPL4Available     -format dec


#ram_watch   add     0xc006      -type byte      -desc PlayerInput     -format hex


#ram_watch   add     0xc02f      -type byte      -desc P2.CurrFrame     -format dec


ram_watch   add     0xc011      -type byte      -desc P1_X     -format dec
ram_watch   add     0xc012      -type byte      -desc P1_Y     -format dec
ram_watch   add     0xc02d      -type byte      -desc P1_Position     -format dec
ram_watch   add     0xc030      -type byte      -desc P1_IsBlocking   -format dec
ram_watch   add     0xc031      -type byte      -desc P1_IsCrouching  -format dec
ram_watch   add     0xc02f      -type byte      -desc P1_IsAnimating  -format dec
ram_watch   add     0xc02e      -type byte      -desc P1_IsGrounded     -format dec

ram_watch   add     0xc019      -type byte      -desc P1_HitB_X     -format dec
ram_watch   add     0xc01a      -type byte      -desc P1_HitB_Y     -format dec
ram_watch   add     0xc01b      -type byte      -desc P1_HitB_Width  -format dec
ram_watch   add     0xc01c      -type byte      -desc P1_HitB_Height -format dec







#ram_watch   add     0xc01c      -type byte      -desc P1_Anim_CurrFrame     -format dec

#ram_watch   add     0xc015      -type byte      -desc P1_Hb_X     -format dec
#ram_watch   add     0xc016      -type byte      -desc P1_Hb_Y     -format dec
#ram_watch   add     0xc017      -type byte      -desc P1_Hb_Width     -format dec
#ram_watch   add     0xc018      -type byte      -desc P1_Hb_Height     -format dec

#ram_watch   add     0xc031      -type byte      -desc P2_X     -format dec
#ram_watch   add     0xc032      -type byte      -desc P2_Y     -format dec

#ram_watch   add     0xc035      -type byte      -desc P2_Hb_X     -format dec
#ram_watch   add     0xc036      -type byte      -desc P2_Hb_Y     -format dec
#ram_watch   add     0xc037      -type byte      -desc P2_Hb_Width     -format dec
#ram_watch   add     0xc038      -type byte      -desc P2_Hb_Height     -format dec

