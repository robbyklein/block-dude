.proc empty_buffer
    ldy #$00 ; buffer position
    block_length := scratch ; stores the length of current block
    block_writes := scratch+1 ; how many writes in current block
    page_writes := scratch+2 ; how many writes on current page
    current_page := scratch+3
    current_tile := scratch+4
    tile_offset := scratch+5

    ReadLength:
        ; Reset block writes
        lda #$00
        sta block_writes
        sta page_writes

        ; Check if there's data to process
        lda vram_buffer,Y      
        beq Return ; if 0 we're done
        sta block_length ;save length for write loop
        
        ; Store ppu address highbyte
        iny
        lda vram_buffer,Y
        sta current_page

        ; Store ppu address lowbyte
        iny
        lda vram_buffer,Y                  
        sta current_tile
        sta tile_offset

        ; Since we're about to write
        bit PPU_STATUS
        
        ; Write the data
        WriteLoop:
            ; Set address to render
            lda current_page
            sta PPU_ADDR
            lda current_tile
            sta PPU_ADDR

            ; Get tile to render
            iny
            lda vram_buffer,Y

            ; Render it
            sta PPU_DATA

            ; Increment counters
            inc block_writes
            inc page_writes

            ; Compare block writes to block length to see if done
            lda block_writes
            cmp block_length
            beq NextBlock ; if they are go to next block

            ; Otherwise we need to move address

            ; Do we need to go to next page?
            lda page_writes
            cmp #$08
            beq NextPage

            ; Go to next row
            clc
            lda current_tile
            adc #$20
            sta current_tile
            jmp WriteLoop

            NextPage:
                lda #$00
                sta page_writes
                inc current_page
                lda tile_offset
                sta current_tile
                jmp WriteLoop            

            NextBlock:
                iny
                jmp ReadLength

    Return:
        lda #$00
        sta scratch
        sta scratch+1
        sta scratch+2
        sta scratch+3
        sta scratch+4
        rts
.endproc