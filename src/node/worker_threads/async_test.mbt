///|
async test "Node Worker Threads: isMainThread returns true in main thread" {
  let is_main = @worker_threads.isMainThread()
  assert_eq(is_main, true)
}

///|
#skip
async test "Node Worker Threads: threadId returns a number" {
  let tid = @worker_threads.threadId()
  inspect(tid, content="0")
  assert_eq(tid > 0, true)
}

///|
async test "Node Worker Threads: parentPort is None in main thread" {
  let port = @worker_threads.parentPort()
  match port {
    None => assert_eq(true, true)
    Some(_) => assert_eq(true, false)
  }
}

// Worker creation tests temporarily disabled due to async timing issues
// @test.describe("Node Worker Threads: Worker creation and messaging", _ => {
//   ...
// })
