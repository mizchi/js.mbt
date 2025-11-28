///|
/// Realworld Example - Client
/// React components for the TODO app (designed for Vite bundling)

///|
/// API client for the TODO app
#external
pub type ApiClient

///|
pub impl @js.JsImpl for ApiClient

///|
/// Create a new API client
pub fn create_api_client(base_url : String) -> ApiClient {
  let obj = @js.Object::new()
  obj.set("baseUrl", base_url)
  obj.to_any().cast()
}

///|
/// Fetch todos from API
pub async fn ApiClient::fetch_todos(self : ApiClient) -> Array[@js.Any] {
  let base_url : String = self.get("baseUrl").cast()
  ffi_fetch_json(base_url + "/api/todos").wait() |> @js.identity
}

///|
/// Add a new todo
pub async fn ApiClient::add_todo(self : ApiClient, title : String) -> Unit {
  let base_url : String = self.get("baseUrl").cast()
  ffi_post_json(base_url + "/api/todos", title).wait()
}

///|
/// Delete a todo
pub async fn ApiClient::delete_todo(self : ApiClient, id : Int) -> Unit {
  let base_url : String = self.get("baseUrl").cast()
  ffi_delete(base_url + "/api/todos/" + id.to_string()).wait()
}

///|
extern "js" fn ffi_fetch_json(url : String) -> @js.Promise[@js.Any] =
  #|(url) => fetch(url, { credentials: 'include' }).then(r => r.json())

///|
extern "js" fn ffi_post_json(url : String, title : String) -> @js.Promise[Unit] =
  #|(url, title) => fetch(url, {
  #|  method: 'POST',
  #|  credentials: 'include',
  #|  headers: { 'Content-Type': 'application/json' },
  #|  body: JSON.stringify({ title })
  #|})

///|
extern "js" fn ffi_delete(url : String) -> @js.Promise[Unit] =
  #|(url) => fetch(url, { method: 'DELETE', credentials: 'include' })

///|
/// Create the auth client for client-side auth
pub fn create_auth_client(base_url : String) -> @better_auth.AuthClient {
  @better_auth.createAuthClient(base_url~)
}
