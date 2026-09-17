package engine

import rl "vendor:raylib"
import "core:strings"


load_shader :: proc(filename: string) -> rl.Shader {
    vs_filename := strings.concatenate({
        "src/resources/shaders/",
        filename,
        ".vs",
    })
    defer delete(vs_filename)

    fs_filename := strings.concatenate({
        "src/resources/shaders/",
        filename,
        ".fs",
    })
    defer delete(fs_filename)

    vs_cstr := strings.clone_to_cstring(vs_filename)
    defer delete(vs_cstr)

    fs_cstr := strings.clone_to_cstring(fs_filename)
    defer delete(fs_cstr)

    shader := rl.LoadShader(vs_cstr, fs_cstr)

    return shader
}