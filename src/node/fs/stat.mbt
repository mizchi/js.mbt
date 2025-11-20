///|
#external
pub type Stat

///|
pub impl JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call0("isFile") |> unsafe_cast
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory") |> unsafe_cast
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.get("size") |> unsafe_cast
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  unsafe_cast(mtime.get("getTime").call("call", [mtime]))
}
