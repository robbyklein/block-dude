.proc empty_buffer
    ; Load the address of vram_buffer into scratch for indirect addressing
    lda #<vram_buffer
    sta scratch
    lda #>vram_buffer
    sta scratch+1

    ldy #$00  ; X register will serve as our index for the buffer

write_loop:
    lda (scratch), y  ; Load a byte from the buffer using X as an index
    sta $2007         ; Write it to the PPU
    iny               ; Move to the next byte in the buffer
    cpy #$00          ; Check if 256 bytes have been written
    bne write_loop    ; If not, continue writing
    inc scratch+1     ; Move to the next page of the buffer
    ; Note: This loop as-is writes 256 bytes. Repeat or modify for 1024 bytes.

    rts
.endproc