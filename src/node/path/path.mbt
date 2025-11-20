///|
/// path.join(...paths)
pub fn join(paths : Array[String]) -> String {
  let path_module = @node.require("node:path")
  path_module.call("join", paths.map(p => p)) |> unsafe_cast
}

///|
/// Join two path segments
/// JS: path.join(a, b)
pub fn join2(a : String, b : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call2("join", a, b) |> unsafe_cast
}

///|
/// JS: path.dirname(path)
pub fn dirname(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.call("dirname", [path]))
}

///|
/// JS: path.basename(path, suffix)
pub fn basename(path : String, suffix? : String) -> String {
  let path_module = @node.require("node:path")
  match suffix {
    Some(s) => path_module.call2("basename", path, s) |> unsafe_cast
    None => unsafe_cast(path_module.call("basename", [path]))
  }
}

///|
/// JS: path.extname(path)
pub fn extname(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call("extname", [path]) |> unsafe_cast
}

///|
/// JS: path.isAbsolute(path)
#alias(is_absolute)
pub fn isAbsolute(path : String) -> Bool {
  let path_module = @node.require("node:path")
  path_module.call("isAbsolute", [path]) |> unsafe_cast
}

///|
/// JS: path.normalize(path)
pub fn normalize(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.call("normalize", [path]))
}

///|
/// JS: path.resolve(...paths)
pub fn resolve(paths : Array[String]) -> String {
  let path_module = @node.require("node:path")
  path_module.call("resolve", paths.map(p => @js.js(p))) |> unsafe_cast
}

///|
/// JS: path.relative(from, to)
pub fn relative(from : String, to : String) -> String {
  let path_module = @node.require("node:path")
  path_module.call2("relative", from, to) |> unsafe_cast
}

///|
/// JS: path.parse(path)
pub fn parse(path : String) -> ParsedPath {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.call("parse", [path]))
}

///|
/// JS: path.format(parsed)
pub fn format(parsed : ParsedPath) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.call("format", [parsed.to_js()]))
}

///|
// #external
pub(all) struct ParsedPath {
  root : String
  dir : String
  base : String
  ext : String
  name : String
}

///|
pub impl JsImpl for ParsedPath

///|
pub fn delimiter() -> String {
  let path_module = @node.require("node:path")
  path_module.get("delimiter") |> unsafe_cast
}

///|
pub fn sep() -> String {
  let path_module = @node.require("node:path")
  path_module.get("sep") |> unsafe_cast
}

///|
#alias(to_namespaced_path)
pub fn toNamespacedPath(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.call("toNamespacedPath", [path]))
}

///|
#alias(matches_glob)
pub fn matchesGlob(path : String, pattern : String) -> Bool {
  let path_module = @node.require("node:path")
  path_module.call2("matchesGlob", path, pattern) |> unsafe_cast
}
