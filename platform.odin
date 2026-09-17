package engine

Platform :: struct {
    get_delta_time:     proc() -> f32,
    window_should_close: proc() -> bool,
}