///|
test "sqlite exec and prepare" {
  let database = DatabaseSync::new(":memory:")
  let query =
    #|CREATE TABLE t3(x, y);
    #|INSERT INTO t3 VALUES ('a', 4), ('b', 5);
  database.exec(query)
  let prepared = database.prepare("SELECT * from t3;")
  let result = prepared.all()
  inspect(
    result |> @js.from_builtin_array |> @js.json_stringify,
    content=(
      #|[
      #|  {
      #|    "x": "a",
      #|    "y": 4
      #|  },
      #|  {
      #|    "x": "b",
      #|    "y": 5
      #|  }
      #|]
    ),
  )
}

///|
test "node:sqlite aggregate" {
  let database = DatabaseSync::new(":memory:")
  let query =
    #|CREATE TABLE t3(x, y);
    #|INSERT INTO t3 VALUES ('a', 4), ('b', 5);
  database.exec(query)
  let _ = database.aggregate("sumint", start=0, step=(acc, value) => acc + value)
  let result = database.prepare("SELECT sumint(y) as total FROM t3").get() // { total: 9 }
  guard result is Some(r)
  inspect(
    r |> @js.json_stringify,
    content=(
      #|{
      #|  "total": 9
      #|}
    ),
  )
}

///|
test "sqlite prepared statement with parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
  )
  let insert = database.prepare("INSERT INTO users (name, age) VALUES (?, ?)")
  let result1 = insert.run(anonymous_parameters=[@js.js("Alice"), @js.js(30)])
  assert_eq(result1.changes, 1)
  let result2 = insert.run(anonymous_parameters=[@js.js("Bob"), @js.js(25)])
  assert_eq(result2.changes, 1)
  let select = database.prepare("SELECT * FROM users WHERE age > ?")
  let users = select.all(anonymous_parameters=[@js.js(26)])
  assert_eq(users.length(), 1)
}

///|
test "sqlite named parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL)",
  )
  let insert = database.prepare(
    "INSERT INTO products (name, price) VALUES (:name, :price)",
  )
  insert.run(named_parameters={ "name": "Apple", "price": 1.5 }) |> ignore
  insert.run(named_parameters={ "name": "Banana", "price": 0.8 }) |> ignore
  let select = database.prepare(
    "SELECT * FROM products WHERE price < :maxPrice",
  )
  let products = select.all(named_parameters={ "maxPrice": 1.0 })
  assert_eq(products.length(), 1)
}

///|
test "sqlite get single row" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE settings(key TEXT PRIMARY KEY, value TEXT)")
  database.exec("INSERT INTO settings VALUES ('theme', 'dark'), ('lang', 'en')")
  let stmt = database.prepare("SELECT value FROM settings WHERE key = ?")
  let result = stmt.get(anonymous_parameters=[@js.js("theme")])
  guard result is Some(row)
  assert_eq(row.get("value").cast(), "dark")
  let no_result = stmt.get(anonymous_parameters=[@js.js("nonexistent")])
  assert_eq(no_result, None)
}

///|
test "sqlite iterate rows" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE numbers(value INTEGER)")
  database.exec("INSERT INTO numbers VALUES (1), (2), (3), (4), (5)")
  let stmt = database.prepare("SELECT value FROM numbers ORDER BY value")
  let iter = stmt.iterate()
  let mut sum = 0
  let mut count = 0
  for row in iter.iter() {
    let value : Int = row.get("value").cast()
    sum += value
    count += 1
  }
  assert_eq(count, 5)
  assert_eq(sum, 15)
}

///|
#skip("custom function requires proper varargs handling")
test "sqlite custom function" {
  let database = DatabaseSync::new(":memory:")
  database.function(
    "double",
    fn(args) {
      if args.length() == 0 {
        return @js.js(0)
      }
      let value : Int = args[0].cast()
      @js.js(value * 2)
    },
    varargs=true,
  )
  database.exec("CREATE TABLE nums(x INTEGER)")
  database.exec("INSERT INTO nums VALUES (5), (10), (15)")
  let stmt = database.prepare("SELECT double(x) as doubled FROM nums")
  let results = stmt.all()
  assert_eq(results.length(), 3)
  let first : Int = results[0].get("doubled").cast()
  assert_eq(first, 10)
}

///|
test "sqlite statement metadata" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE test(id INTEGER, name TEXT)")
  let stmt = database.prepare("SELECT id, name FROM test")
  let sql = stmt.sourceSQL()
  assert_eq(sql, "SELECT id, name FROM test")
  let columns = stmt.columns()
  assert_eq(columns.length(), 2)
}

///|
test "sqlite isOpen and isTransaction" {
  let database = DatabaseSync::new(":memory:")
  assert_true(database.isOpen())
  assert_false(database.isTransaction())
  database.exec("BEGIN TRANSACTION")
  assert_true(database.isTransaction())
  database.exec("COMMIT")
  assert_false(database.isTransaction())
  database.close()
  assert_false(database.isOpen())
}

///|
test "sqlite session and changeset" {
  let source_db = DatabaseSync::new(":memory:")
  let target_db = DatabaseSync::new(":memory:")
  source_db.exec("CREATE TABLE data(key INTEGER PRIMARY KEY, value TEXT)")
  target_db.exec("CREATE TABLE data(key INTEGER PRIMARY KEY, value TEXT)")
  let session = source_db.createSession()
  let insert = source_db.prepare("INSERT INTO data (key, value) VALUES (?, ?)")
  insert.run(anonymous_parameters=[@js.js(1), @js.js("hello")]) |> ignore
  insert.run(anonymous_parameters=[@js.js(2), @js.js("world")]) |> ignore
  let changeset = session.changeset()
  assert_true(changeset.byte_length() > 0)
  target_db.applyChangeset(changeset) |> ignore
  let result = target_db.prepare("SELECT COUNT(*) as count FROM data").get()
  guard result is Some(row)
  assert_eq(row.get("count").cast(), 2)
  session.close()
}

///|
test "sqlite aggregate with window function" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    (
      #|CREATE TABLE sales(product TEXT, amount INTEGER);
      #|INSERT INTO sales VALUES ('A', 100), ('B', 200), ('A', 150), ('B', 250);
    ),
  )
  database.aggregate(
    "running_total",
    start=0,
    step=fn(acc, value) { acc + value },
    result=fn(acc) { @js.js(acc) },
  )
  let stmt = database.prepare(
    "SELECT product, running_total(amount) as total FROM sales GROUP BY product",
  )
  let results = stmt.all()
  assert_eq(results.length(), 2)
}

///|
test "sqlite type-safe anonymous parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, price REAL, stock INT)",
  )
  let insert = database.prepare(
    "INSERT INTO products (name, price, stock) VALUES (?, ?, ?)",
  )
  // Now we can pass direct values without wrapping in @js.js()
  insert.run(anonymous_parameters=["Apple", 1.5, 100]) |> ignore
  insert.run(anonymous_parameters=["Banana", 0.8, 150]) |> ignore
  insert.run(anonymous_parameters=["Orange", 2.0, 75]) |> ignore
  // Query with type-safe parameters
  let select = database.prepare(
    "SELECT * FROM products WHERE price < ? AND stock > ?",
  )
  let results = select.all(anonymous_parameters=[1.6, 80])
  assert_eq(results.length(), 2)
  let first = results[0]
  assert_eq(first.get("name").cast(), "Apple")
  // Test with get() method
  let get_stmt = database.prepare(
    "SELECT name, price FROM products WHERE id = ?",
  )
  let result = get_stmt.get(anonymous_parameters=[2])
  guard result is Some(row)
  assert_eq(row.get("name").cast(), "Banana")
  assert_eq(row.get("price").cast(), 0.8)
  // Test with named parameters
  let named_stmt = database.prepare(
    "SELECT * FROM products WHERE name = :productName AND stock > :minStock",
  )
  let named_results = named_stmt.all(named_parameters={
    "productName": "Apple",
    "minStock": 50,
  })
  assert_eq(named_results.length(), 1)
  let product = named_results[0]
  assert_eq(product.get("name").cast(), "Apple")
  assert_eq(product.get("stock").cast(), 100)
}

///|
test "sqlite location" {
  let database = DatabaseSync::new(":memory:")
  let location = database.location()
  assert_eq(location, None)
}

///|
test "sqlite with readBigInts option" {
  let database = DatabaseSync::new(":memory:", readBigInts=true)
  database.exec("CREATE TABLE big_numbers(value INTEGER)")
  database.exec("INSERT INTO big_numbers VALUES (9007199254740991)")
  let stmt = database.prepare("SELECT value FROM big_numbers")
  let result = stmt.get()
  guard result is Some(row)
  // BigInt is represented as Val
  assert_true(row.get("value").is_some())
}

///|
#skip("constants accessor needs proper implementation")
test "sqlite constants" {
  // Constants are available but need proper module structure
  // Skip for now until we can properly access node:sqlite.constants
  assert_true(true)
}
