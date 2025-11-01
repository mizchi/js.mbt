///|
using @val {type Val, trait Js, unsafe_cast, js}

///|
pub(all) struct URL {
  href : String
  origin : String
  protocol : String
  username : String
  password : String
  host : String
  hostname : String
  port : String
  pathname : String
  search : String
  hash : String
  searchParams : URLSearchParams
}

///|
pub impl Js for URL with to_js(self) {
  self |> js
}

///|
extern "js" fn ffi_url_new(url : String, base : String?) -> Val =
  #| (url, base) => new URL(url, base)

///|
extern "js" fn ffi_can_parse(url : String, base : String?) -> Val =
  #| (url, base) => URL.canParse(url, base)

///|
pub fn URL::new(url : String, base? : String) -> URL {
  ffi_url_new(url, base).cast()
}

///|
pub fn URL::can_parse(url : String, base? : String) -> Bool {
  ffi_can_parse(url, base).cast()
}
