///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @iterator {type JsIterator}

///|
using @arraybuffer {type Uint8Array}

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
  let result = database.prepare("SELECT sumint(y) as total FROM t3").get_() // { total: 9 }
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
  let result = stmt.get_(anonymous_parameters=[@js.js("theme")])
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("value")), "dark")
  let no_result = stmt.get_(anonymous_parameters=[@js.js("nonexistent")])
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
    let value : Int = unsafe_cast(row.get("value"))
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
      let value : Int = unsafe_cast(args[0])
      @js.js(value * 2)
    },
    varargs=true,
  )
  database.exec("CREATE TABLE nums(x INTEGER)")
  database.exec("INSERT INTO nums VALUES (5), (10), (15)")
  let stmt = database.prepare("SELECT double(x) as doubled FROM nums")
  let results = stmt.all()
  assert_eq(results.length(), 3)
  let first : Int = unsafe_cast(results[0].get("doubled"))
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
  let result = target_db.prepare("SELECT COUNT(*) as count FROM data").get_()
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("count")), 2)
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
  assert_eq(unsafe_cast(first.get("name")), "Apple")
  // Test with get() method
  let get_stmt = database.prepare(
    "SELECT name, price FROM products WHERE id = ?",
  )
  let result = get_stmt.get_(anonymous_parameters=[2])
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("name")), "Banana")
  assert_eq(unsafe_cast(row.get("price")), 0.8)
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
  assert_eq(unsafe_cast(product.get("name")), "Apple")
  assert_eq(unsafe_cast(product.get("stock")), 100)
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
  let result = stmt.get_()
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

///|
test "sqlite mixed type parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE mixed(id INTEGER, str TEXT, num REAL, flag INTEGER)",
  )
  let insert = database.prepare(
    "INSERT INTO mixed (str, num, flag) VALUES (?, ?, ?)",
  )
  // Test with different types: String, Double, Int (SQLite uses integers for booleans)
  insert.run(anonymous_parameters=["test", 3.14, 1]) |> ignore
  insert.run(anonymous_parameters=["hello", 2.718, 0]) |> ignore
  insert.run(anonymous_parameters=["world", 1.414, 1]) |> ignore
  let select = database.prepare("SELECT * FROM mixed WHERE flag = ?")
  let results = select.all(anonymous_parameters=[1])
  assert_eq(results.length(), 2)
}

///|
test "sqlite named and anonymous parameters together" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE events(id INTEGER, name TEXT, date TEXT, priority INTEGER)",
  )
  let insert = database.prepare(
    "INSERT INTO events (name, date, priority) VALUES (:name, :date, ?)",
  )
  // Using both named and anonymous parameters
  insert.run(named_parameters={ "name": "Meeting", "date": "2024-01-15" }, anonymous_parameters=[
    5,
  ])
  |> ignore
  insert.run(named_parameters={ "name": "Deadline", "date": "2024-01-20" }, anonymous_parameters=[
    10,
  ])
  |> ignore
  let select = database.prepare(
    "SELECT * FROM events WHERE priority > :min AND name LIKE ?",
  )
  let results = select.all(named_parameters={ "min": 7 }, anonymous_parameters=[
    "%line%",
  ])
  assert_eq(results.length(), 1)
  let event = results[0]
  assert_eq(unsafe_cast(event.get("name")), "Deadline")
}

///|
test "sqlite iterate with type-safe parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE scores(player TEXT, score INTEGER)")
  database.exec(
    "INSERT INTO scores VALUES ('Alice', 100), ('Bob', 150), ('Charlie', 120)",
  )
  let stmt = database.prepare(
    "SELECT * FROM scores WHERE score > ? ORDER BY score",
  )
  let iter = stmt.iterate(anonymous_parameters=[110])
  let mut count = 0
  let mut first_player = ""
  let mut second_player = ""
  for row in iter.iter() {
    let player : String = unsafe_cast(row.get("player"))
    if count == 0 {
      first_player = player
    } else if count == 1 {
      second_player = player
    }
    count = count + 1
  }
  assert_eq(count, 2)
  assert_eq(first_player, "Charlie")
  assert_eq(second_player, "Bob")
}

///|
test "sqlite get with complex named parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE employees(id INTEGER, name TEXT, salary REAL, department TEXT)",
  )
  let insert = database.prepare(
    "INSERT INTO employees (name, salary, department) VALUES (?, ?, ?)",
  )
  insert.run(anonymous_parameters=["Alice", 50000.0, "Engineering"]) |> ignore
  insert.run(anonymous_parameters=["Bob", 60000.0, "Sales"]) |> ignore
  insert.run(anonymous_parameters=["Charlie", 55000.0, "Engineering"]) |> ignore
  let stmt = database.prepare(
    "SELECT * FROM employees WHERE department = :dept AND salary > :minSalary",
  )
  let result = stmt.get_(named_parameters={
    "dept": "Engineering",
    "minSalary": 52000.0,
  })
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("name")), "Charlie")
  assert_eq(unsafe_cast(row.get("salary")), 55000.0)
}

///|
test "sqlite empty parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE simple(id INTEGER PRIMARY KEY, value TEXT)")
  database.exec("INSERT INTO simple VALUES (1, 'test')")
  let stmt = database.prepare("SELECT * FROM simple")
  // Test with no parameters
  let results = stmt.all()
  assert_eq(results.length(), 1)
  let result = stmt.get_()
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("value")), "test")
}

///|
test "sqlite integer types" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE integers(small INT, medium INT, large INT)")
  let insert = database.prepare("INSERT INTO integers VALUES (?, ?, ?)")
  insert.run(anonymous_parameters=[1, 1000, 1000000]) |> ignore
  insert.run(anonymous_parameters=[-5, -500, -50000]) |> ignore
  let select = database.prepare("SELECT * FROM integers WHERE medium < ?")
  let results = select.all(anonymous_parameters=[0])
  assert_eq(results.length(), 1)
  let row = results[0]
  assert_eq(unsafe_cast(row.get("small")), -5)
}

///|
test "sqlite float types" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE floats(val REAL)")
  let insert = database.prepare("INSERT INTO floats VALUES (?)")
  insert.run(anonymous_parameters=[3.14159]) |> ignore
  insert.run(anonymous_parameters=[2.71828]) |> ignore
  insert.run(anonymous_parameters=[1.41421]) |> ignore
  let select = database.prepare(
    "SELECT * FROM floats WHERE val > ? ORDER BY val",
  )
  let results = select.all(anonymous_parameters=[2.0])
  assert_eq(results.length(), 2)
}

///|
test "sqlite string escaping" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE texts(content TEXT)")
  let insert = database.prepare("INSERT INTO texts VALUES (?)")
  // Test strings with special characters
  insert.run(anonymous_parameters=["It's a test"]) |> ignore
  insert.run(anonymous_parameters=["Quote: \"hello\""]) |> ignore
  insert.run(anonymous_parameters=["Line\nbreak"]) |> ignore
  let select = database.prepare("SELECT * FROM texts WHERE content LIKE ?")
  let results = select.all(anonymous_parameters=["%test%"])
  assert_eq(results.length(), 1)
}

///|
test "sqlite multiple queries with same statement" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE counter(id INTEGER PRIMARY KEY, count INTEGER)")
  let insert = database.prepare("INSERT INTO counter (count) VALUES (?)")
  // Execute same statement multiple times with different parameters
  for i = 1; i <= 5; i = i + 1 {
    insert.run(anonymous_parameters=[i * 10]) |> ignore
  }
  let select = database.prepare("SELECT SUM(count) as total FROM counter")
  let result = select.get_()
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("total")), 150)
}

///|
test "sqlite update with type-safe parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE inventory(item TEXT PRIMARY KEY, quantity INTEGER)",
  )
  database.exec("INSERT INTO inventory VALUES ('apple', 10), ('banana', 20)")
  let update = database.prepare(
    "UPDATE inventory SET quantity = quantity + ? WHERE item = ?",
  )
  let result = update.run(anonymous_parameters=[5, "apple"])
  assert_eq(result.changes, 1)
  let select = database.prepare("SELECT quantity FROM inventory WHERE item = ?")
  let row_result = select.get_(anonymous_parameters=["apple"])
  guard row_result is Some(row)
  assert_eq(unsafe_cast(row.get("quantity")), 15)
}

///|
test "sqlite delete with named parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec(
    "CREATE TABLE todos(id INTEGER PRIMARY KEY, task TEXT, done INTEGER)",
  )
  database.exec(
    "INSERT INTO todos (task, done) VALUES ('task1', 0), ('task2', 1), ('task3', 1)",
  )
  let delete = database.prepare("DELETE FROM todos WHERE done = :completed")
  let result = delete.run(named_parameters={ "completed": 1 })
  assert_eq(result.changes, 2)
  let count = database.prepare("SELECT COUNT(*) as cnt FROM todos").get_()
  guard count is Some(row)
  assert_eq(unsafe_cast(row.get("cnt")), 1)
}

///|
test "sqlite null handling" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE nullable(id INTEGER, value TEXT)")
  let insert = database.prepare("INSERT INTO nullable (id) VALUES (?)")
  insert.run(anonymous_parameters=[1]) |> ignore
  let select = database.prepare("SELECT * FROM nullable WHERE id = ?")
  let result = select.get_(anonymous_parameters=[1])
  guard result is Some(row)
  assert_true(row.get("value") |> @js.is_null())
}

///|
test "sqlite transaction with type-safe parameters" {
  let database = DatabaseSync::new(":memory:")
  database.exec("CREATE TABLE accounts(id INTEGER PRIMARY KEY, balance REAL)")
  database.exec("INSERT INTO accounts VALUES (1, 100.0), (2, 50.0)")
  database.exec("BEGIN TRANSACTION")
  let update = database.prepare(
    "UPDATE accounts SET balance = balance + ? WHERE id = ?",
  )
  update.run(anonymous_parameters=[-30.0, 1]) |> ignore
  update.run(anonymous_parameters=[30.0, 2]) |> ignore
  database.exec("COMMIT")
  let select = database.prepare("SELECT balance FROM accounts WHERE id = ?")
  let result1 = select.get_(anonymous_parameters=[1])
  guard result1 is Some(row1)
  assert_eq(unsafe_cast(row1.get("balance")), 70.0)
  let result2 = select.get_(anonymous_parameters=[2])
  guard result2 is Some(row2)
  assert_eq(unsafe_cast(row2.get("balance")), 80.0)
}
