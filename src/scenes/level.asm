.proc level_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Set map and map width
    lda #<Level1Bg
    sta map_address
    lda #>Level1Bg
    sta map_address+1
    lda #$00 ; map width low byte
    sta map_width
    lda #$02 ; map width high byte
    sta map_width+1

    ; Render first name table
    jsr reset_scratch ; reset temp vars
    jsr render_screen

    ; Render 2 buffer columns
    jsr render_next_column
    jsr empty_buffer

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
    jsr reset_buffer

    ; Check if right pressed
    LDA input
    AND #BUTTON_RIGHT
    BEQ Done

    ; increment movement
    inc movement

    ; Scroll
    lda #$01
    sta scratch
    jsr scroll_screen_x

    ; See if we need to render columns
    lda movement
    cmp #$08
    bne Done

    jsr render_next_column
    lda #$00
    sta movement

    ; Mark that we're ready for the next frame
    Done:
        lda #$00
        sta frame_ready

        rts
.endproc