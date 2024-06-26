;   Defines
.include "base/constants.asm"
.include "macros/all.asm"

;   Segments
.segment "INESHDR"
    .include "base/header.asm"

.segment "ZEROPAGE"
    debug: .res 1
    debug2: .res 1
    scratch: .res 16
    nmi_scratch: .res 4
    input: .res 1
    input_mode: .res 1
    nmi_counter: .res 1
    frame_ready: .res 1
    scroll_x: .res 1
    scroll_y: .res 1
    scroll_next: .res 1
    ppu_mask_next: .res 1
    ppu_mask_value: .res 1
    ppu_control_next: .res 1
    ppu_control_value: .res 1
    scene_loaded: .res 1
    active_scene: .res 1
    movement: .res 1
    vram_buffer: .res 128
    map_width: .res 2
    map_address: .res 2
    map_position: .res 2
    map_position_scratch: .res 2
    nametable_column: .res 2

.segment "BSS"

.segment "DMC"

.segment "CODE"
    .include "base/init.asm"
    .include "handlers/all.asm"
    .include "helpers/all.asm"
    .include "managers/all.asm"
    .include "scenes/all.asm"

.segment "RODATA"
    PaletteData: .incbin "assets/palettes.pal"
    IntroBg: .incbin "assets/maps/intro.nam"
    TitleBg: .incbin "assets/maps/title.nam"
    Level1Bg: .incbin "assets/maps/level_1.map"

.segment "VECTORS"
    .addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
    .incbin "assets/tiles.chr"