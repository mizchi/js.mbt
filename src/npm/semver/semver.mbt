///| npm semver package FFI bindings
/// https://www.npmjs.com/package/semver
/// https://github.com/npm/node-semver

///|
/// Dynamic import for semver module
extern "js" fn import_semver() -> @core.Promise[@core.Any] =
  #|() => import("semver")

///|
extern "js" fn get_semver_global() -> @core.Any =
  #|() => globalThis.__semver

///|
extern "js" fn set_semver_global(semver : @core.Any) -> Unit =
  #|(semver) => { globalThis.__semver = semver; }

///|
/// Initialize semver globals asynchronously (recommended for ESM)
pub async fn init_global() -> Unit {
  if @core.is_nullish(get_semver_global()) {
    let mod = import_semver().wait()
    set_semver_global(mod)
  }
}

///|
/// Initialize semver globals synchronously (for testing with require)
pub fn init_semver(semver_module : @core.Any) -> Unit {
  set_semver_global(semver_module)
}

///|
/// Get the semver module instance
fn semver() -> @core.Any {
  get_semver_global()
}

///|
/// SemVer type represents a parsed semantic version
#external
pub type SemVer

///|
/// Parse a semantic version string
/// Returns null if invalid
/// https://github.com/npm/node-semver#usage
pub fn parse(version : String) -> String? {
  let result = semver()._call("parse", [@core.any(version)])
  if @core.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}

///|
/// Return the parsed version, or null if it's not valid
/// https://github.com/npm/node-semver#usage
pub fn valid(version : String) -> String? {
  let result = semver()._call("valid", [@core.any(version)])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return a cleaned version string, or null if invalid
/// https://github.com/npm/node-semver#usage
pub fn clean(version : String) -> String? {
  let result = semver()._call("clean", [@core.any(version)])
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
pub fn compare(v1 : String, v2 : String) -> Int {
  semver()._call("compare", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// Compare two versions loosely
/// https://github.com/npm/node-semver#comparison
pub fn compare_loose(v1 : String, v2 : String) -> Int {
  semver()
  ._call("compare", [@core.any(v1), @core.any(v2), @core.any(true)])
  .cast()
}

///|
/// v1 > v2
/// https://github.com/npm/node-semver#comparison
pub fn gt(v1 : String, v2 : String) -> Bool {
  semver()._call("gt", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// v1 >= v2
/// https://github.com/npm/node-semver#comparison
pub fn gte(v1 : String, v2 : String) -> Bool {
  semver()._call("gte", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// v1 < v2
/// https://github.com/npm/node-semver#comparison
pub fn lt(v1 : String, v2 : String) -> Bool {
  semver()._call("lt", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// v1 <= v2
/// https://github.com/npm/node-semver#comparison
pub fn lte(v1 : String, v2 : String) -> Bool {
  semver()._call("lte", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// v1 == v2
/// https://github.com/npm/node-semver#comparison
pub fn eq(v1 : String, v2 : String) -> Bool {
  semver()._call("eq", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// v1 != v2
/// https://github.com/npm/node-semver#comparison
pub fn neq(v1 : String, v2 : String) -> Bool {
  semver()._call("neq", [@core.any(v1), @core.any(v2)]).cast()
}

///|
/// Check if version satisfies a range
/// https://github.com/npm/node-semver#ranges
pub fn satisfies(version : String, range : String) -> Bool {
  semver()._call("satisfies", [@core.any(version), @core.any(range)]).cast()
}

///|
/// Return the highest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
pub fn max_satisfying(versions : Array[String], range : String) -> String? {
  let result = semver()._call("maxSatisfying", [
    @core.any(versions),
    @core.any(range),
  ])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the lowest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
pub fn min_satisfying(versions : Array[String], range : String) -> String? {
  let result = semver()._call("minSatisfying", [
    @core.any(versions),
    @core.any(range),
  ])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the highest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn max(versions : Array[String]) -> String? {
  let result = semver()._call("max", [@core.any(versions)])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the lowest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn min(versions : Array[String]) -> String? {
  let result = semver()._call("min", [@core.any(versions)])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return true if the version is greater than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn gtr(version : String, range : String) -> Bool {
  semver()._call("gtr", [@core.any(version), @core.any(range)]).cast()
}

///|
/// Return true if the version is less than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn ltr(version : String, range : String) -> Bool {
  semver()._call("ltr", [@core.any(version), @core.any(range)]).cast()
}

///|
/// Return true if version is outside the range
/// https://github.com/npm/node-semver#ranges
pub fn outside(version : String, range : String, hilo : String) -> Bool {
  semver()
  ._call("outside", [@core.any(version), @core.any(range), @core.any(hilo)])
  .cast()
}

///|
/// Return the valid range or null if it's not valid
/// https://github.com/npm/node-semver#ranges
pub fn valid_range(range : String) -> String? {
  let result = semver()._call("validRange", [@core.any(range)])
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
pub fn inc(
  version : String,
  release_type : String,
  identifier? : String = "",
) -> String? {
  let result = if identifier == "" {
    semver()._call("inc", [@core.any(version), @core.any(release_type)])
  } else {
    semver()._call("inc", [
      @core.any(version),
      @core.any(release_type),
      @core.any(identifier),
    ])
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
pub fn major(version : String) -> Int {
  semver()._call("major", [@core.any(version)]).cast()
}

///|
/// Return the minor version number
/// https://github.com/npm/node-semver#functions
pub fn minor(version : String) -> Int {
  semver()._call("minor", [@core.any(version)]).cast()
}

///|
/// Return the patch version number
/// https://github.com/npm/node-semver#functions
pub fn patch(version : String) -> Int {
  semver()._call("patch", [@core.any(version)]).cast()
}

///|
/// Return the prerelease components, or null if none exist
/// https://github.com/npm/node-semver#functions
pub fn prerelease(version : String) -> @core.Any {
  semver()._call("prerelease", [@core.any(version)])
}

///|
/// Return the difference between two versions
/// Returns: 'major', 'premajor', 'minor', 'preminor', 'patch', 'prepatch', or 'prerelease'
/// https://github.com/npm/node-semver#functions
pub fn diff(v1 : String, v2 : String) -> String? {
  let result = semver()._call("diff", [@core.any(v1), @core.any(v2)])
  if @core.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Sort an array of semver strings
/// https://github.com/npm/node-semver#functions
pub fn sort(versions : Array[String]) -> Array[String] {
  semver()._call("sort", [@core.any(versions)]).cast()
}

///|
/// Sort an array of semver strings in reverse order
/// https://github.com/npm/node-semver#functions
pub fn rsort(versions : Array[String]) -> Array[String] {
  semver()._call("rsort", [@core.any(versions)]).cast()
}

///|
/// Coerce a string to semver if possible
/// https://github.com/npm/node-semver#coercion
pub fn coerce(version : String) -> String? {
  let result = semver()._call("coerce", [@core.any(version)])
  if @core.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}
