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
      @js.from_map({
        "port": @js.any(3000),
        "host": @js.any("localhost"),
        "open": @js.any(false),
      }),
    ),
    build?=Some(
      @js.from_map({
        "outDir": @js.any("dist"),
        "sourcemap": @js.any(true),
        "minify": @js.any(true),
      }),
    ),
  )
  println("✓ Config created with defineConfig")
  println("Config: \{config}")
}
