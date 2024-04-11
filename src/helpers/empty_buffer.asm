.proc empty_buffer
    ; Check length
    lda vram_buffer
    cmp #$00
    bne HasSegment
    rts

    HasSegment:
        buffer_offset := nmi_scratch

        ; Extract info about this segment
        data_length := vram_buffer
        nametable_low := vram_buffer+1
        nametable_high := vram_buffer+2


        RenderBuffer: 
            ; Render the tiles
            tile_count := nmi_scratch+1
            page_count := nmi_scratch+2
            original_high := nmi_scratch+3

            lda nametable_high
            sta original_high

            ldy #$03 ; buffer offset

            bit PPU_STATUS
            RenderColumn:
                ; See if we're done
                lda tile_count
                cmp data_length
                beq Done

                ; Increment tile count
                inc tile_count

                ; Set start
                lda nametable_low
                sta PPU_ADDR
                lda nametable_high
                sta PPU_ADDR

                ; Get the tile
                lda vram_buffer, y
                iny

                ; Render it
                sta PPU_DATA

                ; Add 32 to low byte to get to next row
                lda nametable_high
                clc
                adc #$20
                sta nametable_high

                ; Increment page count
                inc page_count
                lda page_count
                cmp #$08
                bne RenderColumn

                ; Go to next page
                lda #$00
                sta page_count
                lda original_high
                sta nametable_high
                inc nametable_low
                jmp RenderColumn

            Done:
                ; Reset scratch
                lda #$00
                sta nmi_scratch
                sta nmi_scratch+1
                sta nmi_scratch+2
                sta nmi_scratch+3

                ; Return
                rts
.endproc