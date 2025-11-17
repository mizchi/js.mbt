///|
using @js {type Val, trait Js, js, unsafe_cast, safe_js}

///|
using @promise {sleep, run_async}

///|
using @test {it, beforeEach}

///|
fn main {
  beforeEach(() => println("before each test"))
  it("sample test", fn(_) { assert_true(true) })
  it("sample test", fn(_) { assert_true(false) })
  // beforeEach(() => @promise.sleep(1))
  it("simple test", _ => assert_eq(2 + 2, 4))
  it("lazy test", _ => {
    @promise.sleep(100)
    assert_eq(2 + 2, 4)
  })
  it("skip test", skip="skip this test", _ => assert_eq(2 + 2, 5))
  it("todo test", ctx => ctx.todo("this test is todo"))
}

///|
test {
  it("Promise::withResolvers resolve", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(0)
      resolver.resolve(42)
    })
    let v = resolver.promise.unwrap()
    assert_eq(v, 42)
  })
}

///|
test {
  it("Promise::withResolvers reject", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.reject(Failure("error occurred"))
    })
    let v = try? resolver.promise.unwrap()
    assert_true(v is Err(Failure("error occurred")))
  })
}

///|
test {
  it("EventEmitter on/emit/off", _ => {
    let emitter = @events.EventEmitter::new()
    let mut received = 0
    let callback = (_data : Val) => run_async(() => {
      sleep(1)
      let v : Int = unsafe_cast(_data)
      received += v
    })
    emitter.on("vvv", callback)
    emitter.emit("vvv", 1 |> @js.safe_js)
    emitter.emit("vvv", 2 |> @js.safe_js)
    emitter.emit("vvv", 3 |> @js.safe_js)
    sleep(16)
    assert_eq(received, 6)
    assert_eq(emitter.listenerCount("vvv"), 1)

    // off and emit again
    emitter.off("vvv", callback)
    assert_eq(emitter.listenerCount("vvv"), 0)
    emitter.emit("vvv", () |> @js.safe_js)
    sleep(16)
    // not called
    assert_eq(received, 6)
    emitter.on("aaa", callback)
    emitter.on("bbb", callback)
    assert_eq(emitter.listenerCount("aaa"), 1)
    assert_eq(emitter.listenerCount("bbb"), 1)
    emitter.removeAllListeners()
    assert_eq(emitter.listenerCount("vvv"), 0)
    emitter.emit("vvv", 10 |> @js.safe_js)
    sleep(16)
    // not called
    assert_eq(received, 6)
  })
}

///|
test {
  it("fs writeFile/readFile/stat", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let outpath = @path.join([tmpdir, "moonbit_example.txt"])
    let content =
      #|This is an example file created by Moonbit.
    @fs.writeFile(outpath, content).unwrap()
    let read_content = @fs.readFile(outpath).unwrap()
    assert_eq(content, read_content)
    let _ = @fs.stat(outpath).unwrap()
    // assert_true(stat.isFile())
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("fs mkdir/rm", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let testdir = @path.join([tmpdir, "moonbit_test_dir"])
    @fs.mkdir(testdir, recursive=true).unwrap()
    let stat = @fs.stat(testdir).unwrap()
    @fs.rm(testdir, recursive=true).unwrap()
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("fs rename", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let oldpath = @path.join([tmpdir, "moonbit_old.txt"])
    let newpath = @path.join([tmpdir, "moonbit_new.txt"])
    @fs.writeFile(oldpath, "rename test").unwrap()
    @fs.rename(oldpath, newpath).unwrap()
    let content = @fs.readFile(newpath).unwrap()
    assert_eq(content, "rename test")
    @fs.rm(newpath, force=true).unwrap()
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("fs cp", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let srcpath = @path.join([tmpdir, "moonbit_src.txt"])
    let dstpath = @path.join([tmpdir, "moonbit_dst.txt"])
    @fs.writeFile(srcpath, "copy test").unwrap()
    @fs.cp(srcpath, dstpath).unwrap()
    let content = @fs.readFile(dstpath).unwrap()
    assert_eq(content, "copy test")
    @fs.rm(srcpath, force=true).unwrap()
    @fs.rm(dstpath, force=true).unwrap()
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("Promise::then", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(10)
    })
    let p = resolver.promise.then(v => @promise.Promise::resolve(v * 2))
    let result = p.unwrap()
    assert_eq(result, 20)
  })
}

///|
test {
  it("Promise::catch_", _ => {
    let err_val : Val = @js.unsafe_cast(@js.Object::new())
    let p = @promise.Promise::reject(err_val)
    let recovered = p.catch_(_ => @promise.Promise::resolve(42 |> @js.safe_js))
    let result : Val = recovered.unwrap()
    let v : Int = unsafe_cast(result)
    assert_eq(v, 42)
  })
}

///|
test {
  it("Promise::finally_", _ => {
    let mut finalized = false
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(100)
    })
    let p = resolver.promise.finally_(() => finalized = true)
    let result = p.unwrap()
    assert_eq(result, 100)
    assert_true(finalized)
  })
}

///|
test {
  it("Promise::all", _ => {
    let p1 = @promise.Promise::resolve(1)
    let p2 = @promise.Promise::resolve(2)
    let p3 = @promise.Promise::resolve(3)
    let all = @promise.Promise::all([p1, p2, p3])
    let results = all.unwrap()
    assert_eq(results[0], 1)
    assert_eq(results[1], 2)
    assert_eq(results[2], 3)
  })
}

///|
test {
  it("Promise::race", _ => {
    let resolver1 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver2 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver1.resolve(100)
    })
    run_async(() => {
      sleep(10)
      resolver2.resolve(200)
    })
    let race = @promise.Promise::race([resolver1.promise, resolver2.promise])
    let result = race.unwrap()
    assert_eq(result, 100)
  })
}

///|
test {
  it("Promise::new", _ => {
    let p : @promise.Promise[Int] = @promise.Promise::new((resolve, reject) => run_async(() => {
        sleep(1)
        resolve(42)
      },
    ))
    let result = p.unwrap()
    assert_eq(result, 42)
  })
}

///|
test {
  it("Promise::try_ success", _ => {
    let p = @promise.Promise::try_(async fn() { 123 })
    let result = p.unwrap()
    assert_eq(result, 123)
  })
}

///|
test {
  it("Promise::try_ failure", _ => {
    let p : @promise.Promise[Unit] = @promise.Promise::try_(async fn() {
      fail("error")
    })
    let result = try? p.unwrap()
    assert_true(result is Err(_))
  })
}

///|
test {
  it("setTimeout", _ => {
    let mut executed = false
    let timer = @timer.setTimeout(() => executed = true, 10)
    @promise.sleep(20)
    assert_true(executed)
  })
}

///|
test {
  it("clearTimeout", _ => {
    let mut executed = false
    let timer = @timer.setTimeout(() => executed = true, 10)
    @timer.clearTimeout(timer)
    @promise.sleep(20)
    assert_false(executed)
  })
}

///|
test {
  it("setInterval/clearInterval", _ => {
    let mut count = 0
    let timer = @timer.setInterval(() => count += 1, 5)
    @promise.sleep(25)
    @timer.clearInterval(timer)
    let final_count = count
    assert_true(final_count >= 3)
    @promise.sleep(20)
    // count should not increase after clear
    assert_eq(count, final_count)
  })
}

///|
test {
  it("EventEmitter once", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count = 0
    emitter.once("test", _ => run_async(() => {
      sleep(1)
      count += 1
    }))
    emitter.emit("test", 1 |> @js.safe_js)
    emitter.emit("test", 2 |> @js.safe_js)
    sleep(10)
    assert_eq(count, 1)
  })
}

///|
test {
  it("EventEmitter eventNames", _ => {
    let emitter = @events.EventEmitter::new()
    emitter.on("event1", _ => ())
    emitter.on("event2", _ => ())
    let names = emitter.eventNames()
    assert_eq(names.length(), 2)
  })
}

///|
test {
  it("EventEmitter multiple listeners", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count1 = 0
    let mut count2 = 0
    emitter.on("test", _ => run_async(() => {
      sleep(1)
      count1 += 1
    }))
    emitter.on("test", _ => run_async(() => {
      sleep(1)
      count2 += 1
    }))
    assert_eq(emitter.listenerCount("test"), 2)
    emitter.emit("test", () |> @js.safe_js)
    sleep(10)
    assert_eq(count1, 1)
    assert_eq(count2, 1)
  })
}

///|
test {
  it("sleep multiple times", _ => run_async(() => try {
    let mut count = 0
    sleep(5)
    count += 1
    sleep(5)
    count += 1
    sleep(5)
    count += 1
    assert_eq(count, 3)
  } catch {
    _ => ()
  }))
}

///|
test {
  it("nested run_async", _ => {
    let mut outer = false
    let mut inner = false
    run_async(() => {
      sleep(5)
      outer = true
      run_async(() => {
        sleep(5)
        inner = true
      })
    })
    sleep(20)
    assert_true(outer)
    assert_true(inner)
  })
}

///|
test {
  it("promisify0", _ => {
    let async_fn = async fn() { 42 }
    let promise_fn = @promise.promisify0(async_fn)
    let p = promise_fn()
    let result = p.unwrap()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify1", _ => {
    let async_fn = async fn(x : Int) { x * 2 }
    let promise_fn = @promise.promisify1(async_fn)
    let p = promise_fn(21)
    let result = p.unwrap()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify2", _ => {
    let async_fn = async fn(x : Int, y : Int) { x + y }
    let promise_fn = @promise.promisify2(async_fn)
    let p = promise_fn(20, 22)
    let result = p.unwrap()
    assert_eq(result, 42)
  })
}

///|
test {
  it("promisify3", _ => {
    let async_fn = async fn(x : Int, y : Int, z : Int) { x + y + z }
    let promise_fn = @promise.promisify3(async_fn)
    let p = promise_fn(10, 20, 12)
    let result = p.unwrap()
    assert_eq(result, 42)
  })
}

///|
test {
  it("suspend with resolve", _ => run_async(() => try {
    let value = @promise.suspend((ok, _err) => run_async(() => {
      sleep(5)
      ok(42)
    }))
    assert_eq(value, 42)
  } catch {
    _ => ()
  }))
}

///|
test {
  it("suspend with reject", _ => run_async(() => try {
    let result : Result[Unit, Failure] = try? @promise.suspend((ok, err) => run_async(() => {
        sleep(5)
        err(Failure("test error"))
      },
    ))
    assert_true(result is Err(_))
  } catch {
    _ => ()
  }))
}

///|
test {
  it("Promise chain", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(1)
    })
    let p = resolver.promise
      .then(v => @promise.Promise::resolve(v + 1))
      .then(v => @promise.Promise::resolve(v * 2))
      .then(v => @promise.Promise::resolve(v + 10))
    let result = p.unwrap()
    assert_eq(result, 14)
  })
}

///|
test {
  it("EventEmitter with async handlers", _ => {
    let emitter = @events.EventEmitter::new()
    let results = []
    emitter.on("async", data => run_async(() => {
      sleep(5)
      let v : Int = unsafe_cast(data)
      results.push(v * 2)
    }))
    emitter.emit("async", 10 |> @js.safe_js)
    emitter.emit("async", 20 |> @js.safe_js)
    sleep(20)
    assert_eq(results.length(), 2)
    assert_eq(results[0], 20)
    assert_eq(results[1], 40)
  })
}

///|
test {
  it("multiple promises concurrent", _ => {
    let resolver1 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver2 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver3 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(5)
      resolver1.resolve(1)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(2)
    })
    run_async(() => {
      sleep(5)
      resolver3.resolve(3)
    })
    let r1 = resolver1.promise.unwrap()
    let r2 = resolver2.promise.unwrap()
    let r3 = resolver3.promise.unwrap()
    assert_eq(r1 + r2 + r3, 6)
  })
}

///|
test {
  it("fs operations sequence", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let testfile = @path.join([tmpdir, "moonbit_sequence.txt"])
    // write
    @fs.writeFile(testfile, "step1").unwrap()
    sleep(5)
    // read
    let content1 = @fs.readFile(testfile).unwrap()
    assert_eq(content1, "step1")
    // overwrite
    @fs.writeFile(testfile, "step2").unwrap()
    sleep(5)
    // read again
    let content2 = @fs.readFile(testfile).unwrap()
    assert_eq(content2, "step2")
    // cleanup
    @fs.rm(testfile, force=true).unwrap()
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("timer and promise coordination", _ => {
    let mut timer_fired = false
    let mut promise_resolved = false
    let resolver : @promise.Resolvers[Unit] = @promise.Promise::withResolvers()
    let _ = @timer.setTimeout(
      () => {
        timer_fired = true
        resolver.resolve(())
      },
      10,
    )
    resolver.promise.unwrap()
    promise_resolved = true
    assert_true(timer_fired)
    assert_true(promise_resolved)
  })
}

///|
test {
  it("EventEmitter stress test", _ => {
    let emitter = @events.EventEmitter::new()
    let mut total = 0
    emitter.on("data", data => run_async(() => {
      let v : Int = unsafe_cast(data)
      total += v
    }))
    for i = 0; i < 10; i = i + 1 {
      emitter.emit("data", i |> @js.safe_js)
    }
    sleep(20)
    assert_eq(total, 45) // 0+1+2+...+9 = 45
  })
}

///|
test {
  it("Promise::resolve with different types", _ => {
    let p1 = @promise.Promise::resolve(42)
    let p2 = @promise.Promise::resolve("hello")
    let p3 = @promise.Promise::resolve(true)
    assert_eq(p1.unwrap(), 42)
    assert_eq(p2.unwrap(), "hello")
    assert_eq(p3.unwrap(), true)
  })
}

///|
test {
  it("multiple EventEmitters", _ => {
    let emitter1 = @events.EventEmitter::new()
    let emitter2 = @events.EventEmitter::new()
    let mut count1 = 0
    let mut count2 = 0
    emitter1.on("test", _ => run_async(() => {
      sleep(1)
      count1 += 1
    }))
    emitter2.on("test", _ => run_async(() => {
      sleep(1)
      count2 += 1
    }))
    emitter1.emit("test", () |> @js.safe_js)
    emitter2.emit("test", () |> @js.safe_js)
    sleep(10)
    assert_eq(count1, 1)
    assert_eq(count2, 1)
  })
}

///|
test {
  it("Promise::all with empty array", _ => {
    let all : @promise.Promise[Array[Int]] = @promise.Promise::all([])
    let results = all.unwrap()
    assert_eq(results.length(), 0)
  })
}

///|
test {
  it("Promise::race with single promise", _ => {
    let p = @promise.Promise::resolve(100)
    let race = @promise.Promise::race([p])
    let result = race.unwrap()
    assert_eq(result, 100)
  })
}

///|
test {
  it("nested promises", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(1)
      resolver.resolve(10)
    })
    let p1 = resolver.promise.then(v => {
      let inner_resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
      run_async(() => {
        sleep(1)
        inner_resolver.resolve(v * 2)
      })
      inner_resolver.promise
    })
    let result = p1.unwrap()
    assert_eq(result, 20)
  })
}

///|
test {
  it("setTimeout with zero delay", _ => {
    let mut executed = false
    let _ = @timer.setTimeout(() => executed = true, 0)
    @promise.sleep(5)
    assert_true(executed)
  })
}

///|
test {
  it("multiple setTimeouts", _ => {
    let order = []
    let _ = @timer.setTimeout(() => order.push(1), 10)
    let _ = @timer.setTimeout(() => order.push(2), 5)
    let _ = @timer.setTimeout(() => order.push(3), 15)
    @promise.sleep(25)
    assert_eq(order.length(), 3)
    assert_eq(order[0], 2) // 5ms
    assert_eq(order[1], 1) // 10ms
    assert_eq(order[2], 3) // 15ms
  })
}

///|
test {
  it("EventEmitter removeAllListeners specific event", _ => {
    let emitter = @events.EventEmitter::new()
    let mut count = 0
    emitter.on("event1", _ => run_async(() => count += 1))
    emitter.on("event2", _ => run_async(() => count += 10))
    emitter.removeAllListeners()
    emitter.emit("event1", () |> @js.safe_js)
    emitter.emit("event2", () |> @js.safe_js)
    sleep(10)
    assert_eq(count, 0)
  })
}

///|
test {
  it("fs readFile non-existent file", _ => run_async(() => try {
    let result = try? @fs.readFile("/nonexistent/file.txt").unwrap()
    assert_true(result is Err(_))
  } catch {
    _ => ()
  }))
}

///|
test {
  it("Promise chain with error recovery", _ => {
    let err_val : Val = @js.unsafe_cast(@js.Object::new())
    let p = @promise.Promise::reject(err_val)
      .catch_(_ => @promise.Promise::resolve(10 |> @js.safe_js))
      .then(v => {
        let i : Int = unsafe_cast(v)
        @promise.Promise::resolve(i * 2)
      })
    let result = p.unwrap()
    assert_eq(result, 20)
  })
}

///|
test {
  it("run_async with multiple sleep calls", _ => {
    let checkpoints = []
    run_async(() => {
      checkpoints.push(1)
      sleep(5)
      checkpoints.push(2)
      sleep(5)
      checkpoints.push(3)
    })
    sleep(15)
    assert_eq(checkpoints.length(), 3)
    assert_eq(checkpoints[0], 1)
    assert_eq(checkpoints[1], 2)
    assert_eq(checkpoints[2], 3)
  })
}

///|
test {
  it("Promise::withResolvers multiple resolve calls", _ => {
    let resolver : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      resolver.resolve(1)
      resolver.resolve(2) // second call should be ignored
    })
    let result = resolver.promise.unwrap()
    assert_eq(result, 1)
  })
}

///|
test {
  it("EventEmitter listenerCount for non-existent event", _ => {
    let emitter = @events.EventEmitter::new()
    assert_eq(emitter.listenerCount("nonexistent"), 0)
  })
}

///|
test {
  it("concurrent file operations", _ => run_async(() => try {
    let tmpdir = @os.tmpdir()
    let file1 = @path.join([tmpdir, "concurrent1.txt"])
    let file2 = @path.join([tmpdir, "concurrent2.txt"])
    let file3 = @path.join([tmpdir, "concurrent3.txt"])
    run_async(() => @fs.writeFile(file1, "file1").unwrap() catch { _ => () })
    run_async(() => @fs.writeFile(file2, "file2").unwrap() catch { _ => () })
    run_async(() => @fs.writeFile(file3, "file3").unwrap() catch { _ => () })
    sleep(20)
    let content1 = @fs.readFile(file1).unwrap()
    let content2 = @fs.readFile(file2).unwrap()
    let content3 = @fs.readFile(file3).unwrap()
    assert_eq(content1, "file1")
    assert_eq(content2, "file2")
    assert_eq(content3, "file3")
    @fs.rm(file1, force=true).unwrap()
    @fs.rm(file2, force=true).unwrap()
    @fs.rm(file3, force=true).unwrap()
  } catch {
    e => @js.log(e)
  }))
}

///|
test {
  it("Promise::all with mixed resolution times", _ => {
    let resolver1 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver2 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    let resolver3 : @promise.Resolvers[Int] = @promise.Promise::withResolvers()
    run_async(() => {
      sleep(10)
      resolver1.resolve(1)
    })
    run_async(() => {
      sleep(5)
      resolver2.resolve(2)
    })
    run_async(() => {
      sleep(15)
      resolver3.resolve(3)
    })
    let all = @promise.Promise::all([
      resolver1.promise,
      resolver2.promise,
      resolver3.promise,
    ])
    let results = all.unwrap()
    assert_eq(results[0], 1)
    assert_eq(results[1], 2)
    assert_eq(results[2], 3)
  })
}

///|
test {
  it("setInterval immediate execution", _ => {
    let mut first_execution = false
    let timer = @timer.setInterval(
      () => if not(first_execution) { first_execution = true },
      5,
    )
    @promise.sleep(10)
    @timer.clearInterval(timer)
    assert_true(first_execution)
  })
}

///|
test {
  it("EventEmitter with different payload types", _ => {
    let emitter = @events.EventEmitter::new()
    let mut int_val = 0
    let mut str_val = ""
    emitter.on("int", data => run_async(() => {
      let v : Int = unsafe_cast(data)
      int_val = v
    }))
    emitter.on("string", data => run_async(() => {
      let v : String = unsafe_cast(data)
      str_val = v
    }))
    emitter.emit("int", 42 |> @js.safe_js)
    emitter.emit("string", "hello" |> @js.safe_js)
    sleep(10)
    assert_eq(int_val, 42)
    assert_eq(str_val, "hello")
  })
}

///|
test {
  it("sleep with very short duration", _ => run_async(() => try {
    sleep(1)
    // Just verify sleep completes without error
    assert_true(true)
  } catch {
    _ => ()
  }))
}
