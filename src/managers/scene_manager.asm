.proc scene_manager
    ; Grab scene / loaded
    lda scene_loaded
    ldx active_scene

    ; Send to correct section
    cpx #$01
    beq Title

    cpx #$02
    beq Level

    Intro:
        ; Check if loaded
        cmp #$00
        bne IntroLoaded
        
        ; If its not
        jsr intro_start
        rts

        ; If it is
        IntroLoaded:
            jsr intro_update
            rts

    Title:
        ; Check if loaded
        cmp #$00
        bne TitleLoaded
        
        ; If its not
        jsr title_start
        rts

        ; If it is
        TitleLoaded:
            jsr title_update
            rts

    Level:
        ; Check if loaded
        cmp #$00
        bne LevelLoaded
        
        ; If its not
        jsr level_start
        rts

        ; If it is
        LevelLoaded:
            jsr level_update
            rts    

.endproc