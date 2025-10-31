// ///|
// #external
// pub type Fs

// ///|
// impl @js.ToJs for Fs with to_js(self) -> @js.Value {
//   self |> @js.to_js
// }

// ///|
// async fn init_fs() -> Fs {
//   let fs = @js.import_module("node:fs/promises")
//   fs.cast()
// }
// // WIP

// ///|
// pub async fn read_file(path : String) -> String {
//   let p : @js.Promise[String] = init_fs()
//     .to_js()
//     .call_property1("readFile", path)
//     .cast()
//   p.wait()
// }

// ///|
// pub async fn write_file(path : String, content : String) -> Unit {
//   let p : @js.Promise[Unit] = init_fs()
//     .to_js()
//     .call_property2("writeFile", path, content)
//     .cast()
//   p.wait()  
// }

// ///|
// test "ok" {
//   @js.it(
//     "fs readFile and writeFile",
//     // let test_path = "./fs_test.txt"
//     _ => assert_true(true),
//   )
// }