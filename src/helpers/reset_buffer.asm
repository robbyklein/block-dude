.proc reset_buffer
    ldy #$00

    reset_loop:
        lda #$00
        sta vram_buffer, y
        iny
        cpy #$80
        bne reset_loop

    rts
.endproc