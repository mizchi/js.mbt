///| Browser IndexedDB async tests

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
// Note: @test {it, describe} and @js {Promise, run_async, sleep, suspend} are already imported in deps.mbt

///|
/// Helper to promisify IDBRequest
fn[T] request_to_promise(
  request : @indexeddb.IDBRequest[T],
) -> @js.Promise[@js.Js] {
  let resolvers = Promise::withResolvers()
  request.addEventListener("success", fn(event) {
    resolvers.resolve(event.get("target").get("result"))
  })
  request.addEventListener("error", fn(event) {
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
  request : @indexeddb.IDBOpenDBRequest,
  onupgradeneeded? : (@js.Js) -> Unit,
) -> @js.Promise[@js.Js] {
  let resolvers = Promise::withResolvers()

  // Handle upgrade if needed
  match onupgradeneeded {
    Some(handler) => request.addEventListener("upgradeneeded", handler)
    None => ()
  }
  request.addEventListener("success", fn(event) {
    resolvers.resolve(event.get("target").get("result"))
  })
  request.addEventListener("error", fn(event) {
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
  @test.describe("IndexedDB: Basic operations", _ => {
    @test.it("open and close database", _ => {
      init_fake_indexeddb()
      let request = @indexeddb.open("test-open-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("store1", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
      assert_eq(db.name, "test-open-db")
      assert_eq(db.version, 1)
      db.close()

      // Cleanup
      @indexeddb.deleteDatabase("test-open-db") |> ignore
    })
    @test.it("add and get item", _ => {
      let request = @indexeddb.open("test-add-get-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("items", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)

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
      @indexeddb.deleteDatabase("test-add-get-db") |> ignore
    })
    @test.it("put updates existing item", _ => {
      let request = @indexeddb.open("test-put-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("records", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
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
      @indexeddb.deleteDatabase("test-put-db") |> ignore
    })
    @test.it("delete removes item", _ => {
      let request = @indexeddb.open("test-delete-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("todos", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
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
      @indexeddb.deleteDatabase("test-delete-db") |> ignore
    })
    @test.it("clear removes all items", _ => {
      let request = @indexeddb.open("test-clear-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("data", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
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
      @indexeddb.deleteDatabase("test-clear-db") |> ignore
    })
    @test.it("getAll returns all items", _ => {
      let request = @indexeddb.open("test-getall-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("entries", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
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
      @indexeddb.deleteDatabase("test-getall-db") |> ignore
    })
    @test.it("count returns correct number", _ => {
      let request = @indexeddb.open("test-count-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("counters", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
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
      @indexeddb.deleteDatabase("test-count-db") |> ignore
    })
    @test.it("transaction modes work correctly", _ => {
      let request = @indexeddb.open("test-tx-mode-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("txtest", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)

      // Read-only transaction
      let readonly_tx = db.transaction(["txtest"], mode="readonly")
      assert_eq(readonly_tx.mode, "readonly")

      // Read-write transaction
      let readwrite_tx = db.transaction(["txtest"], mode="readwrite")
      assert_eq(readwrite_tx.mode, "readwrite")
      db.close()
      @indexeddb.deleteDatabase("test-tx-mode-db") |> ignore
    })
  })
}

///|
test {
  @test.describe("IndexedDB: Advanced queries", _ => {
    @test.it("IDBKeyRange operations", _ => {
      let request = @indexeddb.open("test-keyrange-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("numbers", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)
      let tx = db.transaction(["numbers"], mode="readwrite")
      let store = tx.objectStore("numbers")

      // Add numbers 1-10
      for i = 1; i <= 10; i = i + 1 {
        request_to_promise(store.add(@js.from_map({ "id": @js.js(i) }))).wait()
        |> ignore
      }

      // Test key range queries
      let range = @indexeddb.IDBKeyRange::bound(
        3,
        7,
        lowerOpen=false,
        upperOpen=false,
      )
      let results = request_to_promise(store.getAll(query=range)).wait()
      let len : Int = @js.unsafe_cast(results.get("length"))
      assert_eq(len, 5) // 3, 4, 5, 6, 7
      db.close()
      @indexeddb.deleteDatabase("test-keyrange-db") |> ignore
    })
    @test.it("cmp function compares keys", _ => {
      assert_eq(@indexeddb.cmp(1, 2), -1) // 1 < 2
      assert_eq(@indexeddb.cmp(2, 1), 1) // 2 > 1
      assert_eq(@indexeddb.cmp(5, 5), 0) // 5 == 5
      assert_eq(@indexeddb.cmp("a", "b"), -1) // "a" < "b"
    })
  })
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

///|
/// Type-safe scenario: Managing user profiles with User struct
test {
  @test.describe("IndexedDB: Type-safe operations", _ => {
    @test.it("store and retrieve User struct with full type safety", _ => {
      let request = @indexeddb.open("typed-user-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("users", keyPath="id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)

      // Create User struct
      let alice : User = {
        id: 1,
        name: "Alice",
        email: "alice@example.com",
        age: 30,
      }

      // Type-safe store: @indexeddb.IDBObjectStore[User] with unsafe_cast
      let tx = db.transaction(["users"], mode="readwrite")
      let store : @indexeddb.IDBObjectStore[User] = tx.objectStore("users")
        |> @js.unsafe_cast

      // Add User directly - internal casting handled by IndexedDB
      let add_request = store.add(alice)
      request_to_promise(add_request).wait() |> ignore

      // Get with type parameter User: @indexeddb.IDBRequest[User]
      let get_request : @indexeddb.IDBRequest[User] = store.get(1)
      let result = request_to_promise(get_request).wait()

      // result is User type - direct cast, no from_js() needed
      let retrieved_user : User = result |> @js.unsafe_cast

      // Type-safe assertions with struct fields
      assert_eq(retrieved_user.id, 1)
      assert_eq(retrieved_user.name, "Alice")
      assert_eq(retrieved_user.email, "alice@example.com")
      assert_eq(retrieved_user.age, 30)
      db.close()
      @indexeddb.deleteDatabase("typed-user-db") |> ignore
    })
    @test.it("manage products with Product struct type safety", _ => {
      let request = @indexeddb.open("typed-product-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        let store = db.createObjectStore("products", keyPath="sku")
        store.createIndex("category", "category", unique=false) |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)

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
      let store : @indexeddb.IDBObjectStore[Product] = tx.objectStore(
          "products",
        )
        |> @js.unsafe_cast

      // Add Product directly - internal casting handled by IndexedDB
      request_to_promise(store.add(laptop)).wait() |> ignore
      request_to_promise(store.add(mouse)).wait() |> ignore

      // Get with IDBRequest[Product]
      let laptop_request : @indexeddb.IDBRequest[Product] = store.get(
        "LAPTOP-001",
      )
      let laptop_result = request_to_promise(laptop_request).wait()
      let retrieved_laptop : Product = laptop_result |> @js.unsafe_cast

      // Type-safe field access
      assert_eq(retrieved_laptop.sku, "LAPTOP-001")
      assert_eq(retrieved_laptop.name, "Gaming Laptop")
      assert_eq(retrieved_laptop.price, 1299.99)
      assert_eq(retrieved_laptop.stock, 15)

      // Query all electronics using index
      let category_index : @indexeddb.IDBIndex[Product] = store.index(
        "category",
      )
      let electronics_request = category_index.getAll(query="electronics")
      let electronics_array = request_to_promise(electronics_request).wait()

      // Array operations with Js
      let length : Int = @js.unsafe_cast(electronics_array.get("length"))
      assert_eq(length, 2)

      // Access first product with direct cast
      let first_product_js : @js.Js = electronics_array.call1("at", 0)
      let first_product : Product = first_product_js |> @js.unsafe_cast
      assert_eq(first_product.category, "electronics")
      db.close()
      @indexeddb.deleteDatabase("typed-product-db") |> ignore
    })
    @test.it("iterate orders with IDBCursorWithValue and Order struct", _ => {
      let request = @indexeddb.open("typed-orders-db", version=1)
      let db_promise = open_request_to_promise(request, onupgradeneeded=fn(
        event,
      ) {
        let db : @indexeddb.IDBDatabase = @js.unsafe_cast(
          event.get("target").get("result"),
        )
        db.createObjectStore("orders", keyPath="order_id") |> ignore
      })
      let db_js = db_promise.wait()
      let db : @indexeddb.IDBDatabase = @js.unsafe_cast(db_js)

      // Create and store Order structs
      let tx = db.transaction(["orders"], mode="readwrite")
      let store : @indexeddb.IDBObjectStore[Order] = tx.objectStore("orders")
        |> @js.unsafe_cast
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
      if not(@js.is_nullish(cursor_result)) {
        let cursor : @indexeddb.IDBCursorWithValue[Order] = cursor_result
          |> @js.unsafe_cast

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
    })
  })
}
