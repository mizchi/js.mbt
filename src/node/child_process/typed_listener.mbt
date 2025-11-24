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
    @js.identity(fn(code : @js.Any, signal : @js.Any) {
      callback(
        code |> @js.identity_option(),
        signal |> @js.identity_option(),
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
    @js.identity(fn(code : @js.Any, signal : @js.Any) {
      callback(
        code |> @js.identity_option(),
        signal |> @js.identity_option(),
      )
    }),
  ])
  |> ignore
}

///|
/// Listen for 'error' event with typed callback
/// Callback receives: error (@js.Any)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (@js.Any) -> Unit noraise,
) -> Unit {
  self.call2("on", "error", @js.identity(callback)) |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (@js.Any), sendHandle (@js.Any?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (@js.Any, @js.Any?) -> Unit noraise,
) -> Unit {
  self.call("on", [
    "message",
    @js.identity(fn(message : @js.Any, sendHandle : @js.Any) {
      callback(message, sendHandle |> @js.identity_option())
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
  self.call2("on", "disconnect", @js.identity(callback)) |> ignore
}

///|
/// Listen for 'spawn' event with typed callback
/// No parameters
pub fn ChildProcess::on_spawn(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  self.call2("on", "spawn", @js.identity(callback)) |> ignore
}

///|
/// Listen for stdout 'data' event with typed callback
/// Callback receives: data (@js.Any) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (@js.Any) -> Unit noraise,
) -> Unit {
  self.stdout.call2("on", "data", @js.identity(callback)) |> ignore
}
