// https://nodejs.org/api/fs.html
// Synchronous File System API

///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @buffer {type Buffer}

///|
/// Get fs module
fn fs_module() -> Val {
  @node.require("node:fs")
}

///| File Reading

///|
/// Read file synchronously as Buffer
#alias(readFileSync)
pub fn read_file_sync(path : String) -> Buffer {
  let fs = fs_module()
  fs.invoke("readFileSync", [path]) |> unsafe_cast
}

///|
/// Read file synchronously as string with encoding
pub fn read_file_sync_string(path : String, encoding : String) -> String {
  let fs = fs_module()
  fs.invoke("readFileSync", [path, encoding]) |> unsafe_cast
}

///| File Writing

///|
/// Write file synchronously
#alias(writeFileSync)
pub fn write_file_sync(path : String, data : &Js) -> Unit {
  let fs = fs_module()
  fs.invoke("writeFileSync", [path, data.to_js()]) |> ignore
}

///|
/// Append to file synchronously
#alias(appendFileSync)
pub fn append_file_sync(path : String, data : &Js) -> Unit {
  let fs = fs_module()
  fs.invoke("appendFileSync", [path, data.to_js()]) |> ignore
}

///| File/Directory Operations

///|
/// Check if path exists
#alias(existsSync)
pub fn exists_sync(path : String) -> Bool {
  let fs = fs_module()
  fs.invoke("existsSync", [path]) |> unsafe_cast
}

///|
/// Get file statistics
#alias(statSync)
pub fn stat_sync(path : String) -> Val {
  let fs = fs_module()
  fs.invoke("statSync", [path])
}

///|
/// Create directory synchronously
#alias(mkdirSync)
pub fn mkdir_sync(path : String, recursive? : Bool) -> Unit {
  let fs = fs_module()
  match recursive {
    Some(r) => {
      let options = @js.new_empty_object()
      options.set("recursive", r)
      fs.invoke("mkdirSync", [path, options]) |> ignore
    }
    None => fs.invoke("mkdirSync", [path]) |> ignore
  }
}

///|
/// Delete file synchronously
#alias(unlinkSync)
pub fn unlink_sync(path : String) -> Unit {
  let fs = fs_module()
  fs.invoke("unlinkSync", [path]) |> ignore
}

///|
/// Rename/move file or directory synchronously
#alias(renameSync)
pub fn rename_sync(old_path : String, new_path : String) -> Unit {
  let fs = fs_module()
  fs.invoke("renameSync", [old_path, new_path]) |> ignore
}

///|
/// Copy file synchronously
#alias(copyFileSync)
pub fn copy_file_sync(src : String, dest : String) -> Unit {
  let fs = fs_module()
  fs.invoke("copyFileSync", [src |> js, dest |> js]) |> ignore
}

///|
/// Read directory contents synchronously
#alias(readdirSync)
pub fn readdir_sync(path : String) -> Array[String] {
  let fs = fs_module()
  fs.invoke("readdirSync", [path]) |> unsafe_cast
}

///|
/// Remove file or directory synchronously
#alias(rmSync)
pub fn rm_sync(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_module()
  match (recursive, force) {
    (Some(r), Some(f)) => {
      let options = @js.new_empty_object()
      options.set("recursive", r)
      options.set("force", f)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (Some(r), None) => {
      let options = @js.new_empty_object()
      options.set("recursive", r)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (None, Some(f)) => {
      let options = @js.new_empty_object()
      options.set("force", f)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (None, None) => fs.invoke("rmSync", [path]) |> ignore
  }
}
