///|
extern "js" fn ffi_new_url_pattern(pattern : @js.Js) -> @js.Js =
  #|(pattern) => new URLPattern(pattern)

///|
extern "js" fn ffi_new_url_pattern_with_base(
  pattern : @js.Js,
  base : String,
) -> @js.Js =
  #|(pattern, base) => new URLPattern(pattern, base)

///|
pub(all) struct URLPattern {
  protocol : String
  username : String
  password : String
  hostname : String
  port : String
  pathname : String
  search : String
  hash : String
  hasRegExpGroups : Bool
}

///|
pub impl @js.JsImpl for URLPattern

///|
pub(all) struct URLPatternComponentResult {
  input : String
  groups : @js.Js
}

///|
pub impl @js.JsImpl for URLPatternComponentResult

///|
pub(all) struct URLPatternResult {
  inputs : Array[String]
  protocol : URLPatternComponentResult
  username : URLPatternComponentResult
  password : URLPatternComponentResult
  hostname : URLPatternComponentResult
  port : URLPatternComponentResult
  pathname : URLPatternComponentResult
  search : URLPatternComponentResult
  hash : URLPatternComponentResult
}

///|
pub impl @js.JsImpl for URLPatternResult

///|
/// Create a new URLPattern from a pattern string
pub fn URLPattern::new(pattern : String, base? : String) -> URLPattern {
  let pattern_val = @js.unsafe_js(pattern)
  match base {
    Some(b) => @js.identity(ffi_new_url_pattern_with_base(pattern_val, b))
    None => @js.identity(ffi_new_url_pattern(pattern_val))
  }
}

///|
/// Create a new URLPattern from a pattern object
#alias(new_from_object)
pub fn URLPattern::newFromObject(
  pattern : @js.Js,
  base? : String,
) -> URLPattern {
  match base {
    Some(b) => @js.identity(ffi_new_url_pattern_with_base(pattern, b))
    None => @js.identity(ffi_new_url_pattern(pattern))
  }
}

///|
/// Test if a URL string matches the pattern
pub fn URLPattern::test_url(self : Self, input : String) -> Bool {
  self.call("test", [input]).cast()
}

///|
/// Test if a URL matches the pattern (with optional base)
pub fn URLPattern::test_url_with_base(
  self : Self,
  input : String,
  base? : String,
) -> Bool {
  match base {
    Some(b) => self.call2("test", input, b) |> @js.identity
    None => self.call("test", [input]).cast()
  }
}

///|
extern "js" fn ffi_is_null(v : @js.Js) -> Bool =
  #|(v) => v === null

///|
/// Execute the pattern against a URL and return match result
pub fn URLPattern::exec(self : Self, input : String) -> URLPatternResult? {
  let result = self.call("exec", [input])
  if ffi_is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
/// Execute the pattern against a URL with optional base
#alias(exec_with_base)
pub fn URLPattern::execWithBase(
  self : Self,
  input : String,
  base? : String,
) -> URLPatternResult? {
  let result = match base {
    Some(b) => self.call2("exec", input, b)
    None => self.call("exec", [input])
  }
  if ffi_is_null(result) {
    None
  } else {
    Some(result.cast())
  }
}
