///| drizzle-orm FFI bindings
/// https://orm.drizzle.team/

// ============ Row Builder ============
// Helper for building row data without exposing @core.Any

///|
/// Row builder for constructing insert/update data
pub struct Row {
  priv obj : @core.Any
}

///|
/// Create a new empty row
pub fn Row::new() -> Row {
  { obj: @core.new_object() }
}

///|
/// Set a string value
pub fn Row::str(self : Row, key : String, value : String) -> Row {
  self.obj._set(key, value |> @core.any)
  self
}

///|
/// Set an integer value
pub fn Row::int(self : Row, key : String, value : Int) -> Row {
  self.obj._set(key, value |> @core.any)
  self
}

///|
/// Set a double value
pub fn Row::double(self : Row, key : String, value : Double) -> Row {
  self.obj._set(key, value |> @core.any)
  self
}

///|
/// Set a boolean value
pub fn Row::bool(self : Row, key : String, value : Bool) -> Row {
  self.obj._set(key, value |> @core.any)
  self
}

///|
/// Set a null value
pub fn Row::null(self : Row, key : String) -> Row {
  self.obj._set(key, @core.null())
  self
}

///|
/// Set any JsImpl value
pub fn Row::set_(self : Row, key : String, value : @core.Any) -> Row {
  @core.any(self.obj)[key] = value
  self
}

///|
/// Build the row data (returns the underlying JS object)
pub fn Row::build(self : Row) -> @core.Any {
  self.obj
}

///|
pub fn Row::as_any(self : Row) -> @core.Any {
  self.obj
}

// ============ Row Array Helper ============

///|
/// Create an array of rows for batch insert
pub fn rows(items : Array[Row]) -> @core.Any {
  @core.any(items.map(fn(r) { r.obj }))
}

// Internal helpers for other files in this package

///|
fn drizzle_pg_core() -> @core.Any {
  @node.require("drizzle-orm/pg-core")
}

///|
fn drizzle_orm() -> @core.Any {
  @node.require("drizzle-orm")
}

///|
/// Drizzle database instance
#external
pub type DrizzleDB

///|
pub fn DrizzleDB::as_any(self : DrizzleDB) -> @core.Any = "%identity"

///|
/// Query builder
#external
pub type QueryBuilder

///|
pub fn QueryBuilder::as_any(self : QueryBuilder) -> @core.Any = "%identity"

// Internal helper for method calls

///|
fn QueryBuilder::call0(self : QueryBuilder, name : String) -> @core.Any {
  @core.any(self)._call(name, []).cast()
}

///|
fn QueryBuilder::call1(
  self : QueryBuilder,
  name : String,
  arg : @core.Any,
) -> @core.Any {
  @core.any(self)._call(name, [arg]).cast()
}

///|
/// Table definition
#external
pub type Table

///|
pub fn Table::as_any(self : Table) -> @core.Any = "%identity"

///|
/// Get a column from a table by name
pub fn Table::get(self : Table, name : String) -> @core.Any {
  self.as_any()._get(name)
}

///|
/// Column definition
#external
pub type Column

///|
pub fn Column::as_any(self : Column) -> @core.Any = "%identity"

// Internal helper for method calls

///|
fn Column::call0(self : Column, name : String) -> @core.Any {
  @core.any(self)._call(name, []).cast()
}

///|
fn Column::call1(self : Column, name : String, arg : @core.Any) -> @core.Any {
  @core.any(self)._call(name, [arg]).cast()
}

///|
/// SQL expression
#external
pub type SQL

///|
pub fn SQL::as_any(self : SQL) -> @core.Any = "%identity"

// ============ Database Creation ============

///|
/// Create a Drizzle instance with connection string
pub extern "js" fn drizzle(connection_string : String) -> DrizzleDB =
  #| (cs) => require("drizzle-orm/node-postgres").drizzle(cs)

///|
/// Create a Drizzle instance with pg Pool
#alias(drizzle_with_pool)
pub extern "js" fn drizzleWithPool(pool : @core.Any) -> DrizzleDB =
  #| (pool) => require("drizzle-orm/node-postgres").drizzle(pool)

///|
/// Create a Drizzle instance with config object
#alias(drizzle_with_config)
pub fn drizzleWithConfig(config : @core.Any) -> DrizzleDB {
  drizzleWithPool(config)
}

// ============ Cloudflare D1 ============

///|
/// Create a Drizzle instance with Cloudflare D1 database binding
/// Usage: drizzleD1(env.DB) where env.DB is D1Database from Cloudflare Workers
#alias(drizzle_d1)
pub extern "js" fn drizzleD1(d1_database : @core.Any) -> DrizzleDB =
  #| (d1) => require("drizzle-orm/d1").drizzle(d1)

///|
/// Create a Drizzle instance with D1 and schema for relational queries
#alias(drizzle_d1_with_schema)
pub extern "js" fn drizzleD1WithSchema(
  d1_database : @core.Any,
  schema : @core.Any,
) -> DrizzleDB =
  #| (d1, schema) => require("drizzle-orm/d1").drizzle(d1, { schema })

// ============ Schema Definition ============

///|
/// Create a PostgreSQL table
#alias(pg_table)
pub extern "js" fn pgTable(name : String, columns : @core.Any) -> Table =
  #| (name, columns) => require("drizzle-orm/pg-core").pgTable(name, columns)

///|
/// Create a PostgreSQL table from a Map of column definitions
#alias(pg_table_from_map)
pub fn pgTableFromMap(name : String, columns : Map[String, Column]) -> Table {
  let obj = @core.new_object()
  columns.each(fn(key, col) { obj._set(key, col.as_any() |> @core.any) })
  pgTable(name, obj)
}

///|
extern "js" fn ffi_integer(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").integer(name)

///|
extern "js" fn ffi_integer_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").integer()

///|
/// Integer column type
pub fn integer(name? : String) -> Column {
  match name {
    Some(n) => ffi_integer(n)
    None => ffi_integer_no_name()
  }
}

///|
extern "js" fn ffi_serial(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").serial(name)

///|
extern "js" fn ffi_serial_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").serial()

///|
/// Serial (auto-increment) column type
pub fn serial(name? : String) -> Column {
  match name {
    Some(n) => ffi_serial(n)
    None => ffi_serial_no_name()
  }
}

///|
extern "js" fn ffi_bigserial(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").bigserial(name)

///|
extern "js" fn ffi_bigserial_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").bigserial()

///|
/// Big serial column type
#alias(big_serial)
pub fn bigserial(name? : String) -> Column {
  match name {
    Some(n) => ffi_bigserial(n)
    None => ffi_bigserial_no_name()
  }
}

///|
extern "js" fn ffi_text(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").text(name)

///|
extern "js" fn ffi_text_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").text()

///|
/// Text column type
pub fn text(name? : String) -> Column {
  match name {
    Some(n) => ffi_text(n)
    None => ffi_text_no_name()
  }
}

///|
extern "js" fn ffi_varchar(name : String, length : Int) -> Column =
  #| (name, length) => require("drizzle-orm/pg-core").varchar(name, { length })

///|
extern "js" fn ffi_varchar_name_only(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").varchar(name)

///|
extern "js" fn ffi_varchar_length_only(length : Int) -> Column =
  #| (length) => require("drizzle-orm/pg-core").varchar({ length })

///|
extern "js" fn ffi_varchar_no_args() -> Column =
  #| () => require("drizzle-orm/pg-core").varchar()

///|
/// Varchar column type with optional length
pub fn varchar(name? : String, length? : Int) -> Column {
  match (name, length) {
    (Some(n), Some(l)) => ffi_varchar(n, l)
    (Some(n), None) => ffi_varchar_name_only(n)
    (None, Some(l)) => ffi_varchar_length_only(l)
    (None, None) => ffi_varchar_no_args()
  }
}

///|
extern "js" fn ffi_boolean(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").boolean(name)

///|
extern "js" fn ffi_boolean_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").boolean()

///|
/// Boolean column type
pub fn boolean(name? : String) -> Column {
  match name {
    Some(n) => ffi_boolean(n)
    None => ffi_boolean_no_name()
  }
}

///|
extern "js" fn ffi_timestamp(name : String, with_timezone : Bool) -> Column =
  #| (name, withTimezone) => require("drizzle-orm/pg-core").timestamp(name, { withTimezone })

///|
extern "js" fn ffi_timestamp_name_only(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").timestamp(name)

///|
extern "js" fn ffi_timestamp_tz_only(with_timezone : Bool) -> Column =
  #| (withTimezone) => require("drizzle-orm/pg-core").timestamp({ withTimezone })

///|
extern "js" fn ffi_timestamp_no_args() -> Column =
  #| () => require("drizzle-orm/pg-core").timestamp()

///|
/// Timestamp column type
pub fn timestamp(name? : String, with_timezone? : Bool) -> Column {
  match (name, with_timezone) {
    (Some(n), Some(tz)) => ffi_timestamp(n, tz)
    (Some(n), None) => ffi_timestamp_name_only(n)
    (None, Some(tz)) => ffi_timestamp_tz_only(tz)
    (None, None) => ffi_timestamp_no_args()
  }
}

///|
extern "js" fn ffi_json(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").json(name)

///|
extern "js" fn ffi_json_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").json()

///|
/// JSON column type
pub fn json(name? : String) -> Column {
  match name {
    Some(n) => ffi_json(n)
    None => ffi_json_no_name()
  }
}

///|
extern "js" fn ffi_jsonb(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").jsonb(name)

///|
extern "js" fn ffi_jsonb_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").jsonb()

///|
/// JSONB column type
pub fn jsonb(name? : String) -> Column {
  match name {
    Some(n) => ffi_jsonb(n)
    None => ffi_jsonb_no_name()
  }
}

///|
extern "js" fn ffi_uuid(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").uuid(name)

///|
extern "js" fn ffi_uuid_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").uuid()

///|
/// UUID column type
pub fn uuid(name? : String) -> Column {
  match name {
    Some(n) => ffi_uuid(n)
    None => ffi_uuid_no_name()
  }
}

///|
extern "js" fn ffi_numeric(
  name : String,
  precision : Int,
  scale : Int,
) -> Column =
  #| (name, precision, scale) => require("drizzle-orm/pg-core").numeric(name, { precision, scale })

///|
extern "js" fn ffi_numeric_name_precision(
  name : String,
  precision : Int,
) -> Column =
  #| (name, precision) => require("drizzle-orm/pg-core").numeric(name, { precision })

///|
extern "js" fn ffi_numeric_name_only(name : String) -> Column =
  #| (name) => require("drizzle-orm/pg-core").numeric(name)

///|
extern "js" fn ffi_numeric_no_name() -> Column =
  #| () => require("drizzle-orm/pg-core").numeric()

///|
/// Numeric/Decimal column type
pub fn numeric(name? : String, precision? : Int, scale? : Int) -> Column {
  match (name, precision, scale) {
    (Some(n), Some(p), Some(s)) => ffi_numeric(n, p, s)
    (Some(n), Some(p), None) => ffi_numeric_name_precision(n, p)
    (Some(n), None, _) => ffi_numeric_name_only(n)
    (None, _, _) => ffi_numeric_no_name()
  }
}

// ============ Column Modifiers ============

///|
/// Mark column as primary key
#alias(primary_key)
pub extern "js" fn Column::primaryKey(self : Column) -> Column =
  #| (col) => col.primaryKey()

///|
/// Mark column as not null
#alias(not_null)
pub extern "js" fn Column::notNull(self : Column) -> Column =
  #| (col) => col.notNull()

///|
/// Mark column as unique
pub extern "js" fn Column::unique(self : Column) -> Column =
  #| (col) => col.unique()

///|
extern "js" fn ffi_default_value(col : Column, value : @core.Any) -> Column =
  #| (col, value) => col.default(value)

///|
/// Set default value (accepts any value)
#alias(default_value)
pub fn Column::defaultValue(self : Column, value : @core.Any) -> Column {
  ffi_default_value(self, @core.identity(value))
}

///|
/// Set default to current timestamp
#alias(default_now)
pub extern "js" fn Column::defaultNow(self : Column) -> Column =
  #| (col) => col.defaultNow()

///|
/// Generated always as identity
#alias(generated_always_as_identity)
pub extern "js" fn Column::generatedAlwaysAsIdentity(self : Column) -> Column =
  #| (col) => col.generatedAlwaysAsIdentity()

///|
/// Add references (foreign key)
pub extern "js" fn Column::references(
  self : Column,
  ref_fn : () -> Column,
) -> Column =
  #| (col, refFn) => col.references(refFn)

// ============ Query Operations ============

///|
extern "js" fn ffi_select(db : DrizzleDB) -> QueryBuilder =
  #| (db) => db.select()

///|
extern "js" fn ffi_select_fields(
  db : DrizzleDB,
  fields : @core.Any,
) -> QueryBuilder =
  #| (db, fields) => db.select(fields)

///|
/// Start a SELECT query
pub fn DrizzleDB::select(self : DrizzleDB, fields? : @core.Any) -> QueryBuilder {
  match fields {
    Some(f) => ffi_select_fields(self, f)
    None => ffi_select(self)
  }
}

///|
/// Start a SELECT DISTINCT query
#alias(select_distinct)
pub extern "js" fn DrizzleDB::selectDistinct(self : DrizzleDB) -> QueryBuilder =
  #| (db) => db.selectDistinct()

///|
/// Start an INSERT query
pub extern "js" fn DrizzleDB::insert(
  self : DrizzleDB,
  table : Table,
) -> QueryBuilder =
  #| (db, table) => db.insert(table)

///|
/// Start an UPDATE query
pub extern "js" fn DrizzleDB::update(
  self : DrizzleDB,
  table : Table,
) -> QueryBuilder =
  #| (db, table) => db.update(table)

///|
/// Start a DELETE query
pub extern "js" fn DrizzleDB::delete(
  self : DrizzleDB,
  table : Table,
) -> QueryBuilder =
  #| (db, table) => db.delete(table)

// ============ Query Builder Methods ============

///|
/// FROM clause
pub extern "js" fn QueryBuilder::from(
  self : QueryBuilder,
  table : Table,
) -> QueryBuilder =
  #| (qb, table) => qb.from(table)

///|
/// WHERE clause
pub extern "js" fn QueryBuilder::filter(
  self : QueryBuilder,
  condition : SQL,
) -> QueryBuilder =
  #| (qb, condition) => qb.where(condition)

///|
extern "js" fn ffi_values(qb : QueryBuilder, data : @core.Any) -> QueryBuilder =
  #| (qb, data) => qb.values(data)

///|
/// VALUES for INSERT (accepts any value)
pub fn QueryBuilder::values(
  self : QueryBuilder,
  data : @core.Any,
) -> QueryBuilder {
  ffi_values(self, @core.identity(data))
}

///|
extern "js" fn ffi_set(qb : QueryBuilder, data : @core.Any) -> QueryBuilder =
  #| (qb, data) => qb.set(data)

///|
/// SET for UPDATE (accepts any value)
pub fn QueryBuilder::set(self : QueryBuilder, data : @core.Any) -> QueryBuilder {
  ffi_set(self, @core.identity(data))
}

///|
extern "js" fn ffi_order_by(
  qb : QueryBuilder,
  columns : Array[@core.Any],
) -> QueryBuilder =
  #| (qb, columns) => qb.orderBy(...columns)

///|
/// ORDER BY clause
#alias(order_by)
pub fn QueryBuilder::orderBy(
  self : QueryBuilder,
  columns : Array[@core.Any],
) -> QueryBuilder {
  ffi_order_by(self, columns)
}

///|
/// LIMIT clause
pub extern "js" fn QueryBuilder::limit(
  self : QueryBuilder,
  count : Int,
) -> QueryBuilder =
  #| (qb, count) => qb.limit(count)

///|
/// OFFSET clause
pub extern "js" fn QueryBuilder::offset(
  self : QueryBuilder,
  count : Int,
) -> QueryBuilder =
  #| (qb, count) => qb.offset(count)

///|
/// RETURNING clause
pub extern "js" fn QueryBuilder::returning(self : QueryBuilder) -> QueryBuilder =
  #| (qb) => qb.returning()

///|
/// LEFT JOIN
#alias(left_join)
pub extern "js" fn QueryBuilder::leftJoin(
  self : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder =
  #| (qb, table, condition) => qb.leftJoin(table, condition)

///|
/// INNER JOIN
#alias(inner_join)
pub extern "js" fn QueryBuilder::innerJoin(
  self : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder =
  #| (qb, table, condition) => qb.innerJoin(table, condition)

///|
/// Execute the query and return promise
extern "js" fn ffi_query_then(qb : QueryBuilder) -> @js.Promise[@core.Any] =
  #| (qb) => qb

///|
/// Execute the query
pub async fn QueryBuilder::execute(self : QueryBuilder) -> @core.Any {
  ffi_query_then(self).wait()
}

///|
/// Execute and get typed array result
pub async fn[T] QueryBuilder::execute_array(self : QueryBuilder) -> Array[T] {
  ffi_query_then(self).wait() |> @core.identity
}

// ============ SQL Operators ============

///|
/// Equal comparison (accepts any value)
pub extern "js" fn eq(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").eq(column, value)

///|
/// Not equal comparison (accepts any value)
pub extern "js" fn ne(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").ne(column, value)

///|
/// Greater than comparison (accepts any value)
pub extern "js" fn gt(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").gt(column, value)

///|
/// Greater than or equal comparison (accepts any value)
pub extern "js" fn gte(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").gte(column, value)

///|
/// Less than comparison (accepts any value)
pub extern "js" fn lt(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").lt(column, value)

///|
/// Less than or equal comparison (accepts any value)
pub extern "js" fn lte(column : Column, value : @core.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").lte(column, value)

///|
/// LIKE comparison
pub extern "js" fn like(column : Column, pattern : String) -> SQL =
  #| (column, pattern) => require("drizzle-orm").like(column, pattern)

///|
/// ILIKE comparison (case insensitive)
pub extern "js" fn ilike(column : Column, pattern : String) -> SQL =
  #| (column, pattern) => require("drizzle-orm").ilike(column, pattern)

///|
/// IS NULL check
#alias(is_null)
pub extern "js" fn isNull(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").isNull(column)

///|
/// IS NOT NULL check
#alias(is_not_null)
pub extern "js" fn isNotNull(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").isNotNull(column)

///|
/// IN comparison
pub extern "js" fn inArray(column : Column, values : Array[@core.Any]) -> SQL =
  #| (column, values) => require("drizzle-orm").inArray(column, values)

///|
/// NOT IN comparison
#alias(not_in_array)
pub extern "js" fn notInArray(
  column : Column,
  values : Array[@core.Any],
) -> SQL =
  #| (column, values) => require("drizzle-orm").notInArray(column, values)

///|
/// BETWEEN comparison (accepts any values)
pub extern "js" fn between(
  column : Column,
  min_val : @core.Any,
  max_val : @core.Any,
) -> SQL =
  #| (column, min, max) => require("drizzle-orm").between(column, min, max)

///|
/// AND logical operator
pub extern "js" fn and_(conditions : Array[SQL]) -> SQL =
  #| (conditions) => require("drizzle-orm").and(...conditions)

///|
/// OR logical operator
pub extern "js" fn or_(conditions : Array[SQL]) -> SQL =
  #| (conditions) => require("drizzle-orm").or(...conditions)

///|
/// NOT logical operator
pub extern "js" fn not_(condition : SQL) -> SQL =
  #| (condition) => require("drizzle-orm").not(condition)

// ============ Aggregation Functions ============

///|
extern "js" fn ffi_count(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").count(column)

///|
extern "js" fn ffi_count_all() -> SQL =
  #| () => require("drizzle-orm").count()

///|
/// COUNT aggregation
pub fn count(column? : Column) -> SQL {
  match column {
    Some(c) => ffi_count(c)
    None => ffi_count_all()
  }
}

///|
/// SUM aggregation
pub extern "js" fn sum(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").sum(column)

///|
/// AVG aggregation
pub extern "js" fn avg(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").avg(column)

///|
/// MAX aggregation
pub extern "js" fn max_(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").max(column)

///|
/// MIN aggregation
pub extern "js" fn min_(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").min(column)

// ============ Ordering ============

///|
/// Ascending order
pub extern "js" fn asc(column : Column) -> @core.Any =
  #| (column) => require("drizzle-orm").asc(column)

///|
/// Descending order
pub extern "js" fn desc(column : Column) -> @core.Any =
  #| (column) => require("drizzle-orm").desc(column)

// ============ Raw SQL ============

///|
/// Create raw SQL expression
pub extern "js" fn sql_expr(query : String) -> SQL =
  #| (query) => require("drizzle-orm").sql([query])
