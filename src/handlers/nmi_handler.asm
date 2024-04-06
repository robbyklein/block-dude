.proc nmi_handler
    ; Save registers.
    pha
    txa
    pha
    tya
    pha

    ; If this is a lag frame, do not touch the PPU.
    lda frame_ready
    bne Done

    ; Write the contents of the VRAM transfer buffer to the PPU.
    BIT PPU_ADDR
    JSR empty_buffer

    ; Set rendering flags.
    LDA ppu_mask_next
    STA PPU_MASK
    STA ppu_mask_value

    ; Set the scroll and other flags.
    LDA ppu_control_next
    STA PPU_CTRL
    STA ppu_control_value

    LDA scroll_x
    STA PPU_SCROLL
    LDY scroll_y
    STY PPU_SCROLL

    ; We do OAM DMA 
    LDA #$00
    STA OAM_ADDR
    LDA #$02
    STA OAM_DMA

    ; Mark that we've handled the start of this frame already.
    LDA #$01
    STA frame_ready

    ; Increment frame count
    inc nmi_counter

    Done:
        ; Restore registers.
        pla
        tay
        pla
        tax
        pla

        rti
.endproc