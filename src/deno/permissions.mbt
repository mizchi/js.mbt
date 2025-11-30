///|
/// Deno Permissions API
/// https://docs.deno.com/api/deno/~/Deno.permissions

///|
#external
pub type PermissionStatus

///|
pub fn PermissionStatus::as_any(self : PermissionStatus) -> @nostd.Any = "%identity"

///|
pub impl @js.JsImpl for PermissionStatus

///|
/// Get permission state ("granted", "denied", "prompt")
pub fn PermissionStatus::state(self : PermissionStatus) -> String {
  self.as_any()["state"].cast()
}

///|
/// Check if permission is granted
pub fn PermissionStatus::is_granted(self : PermissionStatus) -> Bool {
  self.state() == "granted"
}

///|
/// Get permissions object
pub fn Deno::permissions(self : Deno) -> @js.Any {
  self.get("permissions")
}

///|
/// Query permission status
pub async fn Deno::permissions_query(
  self : Deno,
  name : String,
  path? : String,
) -> PermissionStatus {
  let perms = self.permissions()
  let promise : @js.Promise[PermissionStatus] = perms
    .call("query", [
      @js.from_option_map({
        "name": Some(@js.any(name)),
        "path": path.map(fn(x) { @js.any(x) }),
      }),
    ])
    .cast()
  promise.wait()
}

///|
/// Request permission
pub async fn Deno::permissions_request(
  self : Deno,
  name : String,
  path? : String,
) -> PermissionStatus {
  let perms = self.permissions()
  let promise : @js.Promise[PermissionStatus] = perms
    .call("request", [
      @js.from_option_map({
        "name": Some(@js.any(name)),
        "path": path.map(fn(x) { @js.any(x) }),
      }),
    ])
    .cast()
  promise.wait()
}

///|
/// Revoke permission
pub async fn Deno::permissions_revoke(
  self : Deno,
  name : String,
  path? : String,
) -> PermissionStatus {
  let perms = self.permissions()
  let promise : @js.Promise[PermissionStatus] = perms
    .call("revoke", [
      @js.from_option_map({
        "name": Some(@js.any(name)),
        "path": path.map(fn(x) { @js.any(x) }),
      }),
    ])
    .cast()
  promise.wait()
}
