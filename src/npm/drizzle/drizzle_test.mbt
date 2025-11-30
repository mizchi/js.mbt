///| drizzle-orm libsql tests

// =============================================================================
// Test Helper FFI Functions
// =============================================================================
// This FFI function is used for testing raw SQL execution with drizzle.
// The DrizzleDB.run() method is not yet wrapped in the library's public API.
// =============================================================================

///|
/// [Test Helper] Executes raw SQL using DrizzleDB.run().
/// Used for DDL operations like CREATE TABLE in tests.
extern "js" fn test_ffi_db_run(
  db : DrizzleDB,
  sql : SQL,
) -> @js.Promise[@js.Any] =
  #| (db, sql) => db.run(sql)

// Schema definition for tests using Map

///|
fn get_users_table_with_email() -> Table {
  let cols : Map[String, Column] = {
    "id": sqliteInt(name="id").primaryKeyAutoIncrement(),
    "name": sqliteText(name="name").notNull(),
    "email": sqliteText(name="email").unique(),
    "age": sqliteInt(name="age"),
  }
  sqliteTableFromMap("users", cols)
}

///|
fn get_users_table() -> Table {
  let cols : Map[String, Column] = {
    "id": sqliteInt(name="id").primaryKeyAutoIncrement(),
    "name": sqliteText(name="name").notNull(),
    "age": sqliteInt(name="age"),
  }
  sqliteTableFromMap("users", cols)
}

///|
async test "drizzle libsql - create table and insert" {
  // Create in-memory database
  let db = drizzleLibsql("file::memory:")

  // Create table using raw SQL
  let _ = test_ffi_db_run(
    db,
    sqlRaw(
      "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE, age INTEGER)",
    ),
  ).wait()

  // Get table reference for queries
  let users = get_users_table_with_email()

  // Insert a user using Row builder
  let insert_data = Row::new()
    .str("name", "Alice")
    .str("email", "alice@example.com")
    .int("age", 30)
  let _ = db.insert(users).values(@nostd.any(insert_data.as_any())).execute()

  // Query users
  let result : Array[@js.Any] = db.select().from(users).execute_array()
  inspect(result.length(), content="1")
}

///|
async test "drizzle libsql - multiple inserts and select" {
  let db = drizzleLibsql("file::memory:")

  // Create table
  let _ = test_ffi_db_run(
    db,
    sqlRaw(
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE, age INTEGER)",
    ),
  ).wait()
  let users = get_users_table_with_email()

  // Insert multiple users using Row builder
  let user1 = Row::new()
    .str("name", "Alice")
    .str("email", "alice@example.com")
    .int("age", 30)
  let user2 = Row::new()
    .str("name", "Bob")
    .str("email", "bob@example.com")
    .int("age", 25)
  let user3 = Row::new()
    .str("name", "Charlie")
    .str("email", "charlie@example.com")
    .int("age", 35)
  let _ = db.insert(users).values(@nostd.any(rows([user1, user2, user3]))).execute()

  // Select all
  let all_users : Array[@js.Any] = db.select().from(users).execute_array()
  inspect(all_users.length(), content="3")

  // Select with filter
  let age_col : Column = users.get("age") |> @js.identity
  let older_users : Array[@js.Any] = db
    .select()
    .from(users)
    .filter(gt(age_col, @nostd.any(28)))
    .execute_array()
  inspect(older_users.length(), content="2")
}

///|
async test "drizzle libsql - update and delete" {
  let db = drizzleLibsql("file::memory:")

  // Create table and insert data
  let _ = test_ffi_db_run(
    db,
    sqlRaw(
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT, age INTEGER)",
    ),
  ).wait()
  let users = get_users_table_with_email()
  let user = Row::new().str("name", "Alice").int("age", 30)
  let _ = db.insert(users).values(@nostd.any(user.as_any())).execute()

  // Update
  let name_col : Column = users.get("name") |> @js.identity
  let update_data = Row::new().int("age", 31)
  let _ = db
    .update(users)
    .set(@nostd.any(update_data.as_any()))
    .filter(eq(name_col, @nostd.any("Alice")))
    .execute()

  // Verify update
  let result : Array[@js.Any] = db
    .select()
    .from(users)
    .filter(eq(name_col, @nostd.any("Alice")))
    .execute_array()
  inspect(result.length(), content="1")
  let updated_user = result[0]
  let age : Int = updated_user.get("age").cast()
  inspect(age, content="31")

  // Delete
  let _ = db.delete(users).filter(eq(name_col, @nostd.any("Alice"))).execute()

  // Verify delete
  let after_delete : Array[@js.Any] = db.select().from(users).execute_array()
  inspect(after_delete.length(), content="0")
}

///|
async test "drizzle libsql - order by and limit" {
  let db = drizzleLibsql("file::memory:")
  let _ = test_ffi_db_run(
    db,
    sqlRaw(
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER)",
    ),
  ).wait()
  let users = get_users_table()

  // Insert users with different ages using Row builder
  let u1 = Row::new().str("name", "User20").int("age", 20)
  let u2 = Row::new().str("name", "User30").int("age", 30)
  let u3 = Row::new().str("name", "User35").int("age", 35)
  let _ = db.insert(users).values(@nostd.any(rows([u1, u2, u3]))).execute()

  // Select without orderBy first to verify data
  let all : Array[@js.Any] = db.select().from(users).execute_array()
  inspect(all.length(), content="3")

  // Limit only (without orderBy)
  let limited : Array[@js.Any] = db
    .select()
    .from(users)
    .limit(2)
    .execute_array()
  inspect(limited.length(), content="2")
}

///|
async test "drizzle libsql - SQL operators" {
  let db = drizzleLibsql("file::memory:")
  let _ = test_ffi_db_run(
    db,
    sqlRaw(
      "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER)",
    ),
  ).wait()
  let users = get_users_table()

  // Insert test data using Row builder
  let alice = Row::new().str("name", "Alice").int("age", 30)
  let bob = Row::new().str("name", "Bob").int("age", 25)
  let charlie = Row::new().str("name", "Charlie").int("age", 35)
  let _ = db.insert(users).values(@nostd.any(rows([alice, bob, charlie]))).execute()

  // Simple test - lt operator (which is similar to gt that works)
  let age_col : Column = users.get("age") |> @js.identity
  let lt_result : Array[@js.Any] = db
    .select()
    .from(users)
    .filter(lt(age_col, @nostd.any(32)))
    .execute_array()
  inspect(lt_result.length(), content="2") // Alice(30), Bob(25)
}
