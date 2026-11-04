package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

DateTime :: struct {
    y :  i64,
    mo : i8,
    d :  i8,
    h :  i8,
    mi : i8,
    s :  i8,
}

Todo :: struct {
    title :        string,
    description :  string,
    completed :    bool,
    date_created : DateTime,
}

load_todos :: proc() -> bool {
    data, err := os.read_entire_file(db_filepath, context.allocator)
    if err != nil {
        fmt.eprintln("Failed to read database file:", err)
        return false
    }
    err1 := json.unmarshal(data, &todos)
    if err1 != nil {
        fmt.eprintln("Failed to parse database json:", err)
        return false
    }
    return true
}

save_todos :: proc() -> bool {
    data, err := json.marshal(todos)
    if err != nil {
        fmt.eprintln("Failed to serialize todos to json:", err)
        return false
    }
    err1 := os.write_entire_file(db_filepath, data)
    if err1 != nil {
        fmt.eprintln("Failed to write json to database file:", err)
        return false
    }
    return true
}
