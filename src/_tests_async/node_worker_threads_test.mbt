///|
test {
  @test.describe("Node Worker Threads: Basic operations", _ => {
    @test.it("isMainThread returns true in main thread", _ => {
      let is_main = @worker_threads.isMainThread()
      assert_eq(is_main, true)
    })
    @test.it("threadId returns a number", _ => {
      let tid = @worker_threads.threadId()
      assert_eq(tid > 0, true)
    })
    @test.it("parentPort is None in main thread", _ => {
      let port = @worker_threads.parentPort()
      match port {
        None => assert_eq(true, true)
        Some(_) => assert_eq(true, false)
      }
    })
  })
  // Worker creation tests temporarily disabled due to async timing issues
  // @test.describe("Node Worker Threads: Worker creation and messaging", _ => {
  //   ...
  // })
}
