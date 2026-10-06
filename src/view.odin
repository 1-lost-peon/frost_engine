package engine

import ecs "../deps/odin_ecs/src"

// register_view(app, Position, Velocity)

TypePairs :: struct {
    t: typeid,
    u: typeid,
}


register_view :: proc(
    world: ^World,
    $T: typeid,
    $U: typeid,
) {
    if world.views == nil {
        world.views = make(map[TypePairs]rawptr)
    }

    key := TypePairs{T, U}

    t_table := get_table(world, T)
    u_table := get_table(world, U)

    view := new(ecs.View)

    ecs.view_init(
        view,
        &world.db,
        {t_table, u_table},
    )

    world.views[key] = view
}


get_view :: proc(
    world: ^World,
    $T: typeid,
    $U: typeid,
) -> ([]^T, []^U) {
    pair := TypePairs{T, U}

    ptr, ok := world.views[pair]
    if !ok {
        return nil, nil
    }

    view := cast(^ecs.View)ptr

    return ecs.slice(view, T), ecs.slice(view, U)
}