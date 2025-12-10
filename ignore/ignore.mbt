///|
/// ignore bindings for MoonBit
/// https://github.com/kaelzhang/node-ignore
///
/// A manager, filter and parser for .gitignore rules.

///| Types

///|
/// Ignore instance for managing gitignore-style patterns
#external
pub type Ignore

///|
pub extern "js" fn Ignore::as_any(self : Ignore) -> @core.Any =
  #| (x) => x

///|
/// Test result from test() method
#external
pub type TestResult

///|
pub extern "js" fn TestResult::as_any(self : TestResult) -> @core.Any =
  #| (x) => x

///| FFI Functions

///|
extern "js" fn ffi_ignore() -> Ignore =
  #| () => require('ignore')()

///|
extern "js" fn ffi_ignore_with_options(options : @core.Any) -> Ignore =
  #| (options) => require('ignore')(options)

///|
extern "js" fn ffi_add(ig : Ignore, pattern : String) -> Ignore =
  #| (ig, pattern) => ig.add(pattern)

///|
extern "js" fn ffi_add_array(ig : Ignore, patterns : @core.Any) -> Ignore =
  #| (ig, patterns) => ig.add(patterns)

///|
extern "js" fn ffi_filter(ig : Ignore, paths : @core.Any) -> @core.Any =
  #| (ig, paths) => ig.filter(paths)

///|
extern "js" fn ffi_ignores(ig : Ignore, pathname : String) -> Bool =
  #| (ig, pathname) => ig.ignores(pathname)

///|
extern "js" fn ffi_create_filter(ig : Ignore) -> @core.Any =
  #| (ig) => ig.createFilter()

///|
extern "js" fn ffi_test(ig : Ignore, pathname : String) -> TestResult =
  #| (ig, pathname) => ig.test(pathname)

///|
#module("ignore")
extern "js" fn ffi_is_path_valid(pathname : String) -> Bool = "isPathValid"

///| TestResult accessors

///|
extern "js" fn ffi_test_result_ignored(result : TestResult) -> Bool =
  #| (result) => result.ignored

///|
extern "js" fn ffi_test_result_unignored(result : TestResult) -> Bool =
  #| (result) => result.unignored

///|
extern "js" fn ffi_test_result_rule(result : TestResult) -> @core.Any =
  #| (result) => result.rule

///| Constructor

///|
/// Create a new Ignore instance
pub fn ignore_module(ignorecase? : Bool, allowRelativePaths? : Bool) -> Ignore {
  if ignorecase is None && allowRelativePaths is None {
    return ffi_ignore()
  }
  let options = @core.new_object()
  if ignorecase is Some(v) {
    options["ignorecase"] = @core.any(v)
  }
  if allowRelativePaths is Some(v) {
    options["allowRelativePaths"] = @core.any(v)
  }
  ffi_ignore_with_options(options)
}

///| Ignore Methods

///|
/// Add a single pattern
pub fn Ignore::add(self : Ignore, pattern : String) -> Ignore {
  ffi_add(self, pattern)
}

///|
/// Add multiple patterns
pub fn Ignore::addPatterns(self : Ignore, patterns : Array[String]) -> Ignore {
  ffi_add_array(self, @core.any(patterns))
}

///|
/// Add patterns from a string (like .gitignore content)
pub fn Ignore::addFromContent(self : Ignore, content : String) -> Ignore {
  // Split by newlines and add each line
  ffi_add(self, content)
}

///|
/// Filter paths, returning only non-ignored paths
pub fn Ignore::filter(self : Ignore, paths : Array[String]) -> Array[String] {
  ffi_filter(self, @core.any(paths)).cast()
}

///|
/// Check if a pathname should be ignored
pub fn Ignore::ignores(self : Ignore, pathname : String) -> Bool {
  ffi_ignores(self, pathname)
}

///|
/// Create a filter function for use with Array.filter
pub fn Ignore::createFilter(self : Ignore) -> @core.Any {
  ffi_create_filter(self)
}

///|
/// Test a pathname and get detailed result
pub fn Ignore::testPath(self : Ignore, pathname : String) -> TestResult {
  ffi_test(self, pathname)
}

///| TestResult Methods

///|
/// Check if the path was ignored
pub fn TestResult::ignored(self : TestResult) -> Bool {
  ffi_test_result_ignored(self)
}

///|
/// Check if the path was unignored (by negation pattern)
pub fn TestResult::unignored(self : TestResult) -> Bool {
  ffi_test_result_unignored(self)
}

///|
/// Get the matching rule (if any)
pub fn TestResult::rule(self : TestResult) -> @core.Any {
  ffi_test_result_rule(self)
}

///| Static Methods

///|
/// Check if a pathname is valid (relative path format)
pub fn isPathValid(pathname : String) -> Bool {
  ffi_is_path_valid(pathname)
}
