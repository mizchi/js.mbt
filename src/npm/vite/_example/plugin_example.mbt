///|
/// Plugin example
pub fn plugin_example() -> Unit {
  println("=== Vite Plugin Example ===")

  // Create a transform plugin
  let transform_plugin = @vite.define_plugin(
    "my-transform-plugin",
    enforce?=Some("pre"),
    transform?=Some(fn(_code, id) {
      println("Transforming: \{id}")
      // Return transformed code or None to pass through
      if id.contains(".custom") {
        Some("export default 'transformed'")
      } else {
        None
      }
    }),
  )
  println("✓ Transform plugin created")
  let plugin_any : @core.Any = transform_plugin |> @core.any
  let plugin_name = plugin_any["name"]
  println("Plugin name: \{plugin_name}")

  // Create a build lifecycle plugin
  let _lifecycle_plugin = @vite.define_plugin(
    "my-lifecycle-plugin",
    buildStart?=Some(fn(_options) { println("✓ Build started") }),
    buildEnd?=Some(fn(error) {
      match error {
        Some(err) => println("Build failed: \{err}")
        None => println("✓ Build completed successfully")
      }
    }),
  )
  println("✓ Lifecycle plugin created")
}
