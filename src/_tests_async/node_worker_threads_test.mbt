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
  @test.describe("Node Worker Threads: Worker creation and messaging", _ => {
    @test.it("creates a worker and receives init message", _ => {
      let worker_data = @js.from_map({ "value": @js.js(42) })
      let worker = @worker_threads.Worker::new(
        "./fixtures/workers/simple_worker.mjs",
        workerData=worker_data,
      )
      let mut received_init = false
      let mut received_data : Int = 0
      worker.on("message", (msg : @js.Js) => @js.run_async(() => {
        @js.sleep(1)
        let msg_type : String = @js.unsafe_cast(msg.get("type"))
        match msg_type {
          "init" => {
            received_init = true
            let data = msg.get("workerData")
            received_data = @js.unsafe_cast(data.get("value"))
          }
          _ => ()
        }
      }))
      @js.sleep(50)
      assert_eq(received_init, true)
      assert_eq(received_data, 42)
      worker.terminate()
    })
    @test.it("sends message to worker and receives echo", _ => {
      let worker = @worker_threads.Worker::new(
        "./fixtures/workers/simple_worker.mjs",
      )
      let mut received_echo = false
      let mut echo_data : String = ""
      worker.on("message", (msg : @js.Js) => @js.run_async(() => {
        @js.sleep(1)
        let msg_type : String = @js.unsafe_cast(msg.get("type"))
        match msg_type {
          "echo" => {
            received_echo = true
            echo_data = @js.unsafe_cast(msg.get("data"))
          }
          _ => ()
        }
      }))
      // Wait for worker to be ready
      @js.sleep(20)
      worker.postMessage("hello")
      @js.sleep(50)
      assert_eq(received_echo, true)
      assert_eq(echo_data, "hello")
      worker.terminate()
    })
    @test.it("worker performs computation", _ => {
      let worker = @worker_threads.Worker::new(
        "./fixtures/workers/compute_worker.mjs",
      )
      let mut result : Int = 0
      worker.on("message", (msg : @js.Js) => @js.run_async(() => {
        @js.sleep(1)
        let msg_type : String = @js.unsafe_cast(msg.get("type"))
        match msg_type {
          "result" => result = @js.unsafe_cast(msg.get("value"))
          _ => ()
        }
      }))
      // Wait for worker to be ready
      @js.sleep(20)
      let msg_data = @js.from_map({
        "type": @js.js("add"),
        "a": @js.js(10),
        "b": @js.js(32),
      })
      worker.postMessage(msg_data)
      @js.sleep(50)
      assert_eq(result, 42)
      worker.terminate()
    })
    @test.it("worker exits gracefully", _ => {
      let worker = @worker_threads.Worker::new(
        "./fixtures/workers/exit_worker.mjs",
      )
      let mut exited = false
      let mut exit_code : Int = -1
      worker.on("exit", (code : @js.Js) => @js.run_async(() => {
        @js.sleep(1)
        exited = true
        exit_code = @js.unsafe_cast(code)
      }))
      // Wait for worker to be ready
      @js.sleep(20)
      let msg_data = @js.from_map({ "type": @js.js("exit"), "code": @js.js(0) })
      worker.postMessage(msg_data)
      @js.sleep(50)
      assert_eq(exited, true)
      assert_eq(exit_code, 0)
    })
    @test.it("worker threadId is different from main", _ => {
      let main_thread_id = @worker_threads.threadId()
      let worker = @worker_threads.Worker::new(
        "./fixtures/workers/simple_worker.mjs",
      )
      @js.sleep(20)
      let worker_thread_id = worker.threadId()
      assert_eq(worker_thread_id != main_thread_id, true)
      worker.terminate()
    })
  })
}
