.proc render_next_column
   ; Render scroll buffer column #1
    jsr get_next_map_column

    lda map_position_scratch ; map column low byte
    sta scratch
    lda map_position_scratch+1 ; map column high byte
    sta scratch+1

    lda nametable_column ; nametable low
    sta scratch+2
    lda nametable_column+1 ; nametable high
    sta scratch+3

    lda #$00  ; Starting offset
    sta scratch+4

    jsr load_column ; load into buffer
    jsr reset_scratch
    
    add16 map_position, #$01
    
    
    ; Render scroll buffer column #2
    jsr get_next_map_column

    lda map_position_scratch ; map column low byte
    sta scratch
    lda map_position_scratch+1 ; map column high byte
    sta scratch+1

    lda nametable_column ; nametable low
    sta scratch+2
    lda nametable_column+1 ; nametable high
    sta scratch+3

    lda #$21  ; Starting offset
    sta scratch+4

    jsr load_column ; load into buffer
    jsr reset_scratch

    ; Increment map position and column
    add16 map_position, #$01
    jsr increment_column

    rts
.endproc