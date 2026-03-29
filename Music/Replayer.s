	
; music/replayer.s
; Original Re-player by Grauw (https://hg.sr.ht/~grauw/re-play)


; ------------------------------------------------------------------
; Instalar hook em H.KEYI (FD9Ah)
; ------------------------------------------------------------------
RePlayer_HookInstall:
    di
    ; escreve opcode JP (C3h)
    ld  a,0C3h
    ld  (0FD9Ah),a

    ; escreve endereço do hook logo depois
    ld  hl,RePlayer_IRQ_Hook
    ld  (0FD9Ah+1),hl
    ei
    ret

; ------------------------------------------------------------------
; RePlayer_Tick_entry
; ------------------------------------------------------------------
RePlayer_Tick:
    di
    call RePlayer_Tick_entry
    ei
    ret

; ------------------------------------------------------------------
; Replayer IRQ Routine
; ------------------------------------------------------------------
RePlayer_IRQ_Hook:
    call RePlayer_Tick_entry
	ld	 a,(Seg_P8000_SW_Mirror)
	ld	 (7000h),a
	ret

; ------------------------------------------------------------------
; Replayer Init
; ------------------------------------------------------------------
RePlayer_Init:
    di

    ld  bc,0
    ld  (Main_currentTrack),bc

    ld a,MEGAROM_PAGE_REPLAYER_0    ; First bank of sound data
	ld (RePlayer_currentBank),a	
	ld (7000h),a

	ld a,(SoundData)
	call RePlayer_Detect_entry
    call RePlayer_Stop
    call RePlayer_HookInstall 

    ld a,(Seg_P8000_SW_Mirror)
    ld  (Seg_P8000_SW),a
    ei
    ret

; ------------------------------------------------------------------
; Play music track (A=Track)
; ------------------------------------------------------------------
RePlayer_PlayTrack:
    di
    ld b,0
    ld c,a
    ld (Main_currentTrack),bc
    ld a,(RePlayer_currentBank)
    ld hl,SoundData +1

    call RePlayer_Play_entry

    ld  a,(Seg_P8000_SW_Mirror)  
    ld  (Seg_P8000_SW),a
    ei
    ret

; ------------------------------------------------------------------
; Stop music track
; ------------------------------------------------------------------
RePlayer_Stop:
    call RePlayer_Stop_entry
    ld a,(Seg_P8000_SW_Mirror)
    ld  (Seg_P8000_SW),a
    ret

; ------------------------------------------------------------------
; Pause / Resume music track
; ------------------------------------------------------------------
RePlayer_TogglePause:
    call RePlayer_TogglePause_entry
    ld a,(Seg_P8000_SW_Mirror)
    ld  (Seg_P8000_SW),a
    ret

