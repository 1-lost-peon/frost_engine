package engine
import rl "vendor:raylib"
import "core:fmt"


PointLight :: struct {
    color: rl.Color,
    intensity: f32,
    range: f32,

    shadow_maps_enabled: bool,
    shadow_depth_bias: f32,
}


update_point_lights :: proc(app: ^App) {
    lights, transforms := get_view(app, PointLight, Transform)

    if len(lights) == 0 {
        return
    }

    light := lights[0]
    transform := transforms[0]

    light_pos := transform.translation

    light_color := [3]f32{
        f32(light.color.r) / 255.0,
        f32(light.color.g) / 255.0,
        f32(light.color.b) / 255.0,
    }

    fmt.println(
        "shader light color:", light_color,
        " intensity:", light.intensity,
    )

    ambient_strength: f32 = 0.2


    fmt.println(
        "light position:", transform.translation,
        " color:", light.color,
    )



    meshes, materials := get_view(app, Mesh3D, MeshMaterial3d)

    for i in 0..<len(materials) {
        shader := materials[i].shader

        pos_loc := rl.GetShaderLocation(shader, "lightPos")
        color_loc := rl.GetShaderLocation(shader, "lightColor")
        ambient_loc := rl.GetShaderLocation(shader, "ambientStrength")
        intensity_loc := rl.GetShaderLocation(
            shader,
            "lightIntensity",
        )
        range_loc := rl.GetShaderLocation(
            shader,
            "lightRange",
        )

        fmt.println(
            "pos:", pos_loc,
            " color:", color_loc,
            " ambient:", ambient_loc,
        )

        rl.SetShaderValue(
            shader,
            pos_loc,
            &light_pos,
            .VEC3,
        )

        rl.SetShaderValue(
            shader,
            color_loc,
            &light_color,
            .VEC3,
        )

        rl.SetShaderValue(
            shader,
            ambient_loc,
            &ambient_strength,
            .FLOAT,
        )

        rl.SetShaderValue(
            shader,
            intensity_loc,
            &light.intensity,
            .FLOAT,
        )

        rl.SetShaderValue(
            shader,
            range_loc,
            &light.range,
            .FLOAT,
        )

        fmt.println(
            "pos:", pos_loc,
            " color:", color_loc,
            " ambient:", ambient_loc,
            " intensity:", intensity_loc,
        )
    }
}


draw_point_light_debug :: proc(
    lights: []^PointLight,
    transforms: []^Transform,
) {
    for i in 0..<len(lights) {
        rl.DrawSphere(
            transforms[i].translation,
            0.2,
            lights[i].color,
        )
    }
}