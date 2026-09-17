package engine
import rl "vendor:raylib"


Transform :: struct {
    translation:  [3]f32,
    rotation: quaternion128,
    scale: rl.Vector3,
    target: rl.Vector3,
    up: rl.Vector3,
}


default_transform :: proc(
    translation: rl.Vector3 = [3]f32{0.0, 0.0, 0.0},
    rotation: rl.Quaternion = quaternion(w = 1, x = 0, y = 0, z = 0),
    scale: rl.Vector3 = [3]f32{0.0, 0.0, 0.0},
    target: rl.Vector3 = [3]f32{0.0, 0.0, 0.0},
    up: rl.Vector3 = [3]f32{0.0, 1.0, 0.0},
) -> Transform {
    return Transform{
        translation = translation,
        rotation = rotation,
        scale = scale,
        target = target,
        up = up,
    }
}


MeshMaterial3d :: struct {
    shader_file: string,
    shader: rl.Shader,
    color: rl.Color,
}


/*
    shader: rl.Shader, --Material shader
    maps:   [^]rl.MaterialMap, --Material maps array (MAX_MATERIAL_MAPS)
    params: [4]f32, --Material generic parameters (if required)
*/
// Material :: distinct rl.Material
import "core:fmt"
startup_materials :: proc(materials: []^MeshMaterial3d) {
    fmt.println("material count:", len(materials))

    for i in 0..<len(materials) {
        fmt.println(
            "loading material:",
            i,
            " shader:",
            materials[i].shader_file,
        )

        materials[i].shader = load_shader(
            materials[i].shader_file,
        )

        fmt.println(
            "loaded shader ID:",
            materials[i].shader.id,
        )
    }
}