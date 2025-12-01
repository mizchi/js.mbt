///|
#external
pub type Stat

///|
pub fn Stat::as_any(self : Stat) -> @nostd.Any = "%identity"

///|
pub fn Stat::isFile(self : Self) -> Bool {
  self.as_any()._call("isFile", []).cast()
}

///|
pub fn Stat::isDirectory(self : Self) -> Bool {
  self.as_any()._call("isDirectory", []).cast()
}

///|
pub fn Stat::size(self : Self) -> Int {
  self.as_any()["size"].cast()
}

///|
pub fn Stat::mtime_ms(self : Self) -> Float {
  let mtime = self.as_any()["mtime"]
  mtime["getTime"]._call("call", [mtime]).cast()
}
