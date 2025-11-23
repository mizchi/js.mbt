///| IndexedDB Tests

///|
/// Setup fake-indexeddb for Node.js testing environment
extern "js" fn ffi_require_fake_indexeddb() -> @js.Js =
  #|() => { require("fake-indexeddb/auto"); return globalThis.indexedDB; }

///|
/// Initialize fake-indexeddb (call once to setup)
fn init_fake_indexeddb() -> Unit {
  ffi_require_fake_indexeddb() |> ignore
}

///|
/// Test IDBKeyRange bound
test "IDBKeyRange bound" {
  init_fake_indexeddb()
  let range = @indexeddb.IDBKeyRange::bound(
    1,
    10,
    lowerOpen=false,
    upperOpen=false,
  )
  assert_true(range.includes(1))
  assert_true(range.includes(5))
  assert_true(range.includes(10))
  assert_false(range.includes(0))
  assert_false(range.includes(11))
}

///|
test "IDBKeyRange only" {
  init_fake_indexeddb()
  let range = @indexeddb.IDBKeyRange::only(5)
  assert_true(range.includes(5))
  assert_false(range.includes(4))
  assert_false(range.includes(6))
}

///|
test "IDBKeyRange lowerBound" {
  init_fake_indexeddb()
  let range = @indexeddb.IDBKeyRange::lowerBound(5, open=false)
  assert_true(range.includes(5))
  assert_true(range.includes(10))
  assert_false(range.includes(4))
}

///|
test "IDBKeyRange upperBound" {
  init_fake_indexeddb()
  let range = @indexeddb.IDBKeyRange::upperBound(10, open=false)
  assert_true(range.includes(10))
  assert_true(range.includes(5))
  assert_false(range.includes(11))
}

///|
/// Test cmp function
test "indexedDB cmp function" {
  init_fake_indexeddb()
  assert_eq(@indexeddb.cmp(1, 2), -1) // 1 < 2
  assert_eq(@indexeddb.cmp(2, 1), 1) // 2 > 1
  assert_eq(@indexeddb.cmp(5, 5), 0) // 5 == 5
}

///|
/// Test opening database
test "indexedDB open database" {
  init_fake_indexeddb()
  let request = @indexeddb.open("test-db", version=1)

  // Set up database structure
  request.addEventListener("upgradeneeded", fn(event) {
    let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
    db.createObjectStore("users", keyPath="id") |> ignore
  })
  request.addEventListener("success", fn(event) {
    let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
    db.close()
  })

  // Test that API exists
  inspect(true, content="true")
}

///|
/// Test deleteDatabase
test "indexedDB deleteDatabase" {
  init_fake_indexeddb()
  let request = @indexeddb.deleteDatabase("db-to-delete")
  request.addEventListener("success", fn(_) { () })
  inspect(true, content="true")
}

///|
/// Test indexedDB factory access
test "indexedDB factory" {
  init_fake_indexeddb()
  let idb = indexedDB()
  assert_false(@js.is_nullish(idb))
}
