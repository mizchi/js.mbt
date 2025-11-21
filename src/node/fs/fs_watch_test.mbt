///|
/// Test fs.watch

///|
test "watch creates FSWatcher" {
  let watcher = @fs.watch(".", recursive=true)
  watcher.close()
}

///|
test "watch with listener" {
  let watcher = @fs.watch(".", persistent=false, listener=fn(event, filename) {
    println("Event: \{event}, File: \{filename}")
  })
  watcher.close()
}

///|
test "FSWatcher.on adds event listener" {
  let watcher = @fs.watch(".")
  watcher.on("change", fn(event, filename) { println("Changed: \{filename}") })
  |> ignore
  watcher.close()
}
