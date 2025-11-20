///|
/// Deno Permissions API
/// https://docs.deno.com/api/deno/~/Deno.permissions

///|
#external
pub type PermissionStatus

///|
pub impl @js.JsImpl for PermissionStatus

///|
/// Get permission state ("granted", "denied", "prompt")
pub fn PermissionStatus::state(self : PermissionStatus) -> String {
  self.get("state") |> @js.unsafe_cast
}

///|
/// Check if permission is granted
pub fn PermissionStatus::is_granted(self : PermissionStatus) -> Bool {
  self.state() == "granted"
}

///|
/// Get permissions object
pub fn Deno::permissions(self : Deno) -> Js {
  self.get("permissions")
}

///|
/// Query permission status
pub fn Deno::permissions_query(
  self : Deno,
  name : String,
  path? : String,
) -> Promise[PermissionStatus] {
  let perms = self.permissions()
  let desc = @js.Object::new()
  desc.set("name", name)
  if path is Some(p) {
    desc.set("path", p)
  }
  perms.call("query", [desc]) |> @js.unsafe_cast
}

///|
/// Request permission
pub fn Deno::permissions_request(
  self : Deno,
  name : String,
  path? : String,
) -> Promise[PermissionStatus] {
  let perms = self.permissions()
  let desc = @js.Object::new()
  desc.set("name", name)
  if path is Some(p) {
    desc.set("path", p)
  }
  perms.call("request", [desc]) |> @js.unsafe_cast
}

///|
/// Revoke permission
pub fn Deno::permissions_revoke(
  self : Deno,
  name : String,
  path? : String,
) -> Promise[PermissionStatus] {
  let perms = self.permissions()
  let desc = @js.Object::new()
  desc.set("name", name)
  if path is Some(p) {
    desc.set("path", p)
  }
  perms.call("revoke", [desc]) |> @js.unsafe_cast
}
