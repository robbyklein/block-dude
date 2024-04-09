.proc render_column
    ; Create labels for all our variables
    map_column_low := scratch+4
    map_column_high := scratch+5
    nametable_column := scratch+6
    rendered := scratch+8
    tile_index := scratch+9
    nametable_row := scratch+10
    nametable_page := scratch+11

    ; Add initial map offset
    add16s map_address, map_column_low

    ; See if in second nametable
    lda nametable_column
    cmp #$1F 

    ; It's in the second table so jump
    bcs NextTable

    ; Otherwise set to 20
    lda #$20
    sta nametable_page
    jmp Render

    NextTable:
        lda #$24 
        sta nametable_page
        sec
        lda nametable_column
        sbc #$20
        sta nametable_column

    Render:
        ; Add column to tileindex
        lda tile_index
        clc
        adc nametable_column
        sta tile_index
        ldy #$00 ; map offset

        RenderTile:
            ; Set tile location
            bit PPU_STATUS
            lda nametable_page
            sta PPU_ADDR
            lda tile_index
            sta PPU_ADDR

            ; Set the tile
            lda (map_address),y
            sta PPU_DATA

            ; Go to next row in map
            add16s map_address, map_width

            ; Inc nametable row
            inc nametable_row
            inc rendered

            ; Add 32 to tile index to move down a row
            lda tile_index
            clc
            adc #$20
            sta tile_index
            
            ; See if we need to go to next page
            lda rendered
            cmp #$08
            bne RenderTile

            ; Check if we rendered all our rows already
            lda nametable_row
            cmp #$20
            beq Return

            ; If not go to next page
            inc nametable_page

            ; Reset rendered / tile index
            lda #$00
            sta rendered
            sta tile_index

            ; Re-add the column offset
            clc
            adc nametable_column
            sta tile_index

            ; Run it back
            jmp RenderTile
            
    Return :
        rts
.endproc