.proc render_screen
    ldx #$20 ; offset
    ldy #$00 ; position

    :
        render_background_tiles:
            ; render each position
            lda PPU_STATUS
            stx PPU_ADDR
            sty PPU_ADDR
            lda (scratch),y
            sta PPU_DATA
            iny
            bne render_background_tiles
        ; Go to next page
        inc scratch+1
        inx
        cpx #$24
        bne :-

    RTS
.endproc

.proc load_buffer
    ldx #$00             ; Start offset
    ldy #$00             ; Start position

fill_buffer:
    lda (scratch), y     ; Load data from IntroSceneBg using indirect indexed addressing
    sta vram_buffer, y   ; Store in vram_buffer at the same offset
    iny                  ; Move to the next byte
    cpy #$00             ; Check if we've wrapped around (256 bytes processed)
    bne fill_buffer      ; If not, keep filling the buffer
    inc scratch+1        ; Move to the next 256-byte block of IntroSceneBg
    inx
    cpx #$04             ; Check if we've filled 1KB (4 blocks of 256 bytes)
    bne fill_buffer      ; If not, continue filling
    RTS
.endproc