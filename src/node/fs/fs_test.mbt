///|
using @js {type Val, trait Js, js, unsafe_cast}

///|
using @buffer {type Buffer}

///|
/// Synchronous File System API Tests

///| File Reading Tests

///|
/// Test read_file_sync reads buffer
test "read_file_sync reads package.json" {
  let content = read_file_sync("package.json")
  inspect(unsafe_cast(content.get("length")) > 0, content="true")
}

///|
/// Test read_file_sync_string reads as string
test "read_file_sync_string reads package.json as utf8" {
  let content = read_file_sync_string("package.json", "utf8")
  inspect(content.contains("scripts"), content="true")
}

///| File Writing Tests

///|
/// Test write_file_sync and read_file_sync
test "write_file_sync creates file" {
  let test_file = "test_write_sync.txt"
  write_file_sync(test_file, "Hello, sync world!" |> js)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content == "Hello, sync world!", content="true")
  // Cleanup
  unlink_sync(test_file)
}

///|
/// Test append_file_sync
test "append_file_sync appends to file" {
  let test_file = "test_append_sync.txt"
  write_file_sync(test_file, "Hello" |> js)
  append_file_sync(test_file, ", World!" |> js)
  let content = read_file_sync_string(test_file, "utf8")
  inspect(content == "Hello, World!", content="true")
  // Cleanup
  unlink_sync(test_file)
}

///| File/Directory Operations Tests

///|
/// Test exists_sync returns true for existing file
test "exists_sync returns true for package.json" {
  let exists = exists_sync("package.json")
  inspect(exists, content="true")
}

///|
/// Test exists_sync returns false for non-existing file
test "exists_sync returns false for non-existing file" {
  let exists = exists_sync("non_existing_file_12345.txt")
  inspect(exists == false, content="true")
}

///|
/// Test stat_sync returns file stats
test "stat_sync returns stats for package.json" {
  let stats = stat_sync("package.json")
  inspect(@js.typeof_(stats) == "object", content="true")
}

///|
/// Test mkdir_sync with recursive option
test "mkdir_sync creates nested directories" {
  let test_dir = "test_sync_nested/sub/deep"
  mkdir_sync(test_dir, recursive=true)
  let exists = exists_sync(test_dir)
  inspect(exists, content="true")
  // Cleanup
  rm_sync("test_sync_nested", recursive=true)
}

///|
/// Test unlink_sync deletes file
test "unlink_sync deletes file" {
  let test_file = "test_unlink_sync.txt"
  write_file_sync(test_file, "delete me" |> js)
  unlink_sync(test_file)
  let exists = exists_sync(test_file)
  inspect(exists == false, content="true")
}

///|
/// Test rename_sync
test "rename_sync renames file" {
  let old_name = "test_rename_old.txt"
  let new_name = "test_rename_new.txt"
  write_file_sync(old_name, "rename test" |> js)
  rename_sync(old_name, new_name)
  let old_exists = exists_sync(old_name)
  let new_exists = exists_sync(new_name)
  inspect(old_exists == false, content="true")
  inspect(new_exists, content="true")
  // Cleanup
  unlink_sync(new_name)
}

///|
/// Test copy_file_sync
test "copy_file_sync copies file" {
  let src = "test_copy_src.txt"
  let dest = "test_copy_dest.txt"
  write_file_sync(src, "copy test" |> js)
  copy_file_sync(src, dest)
  let src_content = read_file_sync_string(src, "utf8")
  let dest_content = read_file_sync_string(dest, "utf8")
  inspect(src_content == dest_content, content="true")
  // Cleanup
  unlink_sync(src)
  unlink_sync(dest)
}

///|
/// Test readdir_sync
test "readdir_sync reads directory contents" {
  let test_dir = "test_readdir_sync"
  mkdir_sync(test_dir)
  write_file_sync("\{test_dir}/file1.txt", "test" |> js)
  write_file_sync("\{test_dir}/file2.txt", "test" |> js)
  let files = readdir_sync(test_dir)
  inspect(files.length() == 2, content="true")
  // Cleanup
  rm_sync(test_dir, recursive=true)
}
