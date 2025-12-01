///| drizzle-orm Prepared statements and raw SQL
/// https://orm.drizzle.team/docs/sql

///|
/// Prepared query handle
#external
pub type PreparedQuery

///|
pub fn PreparedQuery::as_any(self : PreparedQuery) -> @nostd.Any = "%identity"

// ============ Prepared Statements ============

///|
/// Prepare a query for later execution
pub fn QueryBuilder::prepare(
  self : QueryBuilder,
  name : String,
) -> PreparedQuery {
  self.call1("prepare", @nostd.any(name)) |> @js.identity
}

///|
extern "js" fn ffi_prepared_execute(
  pq : PreparedQuery,
  params : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #| (pq, params) => pq.execute(params)

///|
extern "js" fn ffi_prepared_execute_no_params(
  pq : PreparedQuery,
) -> @js.Promise[@nostd.Any] =
  #| (pq) => pq.execute()

///|
/// Execute a prepared query with parameters
pub async fn PreparedQuery::execute(
  self : PreparedQuery,
  params? : @nostd.Any,
) -> @nostd.Any {
  match params {
    Some(p) => ffi_prepared_execute(self, p).wait()
    None => ffi_prepared_execute_no_params(self).wait()
  }
}

///|
/// Execute a prepared query and get typed array result
pub async fn[T] PreparedQuery::execute_array(
  self : PreparedQuery,
  params? : @nostd.Any,
) -> Array[T] {
  let result = match params {
    Some(p) => ffi_prepared_execute(self, p).wait()
    None => ffi_prepared_execute_no_params(self).wait()
  }
  @js.identity(result)
}

// ============ Raw SQL Helpers ============

///|
/// Create SQL template with placeholders
/// Usage: sql_template(["SELECT * FROM users WHERE id = ", ""], [user_id])
#alias(sql_template)
pub fn sqlTemplate(strings : Array[String], values : Array[@nostd.Any]) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  // drizzle's sql is a tagged template function
  // We simulate it by calling sql.raw with the built string
  let mut result = ""
  for i, s in strings {
    result = result + s
    if i < values.length() {
      result = result + "?"
    }
  }
  // Use sql.raw for raw SQL with placeholders
  let raw_fn = sql_fn._get("raw")
  @nostd.any(raw_fn)._invoke([@nostd.any(result)]).cast()
}

///|
/// Create raw SQL (no escaping)
#alias(sql_raw)
pub fn sqlRaw(query : String) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  let raw_fn = sql_fn._get("raw")
  @nostd.any(raw_fn)._invoke([@nostd.any(query)]).cast()
}

///|
/// Create a placeholder for prepared statement parameters
pub fn placeholder(name : String) -> @nostd.Any {
  let sql_fn = drizzle_orm()._get("sql")
  let placeholder_fn = sql_fn._get("placeholder")
  @nostd.any(placeholder_fn)._invoke([@nostd.any(name)]).cast()
}

// ============ SQL Operators for Expressions ============

///|
/// SQL addition
#alias(sql_add)
pub fn sqlAdd(left : @nostd.Any, right : @nostd.Any) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  @nostd.any(sql_fn)
  ._invoke([
    @nostd.any(@js.from_array(["", " + ", ""])),
    @nostd.any(left),
    @nostd.any(right),
  ])
  .cast()
}

///|
/// SQL subtraction
#alias(sql_sub)
pub fn sqlSub(left : @nostd.Any, right : @nostd.Any) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  @nostd.any(sql_fn)
  ._invoke([
    @nostd.any(@js.from_array(["", " - ", ""])),
    @nostd.any(left),
    @nostd.any(right),
  ])
  .cast()
}

///|
/// SQL multiplication
#alias(sql_mul)
pub fn sqlMul(left : @nostd.Any, right : @nostd.Any) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  @nostd.any(sql_fn)
  ._invoke([
    @nostd.any(@js.from_array(["", " * ", ""])),
    @nostd.any(left),
    @nostd.any(right),
  ])
  .cast()
}

///|
/// SQL division
#alias(sql_div)
pub fn sqlDiv(left : @nostd.Any, right : @nostd.Any) -> SQL {
  let sql_fn = drizzle_orm()._get("sql")
  @nostd.any(sql_fn)
  ._invoke([
    @nostd.any(@js.from_array(["", " / ", ""])),
    @nostd.any(left),
    @nostd.any(right),
  ])
  .cast()
}

// ============ Subqueries ============

///|
/// Create a subquery alias
pub fn QueryBuilder::as_(self : QueryBuilder, name : String) -> @nostd.Any {
  self.call1("as", @nostd.any(name))
}

// ============ GROUP BY / HAVING ============

///|
extern "js" fn ffi_group_by(
  qb : QueryBuilder,
  columns : @nostd.Any,
) -> QueryBuilder =
  #| (qb, columns) => qb.groupBy(...columns)

///|
/// GROUP BY clause
#alias(group_by)
pub fn QueryBuilder::groupBy(
  self : QueryBuilder,
  columns : Array[Column],
) -> QueryBuilder {
  ffi_group_by(self, @js.from_array(columns.map(fn(c) { c.as_any() })))
}

///|
/// HAVING clause
pub fn QueryBuilder::having(
  self : QueryBuilder,
  condition : SQL,
) -> QueryBuilder {
  self.call1("having", @nostd.any(condition.as_any())) |> @js.identity
}

// ============ UNION / INTERSECT / EXCEPT ============

///|
/// UNION query
pub fn QueryBuilder::union(
  self : QueryBuilder,
  other : QueryBuilder,
) -> QueryBuilder {
  self.call1("union", @nostd.any(other.as_any())) |> @js.identity
}

///|
/// UNION ALL query
#alias(union_all)
pub fn QueryBuilder::unionAll(
  self : QueryBuilder,
  other : QueryBuilder,
) -> QueryBuilder {
  self.call1("unionAll", @nostd.any(other.as_any())) |> @js.identity
}

///|
/// INTERSECT query
pub fn QueryBuilder::intersect(
  self : QueryBuilder,
  other : QueryBuilder,
) -> QueryBuilder {
  self.call1("intersect", @nostd.any(other.as_any())) |> @js.identity
}

///|
/// EXCEPT query
pub fn QueryBuilder::except(
  self : QueryBuilder,
  other : QueryBuilder,
) -> QueryBuilder {
  self.call1("except", @nostd.any(other.as_any())) |> @js.identity
}

// ============ ON CONFLICT (Upsert) ============

///|
/// ON CONFLICT DO NOTHING
#alias(on_conflict_do_nothing)
pub fn QueryBuilder::onConflictDoNothing(self : QueryBuilder) -> QueryBuilder {
  self.call0("onConflictDoNothing") |> @js.identity
}

///|
extern "js" fn ffi_on_conflict_do_update(
  qb : QueryBuilder,
  config : @nostd.Any,
) -> QueryBuilder =
  #| (qb, config) => qb.onConflictDoUpdate(config)

///|
/// ON CONFLICT DO UPDATE (upsert)
#alias(on_conflict_do_update)
pub fn QueryBuilder::onConflictDoUpdate(
  self : QueryBuilder,
  target : Array[Column],
  set_values : @nostd.Any,
) -> QueryBuilder {
  let config = @nostd.Object::new()
  config.set("target", @js.from_array(target.map(fn(c) { c.as_any() })))
  config.set("set", set_values)
  ffi_on_conflict_do_update(self, config.as_any())
}
