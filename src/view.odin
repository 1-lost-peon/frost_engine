package engine

import "core:fmt"
import rl "vendor:raylib"

// import ecs "deps:odin_ecs/src"
import ecs "../deps/odin_ecs/src"

// register_view(app, Position, Velocity)

TypePairs :: struct {
    t: typeid,
    u: typeid,
}


// register_view :: proc(
//     app: ^App,
//     $T: typeid,
//     $U: typeid,
// ) {
//     if app.views == nil {
//         app.views = make(map[TypePairs]rawptr)
//     }

//     key := TypePairs{T, U}

//     t_table := get_table(app, T)
//     u_table := get_table(app, U)

//     view := new(ecs.View)

//     ecs.view_init(
//         view,
//         &app.db,
//         {t_table, u_table},
//     )

//     app.views[key] = view
// }


// get_view :: proc(
//     app: ^App,
//     $T: typeid,
//     $U: typeid,
// ) -> ([]^T, []^U) {
//     pair := TypePairs{T, U}

//     ptr, ok := app.views[pair]
//     if !ok {
//         return nil, nil
//     }

//     view := cast(^ecs.View)ptr

//     return ecs.slice(view, T), ecs.slice(view, U)
// }