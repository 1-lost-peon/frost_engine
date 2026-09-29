package engine

// import mn "deps:frost_engine/deps/muninn"
import mn "../deps/muninn"

path  := "c:/dev/my_app"
host  := "127.0.0.1"
port  := 22
delay := 15
err   := "This is not good!!!"
version := "0.0.1"

App :: struct {
    name: string,
    version: string,

    plugins: [dynamic]Plugin,
    schedule: Schedule,

    world: World,
    time: Time,

    platform: Platform,

    running: bool,
}

app_startup :: proc(app: ^App) { // RENAME TO STARTUP_APP
    app.running = true
    app.version = version

    app.time.fixed_delta = 1.0 / 60.0

    init_world(&app.world)

    for plugin in app.plugins {
        plugin.build(app)
    }
    // run_systems(app, .Startup) --> SHOULD BE STARTUP

    log_init(level = .TRACE, log_dir = ".logs/app.jsonl")

    log_title("My Game")

    // log_trace("cache warm: %d entries", 128)
    // log_debug("config loaded from %s", path)
    log_info("My Game Version %s starting", app.version)
    // log_sep("-")
    // log_warn("retrying in %v", delay)
    // log_error("connection dropped: %v", err)

    // mn.sep(char = "-", color = mn.GRAY)

    // only if you bail out without returning from main:
    // mn.exit(1)
}

app_shutdown :: proc(app: ^App) {
    log_info("My Game shuting down")
    shutdown_world(&app.world)

    delete(app.schedule.startup)
    delete(app.schedule.update)
    delete(app.schedule.fixed_update)
    // run_systems(app, .Shutdown) --> THIS SHOULD BE HERE
    log_info("Good bye!")
}

app_run :: proc(app: ^App) {
    run_systems(app, .Startup) // NEEDS A NEW NAME... BEFORE LOOP. MAYBE WE JUST MOVE IT
    log_info("App running...")
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