.proc scroll_screen_x
    lda scroll_x       ; Load the current horizontal scroll position
    clc                ; Clear the carry flag before addition
    adc scratch        ; Add the value of scratch to scroll_x
    sta scroll_x       ; Store the result back in scroll_x

    bcc NoWrap         ; If there was no carry (no overflow), skip the nametable toggle
    ; If there was a carry (overflow), toggle the horizontal nametable.
    lda ppu_control_next
    eor #%00000001     ; Toggle bit 0 (horizontal nametable select)
    sta ppu_control_next

NoWrap:
    rts                ; Return from subroutine
.endproc