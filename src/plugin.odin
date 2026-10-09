package engine

import rl "vendor:raylib"


Plugin_Build :: proc(app: ^App)

Plugin :: struct {
    name: string,
    build: Plugin_Build,
}

default_plugin :: Plugin{
    name  = "Default",
    build = default_plugin_build,
}

default_plugin_build :: proc(app: ^App) {
    // register_component(&app.world, Timer)
    // register_component(&app.world, Transform)
    // register_component(&app.world, Camera3D)

    // add_system(app, .Update, update_point_lights)
    // add_system(app, .Fixed_Update, timer_system_update)
    // add_system(app, .Startup, window_startup)
    // add_system(app, .Update, render_scene)
}


default_plugin_startup :: proc(app: ^App) {
    // register_component(&app.world, Timer)
    // register_component(&app.world, Camera3D)
    // register_component(&app.world, Transform)
    // register_component(&app.world, Mesh3D)
    // register_component(&app.world, MeshMaterial3d)
    // register_view(app, Camera3D, Transform)
    // register_view(app, Mesh3D, Transform)
    // register_view(app, Mesh3D, MeshMaterial3d)
    // register_component(&app.world, PointLight)
    // register_view(app, PointLight, Transform)
    app.running = true

    // rl.SetTraceLogLevel(rl.TraceLogLevel.NONE)
    rl.InitWindow(1280, 720, "Control Rig")
   	rl.SetTargetFPS(60) 
}


default_plugin_update :: proc(app: ^App) {
    // update_point_lights(app)

    // rl.BeginDrawing()
    // rl.ClearBackground(rl.GRAY)

    // cameras, camera_transforms := get_view(app, Camera3D, Transform)
    // assert(len(cameras) == len(camera_transforms))

    // for i in 0..<len(cameras) {
    //     camera := cameras[i]
    //     transform := camera_transforms[i]

    //     assert(camera != nil)
    //     assert(transform != nil)

    //     rl.BeginMode3D(rl.Camera3D{
    //         position = camera_transforms[i].translation,
    //         target = camera_transforms[i].target,
    //         up = camera_transforms[i].up,
    //         fovy = cameras[i].fovy,
    //         projection = cameras[i].projection,
    //     })
    // }

    // light, light_transforms := get_view(app, PointLight, Transform)
    // draw_point_light_debug(light, light_transforms)

    

    // meshes, transforms := get_view(app, Mesh3D, Transform)
    // draw_mesh_models(meshes, transforms)

    // // draw_shape(shapes[0]^, transforms[0].translation, rl.RED)

    // rl.EndMode3D()

    // rl.EndDrawing()
}