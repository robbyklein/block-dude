.proc increment_column
    inc nametable_column
    lda nametable_column
    cmp #$20
    beq ChangePage
    rts

    ChangePage:
        lda #$00
        sta nametable_column
        lda nametable_column+1
        cmp #$20
        beq Second
        lda #$20
        sta nametable_column+1
        rts

        Second:
            lda #$24
            sta nametable_column+1
            rts
        

.endproc