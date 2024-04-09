
; Block 1
; LDA #$1e      ; Length of the data block (1 byte)
; STA vram_buffer     ; Store length at the start of the buffer

; LDX #$24            ; High byte of the VRAM address
; STX vram_buffer+1   ; Store the high byte of the VRAM address

; LDY #$05            ; Low byte of the VRAM address
; STY vram_buffer+2   ; Store the low byte of the VRAM address

; ldx #$CA
; ldy #$00


.proc render_screen
    ; Copy address
    map_address_low := scratch
    map_address_high := scratch+1
    lda map_address
    sta map_address_low
    lda map_address+1
    sta map_address_high

    ; Calculate jump amount width - 32 (one screen width)
    jump_amount_low := scratch+10
    jump_amount_high := scratch+11
    subtract16 map_width, #$20, jump_amount_low
    
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
            lda (map_address_low),y
            sta PPU_DATA

            ; Move row pos up 1
            inc row_pos

            ; Check if end of row
            lda row_pos
            cmp #$20
            bne Continue
            
          
            ; If we make it here  we're ready to start a new row
            add16s map_address_low, jump_amount_low
            
            lda #$00
            sta row_pos

            Continue:
                iny
                bne RenderTile

                ; Go to next page
                inc map_address_high
                inx
                cpx #$24
                bne Render
    
    Return:
    ; Return
    RTS
.endproc
