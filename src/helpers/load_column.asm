; Block 1
; LDX #$24            ; High byte of the VRAM address
; STX vram_buffer+1   ; Store the high byte of the VRAM address

; LDY #$05            ; Low byte of the VRAM address
; STY vram_buffer+2   ; Store the low byte of the VRAM address

; ldx #$CA
; ldy #$00

    ; ; Load length of data
    ; lda #$1e
    ; sta vram_buffer


.proc load_column
    ; Variables
    map_column_low := scratch
    map_column_high := scratch+1
    nametable_low := scratch+2
    nametable_high := scratch+3
    map_address_low := scratch+4
    map_address_high := scratch+5
    jump_amount_low := scratch+6
    jump_amount_high := scratch+7

    ; Copy address
    lda map_address
    sta map_address_low
    lda map_address+1
    sta map_address_high

    ; Add initial map offset to address so 0 = column
    add16s map_address_low, map_column_low

    ; Load the buffer
    Load:
        ; Set the length of the data
        lda #$1e
        sta vram_buffer

        ; Set the highbyte
        lda nametable_high
        sta vram_buffer+1

        ; Set the lowbyte
        lda nametable_low
        sta vram_buffer+2

        ; Load the data
        ldx #$03 ; vram buffer offset
        tile_index := scratch+8
        tile_count := scratch+9

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