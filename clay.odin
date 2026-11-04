package main

import cl "clay"
import "core:strings"
import rl "vendor:raylib"

// TODO: hot reload with dynlib for faster iteration
// TODO: runtime config
// TODO: more customization (each border, font size, etc.)

clay_init :: proc() {
    min_memory_size := cl.MinMemorySize()
    memory := make([^]u8, min_memory_size)
    arena := cl.CreateArenaWithCapacityAndMemory(uint(min_memory_size), memory)
    cl.Initialize(arena, {1280, 720}, {
        handler = proc "c" (errorData : cl.ErrorData) {  },
    })

    append_elem(&cl.raylib_fonts, {font = font})
    cl.SetMeasureTextFunction(cl.measure_text, nil)
}

clay_update :: proc() {
    dt := rl.GetFrameTime()
    cl.SetPointerState(
        {cast(f32)rl.GetMouseX(), cast(f32)rl.GetMouseY()},
        rl.IsMouseButtonPressed(.LEFT),
    )
    cl.UpdateScrollContainers(true, rl.GetMouseWheelMoveV(), dt)
    cl.SetLayoutDimensions(
        {cast(f32)rl.GetRenderWidth(), cast(f32)rl.GetRenderHeight()},
    )
}

clay_draw :: proc() -> cl.ClayArray(cl.RenderCommand) {
    cl.BeginLayout()

    if cl.UI(cl.ID("Root"))(
    {
        layout = {
            sizing = {width = {type = .Grow}, height = {type = .Grow}},
            padding = cl.PaddingAll(padding),
            childGap = child_gap,
            childAlignment = {x = .Center, y = .Center},
            layoutDirection = .TopToBottom,
        },
        backgroundColor = bg,
        cornerRadius = cl.CornerRadiusAll(corner_radius),
        border = {
            color = border_color,
            width = cl.BorderOutside(border_width),
        },
    },
    ) {
        if cl.UI(cl.ID("Header"))(
        {
            layout = {
                sizing = {
                    width = {type = .Grow},
                    height = {
                        type = .Fixed,
                        constraints = {sizePercent = header_height},
                    },
                },
                childGap = child_gap,
                childAlignment = {x = .Center, y = .Center},
                layoutDirection = .LeftToRight,
                padding = cl.PaddingAll(padding),
            },
            backgroundColor = header_bg_color,
            cornerRadius = cl.CornerRadiusAll(corner_radius),
            border = {
                color = border_color,
                width = cl.BorderOutside(border_width),
            },
        },
        ) {
            if cl.UI(cl.ID("Input"))(
            {
                layout = {
                    sizing = {
                        width = {type = .Grow},
                        height = {
                            type = .Fixed,
                            constraints = {sizePercent = input_height},
                        },
                    },
                    childAlignment = {y = .Center},
                    padding = cl.PaddingAll(padding),
                },
                backgroundColor = cl.Hovered() ? input_hover_bg_color : input_bg_color,
                cornerRadius = cl.CornerRadiusAll(corner_radius),
                border = {
                    color = border_color,
                    width = cl.BorderOutside(border_width),
                },
            },
            ) {
                cl.Text(
                    strings.to_string(input),
                    {
                        textColor = cl.Hovered() ? input_hover_fg_color : input_fg_color,
                        fontId = 0,
                        fontSize = text_size,
                        textAlignment = .Left,
                    },
                )
                if cl.Hovered() {
                    for c := rl.GetCharPressed();
                        (c >= 'a' && c <= 'z') ||
                        (c >= 'A' && c <= 'Z') ||
                        (c >= '0' + 0 && c <= '0' + 9);
                        c = rl.GetCharPressed() {
                        strings.write_rune(&input, c)
                    }

                    if rl.IsKeyPressed(.BACKSPACE) {
                        strings.pop_rune(&input)
                    }
                }
            }
            if cl.UI(cl.ID("Add"))(
            {
                layout = {
                    sizing = {
                        width = {
                            type = .Fixed,
                            constraints = {sizePercent = add_width},
                        },
                        height = {
                            type = .Fixed,
                            constraints = {sizePercent = add_height},
                        },
                    },
                    childAlignment = {x = .Center, y = .Center},
                },
                backgroundColor = cl.Hovered() ? add_hover_bg_color : add_bg_color,
                cornerRadius = cl.CornerRadiusAll(corner_radius),
                border = {
                    color = border_color,
                    width = cl.BorderOutside(border_width),
                },
            },
            ) {
                cl.Text(
                    "Add",
                    {
                        textColor = cl.Hovered() ? add_hover_fg_color : add_fg_color,
                        fontId = 0,
                        fontSize = text_size,
                        textAlignment = .Center,
                    },
                )
                // TODO: show some kind of visual notification/warning about duplicate title
                // NOTE: or maybe allow duplicates?
                if cl.Hovered() &&
                   rl.IsMouseButtonPressed(.LEFT) &&
                   strings.builder_len(input) > 0 &&
                   unique_todo_title(strings.to_string(input)) {
                    todo := Todo {
                        strings.to_string(input),
                        "",
                        false,
                        datetime_now(),
                    }
                    append(&todos, todo)
                    save_todos()
                    clear(&input.buf)
                }
            }
        }
        if cl.UI(cl.ID("Todos"))(
        {
            layout = {
                sizing = {width = {type = .Grow}, height = {type = .Grow}},
                childGap = child_gap,
                childAlignment = {x = .Center, y = .Center},
                padding = cl.PaddingAll(padding),
                layoutDirection = .TopToBottom,
            },
            backgroundColor = todo_bg_color,
            cornerRadius = cl.CornerRadiusAll(corner_radius),
            border = {
                color = border_color,
                width = cl.BorderOutside(border_width),
            },
            clip = {vertical = true, childOffset = cl.GetScrollOffset()},
        },
        ) {
            for &todo, i in todos {
                if cl.UI(cl.ID("todo"))(
                {
                    layout = {
                        sizing = {
                            width = {type = .Grow},
                            height = {
                                type = .Fixed,
                                constraints = {sizePercent = todo_height},
                            },
                        },
                        childGap = child_gap,
                        childAlignment = {y = .Center},
                        layoutDirection = .LeftToRight,
                        padding = cl.PaddingAll(padding),
                    },
                    backgroundColor = todo_bg_color,
                    cornerRadius = cl.CornerRadiusAll(corner_radius),
                    border = {
                        color = border_color,
                        width = cl.BorderOutside(border_width),
                    },
                },
                ) {
                    if cl.UI(cl.ID("title"))(
                    {
                        layout = {
                            sizing = {width = {type = .Fit}},
                            childAlignment = {y = .Center},
                        },
                    },
                    ) {
                        cl.Text(
                            todo.title,
                            {
                                textColor = todo_fg_color,
                                fontId = 0,
                                fontSize = text_size,
                                textAlignment = .Center,
                            },
                        )
                    }
                    // TODO: this should be an input field!
                    if cl.UI(cl.ID("description"))(
                    {
                        layout = {
                            sizing = {width = {type = .Grow}},
                            childAlignment = {y = .Center},
                        },
                    },
                    ) {
                        cl.Text(
                            todo.description,
                            {
                                textColor = todo_fg_color,
                                fontId = 0,
                                fontSize = text_size,
                                textAlignment = .Center,
                            },
                        )
                    }
                    // TODO: filter completed/non-completed
                    if cl.UI(cl.ID("completion_toggle"))(
                    {
                        layout = {
                            sizing = {width = {type = .Fit}},
                            childAlignment = {y = .Center},
                            padding = cl.PaddingAll(padding),
                        },
                        border = {
                            color = border_color,
                            width = cl.BorderOutside(border_width),
                        },
                        backgroundColor = cl.Hovered() ? toggle_hover_bg_color : toggle_bg_color,
                    },
                    ) {
                        cl.Text(
                            todo.completed ? "[ X ]" : "[ ]",
                            {
                                textColor = cl.Hovered() ? toggle_hover_fg_color : toggle_fg_color,
                                fontId = 0,
                                fontSize = text_size,
                                textAlignment = .Center,
                            },
                        )
                        if cl.Hovered() && rl.IsMouseButtonPressed(.LEFT) {
                            todo.completed = !todo.completed
                            save_todos()
                        }
                        // NOTE: button with text when toggled
                    }
                    if cl.UI(cl.ID("date"))(
                    {
                        layout = {
                            sizing = {width = {type = .Fit}},
                            childAlignment = {y = .Center},
                        },
                    },
                    ) {
                        cl.Text(
                            datetime_to_string(todo.date_created),
                            {
                                textColor = todo_fg_color,
                                fontId = 0,
                                fontSize = text_size,
                                textAlignment = .Center,
                            },
                        )
                    }
                    // TODO: optionally floating undo button for a short period
                    // after deleting a Todo
                    if cl.UI(cl.ID("delete"))(
                    {
                        layout = {
                            sizing = {width = {type = .Fit}},
                            childAlignment = {y = .Center},
                            padding = cl.PaddingAll(padding),
                        },
                        border = {
                            color = border_color,
                            width = cl.BorderOutside(border_width),
                        },
                        backgroundColor = cl.Hovered() ? delete_hover_bg_color : delete_bg_color,
                    },
                    ) {
                        cl.Text(
                            "X",
                            {
                                textColor = cl.Hovered() ? delete_hover_fg_color : delete_fg_color,
                                fontId = 0,
                                fontSize = text_size,
                                textAlignment = .Center,
                            },
                        )
                        if cl.Hovered() && rl.IsMouseButtonPressed(.LEFT) {
                            ordered_remove(&todos, i)
                            save_todos()
                        }
                    }
                }
            }
        }
    }

    return cl.EndLayout(rl.GetFrameTime())
}
