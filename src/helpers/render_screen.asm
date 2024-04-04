; Scratch 0-1 map address
; Scratch 2 map width
.proc render_screen
    ldx #$20 ; Page
    ldy #$00 ; Position
    row_pos := scratch+8

    ; Local variables
    map_width := scratch+2 ; 128
    jump_amount := scratch+7

    ; Subtract 32 (1 row) from map width
    cld
    lda map_width
    sec 
    sbc #$20
    sta jump_amount

    ; Render time
    Start:
        ; Tell the ppu were gonna start from top left ($2000)
        bit PPU_STATUS
        stx PPU_ADDR
        sty PPU_ADDR

        Render:
            RenderTile:
                ; Render the tile
                lda (scratch),y
                sta PPU_DATA

                ; Increment
                inc row_pos

                ; Check if end of row
                lda row_pos
                cmp #$20
                bne Continue

                ; See if map larger than screen
                lda map_width
                beq Continue

                ; If we make it here map is bigger than one 
                ; screen and we're ready to start a new row
                ; add16 scratch, map_width
                add16 scratch, jump_amount
                lda #$00
                sta row_pos
                
                Continue:
                    iny
                    bne RenderTile
            ; Go to next page
            inc scratch+1
            inx
            cpx #$24
            bne Render
    
    ; Return
    RTS
.endproc