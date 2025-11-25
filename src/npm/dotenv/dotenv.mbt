///| npm dotenv package FFI bindings
/// https://github.com/motdotla/dotenv
/// https://www.npmjs.com/package/dotenv

///|
fn dotenv() -> @js.Any {
  @node.require("dotenv")
}

///|
/// DotenvConfigOutput - result of config()
pub struct DotenvConfigOutput {
  parsed : @js.Any?
  error : @js.Any?
}

///|
/// DotenvParseOutput - parsed env object
#external
pub type DotenvParseOutput

///|
pub impl @js.JsImpl for DotenvParseOutput

///|
/// Load .env file and populate process.env
/// Returns parsed object or error
pub fn config(
  path? : String,
  encoding? : String,
  debug? : Bool,
  override_existing? : Bool,
) -> DotenvConfigOutput {
  let opts = @js.Object::new()
  match path {
    Some(v) => opts.set("path", v)
    None => ()
  }
  match encoding {
    Some(v) => opts.set("encoding", v)
    None => ()
  }
  match debug {
    Some(v) => opts.set("debug", v)
    None => ()
  }
  match override_existing {
    Some(v) => opts.set("override", v)
    None => ()
  }
  let result = dotenv().call1("config", opts.to_any())
  let parsed_raw = result.get("parsed")
  let error_raw = result.get("error")
  let parsed : @js.Any? = if @js.is_undefined(parsed_raw) {
    None
  } else {
    Some(parsed_raw)
  }
  let error : @js.Any? = if @js.is_undefined(error_raw) {
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
  let opts = @js.Object::new()
  opts.set("path", @js.from_array(paths))
  let result = dotenv().call1("config", opts.to_any())
  let parsed_raw = result.get("parsed")
  let error_raw = result.get("error")
  let parsed : @js.Any? = if @js.is_undefined(parsed_raw) {
    None
  } else {
    Some(parsed_raw)
  }
  let error : @js.Any? = if @js.is_undefined(error_raw) {
    None
  } else {
    Some(error_raw)
  }
  { parsed, error }
}

///|
/// Parse a dotenv string or Buffer
pub fn parse(src : String) -> DotenvParseOutput {
  dotenv().call1("parse", src).cast()
}

///|
/// Parse with options
#alias(parse_with_options)
pub fn parseWithOptions(src : String, debug? : Bool) -> DotenvParseOutput {
  let opts = @js.Object::new()
  match debug {
    Some(v) => opts.set("debug", v)
    None => ()
  }
  dotenv().call2("parse", src, opts.to_any()).cast()
}

///|
/// Populate target object with source env vars
pub fn populate(
  target : @js.Any,
  source : @js.Any,
  override_existing? : Bool,
) -> Unit {
  let opts = @js.Object::new()
  match override_existing {
    Some(v) => opts.set("override", v)
    None => ()
  }
  dotenv().call("populate", [target, source, opts.to_any()]) |> ignore
}

///| DotenvParseOutput methods

///|
/// Get a value from parsed output
pub fn DotenvParseOutput::get_(
  self : DotenvParseOutput,
  key : String,
) -> String? {
  let v = self.get(key)
  if @js.is_undefined(v) {
    None
  } else {
    Some(v.cast())
  }
}

///|
/// Get all keys
pub fn DotenvParseOutput::keys(self : DotenvParseOutput) -> Array[String] {
  @js.Object::keys(self.to_any()) |> @js.identity
}

///| Helpers for process.env access

///|
extern "js" fn ffi_process_env() -> @js.Any =
  #| () => process.env

///|
/// Get process.env object
#alias(process_env)
pub fn processEnv() -> @js.Any {
  ffi_process_env()
}

///|
/// Get an environment variable
#alias(get_env)
pub fn getEnv(key : String) -> String? {
  let env = ffi_process_env()
  let v = env.get(key)
  if @js.is_undefined(v) {
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
  env.set(key, value)
}

///|
extern "js" fn ffi_delete(obj : @js.Any, key : String) -> Unit =
  #| (obj, key) => delete obj[key]

///|
/// Delete an environment variable
#alias(delete_env)
pub fn deleteEnv(key : String) -> Unit {
  let env = ffi_process_env()
  ffi_delete(env, key)
}
