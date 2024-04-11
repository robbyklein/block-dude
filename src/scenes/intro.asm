.proc intro_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Set map and map width
    lda #<IntroBg
    sta map_address
    lda #>IntroBg
    sta map_address+1
    lda #$20 ; map width low byte
    sta map_width
    lda #$00 ; map width high byte
    sta map_width+1

    ; Render intro name
    jsr reset_scratch
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

    rts
.endproc

.proc intro_update
    ; See how long it's been displayed
    lda nmi_counter

    ; Switch after 2 seconds
    cmp #$78
    bne Done

    lda #$00
    sta scene_loaded
    lda #$01
    sta active_scene

    Done:
        lda #$00
        sta frame_ready

        rts
.endproc
