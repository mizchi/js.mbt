///|
/// Hono Cookie Helper
/// https://hono.dev/docs/helpers/cookie

///|
fn build_cookie_options(
  domain? : String,
  expires? : @js.Any,
  httpOnly? : Bool,
  maxAge? : Int,
  path? : String,
  secure? : Bool,
  sameSite? : String,
  priority? : String,
  prefix? : String,
  partitioned? : Bool,
) -> @js.Any {
  let obj = @js.Object::new()
  if domain is Some(v) {
    obj.set("domain", v)
  }
  if expires is Some(v) {
    obj.set("expires", v)
  }
  if httpOnly is Some(v) {
    obj.set("httpOnly", v)
  }
  if maxAge is Some(v) {
    obj.set("maxAge", v)
  }
  if path is Some(v) {
    obj.set("path", v)
  }
  if secure is Some(v) {
    obj.set("secure", v)
  }
  if sameSite is Some(v) {
    obj.set("sameSite", v)
  }
  if priority is Some(v) {
    obj.set("priority", v)
  }
  if prefix is Some(v) {
    obj.set("prefix", v)
  }
  if partitioned is Some(v) {
    obj.set("partitioned", v)
  }
  obj.to_any()
}

///|
/// Get a cookie value by name
/// https://hono.dev/docs/helpers/cookie#getcookie
pub fn[Env, ExecutionContext] get_cookie(
  c : Context[Env, ExecutionContext],
  name : String,
  prefix? : String,
) -> String? {
  let result = match prefix {
    Some(p) => ffi_get_cookie_with_prefix(c |> @js.identity, name, p)
    None => ffi_get_cookie(c |> @js.identity, name)
  }
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_get_cookie(c : @js.Any, name : String) -> @js.Any =
  #|(c, name) => {
  #|  const { getCookie } = require('hono/cookie');
  #|  return getCookie(c, name);
  #|}

///|
extern "js" fn ffi_get_cookie_with_prefix(
  c : @js.Any,
  name : String,
  prefix : String,
) -> @js.Any =
  #|(c, name, prefix) => {
  #|  const { getCookie } = require('hono/cookie');
  #|  return getCookie(c, name, prefix);
  #|}

///|
/// Get all cookies as a Map
pub fn[Env, ExecutionContext] get_all_cookies(
  c : Context[Env, ExecutionContext],
) -> Map[String, String] {
  let obj = ffi_get_all_cookies(c |> @js.identity)
  let result : Map[String, String] = {}
  let keys : Array[String] = @js.Object::keys(obj) |> @js.identity
  for i = 0; i < keys.length(); i = i + 1 {
    let key = keys[i]
    let value = obj.get(key)
    if not(@js.is_nullish(value)) {
      result[key] = value.cast()
    }
  }
  result
}

///|
extern "js" fn ffi_get_all_cookies(c : @js.Any) -> @js.Any =
  #|(c) => {
  #|  const { getCookie } = require('hono/cookie');
  #|  return getCookie(c);
  #|}

///|
/// Set a cookie
/// https://hono.dev/docs/helpers/cookie#setcookie
pub fn[Env, ExecutionContext] set_cookie(
  c : Context[Env, ExecutionContext],
  name : String,
  value : String,
  domain? : String,
  expires? : @js.Any,
  httpOnly? : Bool,
  maxAge? : Int,
  path? : String,
  secure? : Bool,
  sameSite? : String,
  priority? : String,
  prefix? : String,
  partitioned? : Bool,
) -> Unit {
  let opts = build_cookie_options(
    domain?,
    expires?,
    httpOnly?,
    maxAge?,
    path?,
    secure?,
    sameSite?,
    priority?,
    prefix?,
    partitioned?,
  )
  ffi_set_cookie_with_options(c |> @js.identity, name, value, opts)
}

///|
extern "js" fn ffi_set_cookie_with_options(
  c : @js.Any,
  name : String,
  value : String,
  options : @js.Any,
) -> Unit =
  #|(c, name, value, options) => {
  #|  const { setCookie } = require('hono/cookie');
  #|  setCookie(c, name, value, options);
  #|}

///|
/// Delete a cookie
/// https://hono.dev/docs/helpers/cookie#deletecookie
pub fn[Env, ExecutionContext] delete_cookie(
  c : Context[Env, ExecutionContext],
  name : String,
  path? : String,
  secure? : Bool,
  domain? : String,
) -> String? {
  let opts = build_cookie_options(domain?, path?, secure?)
  let result = ffi_delete_cookie_with_options(c |> @js.identity, name, opts)
  if @js.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_delete_cookie_with_options(
  c : @js.Any,
  name : String,
  options : @js.Any,
) -> @js.Any =
  #|(c, name, options) => {
  #|  const { deleteCookie } = require('hono/cookie');
  #|  return deleteCookie(c, name, options);
  #|}

///|
/// Get a signed cookie (async)
/// https://hono.dev/docs/helpers/cookie#getsignedcookie
pub async fn[Env, ExecutionContext] get_signed_cookie(
  c : Context[Env, ExecutionContext],
  secret : String,
  name : String,
) -> String? {
  let result : @js.Any = ffi_get_signed_cookie(c |> @js.identity, secret, name).wait()
  if @js.is_nullish(result) || result == @js.any(false) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_get_signed_cookie(
  c : @js.Any,
  secret : String,
  name : String,
) -> @js.Promise[@js.Any] =
  #|(c, secret, name) => {
  #|  const { getSignedCookie } = require('hono/cookie');
  #|  return getSignedCookie(c, secret, name);
  #|}

///|
/// Set a signed cookie (async)
/// https://hono.dev/docs/helpers/cookie#setsignedcookie
pub async fn[Env, ExecutionContext] set_signed_cookie(
  c : Context[Env, ExecutionContext],
  name : String,
  value : String,
  secret : String,
  domain? : String,
  expires? : @js.Any,
  httpOnly? : Bool,
  maxAge? : Int,
  path? : String,
  secure? : Bool,
  sameSite? : String,
  priority? : String,
  prefix? : String,
  partitioned? : Bool,
) -> Unit {
  let opts = build_cookie_options(
    domain?,
    expires?,
    httpOnly?,
    maxAge?,
    path?,
    secure?,
    sameSite?,
    priority?,
    prefix?,
    partitioned?,
  )
  ffi_set_signed_cookie_with_options(
    c |> @js.identity,
    name,
    value,
    secret,
    opts,
  ).wait()
}

///|
extern "js" fn ffi_set_signed_cookie_with_options(
  c : @js.Any,
  name : String,
  value : String,
  secret : String,
  options : @js.Any,
) -> @js.Promise[Unit] =
  #|(c, name, value, secret, options) => {
  #|  const { setSignedCookie } = require('hono/cookie');
  #|  return setSignedCookie(c, name, value, secret, options);
  #|}
