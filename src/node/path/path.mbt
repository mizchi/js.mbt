///|
using @js {type Val, js, trait Js}

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
  ffi_apply_variadic(join_fn, path_module, paths_js).cast()
}

///|
pub fn dirname(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("dirname", [path]).cast()
}

///|
pub fn basename(path : String, suffix? : String) -> String {
  let path_module = @node.require("node:path")
  match suffix {
    Some(s) => path_module.invoke("basename", [path, s]).cast()
    None => path_module.invoke("basename", [path]).cast()
  }
}

///|
pub fn extname(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("extname", [path]).cast()
}

///|
#alias(is_absolute)
pub fn isAbsolute(path : String) -> Bool {
  let path_module = @node.require("node:path")
  path_module.invoke("isAbsolute", [path]).cast()
}

///|
pub fn normalize(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("normalize", [path]).cast()
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
  ffi_apply_variadic(resolve_fn, path_module, paths_js).cast()
}

///|
pub fn relative(from : String, to : String) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("relative", [from, to]).cast()
}

///|
pub fn parse(path : String) -> ParsedPath {
  let path_module = @node.require("node:path")
  path_module.invoke("parse", [path]).cast()
}

///|
pub fn format(path_obj : ParsedPath) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("format", [path_obj]).cast()
}

///|
#external
pub type ParsedPath

///|
pub impl Js for ParsedPath with to_js(self) -> Val {
  self |> js
}

///|
pub fn ParsedPath::root(self : Self) -> String {
  self.to_js().get("root").cast()
}

///|
pub fn ParsedPath::dir(self : Self) -> String {
  self.to_js().get("dir").cast()
}

///|
pub fn ParsedPath::base(self : Self) -> String {
  self.to_js().get("base").cast()
}

///|
pub fn ParsedPath::ext(self : Self) -> String {
  self.to_js().get("ext").cast()
}

///|
pub fn ParsedPath::name(self : Self) -> String {
  self.to_js().get("name").cast()
}

///|
pub fn ParsedPath::new(
  root? : String = "",
  dir? : String = "",
  base? : String = "",
  ext? : String = "",
  name? : String = "",
) -> ParsedPath {
  let obj = @js.new_empty_object()
  obj.set("root", root)
  obj.set("dir", dir)
  obj.set("base", base)
  obj.set("ext", ext)
  obj.set("name", name)
  obj.cast()
}

///|
pub fn delimiter() -> String {
  let path_module = @node.require("node:path")
  path_module.get("delimiter").cast()
}

///|
pub fn sep() -> String {
  let path_module = @node.require("node:path")
  path_module.get("sep").cast()
}

///|
#alias(to_namespaced_path)
pub fn toNamespacedPath(path : String) -> String {
  let path_module = @node.require("node:path")
  path_module.invoke("toNamespacedPath", [path]).cast()
}

///|
#alias(matches_glob)
pub fn matchesGlob(path : String, pattern : String) -> Bool {
  let path_module = @node.require("node:path")
  path_module.invoke("matchesGlob", [path, pattern]).cast()
}
