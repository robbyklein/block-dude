; Scratch 0-1 map address
; Scratch 2 map width high byte
; Scratch 3 map width low byte
.proc render_screen
    ; Map info
    map_width_low := scratch+2
    map_width_high := scratch+3

    ; Calculate jump amount width - 32 (one screen width)
    jump_amount_low := scratch+10
    jump_amount_high := scratch+11
    subtract16 map_width_low, #$20, jump_amount_low
    
    ; Render the tiles
    ldx #$20 ; Page
    ldy #$00 ; Position in page
    row_pos := scratch+9 ; Position in row

    Render:
        ; sty row_pos
        bit PPU_STATUS
        stx PPU_ADDR
        sty PPU_ADDR

        RenderTile:
            ; Render the tile
            lda (scratch),y
            sta PPU_DATA

            ; Move row pos up 1
            inc row_pos

            ; Check if end of row
            lda row_pos
            cmp #$20
            bne Continue
            
          
            ; If we make it here  we're ready to start a new row
            add16s scratch, jump_amount_low
            
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
    
    Return:
    ; Return
    RTS
.endproc
