///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite create in-memory database" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  @js.typeof_(db) |> assert_eq("object")
}

///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite simple query" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  let result = db.query("SELECT 1 + 1 as sum")
  let rows : Array[@js.Any] = result.rows_array()
  assert_eq(rows.length(), 1)
}

///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite create table and insert" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  db.exec(
    "CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT NOT NULL, age INT)",
  )
  |> ignore
  db.query("INSERT INTO users (name, age) VALUES ($1, $2)", params=[
    @js.any("Alice"),
    @js.any(30),
  ])
  |> ignore
  let result = db.query("SELECT * FROM users WHERE name = $1", params=[
    @js.any("Alice"),
  ])
  let rows : Array[@js.Any] = result.rows_array()
  assert_eq(rows.length(), 1)
}

///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite query with multiple rows" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  db.exec("CREATE TABLE items (id SERIAL PRIMARY KEY, name TEXT)") |> ignore
  db.exec("INSERT INTO items (name) VALUES ('a'), ('b'), ('c')") |> ignore
  let result = db.query("SELECT * FROM items ORDER BY name")
  let rows : Array[@js.Any] = result.rows_array()
  assert_eq(rows.length(), 3)
}

///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite exec multiple statements" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  db.exec("CREATE TABLE test1 (id INT); CREATE TABLE test2 (id INT);") |> ignore
  // Verify both tables exist
  let result = db.query(
    "SELECT table_name FROM information_schema.tables WHERE table_name IN ('test1', 'test2')",
  )
  let rows : Array[@js.Any] = result.rows_array()
  assert_eq(rows.length(), 2)
}

///|
#skip("PGlite tests are slow and block moon test")
async test "Results fields" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  let result = db.query("SELECT 1 as num, 'hello' as msg")
  let fields = result.fields()
  @js.typeof_(fields) |> assert_eq("object")
}

///|
#skip("PGlite tests are slow and block moon test")
async test "PGlite query string result" {
  let db = PGlite::create()
  defer db.closeSync() |> ignore
  let result = db.query("SELECT 'Hello PGlite' as message")
  let rows = result.rows()
  let first_row = rows.get("0")
  let message : String = first_row.get("message").cast()
  assert_eq(message, "Hello PGlite")
}
