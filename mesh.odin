package engine
import rl "vendor:raylib"


MeshType :: enum {
    Cube,
    Plane,
}


Mesh3D :: struct {
    mesh_type: MeshType,

    width:  f32,
    height: f32,
    length: f32,

    model: rl.Model,
}


init_mesh_models :: proc(
    meshes: []^Mesh3D,
    materials: []^MeshMaterial3d,
) {
    for i in 0..<len(meshes) {
        switch meshes[i].mesh_type {
        case .Cube:
            meshes[i].model = rl.LoadModelFromMesh(
                rl.GenMeshCube(
                    meshes[i].width,
                    meshes[i].height,
                    meshes[i].length,
                ),
            )

        case .Plane:
            meshes[i].model = rl.LoadModelFromMesh(
                rl.GenMeshPlane(
                    meshes[i].width,
                    meshes[i].length,
                    1,
                    1,
                ),
            )
        }

        meshes[i].model.materials[0].shader =
            materials[i].shader
        meshes[i].model.materials[0].maps[rl.MaterialMapIndex.ALBEDO].color = materials[i].color
    }
}


// Find a way to implment shutdown functions
destroy_mesh_models :: proc(
    meshes: []^Mesh3D,
) {
    for i in 0..<len(meshes) {
        rl.UnloadModel(meshes[i].model)
    }
}


draw_mesh_models :: proc(
    meshes: []^Mesh3D,
    transforms: []^Transform,
) {
    for i in 0..<len(meshes) {
        rl.DrawModel(
            meshes[i].model,
            transforms[i].translation,
            1.0,
            rl.WHITE
        )
    }

}


default_cube :: proc() -> Mesh3D {
    return Mesh3D{
        mesh_type   = .Cube,
        width  = 2.0,
        height = 2.0,
        length = 2.0,
    }
}


default_plane :: proc(
    width: f32 = 20.0,
    length: f32 = 20.0,
) -> Mesh3D {
    return Mesh3D{
        mesh_type   = .Plane,
        width  = width,
        length = length,
    }
}