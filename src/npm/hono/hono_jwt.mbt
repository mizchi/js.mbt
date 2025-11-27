///|
/// Hono JWT Helper
/// https://hono.dev/docs/helpers/jwt

///|
/// JWT Algorithm types
pub(all) enum JwtAlgorithm {
  HS256
  HS384
  HS512
  RS256
  RS384
  RS512
  PS256
  PS384
  PS512
  ES256
  ES384
  ES512
  EdDSA
}

///|
fn algorithm_to_string(alg : JwtAlgorithm) -> String {
  match alg {
    HS256 => "HS256"
    HS384 => "HS384"
    HS512 => "HS512"
    RS256 => "RS256"
    RS384 => "RS384"
    RS512 => "RS512"
    PS256 => "PS256"
    PS384 => "PS384"
    PS512 => "PS512"
    ES256 => "ES256"
    ES384 => "ES384"
    ES512 => "ES512"
    EdDSA => "EdDSA"
  }
}

///|
/// JWT Payload type
pub(all) struct JwtPayload {
  sub : String? // Subject
  iss : String? // Issuer
  aud : String? // Audience
  exp : Int? // Expiration time (Unix timestamp)
  nbf : Int? // Not before time
  iat : Int? // Issued at time
  jti : String? // JWT ID
}

///|
/// Default JWT payload
pub fn JwtPayload::default() -> JwtPayload {
  {
    sub: None,
    iss: None,
    aud: None,
    exp: None,
    nbf: None,
    iat: None,
    jti: None,
  }
}

///|
fn payload_to_js(payload : JwtPayload) -> @js.Any {
  let obj = @js.Object::new()
  if payload.sub is Some(v) {
    obj.set("sub", v)
  }
  if payload.iss is Some(v) {
    obj.set("iss", v)
  }
  if payload.aud is Some(v) {
    obj.set("aud", v)
  }
  if payload.exp is Some(v) {
    obj.set("exp", v)
  }
  if payload.nbf is Some(v) {
    obj.set("nbf", v)
  }
  if payload.iat is Some(v) {
    obj.set("iat", v)
  }
  if payload.jti is Some(v) {
    obj.set("jti", v)
  }
  obj.to_any()
}

///|
/// Decoded JWT result
pub struct JwtDecoded {
  header : @js.Any
  payload : @js.Any
}

///|
/// Sign a JWT token
/// https://hono.dev/docs/helpers/jwt#sign
pub async fn jwt_sign(
  payload : @js.Any,
  secret : String,
  alg? : JwtAlgorithm,
) -> String {
  match alg {
    Some(a) =>
      ffi_jwt_sign_with_alg(payload, secret, algorithm_to_string(a)).wait()
    None => ffi_jwt_sign(payload, secret).wait()
  }
}

///|
/// Sign a JWT token with structured payload
pub async fn jwt_sign_payload(
  payload : JwtPayload,
  secret : String,
  alg? : JwtAlgorithm,
) -> String {
  jwt_sign(payload_to_js(payload), secret, alg?)
}

///|
extern "js" fn ffi_jwt_sign(
  payload : @js.Any,
  secret : String,
) -> @js.Promise[String] =
  #|(payload, secret) => {
  #|  const { sign } = require('hono/jwt');
  #|  return sign(payload, secret);
  #|}

///|
extern "js" fn ffi_jwt_sign_with_alg(
  payload : @js.Any,
  secret : String,
  alg : String,
) -> @js.Promise[String] =
  #|(payload, secret, alg) => {
  #|  const { sign } = require('hono/jwt');
  #|  return sign(payload, secret, alg);
  #|}

///|
/// Verify a JWT token
/// Returns the payload if valid, throws on invalid token
/// https://hono.dev/docs/helpers/jwt#verify
pub async fn jwt_verify(
  token : String,
  secret : String,
  alg? : JwtAlgorithm,
) -> @js.Any {
  match alg {
    Some(a) =>
      ffi_jwt_verify_with_alg(token, secret, algorithm_to_string(a)).wait()
    None => ffi_jwt_verify(token, secret).wait()
  }
}

///|
extern "js" fn ffi_jwt_verify(
  token : String,
  secret : String,
) -> @js.Promise[@js.Any] =
  #|(token, secret) => {
  #|  const { verify } = require('hono/jwt');
  #|  return verify(token, secret);
  #|}

///|
extern "js" fn ffi_jwt_verify_with_alg(
  token : String,
  secret : String,
  alg : String,
) -> @js.Promise[@js.Any] =
  #|(token, secret, alg) => {
  #|  const { verify } = require('hono/jwt');
  #|  return verify(token, secret, alg);
  #|}

///|
/// Decode a JWT token without verification
/// https://hono.dev/docs/helpers/jwt#decode
pub fn jwt_decode(token : String) -> JwtDecoded {
  let result = ffi_jwt_decode(token)
  { header: result.get("header"), payload: result.get("payload") }
}

///|
extern "js" fn ffi_jwt_decode(token : String) -> @js.Any =
  #|(token) => {
  #|  const { decode } = require('hono/jwt');
  #|  return decode(token);
  #|}
