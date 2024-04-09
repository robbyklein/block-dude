.proc render_next_column
    ; Copy position
    lda map_position
    sta map_position_scratch
    lda map_position+1
    sta map_position_scratch+1

    ; We stop the first column of the map so the next column would be +32
    add16 map_position_scratch, #$20

   ; Render scroll buffer column #1
    jsr reset_scratch ; reset temp vars

    lda map_position_scratch ; map column low byte
    sta scratch
    lda map_position_scratch+1 ; map column high byte
    sta scratch+1

    lda nametable_column ; nametable low
    sta scratch+2
    lda nametable_column+1 ; nametable high
    sta scratch+3

    jsr load_column
    add16 map_position, #$01
    jsr increment_column

    rts
.endproc