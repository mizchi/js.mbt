#external
pub type JSON

///|
extern "js" fn stringify_no_indent(v : Value) -> String =
  #| (self) => JSON.stringify(self)

///|
extern "js" fn stringify_with_indent(v : Value, indent : Int) -> String =
  #| (self, indent) => JSON.stringify(self, null, indent)

///|
pub extern "js" fn structured_clone(v : Value) -> Value =
  #| (self) => structuredClone(self)

///|
pub fn stringify(v : Value, indent? : Int) -> String {
  match indent {
    None => stringify_no_indent(v)
    Some(i) => stringify_with_indent(v, i)
  }
}
