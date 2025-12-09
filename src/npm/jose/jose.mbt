///| npm jose package FFI bindings
/// https://github.com/panva/jose
/// https://www.npmjs.com/package/jose
/// JavaScript module for JSON Object Signing and Encryption (JOSE)

///|
extern "js" fn jose_module() -> @core.Any =
  #| () => require("jose")

///|
extern "js" fn ffi_new_sign_jwt(
  jose : @core.Any,
  payload : @core.Any,
) -> @core.Any =
  #| (jose, payload) => new jose.SignJWT(payload)

///|
extern "js" fn ffi_new_compact_sign(
  jose : @core.Any,
  payload : @core.Any,
) -> @core.Any =
  #| (jose, payload) => new jose.CompactSign(payload)

///|
extern "js" fn ffi_new_compact_encrypt(
  jose : @core.Any,
  plaintext : @core.Any,
) -> @core.Any =
  #| (jose, plaintext) => new jose.CompactEncrypt(plaintext)

///| JWT - JSON Web Token

///|
/// Sign a JWT
pub async fn signJWT(
  payload : @core.Any,
  secret : String,
  alg? : String,
  expiresIn? : String,
  issuer? : String,
  audience? : String,
  subject? : String,
  jti? : String,
) -> String {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let jwt_constructor = ffi_new_sign_jwt(jose, payload)

  // Set protected header
  let alg_val = match alg {
    Some(v) => v
    None => "HS256"
  }
  let with_header = jwt_constructor._call("setProtectedHeader", [
    @core.from_entries([("alg", @core.any(alg_val))]),
  ])

  // Set claims
  let mut with_claims = with_header
  match expiresIn {
    Some(v) =>
      with_claims = with_claims._call("setExpirationTime", [@core.any(v)])
    None => ()
  }
  match issuer {
    Some(v) => with_claims = with_claims._call("setIssuer", [@core.any(v)])
    None => ()
  }
  match audience {
    Some(v) => with_claims = with_claims._call("setAudience", [@core.any(v)])
    None => ()
  }
  match subject {
    Some(v) => with_claims = with_claims._call("setSubject", [@core.any(v)])
    None => ()
  }
  match jti {
    Some(v) => with_claims = with_claims._call("setJti", [@core.any(v)])
    None => ()
  }

  // Sign
  let promise : @core.Promise[String] = @core.identity(
    with_claims._call("sign", [secret_bytes.as_any()]),
  )
  promise.wait()
}

///|
/// Verify a JWT and return payload
pub async fn verifyJWT(
  token : String,
  secret : String,
  issuer? : String,
  audience? : String,
) -> @core.Any {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let opts = @core.new_object()
  match issuer {
    Some(v) => opts["issuer"] = @core.any(v)
    None => ()
  }
  match audience {
    Some(v) => opts["audience"] = @core.any(v)
    None => ()
  }
  let jwtVerify = jose["jwtVerify"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    jwtVerify._invoke([@core.any(token), secret_bytes.as_any(), opts]),
  )
  let result = promise.wait()
  result["payload"]
}

///| JWS - JSON Web Signature

///|
/// Compact JWS Sign
pub async fn compactSign(
  payload : @core.Any,
  secret : String,
  alg? : String,
) -> String {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let alg_val = match alg {
    Some(v) => v
    None => "HS256"
  }
  let jws = ffi_new_compact_sign(jose, payload)
  let with_header = jws._call("setProtectedHeader", [
    @core.from_entries([("alg", @core.any(alg_val))]),
  ])
  let promise : @core.Promise[String] = @core.identity(
    with_header._call("sign", [secret_bytes.as_any()]),
  )
  promise.wait()
}

///|
/// Compact JWS Verify
pub async fn compactVerify(jws : String, secret : String) -> @core.Any {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let verifyFn = jose["compactVerify"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    verifyFn._invoke([@core.any(jws), secret_bytes.as_any()]),
  )
  promise.wait()
}

///| JWE - JSON Web Encryption

///|
/// Compact JWE Encrypt
pub async fn compactEncrypt(
  plaintext : String,
  secret : String,
  alg? : String,
  enc? : String,
) -> String {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let plaintext_bytes = secret_encoder.encode(plaintext)
  let alg_val = match alg {
    Some(v) => v
    None => "dir"
  }
  let enc_val = match enc {
    Some(v) => v
    None => "A256GCM"
  }
  let jwe = ffi_new_compact_encrypt(jose, plaintext_bytes.as_any())
  let with_header = jwe._call("setProtectedHeader", [
    @core.from_entries([
      ("alg", @core.any(alg_val)),
      ("enc", @core.any(enc_val)),
    ]),
  ])
  let promise : @core.Promise[String] = @core.identity(
    with_header._call("encrypt", [secret_bytes.as_any()]),
  )
  promise.wait()
}

///|
/// Compact JWE Decrypt
pub async fn compactDecrypt(jwe : String, secret : String) -> String {
  let jose = jose_module()
  let secret_encoder = @encoding.TextEncoder::new()
  let secret_bytes = secret_encoder.encode(secret)
  let decryptFn = jose["compactDecrypt"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    decryptFn._invoke([@core.any(jwe), secret_bytes.as_any()]),
  )
  let result = promise.wait()
  let plaintext_bytes : @arraybuffer.Uint8Array = result["plaintext"].cast()

  // Decode Uint8Array to string
  let decoder = @encoding.TextDecoder::new()
  decoder.decode(plaintext_bytes)
}

///| JWK - JSON Web Key

///|
/// Generate secret key
pub async fn generateSecret(alg : String, extractable? : Bool) -> @core.Any {
  let jose = jose_module()
  let opts = @core.new_object()
  match extractable {
    Some(v) => opts["extractable"] = @core.any(v)
    None => ()
  }
  let generateSecretFn = jose["generateSecret"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    generateSecretFn._invoke([@core.any(alg), opts]),
  )
  promise.wait()
}

///|
/// Generate key pair
pub async fn generateKeyPair(alg : String, extractable? : Bool) -> @core.Any {
  let jose = jose_module()
  let opts = @core.new_object()
  match extractable {
    Some(v) => opts["extractable"] = @core.any(v)
    None => ()
  }
  let generateKeyPairFn = jose["generateKeyPair"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    generateKeyPairFn._invoke([@core.any(alg), opts]),
  )
  promise.wait()
}

///|
/// Export JWK
pub async fn exportJWK(key : @core.Any) -> @core.Any {
  let jose = jose_module()
  let exportJWKFn = jose["exportJWK"]
  let promise : @core.Promise[@core.Any] = @core.identity(
    exportJWKFn._invoke([key]),
  )
  promise.wait()
}

///|
/// Import JWK
pub async fn importJWK(jwk : @core.Any, alg? : String) -> @core.Any {
  let jose = jose_module()
  let importJWKFn = jose["importJWK"]
  match alg {
    Some(alg_val) => {
      let promise : @core.Promise[@core.Any] = @core.identity(
        importJWKFn._invoke([jwk, @core.any(alg_val)]),
      )
      promise.wait()
    }
    None => {
      let promise : @core.Promise[@core.Any] = @core.identity(
        importJWKFn._invoke([jwk]),
      )
      promise.wait()
    }
  }
}

///| Utility functions

///|
/// Decode JWT without verification (unsafe, for debugging only)
pub fn decodeJWT(token : String) -> @core.Any {
  let jose = jose_module()
  let decodeFn = jose["decodeJwt"]
  decodeFn._invoke([@core.any(token)])
}

///|
/// Decode protected header
pub fn decodeProtectedHeader(token : String) -> @core.Any {
  let jose = jose_module()
  let decodeFn = jose["decodeProtectedHeader"]
  decodeFn._invoke([@core.any(token)])
}

///|
/// Base64URL encode
pub fn base64url_encode(input : String) -> String {
  let jose = jose_module()
  let base64url = jose["base64url"]
  let encoder = @encoding.TextEncoder::new()
  let bytes = encoder.encode(input)
  base64url._call("encode", [bytes.as_any()]).cast()
}

///|
/// Base64URL decode
pub fn base64url_decode(input : String) -> String {
  let jose = jose_module()
  let base64url = jose["base64url"]
  let bytes : @arraybuffer.Uint8Array = base64url
    ._call("decode", [@core.any(input)])
    .cast()
  let decoder = @encoding.TextDecoder::new()
  decoder.decode(bytes)
}
