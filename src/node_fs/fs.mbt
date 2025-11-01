// ///|
///|
using @val {type Val, js, unsafe_cast}

///|
using @module {require}

///|
using @async {type Promise, run_async}

///|
using @node_test {it, before_each}

///|
pub struct NodeFs {
  readFile : (String, String?) -> Promise[String]
  writeFile : (String, String) -> Promise[Unit]
  mkdir : (String) -> Promise[Val]
  rmdir : (String) -> Promise[Unit]
  rm : (String) -> Promise[Unit]
  stat : (String) -> Promise[FsStat]
}

///|
pub struct FsStat {
  isFile : () -> Bool
  isDirectory : () -> Bool
  size : Int
  mtime_ms : Float
}

///|
pub fn NodeFs::require() -> NodeFs {
  @module.require("node:fs/promises").cast()
}

///|
test "fs readFile and writeFile" {
  it("fs readFile and writeFile", _ => {
    let { readFile, writeFile, .. } = NodeFs::require()
    let test_path = "./fs_test.txt"
    let content = "Hello, Moon!"
    writeFile(test_path, content).unwrap()
    let read_content = readFile(test_path, Some("utf-8")).unwrap()
    assert_eq(content, read_content)
  })
}
