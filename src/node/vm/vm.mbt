///|
/// node:vm module
extern "js" fn vm_module() -> @core.Any =
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
pub fn Script::as_any(self : Script) -> @core.Any = "%identity"

///|
/// Note: Keep JsImpl for backward compatibility with code expecting &JsImpl

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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "cachedData": cachedData.map(fn(x) { @core.any(x) }),
    "produceCachedData": produceCachedData.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
    "contextName": contextName.map(fn(x) { @core.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @core.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
    "contextName": contextName.map(fn(x) { @core.any(x) }),
    "contextOrigin": contextOrigin.map(fn(x) { @core.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "displayErrors": displayErrors.map(fn(x) { @core.any(x) }),
    "timeout": timeout.map(fn(x) { @core.any(x) }),
    "breakOnSigint": breakOnSigint.map(fn(x) { @core.any(x) }),
  })
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
  let options = @mbtconv.from_option_map({
    "name": name.map(fn(x) { @core.any(x) }),
    "origin": origin.map(fn(x) { @core.any(x) }),
    "microtaskMode": microtaskMode.map(fn(x) { @core.any(x) }),
  })
  match contextObject {
    Some(ctx) =>
      @core.any(vm)._call("createContext", [@core.any(ctx), options]).cast()
    None => @core.any(vm)._call("createContext", [options]).cast()
  }
}

///|
/// Check if object is a context
pub fn isContext(object : @core.Any) -> Bool {
  let vm = vm_module()
  @core.any(vm)._call("isContext", [@core.any(object)]).cast()
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
  let options = @mbtconv.from_option_map({
    "filename": filename.map(fn(x) { @core.any(x) }),
    "lineOffset": lineOffset.map(fn(x) { @core.any(x) }),
    "columnOffset": columnOffset.map(fn(x) { @core.any(x) }),
    "cachedData": cachedData.map(fn(x) { @core.any(x) }),
    "produceCachedData": produceCachedData.map(fn(x) { @core.any(x) }),
    "parsingContext": parsingContext.map(fn(x) { @core.any(x) }),
    "contextExtensions": contextExtensions.map(fn(x) { @core.any(x) }),
  })
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
