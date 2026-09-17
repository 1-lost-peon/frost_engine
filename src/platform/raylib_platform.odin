package platform

import rl "vendor:raylib"

raylib_plugin_build :: proc(app: ^App) {
    add_system(app, .Startup, raylib_startup)
    add_system(app, .Frame_Begin, raylib_frame_begin)
    add_system(app, .Shutdown, raylib_shutdown)
}

raylib_startup :: proc(app: ^App) {
    rl.InitWindow(1280, 720, "Control Rig")
    rl.SetTargetFPS(60)
}

raylib_frame_begin :: proc(app: ^App) {
    app.time.delta = rl.GetFrameTime()

    if rl.WindowShouldClose() {
        app.running = false
    }
}

raylib_shutdown :: proc(app: ^App) {
    rl.CloseWindow()
}