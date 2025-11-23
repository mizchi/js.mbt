///| Browser IndexedDB async tests

///|
using @indexeddb {
  open,
  deleteDatabase,
  cmp,
  type IDBDatabase,
  type IDBObjectStore,
  type IDBTransaction,
  type IDBRequest,
  type IDBOpenDBRequest,
  type IDBKeyRange,
}
// Note: @test {it} and @js {Promise, run_async, sleep, suspend} are already imported in deps.mbt

///|
/// Helper to promisify IDBRequest
fn request_to_promise(request : IDBRequest) -> Promise[@js.Js] {
  let resolvers = Promise::withResolvers()
  request.on("success", fn(event) {
    resolvers.resolve(event.get("target").get("result"))
  })
  request.on("error", fn(event) {
    let error_msg = @js.unsafe_cast(
      event.get("target").get("error").call0("toString"),
    )
    resolvers.reject(Failure(error_msg))
  })
  resolvers.promise
}

///|
/// Helper to promisify IDBOpenDBRequest
fn open_request_to_promise(
  request : IDBOpenDBRequest,
  onupgradeneeded? : (@js.Js) -> Unit,
) -> Promise[@js.Js] {
  let resolvers = Promise::withResolvers()

  // Handle upgrade if needed
  match onupgradeneeded {
    Some(handler) => request.on("upgradeneeded", handler)
    None => ()
  }
  request.on("success", fn(event) {
    resolvers.resolve(event.get("target").get("result"))
  })
  request.on("error", fn(event) {
    let error_msg = @js.unsafe_cast(
      event.get("target").get("error").call0("toString"),
    )
    resolvers.reject(Failure(error_msg))
  })
  resolvers.promise
}

///| Basic IndexedDB operations

///|
test {
  it("open and close database", _ => {
    let request = open("test-open-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("store1", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    assert_eq(db.name(), "test-open-db")
    assert_eq(db.version(), 1)
    db.close()

    // Cleanup
    deleteDatabase("test-open-db") |> ignore
  })
}

///|
test {
  it("add and get item", _ => {
    let request = open("test-add-get-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("items", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)

    // Add an item
    let tx = db.transaction(["items"], mode="readwrite")
    let store = tx.objectStore("items")
    let item = @js.from_map({ "id": @js.js(1), "name": @js.js("Test") })
    let add_request = store.add(item)
    let _ = request_to_promise(add_request).wait()

    // Get the item
    let get_request = store.get(1)
    let result = request_to_promise(get_request).wait()
    assert_eq(@js.unsafe_cast(result.get("name")), "Test")
    db.close()
    deleteDatabase("test-add-get-db") |> ignore
  })
}

///|
test {
  it("put updates existing item", _ => {
    let request = open("test-put-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("records", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["records"], mode="readwrite")
    let store = tx.objectStore("records")

    // Add initial item
    let item1 = @js.from_map({ "id": @js.js(1), "value": @js.js("initial") })
    request_to_promise(store.add(item1)).wait() |> ignore

    // Update with put
    let item2 = @js.from_map({ "id": @js.js(1), "value": @js.js("updated") })
    request_to_promise(store.put(item2)).wait() |> ignore

    // Get and verify
    let result = request_to_promise(store.get(1)).wait()
    assert_eq(@js.unsafe_cast(result.get("value")), "updated")
    db.close()
    deleteDatabase("test-put-db") |> ignore
  })
}

///|
test {
  it("delete removes item", _ => {
    let request = open("test-delete-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("todos", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["todos"], mode="readwrite")
    let store = tx.objectStore("todos")

    // Add item
    let item = @js.from_map({ "id": @js.js(1), "task": @js.js("Do it") })
    request_to_promise(store.add(item)).wait() |> ignore

    // Delete it
    request_to_promise(store.delete(1)).wait() |> ignore

    // Verify deletion
    let result = request_to_promise(store.get(1)).wait()
    assert_true(@js.is_undefined(result))
    db.close()
    deleteDatabase("test-delete-db") |> ignore
  })
}

///|
test {
  it("clear removes all items", _ => {
    let request = open("test-clear-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("data", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["data"], mode="readwrite")
    let store = tx.objectStore("data")

    // Add multiple items
    request_to_promise(
      store.add(@js.from_map({ "id": @js.js(1), "v": @js.js("a") })),
    ).wait()
    |> ignore
    request_to_promise(
      store.add(@js.from_map({ "id": @js.js(2), "v": @js.js("b") })),
    ).wait()
    |> ignore

    // Clear all
    request_to_promise(store.clear()).wait() |> ignore

    // Verify empty
    let count_result = request_to_promise(store.count()).wait()
    assert_eq(@js.unsafe_cast(count_result), 0)
    db.close()
    deleteDatabase("test-clear-db") |> ignore
  })
}

///|
test {
  it("getAll returns all items", _ => {
    let request = open("test-getall-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("entries", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["entries"], mode="readwrite")
    let store = tx.objectStore("entries")

    // Add items
    request_to_promise(
      store.add(@js.from_map({ "id": @js.js(1), "name": @js.js("Alice") })),
    ).wait()
    |> ignore
    request_to_promise(
      store.add(@js.from_map({ "id": @js.js(2), "name": @js.js("Bob") })),
    ).wait()
    |> ignore
    request_to_promise(
      store.add(@js.from_map({ "id": @js.js(3), "name": @js.js("Charlie") })),
    ).wait()
    |> ignore

    // Get all
    let results = request_to_promise(store.getAll()).wait()
    let len : Int = @js.unsafe_cast(results.get("length"))
    assert_eq(len, 3)
    db.close()
    deleteDatabase("test-getall-db") |> ignore
  })
}

///|
test {
  it("count returns correct number", _ => {
    let request = open("test-count-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("counters", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["counters"], mode="readwrite")
    let store = tx.objectStore("counters")

    // Add items
    request_to_promise(store.add(@js.from_map({ "id": @js.js(1) }))).wait()
    |> ignore
    request_to_promise(store.add(@js.from_map({ "id": @js.js(2) }))).wait()
    |> ignore
    request_to_promise(store.add(@js.from_map({ "id": @js.js(3) }))).wait()
    |> ignore

    // Count
    let count_result = request_to_promise(store.count()).wait()
    assert_eq(@js.unsafe_cast(count_result), 3)
    db.close()
    deleteDatabase("test-count-db") |> ignore
  })
}

///|
test {
  it("transaction modes work correctly", _ => {
    let request = open("test-tx-mode-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("txtest", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)

    // Read-only transaction
    let readonly_tx = db.transaction(["txtest"], mode="readonly")
    assert_eq(readonly_tx.mode(), "readonly")

    // Read-write transaction
    let readwrite_tx = db.transaction(["txtest"], mode="readwrite")
    assert_eq(readwrite_tx.mode(), "readwrite")
    db.close()
    deleteDatabase("test-tx-mode-db") |> ignore
  })
}

///|
test {
  it("IDBKeyRange operations", _ => {
    let request = open("test-keyrange-db", version=1)
    let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
      event,
    ) {
      let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
      db.createObjectStore("numbers", keyPath="id") |> ignore
    })
    let db_js = db_promise.wait()
    let db : IDBDatabase = @js.unsafe_cast(db_js)
    let tx = db.transaction(["numbers"], mode="readwrite")
    let store = tx.objectStore("numbers")

    // Add numbers 1-10
    for i = 1; i <= 10; i = i + 1 {
      request_to_promise(store.add(@js.from_map({ "id": @js.js(i) }))).wait()
      |> ignore
    }

    // Test key range queries
    let range = IDBKeyRange::bound(3, 7, lowerOpen=false, upperOpen=false)
    let results = request_to_promise(store.getAll(query=range)).wait()
    let len : Int = @js.unsafe_cast(results.get("length"))
    assert_eq(len, 5) // 3, 4, 5, 6, 7
    db.close()
    deleteDatabase("test-keyrange-db") |> ignore
  })
}

///|
test {
  it("cmp function compares keys", _ => {
    assert_eq(cmp(1, 2), -1) // 1 < 2
    assert_eq(cmp(2, 1), 1) // 2 > 1
    assert_eq(cmp(5, 5), 0) // 5 == 5
    assert_eq(cmp("a", "b"), -1) // "a" < "b"
  })
}
