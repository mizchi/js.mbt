///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @iterator {type Generator}

///|
using @arraybuffer {type Uint8Array}

///|
#external
pub type DatabaseSync

///|
pub impl Js for DatabaseSync with to_js(self) {
  self |> js
}

///|
pub fn DatabaseSync::new(
  path : String,
  open? : Bool,
  readOnly? : Bool,
  enableForeignKeyConstraints? : Bool,
  allowExtension? : Bool,
  timeout? : Int,
  readBigInts? : Bool,
  returnArrays? : Bool,
  allowBareNamedParameters? : Bool,
  allowUnknownNamedParameters? : Bool,
  defensive? : Bool,
) -> DatabaseSync {
  let opts = @js.new_empty_object()
  if open is Some(v) {
    opts["open"] = v
  }
  if readOnly is Some(v) {
    opts["readOnly"] = v
  }
  if allowExtension is Some(v) {
    opts["allowExtension"] = v
  }
  if enableForeignKeyConstraints is Some(v) {
    opts["enableForeignKeyConstraints"] = v
  }
  if timeout is Some(v) {
    opts["timeout"] = v
  }
  if readBigInts is Some(v) {
    opts["readBigInts"] = v
  }
  if returnArrays is Some(v) {
    opts["returnArrays"] = v
  }
  if allowBareNamedParameters is Some(v) {
    opts["allowBareNamedParameters"] = v
  }
  if allowUnknownNamedParameters is Some(v) {
    opts["allowUnknownNamedParameters"] = v
  }
  if defensive is Some(v) {
    opts["defensive"] = v
  }
  let v = @node.require("node:sqlite").get("DatabaseSync")
    |> @js.new_([path, opts])
  v.cast()
}

///|
pub fn[T, U] DatabaseSync::aggregate(
  self : Self,
  name : String,
  deterministic? : Bool,
  directOnly? : Bool,
  useBigIntArguments? : Bool,
  varargs? : Bool,
  start? : U,
  step? : (T, U) -> T,
  // TODO
  // inverse? : (T, U) -> T,
  // result? : (T) -> Val,
) -> Bool {
  let opts = @js.new_empty_object()
  if deterministic is Some(v) {
    opts["deterministic"] = v
  }
  if directOnly is Some(v) {
    opts["directOnly"] = v
  }
  if useBigIntArguments is Some(v) {
    opts["useBigIntArguments"] = v
  }
  if varargs is Some(v) {
    opts["varargs"] = v
  }
  if start is Some(v) {
    opts["start"] = v |> js
  }
  if step is Some(v) {
    opts["step"] = v |> js
  }
  self.to_js().call_method("aggregate", [name, opts]).cast()
}

///|
#alias(is_open)
pub fn DatabaseSync::isOpen(self : Self) -> Bool {
  self.to_js().get("isOpen").cast()
}

///|
#alias(is_transaction)
pub fn DatabaseSync::isTransaction(self : Self) -> Bool {
  self.to_js().get("isTransaction").cast()
}

///|
pub fn DatabaseSync::open(self : Self) -> Bool {
  self.to_js().call_method("open", []).cast()
}

///|
pub fn DatabaseSync::close(self : Self) -> Bool {
  self.to_js().call_method("close", []).cast()
}

///|
#alias(create_tag_store)
pub fn DatabaseSync::createTagStore(self : Self, max_size? : Int) -> Bool {
  self.to_js().call_method("createTagStore", [max_size]).cast()
}

///|
#alias(create_session)
pub fn DatabaseSync::createSession(
  self : Self,
  table? : String,
  db? : String,
) -> Session {
  let v = @js.new_empty_object()
  if table is Some(t) {
    v["table"] = t
  }
  if db is Some(d) {
    v["db"] = d
  }
  self.to_js().call_method("createSession", [v]).cast()
}

///|
pub fn DatabaseSync::exec(self : Self, query : String) -> Unit {
  self.to_js().call_method("exec", [query]).cast()
}

///|
pub fn DatabaseSync::prepare(self : Self, query : String) -> StatementSync {
  self.to_js().call_method("prepare", [query]).cast()
}

///|
#alias(apply_changeset)
pub fn DatabaseSync::applyChangeset(
  self : Self,
  changeset : Uint8Array,
  filter? : (Val) -> Bool,
  onConflict? : (Val, Val) -> Bool,
) -> Bool {
  let opts = @js.from_builtin_map({
    "filter": filter |> js,
    "onConflict": onConflict |> js,
  })
  self.to_js().call_method("applyChangeset", [changeset, opts]).cast()
}

///|
#external
pub type StatementSync

///|
pub impl Js for StatementSync with to_js(self) {
  self |> unsafe_cast
}

///|
pub fn StatementSync::get(self : Self) -> Val {
  self.to_js().call_method("get", []).cast()
}

///|
pub fn StatementSync::columns(self : Self) -> Array[String] {
  self.to_js().call_method("columns", []).cast()
}

///|
pub fn StatementSync::run(self : Self, args : Array[Val]) -> Unit {
  self.to_js().call_method("run", args.map(_.to_js())).cast()
}

///|
pub fn StatementSync::all(self : Self) -> Val {
  self.to_js().call_method("all", []).cast()
}

///|
pub fn StatementSync::iterate(self : Self) -> Generator[Val] {
  self.to_js().call_method("iterate", []).cast()
}

///|
#external
pub type Session

///|
pub impl Js for Session with to_js(self) {
  self |> js
}

///|
pub fn Session::changeset(self : Self) -> Uint8Array {
  self.to_js().call_method("changeset", []).cast()
}

///|
pub fn Session::patchset(self : Self) -> Uint8Array {
  self.to_js().call_method("patchset", []).cast()
}

///|
pub fn Session::close(self : Self) -> Unit {
  self.to_js().call_method("close", []).cast()
}

///|
pub(all) struct BackupProgress {
  remainingPages : Int
  totalPages : Int
}

///|
pub fn backup(
  source_db : DatabaseSync,
  db_path : String,
  rate? : Int,
  source? : String,
  target? : String,
  progress? : (BackupProgress) -> Unit,
) -> Unit {
  let opts = @js.new_empty_object()
  if rate is Some(v) {
    opts["rate"] = v
  }
  if source is Some(v) {
    opts["source"] = v
  }
  if target is Some(v) {
    opts["target"] = v
  }
  if progress is Some(f) {
    opts["progress"] = f |> js
  }
  let backup : Val = @node.require("node:sqlite").get("backup")
  backup.call([source_db.to_js(), db_path, opts]) |> ignore
}
