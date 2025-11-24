///|
/// Vite JavaScript API bindings for MoonBit
/// See: https://ja.vite.dev/guide/api-javascript

///|
/// ViteDevServer type
/// Represents a Vite development server instance
#external
pub type ViteDevServer

///|
pub impl @js.JsImpl for ViteDevServer

///|
/// PreviewServer type
/// Represents a Vite preview server instance
#external
pub type PreviewServer

///|
pub impl @js.JsImpl for PreviewServer

///|
/// ResolvedConfig type
/// Represents resolved Vite configuration
#external
pub type ResolvedConfig

///|
pub impl @js.JsImpl for ResolvedConfig

///|
/// RollupOutput type
/// Represents Rollup build output
#external
pub type RollupOutput

///|
pub impl @js.JsImpl for RollupOutput

///| Core API Functions - FFI

///|
/// FFI: createServer
extern "js" fn ffi_createServer(config : @js.Js) -> @js.Js =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.createServer(config);
  #| }

///|
/// FFI: build
extern "js" fn ffi_build(config : @js.Js) -> @js.Js =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.build(config);
  #| }

///|
/// FFI: preview
extern "js" fn ffi_preview(config : @js.Js) -> @js.Js =
  #| (config) => {
  #|   const vite = require('vite');
  #|   return vite.preview(config);
  #| }

///| Public API with labeled arguments

///|
/// Create a development server
/// JS: createServer(inlineConfig)
/// See: https://ja.vite.dev/guide/api-javascript#createserver
pub async fn createServer(
  root? : String,
  base? : String,
  mode? : String,
  configFile? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @js.Js,
) -> ViteDevServer {
  let config = @js.Object::new()
  match root {
    Some(v) => config.set("root", @js.js(v))
    None => ()
  }
  match base {
    Some(v) => config.set("base", @js.js(v))
    None => ()
  }
  match mode {
    Some(v) => config.set("mode", @js.js(v))
    None => ()
  }
  match configFile {
    Some(v) => config.set("configFile", @js.js(v))
    None => ()
  }
  match logLevel {
    Some(v) => config.set("logLevel", @js.js(v))
    None => ()
  }
  match clearScreen {
    Some(v) => config.set("clearScreen", @js.js(v))
    None => ()
  }
  match server {
    Some(v) => config.set("server", v)
    None => ()
  }
  let promise : @js.Promise[ViteDevServer] = @js.unsafe_cast(
    ffi_createServer(config.to_js()),
  )
  promise.wait()
}

///|
/// Build for production
/// JS: build(inlineConfig)
/// See: https://ja.vite.dev/guide/api-javascript#build
pub async fn build(
  root? : String,
  base? : String,
  mode? : String,
  configFile? : String,
  logLevel? : String,
  clearScreen? : Bool,
  build? : @js.Js,
) -> RollupOutput {
  let config = @js.Object::new()
  match root {
    Some(v) => config.set("root", @js.js(v))
    None => ()
  }
  match base {
    Some(v) => config.set("base", @js.js(v))
    None => ()
  }
  match mode {
    Some(v) => config.set("mode", @js.js(v))
    None => ()
  }
  match configFile {
    Some(v) => config.set("configFile", @js.js(v))
    None => ()
  }
  match logLevel {
    Some(v) => config.set("logLevel", @js.js(v))
    None => ()
  }
  match clearScreen {
    Some(v) => config.set("clearScreen", @js.js(v))
    None => ()
  }
  match build {
    Some(v) => config.set("build", v)
    None => ()
  }
  let promise : @js.Promise[RollupOutput] = @js.unsafe_cast(
    ffi_build(config.to_js()),
  )
  promise.wait()
}

///|
/// Create a preview server
/// JS: preview(inlineConfig)
/// See: https://ja.vite.dev/guide/api-javascript#preview
pub async fn preview(
  root? : String,
  base? : String,
  mode? : String,
  configFile? : String,
  logLevel? : String,
  clearScreen? : Bool,
  preview? : @js.Js,
) -> PreviewServer {
  let config = @js.Object::new()
  match root {
    Some(v) => config.set("root", @js.js(v))
    None => ()
  }
  match base {
    Some(v) => config.set("base", @js.js(v))
    None => ()
  }
  match mode {
    Some(v) => config.set("mode", @js.js(v))
    None => ()
  }
  match configFile {
    Some(v) => config.set("configFile", @js.js(v))
    None => ()
  }
  match logLevel {
    Some(v) => config.set("logLevel", @js.js(v))
    None => ()
  }
  match clearScreen {
    Some(v) => config.set("clearScreen", @js.js(v))
    None => ()
  }
  match preview {
    Some(v) => config.set("preview", v)
    None => ()
  }
  let promise : @js.Promise[PreviewServer] = @js.unsafe_cast(
    ffi_preview(config.to_js()),
  )
  promise.wait()
}

///| ViteDevServer methods

///|
/// ViteDevServer: Start listening on port
/// JS: server.listen()
pub async fn ViteDevServer::listen(
  self : ViteDevServer,
  port? : Int,
  host? : String,
) -> ViteDevServer {
  let options = @js.Object::new()
  match port {
    Some(v) => options.set("port", @js.js(v))
    None => ()
  }
  match host {
    Some(v) => options.set("host", @js.js(v))
    None => ()
  }
  let promise : @js.Promise[ViteDevServer] = @js.unsafe_cast(
    self.call("listen", [options.to_js()]),
  )
  promise.wait()
}

///|
/// ViteDevServer: Close the server
/// JS: server.close()
pub async fn ViteDevServer::close(self : ViteDevServer) -> Unit {
  let promise : @js.Promise[Unit] = @js.unsafe_cast(self.call("close", []))
  promise.wait()
}

///|
/// ViteDevServer: Print server URLs
/// JS: server.printUrls()
pub fn ViteDevServer::printUrls(self : ViteDevServer) -> Unit {
  let _ = self.call("printUrls", [])

}

///|
/// ViteDevServer: Restart the server
/// JS: server.restart()
pub async fn ViteDevServer::restart(
  self : ViteDevServer,
  forceOptimize? : Bool,
) -> Unit {
  let options = @js.Object::new()
  match forceOptimize {
    Some(v) => options.set("forceOptimize", @js.js(v))
    None => ()
  }
  let promise : @js.Promise[Unit] = @js.unsafe_cast(
    self.call("restart", [options.to_js()]),
  )
  promise.wait()
}

///|
/// ViteDevServer: Get resolved URLs
/// JS: server.resolvedUrls
pub fn ViteDevServer::resolvedUrls(self : ViteDevServer) -> @js.Js {
  self.get("resolvedUrls")
}

///| PreviewServer methods

///|
/// PreviewServer: Print server URLs
/// JS: server.printUrls()
pub fn PreviewServer::printUrls(self : PreviewServer) -> Unit {
  let _ = self.call("printUrls", [])

}

///|
/// PreviewServer: Get resolved URLs
/// JS: server.resolvedUrls
pub fn PreviewServer::resolvedUrls(self : PreviewServer) -> @js.Js {
  self.get("resolvedUrls")
}
