///|
#external
pub type Storage

///|
pub extern "js" fn get_local_storage() -> Storage =
  #| () => localStorage

///|
pub extern "js" fn get_session_storage() -> Storage =
  #| () => sessionStorage

///|
pub extern "js" fn Storage::get_item(self : Storage, key : String) -> String? =
  #|(ls, key) => {
  #|  const value = ls.getItem(key);
  #|  return value === null ? null : value;
  #|}

///|
pub extern "js" fn Storage::set_item(
  self : Storage,
  key : String,
  value : String,
) -> Unit =
  #|(ls, key, value) => {
  #|  ls.setItem(key, value);
  #|}

///|
pub extern "js" fn Storage::remove_item(self : Storage, key : String) -> Unit =
  #|(ls, key) => {
  #|  ls.removeItem(key);
  #|}
