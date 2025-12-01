///|
/// Vite Environment API bindings for MoonBit
/// https://vite.dev/guide/api-environment
///
/// Environment API for Vite 6+ multi-environment support.

///| Types

///|
/// ViteDevServer - the development server instance
#external
pub type ViteDevServer

///|
pub fn ViteDevServer::to_any(self : ViteDevServer) -> @nostd.Any = "%identity"

///|
/// DevEnvironment - development environment instance
#external
pub type DevEnvironment

///|
pub fn DevEnvironment::to_any(self : DevEnvironment) -> @nostd.Any = "%identity"

///|
/// ModuleGraph - tracks import relationships between modules
#external
pub type ModuleGraph

///|
pub fn ModuleGraph::to_any(self : ModuleGraph) -> @nostd.Any = "%identity"

///|
/// ModuleNode - represents a module in the graph
#external
pub type ModuleNode

///|
pub fn ModuleNode::to_any(self : ModuleNode) -> @nostd.Any = "%identity"

///|
/// HotChannel - communication channel with runtime
#external
pub type HotChannel

///|
pub fn HotChannel::to_any(self : HotChannel) -> @nostd.Any = "%identity"

///|
/// PluginContainer - plugin pipeline container
#external
pub type PluginContainer

///|
pub fn PluginContainer::to_any(self : PluginContainer) -> @nostd.Any =
  "%identity"

///|
/// ModuleRunner - runs modules in target runtime
#external
pub type ModuleRunner

///|
pub fn ModuleRunner::to_any(self : ModuleRunner) -> @nostd.Any = "%identity"

///|
/// TransformResult - result of module transformation
#external
pub type TransformResult

///|
pub fn TransformResult::to_any(self : TransformResult) -> @nostd.Any =
  "%identity"

///|
/// FetchResult - result of module fetch
#external
pub type FetchResult

///|
pub fn FetchResult::to_any(self : FetchResult) -> @nostd.Any = "%identity"

///| ViteDevServer FFI

///|
extern "js" fn ffi_create_server(
  config : @nostd.Any,
) -> @js.Promise[ViteDevServer] =
  #| (config) => require('vite').createServer(config)

///|
extern "js" fn ffi_server_print_urls(server : ViteDevServer) -> Unit =
  #| (server) => server.printUrls()

///|
extern "js" fn ffi_server_resolved_urls(server : ViteDevServer) -> @nostd.Any =
  #| (server) => server.resolvedUrls

///|
extern "js" fn ffi_server_listen(
  server : ViteDevServer,
  port : Int,
) -> @js.Promise[ViteDevServer] =
  #| (server, port) => server.listen(port)

///|
extern "js" fn ffi_server_close(server : ViteDevServer) -> @js.Promise[Unit] =
  #| (server) => server.close()

///|
extern "js" fn ffi_server_environments(server : ViteDevServer) -> @nostd.Any =
  #| (server) => server.environments

///|
extern "js" fn ffi_server_get_environment(
  server : ViteDevServer,
  name : String,
) -> DevEnvironment =
  #| (server, name) => server.environments[name]

///| DevEnvironment FFI

///|
extern "js" fn ffi_env_name(env : DevEnvironment) -> String =
  #| (env) => env.name

///|
extern "js" fn ffi_env_hot(env : DevEnvironment) -> HotChannel =
  #| (env) => env.hot

///|
extern "js" fn ffi_env_module_graph(env : DevEnvironment) -> ModuleGraph =
  #| (env) => env.moduleGraph

///|
extern "js" fn ffi_env_plugin_container(
  env : DevEnvironment,
) -> PluginContainer =
  #| (env) => env.pluginContainer

///|
extern "js" fn ffi_env_transform_request(
  env : DevEnvironment,
  url : String,
) -> @js.Promise[TransformResult?] =
  #| (env, url) => env.transformRequest(url)

///|
extern "js" fn ffi_env_warmup_request(
  env : DevEnvironment,
  url : String,
) -> Unit =
  #| (env, url) => env.warmupRequest(url)

///|
extern "js" fn ffi_env_fetch_module(
  env : DevEnvironment,
  id : String,
  importer : String,
) -> @js.Promise[FetchResult] =
  #| (env, id, importer) => env.fetchModule(id, importer)

///| ModuleGraph FFI

///|
extern "js" fn ffi_graph_get_module_by_url(
  graph : ModuleGraph,
  url : String,
) -> @js.Promise[ModuleNode?] =
  #| (graph, url) => graph.getModuleByUrl(url)

///|
extern "js" fn ffi_graph_get_module_by_id(
  graph : ModuleGraph,
  id : String,
) -> ModuleNode? =
  #| (graph, id) => graph.getModuleById(id)

///|
extern "js" fn ffi_graph_invalidate_module(
  graph : ModuleGraph,
  mod : ModuleNode,
) -> Unit =
  #| (graph, mod) => graph.invalidateModule(mod)

///| ModuleNode FFI

///|
extern "js" fn ffi_node_id(node : ModuleNode) -> String? =
  #| (node) => node.id

///|
extern "js" fn ffi_node_url(node : ModuleNode) -> String =
  #| (node) => node.url

///|
extern "js" fn ffi_node_file(node : ModuleNode) -> String? =
  #| (node) => node.file

///|
extern "js" fn ffi_node_type(node : ModuleNode) -> String =
  #| (node) => node.type

///|
extern "js" fn ffi_node_importers(node : ModuleNode) -> @nostd.Any =
  #| (node) => Array.from(node.importers)

///|
extern "js" fn ffi_node_imported_modules(node : ModuleNode) -> @nostd.Any =
  #| (node) => Array.from(node.importedModules)

///| ModuleRunner FFI

///|
extern "js" fn ffi_runner_import(
  runner : ModuleRunner,
  url : String,
) -> @js.Promise[@nostd.Any] =
  #| (runner, url) => runner.import(url)

///|
extern "js" fn ffi_runner_clear_cache(runner : ModuleRunner) -> Unit =
  #| (runner) => runner.clearCache()

///|
extern "js" fn ffi_runner_close(runner : ModuleRunner) -> @js.Promise[Unit] =
  #| (runner) => runner.close()

///|
extern "js" fn ffi_runner_is_closed(runner : ModuleRunner) -> Bool =
  #| (runner) => runner.isClosed()

///| TransformResult FFI

///|
extern "js" fn ffi_result_code(result : TransformResult) -> String =
  #| (result) => result.code

///|
extern "js" fn ffi_result_map(result : TransformResult) -> @nostd.Any =
  #| (result) => result.map

///|
extern "js" fn ffi_result_etag(result : TransformResult) -> String? =
  #| (result) => result.etag

///| HotChannel FFI

///|
extern "js" fn ffi_hot_send(channel : HotChannel, payload : @nostd.Any) -> Unit =
  #| (channel, payload) => channel.send(payload)

///|
extern "js" fn ffi_hot_on(
  channel : HotChannel,
  event : String,
  handler : @nostd.Any,
) -> Unit =
  #| (channel, event, handler) => channel.on(event, handler)

///|
extern "js" fn ffi_hot_off(
  channel : HotChannel,
  event : String,
  handler : @nostd.Any,
) -> Unit =
  #| (channel, event, handler) => channel.off(event, handler)

///| ViteDevServer Methods

///|
/// Create a new Vite dev server with config object
pub async fn createServerWithConfig(config : @nostd.Any) -> ViteDevServer {
  ffi_create_server(config |> @nostd.any).wait()
}

///|
/// Create a new Vite dev server
pub async fn createServer(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @nostd.Any,
  plugins? : @nostd.Any,
) -> ViteDevServer {
  let cfg = @nostd.Object::new()
  if root is Some(v) {
    cfg["root"] = @nostd.any(v)
  }
  if base is Some(v) {
    cfg["base"] = @nostd.any(v)
  }
  if mode is Some(v) {
    cfg["mode"] = @nostd.any(v)
  }
  if logLevel is Some(v) {
    cfg["logLevel"] = @nostd.any(v)
  }
  if clearScreen is Some(v) {
    cfg["clearScreen"] = @nostd.any(v)
  }
  if server is Some(v) {
    cfg["server"] = @nostd.any(v)
  }
  if plugins is Some(v) {
    cfg["plugins"] = @nostd.any(v)
  }
  ffi_create_server(cfg).wait()
}

///|
/// Start listening on the specified port
pub async fn ViteDevServer::listen(
  self : ViteDevServer,
  port? : Int,
) -> ViteDevServer {
  ffi_server_listen(self, port.unwrap_or(5173)).wait()
}

///|
/// Close the server
pub async fn ViteDevServer::close(self : ViteDevServer) -> Unit {
  ffi_server_close(self).wait()
}

///|
/// Print server URLs to console
pub fn ViteDevServer::printUrls(self : ViteDevServer) -> Unit {
  ffi_server_print_urls(self)
}

///|
/// Get the resolved URLs
pub fn ViteDevServer::resolvedUrls(self : ViteDevServer) -> @nostd.Any {
  ffi_server_resolved_urls(self)
}

///|
/// Get all environments
pub fn ViteDevServer::environments(self : ViteDevServer) -> @nostd.Any {
  ffi_server_environments(self)
}

///|
/// Get environment by name (client, ssr, or custom)
pub fn ViteDevServer::getEnvironment(
  self : ViteDevServer,
  name : String,
) -> DevEnvironment {
  ffi_server_get_environment(self, name)
}

///|
/// Get the client environment
pub fn ViteDevServer::client(self : ViteDevServer) -> DevEnvironment {
  ffi_server_get_environment(self, "client")
}

///|
/// Get the SSR environment
pub fn ViteDevServer::ssr(self : ViteDevServer) -> DevEnvironment {
  ffi_server_get_environment(self, "ssr")
}

///| DevEnvironment Methods

///|
/// Get the environment name
pub fn DevEnvironment::name(self : DevEnvironment) -> String {
  ffi_env_name(self)
}

///|
/// Get the HMR hot channel
pub fn DevEnvironment::hot(self : DevEnvironment) -> HotChannel {
  ffi_env_hot(self)
}

///|
/// Get the module graph
pub fn DevEnvironment::moduleGraph(self : DevEnvironment) -> ModuleGraph {
  ffi_env_module_graph(self)
}

///|
/// Get the plugin container
pub fn DevEnvironment::pluginContainer(
  self : DevEnvironment,
) -> PluginContainer {
  ffi_env_plugin_container(self)
}

///|
/// Transform a request URL through the plugin pipeline
pub async fn DevEnvironment::transformRequest(
  self : DevEnvironment,
  url : String,
) -> TransformResult? {
  ffi_env_transform_request(self, url).wait()
}

///|
/// Register a low-priority warmup request
pub fn DevEnvironment::warmupRequest(
  self : DevEnvironment,
  url : String,
) -> Unit {
  ffi_env_warmup_request(self, url)
}

///|
/// Fetch a module for the runner
pub async fn DevEnvironment::fetchModule(
  self : DevEnvironment,
  id : String,
  importer? : String,
) -> FetchResult {
  ffi_env_fetch_module(self, id, importer.unwrap_or("")).wait()
}

///| ModuleGraph Methods

///|
/// Get module by URL
pub async fn ModuleGraph::getModuleByUrl(
  self : ModuleGraph,
  url : String,
) -> ModuleNode? {
  ffi_graph_get_module_by_url(self, url).wait()
}

///|
/// Get module by ID (sync)
pub fn ModuleGraph::getModuleById(
  self : ModuleGraph,
  id : String,
) -> ModuleNode? {
  ffi_graph_get_module_by_id(self, id)
}

///|
/// Invalidate a module
pub fn ModuleGraph::invalidateModule(
  self : ModuleGraph,
  mod : ModuleNode,
) -> Unit {
  ffi_graph_invalidate_module(self, mod)
}

///| ModuleNode Methods

///|
/// Get the module ID
pub fn ModuleNode::id(self : ModuleNode) -> String? {
  ffi_node_id(self)
}

///|
/// Get the module URL
pub fn ModuleNode::url(self : ModuleNode) -> String {
  ffi_node_url(self)
}

///|
/// Get the file path
pub fn ModuleNode::file(self : ModuleNode) -> String? {
  ffi_node_file(self)
}

///|
/// Get the module type (js, css, etc.)
pub fn ModuleNode::moduleType(self : ModuleNode) -> String {
  ffi_node_type(self)
}

///|
/// Get modules that import this module
pub fn ModuleNode::importers(self : ModuleNode) -> Array[ModuleNode] {
  @js.identity(ffi_node_importers(self))
}

///|
/// Get modules imported by this module
pub fn ModuleNode::importedModules(self : ModuleNode) -> Array[ModuleNode] {
  @js.identity(ffi_node_imported_modules(self))
}

///| ModuleRunner Methods

///|
/// Import and execute a module
pub async fn ModuleRunner::importModule(
  self : ModuleRunner,
  url : String,
) -> @nostd.Any {
  ffi_runner_import(self, url).wait()
}

///|
/// Clear all caches
pub fn ModuleRunner::clearCache(self : ModuleRunner) -> Unit {
  ffi_runner_clear_cache(self)
}

///|
/// Close the runner
pub async fn ModuleRunner::close(self : ModuleRunner) -> Unit {
  ffi_runner_close(self).wait()
}

///|
/// Check if runner is closed
pub fn ModuleRunner::isClosed(self : ModuleRunner) -> Bool {
  ffi_runner_is_closed(self)
}

///| TransformResult Methods

///|
/// Get the transformed code
pub fn TransformResult::code(self : TransformResult) -> String {
  ffi_result_code(self)
}

///|
/// Get the source map
pub fn TransformResult::map(self : TransformResult) -> @nostd.Any {
  ffi_result_map(self)
}

///|
/// Get the etag
pub fn TransformResult::etag(self : TransformResult) -> String? {
  ffi_result_etag(self)
}

///| HotChannel Methods

///|
/// Send a payload to the client
pub fn HotChannel::send(self : HotChannel, payload : @nostd.Any) -> Unit {
  ffi_hot_send(self, payload)
}

///|
/// Listen for an event
pub fn HotChannel::on(
  self : HotChannel,
  event : String,
  handler : (@nostd.Any) -> Unit,
) -> Unit {
  ffi_hot_on(self, event, @js.from_fn1(handler))
}

///|
/// Remove an event listener
pub fn HotChannel::off(
  self : HotChannel,
  event : String,
  handler : (@nostd.Any) -> Unit,
) -> Unit {
  ffi_hot_off(self, event, @js.from_fn1(handler))
}
