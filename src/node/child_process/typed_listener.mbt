///| ChildProcess Typed Event Handlers

///|
/// Listen for 'exit' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_exit(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  self.invoke("on", [
    "exit",
    unsafe_cast(fn(code : Val, signal : Val) {
      callback(code |> unsafe_option(), signal |> unsafe_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'close' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_close(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  self.invoke("on", [
    "close",
    unsafe_cast(fn(code : Val, signal : Val) {
      callback(code |> unsafe_option(), signal |> unsafe_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'error' event with typed callback
/// Callback receives: error (Val)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  self.invoke("on", ["error", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (Val), sendHandle (Val?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (Val, Val?) -> Unit noraise,
) -> Unit {
  self.invoke("on", [
    "message",
    unsafe_cast(fn(message : Val, sendHandle : Val) {
      callback(message, sendHandle |> unsafe_option())
    }),
  ])
  |> ignore
}

///|
/// Listen for 'disconnect' event with typed callback
/// No parameters
pub fn ChildProcess::on_disconnect(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.invoke("on", ["disconnect", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for 'spawn' event with typed callback
/// No parameters
pub fn ChildProcess::on_spawn(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.invoke("on", ["spawn", unsafe_cast(callback)]) |> ignore
}

///|
/// Listen for stdout 'data' event with typed callback
/// Callback receives: data (Val) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (Val) -> Unit noraise,
) -> Unit {
  match self.stdout() {
    Some(stream) =>
      stream.invoke("on", ["data", unsafe_cast(callback)]) |> ignore
    None => ()
  }
}
