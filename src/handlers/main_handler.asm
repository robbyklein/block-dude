.proc main
    ; Wait for nmi to finish
    :
        lda frame_ready
        beq :-
    
    ; Poll input
    jsr poll_input

    ; Scene router
    jsr scene_manager

    ; Infinite
    jmp main
.endproc 
