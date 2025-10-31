// ///|
// #external
// pub type Fs
using @val {type Val, js, unsafe_cast}
using @module {require}
using @promise {type Promise, run_async}
using @node_test {it, before_each}
pub struct NodeFs {
  read_file: (String, String?) -> Promise[String]
  write_file: (String, String) -> Promise[Unit]
}

fn load_fs() -> NodeFs {
  let m = @module.require("node:fs/promises")
  {
    read_file: m.get("readFile").cast(),
    write_file: m.get("writeFile").cast(),
  }
}

test "fs readFile and writeFile" {
  it("fs readFile and writeFile", _ => {
    let {read_file, write_file} = load_fs()
    let test_path = "./fs_test.txt"
    let content = "Hello, Moon!"
    write_file(test_path, content).unwrap()
    let read_content = read_file(test_path, Some("utf-8")).unwrap()
    assert_eq(content, read_content)
  })
}

