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
} derive(Eq, Show)

///|
pub impl JsImpl for URL

///|
extern "js" fn ffi_url_new(url : String, base : String?) -> Js =
  #| (url, base) => new URL(url, base)

///|
extern "js" fn ffi_can_parse(url : String, base : String?) -> Js =
  #| (url, base) => URL.canParse(url, base)

///|
pub fn URL::new(url : String, base? : String) -> URL {
  unsafe_cast(ffi_url_new(url, base))
}

///|
#alias(canParse)
pub fn URL::can_parse(url : String, base? : String) -> Bool {
  unsafe_cast(ffi_can_parse(url, base))
}

///|
extern "js" fn ffi_url_parse(url : String, base : String?) -> Js =
  #| (url, base) => URL.parse(url, base)

///|
pub fn URL::parse(url : String, base? : String) -> URL? {
  ffi_url_parse(url, base) |> @js.unsafe_cast_option()
}

///|
pub fn URL::to_string(self : URL) -> String {
  self.href
}

///|
#alias(toJSON)
pub fn URL::to_json(self : URL) -> String {
  self.href
}

///|
extern "js" fn ffi_create_object_url(obj : Js) -> Js =
  #| (obj) => URL.createObjectURL(obj)

///|
#alias(createObjectURL)
pub fn URL::create_object_url(obj : Js) -> String {
  unsafe_cast(ffi_create_object_url(obj))
}

///|
extern "js" fn ffi_revoke_object_url(url : String) -> Js =
  #| (url) => URL.revokeObjectURL(url)

///|
#alias(revokeObjectURL)
pub fn URL::revoke_object_url(url : String) -> Unit {
  ffi_revoke_object_url(url) |> ignore
}
