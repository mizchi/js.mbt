///|
extern "js" fn console_log(v : @nostd.Any) -> Unit =
  #| (v) => console.log(v)

///|
extern "js" fn make_promise(v : Int) -> @nostd.Promise[Int] =
  #| (v) => Promise.resolve(v)

///|
async fn async_example() -> Int {
  let p = make_promise(42)
  p.wait()
}

///|
extern "js" fn run_async(f : async () -> Unit) -> Unit =
  #| (f) => f()

///|
fn main {
  run_async(async fn() {
    let result = async_example()
    console_log(@nostd.any(result))
  })
}
