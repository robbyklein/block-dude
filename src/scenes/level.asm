.proc level_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Render first name table
    jsr reset_scratch ; reset temp vars

    ; Store the address in 0-1
    lda #<Level1Bg
    sta scratch
    lda #>Level1Bg
    sta scratch+1
    
    lda #$80 ; map width low byte
    sta scratch+2
    lda #$00 ; map width high byte
    sta scratch+3

    ; Render it
    jsr render_screen

    ; Render scroll buffer column
    ; jsr reset_scratch
    ; set16 Level1Bg, scratch
    ; lda #<$21
    ; sta scratch+2
    ; lda #>$00
    ; sta scratch+3
    ; lda #$80
    ; sta scratch+4
    ; ; lda #$21
    ; ; sta scratch+3
    ; ; sta scratch+4




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
    ; lda #$01
    ; sta scratch
    ; jsr scroll_screen_x

    ; Mark that we're ready for the next frame
    lda #$00
    sta frame_ready

    rts
.endproc