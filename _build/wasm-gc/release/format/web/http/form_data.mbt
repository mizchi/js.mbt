///|
/// https://developer.mozilla.org/ja/docs/Web/API/FormData
#external
pub type FormData

///|
pub fn FormData::as_any(self : FormData) -> @core.Any = "%identity"

///|
pub extern "js" fn FormData::append(
  self : Self,
  name : String,
  value : String,
) -> Unit =
  #| (self, name, value) => self.append(name, value)

///|
pub extern "js" fn FormData::delete(self : Self, name : String) -> Unit =
  #| (self, name) => self.delete(name)

///|
pub extern "js" fn FormData::get(self : Self, name : String) -> String =
  #| (self, name) => self.get(name)
