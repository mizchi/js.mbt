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
    @js.unsafe_cast(fn(code : @js.Js, signal : @js.Js) {
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
    @js.unsafe_cast(fn(code : @js.Js, signal : @js.Js) {
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
/// Callback receives: error (@js.Js)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.call2("on", "error", @js.unsafe_cast(callback)) |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (@js.Js), sendHandle (@js.Js?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (@js.Js, @js.Js?) -> Unit noraise,
) -> Unit {
  self.call("on", [
    "message",
    @js.unsafe_cast(fn(message : @js.Js, sendHandle : @js.Js) {
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
/// Callback receives: data (@js.Js) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (@js.Js) -> Unit noraise,
) -> Unit {
  self.stdout.call2("on", "data", @js.unsafe_cast(callback)) |> ignore
}
