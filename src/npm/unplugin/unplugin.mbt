///|
/// Unplugin - Unified Plugin System
/// https://unplugin.unjs.io/
///
/// A unified plugin system for build tools (Vite, Rollup, webpack, esbuild, etc.)

///| FFI

///|
extern "js" fn ffi_require_unplugin() -> @js.Any =
  #|() => require("unplugin")

///|
extern "js" fn ffi_import_unplugin() -> @js.Promise[@js.Any] =
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
pub type TransformResult = @js.Any

///|
/// Context metadata passed to the factory function
pub(all) struct UnpluginContextMeta {
  /// The current framework/bundler being used
  framework : Framework
  /// Raw meta object for framework-specific access
  raw : @js.Any
}

///|
pub fn UnpluginContextMeta::as_any(self : UnpluginContextMeta) -> @js.Any {
  self.raw
}

///|
/// Create UnpluginContextMeta from JS object
fn meta_from_js(meta : @js.Any) -> UnpluginContextMeta {
  let framework_str : String = meta.get("framework").cast()
  { framework: framework_from_string(framework_str), raw: meta }
}

///|
/// String filter with include/exclude patterns
pub(all) struct StringFilter {
  includes : Array[String]?
  excludes : Array[String]?
}

///|
pub fn StringFilter::as_any(self : StringFilter) -> @js.Any {
  @mbtconv.from_option_map({
    "include": self.includes.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
    "exclude": self.excludes.map(fn(x) { @nostd.identity(@js.from_array(x)) }),
  }).cast()
}

///|
/// Hook filter for transform/load hooks
pub(all) struct HookFilter {
  id : StringFilter?
  code : StringFilter?
}

///|
pub fn HookFilter::as_any(self : HookFilter) -> @js.Any {
  @mbtconv.from_option_map({
    "id": self.id.map(fn(x) { @nostd.identity(x.as_any()) }),
    "code": self.code.map(fn(x) { @nostd.identity(x.as_any()) }),
  }).cast()
}

///| Hook Types

///|
/// ResolveId hook callback
/// (id: String, importer: String?, options: @js.Any) -> String? | ResolveIdResult?
pub type ResolveIdHook = (String, String?, @js.Any) -> String?

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
pub type WatchChangeHook = (String, @js.Any) -> Unit

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
  vite : @js.Any?
  /// Rollup-specific plugin options
  rollup : @js.Any?
  /// Webpack-specific function (receives compiler)
  webpack : ((@js.Any) -> Unit)?
  /// Rspack-specific function (receives compiler)
  rspack : ((@js.Any) -> Unit)?
  /// Esbuild-specific options
  esbuild : @js.Any?
  /// Farm-specific plugin options
  farm : @js.Any?
  /// Rolldown-specific plugin options
  rolldown : @js.Any?
  /// Bun-specific plugin options
  bun : @js.Any?
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
  vite? : @js.Any,
  rollup? : @js.Any,
  webpack? : (@js.Any) -> Unit,
  rspack? : (@js.Any) -> Unit,
  esbuild? : @js.Any,
  farm? : @js.Any,
  rolldown? : @js.Any,
  bun? : @js.Any,
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
pub fn UnpluginOptions::as_any(self : UnpluginOptions) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("name", @js.any(self.name))
  match self.enforce {
    Some(v) => obj.set("enforce", @js.any(v))
    None => ()
  }
  match self.buildStart {
    Some(v) => obj.set("buildStart", @js.from_fn0(v))
    None => ()
  }
  match self.buildEnd {
    Some(v) => obj.set("buildEnd", @js.from_fn0(v))
    None => ()
  }
  // Transform with optional filter
  match self.transform {
    Some(handler) =>
      match self.transformFilter {
        Some(filter) => {
          let hook = @js.Object::new()
          hook.set("filter", filter.as_any())
          hook.set("handler", @js.from_fn2(handler))
          obj.set("transform", hook.as_any())
        }
        None => obj.set("transform", @js.from_fn2(handler))
      }
    None => ()
  }
  // Load with optional filter
  match self.load {
    Some(handler) =>
      match self.loadFilter {
        Some(filter) => {
          let hook = @js.Object::new()
          hook.set("filter", filter.as_any())
          hook.set("handler", @js.from_fn1(handler))
          obj.set("load", hook.as_any())
        }
        None => obj.set("load", @js.from_fn1(handler))
      }
    None => ()
  }
  match self.resolveId {
    Some(v) => obj.set("resolveId", @js.from_fn3(v))
    None => ()
  }
  match self.watchChange {
    Some(v) => obj.set("watchChange", @js.from_fn2(v))
    None => ()
  }
  match self.writeBundle {
    Some(v) => obj.set("writeBundle", @js.from_fn0(v))
    None => ()
  }
  match self.vite {
    Some(v) => obj.set("vite", v)
    None => ()
  }
  match self.rollup {
    Some(v) => obj.set("rollup", v)
    None => ()
  }
  match self.webpack {
    Some(v) => obj.set("webpack", @js.from_fn1(v))
    None => ()
  }
  match self.rspack {
    Some(v) => obj.set("rspack", @js.from_fn1(v))
    None => ()
  }
  match self.esbuild {
    Some(v) => obj.set("esbuild", v)
    None => ()
  }
  match self.farm {
    Some(v) => obj.set("farm", v)
    None => ()
  }
  match self.rolldown {
    Some(v) => obj.set("rolldown", v)
    None => ()
  }
  match self.bun {
    Some(v) => obj.set("bun", v)
    None => ()
  }
  obj.as_any()
}

///| UnpluginInstance

///|
/// An unplugin instance with framework-specific plugin getters
#external
pub type UnpluginInstance

///|
pub fn UnpluginInstance::as_any(self : UnpluginInstance) -> @js.Any = "%identity"

///|
/// Get Vite plugin from the unplugin instance
pub fn UnpluginInstance::vite(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("vite")
}

///|
/// Get Rollup plugin from the unplugin instance
pub fn UnpluginInstance::rollup(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("rollup")
}

///|
/// Get webpack plugin from the unplugin instance
pub fn UnpluginInstance::webpack(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("webpack")
}

///|
/// Get Rspack plugin from the unplugin instance
pub fn UnpluginInstance::rspack(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("rspack")
}

///|
/// Get esbuild plugin from the unplugin instance
pub fn UnpluginInstance::esbuild(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("esbuild")
}

///|
/// Get Farm plugin from the unplugin instance
pub fn UnpluginInstance::farm(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("farm")
}

///|
/// Get Rolldown plugin from the unplugin instance
pub fn UnpluginInstance::rolldown(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("rolldown")
}

///|
/// Get Bun plugin from the unplugin instance
pub fn UnpluginInstance::bun(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("bun")
}

///|
/// Get raw plugin for any framework
pub fn UnpluginInstance::raw(self : UnpluginInstance) -> @js.Any {
  self.as_any().get("raw")
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
  let create_fn = unplugin_mod.get("createUnplugin")
  let js_factory = fn(options : @js.Any, meta : @js.Any) -> @js.Any {
    let user_options : UserOptions = @js.identity(options)
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(user_options, context_meta)
    unplugin_options.as_any()
  }
  let instance : @js.Any = create_fn.call_self([@js.from_fn2(js_factory)])
  fn(options : UserOptions) -> UnpluginInstance {
    @js.identity(instance.call_self([@js.identity(options)]))
  }
}

///|
/// Create an unplugin without user options (sync, requires)
pub fn createUnpluginSimple(
  factory : (UnpluginContextMeta) -> UnpluginOptions,
) -> () -> UnpluginInstance {
  let unplugin_mod = ffi_require_unplugin()
  let create_fn = unplugin_mod.get("createUnplugin")
  let js_factory = fn(_options : @js.Any, meta : @js.Any) -> @js.Any {
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(context_meta)
    unplugin_options.as_any()
  }
  let instance : @js.Any = create_fn.call_self([@js.from_fn2(js_factory)])
  fn() -> UnpluginInstance { @js.identity(instance.call_self0()) }
}

///|
/// Create an unplugin with async import
pub async fn[UserOptions] createUnpluginAsync(
  factory : (UserOptions, UnpluginContextMeta) -> UnpluginOptions,
) -> (UserOptions) -> UnpluginInstance {
  let unplugin_mod = ffi_import_unplugin().wait()
  let create_fn = unplugin_mod.get("createUnplugin")
  let js_factory = fn(options : @js.Any, meta : @js.Any) -> @js.Any {
    let user_options : UserOptions = @js.identity(options)
    let context_meta = meta_from_js(meta)
    let unplugin_options = factory(user_options, context_meta)
    unplugin_options.as_any()
  }
  let instance : @js.Any = create_fn.call_self([@js.from_fn2(js_factory)])
  fn(options : UserOptions) -> UnpluginInstance {
    @js.identity(instance.call_self([@js.identity(options)]))
  }
}

///| Transform Result Helpers

///|
/// Create a transform result with code only
pub fn transform_result(code : String) -> TransformResult {
  @js.any(code)
}

///|
/// Create a transform result with code and source map
pub fn transform_result_with_map(
  code : String,
  map : @js.Any,
) -> TransformResult {
  let obj = @js.Object::new()
  obj.set("code", @js.any(code))
  obj.set("map", map)
  obj.as_any()
}

///| Resolve Result Helpers

///|
/// Create a resolve result that marks module as external
pub fn resolve_external(id : String) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("id", @js.any(id))
  obj.set("external", @js.any(true))
  obj.as_any()
}

///|
/// Create a resolve result with custom id
pub fn resolve_id(id : String) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("id", @js.any(id))
  obj.as_any()
}
