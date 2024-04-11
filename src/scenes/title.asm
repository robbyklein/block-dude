.proc title_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Set map and map width
    lda #<TitleBg
    sta map_address
    lda #>TitleBg
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

    ; Enable input
    lda #$01
    sta input_mode

    rts
.endproc

.proc title_update
    ; Check if Start pressed
    LDA input
    AND #BUTTON_START
    BEQ NotPressed 

    ; Change scenes
    lda #$00
    sta scene_loaded
    lda #$02
    sta active_scene
    rts

    ; So nmi runs
    NotPressed:
        lda #$00
        sta frame_ready
    
    ; Return
    rts
.endproc