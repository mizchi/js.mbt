///| npm minimatch package FFI bindings
/// https://www.npmjs.com/package/minimatch
/// https://github.com/isaacs/minimatch
///
/// A glob matcher in JavaScript, used internally by npm.
/// Works by converting glob expressions into JavaScript RegExp objects.

///|
/// Get the minimatch module instance
fn minimatch_mod() -> @js.Any {
  @node.require("minimatch")
}

///|
/// Minimatch options
pub(all) struct MinimatchOptions {
  /// Dump a ton of stuff to stderr
  debug : Bool
  /// Do not expand {a,b} and {1..3} brace sets
  nobrace : Bool
  /// Disable ** matching against multiple folder names
  noglobstar : Bool
  /// Allow patterns to match filenames starting with a period
  dot : Bool
  /// When a match is not found, return the pattern itself (for match())
  nonull : Bool
  /// Match basename of path if pattern has no slashes
  match_base : Bool
  /// Suppress treating # at start as comment
  nocomment : Bool
  /// Suppress treating leading ! as negation
  nonegate : Bool
  /// Returns from negate expressions as if not negated
  flip_negate : Bool
  /// Compare partial path to pattern
  partial : Bool
  /// Report hasMagic() true for brace expansion
  magical_braces : Bool
  /// Use \ as path separator escape on Windows
  windows_paths_no_escape : Bool
  /// Perform case-insensitive match
  nocase : Bool
}

///|
/// Create default minimatch options
pub fn MinimatchOptions::default() -> MinimatchOptions {
  {
    debug: false,
    nobrace: false,
    noglobstar: false,
    dot: false,
    nonull: false,
    match_base: false,
    nocomment: false,
    nonegate: false,
    flip_negate: false,
    partial: false,
    magical_braces: false,
    windows_paths_no_escape: false,
    nocase: false,
  }
}

///|
/// Convert options to JS object
fn options_to_js(options : MinimatchOptions) -> @js.Any {
  let obj = @js.Object::new()
  if options.debug {
    obj.set("debug", @js.any(true))
  }
  if options.nobrace {
    obj.set("nobrace", @js.any(true))
  }
  if options.noglobstar {
    obj.set("noglobstar", @js.any(true))
  }
  if options.dot {
    obj.set("dot", @js.any(true))
  }
  if options.nonull {
    obj.set("nonull", @js.any(true))
  }
  if options.match_base {
    obj.set("matchBase", @js.any(true))
  }
  if options.nocomment {
    obj.set("nocomment", @js.any(true))
  }
  if options.nonegate {
    obj.set("nonegate", @js.any(true))
  }
  if options.flip_negate {
    obj.set("flipNegate", @js.any(true))
  }
  if options.partial {
    obj.set("partial", @js.any(true))
  }
  if options.magical_braces {
    obj.set("magicalBraces", @js.any(true))
  }
  if options.windows_paths_no_escape {
    obj.set("windowsPathsNoEscape", @js.any(true))
  }
  if options.nocase {
    obj.set("nocase", @js.any(true))
  }
  obj
}

///|
/// Test a path against a pattern
///
/// Example:
/// ```moonbit no-check
/// minimatch("bar.foo", "*.foo") // true
/// minimatch("bar.foo", "*.bar") // false
/// ```
pub fn minimatch(path : String, pattern : String) -> Bool {
  minimatch_mod().call2("minimatch", path, pattern).cast()
}

///|
/// Test a path against a pattern with options
pub fn minimatch_with_options(
  path : String,
  pattern : String,
  options : MinimatchOptions,
) -> Bool {
  minimatch_mod()
  .call("minimatch", [path, pattern, options_to_js(options)])
  .cast()
}

///|
/// Match against a list of files
/// Returns matching files, or pattern itself if nonull is set and nothing matches
pub fn match_list(list : Array[String], pattern : String) -> Array[String] {
  minimatch_mod().call("match", [@js.from_array(list), pattern]) |> @js.identity
}

///|
/// Match against a list of files with options
pub fn match_list_with_options(
  list : Array[String],
  pattern : String,
  options : MinimatchOptions,
) -> Array[String] {
  minimatch_mod().call("match", [
    @js.from_array(list),
    pattern,
    options_to_js(options),
  ])
  |> @js.identity
}

///|
/// Create a filter function suitable for Array.filter
/// Returns the filter function
pub fn filter(pattern : String) -> (@js.Any) -> Bool {
  let filter_fn = minimatch_mod().call1("filter", pattern)
  fn(item : @js.Any) -> Bool { filter_fn.call1("call", item).cast() }
}

///|
/// Create a filter function with options
pub fn filter_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> (@js.Any) -> Bool {
  let filter_fn = minimatch_mod().call("filter", [
    pattern,
    options_to_js(options),
  ])
  fn(item : @js.Any) -> Bool { filter_fn.call1("call", item).cast() }
}

///|
/// Make a regular expression from the pattern
/// Returns the RegExp object or None if pattern is invalid
pub fn make_re(pattern : String) -> @js.Any? {
  let result = minimatch_mod().call1("makeRe", pattern)
  if @js.is_nullish(result) {
    None
  } else {
    Some(result)
  }
}

///|
/// Make a regular expression from the pattern with options
pub fn make_re_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> @js.Any? {
  let result = minimatch_mod().call("makeRe", [pattern, options_to_js(options)])
  if @js.is_nullish(result) {
    None
  } else {
    Some(result)
  }
}

///|
/// Escape all magic characters in a glob pattern
/// So it will only match literal strings
pub fn escape(pattern : String) -> String {
  minimatch_mod().call1("escape", pattern).cast()
}

///|
/// Escape with options (for windowsPathsNoEscape support)
pub fn escape_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> String {
  minimatch_mod().call("escape", [pattern, options_to_js(options)]).cast()
}

///|
/// Un-escape a glob string that may contain escaped characters
pub fn unescape(pattern : String) -> String {
  minimatch_mod().call1("unescape", pattern).cast()
}

///|
/// Un-escape with options
pub fn unescape_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> String {
  minimatch_mod().call("unescape", [pattern, options_to_js(options)]).cast()
}

///|
/// Minimatch class instance for reusable pattern matching
pub struct Minimatch(@js.Any)

///|
extern "js" fn ffi_new_minimatch(pattern : String) -> @js.Any =
  #|(pattern) => {
  #|  const { Minimatch } = require('minimatch');
  #|  return new Minimatch(pattern);
  #|}

///|
extern "js" fn ffi_new_minimatch_with_options(
  pattern : String,
  options : @js.Any,
) -> @js.Any =
  #|(pattern, options) => {
  #|  const { Minimatch } = require('minimatch');
  #|  return new Minimatch(pattern, options);
  #|}

///|
/// Create a new Minimatch instance
pub fn Minimatch::new(pattern : String) -> Minimatch {
  ffi_new_minimatch(pattern)
}

///|
/// Create a new Minimatch instance with options
pub fn Minimatch::new_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> Minimatch {
  ffi_new_minimatch_with_options(pattern, options_to_js(options))
}

///|
/// Get the pattern string
pub fn Minimatch::pattern(self : Minimatch) -> String {
  self.0.get("pattern").cast()
}

///|
/// Test if a path matches this pattern
pub fn Minimatch::match_(self : Minimatch, path : String) -> Bool {
  self.0.call1("match", path).cast()
}

///|
/// Check if the pattern has any magic glob characters
pub fn Minimatch::has_magic(self : Minimatch) -> Bool {
  self.0.call0("hasMagic").cast()
}

///|
/// Get the generated RegExp (may be false if pattern is invalid)
pub fn Minimatch::regexp(self : Minimatch) -> @js.Any? {
  let result = self.0.get("regexp")
  if @js.is_nullish(result) || @js.typeof_(result) == "boolean" {
    None
  } else {
    Some(result)
  }
}

///|
/// Get the negate flag
pub fn Minimatch::negate(self : Minimatch) -> Bool {
  self.0.get("negate").cast()
}

///|
/// Get the comment flag (pattern starts with #)
pub fn Minimatch::comment(self : Minimatch) -> Bool {
  self.0.get("comment").cast()
}

///|
/// Get the empty flag (pattern is empty string)
pub fn Minimatch::empty(self : Minimatch) -> Bool {
  self.0.get("empty").cast()
}

///|
/// Check if a pattern has magic glob characters (static method)
pub fn has_magic(pattern : String) -> Bool {
  let mm = Minimatch::new(pattern)
  mm.has_magic()
}

///|
/// Check if a pattern has magic glob characters with options
pub fn has_magic_with_options(
  pattern : String,
  options : MinimatchOptions,
) -> Bool {
  let mm = Minimatch::new_with_options(pattern, options)
  mm.has_magic()
}
