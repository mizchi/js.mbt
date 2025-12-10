///| npm semver package FFI bindings
/// https://www.npmjs.com/package/semver
/// https://github.com/npm/node-semver

///|
/// SemVer type represents a parsed semantic version
#external
pub type SemVer

///|
/// Parse a semantic version string
/// Returns null if invalid
/// https://github.com/npm/node-semver#usage
#module("semver")
extern "js" fn ffi_parse(version : String) -> @core.Any = "parse"

///|
pub fn parse(version : String) -> String? {
  let result = ffi_parse(version)
  if @core.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}

///|
/// Return the parsed version, or null if it's not valid
/// https://github.com/npm/node-semver#usage
#module("semver")
extern "js" fn ffi_valid(version : String) -> @core.Any = "valid"

///|
pub fn valid(version : String) -> String? {
  let result = ffi_valid(version)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return a cleaned version string, or null if invalid
/// https://github.com/npm/node-semver#usage
#module("semver")
extern "js" fn ffi_clean(version : String) -> @core.Any = "clean"

///|
pub fn clean(version : String) -> String? {
  let result = ffi_clean(version)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Compare two versions
/// Returns 0 if v1 == v2, or 1 if v1 is greater, or -1 if v2 is greater
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn compare(v1 : String, v2 : String) -> Int = "compare"

///|
/// Compare two versions loosely
/// https://github.com/npm/node-semver#comparison
#module("semver")
extern "js" fn ffi_compare_loose(v1 : String, v2 : String, loose : Bool) -> Int = "compare"

///|
pub fn compare_loose(v1 : String, v2 : String) -> Int {
  ffi_compare_loose(v1, v2, true)
}

///|
/// v1 > v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn gt(v1 : String, v2 : String) -> Bool = "gt"

///|
/// v1 >= v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn gte(v1 : String, v2 : String) -> Bool = "gte"

///|
/// v1 < v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn lt(v1 : String, v2 : String) -> Bool = "lt"

///|
/// v1 <= v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn lte(v1 : String, v2 : String) -> Bool = "lte"

///|
/// v1 == v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn eq(v1 : String, v2 : String) -> Bool = "eq"

///|
/// v1 != v2
/// https://github.com/npm/node-semver#comparison
#module("semver")
pub extern "js" fn neq(v1 : String, v2 : String) -> Bool = "neq"

///|
/// Check if version satisfies a range
/// https://github.com/npm/node-semver#ranges
#module("semver")
pub extern "js" fn satisfies(version : String, range : String) -> Bool = "satisfies"

///|
/// Return the highest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
#module("semver")
extern "js" fn ffi_max_satisfying(
  versions : Array[String],
  range : String,
) -> @core.Any = "maxSatisfying"

///|
pub fn max_satisfying(versions : Array[String], range : String) -> String? {
  let result = ffi_max_satisfying(versions, range)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the lowest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
#module("semver")
extern "js" fn ffi_min_satisfying(
  versions : Array[String],
  range : String,
) -> @core.Any = "minSatisfying"

///|
pub fn min_satisfying(versions : Array[String], range : String) -> String? {
  let result = ffi_min_satisfying(versions, range)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the highest version in the list
/// https://github.com/npm/node-semver#ranges
#module("semver")
extern "js" fn ffi_max(versions : Array[String]) -> @core.Any = "max"

///|
pub fn max(versions : Array[String]) -> String? {
  let result = ffi_max(versions)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the lowest version in the list
/// https://github.com/npm/node-semver#ranges
#module("semver")
extern "js" fn ffi_min(versions : Array[String]) -> @core.Any = "min"

///|
pub fn min(versions : Array[String]) -> String? {
  let result = ffi_min(versions)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return true if the version is greater than all the versions in the range
/// https://github.com/npm/node-semver#ranges
#module("semver")
pub extern "js" fn gtr(version : String, range : String) -> Bool = "gtr"

///|
/// Return true if the version is less than all the versions in the range
/// https://github.com/npm/node-semver#ranges
#module("semver")
pub extern "js" fn ltr(version : String, range : String) -> Bool = "ltr"

///|
/// Return true if version is outside the range
/// https://github.com/npm/node-semver#ranges
#module("semver")
pub extern "js" fn outside(
  version : String,
  range : String,
  hilo : String,
) -> Bool = "outside"

///|
/// Return the valid range or null if it's not valid
/// https://github.com/npm/node-semver#ranges
#module("semver")
extern "js" fn ffi_valid_range(range : String) -> @core.Any = "validRange"

///|
pub fn valid_range(range : String) -> String? {
  let result = ffi_valid_range(range)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Increment a version
/// release_type: major, premajor, minor, preminor, patch, prepatch, or prerelease
/// https://github.com/npm/node-semver#functions
#module("semver")
extern "js" fn ffi_inc(version : String, release_type : String) -> @core.Any = "inc"

///|
#module("semver")
extern "js" fn ffi_inc_with_identifier(
  version : String,
  release_type : String,
  identifier : String,
) -> @core.Any = "inc"

///|
pub fn inc(
  version : String,
  release_type : String,
  identifier? : String = "",
) -> String? {
  let result = if identifier == "" {
    ffi_inc(version, release_type)
  } else {
    ffi_inc_with_identifier(version, release_type, identifier)
  }
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the major version number
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn major(version : String) -> Int = "major"

///|
/// Return the minor version number
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn minor(version : String) -> Int = "minor"

///|
/// Return the patch version number
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn patch(version : String) -> Int = "patch"

///|
/// Return the prerelease components, or null if none exist
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn prerelease(version : String) -> @core.Any = "prerelease"

///|
/// Return the difference between two versions
/// Returns: 'major', 'premajor', 'minor', 'preminor', 'patch', 'prepatch', or 'prerelease'
/// https://github.com/npm/node-semver#functions
#module("semver")
extern "js" fn ffi_diff(v1 : String, v2 : String) -> @core.Any = "diff"

///|
pub fn diff(v1 : String, v2 : String) -> String? {
  let result = ffi_diff(v1, v2)
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Sort an array of semver strings
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn sort(versions : Array[String]) -> Array[String] = "sort"

///|
/// Sort an array of semver strings in reverse order
/// https://github.com/npm/node-semver#functions
#module("semver")
pub extern "js" fn rsort(versions : Array[String]) -> Array[String] = "rsort"

///|
/// Coerce a string to semver if possible
/// https://github.com/npm/node-semver#coercion
#module("semver")
extern "js" fn ffi_coerce(version : String) -> @core.Any = "coerce"

///|
pub fn coerce(version : String) -> String? {
  let result = ffi_coerce(version)
  if @core.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}
