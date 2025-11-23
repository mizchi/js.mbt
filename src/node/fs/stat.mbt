///|
#external
pub type Stat

///|
pub impl @js.JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call0("isFile") |> @js.unsafe_cast
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory") |> @js.unsafe_cast
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.get("size") |> @js.unsafe_cast
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  @js.unsafe_cast(mtime.get("getTime").call("call", [mtime]))
}
