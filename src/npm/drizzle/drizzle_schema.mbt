///| drizzle-orm Schema features (indexes, constraints, relations)
/// https://orm.drizzle.team/docs/indexes-constraints

// ============ PostgreSQL Index Builder ============

///|
/// Create a PostgreSQL index
#alias(pg_index)
pub fn pgIndex(name : String) -> PgIndexBuilder {
  let fn_ = drizzle_pg_core()._get("index")
  @core.any(fn_)._invoke([@core.any(name)]).cast()
}

///|
/// Create a PostgreSQL unique index
#alias(pg_unique_index)
pub fn pgUniqueIndex(name : String) -> PgIndexBuilder {
  let fn_ = drizzle_pg_core()._get("uniqueIndex")
  @core.any(fn_)._invoke([@core.any(name)]).cast()
}

///|
/// PostgreSQL index builder
#external
pub type PgIndexBuilder

///|
pub fn PgIndexBuilder::as_any(self : PgIndexBuilder) -> @core.Any = "%identity"

///|
/// Specify columns for index
pub fn PgIndexBuilder::on(
  self : PgIndexBuilder,
  columns : Array[Column],
) -> PgIndexBuilder {
  @core.any(self)._call("on", columns.map(fn(c) { @core.any(c) })).cast()
}

///|
/// Add WHERE condition to index
pub fn PgIndexBuilder::filter(
  self : PgIndexBuilder,
  condition : SQL,
) -> PgIndexBuilder {
  @core.any(self)._call("where", [@core.any(condition)]).cast()
}

///|
/// Build index concurrently (PostgreSQL)
pub fn PgIndexBuilder::concurrently(self : PgIndexBuilder) -> PgIndexBuilder {
  @core.any(self)._call("concurrently", []).cast()
}

///|
extern "js" fn ffi_pg_index_using(
  builder : PgIndexBuilder,
  index_type : String,
  columns : @core.Any,
) -> PgIndexBuilder =
  #| (builder, index_type, columns) => builder.using(index_type, ...columns)

///|
/// Specify index method (btree, hash, gist, gin, etc.)
#alias(using_method)
pub fn PgIndexBuilder::usingMethod(
  self : PgIndexBuilder,
  index_method : String,
  columns : Array[@core.Any],
) -> PgIndexBuilder {
  ffi_pg_index_using(self, index_method, @core.any(columns))
}

// ============ Composite Primary Key ============

///|
/// Create a composite primary key (PostgreSQL)
#alias(pg_primary_key)
pub fn pgPrimaryKey(columns : Array[Column], name? : String) -> @core.Any {
  let fn_ = drizzle_pg_core()._get("primaryKey")
  let opts = @core.Object::new()
  opts._set("columns", @core.any(columns.map(fn(c) { c.as_any() })))
  if name is Some(n) {
    opts._set("name", n |> @core.any)
  }
  @core.any(fn_)._invoke([@core.any(opts)]).cast()
}

///|
/// Create a composite primary key (SQLite)
#alias(sqlite_primary_key)
pub fn sqlitePrimaryKey(columns : Array[Column], name? : String) -> @core.Any {
  let fn_ = drizzle_sqlite_core()._get("primaryKey")
  let opts = @core.Object::new()
  opts._set("columns", @core.any(columns.map(fn(c) { c.as_any() })))
  if name is Some(n) {
    opts._set("name", n |> @core.any)
  }
  @core.any(fn_)._invoke([@core.any(opts)]).cast()
}

// ============ Composite Unique Constraint ============

///|
/// Create a composite unique constraint (PostgreSQL)
#alias(pg_unique)
pub fn pgUnique(name? : String) -> UniqueBuilder {
  let fn_ = drizzle_pg_core()._get("unique")
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n)]).cast()
    None => @core.any(fn_)._invoke([]).cast()
  }
}

///|
/// Create a composite unique constraint (SQLite)
#alias(sqlite_unique)
pub fn sqliteUnique(name? : String) -> UniqueBuilder {
  let fn_ = drizzle_sqlite_core()._get("unique")
  match name {
    Some(n) => @core.any(fn_)._invoke([@core.any(n)]).cast()
    None => @core.any(fn_)._invoke([]).cast()
  }
}

///|
/// Unique constraint builder
#external
pub type UniqueBuilder

///|
pub fn UniqueBuilder::as_any(self : UniqueBuilder) -> @core.Any = "%identity"

///|
/// Specify columns for unique constraint
pub fn UniqueBuilder::on(
  self : UniqueBuilder,
  columns : Array[Column],
) -> UniqueBuilder {
  @core.any(self)._call("on", columns.map(fn(c) { @core.any(c) })).cast()
}

///|
/// NULLS NOT DISTINCT (PostgreSQL 15+)
#alias(nulls_not_distinct)
pub fn UniqueBuilder::nullsNotDistinct(self : UniqueBuilder) -> UniqueBuilder {
  @core.any(self)._call("nullsNotDistinct", []).cast()
}

// ============ Foreign Key ============

///|
/// Create a foreign key constraint (PostgreSQL)
#alias(pg_foreign_key)
pub fn pgForeignKey(
  columns : Array[Column],
  foreign_columns : Array[Column],
  name? : String,
) -> @core.Any {
  let fn_ = drizzle_pg_core()._get("foreignKey")
  let opts = @core.Object::new()
  opts._set("columns", @core.any(columns.map(fn(c) { c.as_any() })))
  opts._set(
    "foreignColumns",
    @core.any(foreign_columns.map(fn(c) { c.as_any() })),
  )
  if name is Some(n) {
    opts._set("name", n |> @core.any)
  }
  @core.any(fn_)._invoke([@core.any(opts)]).cast()
}

///|
/// Create a foreign key constraint (SQLite)
#alias(sqlite_foreign_key)
pub fn sqliteForeignKey(
  columns : Array[Column],
  foreign_columns : Array[Column],
  name? : String,
) -> @core.Any {
  let fn_ = drizzle_sqlite_core()._get("foreignKey")
  let opts = @core.Object::new()
  opts._set("columns", @core.any(columns.map(fn(c) { c.as_any() })))
  opts._set(
    "foreignColumns",
    @core.any(foreign_columns.map(fn(c) { c.as_any() })),
  )
  if name is Some(n) {
    opts._set("name", n |> @core.any)
  }
  @core.any(fn_)._invoke([@core.any(opts)]).cast()
}

// ============ Check Constraint ============

///|
/// Create a check constraint (PostgreSQL)
#alias(pg_check)
pub fn pgCheck(name : String, condition : SQL) -> @core.Any {
  let fn_ = drizzle_pg_core()._get("check")
  @core.any(fn_)._invoke([@core.any(name), @core.any(condition)]).cast()
}

///|
/// Create a check constraint (SQLite)
#alias(sqlite_check)
pub fn sqliteCheck(name : String, condition : SQL) -> @core.Any {
  let fn_ = drizzle_sqlite_core()._get("check")
  @core.any(fn_)._invoke([@core.any(name), @core.any(condition)]).cast()
}

// ============ Column Order Modifiers for Index ============

///|
/// Ascending order for column in index
pub fn Column::asc_(self : Column) -> @core.Any {
  self.call0("asc")
}

///|
/// Descending order for column in index
pub fn Column::desc_(self : Column) -> @core.Any {
  self.call0("desc")
}

///|
/// NULLS FIRST for column in index
#alias(nulls_first)
pub fn Column::nullsFirst(self : Column) -> @core.Any {
  self.call0("nullsFirst")
}

///|
/// NULLS LAST for column in index
#alias(nulls_last)
pub fn Column::nullsLast(self : Column) -> @core.Any {
  self.call0("nullsLast")
}

// ============ Foreign Key Actions ============

///|
/// ON DELETE action
pub(all) enum ForeignKeyAction {
  Cascade
  Restrict
  NoAction
  SetNull
  SetDefault
} derive(Eq, Show)

///|
pub fn ForeignKeyAction::to_string(self : ForeignKeyAction) -> String {
  match self {
    Cascade => "cascade"
    Restrict => "restrict"
    NoAction => "no action"
    SetNull => "set null"
    SetDefault => "set default"
  }
}

///|
/// Set ON DELETE action for column reference
#alias(on_delete)
pub fn Column::onDelete(self : Column, action : ForeignKeyAction) -> Column {
  self.call1("onDelete", @core.any(action.to_string())) |> @core.identity
}

///|
/// Set ON UPDATE action for column reference
#alias(on_update)
pub fn Column::onUpdate(self : Column, action : ForeignKeyAction) -> Column {
  self.call1("onUpdate", @core.any(action.to_string())) |> @core.identity
}
