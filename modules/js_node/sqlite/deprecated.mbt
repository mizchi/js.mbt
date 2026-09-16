// Deprecated aliases kept for source compatibility with 0.13.x.
// MoonBit's canonical constructor is `Type::Type(..)`, called as `Type(..)`;
// these `::new` forms will be removed in a future release.

///|
/// Deprecated alias for the `DatabaseSync(..)` constructor.
#deprecated("use `DatabaseSync(..)` instead")
pub fn DatabaseSync::new(
  path : String,
  open? : Bool,
  readOnly? : Bool,
  enableForeignKeyConstraints? : Bool,
  allowExtension? : Bool,
  timeout? : Int,
  readBigInts? : Bool,
  returnArrays? : Bool,
  allowBareNamedParameters? : Bool,
  allowUnknownNamedParameters? : Bool,
  defensive? : Bool,
) -> DatabaseSync {
  DatabaseSync(
    path,
    open?,
    readOnly?,
    enableForeignKeyConstraints?,
    allowExtension?,
    timeout?,
    readBigInts?,
    returnArrays?,
    allowBareNamedParameters?,
    allowUnknownNamedParameters?,
    defensive?,
  )
}
