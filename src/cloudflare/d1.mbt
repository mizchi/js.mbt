// Cloudflare D1 Database bindings

///|
#external
pub type D1Database

///|
pub impl @js.JsImpl for D1Database

///|
/// Prepare a SQL statement
pub fn D1Database::prepare(self : Self, query : String) -> D1PreparedStatement {
  self.call1("prepare", query).cast()
}

///|
/// Execute a SQL statement directly (for statements that don't return data)
pub async fn D1Database::exec(self : Self, query : String) -> D1ExecResult {
  let promise : @js.Promise[D1ExecResult] = self.call1("exec", query).cast()
  promise.wait()
}

///|
/// Batch execute multiple prepared statements in a transaction
pub async fn D1Database::batch(
  self : Self,
  statements : Array[D1PreparedStatement],
) -> Array[D1Result] {
  let stmts_js = @js.JsArray::new()
  let mut i = 0
  while i < statements.length() {
    stmts_js.call1("push", statements[i]) |> ignore
    i = i + 1
  }
  let promise : @js.Promise[Array[D1Result]] = self
    .call1("batch", stmts_js)
    .cast()
  promise.wait()
}

///|
/// Dump the entire database
pub async fn D1Database::dump(self : Self) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self.call0("dump").cast()
  promise.wait()
}

///|
/// Prepared statement type
#external
pub type D1PreparedStatement

///|
pub impl @js.JsImpl for D1PreparedStatement

///|
/// Bind parameters to a prepared statement
/// Note: This wraps parameters in an array and spreads them to match Cloudflare's API
pub fn D1PreparedStatement::bind(self : Self, params : Array[@js.Any]) -> Self {
  // Cloudflare's bind() expects variadic arguments, not an array
  // We need to spread the array when calling bind
  let stmt_js = self.to_any()
  let bind_fn = stmt_js.get("bind")

  // Convert MoonBit array to JavaScript array
  let params_js = @js.JsArray::new()
  let mut i = 0
  while i < params.length() {
    params_js.call1("push", params[i]) |> ignore
    i = i + 1
  }

  // Use apply to spread the array as individual arguments
  bind_fn.call2("apply", stmt_js, params_js).cast()
}

///|
/// Bind a single parameter
pub fn D1PreparedStatement::bind1(self : Self, param : @js.Any) -> Self {
  self.bind([param])
}

///|
/// Bind two parameters
pub fn D1PreparedStatement::bind2(
  self : Self,
  p1 : @js.Any,
  p2 : @js.Any,
) -> Self {
  self.bind([p1, p2])
}

///|
/// Bind three parameters
pub fn D1PreparedStatement::bind3(
  self : Self,
  p1 : @js.Any,
  p2 : @js.Any,
  p3 : @js.Any,
) -> Self {
  self.bind([p1, p2, p3])
}

///|
/// Execute the statement and return first row
pub async fn D1PreparedStatement::first(self : Self) -> @js.Any? {
  let promise : @js.Promise[@js.Any?] = self.call0("first").cast()
  promise.wait()
}

///|
/// Execute the statement and return first column value
pub async fn D1PreparedStatement::first_col(
  self : Self,
  col_name : String,
) -> @js.Any? {
  let promise : @js.Promise[@js.Any?] = self.call1("first", col_name).cast()
  promise.wait()
}

///|
/// Execute the statement and return all rows
pub async fn D1PreparedStatement::all(self : Self) -> D1Result {
  let promise : @js.Promise[D1Result] = self.call0("all").cast()
  promise.wait()
}

///|
/// Execute the statement (for INSERT, UPDATE, DELETE)
pub async fn D1PreparedStatement::run(self : Self) -> D1Result {
  let promise : @js.Promise[D1Result] = self.call0("run").cast()
  promise.wait()
}

///|
/// Execute and return raw results
pub async fn D1PreparedStatement::raw(
  self : Self,
  columnNames? : Bool,
) -> Array[@js.Any] {
  let promise : @js.Promise[Array[@js.Any]] = if columnNames is None {
    self.call0("raw").cast()
  } else {
    let opts = @js.from_option_map({
      "columnNames": columnNames.map(fn(x) { @js.any(x) }),
    })
    self.call1("raw", opts).cast()
  }
  promise.wait()
}

///|
/// Result of a D1 query
pub(all) struct D1Result {
  results : Array[@js.Any]?
  success : Bool
  meta : D1Meta?
  error : String?
}

///|
pub impl @js.JsImpl for D1Result

///|
/// Get results from D1Result
///
/// Note: The returned array is a snapshot and should be treated as immutable.
pub fn D1Result::get_results(self : Self) -> Array[@js.Any] {
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
pub impl @js.JsImpl for D1Meta

///|
/// Result of exec operation
pub(all) struct D1ExecResult {
  count : Int // Number of statements executed
  duration : Double // Total duration in milliseconds
}

///|
pub impl @js.JsImpl for D1ExecResult

///|
/// Legacy type alias for compatibility
pub type D1ResultSet = D1Result
