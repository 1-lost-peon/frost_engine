package engine

// import "core:fmt"

// // import ecs "deps:ode_ecs/src"
// import ecs "../deps/odin_ecs/src"

// // World :: struct {
// //     db: ecs.Database,
// //     tables: map[typeid]rawptr,
// //     views: map[TypePairs]rawptr,
// // }

// init_world :: proc (world: ^World) {
//     ecs.init(&world.db, entities_cap = 100)
//     world.tables = make(map[typeid]rawptr)
// }

// shutdown_world :: proc (world: ^World) {
//     ecs.terminate(&world.db)

//     for _, table in world.tables {
//         free(table)
//     }

//     delete(world.tables)
// }

// register_component :: proc(world: ^World, $T: typeid, cap := 100) {
//     id := typeid_of(T)

//     _, exists := world.tables[id]
//     if exists {
//         return
//     }

//     table := new(ecs.Table(T))
//     ecs.table_init(table, &world.db, cap)

//     world.tables[id] = table
//     log_info("Component Registered: %v", id)
// }

// get_table :: proc(world: ^World, $T: typeid) -> ^ecs.Table(T) {
//     raw, exists := world.tables[typeid_of(T)]

//     assert(exists, "Component type has not been registered")

//     return cast(^ecs.Table(T))raw
// }

// add_component :: proc(
//     world: ^World,
//     entity: ecs.entity_id,
//     value: $T,
// ) {
//     table := get_table(world, T)

//     component, _ := ecs.add_component(table, entity)

//     component^ = value
// }

// get_components :: proc(world: ^World, $T: typeid) -> []T {
//     table := get_table(world, T)
//     return ecs.slice(table)
// }

// spawn_entity_1 :: proc(world: ^World, c1: $T1) -> ecs.entity_id {
//     entity, _ := ecs.create_entity(&world.db)

//     add_component(world, entity, c1)

//     return entity
// }

// spawn_entity_2 :: proc(
//     world: ^World,
//     c1: $T1,
//     c2: $T2,
// ) -> ecs.entity_id {
//     entity, _ := ecs.create_entity(&world.db)

//     add_component(world, entity, c1)
//     add_component(world, entity, c2)

//     return entity
// }

// spawn_entity_3 :: proc(
//     world: ^World,
//     c1: $T1,
//     c2: $T2,
//     c3: $T3,
// ) -> ecs.entity_id {
//     entity, _ := ecs.create_entity(&world.db)

//     add_component(world, entity, c1)
//     add_component(world, entity, c2)
//     add_component(world, entity, c3)

//     return entity
// }

// // spawn_entity(&app.world, ...)
// spawn_entity :: proc {
//     spawn_entity_1,
//     spawn_entity_2,
//     spawn_entity_3,
// }