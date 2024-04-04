.proc reset_scratch
    lda #$00
    sta scratch
    sta scratch+1
    sta scratch+2
    sta scratch+3
    sta scratch+4
    sta scratch+5
    sta scratch+6
    sta scratch+7
    rts
.endproc