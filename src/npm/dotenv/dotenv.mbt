///| npm dotenv package FFI bindings
/// https://github.com/motdotla/dotenv
/// https://www.npmjs.com/package/dotenv

///|
extern "js" fn dotenv() -> @nostd.Any =
  #| () => require("dotenv")

///|
/// DotenvConfigOutput - result of config()
pub struct DotenvConfigOutput {
  parsed : @nostd.Any?
  error : @nostd.Any?
}

///|
/// DotenvParseOutput - parsed env object
#external
pub type DotenvParseOutput

///|
pub extern "js" fn DotenvParseOutput::as_any(
  self : DotenvParseOutput,
) -> @nostd.Any =
  #| (x) => x

///|
/// Load .env file and populate process.env
/// Returns parsed object or error
pub fn config(
  path? : String,
  encoding? : String,
  debug? : Bool,
  override_existing? : Bool,
  quiet? : Bool,
) -> DotenvConfigOutput {
  let opts = @nostd.Object::new()
  match path {
    Some(v) => opts["path"] = @nostd.any(v)
    None => ()
  }
  match encoding {
    Some(v) => opts["encoding"] = @nostd.any(v)
    None => ()
  }
  match debug {
    Some(v) => opts["debug"] = @nostd.any(v)
    None => ()
  }
  match override_existing {
    Some(v) => opts["override"] = @nostd.any(v)
    None => ()
  }
  match quiet {
    Some(v) => opts["quiet"] = @nostd.any(v)
    None => ()
  }
  let result = dotenv()._call("config", [opts])
  let parsed_raw = result["parsed"]
  let error_raw = result["error"]
  let parsed : @nostd.Any? = if @nostd.is_undefined(parsed_raw) {
    None
  } else {
    Some(parsed_raw)
  }
  let error : @nostd.Any? = if @nostd.is_undefined(error_raw) {
    None
  } else {
    Some(error_raw)
  }
  { parsed, error }
}

///|
/// Load .env file with multiple paths
#alias(config_paths)
pub fn configPaths(paths : Array[String]) -> DotenvConfigOutput {
  let opts = @nostd.Object::new()
  opts["path"] = @nostd.any(paths)
  let result = dotenv()._call("config", [opts])
  let parsed_raw = result["parsed"]
  let error_raw = result["error"]
  let parsed : @nostd.Any? = if @nostd.is_undefined(parsed_raw) {
    None
  } else {
    Some(parsed_raw)
  }
  let error : @nostd.Any? = if @nostd.is_undefined(error_raw) {
    None
  } else {
    Some(error_raw)
  }
  { parsed, error }
}

///|
/// Parse a dotenv string or Buffer
pub fn parse(src : String) -> DotenvParseOutput {
  dotenv()._call("parse", [@nostd.any(src)]).cast()
}

///|
/// Parse with options
#alias(parse_with_options)
pub fn parseWithOptions(src : String, debug? : Bool) -> DotenvParseOutput {
  let opts = @nostd.Object::new()
  match debug {
    Some(v) => opts["debug"] = @nostd.any(v)
    None => ()
  }
  dotenv()._call("parse", [@nostd.any(src), opts]).cast()
}

///|
/// Populate target object with source env vars
pub fn populate(
  target : @nostd.Any,
  source : @nostd.Any,
  override_existing? : Bool,
) -> Unit {
  let opts = @nostd.Object::new()
  match override_existing {
    Some(v) => opts["override"] = @nostd.any(v)
    None => ()
  }
  dotenv()._call("populate", [target, source, opts]) |> ignore
}

///| DotenvParseOutput methods

///|
/// Get a value from parsed output
pub fn DotenvParseOutput::get_(
  self : DotenvParseOutput,
  key : String,
) -> String? {
  let v = self.as_any()[key]
  if @nostd.is_undefined(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
extern "js" fn ffi_object_keys(obj : @nostd.Any) -> Array[String] =
  #| (obj) => Object.keys(obj)

///|
/// Get all keys
pub fn DotenvParseOutput::keys(self : DotenvParseOutput) -> Array[String] {
  ffi_object_keys(self.as_any())
}

///| Helpers for process.env access

///|
extern "js" fn ffi_process_env() -> @nostd.Any =
  #| () => process.env

///|
/// Get process.env object
#alias(process_env)
pub fn processEnv() -> @nostd.Any {
  ffi_process_env()
}

///|
/// Get an environment variable
#alias(get_env)
pub fn getEnv(key : String) -> String? {
  let env = ffi_process_env()
  let v = env[key]
  if @nostd.is_undefined(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Set an environment variable
#alias(set_env)
pub fn setEnv(key : String, value : String) -> Unit {
  let env = ffi_process_env()
  env[key] = @nostd.any(value)
}

///|
extern "js" fn ffi_delete(obj : @nostd.Any, key : String) -> Unit =
  #| (obj, key) => delete obj[key]

///|
/// Delete an environment variable
#alias(delete_env)
pub fn deleteEnv(key : String) -> Unit {
  let env = ffi_process_env()
  ffi_delete(env, key)
}
