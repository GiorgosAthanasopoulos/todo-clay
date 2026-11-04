package main

import cl "clay"
import rl "vendor:raylib"

// ui
bg := hex_to_cl_color(0x181818FF)
padding := u16(16)
child_gap := u16(32)
corner_radius := f32(32)

border_color := hex_to_cl_color(0xFF0000FF)
border_width := u16(2)

header_height := f32(100) // NOTE: this should be percentage based but percent doesnt work in clay for some reason
header_bg_color := hex_to_cl_color(0x202020FF)

input_height := f32(100)
input_hover_bg_color := hex_to_cl_color(0xAAAAAAFF)
input_bg_color := hex_to_cl_color(0x222222FF)
input_hover_fg_color := hex_to_cl_color(0x181818FF)
input_fg_color := cl.Color{255, 255, 255, 255}

add_width := f32(200)
add_height := f32(100)
add_hover_bg_color := hex_to_cl_color(0xAAAAAAFF)
add_bg_color := hex_to_cl_color(0x222222FF)
add_hover_fg_color := hex_to_cl_color(0x181818FF)
add_fg_color := cl.Color{255, 255, 255, 255}

text_size := u16(30)
local_utc_h_offset := i8(2)
db_filepath := "db.txt"

todo_bg_color := hex_to_cl_color(0x202020FF)
todo_height := f32(100)
todo_fg_color := hex_to_cl_color(0xFFFFFFFF)

delete_hover_fg_color := hex_to_cl_color(0x181818FF)
delete_fg_color := cl.Color{255, 255, 255, 255}
delete_hover_bg_color := hex_to_cl_color(0xAAAAAAFF)
delete_bg_color := hex_to_cl_color(0x222222FF)

toggle_hover_fg_color := hex_to_cl_color(0x181818FF)
toggle_fg_color := cl.Color{255, 255, 255, 255}
toggle_hover_bg_color := hex_to_cl_color(0xAAAAAAFF)
toggle_bg_color := hex_to_cl_color(0x222222FF)

// window
win_flags := rl.ConfigFlags {
    .VSYNC_HINT,
    // .FULLSCREEN_MODE,
    .WINDOW_RESIZABLE,
    // .WINDOW_MAXIMIZED,
    .MSAA_4X_HINT,
}
win_w := i32(1280)
win_h := i32(720)
win_title := cstring("Clay")
target_fps := i32(60)
win_min_w := i32(640)
win_min_h := i32(480)
font_filepath := cstring("IosevkaNerdFontMono-Regular.ttf")
