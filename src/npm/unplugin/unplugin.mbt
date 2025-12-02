///|
/// Unplugin - Unified Plugin System
/// https://unplugin.unjs.io/
///
/// A unified plugin system for build tools (Vite, Rollup, webpack, esbuild, etc.)

///| FFI

///|
extern "js" fn ffi_require_unplugin() -> @nostd.Any =
  #|() => require("unplugin")

///|
extern "js" fn ffi_import_unplugin() -> @js.Promise[@nostd.Any] =
  #|() => import("unplugin")

///| Core Types

///|
/// Framework identifier for the current build context
pub enum Framework {
  Vite
  Rollup
  Webpack
  Rspack
  Esbuild
  Farm
  Rolldown
  Bun
} derive(Eq, Show)

///|
/// Convert framework string to enum
fn framework_from_string(s : String) -> Framework {
  match s {
    "vite" => Framework::Vite
    "rollup" => Framework::Rollup
    "webpack" => Framework::Webpack
    "rspack" => Framework::Rspack
    "esbuild" => Framework::Esbuild
    "farm" => Framework::Farm
    "rolldown" => Framework::Rolldown
    "bun" => Framework::Bun
    _ => Framework::Vite // fallback
  }
}

///|
/// Transform result - can be a string, object with code/map, or null
pub type TransformResult = @nostd.Any

///|
/// Context metadata passed to the factory function
pub(all) struct UnpluginContextMeta {
  /// The current framework/bundler being used
  framework : Framework
  /// Raw meta object for framework-specific access
  raw : @nostd.Any
}

///|
pub fn UnpluginContextMeta::to_any(self : UnpluginContextMeta) -> @nostd.Any {
  self.raw
}

///|
/// Create UnpluginContextMeta from JS object
fn meta_from_js(meta : @nostd.Any) -> UnpluginContextMeta {
  let framework_str : String = meta["framework"].cast()
  { framework: framework_from_string(framework_str), raw: meta }
}

///|
/// String filter with include/exclude patterns
pub(all) struct StringFilter {
  includes : Array[String]?
  excludes : Array[String]?
}

///|
pub fn StringFilter::to_any(self : StringFilter) -> @nostd.Any {
  @mbtconv.from_option_map({
    "include": self.includes.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "exclude": self.excludes.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
  })
}

///|
/// Hook filter for transform/load hooks
pub(all) struct HookFilter {
  id : StringFilter?
  code : StringFilter?
}

///|
pub fn HookFilter::to_any(self : HookFilter) -> @nostd.Any {
  @mbtconv.from_option_map({
    "id": self.id.map(fn(x) { x.to_any() }),
    "code": self.code.map(fn(x) { x.to_any() }),
  })
}

///| Hook Types

///|
/// ResolveId hook callback
/// (id: String, importer: String?, options: @nostd.Any) -> String? | ResolveIdResult?
pub type ResolveIdHook = (String, String?, @nostd.Any) -> String?

///|
/// Load hook callback
/// (id: String) -> String? | LoadResult?
pub type LoadHook = (String) -> String?

///|
/// Transform hook callback
/// (code: String, id: String) -> String? | TransformResult?
pub type TransformHook = (String, String) -> String?

///|
/// BuildStart hook callback
pub type BuildStartHook = () -> Unit

///|
/// BuildEnd hook callback
pub type BuildEndHook = () -> Unit

///|
/// WatchChange hook callback
/// (id: String, change: { event: 'create' | 'update' | 'delete' }) -> Unit
pub type WatchChangeHook = (String, @nostd.Any) -> Unit

///|
/// WriteBundle hook callback
pub type WriteBundleHook = () -> Unit

///| UnpluginOptions

///|
/// Options for creating an unplugin
pub(all) struct UnpluginOptions {
  /// Plugin name (required)
  name : String
  /// Plugin ordering: "pre" | "post" | undefined
  enforce : String?
  /// Build start hook
  buildStart : BuildStartHook?
  /// Build end hook
  buildEnd : BuildEndHook?
  /// Transform hook
  transform : TransformHook?
  /// Transform with filter
  transformFilter : HookFilter?
  /// Load hook
  load : LoadHook?
  /// Load with filter
  loadFilter : HookFilter?
  /// ResolveId hook
  resolveId : ResolveIdHook?
  /// Watch change hook
  watchChange : WatchChangeHook?
  /// Write bundle hook
  writeBundle : WriteBundleHook?
  /// Vite-specific plugin options
  vite : @nostd.Any?
  /// Rollup-specific plugin options
  rollup : @nostd.Any?
  /// Webpack-specific function (receives compiler)
  webpack : ((@nostd.Any) -> Unit)?
  /// Rspack-specific function (receives compiler)
  rspack : ((@nostd.Any) -> Unit)?
  /// Esbuild-specific options
  esbuild : @nostd.Any?
  /// Farm-specific plugin options
  farm : @nostd.Any?
  /// Rolldown-specific plugin options
  rolldown : @nostd.Any?
  /// Bun-specific plugin options
  bun : @nostd.Any?
}

///|
pub fn UnpluginOptions::new(
  name : String,
  enforce? : String,
  buildStart? : BuildStartHook,
  buildEnd? : BuildEndHook,
  transform? : TransformHook,
  transformFilter? : HookFilter,
  load? : LoadHook,
  loadFilter? : HookFilter,
  resolveId? : ResolveIdHook,
  watchChange? : WatchChangeHook,
  writeBundle? : WriteBundleHook,
  vite? : @nostd.Any,
  rollup? : @nostd.Any,
  webpack? : (@nostd.Any) -> Unit,
  rspack? : (@nostd.Any) -> Unit,
  esbuild? : @nostd.Any,
  farm? : @nostd.Any,
  rolldown? : @nostd.Any,
  bun? : @nostd.Any,
) -> UnpluginOptions {
  {
    name,
    enforce,
    buildStart,
    buildEnd,
    transform,
    transformFilter,
    load,
    loadFilter,
    resolveId,
    watchChange,
    writeBundle,
    vite,
    rollup,
    webpack,
    rspack,
    esbuild,
    farm,
    rolldown,
    bun,
  }
}

///|
pub fn UnpluginOptions::to_any(self : UnpluginOptions) -> @nostd.Any {
  let obj = @nostd.Object::new()
  obj["name"] = @nostd.any(self.name)
  if self.enforce is Some(v) {
    obj["enforce"] = @nostd.any(v)
  }
  if self.buildStart is Some(v) {
    obj["buildStart"] = @nostd.any(@js.from_fn0(v))
  }
  if self.buildEnd is Some(v) {
    obj["buildEnd"] = @nostd.any(@js.from_fn0(v))
  }
  // Transform with optional filter
  if self.transform is Some(handler) {
    if self.transformFilter is Some(filter) {
      let hook = @nostd.Object::new()
      hook["filter"] = filter.to_any()
      hook["handler"] = @nostd.any(@js.from_fn2(handler))
      obj["transform"] = hook
    } else {
      obj["transform"] = @nostd.any(@js.from_fn2(handler))
    }
  }
  // Load with optional filter
  if self.load is Some(handler) {
    if self.loadFilter is Some(filter) {
      let hook = @nostd.Object::new()
      hook["filter"] = filter.to_any()
      hook["handler"] = @nostd.any(@js.from_fn1(handler))
      obj["load"] = hook
    } else {
      obj["load"] = @nostd.any(@js.from_fn1(handler))
    }
  }
  if self.resolveId is Some(v) {
    obj["resolveId"] = @nostd.any(@js.from_fn3(v))
  }
  if self.watchChange is Some(v) {
    obj["watchChange"] = @nostd.any(@js.from_fn2(v))
  }
  if self.writeBundle is Some(v) {
    obj["writeBundle"] = @nostd.any(@js.from_fn0(v))
  }
  if self.vite is Some(v) {
    obj["vite"] = @nostd.any(v)
  }
  if self.rollup is Some(v) {
    obj["rollup"] = @nostd.any(v)
  }
  if self.webpack is Some(v) {
    obj["webpack"] = @nostd.any(@js.from_fn1(v))
  }
  if self.rspack is Some(v) {
    obj["rspack"] = @nostd.any(@js.from_fn1(v))
  }
  if self.esbuild is Some(v) {
    obj["esbuild"] = @nostd.any(v)
  }
  if self.farm is Some(v) {
    obj["farm"] = @nostd.any(v)
  }
  if self.rolldown is Some(v) {
    obj["rolldown"] = @nostd.any(v)
  }
  if self.bun is Some(v) {
    obj["bun"] = @nostd.any(v)
  }
  obj
}

///| UnpluginInstance

///|
/// An unplugin instance with framework-specific plugin getters
#external
pub type UnpluginInstance

///|
pub fn UnpluginInstance::to_any(self : UnpluginInstance) -> @nostd.Any = "%identity"

///|
/// Get Vite plugin from the unplugin instance
pub fn UnpluginInstance::vite(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["vite"] |> @nostd.identity
}

///|
/// Get Rollup plugin from the unplugin instance
pub fn UnpluginInstance::rollup(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["rollup"] |> @nostd.identity
}

///|
/// Get webpack plugin from the unplugin instance
pub fn UnpluginInstance::webpack(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["webpack"] |> @nostd.identity
}

///|
/// Get Rspack plugin from the unplugin instance
pub fn UnpluginInstance::rspack(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["rspack"] |> @nostd.identity
}

///|
/// Get esbuild plugin from the unplugin instance
pub fn UnpluginInstance::esbuild(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["esbuild"] |> @nostd.identity
}

///|
/// Get Farm plugin from the unplugin instance
pub fn UnpluginInstance::farm(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["farm"] |> @nostd.identity
}

///|
/// Get Rolldown plugin from the unplugin instance
pub fn UnpluginInstance::rolldown(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["rolldown"] |> @nostd.identity
}

///|
/// Get Bun plugin from the unplugin instance
pub fn UnpluginInstance::bun(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["bun"] |> @nostd.identity
}

///|
/// Get raw plugin for any framework
pub fn UnpluginInstance::raw(self : UnpluginInstance) -> @nostd.Any {
  self.to_any()["raw"] |> @nostd.identity
}

///| Factory Functions

///|
/// Factory function type that receives options and meta
pub type UnpluginFactory[UserOptions] = (UserOptions, UnpluginContextMeta) -> UnpluginOptions

///|
/// Create an unplugin with a factory function (sync, requires)
/// The factory receives user options and context meta
pub fn[UserOptions] createUnplugin(
  factory : (UserOptions, UnpluginContextMeta) -> UnpluginOptions,
) -> (UserOptions) -> UnpluginInstance {
  let unplugin_mod = ffi_require_unplugin()
  let create_fn = unplugin_mod["createUnplugin"]
  let js_factory = fn(options : @nostd.Any, meta : @nostd.Any) -> @nostd.Any {
    let user_options : UserOptions = @nostd.identity(options)
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(user_options, context_meta)
    unplugin_options.to_any()
  }
  let instance = create_fn._invoke([@nostd.any(@js.from_fn2(js_factory))])
  fn(options : UserOptions) -> UnpluginInstance {
    instance._invoke([@nostd.any(options)]) |> @nostd.identity
  }
}

///|
/// Create an unplugin without user options (sync, requires)
pub fn createUnpluginSimple(
  factory : (UnpluginContextMeta) -> UnpluginOptions,
) -> () -> UnpluginInstance {
  let unplugin_mod = ffi_require_unplugin()
  let create_fn = unplugin_mod["createUnplugin"]
  let js_factory = fn(_options : @nostd.Any, meta : @nostd.Any) -> @nostd.Any {
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(context_meta)
    unplugin_options.to_any()
  }
  let instance = create_fn._invoke([@nostd.any(@js.from_fn2(js_factory))])
  fn() -> UnpluginInstance { instance._invoke([]) |> @nostd.identity }
}

///|
/// Create an unplugin with async import
pub async fn[UserOptions] createUnpluginAsync(
  factory : (UserOptions, UnpluginContextMeta) -> UnpluginOptions,
) -> (UserOptions) -> UnpluginInstance {
  let unplugin_mod = ffi_import_unplugin().wait()
  let create_fn = unplugin_mod["createUnplugin"]
  let js_factory = fn(options : @nostd.Any, meta : @nostd.Any) -> @nostd.Any {
    let user_options : UserOptions = @nostd.identity(options)
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(user_options, context_meta)
    unplugin_options.to_any()
  }
  let instance = create_fn._invoke([@nostd.any(@js.from_fn2(js_factory))])
  fn(options : UserOptions) -> UnpluginInstance {
    instance._invoke([@nostd.any(options)]) |> @nostd.identity
  }
}

///| Transform Result Helpers

///|
/// Create a transform result with code only
pub fn transform_result(code : String) -> TransformResult {
  @nostd.any(code)
}

///|
/// Create a transform result with code and source map
pub fn transform_result_with_map(
  code : String,
  map : @nostd.Any,
) -> TransformResult {
  let obj = @nostd.Object::new()
  obj["code"] = @nostd.any(code)
  obj["map"] = @nostd.any(map)
  obj |> @nostd.identity
}

///| Resolve Result Helpers

///|
/// Create a resolve result that marks module as external
pub fn resolve_external(id : String) -> @nostd.Any {
  let obj = @nostd.Object::new()
  obj["id"] = @nostd.any(id)
  obj["external"] = @nostd.any(true)
  obj |> @nostd.identity
}

///|
/// Create a resolve result with custom id
pub fn resolve_id(id : String) -> @nostd.Any {
  let obj = @nostd.Object::new()
  obj["id"] = @nostd.any(id)
  obj |> @nostd.identity
}
