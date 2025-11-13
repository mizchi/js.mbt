// WIP

///|
#external
pub type D1Database

///|
pub impl Js for D1Database with to_js(self) {
  self |> js
}

///|
pub fn D1Database::prepare(self : Self, query : String) -> D1PreparedStatement {
  self.to_js().call_method("prepare", [query]).cast()
}

///|
pub type D1PreparedStatement

///|
pub impl Js for D1PreparedStatement with to_js(self) {
  self |> js
}

///|
pub fn D1PreparedStatement::bind(self : Self, params : Array[Val]) -> Self {
  let stmt_js = self.to_js().call_method("bind", params.map(_.to_js()))
  stmt_js.cast()
}

///|
pub fn D1PreparedStatement::run(self : Self) -> Promise[D1ResultSet] {
  let stmt_js = self.to_js().call_method("run", [])
  stmt_js.cast()
}

///|
pub(all) struct D1ResultSet {
  results : Array[Val]
}
