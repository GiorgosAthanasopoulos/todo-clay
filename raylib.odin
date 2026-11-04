package main

import rl "vendor:raylib"

raylib_init :: proc() {
    rl.SetConfigFlags(win_flags)
    rl.InitWindow(win_w, win_h, win_title)
    rl.SetTargetFPS(target_fps)
    rl.SetWindowMinSize(win_min_w, win_min_h)

    font = rl.LoadFont(font_filepath)
}
