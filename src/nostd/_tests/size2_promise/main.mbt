///|
/// Lightweight Promise wrapper for nostd
/// Test case for measuring Promise wait overhead with multiple awaits

///|
extern "js" fn get_console() -> @nostd.Any =
  #| () => console

///|
/// JS: new Promise((resolve) => setTimeout(() => resolve(value), ms))
extern "js" fn delay_string(ms : Int, value : String) -> @nostd.Promise[String] =
  #| (ms, value) => new Promise(r => setTimeout(() => r(value), ms))

///|
fn log(con : @nostd.Any, msg : String) -> Unit {
  con._call("log", [@nostd.any(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()
  @nostd.run_async(async fn() noraise {
    // Multiple awaits to see how state machine grows
    let r1 : String = delay_string(1, "Step 1").wait() catch { _ => "err" }
    log(con, r1)
    let r2 : String = delay_string(1, "Step 2").wait() catch { _ => "err" }
    log(con, r2)
    let r3 : String = delay_string(1, "Step 3").wait() catch { _ => "err" }
    log(con, r3)
  })
}
