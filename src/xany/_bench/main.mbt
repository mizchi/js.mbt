///|
extern "js" fn performance_now() -> Double =
  #| () => performance.now()

///|
extern "js" fn console_log(msg : String) -> Unit =
  #| (msg) => console.log(msg)

///|
fn bench(name : String, iterations : Int, f : () -> Unit) -> Unit {
  // Warmup
  for i = 0; i < 100; i = i + 1 {
    f()
  }
  let start = performance_now()
  for i = 0; i < iterations; i = i + 1 {
    f()
  }
  let end = performance_now()
  let elapsed = end - start
  let ops_per_sec = iterations.to_double() / (elapsed / 1000.0)
  console_log(
    name +
    ": " +
    elapsed.to_string() +
    "ms (" +
    ops_per_sec.to_string() +
    " ops/sec)",
  )
}

///|
fn main {
  let iterations = 100000
  console_log("=== xany vs @core.Any Benchmark ===")
  console_log("Iterations: " + iterations.to_string())
  console_log("")

  // --- Get property benchmark ---
  console_log("--- Get Property (Math.PI) ---")
  bench("@core.Any", iterations, fn() {
    let global = @core.global_this()
    let math = global["Math"]
    let _ = math["PI"]

  })
  bench("@xany.Xany", iterations, fn() {
    let global = @xany.global_this()
    let math = global["Math"]
    let _ = math["PI"]

  })
  console_log("")

  // --- Call method benchmark ---
  console_log("--- Call Method (Math.sqrt) ---")
  bench("@core.Any", iterations, fn() {
    let global = @core.global_this()
    let math = global["Math"]
    let _ = math._call("sqrt", [@core.any(16.0)])

  })
  bench("@xany.Xany", iterations, fn() {
    let global = @xany.global_this()
    let math = global["Math"]
    let _ = math._call("sqrt", [@xany.Xany::of(16.0)])

  })
  console_log("")

  // --- Set property benchmark ---
  console_log("--- Set Property ---")
  bench("@core.Any", iterations, fn() {
    let global = @core.global_this()
    let obj = global._call("Object", [])
    obj["x"] = @core.any(42)
  })
  bench("@xany.Xany", iterations, fn() {
    let global = @xany.global_this()
    let obj = global._call("Object", [])
    obj["x"] = @xany.Xany::of(42)
  })
  console_log("")

  // --- Invoke function benchmark ---
  console_log("--- Invoke Function (Math.random) ---")
  bench("@core.Any", iterations, fn() {
    let global = @core.global_this()
    let math = global["Math"]
    let random_fn = math["random"]
    let _ = random_fn._invoke([])

  })
  bench("@xany.Xany", iterations, fn() {
    let global = @xany.global_this()
    let math = global["Math"]
    let random_fn = math["random"]
    let _ = random_fn._invoke([])

  })
  console_log("")
  console_log("=== Benchmark Complete ===")
}
