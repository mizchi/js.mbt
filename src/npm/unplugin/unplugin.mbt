///|
/// Unplugin - Unified Plugin System
/// https://unplugin.unjs.io/
///
/// A unified plugin system for build tools (Vite, Rollup, webpack, esbuild, etc.)

///| FFI

///|
#module("unplugin")
extern "js" fn ffi_create_unplugin(
  factory : (@core.Any, @core.Any) -> @core.Any,
) -> @core.Any = "createUnplugin"

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
pub type TransformResult = @core.Any

///|
/// Context metadata passed to the factory function
pub(all) struct UnpluginContextMeta {
  /// The current framework/bundler being used
  framework : Framework
  /// Raw meta object for framework-specific access
  raw : @core.Any
}

///|
pub fn UnpluginContextMeta::to_any(self : UnpluginContextMeta) -> @core.Any {
  self.raw
}

///|
/// Create UnpluginContextMeta from JS object
fn meta_from_js(meta : @core.Any) -> UnpluginContextMeta {
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
pub fn StringFilter::to_any(self : StringFilter) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if self.includes is Some(v) {
    entries.push(("include", @core.identity(@core.any(v))))
  }
  if self.excludes is Some(v) {
    entries.push(("exclude", @core.identity(@core.any(v))))
  }
  @core.from_entries(entries)
}

///|
/// Hook filter for transform/load hooks
pub(all) struct HookFilter {
  id : StringFilter?
  code : StringFilter?
}

///|
pub fn HookFilter::to_any(self : HookFilter) -> @core.Any {
  let entries : Array[(String, @core.Any)] = []
  if self.id is Some(v) {
    entries.push(("id", v.to_any()))
  }
  if self.code is Some(v) {
    entries.push(("code", v.to_any()))
  }
  @core.from_entries(entries)
}

///| Hook Types

///|
/// ResolveId hook callback
/// (id: String, importer: String?, options: @core.Any) -> String? | ResolveIdResult?
pub type ResolveIdHook = (String, String?, @core.Any) -> String?

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
pub type WatchChangeHook = (String, @core.Any) -> Unit

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
  vite : @core.Any?
  /// Rollup-specific plugin options
  rollup : @core.Any?
  /// Webpack-specific function (receives compiler)
  webpack : ((@core.Any) -> Unit)?
  /// Rspack-specific function (receives compiler)
  rspack : ((@core.Any) -> Unit)?
  /// Esbuild-specific options
  esbuild : @core.Any?
  /// Farm-specific plugin options
  farm : @core.Any?
  /// Rolldown-specific plugin options
  rolldown : @core.Any?
  /// Bun-specific plugin options
  bun : @core.Any?
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
  vite? : @core.Any,
  rollup? : @core.Any,
  webpack? : (@core.Any) -> Unit,
  rspack? : (@core.Any) -> Unit,
  esbuild? : @core.Any,
  farm? : @core.Any,
  rolldown? : @core.Any,
  bun? : @core.Any,
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
pub fn UnpluginOptions::to_any(self : UnpluginOptions) -> @core.Any {
  let obj = @core.new_object()
  obj["name"] = @core.any(self.name)
  if self.enforce is Some(v) {
    obj["enforce"] = @core.any(v)
  }
  if self.buildStart is Some(v) {
    obj["buildStart"] = @core.any(@js.from_fn0(v))
  }
  if self.buildEnd is Some(v) {
    obj["buildEnd"] = @core.any(@js.from_fn0(v))
  }
  // Transform with optional filter
  if self.transform is Some(handler) {
    if self.transformFilter is Some(filter) {
      let hook = @core.new_object()
      hook["filter"] = filter.to_any()
      hook["handler"] = @core.any(@js.from_fn2(handler))
      obj["transform"] = hook
    } else {
      obj["transform"] = @core.any(@js.from_fn2(handler))
    }
  }
  // Load with optional filter
  if self.load is Some(handler) {
    if self.loadFilter is Some(filter) {
      let hook = @core.new_object()
      hook["filter"] = filter.to_any()
      hook["handler"] = @core.any(@js.from_fn1(handler))
      obj["load"] = hook
    } else {
      obj["load"] = @core.any(@js.from_fn1(handler))
    }
  }
  if self.resolveId is Some(v) {
    obj["resolveId"] = @core.any(@js.from_fn3(v))
  }
  if self.watchChange is Some(v) {
    obj["watchChange"] = @core.any(@js.from_fn2(v))
  }
  if self.writeBundle is Some(v) {
    obj["writeBundle"] = @core.any(@js.from_fn0(v))
  }
  if self.vite is Some(v) {
    obj["vite"] = @core.any(v)
  }
  if self.rollup is Some(v) {
    obj["rollup"] = @core.any(v)
  }
  if self.webpack is Some(v) {
    obj["webpack"] = @core.any(@js.from_fn1(v))
  }
  if self.rspack is Some(v) {
    obj["rspack"] = @core.any(@js.from_fn1(v))
  }
  if self.esbuild is Some(v) {
    obj["esbuild"] = @core.any(v)
  }
  if self.farm is Some(v) {
    obj["farm"] = @core.any(v)
  }
  if self.rolldown is Some(v) {
    obj["rolldown"] = @core.any(v)
  }
  if self.bun is Some(v) {
    obj["bun"] = @core.any(v)
  }
  obj
}

///| UnpluginInstance

///|
/// An unplugin instance with framework-specific plugin getters
#external
pub type UnpluginInstance

///|
pub fn UnpluginInstance::to_any(self : UnpluginInstance) -> @core.Any = "%identity"

///|
/// Get Vite plugin from the unplugin instance
pub fn UnpluginInstance::vite(self : UnpluginInstance) -> @core.Any {
  self.to_any()["vite"] |> @core.identity
}

///|
/// Get Rollup plugin from the unplugin instance
pub fn UnpluginInstance::rollup(self : UnpluginInstance) -> @core.Any {
  self.to_any()["rollup"] |> @core.identity
}

///|
/// Get webpack plugin from the unplugin instance
pub fn UnpluginInstance::webpack(self : UnpluginInstance) -> @core.Any {
  self.to_any()["webpack"] |> @core.identity
}

///|
/// Get Rspack plugin from the unplugin instance
pub fn UnpluginInstance::rspack(self : UnpluginInstance) -> @core.Any {
  self.to_any()["rspack"] |> @core.identity
}

///|
/// Get esbuild plugin from the unplugin instance
pub fn UnpluginInstance::esbuild(self : UnpluginInstance) -> @core.Any {
  self.to_any()["esbuild"] |> @core.identity
}

///|
/// Get Farm plugin from the unplugin instance
pub fn UnpluginInstance::farm(self : UnpluginInstance) -> @core.Any {
  self.to_any()["farm"] |> @core.identity
}

///|
/// Get Rolldown plugin from the unplugin instance
pub fn UnpluginInstance::rolldown(self : UnpluginInstance) -> @core.Any {
  self.to_any()["rolldown"] |> @core.identity
}

///|
/// Get Bun plugin from the unplugin instance
pub fn UnpluginInstance::bun(self : UnpluginInstance) -> @core.Any {
  self.to_any()["bun"] |> @core.identity
}

///|
/// Get raw plugin for any framework
pub fn UnpluginInstance::raw(self : UnpluginInstance) -> @core.Any {
  self.to_any()["raw"] |> @core.identity
}

///| Factory Functions

///|
/// Factory function type that receives options and meta
pub type UnpluginFactory[UserOptions] = (UserOptions, UnpluginContextMeta) -> UnpluginOptions

///|
/// Create an unplugin with a factory function
/// The factory receives user options and context meta
pub fn[UserOptions] createUnplugin(
  factory : (UserOptions, UnpluginContextMeta) -> UnpluginOptions,
) -> (UserOptions) -> UnpluginInstance {
  let js_factory = fn(options : @core.Any, meta : @core.Any) -> @core.Any {
    let user_options : UserOptions = @core.identity(options)
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(user_options, context_meta)
    unplugin_options.to_any()
  }
  let instance = ffi_create_unplugin(js_factory)
  fn(options : UserOptions) -> UnpluginInstance {
    instance._invoke([@core.any(options)]) |> @core.identity
  }
}

///|
/// Create an unplugin without user options
pub fn createUnpluginSimple(
  factory : (UnpluginContextMeta) -> UnpluginOptions,
) -> () -> UnpluginInstance {
  let js_factory = fn(_options : @core.Any, meta : @core.Any) -> @core.Any {
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(context_meta)
    unplugin_options.to_any()
  }
  let instance = ffi_create_unplugin(js_factory)
  fn() -> UnpluginInstance { instance._invoke([]) |> @core.identity }
}

///| Transform Result Helpers

///|
/// Create a transform result with code only
pub fn transform_result(code : String) -> TransformResult {
  @core.any(code)
}

///|
/// Create a transform result with code and source map
pub fn transform_result_with_map(
  code : String,
  map : @core.Any,
) -> TransformResult {
  let obj = @core.new_object()
  obj["code"] = @core.any(code)
  obj["map"] = @core.any(map)
  obj |> @core.identity
}

///| Resolve Result Helpers

///|
/// Create a resolve result that marks module as external
pub fn resolve_external(id : String) -> @core.Any {
  let obj = @core.new_object()
  obj["id"] = @core.any(id)
  obj["external"] = @core.any(true)
  obj |> @core.identity
}

///|
/// Create a resolve result with custom id
pub fn resolve_id(id : String) -> @core.Any {
  let obj = @core.new_object()
  obj["id"] = @core.any(id)
  obj |> @core.identity
}
