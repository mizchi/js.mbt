// Cloudflare D1 Database bindings

///|
#external
pub type D1Database

///|
pub impl JsImpl for D1Database

///|
/// Prepare a SQL statement
pub fn D1Database::prepare(self : Self, query : String) -> D1PreparedStatement {
  self.call("prepare", [query]) |> unsafe_cast
}

///|
/// Execute a SQL statement directly (for statements that don't return data)
pub fn D1Database::exec(self : Self, query : String) -> Promise[D1ExecResult] {
  self.call("exec", [query]) |> unsafe_cast
}

///|
/// Batch execute multiple prepared statements in a transaction
pub fn D1Database::batch(
  self : Self,
  statements : Array[D1PreparedStatement],
) -> Promise[Array[D1Result]] {
  let stmts_js = @js.JsArray::new()
  let mut i = 0
  while i < statements.length() {
    stmts_js.call("push", [statements[i]]) |> ignore
    i = i + 1
  }
  self.call("batch", [stmts_js]) |> unsafe_cast
}

///|
/// Dump the entire database
pub fn D1Database::dump(self : Self) -> Promise[Js] {
  self.call0("dump") |> unsafe_cast
}

///|
/// Prepared statement type
#external
pub type D1PreparedStatement

///|
pub impl JsImpl for D1PreparedStatement

///|
/// Bind parameters to a prepared statement
/// Note: This wraps parameters in an array and spreads them to match Cloudflare's API
pub fn D1PreparedStatement::bind(self : Self, params : Array[Js]) -> Self {
  // Cloudflare's bind() expects variadic arguments, not an array
  // We need to spread the array when calling bind
  let stmt_js = self.to_js()
  let bind_fn = stmt_js.get("bind")

  // Convert MoonBit array to JavaScript array
  let params_js = @js.JsArray::new()
  let mut i = 0
  while i < params.length() {
    params_js.call("push", [params[i]]) |> ignore
    i = i + 1
  }

  // Use apply to spread the array as individual arguments
  bind_fn.call2("apply", stmt_js, params_js) |> unsafe_cast
}

///|
/// Bind a single parameter
pub fn D1PreparedStatement::bind1(self : Self, param : Js) -> Self {
  self.bind([param])
}

///|
/// Bind two parameters
pub fn D1PreparedStatement::bind2(self : Self, p1 : Js, p2 : Js) -> Self {
  self.bind([p1, p2])
}

///|
/// Bind three parameters
pub fn D1PreparedStatement::bind3(
  self : Self,
  p1 : Js,
  p2 : Js,
  p3 : Js,
) -> Self {
  self.bind([p1, p2, p3])
}

///|
/// Execute the statement and return first row
pub fn D1PreparedStatement::first(self : Self) -> Promise[Js?] {
  self.call0("first") |> unsafe_cast
}

///|
/// Execute the statement and return first column value
pub fn D1PreparedStatement::first_col(
  self : Self,
  col_name : String,
) -> Promise[Js?] {
  self.call1("first", col_name) |> unsafe_cast
}

///|
/// Execute the statement and return all rows
pub fn D1PreparedStatement::all(self : Self) -> Promise[D1Result] {
  self.call0("all") |> unsafe_cast
}

///|
/// Execute the statement (for INSERT, UPDATE, DELETE)
pub fn D1PreparedStatement::run(self : Self) -> Promise[D1Result] {
  self.call0("run") |> unsafe_cast
}

///|
/// Execute and return raw results
pub fn D1PreparedStatement::raw(self : Self) -> Promise[Array[Js]] {
  self.call0("raw") |> unsafe_cast
}

///|
/// Execute and return raw results with options
pub fn D1PreparedStatement::raw_with_options(
  self : Self,
  options : D1RawOptions,
) -> Promise[Array[Js]] {
  self.call1("raw", options) |> unsafe_cast
}

///|
/// Options for raw query
pub(all) struct D1RawOptions {
  columnNames : Bool? // Include column names as first row
}

///|
pub impl JsImpl for D1RawOptions with to_js(self) {
  @js.from_entries_option_cast([("columnNames", self.columnNames)])
}

///|
/// Result of a D1 query
pub(all) struct D1Result {
  results : Array[Js]?
  success : Bool
  meta : D1Meta?
  error : String?
}

///|
pub impl JsImpl for D1Result

///|
/// Get results from D1Result
pub fn D1Result::get_results(self : Self) -> Array[Js] {
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
pub impl JsImpl for D1Meta

///|
/// Result of exec operation
pub(all) struct D1ExecResult {
  count : Int // Number of statements executed
  duration : Double // Total duration in milliseconds
}

///|
pub impl JsImpl for D1ExecResult

///|
/// Legacy type alias for compatibility
pub type D1ResultSet = D1Result
