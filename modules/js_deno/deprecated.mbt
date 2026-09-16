// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `Command(..)` constructor.
#deprecated("use `Command(..)` instead")
pub fn Command::new(
  program : String,
  args? : Array[String],
  cwd? : String,
  env? : @core.Any,
  stdin? : String,
  stdout? : String,
  stderr? : String,
) -> Command {
  Command(program, args?, cwd?, env?, stdin?, stdout?, stderr?)
}
