package engine
import ecs "../deps/odin_ecs/src"
import "core:fmt"
import "core:slice"

AI :: struct { neurons_count: int }

World :: struct {
    db: ecs.Database,
    tables: map[typeid]rawptr,
    views: map[TypePairs]rawptr,
    view: ecs.View
}

Database :: distinct ecs.Database
Table :: struct($T: typeid) {
    using table: ecs.Table(T)
}
View :: distinct ecs.View
Error :: distinct ecs.Error
entity_id :: distinct ecs.entity_id

start_database :: proc (db: ^Database, cap: u32) -> Error {
    err: ecs.Error
    err = ecs.init((^ecs.Database)(db), cap)
    return Error(err)
}

ecs_db_shutdown :: proc (db: ^Database) -> Error {
    err: ecs.Error
    err = ecs.terminate((^ecs.Database)(db))
    return Error(err)
}

start_table :: proc(self: ^Table($T), db: ^Database, cap: int) -> Error {
    err: ecs.Error
    err = ecs.table_init(&self.table, (^ecs.Database)(db), cap)
    return Error(err)
}

start_view :: proc () -> ecs.View {
    view: ecs.View
    return view
}

entity_start :: proc (db: ^Database) -> (entity_id, Error) {
    eid: ecs.entity_id
    err: ecs.Error
    eid, err = ecs.create_entity((^ecs.Database)(db))
    return entity_id(eid), Error(err)
}

entity_add_component :: proc (self: ^Table($T), eid: entity_id) -> (^T, Error) {
    err: ecs.Error
    component: ^T
    component, err = ecs.add_component(&self.table, ecs.entity_id(eid))
    return component, Error(err)
}

entity_get_component_by_id :: proc (self: ^Table($T), eid: entity_id) -> ^T {
    component: ^T
    component = ecs.get_component(&self.table, ecs.entity_id(eid))
    return component
}

components_get_all :: proc (self: ^Table($T)) -> []T {
    return ecs.slice(&self.table)
}

components_get_all_ids :: proc (self: ^Table($T)) -> []entity_id {
    return slice.reinterpret([]entity_id, ecs.entities_slice(&self.table))
}


table_iterate :: proc (self: ^Table($T)) {
    // Iterate over table
    table_dense := ecs.slice(&self.table)
    table_eids := ecs.entities_slice(&self.table)
    for i in 0..<len(table_dense) {
        eid := table_eids[i]
        // ai = ecs.get_component(&ais, eid)

        fmt.println("Iterating over table: ", eid, table_dense[i])
    }
}

startup_world :: proc (world: ^World) {
    // Init ECS databas
    ecs.init(&world.db, entities_cap=100)
    log_debug("init world")

    world.tables = make(map[typeid]rawptr)

    // Init component tables
    positions : ecs.Table(Position)
    ais : ecs.Table(AI)
    ecs.table_init(&positions, &world.db, 10)
    ecs.table_init(&ais, &world.db, 10)

    // Init view
    ecs.view_init(&world.view, &world.db, {&ais, &positions})


    // Create entity and add components
    robot, _ := ecs.create_entity(&world.db)
    fmt.println("Robot entity:", robot)

    pos1, _ := ecs.add_component(&positions, robot)
    pos1.x = 67
    pos1.y = 43

    pos2 := ecs.get_component(&positions, robot)

    assert(pos1 == pos2)

    ai: ^AI
    ai, _ = ecs.add_component(&ais, robot)
    ai.neurons_count = 88

    // Iterate over table
    pos_dense := ecs.slice(&positions)
    pos_eids := ecs.entities_slice(&positions)
    for i in 0..<len(pos_dense) {
        eid := pos_eids[i]
        ai = ecs.get_component(&ais, eid)

        fmt.println("Iterating over table: ", eid, pos_dense[i], ai)
    }

    // Iterate over view
    pos_slice := ecs.slice(&world.view, Position)
    ai_slice := ecs.slice(&world.view, AI)
    view_eids := ecs.entities_slice(&world.view)

    for i in 0..<len(pos_slice) {
        fmt.println("Iterating over view: ", view_eids[i], pos_slice[i], ai_slice[i])
    }

    fmt.println("Total memory usage:", ecs.memory_usage(&world.db), "bytes")

}