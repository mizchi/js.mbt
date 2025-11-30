///|
/// Convert JS nullable value to MoonBit Option
/// Returns None if the value is null or undefined, Some(value) otherwise
pub fn[T] identity_option(value : @nostd.Any) -> T? {
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
extern "js" fn get_test_object() -> @nostd.Any =
  #| () => ({ name: "test", value: null, count: 42, missing: undefined })

///|
fn main {
  let obj = get_test_object()

  // Test with non-null value
  let name : String? = identity_option(obj["name"])
  match name {
    Some(n) => console_log(@nostd.any("name: " + n))
    None => console_log(@nostd.any("name is null"))
  }

  // Test with null value
  let value : String? = identity_option(obj["value"])
  match value {
    Some(v) => console_log(@nostd.any("value: " + v))
    None => console_log(@nostd.any("value is null"))
  }

  // Test with number
  let count : Int? = identity_option(obj["count"])
  match count {
    Some(c) => console_log(@nostd.any("count: " + c.to_string()))
    None => console_log(@nostd.any("count is null"))
  }

  // Test with undefined (missing property)
  let missing : String? = identity_option(obj["missing"])
  match missing {
    Some(m) => console_log(@nostd.any("missing: " + m))
    None => console_log(@nostd.any("missing is undefined"))
  }

  // Test with completely missing key
  let notexist : String? = identity_option(obj["notexist"])
  match notexist {
    Some(n) => console_log(@nostd.any("notexist: " + n))
    None => console_log(@nostd.any("notexist is undefined"))
  }
}
