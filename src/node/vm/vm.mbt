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
/// Note: Keep JsImpl for backward compatibility with code expecting &JsImpl
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "cachedData": cachedData.map(fn(x) { @nostd.any(x) }),
    "produceCachedData": produceCachedData.map(fn(x) { @nostd.any(x) }),
  })
  @js.new_(script_constructor, [@js.any(code), @js.identity(options)])
  |> @js.identity
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
  })
  @nostd.any(self)._call("runInThisContext", [options]).cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
    "contextName": contextName.map(fn(x) { @nostd.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @nostd.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @nostd.any(x) }),
  })
  match contextObject {
    Some(ctx) =>
      @nostd.any(self)
      ._call("runInNewContext", [@nostd.any(ctx), options])
      .cast()
    None => @nostd.any(self)._call("runInNewContext", [options]).cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
  })
  @nostd.any(self)
  ._call("runInContext", [@nostd.any(contextifiedObject), options])
  .cast()
}

///|
/// Create cached data
pub fn Script::createCachedData(self : Script) -> @buffer.Buffer {
  @nostd.any(self)._call("createCachedData", []).cast()
}

///|
/// Get cachedDataRejected property
pub fn Script::cachedDataRejected(self : Script) -> Bool? {
  @nostd.any(self)["cachedDataRejected"] |> @nostd.identity_option
}

///|
/// Get sourceMapURL property
pub fn Script::sourceMapURL(self : Script) -> String? {
  @nostd.any(self)["sourceMapURL"] |> @nostd.identity_option
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
  })
  @nostd.any(vm)._call("runInThisContext", [@nostd.any(code), options]).cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
    "contextName": contextName.map(fn(x) { @nostd.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @nostd.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @nostd.any(x) }),
  })
  match contextObject {
    Some(ctx) =>
      @nostd.any(vm)
      ._call("runInNewContext", [@nostd.any(code), @nostd.any(ctx), options])
      .cast()
    None =>
      @nostd.any(vm)
      ._call("runInNewContext", [@nostd.any(code), options])
      .cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @nostd.any(x) }),
    "timeout": timeout.map(fn(x) { @nostd.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @nostd.any(x) }),
  })
  @nostd.any(vm)
  ._call("runInContext", [
    @nostd.any(code),
    @nostd.any(contextifiedObject),
    options,
  ])
  .cast()
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
  let options = @mbtconv.from_option_map({
    "name": name.map(fn(x) { @nostd.any(x) }),
    "origin": origin.map(fn(x) { @nostd.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @nostd.any(x) }),
  })
  match contextObject {
    Some(ctx) =>
      @nostd.any(vm)._call("createContext", [@nostd.any(ctx), options]).cast()
    None => @nostd.any(vm)._call("createContext", [options]).cast()
  }
}

///|
/// Check if object is a context
pub fn isContext(object : @js.Any) -> Bool {
  let vm = vm_module()
  @nostd.any(vm)._call("isContext", [@nostd.any(object)]).cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @nostd.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @nostd.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @nostd.any(x) }),
    "cachedData": cachedData.map(fn(x) { @nostd.any(x) }),
    "produceCachedData": produceCachedData.map(fn(x) { @nostd.any(x) }),
    "parsingContext": parsingContext.map(fn(x) { @nostd.any(x) }),
    "contextExtensions": contextExtensions.map(fn(x) { @nostd.any(x) }),
  })
  match params {
    Some(p) => {
      let params_js = @js.from_array(p.map(fn(s) { s }))
      @nostd.any(vm)
      ._call("compileFunction", [
        @nostd.any(code),
        @nostd.any(params_js),
        options,
      ])
      .cast()
    }
    None =>
      @nostd.any(vm)
      ._call("compileFunction", [@nostd.any(code), options])
      .cast()
  }
}
