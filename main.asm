INCLUDE "gbhw.inc"
INCLUDE "song.inc"

MACRO SampleDelay
    DEF DELAY SET 25
    ASSERT FATAL, \1 <= DELAY
    REPT (DELAY - \1)
        nop
    ENDR
ENDM

MACRO LoadSample
    ld A, B             ; 1
    and A, $80          ; 2
    srl A               ; 2
    srl A               ; 2
    ld [rAUD3LEVEL], A  ; 4
    sla B               ; 2
ENDM

SECTION "start",ROM0[$0100]
    nop
    jp begin
    ROM_HEADER      ROM_MBC5, ROM_SIZE_4MBYTE, RAM_SIZE_0KBYTE
    
begin:
    ld A, $80
    ld [rAUDENA], A

    ld A, %01110111
    ld [rAUDVOL], A

    ld A, %01000100
    ld [rAUDTERM], A

    ld A, $FF
    ld [(_AUD3WAVERAM+$0)], A
    ld [(_AUD3WAVERAM+$1)], A
    ld [(_AUD3WAVERAM+$2)], A
    ld [(_AUD3WAVERAM+$3)], A
    ld [(_AUD3WAVERAM+$4)], A
    ld [(_AUD3WAVERAM+$5)], A
    ld [(_AUD3WAVERAM+$6)], A
    ld [(_AUD3WAVERAM+$7)], A
    ld [(_AUD3WAVERAM+$8)], A
    ld [(_AUD3WAVERAM+$9)], A
    ld [(_AUD3WAVERAM+$A)], A
    ld [(_AUD3WAVERAM+$B)], A
    ld [(_AUD3WAVERAM+$C)], A
    ld [(_AUD3WAVERAM+$D)], A
    ld [(_AUD3WAVERAM+$E)], A
    ld [(_AUD3WAVERAM+$F)], A

    ld A, $80
    ld [rAUD3ENA], A

    ld A, 0
    ld [rAUD3LEVEL], A ; set 3rd channel volume to known value

    ld A, 1
    ld [rAUD3LOW], A
    ld A, %10000000
    ld [rAUD3HIGH], A

    ld sp, $FFFF       ; initialize stack pointer
    ld A, 1
    ld C, A
    ld [ROM_BANK_NUMBER], A
    ld A, 0
    ld HL, $4000
    ld B, [HL]
    inc HL

.loop
; sample 1
    LoadSample         ; 13

    SampleDelay 13
; sample 2
    LoadSample         ; 13
    
    SampleDelay 13
; sample 3
    LoadSample         ; 13
    
    ld D, $80          ; 2

    SampleDelay 15
; sample 4
    LoadSample         ; 13

    ld A, H            ; 1
    cp A, D            ; 1
    jr NZ, .notLastSample
.lastSample          ; 2
    ld DE, .cont     ; 3
    SampleDelay 20
; sample 5
    LoadSample          ; 13

    ld A, SONG_BANKS    ; 4
    cp A, C             ; 1
    jr NZ, .notLastBank
                        ; 2
    ld DE, .quit        ; 3
    SampleDelay 23
; sample 6
    LoadSample          ; 13

    SampleDelay 19
    jr .lastBankFi      ; 3

.notLastBank ; 3
    inc C    ; 1
    SampleDelay 22
; sample 6
    LoadSample               ; 13
    ld A, C                  ; 1
    ld [ROM_BANK_NUMBER], A  ; 4
    ld H, $40                ; 2

    SampleDelay 23
.lastBankFi
    jr .lastSampleFi ; 3

.notLastSample       ; 3
    ld DE, .cont     ; 3
    SampleDelay 21
; sample 5
    LoadSample         ; 13

    SampleDelay 13
; sample 6
    LoadSample         ; 13
    
    SampleDelay 13

.lastSampleFi
; sample 7
    LoadSample         ; 13

    push DE            ; 4
    ld D, [HL]         ; 2
    inc HL             ; 2

    SampleDelay 21
; sample 8
    LoadSample         ; 13
    ld B, D            ; 1
    ret                ; 4
.cont
    SampleDelay 22
    jp .loop           ; 4

.quit
    jr .quit
