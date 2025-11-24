///|
#external
pub type Stat

///|
pub impl @js.JsImpl for Stat

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.call0("isFile").cast()
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.call0("isDirectory").cast()
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.get("size").cast()
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.get("mtime")
  @js.identity(mtime.get("getTime").call("call", [mtime]))
}
