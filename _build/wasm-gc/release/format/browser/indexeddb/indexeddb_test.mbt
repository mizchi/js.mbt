///| Browser IndexedDB async tests

///|
/// Setup fake-indexeddb for Node.js testing environment
extern "js" fn ffi_require_fake_indexeddb() -> @core.Any =
  #|() => { require("fake-indexeddb/auto"); return globalThis.indexedDB; }

///|
/// Initialize fake-indexeddb (call once to setup)
fn init_fake_indexeddb() -> Unit {
  ffi_require_fake_indexeddb() |> ignore
}

///|
// Note: @test {it, describe} and @js {Promise, run_async, sleep, suspend} are already imported in deps.mbt

///|
/// Helper to promisify IDBRequest
fn[T] request_to_promise(
  request : @indexeddb.IDBRequest[T],
) -> @js.Promise[@core.Any] {
  let resolvers = @js.Promise::withResolvers()
  request
  .as_event_target()
  .addEventListener("success", fn(event) {
    resolvers.resolve(event._get("target")._get("result"))
  })
  request
  .as_event_target()
  .addEventListener("error", fn(event) {
    let error_msg = @core.identity(
      event._get("target")._get("error")._call("toString", []),
    )
    resolvers.reject(Failure::Failure(error_msg))
  })
  resolvers.promise
}

///|
/// Helper to promisify IDBOpenDBRequest
fn open_request_to_promise(
  request : @indexeddb.IDBOpenDBRequest,
  onupgradeneeded? : (@core.Any) -> Unit,
) -> @js.Promise[@core.Any] {
  let resolvers = @js.Promise::withResolvers()

  // Handle upgrade if needed
  match onupgradeneeded {
    Some(handler) =>
      request.as_event_target().addEventListener("upgradeneeded", handler)
    None => ()
  }
  request
  .as_event_target()
  .addEventListener("success", fn(event) {
    resolvers.resolve(event._get("target")._get("result"))
  })
  request
  .as_event_target()
  .addEventListener("error", fn(event) {
    let error_msg = @core.identity(
      event._get("target")._get("error")._call("toString", []),
    )
    resolvers.reject(Failure::Failure(error_msg))
  })
  resolvers.promise
}

///| Basic IndexedDB operations

///|
async test "IndexedDB: open and close database" {
  init_fake_indexeddb()
  let request = @indexeddb.open("test-open-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("store1", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  assert_eq(db.name, "test-open-db")
  assert_eq(db.version, 1)
  db.close()

  // Cleanup
  @indexeddb.deleteDatabase("test-open-db") |> ignore
}

///|
async test "IndexedDB: add and get item" {
  let request = @indexeddb.open("test-add-get-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("items", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)

  // Add an item
  let tx = db.transaction(["items"], mode="readwrite")
  let store = tx.objectStore("items")
  let item : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("name", @core.any("Test")),
  ]).cast()
  let add_request = store.add(item)
  let _ = request_to_promise(add_request).wait()

  // Get the item
  let get_request = store.get(@core.any(1))
  let result = request_to_promise(get_request).wait()
  assert_eq(@core.identity(result._get("name")), "Test")
  db.close()
  @indexeddb.deleteDatabase("test-add-get-db") |> ignore
}

///|
async test "IndexedDB: put updates existing item" {
  let request = @indexeddb.open("test-put-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("records", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["records"], mode="readwrite")
  let store = tx.objectStore("records")

  // Add initial item
  let item1 : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("value", @core.any("initial")),
  ]).cast()
  request_to_promise(store.add(item1)).wait() |> ignore

  // Update with put
  let item2 : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("value", @core.any("updated")),
  ]).cast()
  request_to_promise(store.put(item2)).wait() |> ignore

  // Get and verify
  let result = request_to_promise(store.get(@core.any(1))).wait()
  assert_eq(@core.identity(result._get("value")), "updated")
  db.close()
  @indexeddb.deleteDatabase("test-put-db") |> ignore
}

///|
async test "IndexedDB: delete removes item" {
  let request = @indexeddb.open("test-delete-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("todos", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["todos"], mode="readwrite")
  let store = tx.objectStore("todos")

  // Add item
  let item : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("task", @core.any("Do it")),
  ]).cast()
  request_to_promise(store.add(item)).wait() |> ignore

  // Delete it
  request_to_promise(store.delete(@core.any(1))).wait() |> ignore

  // Verify deletion
  let result = request_to_promise(store.get(@core.any(1))).wait()
  assert_true(@core.is_undefined(result))
  db.close()
  @indexeddb.deleteDatabase("test-delete-db") |> ignore
}

///|
async test "IndexedDB: clear removes all items" {
  let request = @indexeddb.open("test-clear-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("data", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["data"], mode="readwrite")
  let store = tx.objectStore("data")

  // Add multiple items
  let item1 : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("v", @core.any("a")),
  ]).cast()
  request_to_promise(store.add(item1)).wait() |> ignore
  let item2 : @core.Any = @core.from_entries([
    ("id", @core.any(2)),
    ("v", @core.any("b")),
  ]).cast()
  request_to_promise(store.add(item2)).wait() |> ignore

  // Clear all
  request_to_promise(store.clear()).wait() |> ignore

  // Verify empty
  let count_result = request_to_promise(store.count()).wait()
  assert_eq(@core.identity(count_result), 0)
  db.close()
  @indexeddb.deleteDatabase("test-clear-db") |> ignore
}

///|
async test "IndexedDB: getAll returns all items" {
  let request = @indexeddb.open("test-getall-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("entries", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["entries"], mode="readwrite")
  let store = tx.objectStore("entries")

  // Add items
  let alice : @core.Any = @core.from_entries([
    ("id", @core.any(1)),
    ("name", @core.any("Alice")),
  ]).cast()
  request_to_promise(store.add(alice)).wait() |> ignore
  let bob : @core.Any = @core.from_entries([
    ("id", @core.any(2)),
    ("name", @core.any("Bob")),
  ]).cast()
  request_to_promise(store.add(bob)).wait() |> ignore
  let charlie : @core.Any = @core.from_entries([
    ("id", @core.any(3)),
    ("name", @core.any("Charlie")),
  ]).cast()
  request_to_promise(store.add(charlie)).wait() |> ignore

  // Get all
  let results = request_to_promise(store.getAll()).wait()
  let len : Int = @core.identity(results._get("length"))
  assert_eq(len, 3)
  db.close()
  @indexeddb.deleteDatabase("test-getall-db") |> ignore
}

///|
async test "IndexedDB: count returns correct number" {
  let request = @indexeddb.open("test-count-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("counters", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["counters"], mode="readwrite")
  let store = tx.objectStore("counters")

  // Add items
  let i1 : @core.Any = @core.from_entries([("id", @core.any(1))]).cast()
  request_to_promise(store.add(i1)).wait() |> ignore
  let i2 : @core.Any = @core.from_entries([("id", @core.any(2))]).cast()
  request_to_promise(store.add(i2)).wait() |> ignore
  let i3 : @core.Any = @core.from_entries([("id", @core.any(3))]).cast()
  request_to_promise(store.add(i3)).wait() |> ignore

  // Count
  let count_result = request_to_promise(store.count()).wait()
  assert_eq(@core.identity(count_result), 3)
  db.close()
  @indexeddb.deleteDatabase("test-count-db") |> ignore
}

///|
async test "IndexedDB: transaction modes work correctly" {
  let request = @indexeddb.open("test-tx-mode-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("txtest", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)

  // Read-only transaction
  let readonly_tx = db.transaction(["txtest"], mode="readonly")
  assert_eq(readonly_tx.mode, "readonly")

  // Read-write transaction
  let readwrite_tx = db.transaction(["txtest"], mode="readwrite")
  assert_eq(readwrite_tx.mode, "readwrite")
  db.close()
  @indexeddb.deleteDatabase("test-tx-mode-db") |> ignore
}

///| Advanced queries

///|
async test "IndexedDB: IDBKeyRange operations" {
  let request = @indexeddb.open("test-keyrange-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("numbers", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)
  let tx = db.transaction(["numbers"], mode="readwrite")
  let store = tx.objectStore("numbers")

  // Add numbers 1-10
  for i = 1; i <= 10; i = i + 1 {
    let item : @core.Any = @core.from_entries([("id", @core.any(i))]).cast()
    request_to_promise(store.add(item)).wait() |> ignore
  }

  // Test key range queries
  let range = @indexeddb.IDBKeyRange::bound(
    @core.any(3),
    @core.any(7),
    lowerOpen=false,
    upperOpen=false,
  )
  let results = request_to_promise(store.getAll(query=range.as_any())).wait()
  let len : Int = @core.identity(results._get("length"))
  assert_eq(len, 5) // 3, 4, 5, 6, 7
  db.close()
  @indexeddb.deleteDatabase("test-keyrange-db") |> ignore
}

///|
async test "IndexedDB: cmp function compares keys" {
  assert_eq(@indexeddb.cmp(@core.any(1), @core.any(2)), -1) // 1 < 2
  assert_eq(@indexeddb.cmp(@core.any(2), @core.any(1)), 1) // 2 > 1
  assert_eq(@indexeddb.cmp(@core.any(5), @core.any(5)), 0) // 5 == 5
  assert_eq(@indexeddb.cmp(@core.any("a"), @core.any("b")), -1) // "a" < "b"
}

///| Real-world user scenarios with MoonBit structs

///|
/// Define MoonBit struct types for type-safe IndexedDB operations
struct User {
  id : Int
  name : String
  email : String
  age : Int
}

///|
/// Product struct for e-commerce
struct Product {
  sku : String
  name : String
  category : String
  price : Double
  stock : Int
}

///|
/// Order struct
struct Order {
  order_id : Int
  customer : String
  total : Double
  status : String
}

///| Type-safe scenario: Managing user profiles with User struct

///|
async test "IndexedDB: store and retrieve User struct with full type safety" {
  let request = @indexeddb.open("typed-user-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("users", keyPath="id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)

  // Create User struct
  let alice : User = {
    id: 1,
    name: "Alice",
    email: "alice@example.com",
    age: 30,
  }

  // Type-safe store: @indexeddb.IDBObjectStore[User] with identity
  let tx = db.transaction(["users"], mode="readwrite")
  let store : @indexeddb.IDBObjectStore[User] = tx.objectStore("users")
    |> @core.identity

  // Add User directly - internal casting handled by IndexedDB
  let add_request = store.add(alice)
  request_to_promise(add_request).wait() |> ignore

  // Get with type parameter User: @indexeddb.IDBRequest[User]
  let get_request : @indexeddb.IDBRequest[User] = store.get(@core.any(1))
  let result = request_to_promise(get_request).wait()

  // result is User type - direct cast, no from_js() needed
  let retrieved_user : User = result |> @core.identity

  // Type-safe assertions with struct fields
  assert_eq(retrieved_user.id, 1)
  assert_eq(retrieved_user.name, "Alice")
  assert_eq(retrieved_user.email, "alice@example.com")
  assert_eq(retrieved_user.age, 30)
  db.close()
  @indexeddb.deleteDatabase("typed-user-db") |> ignore
}

///|
async test "IndexedDB: manage products with Product struct type safety" {
  let request = @indexeddb.open("typed-product-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    let store = db.createObjectStore("products", keyPath="sku")
    store.createIndex("category", "category", unique=false) |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)

  // Create Product structs
  let laptop : Product = {
    sku: "LAPTOP-001",
    name: "Gaming Laptop",
    category: "electronics",
    price: 1299.99,
    stock: 15,
  }
  let mouse : Product = {
    sku: "MOUSE-002",
    name: "Wireless Mouse",
    category: "electronics",
    price: 29.99,
    stock: 50,
  }

  // Type-safe store: @indexeddb.IDBObjectStore[Product]
  let tx = db.transaction(["products"], mode="readwrite")
  let store : @indexeddb.IDBObjectStore[Product] = tx.objectStore("products")
    |> @core.identity

  // Add Product directly - internal casting handled by IndexedDB
  request_to_promise(store.add(laptop)).wait() |> ignore
  request_to_promise(store.add(mouse)).wait() |> ignore

  // Get with IDBRequest[Product]
  let laptop_request : @indexeddb.IDBRequest[Product] = store.get(
    @core.any("LAPTOP-001"),
  )
  let laptop_result = request_to_promise(laptop_request).wait()
  let retrieved_laptop : Product = laptop_result |> @core.identity

  // Type-safe field access
  assert_eq(retrieved_laptop.sku, "LAPTOP-001")
  assert_eq(retrieved_laptop.name, "Gaming Laptop")
  assert_eq(retrieved_laptop.price, 1299.99)
  assert_eq(retrieved_laptop.stock, 15)

  // Query all electronics using index
  let category_index : @indexeddb.IDBIndex[Product] = store.index("category")
  let electronics_request = category_index.getAll(
    query=@core.any("electronics"),
  )
  let electronics_array = request_to_promise(electronics_request).wait()

  // Array operations with Js
  let length : Int = @core.identity(electronics_array._get("length"))
  assert_eq(length, 2)

  // Access first product with direct cast
  let first_product_js : @core.Any = electronics_array._call("at", [
    "0" |> @core.any,
  ])
  let first_product : Product = first_product_js |> @core.identity
  assert_eq(first_product.category, "electronics")
  db.close()
  @indexeddb.deleteDatabase("typed-product-db") |> ignore
}

///|
async test "IndexedDB: iterate orders with IDBCursorWithValue and Order struct" {
  let request = @indexeddb.open("typed-orders-db", version=1)
  let db_promise = open_request_to_promise(request, onupgradeneeded=fn(event) {
    let db : @indexeddb.IDBDatabase = @core.identity(
      event._get("target")._get("result"),
    )
    db.createObjectStore("orders", keyPath="order_id") |> ignore
  })
  let db_js = db_promise.wait()
  let db : @indexeddb.IDBDatabase = @core.identity(db_js)

  // Create and store Order structs
  let tx = db.transaction(["orders"], mode="readwrite")
  let store : @indexeddb.IDBObjectStore[Order] = tx.objectStore("orders")
    |> @core.identity
  for i = 1; i <= 3; i = i + 1 {
    let order : Order = {
      order_id: i,
      customer: "Customer-\{i}",
      total: i.to_double() * 100.0,
      status: "pending",
    }
    request_to_promise(store.add(order)).wait() |> ignore
  }

  // Open cursor with typed value
  let cursor_request = store.openCursor()
  let cursor_result = request_to_promise(cursor_request).wait()

  // Type-safe cursor access
  if not(@core.is_nullish(cursor_result)) {
    let cursor : @indexeddb.IDBCursorWithValue[Order] = cursor_result
      |> @core.identity

    // cursor.value is Order - direct access, no conversion needed
    let order : Order = cursor.value

    // Type-safe field access
    assert_eq(order.order_id, 1)
    assert_eq(order.customer, "Customer-1")
    assert_eq(order.total, 100.0)
    assert_eq(order.status, "pending")
  }
  db.close()
  @indexeddb.deleteDatabase("typed-orders-db") |> ignore
}
