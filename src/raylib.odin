package engine

import rl "vendor:raylib"
import "core:strings"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

Raylib_Plugins := []Plugin{
    Core_Raylib_Plugin,
}

Core_Raylib_Plugin := Plugin{
    name  = "Core Raylib",
    build = core_raylib_plugin_build,
}

core_raylib_plugin_build :: proc(app: ^App) {
    add_system(app, Schedule_Stage.Startup, raylib_startup)
    add_system(app, Schedule_Stage.Update, raylib_update)
    add_system(app, Schedule_Stage.Shutdown, raylib_shutdown)
}


raylib_startup :: proc(app: ^App) {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, strings.clone_to_cstring(app.settings.name))
    rl.SetTargetFPS(60)
}


raylib_update :: proc(app: ^App) {
    if (rl.WindowShouldClose()) {
        app.running = false
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.WHITE)
    rl.DrawText("Hello", 190, 200, 20, rl.LIGHTGRAY)
    rl.EndDrawing()
}


raylib_shutdown :: proc(app: ^App) {
    rl.CloseWindow()
}