///|
extern "js" fn path_module() -> @core.Any =
  #| () => require("node:path")

///|
/// path.join(...paths)
pub fn join(paths : Array[String]) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  path_module._call("join", paths.map(fn(p) { @core.any(p) })).cast()
}

///|
/// Join two path segments
/// JS: path.join(a, b)
pub extern "js" fn join2(a : String, b : String) -> String =
  #|(a, b) => require("node:path").join(a, b)

///|
/// JS: path.dirname(path)
pub extern "js" fn dirname(path : String) -> String =
  #|(path) => require("node:path").dirname(path)

///|
/// JS: path.basename(path, suffix)
pub fn basename(path : String, suffix? : String) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  match suffix {
    Some(s) =>
      path_module._call("basename", [@core.any(path), @core.any(s)]).cast()
    None => path_module._call("basename", [@core.any(path)]).cast()
  }
}

///|
/// JS: path.extname(path)
pub extern "js" fn extname(path : String) -> String =
  #|(path) => require("node:path").extname(path)

///|
/// JS: path.isAbsolute(path)
#alias(is_absolute)
pub extern "js" fn isAbsolute(path : String) -> Bool =
  #|(path) => require("node:path").isAbsolute(path)

///|
/// JS: path.normalize(path)
pub extern "js" fn normalize(path : String) -> String =
  #|(path) => require("node:path").normalize(path)

///|
/// JS: path.resolve(...paths)
pub fn resolve(paths : Array[String]) -> String {
  let path_module : @core.Any = path_module() |> @core.any
  path_module._call("resolve", paths.map(fn(p) { @core.any(p) })).cast()
}

///|
/// JS: path.relative(from, to)
pub extern "js" fn relative(from : String, to : String) -> String =
  #|(from, to) => require("node:path").relative(from, to)

///|
/// JS: path.parse(path)
pub extern "js" fn parse(path : String) -> ParsedPath =
  #|(path) => require("node:path").parse(path)

///|
/// JS: path.format(parsed)
pub extern "js" fn format(parsed : ParsedPath) -> String =
  #|(parsed) => require("node:path").format(parsed)

///|
pub(all) struct ParsedPath {
  root : String
  dir : String
  base : String
  ext : String
  name : String
}

///|
pub fn ParsedPath::to_any(self : ParsedPath) -> @core.Any = "%identity"

///|
pub extern "js" fn delimiter() -> String =
  #|() => require("node:path").delimiter

///|
pub extern "js" fn sep() -> String =
  #|() => require("node:path").sep

///|
#alias(to_namespaced_path)
pub extern "js" fn toNamespacedPath(path : String) -> String =
  #|(path) => require("node:path").toNamespacedPath(path)

///|
#alias(matches_glob)
pub extern "js" fn matchesGlob(path : String, pattern : String) -> Bool =
  #|(path, pattern) => require("node:path").matchesGlob(path, pattern)
