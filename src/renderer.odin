package engine

Renderer :: struct {
    camera: Camera3D
}

Camera3D :: struct {
    position: [3]f32,
    target: [3]f32,
    up: [3]f32,
    fovy: f32,
    projection: CameraProjection,
}

CameraProjection :: enum {
	PERSPECTIVE = 0,                  // Perspective projection
	ORTHOGRAPHIC,                     // Orthographic projection
}