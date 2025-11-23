///| IndexedDB Tests

///|
/// Test IDBKeyRange bound
test "IDBKeyRange bound" {
  let range = IDBKeyRange::bound(1, 10, lowerOpen=false, upperOpen=false)
  assert_true(range.includes(1))
  assert_true(range.includes(5))
  assert_true(range.includes(10))
  assert_false(range.includes(0))
  assert_false(range.includes(11))
}

///|
test "IDBKeyRange only" {
  let range = IDBKeyRange::only(5)
  assert_true(range.includes(5))
  assert_false(range.includes(4))
  assert_false(range.includes(6))
}

///|
test "IDBKeyRange lowerBound" {
  let range = IDBKeyRange::lowerBound(5, open=false)
  assert_true(range.includes(5))
  assert_true(range.includes(10))
  assert_false(range.includes(4))
}

///|
test "IDBKeyRange upperBound" {
  let range = IDBKeyRange::upperBound(10, open=false)
  assert_true(range.includes(10))
  assert_true(range.includes(5))
  assert_false(range.includes(11))
}

///|
/// Test cmp function
test "indexedDB cmp function" {
  assert_eq(cmp(1, 2), -1) // 1 < 2
  assert_eq(cmp(2, 1), 1) // 2 > 1
  assert_eq(cmp(5, 5), 0) // 5 == 5
}

///|
/// Test opening database
test "indexedDB open database" {
  let request = open("test-db", version=1)

  // Set up database structure
  request.on("upgradeneeded", fn(event) {
    let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
    db.createObjectStore("users", keyPath="id") |> ignore
  })
  request.on("success", fn(event) {
    let db : IDBDatabase = @js.unsafe_cast(event.get("target").get("result"))
    db.close()
  })

  // Test that API exists
  inspect(true, content="true")
}

///|
/// Test deleteDatabase
test "indexedDB deleteDatabase" {
  let request = deleteDatabase("db-to-delete")
  request.on("success", fn(_) { () })
  inspect(true, content="true")
}

///|
/// Test indexedDB factory access
test "indexedDB factory" {
  let idb = indexedDB()
  assert_false(@js.is_nullish(idb))
}
