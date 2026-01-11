///|
/// Test create_gzip returns stream
test "create_gzip returns stream" {
  let gzip = create_gzip()
  inspect(@core.typeof_(gzip.as_any()), content="object")
}

///|
/// Test create_deflate returns stream
test "create_deflate returns stream" {
  let deflate = create_deflate()
  inspect(@core.typeof_(deflate.as_any()), content="object")
}

///|
/// Test create_brotli_compress returns stream
test "create_brotli_compress returns stream" {
  let brotli = create_brotli_compress()
  inspect(@core.typeof_(brotli.as_any()), content="object")
}
