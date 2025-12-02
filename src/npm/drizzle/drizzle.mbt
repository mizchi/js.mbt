///| drizzle-orm FFI bindings
/// https://orm.drizzle.team/

// ============ Row Builder ============
// Helper for building row data without exposing @nostd.Any

///|
/// Row builder for constructing insert/update data
pub struct Row {
  priv obj : @nostd.Any
}

///|
/// Create a new empty row
pub fn Row::new() -> Row {
  { obj: @nostd.Object::new() }
}

///|
/// Set a string value
pub fn Row::str(self : Row, key : String, value : String) -> Row {
  self.obj.set(key, value)
  self
}

///|
/// Set an integer value
pub fn Row::int(self : Row, key : String, value : Int) -> Row {
  self.obj.set(key, value)
  self
}

///|
/// Set a double value
pub fn Row::double(self : Row, key : String, value : Double) -> Row {
  self.obj.set(key, value)
  self
}

///|
/// Set a boolean value
pub fn Row::bool(self : Row, key : String, value : Bool) -> Row {
  self.obj.set(key, value)
  self
}

///|
/// Set a null value
pub fn Row::null(self : Row, key : String) -> Row {
  self.obj.set(key, @nostd.null())
  self
}

///|
/// Set any JsImpl value
pub fn Row::set_(self : Row, key : String, value : @nostd.Any) -> Row {
  @nostd.any(self.obj)[key] = value
  self
}

///|
/// Build the row data (returns the underlying JS object)
pub fn Row::build(self : Row) -> @nostd.Any {
  self.obj
}

///|
pub fn Row::as_any(self : Row) -> @nostd.Any {
  self.obj
}

// ============ Row Array Helper ============

///|
/// Create an array of rows for batch insert
pub fn rows(items : Array[Row]) -> @nostd.Any {
  @js.from_array(items.map(fn(r) { r.obj }))
}

// Internal helpers for other files in this package

///|
fn drizzle_pg_core() -> @nostd.Any {
  @node.require("drizzle-orm/pg-core")
}

///|
fn drizzle_orm() -> @nostd.Any {
  @node.require("drizzle-orm")
}

///|
/// Drizzle database instance
#external
pub type DrizzleDB

///|
pub fn DrizzleDB::as_any(self : DrizzleDB) -> @nostd.Any = "%identity"

///|
/// Query builder
#external
pub type QueryBuilder

///|
pub fn QueryBuilder::as_any(self : QueryBuilder) -> @nostd.Any = "%identity"

// Internal helper for method calls

///|
fn QueryBuilder::call0(self : QueryBuilder, name : String) -> @nostd.Any {
  @nostd.any(self)._call(name, []).cast()
}

///|
fn QueryBuilder::call1(
  self : QueryBuilder,
  name : String,
  arg : @nostd.Any,
) -> @nostd.Any {
  @nostd.any(self)._call(name, [arg]).cast()
}

///|
/// Table definition
#external
pub type Table

///|
pub fn Table::as_any(self : Table) -> @nostd.Any = "%identity"

///|
/// Get a column from a table by name
pub fn Table::get(self : Table, name : String) -> @nostd.Any {
  self.as_any()._get(name)
}

///|
/// Column definition
#external
pub type Column

///|
pub fn Column::as_any(self : Column) -> @nostd.Any = "%identity"

// Internal helper for method calls

///|
fn Column::call0(self : Column, name : String) -> @nostd.Any {
  @nostd.any(self)._call(name, []).cast()
}

///|
fn Column::call1(self : Column, name : String, arg : @nostd.Any) -> @nostd.Any {
  @nostd.any(self)._call(name, [arg]).cast()
}

///|
/// SQL expression
#external
pub type SQL

///|
pub fn SQL::as_any(self : SQL) -> @nostd.Any = "%identity"

// ============ Database Creation ============

///|
extern "js" fn ffi_drizzle(connection_string : String) -> DrizzleDB =
  #| (cs) => require("drizzle-orm/node-postgres").drizzle(cs)

///|
/// Create a Drizzle instance with connection string
pub fn drizzle(connection_string : String) -> DrizzleDB {
  ffi_drizzle(connection_string)
}

///|
extern "js" fn ffi_drizzle_with_pool(pool : @nostd.Any) -> DrizzleDB =
  #| (pool) => require("drizzle-orm/node-postgres").drizzle(pool)

///|
/// Create a Drizzle instance with pg Pool
#alias(drizzle_with_pool)
pub fn drizzleWithPool(pool : @nostd.Any) -> DrizzleDB {
  ffi_drizzle_with_pool(pool)
}

///|
/// Create a Drizzle instance with config object
#alias(drizzle_with_config)
pub fn drizzleWithConfig(config : @nostd.Any) -> DrizzleDB {
  ffi_drizzle_with_pool(config)
}

// ============ Cloudflare D1 ============

///|
extern "js" fn ffi_drizzle_d1(d1_database : @nostd.Any) -> DrizzleDB =
  #| (d1) => require("drizzle-orm/d1").drizzle(d1)

///|
/// Create a Drizzle instance with Cloudflare D1 database binding
/// Usage: drizzleD1(env.DB) where env.DB is D1Database from Cloudflare Workers
#alias(drizzle_d1)
pub fn drizzleD1(d1_database : @nostd.Any) -> DrizzleDB {
  ffi_drizzle_d1(d1_database)
}

///|
extern "js" fn ffi_drizzle_d1_with_schema(
  d1_database : @nostd.Any,
  schema : @nostd.Any,
) -> DrizzleDB =
  #| (d1, schema) => require("drizzle-orm/d1").drizzle(d1, { schema })

///|
/// Create a Drizzle instance with D1 and schema for relational queries
#alias(drizzle_d1_with_schema)
pub fn drizzleD1WithSchema(
  d1_database : @nostd.Any,
  schema : @nostd.Any,
) -> DrizzleDB {
  ffi_drizzle_d1_with_schema(d1_database, schema)
}

// ============ Schema Definition ============

///|
extern "js" fn ffi_pg_table(name : String, columns : @nostd.Any) -> Table =
  #| (name, columns) => require("drizzle-orm/pg-core").pgTable(name, columns)

///|
/// Create a PostgreSQL table
#alias(pg_table)
pub fn pgTable(name : String, columns : @nostd.Any) -> Table {
  ffi_pg_table(name, columns)
}

///|
/// Create a PostgreSQL table from a Map of column definitions
#alias(pg_table_from_map)
pub fn pgTableFromMap(name : String, columns : Map[String, Column]) -> Table {
  let obj = @nostd.Object::new()
  columns.each(fn(key, col) { obj.set(key, col.as_any()) })
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
extern "js" fn ffi_primary_key(col : Column) -> Column =
  #| (col) => col.primaryKey()

///|
/// Mark column as primary key
#alias(primary_key)
pub fn Column::primaryKey(self : Column) -> Column {
  ffi_primary_key(self)
}

///|
extern "js" fn ffi_not_null(col : Column) -> Column =
  #| (col) => col.notNull()

///|
/// Mark column as not null
#alias(not_null)
pub fn Column::notNull(self : Column) -> Column {
  ffi_not_null(self)
}

///|
extern "js" fn ffi_unique(col : Column) -> Column =
  #| (col) => col.unique()

///|
/// Mark column as unique
pub fn Column::unique(self : Column) -> Column {
  ffi_unique(self)
}

///|
extern "js" fn ffi_default_value(col : Column, value : @nostd.Any) -> Column =
  #| (col, value) => col.default(value)

///|
/// Set default value (accepts any value)
#alias(default_value)
pub fn Column::defaultValue(self : Column, value : @nostd.Any) -> Column {
  ffi_default_value(self, @nostd.identity(value))
}

///|
extern "js" fn ffi_default_now(col : Column) -> Column =
  #| (col) => col.defaultNow()

///|
/// Set default to current timestamp
#alias(default_now)
pub fn Column::defaultNow(self : Column) -> Column {
  ffi_default_now(self)
}

///|
extern "js" fn ffi_generated_always_as_identity(col : Column) -> Column =
  #| (col) => col.generatedAlwaysAsIdentity()

///|
/// Generated always as identity
#alias(generated_always_as_identity)
pub fn Column::generatedAlwaysAsIdentity(self : Column) -> Column {
  ffi_generated_always_as_identity(self)
}

///|
extern "js" fn ffi_references(col : Column, ref_fn : () -> Column) -> Column =
  #| (col, refFn) => col.references(refFn)

///|
/// Add references (foreign key)
pub fn Column::references(self : Column, ref_fn : () -> Column) -> Column {
  ffi_references(self, ref_fn)
}

// ============ Query Operations ============

///|
extern "js" fn ffi_select(db : DrizzleDB) -> QueryBuilder =
  #| (db) => db.select()

///|
extern "js" fn ffi_select_fields(
  db : DrizzleDB,
  fields : @nostd.Any,
) -> QueryBuilder =
  #| (db, fields) => db.select(fields)

///|
/// Start a SELECT query
pub fn DrizzleDB::select(
  self : DrizzleDB,
  fields? : @nostd.Any,
) -> QueryBuilder {
  match fields {
    Some(f) => ffi_select_fields(self, f)
    None => ffi_select(self)
  }
}

///|
extern "js" fn ffi_select_distinct(db : DrizzleDB) -> QueryBuilder =
  #| (db) => db.selectDistinct()

///|
/// Start a SELECT DISTINCT query
#alias(select_distinct)
pub fn DrizzleDB::selectDistinct(self : DrizzleDB) -> QueryBuilder {
  ffi_select_distinct(self)
}

///|
extern "js" fn ffi_insert(db : DrizzleDB, table : Table) -> QueryBuilder =
  #| (db, table) => db.insert(table)

///|
/// Start an INSERT query
pub fn DrizzleDB::insert(self : DrizzleDB, table : Table) -> QueryBuilder {
  ffi_insert(self, table)
}

///|
extern "js" fn ffi_update(db : DrizzleDB, table : Table) -> QueryBuilder =
  #| (db, table) => db.update(table)

///|
/// Start an UPDATE query
pub fn DrizzleDB::update(self : DrizzleDB, table : Table) -> QueryBuilder {
  ffi_update(self, table)
}

///|
extern "js" fn ffi_delete(db : DrizzleDB, table : Table) -> QueryBuilder =
  #| (db, table) => db.delete(table)

///|
/// Start a DELETE query
pub fn DrizzleDB::delete(self : DrizzleDB, table : Table) -> QueryBuilder {
  ffi_delete(self, table)
}

// ============ Query Builder Methods ============

///|
extern "js" fn ffi_from(qb : QueryBuilder, table : Table) -> QueryBuilder =
  #| (qb, table) => qb.from(table)

///|
/// FROM clause
pub fn QueryBuilder::from(self : QueryBuilder, table : Table) -> QueryBuilder {
  ffi_from(self, table)
}

///|
extern "js" fn ffi_where(qb : QueryBuilder, condition : SQL) -> QueryBuilder =
  #| (qb, condition) => qb.where(condition)

///|
/// WHERE clause
pub fn QueryBuilder::filter(
  self : QueryBuilder,
  condition : SQL,
) -> QueryBuilder {
  ffi_where(self, condition)
}

///|
extern "js" fn ffi_values(qb : QueryBuilder, data : @nostd.Any) -> QueryBuilder =
  #| (qb, data) => qb.values(data)

///|
/// VALUES for INSERT (accepts any value)
pub fn QueryBuilder::values(
  self : QueryBuilder,
  data : @nostd.Any,
) -> QueryBuilder {
  ffi_values(self, @nostd.identity(data))
}

///|
extern "js" fn ffi_set(qb : QueryBuilder, data : @nostd.Any) -> QueryBuilder =
  #| (qb, data) => qb.set(data)

///|
/// SET for UPDATE (accepts any value)
pub fn QueryBuilder::set(
  self : QueryBuilder,
  data : @nostd.Any,
) -> QueryBuilder {
  ffi_set(self, @nostd.identity(data))
}

///|
extern "js" fn ffi_order_by(
  qb : QueryBuilder,
  columns : Array[@nostd.Any],
) -> QueryBuilder =
  #| (qb, columns) => qb.orderBy(...columns)

///|
/// ORDER BY clause
#alias(order_by)
pub fn QueryBuilder::orderBy(
  self : QueryBuilder,
  columns : Array[@nostd.Any],
) -> QueryBuilder {
  ffi_order_by(self, columns)
}

///|
extern "js" fn ffi_limit(qb : QueryBuilder, count : Int) -> QueryBuilder =
  #| (qb, count) => qb.limit(count)

///|
/// LIMIT clause
pub fn QueryBuilder::limit(self : QueryBuilder, count : Int) -> QueryBuilder {
  ffi_limit(self, count)
}

///|
extern "js" fn ffi_offset(qb : QueryBuilder, count : Int) -> QueryBuilder =
  #| (qb, count) => qb.offset(count)

///|
/// OFFSET clause
pub fn QueryBuilder::offset(self : QueryBuilder, count : Int) -> QueryBuilder {
  ffi_offset(self, count)
}

///|
extern "js" fn ffi_returning(qb : QueryBuilder) -> QueryBuilder =
  #| (qb) => qb.returning()

///|
/// RETURNING clause
pub fn QueryBuilder::returning(self : QueryBuilder) -> QueryBuilder {
  ffi_returning(self)
}

///|
extern "js" fn ffi_left_join(
  qb : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder =
  #| (qb, table, condition) => qb.leftJoin(table, condition)

///|
/// LEFT JOIN
#alias(left_join)
pub fn QueryBuilder::leftJoin(
  self : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder {
  ffi_left_join(self, table, condition)
}

///|
extern "js" fn ffi_inner_join(
  qb : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder =
  #| (qb, table, condition) => qb.innerJoin(table, condition)

///|
/// INNER JOIN
#alias(inner_join)
pub fn QueryBuilder::innerJoin(
  self : QueryBuilder,
  table : Table,
  condition : SQL,
) -> QueryBuilder {
  ffi_inner_join(self, table, condition)
}

///|
/// Execute the query and return promise
extern "js" fn ffi_query_then(qb : QueryBuilder) -> @js.Promise[@nostd.Any] =
  #| (qb) => qb

///|
/// Execute the query
pub async fn QueryBuilder::execute(self : QueryBuilder) -> @nostd.Any {
  ffi_query_then(self).wait()
}

///|
/// Execute and get typed array result
pub async fn[T] QueryBuilder::execute_array(self : QueryBuilder) -> Array[T] {
  ffi_query_then(self).wait() |> @nostd.identity
}

// ============ SQL Operators ============

///|
extern "js" fn ffi_eq(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").eq(column, value)

///|
/// Equal comparison (accepts any value)
pub fn eq(column : Column, value : @nostd.Any) -> SQL {
  ffi_eq(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_ne(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").ne(column, value)

///|
/// Not equal comparison (accepts any value)
pub fn ne(column : Column, value : @nostd.Any) -> SQL {
  ffi_ne(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_gt(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").gt(column, value)

///|
/// Greater than comparison (accepts any value)
pub fn gt(column : Column, value : @nostd.Any) -> SQL {
  ffi_gt(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_gte(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").gte(column, value)

///|
/// Greater than or equal comparison (accepts any value)
pub fn gte(column : Column, value : @nostd.Any) -> SQL {
  ffi_gte(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_lt(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").lt(column, value)

///|
/// Less than comparison (accepts any value)
pub fn lt(column : Column, value : @nostd.Any) -> SQL {
  ffi_lt(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_lte(column : Column, value : @nostd.Any) -> SQL =
  #| (column, value) => require("drizzle-orm").lte(column, value)

///|
/// Less than or equal comparison (accepts any value)
pub fn lte(column : Column, value : @nostd.Any) -> SQL {
  ffi_lte(column, @nostd.identity(value))
}

///|
extern "js" fn ffi_like(column : Column, pattern : String) -> SQL =
  #| (column, pattern) => require("drizzle-orm").like(column, pattern)

///|
/// LIKE comparison
pub fn like(column : Column, pattern : String) -> SQL {
  ffi_like(column, pattern)
}

///|
extern "js" fn ffi_ilike(column : Column, pattern : String) -> SQL =
  #| (column, pattern) => require("drizzle-orm").ilike(column, pattern)

///|
/// ILIKE comparison (case insensitive)
pub fn ilike(column : Column, pattern : String) -> SQL {
  ffi_ilike(column, pattern)
}

///|
extern "js" fn ffi_is_null(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").isNull(column)

///|
/// IS NULL check
#alias(is_null)
pub fn isNull(column : Column) -> SQL {
  ffi_is_null(column)
}

///|
extern "js" fn ffi_is_not_null(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").isNotNull(column)

///|
/// IS NOT NULL check
#alias(is_not_null)
pub fn isNotNull(column : Column) -> SQL {
  ffi_is_not_null(column)
}

///|
extern "js" fn ffi_in_array(column : Column, values : Array[@nostd.Any]) -> SQL =
  #| (column, values) => require("drizzle-orm").inArray(column, values)

///|
/// IN comparison
pub fn inArray(column : Column, values : Array[@nostd.Any]) -> SQL {
  ffi_in_array(column, values)
}

///|
extern "js" fn ffi_not_in_array(
  column : Column,
  values : Array[@nostd.Any],
) -> SQL =
  #| (column, values) => require("drizzle-orm").notInArray(column, values)

///|
/// NOT IN comparison
#alias(not_in_array)
pub fn notInArray(column : Column, values : Array[@nostd.Any]) -> SQL {
  ffi_not_in_array(column, values)
}

///|
extern "js" fn ffi_between(
  column : Column,
  min_val : @nostd.Any,
  max_val : @nostd.Any,
) -> SQL =
  #| (column, min, max) => require("drizzle-orm").between(column, min, max)

///|
/// BETWEEN comparison (accepts any values)
pub fn between(
  column : Column,
  min_val : @nostd.Any,
  max_val : @nostd.Any,
) -> SQL {
  ffi_between(column, @nostd.identity(min_val), @nostd.identity(max_val))
}

///|
extern "js" fn ffi_and(conditions : Array[SQL]) -> SQL =
  #| (conditions) => require("drizzle-orm").and(...conditions)

///|
/// AND logical operator
pub fn and_(conditions : Array[SQL]) -> SQL {
  ffi_and(conditions)
}

///|
extern "js" fn ffi_or(conditions : Array[SQL]) -> SQL =
  #| (conditions) => require("drizzle-orm").or(...conditions)

///|
/// OR logical operator
pub fn or_(conditions : Array[SQL]) -> SQL {
  ffi_or(conditions)
}

///|
extern "js" fn ffi_not(condition : SQL) -> SQL =
  #| (condition) => require("drizzle-orm").not(condition)

///|
/// NOT logical operator
pub fn not_(condition : SQL) -> SQL {
  ffi_not(condition)
}

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
extern "js" fn ffi_sum(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").sum(column)

///|
/// SUM aggregation
pub fn sum(column : Column) -> SQL {
  ffi_sum(column)
}

///|
extern "js" fn ffi_avg(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").avg(column)

///|
/// AVG aggregation
pub fn avg(column : Column) -> SQL {
  ffi_avg(column)
}

///|
extern "js" fn ffi_max(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").max(column)

///|
/// MAX aggregation
pub fn max_(column : Column) -> SQL {
  ffi_max(column)
}

///|
extern "js" fn ffi_min(column : Column) -> SQL =
  #| (column) => require("drizzle-orm").min(column)

///|
/// MIN aggregation
pub fn min_(column : Column) -> SQL {
  ffi_min(column)
}

// ============ Ordering ============

///|
extern "js" fn ffi_asc(column : Column) -> @nostd.Any =
  #| (column) => require("drizzle-orm").asc(column)

///|
/// Ascending order
pub fn asc(column : Column) -> @nostd.Any {
  ffi_asc(column)
}

///|
extern "js" fn ffi_desc(column : Column) -> @nostd.Any =
  #| (column) => require("drizzle-orm").desc(column)

///|
/// Descending order
pub fn desc(column : Column) -> @nostd.Any {
  ffi_desc(column)
}

// ============ Raw SQL ============

///|
extern "js" fn ffi_sql_expr(query : String) -> SQL =
  #| (query) => require("drizzle-orm").sql([query])

///|
/// Create raw SQL expression
pub fn sql_expr(query : String) -> SQL {
  ffi_sql_expr(query)
}
