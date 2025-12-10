# vite

MoonBit bindings for Vite - A next generation frontend tooling.

## Installation

First, install vite via npm:

```bash
npm install vite
```

## Usage

### Using defineConfig

```moonbit
// defineConfig returns @core.Any object directly
let config = @vite.defineConfig(
  root?=Some("."),
  base?=Some("/"),
  mode?=Some("development"),
  server?=Some(@js.from_map({
    "port": @core.any(3000),
    "host": @core.any("localhost")
  }))
)
```

### Development Server

```moonbit
let server = @vite.createServer(
  root?=Some("."),
  logLevel?=Some("info"),
  clearScreen?=Some(false)
)!

let listening = server.listen(port?=Some(5173))!
listening.printUrls()

// Close when done
server.close()!
```

### Production Build

```moonbit
let output = @vite.build(
  root?=Some("."),
  mode?=Some("production"),
  logLevel?=Some("info")
)!
```

### Preview Server

```moonbit
let server = @vite.preview(
  root?=Some("."),
  logLevel?=Some("info")
)!

server.printUrls()
```

### Creating Plugins

```moonbit
let my_plugin = @vite.define_plugin(
  name="my-plugin",
  enforce?=Some("pre"),
  transform?=Some(@js.function(fn(code, id) {
    // Transform code here
    code
  }))
)

// Use in config
let config = @vite.defineConfig(
  plugins?=Some(@core.any([my_plugin]))
)
```

## API Reference

### Core Functions

#### defineConfig

Define Vite configuration with labeled arguments:

```moonbit
pub fn defineConfig(
  root? : String,
  base? : String,
  mode? : String,
  logLevel? : String,
  clearScreen? : Bool,
  server? : @core.Any,
  build? : @core.Any,
  preview? : @core.Any,
  optimizeDeps? : @core.Any,
  plugins? : @core.Any,
  publicDir? : String,
  cacheDir? : String,
  resolve? : @core.Any,
  css? : @core.Any,
  json? : @core.Any,
  esbuild? : @core.Any,
  assetsInclude? : @core.Any,
  envDir? : String,
  envPrefix? : String
) -> @core.Any
```

**Example:**
```moonbit
let config = @vite.defineConfig(
  root?=Some("."),
  base?=Some("/"),
  mode?=Some("development"),
  plugins?=Some(@core.any([])),
  server?=Some(@js.from_map({
    "port": @core.any(5173),
    "host": @core.any("0.0.0.0"),
    "open": @core.any(true)
  })),
  build?=Some(@js.from_map({
    "outDir": @core.any("dist"),
    "sourcemap": @core.any(true)
  }))
)
```

#### define_plugin

Create a Vite plugin with typed callback functions:

```moonbit
pub fn define_plugin(
  name : String,
  enforce? : String,
  apply? : String,
  config? : (@core.Any) -> Unit,
  configResolved? : ConfigResolvedHook,
  configureServer? : ConfigureServerHook,
  configurePreviewServer? : (@core.Any) -> Unit,
  transformIndexHtml? : (@core.Any) -> @core.Any,
  handleHotUpdate? : (@core.Any) -> Unit,
  options? : (@core.Any) -> Unit,
  buildStart? : BuildStartHook,
  resolveId? : ResolveIdHook,
  load? : LoadHook,
  transform? : TransformHook,
  buildEnd? : BuildEndHook,
  closeBundle? : () -> Unit
) -> Plugin
```

**Hook Types:**
```moonbit
pub type ResolveIdHook = (String, String?, @core.Any) -> String?
pub type LoadHook = (String) -> String?
pub type TransformHook = (String, String) -> String?
pub type BuildStartHook = (@core.Any) -> Unit
pub type BuildEndHook = (@core.Any?) -> Unit
pub type ConfigResolvedHook = (@core.Any) -> Unit
pub type ConfigureServerHook = (@core.Any) -> Unit
```

**Parameters:**
- `name` (required) - Plugin identifier
- `enforce?` - Order control: `"pre"` or `"post"`
- `apply?` - Conditional activation: `"build"` or `"serve"`
- `config?` - Modify Vite config (hook function)
- `configResolved?` - Called after config is resolved (hook function)
- `configureServer?` - Configure dev server (hook function)
- `configurePreviewServer?` - Configure preview server (hook function)
- `transformIndexHtml?` - Transform HTML (hook function)
- `handleHotUpdate?` - Custom HMR handling (hook function)
- `resolveId?` - Custom module resolution (Rollup hook)
- `load?` - Custom module loading (Rollup hook)
- `transform?` - Transform module code (Rollup hook)
- `buildStart?` - Called at build start (Rollup hook)
- `buildEnd?` - Called at build end (Rollup hook)
- `closeBundle?` - Called when bundle is closed (Rollup hook)

**Example:**
```moonbit
let my_plugin = @vite.define_plugin(
  "my-transform-plugin",
  enforce?=Some("pre"),
  transform?=Some(fn(code, id) {
    // Transform code
    if id.contains(".custom") {
      Some("export default 'transformed'")
    } else {
      None  // Pass through
    }
  })
)

// Build lifecycle example
let lifecycle = @vite.define_plugin(
  "lifecycle-plugin",
  buildStart?=Some(fn(options) {
    println("Build started")
  }),
  buildEnd?=Some(fn(error) {
    match error {
      Some(e) => println("Build failed")
      None => println("Build succeeded")
    }
  })
)
```

#### createServer

Create a development server with labeled arguments:

```moonbit
pub async fn createServer(
  ~root : String = "",
  ~base : String = "",
  ~mode : String = "",
  ~configFile : String = "",
  ~logLevel : String = "",
  ~clearScreen : Bool = true,
  ~server : @core.Any = @js.undefined
) -> ViteDevServer
```

**Options:**
- `root` - Project root directory (default: current directory)
- `base` - Public base path (default: "/")
- `mode` - Development mode (default: "development")
- `configFile` - Path to config file (default: auto-detect)
- `logLevel` - Log level: "info" | "warn" | "error" | "silent"
- `clearScreen` - Clear terminal screen (default: true)
- `server` - Server-specific options as `@core.Any` object

#### build

Build for production:

```moonbit
pub async fn build(
  ~root : String = "",
  ~base : String = "",
  ~mode : String = "",
  ~configFile : String = "",
  ~logLevel : String = "",
  ~clearScreen : Bool = true,
  ~build : @core.Any = @js.undefined
) -> RollupOutput
```

**Options:**
- `root` - Project root directory
- `base` - Public base path
- `mode` - Build mode (default: "production")
- `configFile` - Path to config file
- `logLevel` - Log level
- `clearScreen` - Clear terminal screen
- `build` - Build-specific options as `@core.Any` object

#### preview

Create a preview server for production builds:

```moonbit
pub async fn preview(
  ~root : String = "",
  ~base : String = "",
  ~mode : String = "",
  ~configFile : String = "",
  ~logLevel : String = "",
  ~clearScreen : Bool = true,
  ~preview : @core.Any = @js.undefined
) -> PreviewServer
```

**Options:**
- `root` - Project root directory
- `base` - Public base path
- `mode` - Preview mode (default: "production")
- `configFile` - Path to config file
- `logLevel` - Log level
- `clearScreen` - Clear terminal screen
- `preview` - Preview-specific options as `@core.Any` object

### ViteDevServer Methods

#### listen

Start listening on a port:

```moonbit
pub async fn ViteDevServer::listen(
  self : ViteDevServer,
  ~port : Int = 0,
  ~host : String = ""
) -> ViteDevServer
```

#### close

Close the development server:

```moonbit
pub async fn ViteDevServer::close(self : ViteDevServer) -> Unit
```

#### printUrls

Print server URLs to console:

```moonbit
pub fn ViteDevServer::printUrls(self : ViteDevServer) -> Unit
```

#### restart

Restart the server:

```moonbit
pub async fn ViteDevServer::restart(
  self : ViteDevServer,
  ~forceOptimize : Bool = false
) -> Unit
```

#### resolvedUrls

Get resolved URLs:

```moonbit
pub fn ViteDevServer::resolvedUrls(self : ViteDevServer) -> @core.Any
```

### PreviewServer Methods

#### printUrls

Print server URLs to console:

```moonbit
pub fn PreviewServer::printUrls(self : PreviewServer) -> Unit
```

#### resolvedUrls

Get resolved URLs:

```moonbit
pub fn PreviewServer::resolvedUrls(self : PreviewServer) -> @core.Any
```

## Advanced Configuration

### Custom Server Options

```moonbit
let serverConfig = @js.from_map({
  "port": @core.any(3000),
  "host": @core.any("localhost"),
  "open": @core.any(true),
  "cors": @core.any(true)
})

let server = @vite.createServer(
  root?=Some("."),
  server?=Some(serverConfig)
)!
```

### Custom Build Options

```moonbit
let buildConfig = @js.from_map({
  "outDir": @core.any("dist"),
  "minify": @core.any(true),
  "sourcemap": @core.any(true)
})

let output = @vite.build(
  root?=Some("."),
  build?=Some(buildConfig)
)!
```

## Types

### Config

Internal Vite configuration struct (used for type safety):

```moonbit
pub(all) struct Config {
  root : String?
  base : String?
  mode : String?
  logLevel : String?
  clearScreen : Bool?
  server : @core.Any?
  build : @core.Any?
  preview : @core.Any?
  optimizeDeps : @core.Any?
  plugins : @core.Any?
  publicDir : String?
  cacheDir : String?
  resolve : @core.Any?
  css : @core.Any?
  json : @core.Any?
  esbuild : @core.Any?
  assetsInclude : @core.Any?
  envDir : String?
  envPrefix : String?
} derive(Show)
```

Note: `defineConfig()` returns `@core.Any` directly, so you typically don't need to work with the `Config` struct directly.

### Other Types

- `Plugin` - Vite plugin (alias for `@core.Any`)
- `ViteDevServer` - Development server instance
- `PreviewServer` - Preview server instance
- `ResolvedConfig` - Resolved Vite configuration
- `RollupOutput` - Build output from Rollup

## References

- [Vite JavaScript API](https://ja.vite.dev/guide/api-javascript)
- [Vite Plugin API](https://ja.vite.dev/guide/api-plugin)
- [Vite Configuration](https://ja.vite.dev/config/)
