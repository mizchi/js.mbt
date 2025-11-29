///|
/// Lightweight Promise wrapper for nostd
/// Test case for measuring Promise wait overhead with multiple awaits

///|
extern "js" fn get_console() -> @nostd.JsValue =
  #| () => console

///|
/// JS: new Promise((resolve) => setTimeout(() => resolve(value), ms))
extern "js" fn delay_string(ms : Int, value : String) -> @nostd.JsValue =
  #| (ms, value) => new Promise(r => setTimeout(() => r(value), ms))

///|
/// MoonBit builtin %async.suspend
async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
/// MoonBit builtin %async.run
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
/// Await a JS Promise using suspend
async fn[T] wait(promise : @nostd.JsValue) -> T {
  suspend(fn(resolve, reject) {
    promise._call("then", [@nostd.JsValue::from(resolve)]) |> ignore
    promise._call("catch", [@nostd.JsValue::from(reject)]) |> ignore
  })
}

///|
fn log(con : @nostd.JsValue, msg : String) -> Unit {
  con._call("log", [@nostd.JsValue::from(msg)]) |> ignore
}

///|
fn main {
  let con = get_console()
  run_async(async fn() noraise {
    // Multiple awaits to see how state machine grows
    let r1 : String = wait(delay_string(1, "Step 1")) catch { _ => "err" }
    log(con, r1)
    let r2 : String = wait(delay_string(1, "Step 2")) catch { _ => "err" }
    log(con, r2)
    let r3 : String = wait(delay_string(1, "Step 3")) catch { _ => "err" }
    log(con, r3)
  })
}
