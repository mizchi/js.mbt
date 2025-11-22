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
#external
pub type URLPattern

///|
pub impl @js.JsImpl for URLPattern with to_js(self) -> @js.Js {
  self |> @js.unsafe_js
}

///|
pub(all) struct URLPatternResult {
  inputs : @js.Js
  protocol : @js.Js
  username : @js.Js
  password : @js.Js
  hostname : @js.Js
  port : @js.Js
  pathname : @js.Js
  search : @js.Js
  hash : @js.Js
}

///|
pub impl @js.JsImpl for URLPatternResult

///|
/// Get the input value from a component result
pub fn get_component_input(component : @js.Js) -> String {
  component.get("input") |> @js.unsafe_cast
}

///|
/// Get the groups from a component result
pub fn get_component_groups(component : @js.Js) -> @js.Js {
  component.get("groups")
}

///|
/// Create a new URLPattern from a pattern string
pub fn URLPattern::new(pattern : String, base? : String) -> URLPattern {
  let pattern_val = @js.unsafe_js(pattern)
  match base {
    Some(b) => unsafe_cast(ffi_new_url_pattern_with_base(pattern_val, b))
    None => unsafe_cast(ffi_new_url_pattern(pattern_val))
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
    Some(b) => unsafe_cast(ffi_new_url_pattern_with_base(pattern, b))
    None => unsafe_cast(ffi_new_url_pattern(pattern))
  }
}

///|
/// Get the protocol pattern
pub fn URLPattern::protocol(self : Self) -> String {
  self.get("protocol") |> unsafe_cast
}

///|
/// Get the username pattern
pub fn URLPattern::username(self : Self) -> String {
  self.get("username") |> unsafe_cast
}

///|
/// Get the password pattern
pub fn URLPattern::password(self : Self) -> String {
  self.get("password") |> unsafe_cast
}

///|
/// Get the hostname pattern
pub fn URLPattern::hostname(self : Self) -> String {
  unsafe_cast(self.to_js().get("hostname"))
}

///|
/// Get the port pattern
pub fn URLPattern::port(self : Self) -> String {
  unsafe_cast(self.to_js().get("port"))
}

///|
/// Get the pathname pattern
pub fn URLPattern::pathname(self : Self) -> String {
  unsafe_cast(self.to_js().get("pathname"))
}

///|
/// Get the search pattern
pub fn URLPattern::search(self : Self) -> String {
  unsafe_cast(self.to_js().get("search"))
}

///|
/// Get the hash pattern
pub fn URLPattern::hash(self : Self) -> String {
  unsafe_cast(self.to_js().get("hash"))
}

///|
/// Check if the pattern has regular expression groups
#alias(has_regexp_groups)
pub fn URLPattern::hasRegExpGroups(self : Self) -> Bool {
  unsafe_cast(self.to_js().get("hasRegExpGroups"))
}

///|
/// Test if a URL string matches the pattern
pub fn URLPattern::test_url(self : Self, input : String) -> Bool {
  self.call("test", [input]) |> unsafe_cast
}

///|
/// Test if a URL matches the pattern (with optional base)
pub fn URLPattern::test_url_with_base(
  self : Self,
  input : String,
  base? : String,
) -> Bool {
  match base {
    Some(b) => self.call2("test", input, b) |> unsafe_cast
    None => self.call("test", [input]) |> unsafe_cast
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
    Some(result |> @js.unsafe_cast)
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
    Some(result |> @js.unsafe_cast)
  }
}
