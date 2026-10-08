package engine

import rl "vendor:raylib"
import r3d "../deps/r3d/r3d"
import "core:strings"
import "core:math/rand"

/**************** 
* CONSTANTS
****************/

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
NUMBER_OF_ENTITIES :: 100_000

/**************** 
* PLUGIN
****************/

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

/**************** 
* COMPONENTS
****************/


/**************** 
* GLOBALS
****************/

raylib_db: Database
positions: Table(Position)
meshes: Table(r3d.Mesh)
materials: Table(r3d.Material)
lights: Table(r3d.Light)
shadows: Table(r3d.ShadowMap)


// enemy_view: View

// register_components :: proc(app: ^App) {
//     register_component(&app.world, r3d.Mesh)
//     register_component(&app.world, r3d.Material)
//     register_component(&app.world, r3d.Light)
//     register_component(&app.world, r3d.ShadowMap)
// }

/**************** 
* STARTUP
****************/

raylib_startup :: proc(app: ^App) {
    // Initialize window
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, strings.clone_to_cstring(app.settings.name))
    rl.SetTargetFPS(60)

    // Initialize R3D
    r3d.Init(SCREEN_WIDTH, SCREEN_HEIGHT) 

    app.renderer.camera.position = {0, 2, 2}
    app.renderer.camera.target = {0, 0, 0}
    app.renderer.camera.up = {0, 1, 0}
    app.renderer.camera.fovy = 60

    // Variables
    err: Error

    // Start Tables
    err = start_database(&raylib_db, NUMBER_OF_ENTITIES)

    err = start_table(&positions, &raylib_db, NUMBER_OF_ENTITIES)
    err = start_table(&meshes, &raylib_db, NUMBER_OF_ENTITIES)
    err = start_table(&materials, &raylib_db, NUMBER_OF_ENTITIES)
    err = start_table(&lights, &raylib_db, NUMBER_OF_ENTITIES)
    err = start_table(&shadows, &raylib_db, NUMBER_OF_ENTITIES)

    // Plane
    // plane_eid: entity_id
    // plane_position: ^Position
    // plane_mesh: ^r3d.Mesh
    // plane_material: ^r3d.Material

    // plane_eid, err = entity_start(&raylib_db)
    // plane_position, err = entity_add_component(&positions, plane_eid)
    // plane_position^ = Position{
    //     x = 0, 
    //     y = -0.5, 
    //     z = 0
    // }
    // plane_mesh, err = entity_add_component(&meshes, plane_eid)
    // plane_mesh^ = r3d.GenMeshPlane(1000, 1000, 1, 1)
    // plane_material, err = entity_add_component(&materials, plane_eid)
    // plane_material^ = r3d.GetDefaultMaterial()

    // Spheres
    for i:=0; i < 5000; i+=1 {
        sphere_eid: entity_id
        sphere_position: ^Position
        sphere_mesh: ^r3d.Mesh
        sphere_material: ^r3d.Material
    
        sphere_eid, err = entity_start(&raylib_db)
        sphere_position, err = entity_add_component(&positions, sphere_eid)
        sphere_position^ = Position{
            // x = 0, 
            x = rand.float32_range(-2, 2), 
            y = rand.float32_range(-1, 0), 
            // y = rand.float32_range(0, 500), 
            z = rand.float32_range(-2, 2)
        }
        sphere_mesh, err = entity_add_component(&meshes, sphere_eid)
        sphere_mesh^ = r3d.GenMeshSphere(0.5, 64, 64)
        sphere_material, err = entity_add_component(&materials, sphere_eid)
        sphere_material^ = r3d.GetDefaultMaterial()
    }

    // Light
    light_eid: entity_id
    light_light: ^r3d.Light
    light_shadow: ^r3d.ShadowMap

    light_eid, err = entity_start(&raylib_db)
    light_light, err = entity_add_component(&lights, light_eid)
    light_light^ = r3d.CreateSpotLight({0, 10, 5}, {0, -1, -0.5}, 50.0, rl.WHITE, 1.0)
    light_shadow, err = entity_add_component(&shadows, light_eid)
    light_shadow^ = r3d.LoadShadowMap(.SPOT)
    light_shadow.softness = 4.0

    // register_view(&app.world, r3d.Light, r3d.ShadowMap)
    // register_view(&app.world, r3d.Mesh, r3d.Material)

    // spawn_entity(
    //     &app.world,
    //     r3d.GenMeshPlane(1000, 1000, 1, 1),
    //     r3d.GetDefaultMaterial()
    // )

    // spawn_entity(
    //     &app.world,
    //     r3d.GenMeshPlane(1000, 1000, 1, 1),
    //     r3d.GenMeshSphere(0.5, 64, 64)
    // )

    // shadow := r3d.LoadShadowMap(.SPOT)
    // shadow.softness = 4.0

    // spawn_entity(
    //     &app.world,
    //     r3d.CreateSpotLight({0, 10, 5}, {0, -1, -0.5}, 50.0, rl.WHITE, 1.0),
    //     shadow
    // )



    // Create meshes
    // plane := r3d.GenMeshPlane(1000, 1000, 1, 1)
    // sphere := r3d.GenMeshSphere(0.5, 64, 64)
    // material := r3d.GetDefaultMaterial()

    // Setup environment
    env := r3d.GetEnvironment()
    env.ambient.color = {10, 10, 10, 255}

    // Create light
    // light := r3d.CreateSpotLight({0, 10, 5}, {0, -1, -0.5}, 50.0, rl.WHITE, 1.0)
    // shadow := r3d.LoadShadowMap(.SPOT)
    // shadow.softness = 4.0
    
}


raylib_update :: proc(app: ^App) {
    if (rl.WindowShouldClose()) {
        app.running = false
    }

    // pair := TypePairs{r3d.Mesh, r3d.Material}
    // meshes, materials := get_view(&app.world, r3d.Mesh, r3d.Material)

    // light_pair := TypePairs{r3d.Light, r3d.ShadowMap}
    // lights, shadows := get_view(&app.world, r3d.Light, r3d.ShadowMap)

    position: ^Position
    material: ^r3d.Material
    mesh_slice := components_get_all(&meshes)
    mesh_ids := components_get_all_ids(&meshes)
    // materials := components_get_all(&materials)
    // positions := components_get_all(&positions)

    shadow: ^r3d.ShadowMap
    light_slice := components_get_all(&lights)
    light_ids := components_get_all_ids(&lights)

    camera: rl.Camera3D = rl.Camera3D{
        position = app.renderer.camera.position,
        target = app.renderer.camera.target,
        up = app.renderer.camera.up,
        fovy = app.renderer.camera.fovy,
        projection = rl.CameraProjection.PERSPECTIVE,
    }

    for &pos in components_get_all(&positions) {
        pos = Position{
            // x = 0, 
            x = pos.x + rand.float32_range(-1, 1) * rl.GetFrameTime(), 
            y = pos.y + rand.float32_range(-1, 1) * rl.GetFrameTime(), 
            // y = rand.float32_range(0, 500), 
            z = pos.z + rand.float32_range(-1, 1) * rl.GetFrameTime()
        }
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.WHITE)
    r3d.Begin(rl.Camera3D(camera))

    {
        for i in 0..<len(mesh_slice) {
            eid := mesh_ids[i]
            position = entity_get_component_by_id(&positions, eid)
            material = entity_get_component_by_id(&materials, eid)
            r3d.DrawMesh(mesh_slice[i], material^, {position.x, position.y, position.z}, 0.05)
            // r3d.DrawMesh(sphere, material, {0, 0, 0}, 1.0)
        }

        for i in 0..<len(light_slice) {
            eid := light_ids[i]
            shadow = entity_get_component_by_id(&shadows, eid)
            r3d.PushLightEx(light_slice[i], shadow^, false)
        }
    }

    r3d.End()

    rl.DrawFPS(10, 10)

    rl.EndDrawing()
}


raylib_shutdown :: proc(app: ^App) {
    // meshes := get_components(&app.world, r3d.Mesh)
    // for i in 0..<len(meshes) {
    //     r3d.UnloadMesh(meshes[i])
    // }
    ecs_db_shutdown(&raylib_db)

    r3d.Close()
    rl.CloseWindow()
}