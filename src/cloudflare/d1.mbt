// Cloudflare D1 Database bindings

///|
#external
pub type D1Database

///|
pub impl Js for D1Database

///|
/// Prepare a SQL statement
pub fn D1Database::prepare(self : Self, query : String) -> D1PreparedStatement {
  self.invoke("prepare", [query]) |> unsafe_cast
}

///|
/// Execute a SQL statement directly (for statements that don't return data)
pub fn D1Database::exec(self : Self, query : String) -> Promise[D1ExecResult] {
  self.invoke("exec", [query]) |> unsafe_cast
}

///|
/// Batch execute multiple prepared statements in a transaction
pub fn D1Database::batch(
  self : Self,
  statements : Array[D1PreparedStatement],
) -> Promise[Array[D1Result]] {
  let stmts_js = js("[]")
  let mut i = 0
  while i < statements.length() {
    stmts_js.invoke("push", [statements[i]]) |> ignore
    i = i + 1
  }
  self.invoke("batch", [stmts_js]) |> unsafe_cast
}

///|
/// Dump the entire database
pub fn D1Database::dump(self : Self) -> Promise[Val] {
  self.invoke("dump", []) |> unsafe_cast
}

///|
/// Prepared statement type
#external
pub type D1PreparedStatement

///|
pub impl Js for D1PreparedStatement

///|
/// Bind parameters to a prepared statement
/// Note: This wraps parameters in an array and spreads them to match Cloudflare's API
pub fn D1PreparedStatement::bind(self : Self, params : Array[Val]) -> Self {
  // Cloudflare's bind() expects variadic arguments, not an array
  // We need to spread the array when calling bind
  let stmt_js = self.to_js()
  let bind_fn = stmt_js.get("bind")

  // Convert MoonBit array to JavaScript array
  let params_js = js("[]")
  let mut i = 0
  while i < params.length() {
    params_js.invoke("push", [params[i]]) |> ignore
    i = i + 1
  }

  // Use apply to spread the array as individual arguments
  unsafe_cast(bind_fn.invoke("apply", [stmt_js, params_js]))
}

///|
/// Bind a single parameter
pub fn D1PreparedStatement::bind1(self : Self, param : Val) -> Self {
  self.bind([param])
}

///|
/// Bind two parameters
pub fn D1PreparedStatement::bind2(self : Self, p1 : Val, p2 : Val) -> Self {
  self.bind([p1, p2])
}

///|
/// Bind three parameters
pub fn D1PreparedStatement::bind3(
  self : Self,
  p1 : Val,
  p2 : Val,
  p3 : Val,
) -> Self {
  self.bind([p1, p2, p3])
}

///|
/// Execute the statement and return first row
pub fn D1PreparedStatement::first(self : Self) -> Promise[Val?] {
  self.invoke("first", []) |> unsafe_cast
}

///|
/// Execute the statement and return first column value
pub fn D1PreparedStatement::first_col(
  self : Self,
  col_name : String,
) -> Promise[Val?] {
  self.invoke("first", [col_name]) |> unsafe_cast
}

///|
/// Execute the statement and return all rows
pub fn D1PreparedStatement::all(self : Self) -> Promise[D1Result] {
  self.invoke("all", []) |> unsafe_cast
}

///|
/// Execute the statement (for INSERT, UPDATE, DELETE)
pub fn D1PreparedStatement::run(self : Self) -> Promise[D1Result] {
  self.invoke("run", []) |> unsafe_cast
}

///|
/// Execute and return raw results
pub fn D1PreparedStatement::raw(self : Self) -> Promise[Array[Val]] {
  self.invoke("raw", []) |> unsafe_cast
}

///|
/// Execute and return raw results with options
pub fn D1PreparedStatement::raw_with_options(
  self : Self,
  options : D1RawOptions,
) -> Promise[Array[Val]] {
  self.invoke("raw", [options.to_js()]) |> unsafe_cast
}

///|
/// Options for raw query
pub(all) struct D1RawOptions {
  column_names : Bool? // Include column names as first row
}

///|
pub impl Js for D1RawOptions with to_js(self) {
  let obj = @js.new_empty_object()
  match self.column_names {
    Some(val) => obj.set("columnNames", val)
    None => ()
  }
  obj
}

///|
/// Result of a D1 query
pub(all) struct D1Result {
  results : Array[Val]?
  success : Bool
  meta : D1Meta?
  error : String?
}

///|
pub impl Js for D1Result with to_js(self) {
  self |> js
}

///|
/// Get results from D1Result
pub fn D1Result::get_results(self : Self) -> Array[Val] {
  match self.results {
    Some(r) => r
    None => []
  }
}

///|
/// Metadata about query execution
pub(all) struct D1Meta {
  duration : Double? // Query duration in milliseconds
  rows_read : Int? // Number of rows read
  rows_written : Int? // Number of rows written
  last_row_id : Int? // Last inserted row ID
  changed_db : Bool? // Whether database was changed
  changes : Int? // Number of rows changed
  size_after : Int? // Database size after query
}

///|
pub impl Js for D1Meta with to_js(self) {
  self |> js
}

///|
/// Result of exec operation
pub(all) struct D1ExecResult {
  count : Int // Number of statements executed
  duration : Double // Total duration in milliseconds
}

///|
pub impl Js for D1ExecResult with to_js(self) {
  self |> js
}

///|
/// Legacy type alias for compatibility
pub type D1ResultSet = D1Result
