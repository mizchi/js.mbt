///|
/// defineConfig example
pub fn config_example() -> Unit {
  println("=== defineConfig Example ===")

  // Create configuration using defineConfig with labeled arguments
  // This returns a @js.Any object directly
  let config = @vite.defineConfig(
    root?=Some("."),
    base?=Some("/"),
    mode?=Some("development"),
    server?=Some(
      @mbtconv.from_map({
        "port": @nostd.any(3000),
        "host": @nostd.any("localhost"),
        "open": @nostd.any(false),
      }).cast(),
    ),
    build?=Some(
      @mbtconv.from_map({
        "outDir": @nostd.any("dist"),
        "sourcemap": @nostd.any(true),
        "minify": @nostd.any(true),
      }).cast(),
    ),
  )
  println("✓ Config created with defineConfig")
  println("Config: \{config}")
}
