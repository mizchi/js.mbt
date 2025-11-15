///|
/// Storage represents the Web Storage API (localStorage/sessionStorage)
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage
#external
pub type Storage

///|
pub impl Js for Storage with to_js(self) {
  self |> js
}

///|
/// Returns the localStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage
pub extern "js" fn get_local_storage() -> Storage =
  #| () => localStorage

///|
/// Returns the sessionStorage object
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage
pub extern "js" fn get_session_storage() -> Storage =
  #| () => sessionStorage

///|
/// Gets an item from storage by key
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/getItem
pub extern "js" fn Storage::get_item(self : Storage, key : String) -> String? =
  #|(storage, key) => {
  #|  const value = storage.getItem(key);
  #|  return value === null ? null : value;
  #|}

///|
/// Sets an item in storage
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/setItem
pub extern "js" fn Storage::set_item(
  self : Storage,
  key : String,
  value : String,
) -> Unit =
  #|(storage, key, value) => {
  #|  storage.setItem(key, value);
  #|}

///|
/// Removes an item from storage by key
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/removeItem
pub extern "js" fn Storage::remove_item(self : Storage, key : String) -> Unit =
  #|(storage, key) => {
  #|  storage.removeItem(key);
  #|}

///|
/// Clears all items from storage
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/clear
pub fn Storage::clear(self : Storage) -> Unit {
  self.to_js().invoke("clear", []) |> ignore
}

///|
/// Returns the number of items in storage
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/length
pub fn Storage::length(self : Storage) -> Int {
  unsafe_cast(self.to_js().get("length"))
}

///|
/// Returns the key at the specified index
/// https://developer.mozilla.org/en-US/docs/Web/API/Storage/key
pub fn Storage::key(self : Storage, index : Int) -> String? {
  self.to_js().invoke("key", [index |> js]) |> to_option()
}

///|
/// Checks if a key exists in storage
pub fn Storage::has_item(self : Storage, key : String) -> Bool {
  match self.get_item(key) {
    Some(_) => true
    None => false
  }
}

///|
/// Gets all keys in storage as an array
pub fn Storage::keys(self : Storage) -> Array[String] {
  let len = self.length()
  let result = []
  for i = 0; i < len; i = i + 1 {
    match self.key(i) {
      Some(k) => result.push(k)
      None => ()
    }
  }
  result
}

///|
/// Gets all values in storage as an array
pub fn Storage::values(self : Storage) -> Array[String] {
  let len = self.length()
  let result = []
  for i = 0; i < len; i = i + 1 {
    match self.key(i) {
      Some(k) =>
        match self.get_item(k) {
          Some(v) => result.push(v)
          None => ()
        }
      None => ()
    }
  }
  result
}

///|
/// Gets all key-value pairs in storage
pub fn Storage::entries(self : Storage) -> Array[(String, String)] {
  let len = self.length()
  let result = []
  for i = 0; i < len; i = i + 1 {
    match self.key(i) {
      Some(k) =>
        match self.get_item(k) {
          Some(v) => result.push((k, v))
          None => ()
        }
      None => ()
    }
  }
  result
}
