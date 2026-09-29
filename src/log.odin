package engine

import mn "../deps/muninn"

Log_Level :: enum i32 {
    TRACE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
}

log_init :: proc(level: Log_Level = .INFO, log_dir := "") {
    mn.init(
        level   = mn.Levels(level),
        log_dir = log_dir,
        save_file = true,
    )
}

log_title :: proc(name: string) {
    mn.title(name)
}

log_trace :: proc(msg: string, args: ..any) {
    mn.trace(msg, ..args)
}

log_debug :: proc(msg: string, args: ..any) {
    mn.debug(msg, ..args)
}

log_info :: proc(msg: string, args: ..any) {
    mn.info(msg, ..args)
}

log_warn :: proc(msg: string, args: ..any) {
    mn.warn(msg, ..args)
}

log_error :: proc(msg: string, args: ..any) {
    mn.error(msg, ..args)
}

log_sep :: proc(char: string) {
    mn.sep(char = char, color = mn.GRAY)
}