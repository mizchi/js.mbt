///|
extern "js" fn ffi_apply_variadic(
  fn_val : Val,
  this_val : Val,
  args : Val,
) -> Val =
  #|(fn, thisArg, args) => fn.apply(thisArg, args)

///|
pub fn join(paths : Array[String]) -> String {
  let path_module = @node.require("node:path")
  let join_fn = path_module.get("join")
  let paths_js = @js.new_empty_array()
  let mut i = 0
  while i < paths.length() {
    paths_js.invoke("push", [paths[i]]) |> ignore
    i = i + 1
  }
  unsafe_cast(ffi_apply_variadic(join_fn, path_module, paths_js))
}

///|
pub fn dirname(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("dirname", [path]))
}

///|
pub fn basename(path : String, suffix? : String) -> String {
  let path_module = @node.require("node:path")
  match suffix {
    Some(s) => unsafe_cast(path_module.invoke("basename", [path, s]))
    None => unsafe_cast(path_module.invoke("basename", [path]))
  }
}

///|
pub fn extname(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("extname", [path]))
}

///|
#alias(is_absolute)
pub fn isAbsolute(path : String) -> Bool {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("isAbsolute", [path]))
}

///|
pub fn normalize(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("normalize", [path]))
}

///|
pub fn resolve(paths : Array[String]) -> String {
  let path_module = @node.require("node:path")
  let resolve_fn = path_module.get("resolve")
  let paths_js = @js.new_empty_array()
  let mut i = 0
  while i < paths.length() {
    paths_js.invoke("push", [paths[i]]) |> ignore
    i = i + 1
  }
  unsafe_cast(ffi_apply_variadic(resolve_fn, path_module, paths_js))
}

///|
pub fn relative(from : String, to : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("relative", [from, to]))
}

///|
pub fn parse(path : String) -> ParsedPath {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("parse", [path]))
}

///|
pub fn format(path_obj : ParsedPath) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("format", [path_obj]))
}

///|
#external
pub type ParsedPath

///|
pub impl Js for ParsedPath

///|
pub fn ParsedPath::root(self : Self) -> String {
  unsafe_cast(self.get("root"))
}

///|
pub fn ParsedPath::dir(self : Self) -> String {
  unsafe_cast(self.get("dir"))
}

///|
pub fn ParsedPath::base(self : Self) -> String {
  unsafe_cast(self.get("base"))
}

///|
pub fn ParsedPath::ext(self : Self) -> String {
  unsafe_cast(self.get("ext"))
}

///|
pub fn ParsedPath::name(self : Self) -> String {
  unsafe_cast(self.get("name"))
}

///|
pub fn ParsedPath::new(
  root? : String = "",
  dir? : String = "",
  base? : String = "",
  ext? : String = "",
  name? : String = "",
) -> ParsedPath {
  let obj = @js.Object::new()
  obj.set("root", root)
  obj.set("dir", dir)
  obj.set("base", base)
  obj.set("ext", ext)
  obj.set("name", name)
  unsafe_cast(obj)
}

///|
pub fn delimiter() -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.get("delimiter"))
}

///|
pub fn sep() -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.get("sep"))
}

///|
#alias(to_namespaced_path)
pub fn toNamespacedPath(path : String) -> String {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("toNamespacedPath", [path]))
}

///|
#alias(matches_glob)
pub fn matchesGlob(path : String, pattern : String) -> Bool {
  let path_module = @node.require("node:path")
  unsafe_cast(path_module.invoke("matchesGlob", [path, pattern]))
}
