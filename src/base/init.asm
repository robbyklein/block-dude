.proc init    
    lda #%00011110 
    sta ppu_mask_next
    sta ppu_mask_value

    jmp main
.endproc