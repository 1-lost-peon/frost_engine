package engine

import rl "vendor:raylib"
import r3d "../deps/r3d/r3d"
import "core:strings"
import "core:math/rand"


Mesh :: distinct r3d.Mesh
Material :: distinct r3d.Material
Light :: distinct r3d.Light
ShadowMap :: distinct r3d.ShadowMap
AlbedoMap :: distinct r3d.AlbedoMap
NormalMap :: distinct r3d.NormalMap
OrmMap :: distinct r3d.OrmMap
Color :: distinct rl.Color
Texture2D :: distinct rl.Texture2D
TextureWrap :: distinct rl.TextureWrap
// rl.WHITE
WHITE :: [4]i32{255, 255, 255, 255}

generate_mesh_plane :: proc(width: f32, length: f32, resX: i32, resZ: i32) -> Mesh {
    mesh := r3d.GenMeshPlane(width, length, resX, resZ)
    return Mesh(mesh)
}

get_default_material :: proc() -> Material {
    material := r3d.GetDefaultMaterial()
    return Material(material)
}

load_albedo_map :: proc(filepath: string, color: [4]i32) -> r3d.AlbedoMap {
    return r3d.LoadAlbedoMap(strings.clone_to_cstring(filepath), rl.Color(color))
}

load_normal_map :: proc(filepath: string, scale: f32) -> r3d.NormalMap {
    return r3d.LoadNormalMap(strings.clone_to_cstring(filepath), scale)
}

load_orm_map :: proc(filepath: string, occlusion: f32, roughness: f32, metalness: f32, specular: f32) -> r3d.OrmMap {
    return r3d.LoadOrmMap(strings.clone_to_cstring(
        filepath), 
        occlusion,
        roughness,
        metalness,
        specular,
    )
}

load_shadow_map :: proc () -> ShadowMap {
    return ShadowMap(r3d.LoadShadowMap(.SPOT))
}

set_texture_wrap :: proc(texture: rl.Texture2D, wrap: TextureWrap) {
    rl.SetTextureWrap(texture, rl.TextureWrap(wrap))
}

create_spot_light :: proc () -> Light {
    return Light(r3d.CreateSpotLight({0, 10, 5}, {0, -1, -0.5}, 50.0, rl.Color(WHITE), 1.0))
}

draw_mesh :: proc (mesh: Mesh, material: Material, position: [3]f32, scale: f32) {
    r3d.DrawMesh(r3d.Mesh(mesh), r3d.Material(material), position, scale)
}

push_light_ex :: proc (light: Light, _map: ShadowMap, updateShadow: bool) {
    r3d.PushLightEx(r3d.Light(light), r3d.ShadowMap(_map), updateShadow)
}

mesh_unload :: proc (mesh: Mesh) {
    r3d.UnloadMesh(r3d.Mesh(mesh))
}

/**************** 
* CONSTANTS
****************/

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450
NUMBER_OF_ENTITIES :: 100_000

/**************** 
* PLUGIN
****************/

Raylib_Plugin := Plugin{
    name  = "Raylib",
    build = raylib_plugin_build,
}

raylib_plugin_build :: proc(app: ^App) {
    log_trace("RAYLIB - Adding schedule")
    add_system(app, Schedule_Stage.Startup, raylib_startup)
    // add_system(app, Schedule_Stage.Update, raylib_update)
    add_system(app, Schedule_Stage.Pre_Render, raylib_pre_render)
    add_system(app, Schedule_Stage.Render, raylib_render)
    add_system(app, Schedule_Stage.Post_Render, raylib_post_render)
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
    log_info("Raylib Startup")
    // Initialize window
    rl.InitWindow(app.settings.screen_width, app.settings.screen_height, strings.clone_to_cstring(app.settings.name))
    rl.SetTargetFPS(60)

    // Initialize R3D
    r3d.Init(app.settings.screen_width, app.settings.screen_height) 

    app.renderer.camera.position = {0, 2, 2}
    app.renderer.camera.target = {0, 0, 0}
    app.renderer.camera.up = {0, 1, 0}
    app.renderer.camera.fovy = 60

    // // Variables
    // err: Error

    // // Start Tables
    // err = start_database(&raylib_db, NUMBER_OF_ENTITIES)

    // err = start_table(&positions, &raylib_db, NUMBER_OF_ENTITIES)
    // err = start_table(&meshes, &raylib_db, NUMBER_OF_ENTITIES)
    // err = start_table(&materials, &raylib_db, NUMBER_OF_ENTITIES)
    // err = start_table(&lights, &raylib_db, NUMBER_OF_ENTITIES)
    // err = start_table(&shadows, &raylib_db, NUMBER_OF_ENTITIES)

    // // Plane
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
    // plane_mesh^ = r3d.GenMeshPlane(5, 5, 1, 1)
    // plane_material, err = entity_add_component(&materials, plane_eid)
    // plane_material^ = r3d.GetDefaultMaterial()

    // plane_material.albedo = r3d.LoadAlbedoMap(
    //     "assets/ground/color.png",
    //     rl.WHITE,
    // )

    // plane_material.normal = r3d.LoadNormalMap(
    //     "assets/ground/normal.png",
    //     1.0,
    // )

    // plane_material.orm = r3d.LoadOrmMap(
    //     "assets/ground/orm.png",
    //     1.0, // Ambient occlusion
    //     1.0, // Roughness
    //     0.0, // Metalness
    //     0.5, // Specular
    // )

    // rl.SetTextureWrap(plane_material.albedo.texture, .REPEAT)
    // rl.SetTextureWrap(plane_material.normal.texture, .REPEAT)
    // rl.SetTextureWrap(plane_material.orm.texture, .REPEAT)

    // plane_material.uvScale = {16.0, 16.0}

    // // Light
    // light_eid: entity_id
    // light_light: ^r3d.Light
    // light_shadow: ^r3d.ShadowMap

    // light_eid, err = entity_start(&raylib_db)
    // light_light, err = entity_add_component(&lights, light_eid)
    // light_light^ = r3d.CreateSpotLight({0, 10, 5}, {0, -1, -0.5}, 50.0, rl.WHITE, 1.0)
    // light_shadow, err = entity_add_component(&shadows, light_eid)
    // light_shadow^ = r3d.LoadShadowMap(.SPOT)
    // light_shadow.softness = 4.0

    // Setup environment
    env := r3d.GetEnvironment()
    env.ambient.color = {10, 10, 10, 255}
}

/**************** 
* PRE_RENDER
****************/

raylib_pre_render :: proc(app: ^App) {
    if (rl.WindowShouldClose()) {
        app.running = false
    }

    camera: rl.Camera3D = rl.Camera3D{
        position = app.renderer.camera.position,
        target = app.renderer.camera.target,
        up = app.renderer.camera.up,
        fovy = app.renderer.camera.fovy,
        projection = rl.CameraProjection.PERSPECTIVE,
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.WHITE)

    r3d.Begin(rl.Camera3D(camera))
    log_trace("Raylib Pre-render done. Begin draw + begin")
}

/**************** 
* RENDER
****************/

raylib_render :: proc(app: ^App) {

}

/**************** 
* POST_RENDER
****************/

raylib_post_render :: proc(app: ^App) {
    log_trace("Raylib Post-render begin. end draw + end")
    r3d.End()

    rl.DrawFPS(10, 10)

    rl.EndDrawing()
}

// raylib_update :: proc(app: ^App) {
//     // pair := TypePairs{r3d.Mesh, r3d.Material}
//     // meshes, materials := get_view(&app.world, r3d.Mesh, r3d.Material)

//     // light_pair := TypePairs{r3d.Light, r3d.ShadowMap}
//     // lights, shadows := get_view(&app.world, r3d.Light, r3d.ShadowMap)

//     position: ^Position
//     material: ^r3d.Material
//     mesh_slice := components_get_all(&meshes)
//     mesh_ids := components_get_all_ids(&meshes)
//     // materials := components_get_all(&materials)
//     // positions := components_get_all(&positions)

//     shadow: ^r3d.ShadowMap
//     light_slice := components_get_all(&lights)
//     light_ids := components_get_all_ids(&lights)

//     // for &pos in components_get_all(&positions) {
//     //     pos = Position{
//     //         // x = 0, 
//     //         x = pos.x + rand.float32_range(-1, 1) * rl.GetFrameTime(), 
//     //         y = pos.y + rand.float32_range(-1, 1) * rl.GetFrameTime(), 
//     //         // y = rand.float32_range(0, 500), 
//     //         z = pos.z + rand.float32_range(-1, 1) * rl.GetFrameTime()
//     //     }
//     // }



//     {
//         for i in 0..<len(mesh_slice) {
//             eid := mesh_ids[i]
//             position = entity_get_component_by_id(&positions, eid)
//             material = entity_get_component_by_id(&materials, eid)
//             r3d.DrawMesh(mesh_slice[i], material^, {position.x, position.y, position.z}, 1.0)
//             // r3d.DrawMesh(sphere, material, {0, 0, 0}, 1.0)
//         }

//         for i in 0..<len(light_slice) {
//             eid := light_ids[i]
//             shadow = entity_get_component_by_id(&shadows, eid)
//             r3d.PushLightEx(light_slice[i], shadow^, false)
//         }
//     }


// }


raylib_shutdown :: proc(app: ^App) {
    // meshes := get_components(&app.world, r3d.Mesh)
    // for i in 0..<len(meshes) {
    //     r3d.UnloadMesh(meshes[i])
    // }
    // ecs_db_shutdown(&raylib_db)

    r3d.Close()
    rl.CloseWindow()
}