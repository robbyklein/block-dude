.proc level_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Render intro name
    jsr reset_scratch
    lda #<Level1Bg
    sta scratch
    lda #>Level1Bg
    sta scratch+1
    lda #$80
    sta scratch+2
    jsr render_screen

    ; Set loaded flag
    lda #$01
    sta scene_loaded

    ; Reset nmi counter
    sta nmi_counter

    ; Enable rendering again
    lda #%00011110 
    sta PPU_MASK
    lda #$02
    sta OAM_DMA

    ; Enable input
    lda #$02
    sta input_mode

    rts
.endproc

.proc level_update
    ; So nmi runs
    Done:
        lda #$00
        sta frame_ready
    
    ; Return
    rts
.endproc