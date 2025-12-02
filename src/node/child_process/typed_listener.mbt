///| ChildProcess Typed Event Handlers

///|
/// Listen for 'exit' event with typed callback
/// Callback receives: code (Int?), signal (String?)
pub fn ChildProcess::on_exit(
  self : Self,
  callback : (Int?, String?) -> Unit noraise,
) -> Unit {
  @core.any(self)._call("on", [
    @core.any("exit"),
    @core.any(
      @js.from_fn2(fn(code : @core.Any, signal : @core.Any) {
        callback(
          code |> @core.identity_option(),
          signal |> @core.identity_option(),
        )
      }),
    ),
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
  @core.any(self)._call("on", [
    @core.any("close"),
    @core.any(
      @js.from_fn2(fn(code : @core.Any, signal : @core.Any) {
        callback(
          code |> @core.identity_option(),
          signal |> @core.identity_option(),
        )
      }),
    ),
  ])
  |> ignore
}

///|
/// Listen for 'error' event with typed callback
/// Callback receives: error (JsError)
pub fn ChildProcess::on_error(
  self : Self,
  callback : (@js.JsError) -> Unit noraise,
) -> Unit {
  @core.any(self)._call("on", [
    @core.any("error"),
    @core.any(@js.from_fn1(callback)),
  ])
  |> ignore
}

///|
/// Listen for 'message' event with typed callback
/// Callback receives: message (@core.Any), sendHandle (@core.Any?)
pub fn ChildProcess::on_message(
  self : Self,
  callback : (@core.Any, @core.Any?) -> Unit noraise,
) -> Unit {
  @core.any(self)._call("on", [
    @core.any("message"),
    @core.any(
      @js.from_fn2(fn(message : @core.Any, sendHandle : @core.Any) {
        callback(message, sendHandle |> @core.identity_option())
      }),
    ),
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
  @core.any(self)._call("on", [
    @core.any("disconnect"),
    @core.any(@js.from_fn0(callback)),
  ])
  |> ignore
}

///|
/// Listen for 'spawn' event with typed callback
/// No parameters
pub fn ChildProcess::on_spawn(
  self : Self,
  callback : () -> Unit noraise,
) -> Unit {
  @core.any(self)._call("on", [
    @core.any("spawn"),
    @core.any(@js.from_fn0(callback)),
  ])
  |> ignore
}

///|
/// Listen for stdout 'data' event with typed callback
/// Callback receives: data (@core.Any) - typically Buffer or String
pub fn ChildProcess::on_stdout_data(
  self : Self,
  callback : (@core.Any) -> Unit noraise,
) -> Unit {
  @core.any(self.stdout())._call("on", [
    @core.any("data"),
    @core.any(@js.from_fn1(callback)),
  ])
  |> ignore
}
