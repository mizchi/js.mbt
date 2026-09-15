///|
extern "js" fn ffi_new_url_pattern(pattern : @core.Any) -> @core.Any =
  #|(pattern) => new URLPattern(pattern)

///|
extern "js" fn ffi_new_url_pattern_with_base(
  pattern : @core.Any,
  base : String,
) -> @core.Any =
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
pub fn URLPattern::as_any(self : URLPattern) -> @core.Any = "%identity"

///|
pub(all) struct URLPatternComponentResult {
  input : String
  groups : @core.Any
}

///|
pub fn URLPatternComponentResult::as_any(
  self : URLPatternComponentResult,
) -> @core.Any = "%identity"

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
pub fn URLPatternResult::as_any(self : URLPatternResult) -> @core.Any = "%identity"

///|
/// Create a new URLPattern from a pattern string
pub fn URLPattern::new(pattern : String, base? : String) -> URLPattern {
  let pattern_val = @core.any(pattern)
  match base {
    Some(b) => @core.identity(ffi_new_url_pattern_with_base(pattern_val, b))
    None => @core.identity(ffi_new_url_pattern(pattern_val))
  }
}

///|
/// Create a new URLPattern from a pattern object
#alias(new_from_object)
pub fn URLPattern::newFromObject(
  pattern : @core.Any,
  base? : String,
) -> URLPattern {
  match base {
    Some(b) => @core.identity(ffi_new_url_pattern_with_base(pattern, b))
    None => @core.identity(ffi_new_url_pattern(pattern))
  }
}

///|
/// Test if a URL string matches the pattern
pub fn URLPattern::test_url(self : Self, input : String) -> Bool {
  self.as_any()._call("test", [@core.any(input)]).cast()
}

///|
/// Test if a URL matches the pattern (with optional base)
pub fn URLPattern::test_url_with_base(
  self : Self,
  input : String,
  base? : String,
) -> Bool {
  match base {
    Some(b) =>
      self.as_any()._call("test", [@core.any(input), @core.any(b)]).cast()
    None => self.as_any()._call("test", [@core.any(input)]).cast()
  }
}

///|
/// Execute the pattern against a URL and return match result
pub fn URLPattern::exec(self : Self, input : String) -> URLPatternResult? {
  let result = self.as_any()._call("exec", [@core.any(input)])
  if @core.is_nullish(result) {
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
    Some(b) => self.as_any()._call("exec", [@core.any(input), @core.any(b)])
    None => self.as_any()._call("exec", [@core.any(input)])
  }
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}
