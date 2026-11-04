package main

import cl "clay"
import "core:strings"
import rl "vendor:raylib"

app_init :: proc() {
    raylib_init()
    clay_init()
    load_todos()

    input = strings.builder_make()
}

app_update :: proc() {
    clay_update()
}

app_draw :: proc() {
    commands := clay_draw()

    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK) // NOTE: dont care about this its override by clay bg
    cl.clay_raylib_render(&commands)
    rl.EndDrawing()
}

app_close :: proc() {
    strings.builder_destroy(&input)
    save_todos()

    rl.UnloadFont(font)
    rl.CloseWindow()
}
