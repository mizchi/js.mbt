// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `File(..)` constructor.
#deprecated("use `File(..)` instead")
pub fn File::new(
  data : Array[String],
  filename : String,
  content_type? : String,
  last_modified? : Int,
) -> File {
  File(data, filename, content_type?, last_modified?)
}

///|
/// Deprecated alias for the `FileReader(..)` constructor.
#deprecated("use `FileReader(..)` instead")
pub fn FileReader::new() -> FileReader {
  FileReader()
}
