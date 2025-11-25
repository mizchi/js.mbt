///| npm semver package FFI bindings
/// https://www.npmjs.com/package/semver
/// https://github.com/npm/node-semver

///|
/// Get the semver module instance
fn semver() -> @js.Any {
  @node.require("semver")
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
  let result = semver().call("parse", [version])
  if @js.is_null(result) {
    None
  } else {
    Some(result.get("version") |> @js.identity)
  }
}

///|
/// Return the parsed version, or null if it's not valid
/// https://github.com/npm/node-semver#usage
pub fn valid(version : String) -> String? {
  let result = semver().call("valid", [version])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Return a cleaned version string, or null if invalid
/// https://github.com/npm/node-semver#usage
pub fn clean(version : String) -> String? {
  let result = semver().call("clean", [version])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Compare two versions
/// Returns 0 if v1 == v2, or 1 if v1 is greater, or -1 if v2 is greater
/// https://github.com/npm/node-semver#comparison
pub fn compare(v1 : String, v2 : String) -> Int {
  semver().call("compare", [v1, v2]).cast()
}

///|
/// Compare two versions loosely
/// https://github.com/npm/node-semver#comparison
pub fn compare_loose(v1 : String, v2 : String) -> Int {
  semver().call("compare", [v1, v2, true]).cast()
}

///|
/// v1 > v2
/// https://github.com/npm/node-semver#comparison
pub fn gt(v1 : String, v2 : String) -> Bool {
  semver().call("gt", [v1, v2]).cast()
}

///|
/// v1 >= v2
/// https://github.com/npm/node-semver#comparison
pub fn gte(v1 : String, v2 : String) -> Bool {
  semver().call("gte", [v1, v2]).cast()
}

///|
/// v1 < v2
/// https://github.com/npm/node-semver#comparison
pub fn lt(v1 : String, v2 : String) -> Bool {
  semver().call("lt", [v1, v2]).cast()
}

///|
/// v1 <= v2
/// https://github.com/npm/node-semver#comparison
pub fn lte(v1 : String, v2 : String) -> Bool {
  semver().call("lte", [v1, v2]).cast()
}

///|
/// v1 == v2
/// https://github.com/npm/node-semver#comparison
pub fn eq(v1 : String, v2 : String) -> Bool {
  semver().call("eq", [v1, v2]).cast()
}

///|
/// v1 != v2
/// https://github.com/npm/node-semver#comparison
pub fn neq(v1 : String, v2 : String) -> Bool {
  semver().call("neq", [v1, v2]).cast()
}

///|
/// Check if version satisfies a range
/// https://github.com/npm/node-semver#ranges
pub fn satisfies(version : String, range : String) -> Bool {
  semver().call("satisfies", [version, range]).cast()
}

///|
/// Return the highest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
pub fn max_satisfying(versions : Array[String], range : String) -> String? {
  let result = semver().call("maxSatisfying", [@js.from_array(versions), range])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Return the lowest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
pub fn min_satisfying(versions : Array[String], range : String) -> String? {
  let result = semver().call("minSatisfying", [@js.from_array(versions), range])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
extern "js" fn ffi_max(versions : Array[String]) -> @js.Any =
  #| (versions) => {
  #|   const semver = require('semver');
  #|   return semver.max(versions);
  #| }

///|
/// Return the highest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn max(versions : Array[String]) -> String? {
  let result = ffi_max(versions)
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
extern "js" fn ffi_min(versions : Array[String]) -> @js.Any =
  #| (versions) => {
  #|   const semver = require('semver');
  #|   return semver.min(versions);
  #| }

///|
/// Return the lowest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn min(versions : Array[String]) -> String? {
  let result = ffi_min(versions)
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Return true if the version is greater than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn gtr(version : String, range : String) -> Bool {
  semver().call("gtr", [version, range]).cast()
}

///|
/// Return true if the version is less than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn ltr(version : String, range : String) -> Bool {
  semver().call("ltr", [version, range]).cast()
}

///|
/// Return true if version is outside the range
/// https://github.com/npm/node-semver#ranges
pub fn outside(version : String, range : String, hilo : String) -> Bool {
  semver().call("outside", [version, range, hilo]).cast()
}

///|
/// Return the valid range or null if it's not valid
/// https://github.com/npm/node-semver#ranges
pub fn valid_range(range : String) -> String? {
  let result = semver().call("validRange", [range])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
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
    semver().call("inc", [version, release_type])
  } else {
    semver().call("inc", [version, release_type, identifier])
  }
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Return the major version number
/// https://github.com/npm/node-semver#functions
pub fn major(version : String) -> Int {
  semver().call("major", [version]).cast()
}

///|
/// Return the minor version number
/// https://github.com/npm/node-semver#functions
pub fn minor(version : String) -> Int {
  semver().call("minor", [version]).cast()
}

///|
/// Return the patch version number
/// https://github.com/npm/node-semver#functions
pub fn patch(version : String) -> Int {
  semver().call("patch", [version]).cast()
}

///|
/// Return the prerelease components, or null if none exist
/// https://github.com/npm/node-semver#functions
pub fn prerelease(version : String) -> @js.Any {
  semver().call("prerelease", [version])
}

///|
/// Return the difference between two versions
/// Returns: 'major', 'premajor', 'minor', 'preminor', 'patch', 'prepatch', or 'prerelease'
/// https://github.com/npm/node-semver#functions
pub fn diff(v1 : String, v2 : String) -> String? {
  let result = semver().call("diff", [v1, v2])
  if @js.is_null(result) {
    None
  } else {
    Some(@js.identity(result))
  }
}

///|
/// Sort an array of semver strings
/// https://github.com/npm/node-semver#functions
pub fn sort(versions : Array[String]) -> Array[String] {
  semver().call("sort", [@js.from_array(versions)]) |> @js.identity
}

///|
/// Sort an array of semver strings in reverse order
/// https://github.com/npm/node-semver#functions
pub fn rsort(versions : Array[String]) -> Array[String] {
  semver().call("rsort", [@js.from_array(versions)]) |> @js.identity
}

///|
/// Coerce a string to semver if possible
/// https://github.com/npm/node-semver#coercion
pub fn coerce(version : String) -> String? {
  let result = semver().call("coerce", [version])
  if @js.is_null(result) {
    None
  } else {
    Some(result.get("version") |> @js.identity)
  }
}
