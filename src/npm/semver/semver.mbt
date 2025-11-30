///| npm semver package FFI bindings
/// https://www.npmjs.com/package/semver
/// https://github.com/npm/node-semver

///|
/// Get the semver module instance
extern "js" fn semver() -> @nostd.Any =
  #| () => require("semver")

///|
/// SemVer type represents a parsed semantic version
#external
pub type SemVer

///|
/// Parse a semantic version string
/// Returns null if invalid
/// https://github.com/npm/node-semver#usage
pub fn parse(version : String) -> String? {
  let result = semver()._call("parse", [@nostd.any(version)])
  if @nostd.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}

///|
/// Return the parsed version, or null if it's not valid
/// https://github.com/npm/node-semver#usage
pub fn valid(version : String) -> String? {
  let result = semver()._call("valid", [@nostd.any(version)])
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return a cleaned version string, or null if invalid
/// https://github.com/npm/node-semver#usage
pub fn clean(version : String) -> String? {
  let result = semver()._call("clean", [@nostd.any(version)])
  if @nostd.is_null(result) {
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
  semver()._call("compare", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// Compare two versions loosely
/// https://github.com/npm/node-semver#comparison
pub fn compare_loose(v1 : String, v2 : String) -> Int {
  semver()
  ._call("compare", [@nostd.any(v1), @nostd.any(v2), @nostd.any(true)])
  .cast()
}

///|
/// v1 > v2
/// https://github.com/npm/node-semver#comparison
pub fn gt(v1 : String, v2 : String) -> Bool {
  semver()._call("gt", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// v1 >= v2
/// https://github.com/npm/node-semver#comparison
pub fn gte(v1 : String, v2 : String) -> Bool {
  semver()._call("gte", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// v1 < v2
/// https://github.com/npm/node-semver#comparison
pub fn lt(v1 : String, v2 : String) -> Bool {
  semver()._call("lt", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// v1 <= v2
/// https://github.com/npm/node-semver#comparison
pub fn lte(v1 : String, v2 : String) -> Bool {
  semver()._call("lte", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// v1 == v2
/// https://github.com/npm/node-semver#comparison
pub fn eq(v1 : String, v2 : String) -> Bool {
  semver()._call("eq", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// v1 != v2
/// https://github.com/npm/node-semver#comparison
pub fn neq(v1 : String, v2 : String) -> Bool {
  semver()._call("neq", [@nostd.any(v1), @nostd.any(v2)]).cast()
}

///|
/// Check if version satisfies a range
/// https://github.com/npm/node-semver#ranges
pub fn satisfies(version : String, range : String) -> Bool {
  semver()._call("satisfies", [@nostd.any(version), @nostd.any(range)]).cast()
}

///|
/// Return the highest version in the list that satisfies the range, or null if none of them do
/// https://github.com/npm/node-semver#ranges
pub fn max_satisfying(versions : Array[String], range : String) -> String? {
  let result = semver()._call("maxSatisfying", [
    @nostd.any(versions),
    @nostd.any(range),
  ])
  if @nostd.is_null(result) {
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
    @nostd.any(versions),
    @nostd.any(range),
  ])
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_max(versions : Array[String]) -> @nostd.Any =
  #| (versions) => {
  #|   const semver = require('semver');
  #|   return semver.max(versions);
  #| }

///|
/// Return the highest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn max(versions : Array[String]) -> String? {
  let result = ffi_max(versions)
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_min(versions : Array[String]) -> @nostd.Any =
  #| (versions) => {
  #|   const semver = require('semver');
  #|   return semver.min(versions);
  #| }

///|
/// Return the lowest version in the list
/// https://github.com/npm/node-semver#ranges
pub fn min(versions : Array[String]) -> String? {
  let result = ffi_min(versions)
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return true if the version is greater than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn gtr(version : String, range : String) -> Bool {
  semver()._call("gtr", [@nostd.any(version), @nostd.any(range)]).cast()
}

///|
/// Return true if the version is less than all the versions in the range
/// https://github.com/npm/node-semver#ranges
pub fn ltr(version : String, range : String) -> Bool {
  semver()._call("ltr", [@nostd.any(version), @nostd.any(range)]).cast()
}

///|
/// Return true if version is outside the range
/// https://github.com/npm/node-semver#ranges
pub fn outside(version : String, range : String, hilo : String) -> Bool {
  semver()
  ._call("outside", [@nostd.any(version), @nostd.any(range), @nostd.any(hilo)])
  .cast()
}

///|
/// Return the valid range or null if it's not valid
/// https://github.com/npm/node-semver#ranges
pub fn valid_range(range : String) -> String? {
  let result = semver()._call("validRange", [@nostd.any(range)])
  if @nostd.is_null(result) {
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
    semver()._call("inc", [@nostd.any(version), @nostd.any(release_type)])
  } else {
    semver()._call("inc", [
      @nostd.any(version),
      @nostd.any(release_type),
      @nostd.any(identifier),
    ])
  }
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Return the major version number
/// https://github.com/npm/node-semver#functions
pub fn major(version : String) -> Int {
  semver()._call("major", [@nostd.any(version)]).cast()
}

///|
/// Return the minor version number
/// https://github.com/npm/node-semver#functions
pub fn minor(version : String) -> Int {
  semver()._call("minor", [@nostd.any(version)]).cast()
}

///|
/// Return the patch version number
/// https://github.com/npm/node-semver#functions
pub fn patch(version : String) -> Int {
  semver()._call("patch", [@nostd.any(version)]).cast()
}

///|
/// Return the prerelease components, or null if none exist
/// https://github.com/npm/node-semver#functions
pub fn prerelease(version : String) -> @nostd.Any {
  semver()._call("prerelease", [@nostd.any(version)])
}

///|
/// Return the difference between two versions
/// Returns: 'major', 'premajor', 'minor', 'preminor', 'patch', 'prepatch', or 'prerelease'
/// https://github.com/npm/node-semver#functions
pub fn diff(v1 : String, v2 : String) -> String? {
  let result = semver()._call("diff", [@nostd.any(v1), @nostd.any(v2)])
  if @nostd.is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Sort an array of semver strings
/// https://github.com/npm/node-semver#functions
pub fn sort(versions : Array[String]) -> Array[String] {
  semver()._call("sort", [@nostd.any(versions)]).cast()
}

///|
/// Sort an array of semver strings in reverse order
/// https://github.com/npm/node-semver#functions
pub fn rsort(versions : Array[String]) -> Array[String] {
  semver()._call("rsort", [@nostd.any(versions)]).cast()
}

///|
/// Coerce a string to semver if possible
/// https://github.com/npm/node-semver#coercion
pub fn coerce(version : String) -> String? {
  let result = semver()._call("coerce", [@nostd.any(version)])
  if @nostd.is_null(result) {
    None
  } else {
    Some(result["version"].cast())
  }
}
