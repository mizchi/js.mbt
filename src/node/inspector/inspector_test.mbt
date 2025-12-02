///|
/// Test Session creation
test "Session::new creates session" {
  let session = Session::new()
  let session_js : @nostd.Any = session.as_any().cast()
  inspect(@nostd.typeof_(session_js), content="object")
}

///|
/// Test Session connect and disconnect
test "Session connect and disconnect" {
  let session = Session::new()
  session.connect()
  session.disconnect()
  let session_js : @nostd.Any = session.as_any().cast()
  inspect(@nostd.typeof_(session_js), content="object")
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
  let console_js : @nostd.Any = @nostd.any(inspector_console)
  inspect(@nostd.typeof_(console_js), content="object")
}
