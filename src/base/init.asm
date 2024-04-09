.proc init    
    lda #%00011110 
    sta ppu_mask_next
    sta ppu_mask_value

    lda #$02
    sta active_scene

    lda #$00
    sta nametable_column
    lda #$24
    sta nametable_column+1


    jmp main
.endproc