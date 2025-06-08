; Output:
;   z: not available
;   nz: available
IsOPL4Available:
    in		  a, (0xc4)
    cp		  0xff
    ;jr		  z, $						;stay here forever if not found!
    ret

OPL4_Init:

    di

        ;setup OPL4 (parte FM)
        ;enable new2:wave registers						(Manual pag 42)
        ld       a, 5
        out      (0xc6), a                                ; 0xc4 + 2
        ld       a, 2
        out      (0xc7), a                                ; 0xc4 + 2 + 1

        
        
        ld 		bc, 0x0210				;device ID 0, Wave table header 100b = 5 => from wave 384 to 511 starts at 0x200000 (Check manual pages 14,15)
        call    write_opl4_port
        
        ld      bc, 0x2001				;first channel, wave most significant bit (MSB) always 1 ... so 1xxxxxxxxb 
        call    write_opl4_port

        ld      bc, 0x38F0				;first channel, octave 15 (max). Play this with FNumber (Check manual page 17). Our samples are 11Kz
        call    write_opl4_port
        
        
        
        ;uploading samples (headers & data)		   
        ;activate reading/writting
        ld      b, 2
        call    read_opl4_port
        or      1                                        ;bit 0 to 1 => reading/writting wave memory
        
;           ld      b, 2                                      ;b keeps value
        ld      c, a
        call    write_opl4_port
        
        ;uploading headers
        ;set up wave ram writting address		0x200000
        ld      bc, 0x0320
        call    write_opl4_port
        ld      bc, 0x0400
        call    write_opl4_port
        ld      bc, 0x0500
        call    write_opl4_port                              
        
        ld      a, MEGAROM_PAGE_SOUNDS_HEADERS
        ld      (0x7000), a								;megarom block 1 from 0x8000

        ld      hl, 0x8000 ;headers_begin
        ld      de, headers_end - headers_begin
        ld      b, 0x06                                   ;read/write OPL4 wave register
loop_header:
        ld      c, (hl)
        
        call    write_opl4_port
        inc     hl
        dec     de
        ld      a, d
        or      e
        jr      nz, loop_header
        

        
        ;uploading samples data
        
        ;set up wave ram writting address
        ;from 0x201200  
        ld      bc, 0x0320
        call    write_opl4_port
        ld      bc, 0x0412
        call    write_opl4_port
        ld      bc, 0x0500
        call    write_opl4_port                              

        ld      a, MEGAROM_PAGES_SOUNDS_DATA ; 2
        ld      (0x7000), a
        call	load_16kb_chunk
        ld      a, MEGAROM_PAGES_SOUNDS_DATA + 1 ;3
        ld      (0x7000), a
        call	load_16kb_chunk			
        ld      a, MEGAROM_PAGES_SOUNDS_DATA + 2 ; 4
        ld      (0x7000), a
        call	load_16kb_chunk
        
        

        ;restore regular operation (play sound!)
        ld      b, 2
        call    read_opl4_port
        and     11111110b                                    ;bit 0 to 0 => reading/writting wave memory disabled
        
;           ld      b, 2                    ;b keeps value
        ld      c, a
        call    write_opl4_port


    ei    

    ret

; Input:
;   D: sound number (constant SOUND_FX_?)
PlaySound:
    ; if (!IsOPL4Available) return;
    ld      a, (Var_IsOPL4Available)
    or      a
    ret     z

    ; play sound on OPL4
    ld	    d, 0x81 ; 0x80 to 0x82
    call    speak
    
    ret


;d - sample number		   
speak:
			ld     bc, 0x6800                                             
			call   write_opl4_port                                              ;silence please

			ld     b, 0x08                                                              
			ld	   c, d															;sample number
			call   write_opl4_port                              

			ld     bc, 0x6880                                                    ;play that                                            
			jp     write_opl4_port                                              


		   
		   
		   
		   
		   
		   

;b - port number
;c - data
write_opl4_port:
			;port
			ld      a, b
			out     (0x7e), a
			ld      a, c
			nop
			nop
			;data
			out     (0x7f), a
			ret
		   
		   

;b - port number
; returns
; a - value read
read_opl4_port:
			;port
			ld     a, b
			out    (0x7e), a
			nop
			nop
			nop
			;data
			in     a, (0x7f)
			ret



;set the right page on the megarom before calling this guy
load_16kb_chunk:
			ld      hl, 0x8000
			ld      de, 0x4000			;16kb
			ld      b, 0x06                                                     ;read/write OPL4 wave register
loop_data:
			ld      c, (hl)
		   
			call    write_opl4_port
			inc     hl
			dec     de
			ld      a, d
			or      e
			jr      nz, loop_data
			ret




