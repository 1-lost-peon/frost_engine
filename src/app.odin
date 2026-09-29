package engine

import "base:intrinsics"
import "core:sys/posix"

App :: struct {
    settings: App_Settings,

    plugins:  [dynamic]Plugin,
    schedule: Schedule,

    world: World,
    time:  Time,

    platform: Platform,

    running: bool,
}

App_Mode :: enum i32 {
    DEVELOPMENT,
    PRODUCTION,
}

App_Settings :: struct {
    name:    string,
    version: string,
    mode:    App_Mode,
}


// ============================================================================
// App Lifecycle
// ============================================================================

app_startup :: proc(app: ^App) {
    startup_platform(app)
    startup_logging(app)
    startup_runtime(app)
    run_systems(app, .Startup)
}

app_run :: proc(app: ^App) {
    log_info("App running...")

    for app.running {
        run_frame(app)
    }
}

app_shutdown :: proc(app: ^App) {
    run_systems(app, .Shutdown)
    log_info("App shutting down")

    shutdown_world(&app.world)
    shutdown_schedule(app)

    log_info("Good bye!")
}


// ============================================================================
// Startup
// ============================================================================

startup_platform :: proc(app: ^App) {
    app.running = true
    intrinsics.atomic_store(&platform_shutdown_requested, 0)

    posix.signal(.SIGINT,  handle_signal)
    posix.signal(.SIGTERM, handle_signal)
}

startup_logging :: proc(app: ^App) {
    log_init(level = .TRACE, log_dir = ".logs/app.jsonl")

    log_title(app.settings.name)
    log_info("App Version %s starting", app.settings.version)
}

startup_runtime :: proc(app: ^App) {
    app.time.fixed_delta = 1.0 / 60.0

    init_world(&app.world)
    build_plugins(app)
}

build_plugins :: proc(app: ^App) {
    for plugin in app.plugins {
        plugin.build(app)
    }
}


// ============================================================================
// Main Loop
// ============================================================================

run_frame :: proc(app: ^App) {
    poll_platform_events(app)
    run_systems(app, .Frame_Begin)

    app.time.accumulator += app.time.delta
    run_fixed_updates(app)
    run_systems(app, .Update)
    
    // run_systems(app, .Frame_End)
}

run_fixed_updates :: proc(app: ^App) {
    for app.time.accumulator >= app.time.fixed_delta {
        run_systems(app, .Fixed_Update)
        app.time.accumulator -= app.time.fixed_delta
    }
}


// ============================================================================
// Shutdown
// ============================================================================

shutdown_schedule :: proc(app: ^App) {
    delete(app.schedule.startup)
    delete(app.schedule.update)
    delete(app.schedule.fixed_update)
}


// ============================================================================
// Platform Shutdown
// ============================================================================

app_request_shutdown :: proc(app: ^App) {
    app.running = false
}

poll_platform_events :: proc(app: ^App) {
    if intrinsics.atomic_load(&platform_shutdown_requested) != 0 {
        app_request_shutdown(app)
    }
}

platform_shutdown_requested: i32

handle_signal :: proc "c" (signal: posix.Signal) {
    intrinsics.atomic_store(&platform_shutdown_requested, 1)
}