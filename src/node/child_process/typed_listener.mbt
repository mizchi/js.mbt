///| ChildProcess Typed Event Handlers

///|
/// Listen for 'exit' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_exit(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  self.call("on", [
    "exit",
    @js.unsafe_cast(fn(code : Js, signal : Js) {
      callback(
        code |> @js.unsafe_cast_option(),
        signal |> @js.unsafe_cast_option(),
      )
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
  self.call("on", [
    "close",
    @js.unsafe_cast(fn(code : Js, signal : Js) {
      callback(
        code |> @js.unsafe_cast_option(),
        signal |> @js.unsafe_cast_option(),
      )
    }),
  ])
  |> ignore
}

///|
/// Listen for 'error' event with typed callback
/// Callback receives: error (Js)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  self.call2("on", "error", @js.unsafe_cast(callback)) |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (Js), sendHandle (Js?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (Js, Js?) -> Unit noraise,
) -> Unit {
  self.call("on", [
    "message",
    @js.unsafe_cast(fn(message : Js, sendHandle : Js) {
      callback(message, sendHandle |> @js.unsafe_cast_option())
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
  self.call2("on", "disconnect", @js.unsafe_cast(callback)) |> ignore
}

///|
/// Listen for 'spawn' event with typed callback
/// No parameters
pub fn ChildProcess::on_spawn(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.call2("on", "spawn", @js.unsafe_cast(callback)) |> ignore
}

///|
/// Listen for stdout 'data' event with typed callback
/// Callback receives: data (Js) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (Js) -> Unit noraise,
) -> Unit {
  self.stdout.call2("on", "data", @js.unsafe_cast(callback)) |> ignore
}
