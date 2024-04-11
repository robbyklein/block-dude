.proc load_column
    ; Variables
    map_column_low := scratch
    map_column_high := scratch+1
    nametable_low := scratch+2
    nametable_high := scratch+3
    starting_offset := scratch+4
    
    map_address_low := scratch+9
    map_address_high := scratch+10
    jump_amount_low := scratch+11
    jump_amount_high := scratch+12

    ; Copy address
    lda map_address
    sta map_address_low
    lda map_address+1
    sta map_address_high

    ; Add initial map offset to address so 0 = column
    add16s map_address_low, map_column_low

    ; Load the buffer
    Load:
        ; Grab starting offset
        ldy starting_offset

        ; Set the length of the data
        lda #$1e
        sta vram_buffer, y

        ; Set the highbyte
        lda nametable_high
        sta vram_buffer+1, y

        ; Set the lowbyte
        lda nametable_low
        sta vram_buffer+2, y

        ; Load the data

        ; Get starting offset
        lda #$03
        clc
        adc starting_offset
        tax 

        tile_index := scratch+14
        tile_count := scratch+15

        LoadTiles:
            ldy #$00 ; map offset
            lda (map_address_low), y ; Get the tile
            sta tile_index ; save it
            add16s map_address_low, map_width ; Jump a row for next interation
            
            ; Transfer x to y
            txa
            tay

            ; Load tile in buffer
            lda tile_index
            sta vram_buffer, y 

            ; increment buffer offset
            inx

            ; Increment tile_count
            inc tile_count

            ; Loop till we loaded 30 tiles (1 column)
            lda tile_count
            cmp #$1e
            bne LoadTiles

        rts
.endproc