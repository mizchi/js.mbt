///|
/// Test ZlibOptions creation
test "ZlibOptions::new creates options" {
  let options = ZlibOptions::new()
  let js_obj = options.to_any()
  inspect(@js.typeof_(js_obj), content="object")
}

///|
/// Test create_gzip returns stream
test "create_gzip returns stream" {
  let options = ZlibOptions::new()
  let gzip = create_gzip(options)
  inspect(@js.typeof_(gzip.to_any()), content="object")
}

///|
/// Test create_deflate returns stream
test "create_deflate returns stream" {
  let options = ZlibOptions::new()
  let deflate = create_deflate(options)
  inspect(@js.typeof_(deflate.to_any()), content="object")
}

///|
/// Test create_brotli_compress returns stream
test "create_brotli_compress returns stream" {
  let options = ZlibOptions::new()
  let brotli = create_brotli_compress(options)
  inspect(@js.typeof_(brotli.to_any()), content="object")
}
