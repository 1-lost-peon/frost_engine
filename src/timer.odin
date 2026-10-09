package engine


Timer :: struct {
    remaining:  f32,
    duration: f32,
    ticked: bool,
}

Time :: struct {
    delta:       f32,
    fixed_delta: f32,
    accumulator: f32,
}


// timer_system_update :: proc(app: ^App) {
//     dt := app.time.fixed_delta

//     timers := get_components(&app.world, Timer)

//     for &timer in timers {
//         timer.remaining -= dt

//         if timer.remaining <= 0 {
//             timer.ticked = true
//             timer.remaining = timer.duration
//         } else {
//             timer.ticked = false
//         }
//     }
// }