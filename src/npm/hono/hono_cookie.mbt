///|
/// Hono Cookie Helper
/// https://hono.dev/docs/helpers/cookie

///|
fn build_cookie_options(
  domain? : String,
  expires? : @core.Any,
  httpOnly? : Bool,
  maxAge? : Int,
  path? : String,
  secure? : Bool,
  sameSite? : String,
  priority? : String,
  prefix? : String,
  partitioned? : Bool,
) -> @core.Any {
  let obj = @core.Object::new()
  if domain is Some(v) {
    obj["domain"] = @core.any(v)
  }
  if expires is Some(v) {
    obj["expires"] = v
  }
  if httpOnly is Some(v) {
    obj["httpOnly"] = @core.any(v)
  }
  if maxAge is Some(v) {
    obj["maxAge"] = @core.any(v)
  }
  if path is Some(v) {
    obj["path"] = @core.any(v)
  }
  if secure is Some(v) {
    obj["secure"] = @core.any(v)
  }
  if sameSite is Some(v) {
    obj["sameSite"] = @core.any(v)
  }
  if priority is Some(v) {
    obj["priority"] = @core.any(v)
  }
  if prefix is Some(v) {
    obj["prefix"] = @core.any(v)
  }
  if partitioned is Some(v) {
    obj["partitioned"] = @core.any(v)
  }
  obj
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
    Some(p) => ffi_get_cookie_with_prefix(c.as_any(), name, p)
    None => ffi_get_cookie(c.as_any(), name)
  }
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_get_cookie(c : @core.Any, name : String) -> @core.Any =
  #|(c, name) => {
  #|  const { getCookie } = require('hono/cookie');
  #|  return getCookie(c, name);
  #|}

///|
extern "js" fn ffi_get_cookie_with_prefix(
  c : @core.Any,
  name : String,
  prefix : String,
) -> @core.Any =
  #|(c, name, prefix) => {
  #|  const { getCookie } = require('hono/cookie');
  #|  return getCookie(c, name, prefix);
  #|}

///|
/// Get all cookies as a Map
pub fn[Env, ExecutionContext] get_all_cookies(
  c : Context[Env, ExecutionContext],
) -> Map[String, String] {
  let obj = ffi_get_all_cookies(c.as_any())
  let result : Map[String, String] = {}
  let keys : Array[String] = @core.Object::keys(obj)
  for i = 0; i < keys.length(); i = i + 1 {
    let key = keys[i]
    let value = obj[key]
    if not(@core.is_nullish(value)) {
      result[key] = value.cast()
    }
  }
  result
}

///|
extern "js" fn ffi_get_all_cookies(c : @core.Any) -> @core.Any =
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
  expires? : @core.Any,
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
  ffi_set_cookie_with_options(c.as_any(), name, value, opts)
}

///|
extern "js" fn ffi_set_cookie_with_options(
  c : @core.Any,
  name : String,
  value : String,
  options : @core.Any,
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
  let result = ffi_delete_cookie_with_options(c.as_any(), name, opts)
  if @core.is_nullish(result) {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_delete_cookie_with_options(
  c : @core.Any,
  name : String,
  options : @core.Any,
) -> @core.Any =
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
  let result = ffi_get_signed_cookie(c.as_any(), secret, name).wait()
  if @core.is_nullish(result) || @core.typeof_(result) == "boolean" {
    None
  } else {
    Some(result.cast())
  }
}

///|
extern "js" fn ffi_get_signed_cookie(
  c : @core.Any,
  secret : String,
  name : String,
) -> @core.Promise[@core.Any] =
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
  expires? : @core.Any,
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
  ffi_set_signed_cookie_with_options(c.as_any(), name, value, secret, opts).wait()
}

///|
extern "js" fn ffi_set_signed_cookie_with_options(
  c : @core.Any,
  name : String,
  value : String,
  secret : String,
  options : @core.Any,
) -> @core.Promise[Unit] =
  #|(c, name, value, secret, options) => {
  #|  const { setSignedCookie } = require('hono/cookie');
  #|  return setSignedCookie(c, name, value, secret, options);
  #|}
