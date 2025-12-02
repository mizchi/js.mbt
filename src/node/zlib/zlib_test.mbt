///|
/// Test ZlibOptions creation
test "ZlibOptions::new creates options" {
  let options = ZlibOptions::new()
  let js_obj = options.as_any()
  inspect(@nostd.typeof_(js_obj), content="object")
}

///|
/// Test create_gzip returns stream
test "create_gzip returns stream" {
  let options = ZlibOptions::new()
  let gzip = create_gzip(options)
  inspect(@nostd.typeof_(gzip.as_any()), content="object")
}

///|
/// Test create_deflate returns stream
test "create_deflate returns stream" {
  let options = ZlibOptions::new()
  let deflate = create_deflate(options)
  inspect(@nostd.typeof_(deflate.as_any()), content="object")
}

///|
/// Test create_brotli_compress returns stream
test "create_brotli_compress returns stream" {
  let options = ZlibOptions::new()
  let brotli = create_brotli_compress(options)
  inspect(@nostd.typeof_(brotli.as_any()), content="object")
}
