///|
#external
pub type Stat

///|
pub impl JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call("isFile", []) |> unsafe_cast
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call("isFile", []) |> unsafe_cast
}

///|
pub fn Stat::size(self : Self) -> Int {
  unsafe_cast(self.get("size"))
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  unsafe_cast(mtime.get("getTime").call("call", [mtime]))
}
