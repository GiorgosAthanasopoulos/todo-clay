package main

import cl "clay"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

unique_todo_title :: proc(title : string) -> bool {
    for todo in todos {
        if todo.title == title {
            return false
        }
    }
    return true
}

hex_to_cl_color :: #force_inline proc "c" (hex : u32) -> cl.Color {
    return cast([4]f32)rl.GetColor(hex)
}

datetime_to_string :: proc(dt : DateTime) -> string {
    sb := strings.builder_make()
    // defer strings.builder_destroy(&sb)

    strings.write_int(&sb, int(dt.d))
    strings.write_string(&sb, "/")
    strings.write_int(&sb, int(dt.mo))
    strings.write_string(&sb, "/")
    strings.write_int(&sb, int(dt.y))

    strings.write_string(&sb, " ")

    strings.write_int(&sb, int(dt.h))
    strings.write_string(&sb, ":")
    strings.write_int(&sb, int(dt.mi))
    strings.write_string(&sb, ":")
    strings.write_int(&sb, int(dt.s))

    return strings.to_string(sb)
}

datetime_now :: proc "c" () -> DateTime {
    _time := time.now()
    h, m, s := time.clock(_time)
    return {
        y = i64(time.year(_time)),
        mo = i8(time.month(_time)),
        d = i8(time.day(_time)),
        h = i8(h) + local_utc_h_offset,
        mi = i8(m),
        s = i8(s),
    }
}
