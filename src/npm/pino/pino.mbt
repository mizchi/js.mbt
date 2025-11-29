///| pino bindings
/// Bindings for https://getpino.io/

// ============================================================
// Module Handle
// ============================================================

///|
/// Pino module handle
#external
pub type Pino

///|
pub impl @js.JsImpl for Pino

///|
/// Get the pino module
pub fn pino_module() -> Pino {
  @node.require("pino").cast()
}

// ============================================================
// Level enum
// ============================================================

///|
/// Log level
pub(all) enum Level {
  Trace
  Debug
  Info
  Warn
  Error
  Fatal
  Silent
}

///|
pub fn Level::to_string(self : Level) -> String {
  match self {
    Trace => "trace"
    Debug => "debug"
    Info => "info"
    Warn => "warn"
    Error => "error"
    Fatal => "fatal"
    Silent => "silent"
  }
}

///|
pub fn Level::to_number(self : Level) -> Int {
  match self {
    Trace => 10
    Debug => 20
    Info => 30
    Warn => 40
    Error => 50
    Fatal => 60
    Silent => 100
  }
}

// ============================================================
// Logger
// ============================================================

///|
/// Pino logger instance
#external
pub type Logger

///|
pub impl @js.JsImpl for Logger

///|
/// Create a pino logger with options
pub fn pino(
  level? : Level = Info,
  name? : String = "",
  timestamp? : Bool = true,
) -> Logger {
  let mod = pino_module()
  let opts = @js.Object::new()
  opts["level"] = level.to_string()
  if name != "" {
    opts["name"] = name
  }
  opts["timestamp"] = timestamp
  mod.call1("default", opts).cast()
}

///|
/// Create a pino logger with default options
pub fn pino_default() -> Logger {
  let mod = pino_module()
  mod.call0("default").cast()
}

// ============================================================
// Logging methods
// ============================================================

///|
/// Log at trace level
pub fn Logger::trace(self : Logger, msg : String) -> Unit {
  self.call1("trace", msg) |> ignore
}

///|
/// Log at trace level with object
pub fn Logger::trace_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("trace", obj.to_any(), msg) |> ignore
}

///|
/// Log at debug level
pub fn Logger::debug(self : Logger, msg : String) -> Unit {
  self.call1("debug", msg) |> ignore
}

///|
/// Log at debug level with object
pub fn Logger::debug_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("debug", obj.to_any(), msg) |> ignore
}

///|
/// Log at info level
pub fn Logger::info(self : Logger, msg : String) -> Unit {
  self.call1("info", msg) |> ignore
}

///|
/// Log at info level with object
pub fn Logger::info_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("info", obj.to_any(), msg) |> ignore
}

///|
/// Log at warn level
pub fn Logger::warn(self : Logger, msg : String) -> Unit {
  self.call1("warn", msg) |> ignore
}

///|
/// Log at warn level with object
pub fn Logger::warn_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("warn", obj.to_any(), msg) |> ignore
}

///|
/// Log at error level
pub fn Logger::error(self : Logger, msg : String) -> Unit {
  self.call1("error", msg) |> ignore
}

///|
/// Log at error level with object
pub fn Logger::error_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("error", obj.to_any(), msg) |> ignore
}

///|
/// Log at fatal level
pub fn Logger::fatal(self : Logger, msg : String) -> Unit {
  self.call1("fatal", msg) |> ignore
}

///|
/// Log at fatal level with object
pub fn Logger::fatal_obj(self : Logger, obj : @js.Object, msg : String) -> Unit {
  self.call2("fatal", obj.to_any(), msg) |> ignore
}

// ============================================================
// Child loggers
// ============================================================

///|
/// Create a child logger with additional bindings
pub fn Logger::child(self : Logger, bindings : @js.Object) -> Logger {
  self.call1("child", bindings.to_any()).cast()
}

// ============================================================
// Logger properties
// ============================================================

///|
/// Get the current log level
pub fn Logger::level(self : Logger) -> String {
  @js.identity(self.get("level"))
}

///|
/// Set the log level
pub fn Logger::set_level(self : Logger, level : Level) -> Unit {
  self.set("level", level.to_string())
}

///|
/// Check if a level is enabled
pub fn Logger::is_level_enabled(self : Logger, level : Level) -> Bool {
  @js.identity(self.call1("isLevelEnabled", level.to_string()))
}

///|
/// Flush the logger
pub fn Logger::flush(self : Logger) -> Unit {
  self.call0("flush") |> ignore
}
