// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Worker(..)` constructor.
#deprecated("use `Worker(..)` instead")
pub fn Worker::new(
  filename : String,
  workerData? : @core.Any,
  env? : @core.Any,
  stdin? : Bool,
  stdout? : Bool,
  stderr? : Bool,
  execArgv? : Array[String],
  resourceLimits? : @core.Any,
) -> Worker {
  Worker(
    filename,
    workerData?,
    env?,
    stdin?,
    stdout?,
    stderr?,
    execArgv?,
    resourceLimits?,
  )
}
