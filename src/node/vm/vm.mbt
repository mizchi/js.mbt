///|
/// node:vm module
extern "js" fn vm_module() -> @js.Any =
  #| () => require("node:vm")

///|
/// TODO: Add vm.Module support
/// vm.Module (SourceTextModule, SyntheticModule) is currently marked as unstable in Node.js.
/// These APIs will be added once they are stabilized.
/// See: https://nodejs.org/api/vm.html#class-vmmodule

///| Script clasqs

///|
#external
pub type Script

///|
pub impl @js.JsImpl for Script

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
  let script_constructor = vm.get("Script")
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "cachedData": cachedData.map(fn(x) { x.to_any() }),
    "produceCachedData": produceCachedData.map(fn(x) { @js.any(x) }),
  })
  @js.new_(script_constructor, [code, options]) |> @js.identity
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
) -> @js.Any {
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
  })
  self.call1("runInThisContext", options)
}

///|
/// Run script in new context
pub fn Script::runInNewContext(
  self : Script,
  contextObject? : @js.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
  contextName? : String,
  contextOrigin? : String,
  microtaskMode? : String,
) -> @js.Any {
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
    "contextName": contextName.map(fn(x) { @js.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @js.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @js.any(x) }),
  })
  match contextObject {
    Some(ctx) => self.call2("runInNewContext", ctx, options)
    None => self.call1("runInNewContext", options)
  }
}

///|
/// Run script in context
pub fn Script::runInContext(
  self : Script,
  contextifiedObject : @js.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @js.Any {
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
  })
  self.call2("runInContext", contextifiedObject, options)
}

///|
/// Create cached data
pub fn Script::createCachedData(self : Script) -> @buffer.Buffer {
  self.call0("createCachedData") |> @js.identity
}

///|
/// Get cachedDataRejected property
pub fn Script::cachedDataRejected(self : Script) -> Bool? {
  self.get("cachedDataRejected") |> @js.identity_option
}

///|
/// Get sourceMapURL property
pub fn Script::sourceMapURL(self : Script) -> String? {
  self.get("sourceMapURL") |> @js.identity_option
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
) -> @js.Any {
  let vm = vm_module()
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
  })
  vm.call2("runInThisContext", code, options)
}

///|
/// Compile and run code in new context
pub fn runInNewContext(
  code : String,
  contextObject? : @js.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
  contextName? : String,
  contextOrigin? : String,
  microtaskMode? : String,
) -> @js.Any {
  let vm = vm_module()
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
    "contextName": contextName.map(fn(x) { @js.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @js.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @js.any(x) }),
  })
  match contextObject {
    Some(ctx) => vm.call("runInNewContext", [code, ctx, options])
    None => vm.call2("runInNewContext", code, options)
  }
}

///|
/// Run code in context
pub fn runInContext(
  code : String,
  contextifiedObject : @js.Any,
  filename? : String,
  lineOffset? : Int,
  columnOffset? : Int,
  displayErrors? : Bool,
  timeout? : Int,
  breakOnSigint? : Bool,
) -> @js.Any {
  let vm = vm_module()
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @js.any(x) }),
    "timeout": timeout.map(fn(x) { @js.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @js.any(x) }),
  })
  vm.call("runInContext", [code, contextifiedObject, options])
}

///|
/// Create a new context
pub fn createContext(
  contextObject? : @js.Any,
  name? : String,
  origin? : String,
  microtaskMode? : String,
) -> @js.Any {
  let vm = vm_module()
  let options = @js.from_option_map({
    "name": name.map(fn(x) { @js.any(x) }),
    "origin": origin.map(fn(x) { @js.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @js.any(x) }),
  })
  match contextObject {
    Some(ctx) => vm.call2("createContext", ctx, options)
    None => vm.call1("createContext", options)
  }
}

///|
/// Check if object is a context
pub fn isContext(object : @js.Any) -> Bool {
  let vm = vm_module()
  vm.call1("isContext", object) |> @js.identity
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
  parsingContext? : @js.Any,
  contextExtensions? : Array[@js.Any],
) -> @js.Any {
  let vm = vm_module()
  let options = @js.from_option_map({
    "filename": filename.map(fn(x) { @js.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @js.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @js.any(x) }),
    "cachedData": cachedData.map(fn(x) { x.to_any() }),
    "produceCachedData": produceCachedData.map(fn(x) { @js.any(x) }),
    "parsingContext": parsingContext,
    "contextExtensions": contextExtensions.map(fn(x) { @js.from_array(x) }),
  })
  match params {
    Some(p) => {
      let params_js = @js.from_array(p.map(fn(s) { s }))
      vm.call("compileFunction", [code, params_js, options])
    }
    None => vm.call2("compileFunction", code, options)
  }
}
