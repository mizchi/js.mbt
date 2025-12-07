///| Tests for jose bindings

///|
test "base64url encode and decode" {
  let original = "Hello, World!"
  let encoded = base64url_encode(original)
  let decoded = base64url_decode(encoded)
  inspect(decoded, content="Hello, World!")
}

///|
async test "JWT sign and verify" {
  let payload = @core.from_entries([
    ("sub", @core.any("1234567890")),
    ("name", @core.any("John Doe")),
    ("iat", @core.any(1516239022)),
  ])
  let secret = "your-256-bit-secret"

  // Sign JWT
  let token = signJWT(payload, secret)

  // Verify JWT
  let verified_payload = verifyJWT(token, secret)
  let name : String = verified_payload["name"].cast()
  inspect(name, content="John Doe")
}

///|
async test "JWT with expiration and issuer" {
  let payload = @core.from_entries([("data", @core.any("test"))])
  let secret = "test-secret"
  let token = signJWT(
    payload,
    secret,
    expiresIn="2h",
    issuer="test-issuer",
    audience="test-audience",
  )
  let verified = verifyJWT(
    token,
    secret,
    issuer="test-issuer",
    audience="test-audience",
  )
  let data : String = verified["data"].cast()
  inspect(data, content="test")
}

///|
async test "JWS compact sign and verify" {
  let payload = @core.any("test payload")
  let secret = "test-secret"
  let jws = compactSign(payload, secret)
  let verified = compactVerify(jws, secret)
  inspect(verified, content="Any")
}

///|
async test "JWE compact encrypt and decrypt" {
  let plaintext = "secret message"
  let secret = "your-256-bit-secretyour-256-b"
  let encrypted = compactEncrypt(plaintext, secret)
  let decrypted = compactDecrypt(encrypted, secret)
  inspect(decrypted, content="secret message")
}

///|
async test "Generate secret key" {
  let secret = generateSecret("HS256")
  inspect(secret, content="Any")
}

///|
test "Decode JWT without verification" {
  let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  let payload = decodeJWT(token)
  let name : String = payload["name"].cast()
  inspect(name, content="John Doe")
}

///|
test "Decode protected header" {
  let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  let header = decodeProtectedHeader(token)
  let alg : String = header["alg"].cast()
  inspect(alg, content="HS256")
}
