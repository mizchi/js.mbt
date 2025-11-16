// https://nodejs.org/api/fs.html
// Synchronous File System API

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
#alias(write_file_sync)
pub fn writeFileSync(path : String, data : &Js) -> Unit {
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
#alias(exists_sync)
pub fn existsSync(path : String) -> Bool {
  let fs = fs_module()
  fs.invoke("existsSync", [path]) |> unsafe_cast
}

///|
/// Get file statistics
#alias(stat_sync)
pub fn statSync(path : String) -> Val {
  let fs = fs_module()
  fs.invoke("statSync", [path])
}

///|
/// Create directory synchronously
#alias(mkdir_sync)
pub fn mkdirSync(path : String, recursive? : Bool) -> Unit {
  let fs = fs_module()
  match recursive {
    Some(r) => {
      let opts = @js.from_map({ "recursive": r |> unsafe_cast })
      fs.invoke("mkdirSync", [path, opts]) |> ignore
    }
    None => fs.invoke("mkdirSync", [path]) |> ignore
  }
}

///|
/// Delete file synchronously
#alias(unlink_sync)
pub fn unlinkSync(path : String) -> Unit {
  let fs = fs_module()
  fs.invoke("unlinkSync", [path]) |> ignore
}

///|
/// Rename/move file or directory synchronously
#alias(rename_sync)
pub fn renameSync(old_path : String, new_path : String) -> Unit {
  let fs = fs_module()
  fs.invoke("renameSync", [old_path, new_path]) |> ignore
}

///|
/// Copy file synchronously
// #alias(copyFileSync)
pub fn copyFileSync(src : String, dest : String) -> Unit {
  let fs = fs_module()
  fs.invoke("copyFileSync", [src, dest]) |> ignore
}

///|
/// Read directory contents synchronously
#alias(readdir_sync)
pub fn readdirSync(path : String) -> Array[String] {
  let fs = fs_module()
  fs.invoke("readdirSync", [path]) |> unsafe_cast
}

///|
/// Remove file or directory synchronously
#alias(rm_sync)
pub fn rmSync(path : String, recursive? : Bool, force? : Bool) -> Unit {
  let fs = fs_module()
  match (recursive, force) {
    (Some(r), Some(f)) => {
      let options = @js.Object::new()
      options.set("recursive", r)
      options.set("force", f)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (Some(r), None) => {
      let options = @js.Object::new()
      options.set("recursive", r)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (None, Some(f)) => {
      let options = @js.Object::new()
      options.set("force", f)
      fs.invoke("rmSync", [path, options]) |> ignore
    }
    (None, None) => fs.invoke("rmSync", [path]) |> ignore
  }
}
