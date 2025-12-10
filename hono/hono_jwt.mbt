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
fn payload_to_js(payload : JwtPayload) -> @core.Any {
  let obj = @core.new_object()
  if payload.sub is Some(v) {
    obj["sub"] = @core.any(v)
  }
  if payload.iss is Some(v) {
    obj["iss"] = @core.any(v)
  }
  if payload.aud is Some(v) {
    obj["aud"] = @core.any(v)
  }
  if payload.exp is Some(v) {
    obj["exp"] = @core.any(v)
  }
  if payload.nbf is Some(v) {
    obj["nbf"] = @core.any(v)
  }
  if payload.iat is Some(v) {
    obj["iat"] = @core.any(v)
  }
  if payload.jti is Some(v) {
    obj["jti"] = @core.any(v)
  }
  obj
}

///|
/// Decoded JWT result
pub struct JwtDecoded {
  header : @core.Any
  payload : @core.Any
}

///| FFI with #module for ESM

///|
#module("hono/jwt")
extern "js" fn ffi_jwt_sign(
  payload : @core.Any,
  secret : String,
) -> @js.Promise[String] = "sign"

///|
#module("hono/jwt")
extern "js" fn ffi_jwt_sign_with_alg(
  payload : @core.Any,
  secret : String,
  alg : String,
) -> @js.Promise[String] = "sign"

///|
#module("hono/jwt")
extern "js" fn ffi_jwt_verify(
  token : String,
  secret : String,
) -> @js.Promise[@core.Any] = "verify"

///|
#module("hono/jwt")
extern "js" fn ffi_jwt_verify_with_alg(
  token : String,
  secret : String,
  alg : String,
) -> @js.Promise[@core.Any] = "verify"

///|
#module("hono/jwt")
extern "js" fn ffi_jwt_decode(token : String) -> @core.Any = "decode"

///| Public API

///|
/// Sign a JWT token
/// https://hono.dev/docs/helpers/jwt#sign
pub async fn jwt_sign(
  payload : @core.Any,
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
/// Verify a JWT token
/// Returns the payload if valid, throws on invalid token
/// https://hono.dev/docs/helpers/jwt#verify
pub async fn jwt_verify(
  token : String,
  secret : String,
  alg? : JwtAlgorithm,
) -> @core.Any {
  match alg {
    Some(a) =>
      ffi_jwt_verify_with_alg(token, secret, algorithm_to_string(a)).wait()
    None => ffi_jwt_verify(token, secret).wait()
  }
}

///|
/// Decode a JWT token without verification
/// https://hono.dev/docs/helpers/jwt#decode
pub fn jwt_decode(token : String) -> JwtDecoded {
  let result = ffi_jwt_decode(token)
  { header: result["header"], payload: result["payload"] }
}
