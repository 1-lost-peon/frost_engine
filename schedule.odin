package engine

System :: proc(app: ^App)

Schedule_Stage :: enum {
    Startup,
    Frame_Begin,
    Update,
    Fixed_Update,
    Shutdown,
}

Schedule :: struct {
    startup: [dynamic]System,
    frame_begin: [dynamic]System,
    update: [dynamic]System,
    fixed_update: [dynamic]System,
    shutdown: [dynamic]System,
}

add_system :: proc(app: ^App, stage: Schedule_Stage, system: System) {
    switch stage {
        case Schedule_Stage.Startup:
            append(&app.schedule.startup, system)
        case Schedule_Stage.Frame_Begin:
            append(&app.schedule.frame_begin, system)
        case Schedule_Stage.Update:
            append(&app.schedule.update, system)
        case Schedule_Stage.Fixed_Update:
            append(&app.schedule.fixed_update, system)
        case Schedule_Stage.Shutdown:
            append(&app.schedule.shutdown, system)
        }
}

run_systems :: proc(app: ^App, stage: Schedule_Stage) {
    switch stage {
        case Schedule_Stage.Startup:
            for system in app.schedule.startup {
                system(app)
            }
        case Schedule_Stage.Frame_Begin:
            for system in app.schedule.frame_begin {
                system(app)
            }
        case Schedule_Stage.Update:
            for system in app.schedule.update {
                system(app)
            }
        case Schedule_Stage.Fixed_Update:
            for system in app.schedule.fixed_update {
                system(app)
            }
        case Schedule_Stage.Shutdown:
            for system in app.schedule.shutdown {
                system(app)
            }
        }
}