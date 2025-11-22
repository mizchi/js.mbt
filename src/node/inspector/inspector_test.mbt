///|
/// Test Session creation
test "Session::new creates session" {
  let session = Session::new()
  inspect(@js.typeof_(session.to_js()), content="object")
}

///|
/// Test Session connect and disconnect
test "Session connect and disconnect" {
  let session = Session::new()
  session.connect()
  session.disconnect()
  inspect(@js.typeof_(session.to_js()), content="object")
}

///|
/// Test url function
test "url returns string or undefined" {
  let result = url()
  match result {
    Some(_) => inspect(true, content="true")
    None => inspect(true, content="true")
  }
}

///|
/// Test console function
test "console returns Console instance" {
  let inspector_console = console()
  inspect(@js.typeof_(inspector_console.to_js()), content="object")
}
