///|
/// Realworld Example - Main Entry Point
/// A TODO app with user authentication

///|
fn main {
  let db = @server.init_db()
  let auth = @server.create_auth(db)
  let app = @server.create_app(db, auth)
  let port = 3000
  println("Starting Realworld TODO app on port " + port.to_string() + "...")
  @server.serve(app, port)
}
