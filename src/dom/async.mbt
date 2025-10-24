///|
async fn[T, E : Error] suspend(
  f : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
fn run_async(f : async () -> Unit noraise) -> Unit = "%async.run"

///|
test {
  run_async(fn() noraise { println("Starting async test...") })
}
