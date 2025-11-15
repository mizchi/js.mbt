///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
/// JavaScript RegExp object wrapper.
///
/// Corresponds to JavaScript's `RegExp` constructor and object.
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp
#external
pub type RegExp

///|
/// Result of RegExp.exec() method.
///
/// Corresponds to the return value of JavaScript's `RegExp.prototype.exec()`.
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/exec
pub struct RegExpResult {
  full : String
  input : String
  index : Int
  last_index : Int
  groups : Map[String, String]?
}

///|
/// Result of String.match() or String.matchAll() methods.
///
/// Corresponds to the return value of JavaScript's `String.prototype.match()` and `String.prototype.matchAll()`.
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/matchAll
pub struct RegExpMatchArray {
  matches : Array[String]
  index : Int?
  input : String?
  groups : Map[String, String]?
}

///|
extern "js" fn ffi_regexp_new(s : String, flags : String) -> RegExp =
  #|(s, flags) => new RegExp(s, flags)

///|
extern "js" fn RegExp::ffi_regexp_test(self : RegExp, string : String) -> Bool =
  #|(re, string) => re.test(string)

///|
extern "js" fn RegExp::ffi_regexp_exec(self : RegExp, string : String) -> Val =
  #|(re, string) => re.exec(string)

///|
/// JavaScript API: RegExp.prototype.source
extern "js" fn RegExp::ffi_regexp_source(self : RegExp) -> String =
  #|(re) => re.source

///|
/// JavaScript API: RegExp.prototype.flags
extern "js" fn RegExp::ffi_regexp_flags(self : RegExp) -> String =
  #|(re) => re.flags

///|
/// JavaScript API: RegExp.prototype.global
extern "js" fn RegExp::ffi_regexp_global(self : RegExp) -> Bool =
  #|(re) => re.global

///|
/// JavaScript API: RegExp.prototype.ignoreCase
extern "js" fn RegExp::ffi_regexp_ignore_case(self : RegExp) -> Bool =
  #|(re) => re.ignoreCase

///|
/// JavaScript API: RegExp.prototype.multiline
extern "js" fn RegExp::ffi_regexp_multiline(self : RegExp) -> Bool =
  #|(re) => re.multiline

///|
/// JavaScript API: RegExp.prototype.sticky
extern "js" fn RegExp::ffi_regexp_sticky(self : RegExp) -> Bool =
  #|(re) => re.sticky

///|
/// JavaScript API: RegExp.prototype.unicode
extern "js" fn RegExp::ffi_regexp_unicode(self : RegExp) -> Bool =
  #|(re) => re.unicode

///|
/// JavaScript API: RegExp.prototype.dotAll
extern "js" fn RegExp::ffi_regexp_dot_all(self : RegExp) -> Bool =
  #|(re) => re.dotAll

///|
/// JavaScript API: RegExp.prototype.hasIndices
extern "js" fn RegExp::ffi_regexp_has_indices(self : RegExp) -> Bool =
  #|(re) => re.hasIndices

///|
/// JavaScript API: RegExp.prototype.lastIndex (getter)
extern "js" fn RegExp::ffi_regexp_get_last_index(self : RegExp) -> Int =
  #|(re) => re.lastIndex

///|
/// JavaScript API: RegExp.prototype.lastIndex (setter)
extern "js" fn RegExp::ffi_regexp_set_last_index(
  self : RegExp,
  index : Int,
) -> Unit =
  #|(re, index) => { re.lastIndex = index; }

///|
/// JavaScript API: RegExp.prototype.toString()
extern "js" fn RegExp::ffi_regexp_to_string(self : RegExp) -> String =
  #|(re) => re.toString()

///|
/// JavaScript API: String.prototype.match()
extern "js" fn ffi_string_match(string : String, re : RegExp) -> Val =
  #|(string, re) => string.match(re)

///|
/// JavaScript API: String.prototype.matchAll()
extern "js" fn ffi_string_match_all(string : String, re : RegExp) -> Val =
  #|(string, re) => Array.from(string.matchAll(re))

///|
/// JavaScript API: String.prototype.replace()
extern "js" fn ffi_string_replace(
  string : String,
  re : RegExp,
  replacement : String,
) -> String =
  #|(string, re, replacement) => string.replace(re, replacement)

///|
/// JavaScript API: String.prototype.replaceAll()
extern "js" fn ffi_string_replace_all(
  string : String,
  re : RegExp,
  replacement : String,
) -> String =
  #|(string, re, replacement) => string.replaceAll(re, replacement)

///|
/// JavaScript API: String.prototype.replace() with replacer function
extern "js" fn ffi_string_replace_fn(
  string : String,
  re : RegExp,
  replacer : Val,
) -> String =
  #|(string, re, replacer) => string.replace(re, replacer)

///|
/// JavaScript API: String.prototype.replaceAll() with replacer function
extern "js" fn ffi_string_replace_all_fn(
  string : String,
  re : RegExp,
  replacer : Val,
) -> String =
  #|(string, re, replacer) => string.replaceAll(re, replacer)

///|
/// JavaScript API: String.prototype.search()
extern "js" fn ffi_string_search(string : String, re : RegExp) -> Int =
  #|(string, re) => string.search(re)

///|
/// JavaScript API: String.prototype.split()
extern "js" fn ffi_string_split(
  string : String,
  re : RegExp,
  limit : Val,
) -> Array[String] =
  #|(string, re, limit) => string.split(re, limit === null ? undefined : limit)

///|
/// Get the source pattern of the regular expression.
///
/// JavaScript API: `RegExp.prototype.source`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/source
pub fn RegExp::source(self : RegExp) -> String {
  RegExp::ffi_regexp_source(self)
}

///|
/// Get the flags string of the regular expression.
///
/// JavaScript API: `RegExp.prototype.flags`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/flags
pub fn RegExp::flags(self : RegExp) -> String {
  RegExp::ffi_regexp_flags(self)
}

///|
/// Check if the global flag is set.
///
/// JavaScript API: `RegExp.prototype.global`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/global
pub fn RegExp::global(self : RegExp) -> Bool {
  RegExp::ffi_regexp_global(self)
}

///|
/// Check if the ignoreCase flag is set.
///
/// JavaScript API: `RegExp.prototype.ignoreCase`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/ignoreCase
pub fn RegExp::ignore_case(self : RegExp) -> Bool {
  RegExp::ffi_regexp_ignore_case(self)
}

///|
/// Check if the multiline flag is set.
///
/// JavaScript API: `RegExp.prototype.multiline`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/multiline
pub fn RegExp::multiline(self : RegExp) -> Bool {
  RegExp::ffi_regexp_multiline(self)
}

///|
/// Check if the sticky flag is set.
///
/// JavaScript API: `RegExp.prototype.sticky`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/sticky
pub fn RegExp::sticky(self : RegExp) -> Bool {
  RegExp::ffi_regexp_sticky(self)
}

///|
/// Check if the unicode flag is set.
///
/// JavaScript API: `RegExp.prototype.unicode`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/unicode
pub fn RegExp::unicode(self : RegExp) -> Bool {
  RegExp::ffi_regexp_unicode(self)
}

///|
/// Check if the dotAll flag is set.
///
/// JavaScript API: `RegExp.prototype.dotAll`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/dotAll
pub fn RegExp::dot_all(self : RegExp) -> Bool {
  RegExp::ffi_regexp_dot_all(self)
}

///|
/// Check if the hasIndices flag is set.
///
/// JavaScript API: `RegExp.prototype.hasIndices`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/hasIndices
pub fn RegExp::has_indices(self : RegExp) -> Bool {
  RegExp::ffi_regexp_has_indices(self)
}

///|
/// Get the index at which to start the next match.
///
/// JavaScript API: `RegExp.prototype.lastIndex` (getter)
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/lastIndex
pub fn RegExp::last_index(self : RegExp) -> Int {
  RegExp::ffi_regexp_get_last_index(self)
}

///|
/// Set the index at which to start the next match.
///
/// JavaScript API: `RegExp.prototype.lastIndex` (setter)
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/lastIndex
pub fn RegExp::set_last_index(self : RegExp, index : Int) -> Unit {
  RegExp::ffi_regexp_set_last_index(self, index)
}

///|
/// Convert the regular expression to a string.
///
/// JavaScript API: `RegExp.prototype.toString()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/toString
pub fn RegExp::to_string(self : RegExp) -> String {
  RegExp::ffi_regexp_to_string(self)
}

///|
/// Test if the pattern matches the given string.
///
/// JavaScript API: `RegExp.prototype.test()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/test
pub fn RegExp::test_(self : RegExp, string : String) -> Bool {
  RegExp::ffi_regexp_test(self, string)
}

///|
/// Execute the regular expression and return detailed match information.
///
/// JavaScript API: `RegExp.prototype.exec()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/exec
pub fn RegExp::exec(self : RegExp, s : String) -> RegExpResult? {
  let v = RegExp::ffi_regexp_exec(self, s)
  if v.is_null() {
    return None
  }
  let full : String = unsafe_cast(v[0])
  let index : Int = unsafe_cast(v["index"])
  let last_index : Int = unsafe_cast(v["lastIndex"])
  let input : String = unsafe_cast(v["input"])
  let groups : Map[String, String]? = if v["groups"].is_undefined() {
    None
  } else {
    let g : Map[String, String] = {}
    let keys = @js.object_keys(v.get("groups"))
    for k in keys {
      g[k] = unsafe_cast(v.get("groups").get(k))
    }
    Some(g)
  }
  { full, input, index, last_index, groups } |> Some
}

///|
/// Create a new RegExp instance.
///
/// JavaScript API: `new RegExp(pattern, flags)`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/RegExp
pub fn RegExp::new(pattern : String, flags? : String) -> RegExp {
  let flags_str = match flags {
    None => ""
    Some(f) => f
  }
  ffi_regexp_new(pattern, flags_str)
}

///|
/// Match a regular expression against a string.
///
/// JavaScript API: `String.prototype.match()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match
pub fn RegExp::match_(self : RegExp, string : String) -> RegExpMatchArray? {
  let v = ffi_string_match(string, self)
  if v.is_null() {
    return None
  }
  let len : Int = unsafe_cast(v["length"])
  let matches : Array[String] = Array::new(capacity=len)
  for i = 0; i < len; i = i + 1 {
    matches.push(unsafe_cast(v[i]))
  }
  let index : Int? = if v["index"].is_undefined() {
    None
  } else {
    Some(unsafe_cast(v["index"]))
  }
  let input : String? = if v["input"].is_undefined() {
    None
  } else {
    Some(unsafe_cast(v["input"]))
  }
  let groups : Map[String, String]? = if v["groups"].is_undefined() {
    None
  } else {
    let g : Map[String, String] = {}
    let keys = @js.object_keys(v.get("groups"))
    for k in keys {
      g[k] = unsafe_cast(v.get("groups").get(k))
    }
    Some(g)
  }
  Some({ matches, index, input, groups })
}

///|
/// Return all matches of a regular expression against a string.
///
/// JavaScript API: `String.prototype.matchAll()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/matchAll
pub fn RegExp::match_all(
  self : RegExp,
  string : String,
) -> Array[RegExpMatchArray] {
  let v = ffi_string_match_all(string, self)
  let len : Int = unsafe_cast(v["length"])
  let results : Array[RegExpMatchArray] = []
  for i = 0; i < len; i = i + 1 {
    let item = v[i]
    let match_len : Int = unsafe_cast(item["length"])
    let matches : Array[String] = Array::new(capacity=match_len)
    for j = 0; j < match_len; j = j + 1 {
      matches.push(unsafe_cast(item[j]))
    }
    let index : Int? = if item["index"].is_undefined() {
      None
    } else {
      Some(unsafe_cast(item["index"]))
    }
    let input : String? = if item["input"].is_undefined() {
      None
    } else {
      Some(unsafe_cast(item["input"]))
    }
    let groups : Map[String, String]? = if item["groups"].is_undefined() {
      None
    } else {
      let g : Map[String, String] = {}
      let keys = @js.object_keys(item.get("groups"))
      for k in keys {
        g[k] = unsafe_cast(item.get("groups").get(k))
      }
      Some(g)
    }
    results.push({ matches, index, input, groups })
  }
  results
}

///|
/// Replace matches of the regular expression with a string.
///
/// JavaScript API: `String.prototype.replace()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace
pub fn RegExp::replace(
  self : RegExp,
  string : String,
  replacement : String,
) -> String {
  ffi_string_replace(string, self, replacement)
}

///|
/// Replace all matches of the regular expression with a string.
///
/// JavaScript API: `String.prototype.replaceAll()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replaceAll
pub fn RegExp::replace_all(
  self : RegExp,
  string : String,
  replacement : String,
) -> String {
  ffi_string_replace_all(string, self, replacement)
}

///|
/// Replace matches of the regular expression using a replacer function.
///
/// JavaScript API: `String.prototype.replace()` with replacer function
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace
pub fn RegExp::replace_fn(
  self : RegExp,
  string : String,
  replacer : (String, Array[String], Int, String) -> String,
) -> String {
  let wrapper = fn(
    matched : String,
    groups_val : Val,
    offset : Int,
    input : String,
  ) -> String {
    let groups_len : Int = unsafe_cast(groups_val["length"])
    let groups : Array[String] = Array::new(capacity=groups_len)
    for i = 0; i < groups_len; i = i + 1 {
      let item = groups_val[i]
      if item.is_undefined() {
        groups.push("")
      } else {
        groups.push(unsafe_cast(item))
      }
    }
    replacer(matched, groups, offset, input)
  }
  ffi_string_replace_fn(string, self, @js.js(wrapper))
}

///|
/// Replace all matches of the regular expression using a replacer function.
///
/// JavaScript API: `String.prototype.replaceAll()` with replacer function
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replaceAll
pub fn RegExp::replace_all_fn(
  self : RegExp,
  string : String,
  replacer : (String, Array[String], Int, String) -> String,
) -> String {
  let wrapper = fn(
    matched : String,
    groups_val : Val,
    offset : Int,
    input : String,
  ) -> String {
    let groups_len : Int = unsafe_cast(groups_val["length"])
    let groups : Array[String] = Array::new(capacity=groups_len)
    for i = 0; i < groups_len; i = i + 1 {
      let item = groups_val[i]
      if item.is_undefined() {
        groups.push("")
      } else {
        groups.push(unsafe_cast(item))
      }
    }
    replacer(matched, groups, offset, input)
  }
  ffi_string_replace_all_fn(string, self, @js.js(wrapper))
}

///|
/// Search for a match and return the index of the first occurrence.
///
/// JavaScript API: `String.prototype.search()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/search
pub fn RegExp::search(self : RegExp, string : String) -> Int {
  ffi_string_search(string, self)
}

///|
/// Split a string using the regular expression as the separator.
///
/// JavaScript API: `String.prototype.split()`
/// See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/split
pub fn RegExp::split(
  self : RegExp,
  string : String,
  limit? : Int,
) -> Array[String] {
  let limit_val = match limit {
    None => @js.null_()
    Some(n) => @js.js(n)
  }
  ffi_string_split(string, self, limit_val)
}
