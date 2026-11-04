package main

import "core:strings"
import rl "vendor:raylib"

todos : [dynamic]Todo
font : rl.Font
input : strings.Builder

main :: proc() {
    app_init()

    for !rl.WindowShouldClose() {
        app_update()
        app_draw()
    }

    app_close()
}
