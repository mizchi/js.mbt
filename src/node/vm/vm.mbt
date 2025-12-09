///| node:vm module bindings
/// https://nodejs.org/api/vm.html

// Simple functions with #module

///|
/// Check if object is a context
#module("node:vm")
pub extern "js" fn isContext(object : @core.Any) -> Bool = "isContext"

// Functions with optional args need inline require()

///|
extern "js" fn vm_module() -> @core.Any =
  #| () => require("node:vm")

///|
/// TODO: Add vm.Module support
/// vm.Module (SourceTextModule, SyntheticModule) is currently marked as unstable in Node.js.
/// These APIs will be added once they are stabilized.
/// See: https://nodejs.org/api/vm.html#class-vmmodule

///| Script class

///|
#external
pub type Script

///|
pub fn Script::as_any(self : Script) -> @core.Any = "%identity"

///|
/// Create a new Script object
pub fn Script::new(
  code : String,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  cachedData? : @buffer.Buffer,
  produceCachedData? : Bool,
) -> Script {
  let vm = vm_module()
  let script_constructor = vm._get("Script")
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if cachedData is Some(v) {
    entries.push(("cachedData", @core.any(v)))
  }
  if produceCachedData is Some(v) {
    entries.push(("produceCachedData", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  @core.new(script_constructor, [@core.any(code), @core.identity(options)])
  |> @core.identity
}

///|
/// Run script in current context
pub fn Script::runInThisContext(
  self : Script,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  self.as_any()._call("runInThisContext", [options]).cast()
}

///|
/// Run script in new context
pub fn Script::runInNewContext(
  self : Script,
  contextObject? : @core.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
  contextName? : String,
  contextOrigin? : String,
  microtaskMode? : String,
) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  if contextName is Some(v) {
    entries.push(("contextName", @core.any(v)))
  }
  if contextOrigin is Some(v) {
    entries.push(("contextOrigin", @core.any(v)))
  }
  if microtaskMode is Some(v) {
    entries.push(("microtaskMode", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match contextObject {
    Some(ctx) =>
      self.as_any()._call("runInNewContext", [@core.any(ctx), options]).cast()
    None => self.as_any()._call("runInNewContext", [options]).cast()
  }
}

///|
/// Run script in context
pub fn Script::runInContext(
  self : Script,
  contextifiedObject : @core.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  self
  .as_any()
  ._call("runInContext", [@core.any(contextifiedObject), options])
  .cast()
}

///|
/// Create cached data
pub fn Script::createCachedData(self : Script) -> @buffer.Buffer {
  self.as_any()._call("createCachedData", []).cast()
}

///|
/// Get cachedDataRejected property
pub fn Script::cachedDataRejected(self : Script) -> Bool? {
  self.as_any()["cachedDataRejected"] |> @core.identity_option
}

///|
/// Get sourceMapURL property
pub fn Script::sourceMapURL(self : Script) -> String? {
  self.as_any()["sourceMapURL"] |> @core.identity_option
}

///| Module functions

///|
/// Compile and run code in current context
pub fn runInThisContext(
  code : String,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @core.Any {
  let vm = vm_module()
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  @core.any(vm)._call("runInThisContext", [@core.any(code), options]).cast()
}

///|
/// Compile and run code in new context
pub fn runInNewContext(
  code : String,
  contextObject? : @core.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
  contextName? : String,
  contextOrigin? : String,
  microtaskMode? : String,
) -> @core.Any {
  let vm = vm_module()
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  if contextName is Some(v) {
    entries.push(("contextName", @core.any(v)))
  }
  if contextOrigin is Some(v) {
    entries.push(("contextOrigin", @core.any(v)))
  }
  if microtaskMode is Some(v) {
    entries.push(("microtaskMode", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match contextObject {
    Some(ctx) =>
      @core.any(vm)
      ._call("runInNewContext", [@core.any(code), @core.any(ctx), options])
      .cast()
    None =>
      @core.any(vm)._call("runInNewContext", [@core.any(code), options]).cast()
  }
}

///|
/// Run code in context
pub fn runInContext(
  code : String,
  contextifiedObject : @core.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @core.Any {
  let vm = vm_module()
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if displayErrors is Some(v) {
    entries.push(("displayErrors", @core.any(v)))
  }
  if timeout is Some(v) {
    entries.push(("timeout", @core.any(v)))
  }
  if breakOnSigint is Some(v) {
    entries.push(("breakOnSigint", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  @core.any(vm)
  ._call("runInContext", [
    @core.any(code),
    @core.any(contextifiedObject),
    options,
  ])
  .cast()
}

///|
/// Create a new context
pub fn createContext(
  contextObject? : @core.Any,
  name? : String,
  origin? : String,
  microtaskMode? : String,
) -> @core.Any {
  let vm = vm_module()
  let entries : Array[(String, @core.Any)] = []
  if name is Some(v) {
    entries.push(("name", @core.any(v)))
  }
  if origin is Some(v) {
    entries.push(("origin", @core.any(v)))
  }
  if microtaskMode is Some(v) {
    entries.push(("microtaskMode", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match contextObject {
    Some(ctx) =>
      @core.any(vm)._call("createContext", [@core.any(ctx), options]).cast()
    None => @core.any(vm)._call("createContext", [options]).cast()
  }
}

///|
/// Compile a function
pub fn compileFunction(
  code : String,
  params? : Array[String],
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  cachedData? : @buffer.Buffer,
  produceCachedData? : Bool,
  parsingContext? : @core.Any,
  contextExtensions? : Array[@core.Any],
) -> @core.Any {
  let vm = vm_module()
  let entries : Array[(String, @core.Any)] = []
  if filename is Some(v) {
    entries.push(("filename", @core.any(v)))
  }
  if lineOffset is Some(v) {
    entries.push(("lineOffset", @core.any(v)))
  }
  if columnOffset is Some(v) {
    entries.push(("columnOffset", @core.any(v)))
  }
  if cachedData is Some(v) {
    entries.push(("cachedData", @core.any(v)))
  }
  if produceCachedData is Some(v) {
    entries.push(("produceCachedData", @core.any(v)))
  }
  if parsingContext is Some(v) {
    entries.push(("parsingContext", @core.any(v)))
  }
  if contextExtensions is Some(v) {
    entries.push(("contextExtensions", @core.any(v)))
  }
  let options = @core.from_entries(entries)
  match params {
    Some(p) => {
      let params_js = @core.any(p.map(fn(s) { s }))
      @core.any(vm)
      ._call("compileFunction", [@core.any(code), @core.any(params_js), options])
      .cast()
    }
    None =>
      @core.any(vm)._call("compileFunction", [@core.any(code), options]).cast()
  }
}
