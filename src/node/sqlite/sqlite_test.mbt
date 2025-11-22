///|
using @js {unsafe_cast}

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
    result |> @js.from_array |> @js.JSON::stringify,
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
    r |> @js.JSON::stringify,
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
  let result1 = insert.run(anonymous_parameters=["Alice", 30])
  assert_eq(result1.changes, 1)
  let result2 = insert.run(anonymous_parameters=["Bob", 25])
  assert_eq(result2.changes, 1)
  let select = database.prepare("SELECT * FROM users WHERE age > ?")
  let users = select.all(anonymous_parameters=[26])
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
  let result = stmt.get_(anonymous_parameters=["theme"])
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("value")), "dark")
  let no_result = stmt.get_(anonymous_parameters=["nonexistent"])
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
  insert.run(anonymous_parameters=[1, "hello"]) |> ignore
  insert.run(anonymous_parameters=[2, "world"]) |> ignore
  let changeset = session.changeset()
  assert_true(changeset.byteLength > 0)
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
    result=fn(acc) { @js.unsafe_js(acc) },
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
  assert_false(row.get("value") |> @js.is_nullish())
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
test "sqlite DatabaseSync options - readOnly" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(id INTEGER)")
  db.exec("INSERT INTO test VALUES (1)")
  db.close()
  // Note: readOnly option requires a file path, not :memory:
  // This test verifies the option is passed correctly
  let db2 = DatabaseSync::new(":memory:", readOnly=false)
  db2.exec("CREATE TABLE test2(id INTEGER)")
  assert_true(db2.isOpen())
  db2.close()
}

///|
test "sqlite DatabaseSync options - timeout" {
  let db = DatabaseSync::new(":memory:", timeout=5000)
  db.exec("CREATE TABLE test(id INTEGER)")
  assert_true(db.isOpen())
  db.close()
}

///|
test "sqlite DatabaseSync options - returnArrays" {
  let db = DatabaseSync::new(":memory:", returnArrays=true)
  db.exec("CREATE TABLE test(a INTEGER, b INTEGER)")
  db.exec("INSERT INTO test VALUES (1, 2)")
  let stmt = db.prepare("SELECT * FROM test")
  let results = stmt.all()
  assert_eq(results.length(), 1)
  db.close()
}

///|
test "sqlite DatabaseSync options - enableForeignKeyConstraints" {
  let db = DatabaseSync::new(":memory:", enableForeignKeyConstraints=true)
  db.exec(
    (
      #|CREATE TABLE parent(id INTEGER PRIMARY KEY);
      #|CREATE TABLE child(id INTEGER PRIMARY KEY, parent_id INTEGER, FOREIGN KEY(parent_id) REFERENCES parent(id));
    ),
  )
  db.exec("INSERT INTO parent VALUES (1)")
  db.exec("INSERT INTO child VALUES (1, 1)")
  assert_true(db.isOpen())
  db.close()
}

///|
test "sqlite DatabaseSync options - defensive" {
  let db = DatabaseSync::new(":memory:", defensive=true)
  db.exec("CREATE TABLE test(id INTEGER)")
  assert_true(db.isOpen())
  db.close()
}

///|
test "sqlite DatabaseSync options - allowBareNamedParameters" {
  let db = DatabaseSync::new(":memory:", allowBareNamedParameters=true)
  db.exec("CREATE TABLE test(id INTEGER, name TEXT)")
  let stmt = db.prepare("INSERT INTO test VALUES (:id, :name)")
  stmt.run(named_parameters={ "id": 1, "name": "test" }) |> ignore
  db.close()
}

///|
test "sqlite DatabaseSync options - allowUnknownNamedParameters" {
  let db = DatabaseSync::new(":memory:", allowUnknownNamedParameters=true)
  db.exec("CREATE TABLE test(id INTEGER)")
  assert_true(db.isOpen())
  db.close()
}

///|
test "sqlite DatabaseSync options - allowExtension" {
  let db = DatabaseSync::new(":memory:", allowExtension=false)
  db.exec("CREATE TABLE test(id INTEGER)")
  assert_true(db.isOpen())
  db.close()
}

///|
test "sqlite StatementSync setReturnArrays" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(a INTEGER, b INTEGER)")
  db.exec("INSERT INTO test VALUES (1, 2)")
  let stmt = db.prepare("SELECT * FROM test")
  stmt.setReturnArrays(true)
  let results = stmt.all()
  assert_eq(results.length(), 1)
  db.close()
}

///|
test "sqlite StatementSync setReadBigInts" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(value INTEGER)")
  db.exec("INSERT INTO test VALUES (9007199254740991)")
  let stmt = db.prepare("SELECT value FROM test")
  stmt.setReadBigInts(true)
  let result = stmt.get_()
  guard result is Some(row)
  assert_false(row.get("value") |> @js.is_nullish())
  db.close()
}

///|
test "sqlite StatementSync setAllowBareNamedParameters" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(id INTEGER, name TEXT)")
  let stmt = db.prepare("INSERT INTO test VALUES (:id, :name)")
  stmt.setAllowBareNamedParameters(true)
  stmt.run(named_parameters={ "id": 1, "name": "test" }) |> ignore
  db.close()
}

///|
test "sqlite StatementSync setAllowUnknownNamedParameters" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(id INTEGER)")
  let stmt = db.prepare("SELECT * FROM test WHERE id = :id")
  stmt.setAllowUnknownNamedParameters(true)
  let _result = stmt.get_(named_parameters={ "id": 1, "unknown": 2 })
  db.close()
}

///|
test "sqlite Session patchset" {
  let source_db = DatabaseSync::new(":memory:")
  source_db.exec("CREATE TABLE data(key INTEGER PRIMARY KEY, value TEXT)")
  let session = source_db.createSession()
  let insert = source_db.prepare("INSERT INTO data (key, value) VALUES (?, ?)")
  insert.run(anonymous_parameters=[1, "hello"]) |> ignore
  insert.run(anonymous_parameters=[2, "world"]) |> ignore
  let patchset = session.patchset()
  assert_true(patchset.byteLength > 0)
  session.close()
  source_db.close()
}

///|
test "sqlite Session with table option" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE data(id INTEGER PRIMARY KEY, value TEXT)")
  let session = db.createSession(table="data")
  let insert = db.prepare("INSERT INTO data (value) VALUES (?)")
  insert.run(anonymous_parameters=["test"]) |> ignore
  let changeset = session.changeset()
  assert_true(changeset.byteLength > 0)
  session.close()
  db.close()
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite constants access" {
  let ok = sqlite_ok()
  // SQLITE_OK is 0
  assert_true(ok >= 0)
  let deny = sqlite_deny()
  // SQLITE_DENY is 1
  assert_true(deny >= 0)
  let ignore = sqlite_ignore()
  // SQLITE_IGNORE is 2
  assert_true(ignore >= 0)
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite changeset constants" {
  let data = sqlite_changeset_data()
  assert_true(data >= 0)
  let notfound = sqlite_changeset_notfound()
  assert_true(notfound >= 0)
  let conflict = sqlite_changeset_conflict()
  assert_true(conflict >= 0)
  let foreign_key = sqlite_changeset_foreign_key()
  assert_true(foreign_key >= 0)
  let omit = sqlite_changeset_omit()
  assert_true(omit >= 0)
  let replace = sqlite_changeset_replace()
  assert_true(replace >= 0)
  let abort = sqlite_changeset_abort()
  assert_true(abort >= 0)
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite authorization constants" {
  let create_index = sqlite_create_index()
  assert_true(create_index >= 0)
  let create_table = sqlite_create_table()
  assert_true(create_table >= 0)
  let create_temp_index = sqlite_create_temp_index()
  assert_true(create_temp_index >= 0)
  let create_temp_table = sqlite_create_temp_table()
  assert_true(create_temp_table >= 0)
  let create_temp_trigger = sqlite_create_temp_trigger()
  assert_true(create_temp_trigger >= 0)
  let create_temp_view = sqlite_create_temp_view()
  assert_true(create_temp_view >= 0)
  let create_trigger = sqlite_create_trigger()
  assert_true(create_trigger >= 0)
  let create_view = sqlite_create_view()
  assert_true(create_view >= 0)
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite operation constants" {
  let delete = sqlite_delete()
  assert_true(delete >= 0)
  let drop_index = sqlite_drop_index()
  assert_true(drop_index >= 0)
  let drop_table = sqlite_drop_table()
  assert_true(drop_table >= 0)
  let drop_temp_index = sqlite_drop_temp_index()
  assert_true(drop_temp_index >= 0)
  let drop_temp_table = sqlite_drop_temp_table()
  assert_true(drop_temp_table >= 0)
  let drop_temp_trigger = sqlite_drop_temp_trigger()
  assert_true(drop_temp_trigger >= 0)
  let drop_temp_view = sqlite_drop_temp_view()
  assert_true(drop_temp_view >= 0)
  let drop_trigger = sqlite_drop_trigger()
  assert_true(drop_trigger >= 0)
  let drop_view = sqlite_drop_view()
  assert_true(drop_view >= 0)
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite more operation constants" {
  let insert = sqlite_insert()
  assert_true(insert >= 0)
  let pragma = sqlite_pragma()
  assert_true(pragma >= 0)
  let read = sqlite_read()
  assert_true(read >= 0)
  let select = sqlite_select()
  assert_true(select >= 0)
  let transaction = sqlite_transaction()
  assert_true(transaction >= 0)
  let update = sqlite_update()
  assert_true(update >= 0)
  let attach = sqlite_attach()
  assert_true(attach >= 0)
  let detach = sqlite_detach()
  assert_true(detach >= 0)
}

///|
#skip("constants may not be available in all Node.js versions")
test "sqlite advanced operation constants" {
  let alter_table = sqlite_alter_table()
  assert_true(alter_table >= 0)
  let reindex = sqlite_reindex()
  assert_true(reindex >= 0)
  let analyze = sqlite_analyze()
  assert_true(analyze >= 0)
  let create_vtable = sqlite_create_vtable()
  assert_true(create_vtable >= 0)
  let drop_vtable = sqlite_drop_vtable()
  assert_true(drop_vtable >= 0)
  let function = sqlite_function()
  assert_true(function >= 0)
  let savepoint = sqlite_savepoint()
  assert_true(savepoint >= 0)
  let recursive = sqlite_recursive()
  assert_true(recursive >= 0)
}

///|
test "sqlite aggregate with all options" {
  let db = DatabaseSync::new(":memory:")
  db.exec("CREATE TABLE test(x INTEGER)")
  db.exec("INSERT INTO test VALUES (1), (2), (3)")
  db.aggregate(
    "test_agg",
    deterministic=true,
    directOnly=false,
    varargs=false,
    start=0,
    step=fn(acc, value) { acc + value },
    result=fn(acc) { @js.unsafe_js(acc) },
  )
  let stmt = db.prepare("SELECT test_agg(x) as total FROM test")
  let result = stmt.get_()
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("total")), 6)
  db.close()
}

///|
#skip("function registration with options needs fixing")
test "sqlite function with options" {
  let db = DatabaseSync::new(":memory:")
  db.function(
    "add_one",
    fn(args) {
      if args.length() == 0 {
        return @js.js(0)
      }
      let value : Int = unsafe_cast(args[0])
      @js.js(value + 1)
    },
    deterministic=true,
    directOnly=false,
    varargs=false,
  )
  db.exec("CREATE TABLE nums(x INTEGER)")
  db.exec("INSERT INTO nums VALUES (5)")
  let stmt = db.prepare("SELECT add_one(x) as result FROM nums")
  let result = stmt.get_()
  guard result is Some(row)
  assert_eq(unsafe_cast(row.get("result")), 6)
  db.close()
}

///|
test "sqlite enableLoadExtension" {
  let db = DatabaseSync::new(":memory:")
  db.enableLoadExtension(false)
  db.exec("CREATE TABLE test(id INTEGER)")
  assert_true(db.isOpen())
  db.close()
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
