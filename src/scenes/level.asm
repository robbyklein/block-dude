.proc level_start
    ; disable input
    lda #$00
    sta input_mode

    ; disable rendering
    lda #%00000110 
    sta PPU_MASK

    ; Render first name table
    jsr reset_scratch ; reset temp vars
    lda #<Level1Bg
    sta scratch
    lda #>Level1Bg
    sta scratch+1
    lda #$00 ; map width low byte
    sta scratch+2
    lda #$02 ; map width high byte
    sta scratch+3
    jsr render_screen

    ; Render scroll buffer column #1
    jsr reset_scratch ; reset temp vars
    lda #<Level1Bg
    sta scratch
    lda #>Level1Bg
    sta scratch+1
    lda #$00 ; map width low byte
    sta scratch+2
    lda #$02 ; map width high byte
    sta scratch+3
    lda #$20 ; map column low byte
    sta scratch+4
    lda #$00 ; map column high byte
    sta scratch+5
    lda #$20 ; nametable column
    sta scratch+6
    jsr render_column

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

    ; Block 1
    LDA #$1e      ; Length of the data block (1 byte)
    STA vram_buffer     ; Store length at the start of the buffer
    
    LDX #$24            ; High byte of the VRAM address
    STX vram_buffer+1   ; Store the high byte of the VRAM address
    
    LDY #$05            ; Low byte of the VRAM address
    STY vram_buffer+2   ; Store the low byte of the VRAM address
    
    ldx #$CA
    ldy #$00

    Loop:
        STX vram_buffer+3, y
        iny
        inx
        cpy #$1e
        bne Loop
      




    ; lda #$01
    ; sta scratch
    ; jsr scroll_screen_x

    ; Mark that we're ready for the next frame
    lda #$00
    sta frame_ready

    rts
.endproc