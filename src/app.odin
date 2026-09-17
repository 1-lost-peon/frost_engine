package engine

App :: struct {
    name: string,

    plugins: [dynamic]Plugin,
    schedule: Schedule,

    world: World,
    time: Time,

    platform: Platform,

    running: bool,
}

init_app :: proc(app: ^App) { // RENAME TO STARTUP_APP
    app.running = true

    app.time.fixed_delta = 1.0 / 60.0

    init_world(&app.world)

    for plugin in app.plugins {
        plugin.build(app)
    }
    // run_systems(app, .Startup) --> SHOULD BE STARTUP
}

shutdown_app :: proc(app: ^App) {
    shutdown_world(&app.world)

    delete(app.schedule.startup)
    delete(app.schedule.update)
    delete(app.schedule.fixed_update)
    // run_systems(app, .Shutdown) --> THIS SHOULD BE HERE
}


run_app :: proc(app: ^App) {
    run_systems(app, .Startup) // NEEDS A NEW NAME... BEFORE LOOP. MAYBE WE JUST MOVE IT

    for app.running {
        run_systems(app, .Frame_Begin)
        app.time.accumulator += app.time.delta

        // Fixed simulation
        for app.time.accumulator >= app.time.fixed_delta {
            run_systems(app, .Fixed_Update)

            app.time.accumulator -= app.time.fixed_delta
        }

        // Normal per-frame update
        run_systems(app, .Update)
    }

    run_systems(app, .Shutdown) // SHOULD BE FRAME_END
}