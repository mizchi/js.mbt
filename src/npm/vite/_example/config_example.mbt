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
      @js.from_entries([("port", 3000), ("host", "localhost"), ("open", false)]),
    ),
    build?=Some(
      @js.from_entries([
        ("outDir", "dist"),
        ("sourcemap", true),
        ("minify", true),
      ]),
    ),
  )
  println("✓ Config created with defineConfig")
  println("Config: \{config}")
}
