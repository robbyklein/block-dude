.proc get_next_map_column
   ; Copy position
    lda map_position
    sta map_position_scratch
    lda map_position+1
    sta map_position_scratch+1

    ; We store top left pos so add 32 
    add16 map_position_scratch, #$20

    rts
.endproc