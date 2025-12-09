///| pino bindings
/// Bindings for https://getpino.io/

// ============================================================
// Module Handle
// ============================================================

///|
/// Dynamic import for pino module
extern "js" fn import_pino() -> @core.Promise[@core.Any] =
  #|() => import("pino")

///|
extern "js" fn get_pino_global() -> @core.Any =
  #|() => globalThis.__pino

///|
extern "js" fn set_pino_global(pino : @core.Any) -> Unit =
  #|(pino) => { globalThis.__pino = pino; }

///|
/// Initialize pino globals asynchronously (recommended for ESM)
pub async fn init_global() -> Unit {
  if @core.is_nullish(get_pino_global()) {
    let mod = import_pino().wait()
    set_pino_global(mod._get("default"))
  }
}

///|
/// Initialize pino globals synchronously (for testing with require)
pub fn init_pino(pino_module : @core.Any) -> Unit {
  set_pino_global(pino_module)
}

///|
/// Get the pino module
fn pino_module() -> @core.Any {
  get_pino_global()
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
pub extern "js" fn Logger::as_any(self : Logger) -> @core.Any =
  #| (x) => x

///|
extern "js" fn ffi_pino_call(pino : @core.Any, opts : @core.Any) -> Logger =
  #|(pino, opts) => pino(opts)

///|
extern "js" fn ffi_pino_default(pino : @core.Any) -> Logger =
  #|(pino) => pino()

///|
/// Create a pino logger with options
pub fn pino(
  level? : Level = Info,
  name? : String = "",
  timestamp? : Bool = true,
) -> Logger {
  let mod = pino_module()
  let opts = @core.new_object()
  opts["level"] = @core.any(level.to_string())
  if name != "" {
    opts["name"] = @core.any(name)
  }
  opts["timestamp"] = @core.any(timestamp)
  ffi_pino_call(mod, opts)
}

///|
/// Create a pino logger with default options
pub fn pino_default() -> Logger {
  ffi_pino_default(pino_module())
}

// ============================================================
// Logging methods
// ============================================================

///|
/// Log at trace level
pub fn Logger::trace(self : Logger, msg : String) -> Unit {
  self.as_any()._call("trace", [@core.any(msg)]) |> ignore
}

///|
/// Log at trace level with object
pub fn Logger::trace_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("trace", [obj, @core.any(msg)]) |> ignore
}

///|
/// Log at debug level
pub fn Logger::debug(self : Logger, msg : String) -> Unit {
  self.as_any()._call("debug", [@core.any(msg)]) |> ignore
}

///|
/// Log at debug level with object
pub fn Logger::debug_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("debug", [obj, @core.any(msg)]) |> ignore
}

///|
/// Log at info level
pub fn Logger::info(self : Logger, msg : String) -> Unit {
  self.as_any()._call("info", [@core.any(msg)]) |> ignore
}

///|
/// Log at info level with object
pub fn Logger::info_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("info", [obj, @core.any(msg)]) |> ignore
}

///|
/// Log at warn level
pub fn Logger::warn(self : Logger, msg : String) -> Unit {
  self.as_any()._call("warn", [@core.any(msg)]) |> ignore
}

///|
/// Log at warn level with object
pub fn Logger::warn_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("warn", [obj, @core.any(msg)]) |> ignore
}

///|
/// Log at error level
pub fn Logger::error(self : Logger, msg : String) -> Unit {
  self.as_any()._call("error", [@core.any(msg)]) |> ignore
}

///|
/// Log at error level with object
pub fn Logger::error_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("error", [obj, @core.any(msg)]) |> ignore
}

///|
/// Log at fatal level
pub fn Logger::fatal(self : Logger, msg : String) -> Unit {
  self.as_any()._call("fatal", [@core.any(msg)]) |> ignore
}

///|
/// Log at fatal level with object
pub fn Logger::fatal_obj(self : Logger, obj : @core.Any, msg : String) -> Unit {
  self.as_any()._call("fatal", [obj, @core.any(msg)]) |> ignore
}

// ============================================================
// Child loggers
// ============================================================

///|
/// Create a child logger with additional bindings
pub fn Logger::child(self : Logger, bindings : @core.Any) -> Logger {
  self.as_any()._call("child", [bindings]).cast()
}

// ============================================================
// Logger properties
// ============================================================

///|
/// Get the current log level
pub fn Logger::level(self : Logger) -> String {
  self.as_any()["level"].cast()
}

///|
/// Set the log level
pub fn Logger::set_level(self : Logger, level : Level) -> Unit {
  self.as_any()["level"] = @core.any(level.to_string())
}

///|
/// Check if a level is enabled
pub fn Logger::is_level_enabled(self : Logger, level : Level) -> Bool {
  self.as_any()._call("isLevelEnabled", [@core.any(level.to_string())]).cast()
}

///|
/// Flush the logger
pub fn Logger::flush(self : Logger) -> Unit {
  self.as_any()._call("flush", []) |> ignore
}
