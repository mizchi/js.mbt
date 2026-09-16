///|
/// Deno Permissions API
/// https://docs.deno.com/api/deno/~/Deno.permissions

///|
#external
pub type PermissionStatus

///|
pub fn PermissionStatus::as_any(self : PermissionStatus) -> @core.Any = "%identity"

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
pub fn Deno::permissions(self : Deno) -> @core.Any {
  self.as_any()["permissions"].cast()
}

///|
/// Query permission status
pub async fn Deno::permissions_query(
  self : Deno,
  name : String,
  path? : String,
) -> PermissionStatus {
  let perms : @core.Any = self.permissions().cast()
  let entries : Array[(String, @core.Any)] = []
  entries.push(("name", @core.any(name)))
  if path is Some(v) {
    entries.push(("path", @core.any(v)))
  }
  let opts = @core.from_entries(entries).cast()
  let promise : @core.Promise[PermissionStatus] = perms
    ._call("query", [opts])
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
  let perms : @core.Any = self.permissions().cast()
  let entries : Array[(String, @core.Any)] = []
  entries.push(("name", @core.any(name)))
  if path is Some(v) {
    entries.push(("path", @core.any(v)))
  }
  let opts = @core.from_entries(entries).cast()
  let promise : @core.Promise[PermissionStatus] = perms
    ._call("request", [opts])
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
  let perms : @core.Any = self.permissions().cast()
  let entries : Array[(String, @core.Any)] = []
  entries.push(("name", @core.any(name)))
  if path is Some(v) {
    entries.push(("path", @core.any(v)))
  }
  let opts = @core.from_entries(entries).cast()
  let promise : @core.Promise[PermissionStatus] = perms
    ._call("revoke", [opts])
    .cast()
  promise.wait()
}
