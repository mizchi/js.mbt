///|
/// Test AsyncLocalStorage::new creates an instance
test "AsyncLocalStorage::new creates an instance" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  inspect(@js.typeof_(als.as_any().cast()), content="object")
}

///|
/// Test AsyncLocalStorage::run sets and gets store
test "AsyncLocalStorage::run sets store" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  let store = 42
  let mut retrieved_value : Int = 0
  als.run(store, fn() {
    let retrieved = als.getStore()
    match retrieved {
      Some(value) => retrieved_value = value
      None => ()
    }
  })
  assert_eq(retrieved_value, 42)
}

///|
/// Test AsyncLocalStorage::getStore returns None outside context
test "AsyncLocalStorage::getStore returns None outside context" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  let store = als.getStore()
  assert_eq(store, None)
}

///|
/// Test AsyncLocalStorage::exit clears store
test "AsyncLocalStorage::exit clears store" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  let store = 42
  let mut is_none = false
  als.run(store, fn() {
    als.exit(fn() {
      let retrieved = als.getStore()
      match retrieved {
        None => is_none = true
        Some(_) => is_none = false
      }
    })
  })
  assert_eq(is_none, true)
}

///|
/// Test AsyncLocalStorage::enterWith sets store
test "AsyncLocalStorage::enterWith sets store" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  let store = 100
  als.enterWith(store)
  let retrieved = als.getStore()
  match retrieved {
    Some(value) => assert_eq(value, 100)
    None => assert_eq(true, false) // Should not reach here
  }
}

///|
/// Test AsyncLocalStorage::disable can be called
test "AsyncLocalStorage::disable can be called" {
  let als : AsyncLocalStorage[Int] = AsyncLocalStorage::new()
  let store = 42
  als.enterWith(store)
  als.disable()
  inspect(@js.typeof_(als.as_any().cast()), content="object")
}

///|
/// Test AsyncLocalStorage with String type
test "AsyncLocalStorage with String type" {
  let als : AsyncLocalStorage[String] = AsyncLocalStorage::new()
  let store = "Hello"
  let mut retrieved_value = ""
  als.run(store, fn() {
    let retrieved = als.getStore()
    match retrieved {
      Some(value) => retrieved_value = value
      None => ()
    }
  })
  assert_eq(retrieved_value, "Hello")
}
