///|
#external
pub type RegExp

///|
pub struct RegExpResult {
  full : String
  input : String
  index : Int
  last_index : Int
  groups : Map[String, String]?
}

///|
extern "js" fn ffi_regexp_new(s : String, flags : String) -> RegExp =
  #|(s, flags) => new RegExp(s, flags)

///|
extern "js" fn ffi_regexp_test(self : RegExp, string : String) -> Bool =
  #|(re, string) => re.test(string)

///|
extern "js" fn ffi_regexp_exec(self : RegExp, string : String) -> Value =
  #|(re, string) => re.exec(string)

///|
pub fn RegExp::test_(self : RegExp, string : String) -> Bool {
  RegExp::ffi_regexp_test(self, string)
}

///|
pub fn RegExp::exec(self : RegExp, s : String) -> RegExpResult? {
  let v = RegExp::ffi_regexp_exec(self, s)
  if v.is_null() {
    return None
  }
  let full : String = v.at(0) |> identity
  let index : Int = v.get("index") |> identity
  let last_index : Int = v.get("lastIndex") |> identity
  let input : String = v.get("input") |> identity
  let groups : Map[String, String]? = if v.get("groups").is_undefined() {
    None
  } else {
    let g : Map[String, String] = {}
    for k in v.get("groups").keys() {
      g[k] = v.get("groups").get(k) |> identity
    }
    Some(g)
  }
  { full, input, index, last_index, groups } |> Some
}

///|
pub fn RegExp::new(pattern : String, flags? : String) -> RegExp {
  let flags_str = match flags {
    None => ""
    Some(f) => f
  }
  ffi_regexp_new(pattern, flags_str)
}

///|
test "RegExp.test" {
  let re = RegExp::new("^[a-z]+$", flags="igu")
  assert_true(re.test_("MoonBit"))
}

///|
test "RegExp.exec" {
  let re = RegExp::new("^[a-z]+$", flags="igu")
  let matched = re.exec("MoonBit")
  guard matched is Some(matched)
  assert_eq(matched.full, "MoonBit")
  assert_eq(matched.index, 0)
  assert_eq(matched.input, "MoonBit")
}

///|
test "RegExp.exec with named capture groups" {
  let re = RegExp::new("(?<name>[a-z]+)", flags="igu")
  let matched = re.exec("MoonBit")
  guard matched is Some(matched)
  assert_eq(matched.full, "MoonBit")
  assert_eq(matched.index, 0)
  assert_eq(matched.input, "MoonBit")
  assert_eq(matched.groups, Some({ "name": "MoonBit" }))
}
