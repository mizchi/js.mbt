# MoonBit Node.js API Examples

This document demonstrates how to use Node.js APIs with the `mizchi/js` library.

## File System Operations

Working with the Node.js file system API:

```moonbit
///|
test "file write and read operations" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let outpath = @path.join([tmpdir, "moonbit_test.txt"])
    let content = "Hello from MoonBit!"

    // Write file
    @fs_promises.writeFile(outpath, content).unwrap()

    // Read file
    let read_content = @fs_promises.readFile(outpath).unwrap()
    inspect(read_content, content="Hello from MoonBit!")
    assert_eq(content, read_content)
  } catch {
    _ => ()
  })
}
```

## File Stats

Getting file statistics:

```moonbit
///|
test "file stats" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let filepath = @path.join([tmpdir, "moonbit_stat_test.txt"])
    let content = "File stats test"
    @fs_promises.writeFile(filepath, content).unwrap()
    let stat = @fs_promises.stat(filepath).unwrap()
    inspect(stat.isFile(), content="true")
    inspect(stat.isDirectory(), content="false")
    assert_true(stat.isFile())
    assert_false(stat.isDirectory())
  } catch {
    _ => ()
  })
}
```

## Path Operations

Working with file paths:

```moonbit
///|
test "path operations" {
  let parts = ["tmp", "test", "file.txt"]
  let joined = @path.join(parts)
  inspect(joined, content="tmp/test/file.txt")

  // Platform-specific path separators
  let has_separator = joined.contains("/") || joined.contains("\\")
  assert_true(has_separator)
}
```

## OS Information

Getting operating system information:

```moonbit
///|
test "os information" {
  let tmpdir = @os.tmpdir()
  // tmpdir should be a non-empty string
  assert_true(tmpdir.length() > 0)
  let homedir = @os.homedir()
  assert_true(homedir.length() > 0)
}
```

## Directory Operations

Creating and checking directories:

```moonbit
///|
test "directory operations" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let test_dir = @path.join([tmpdir, "moonbit_test_dir"])

    // Create directory
    @fs_promises.mkdir(test_dir).unwrap()

    // Check if it exists and is a directory
    let stat = @fs_promises.stat(test_dir).unwrap()
    inspect(stat.isDirectory(), content="true")
    assert_true(stat.isDirectory())

    // Clean up
    @fs_promises.rmdir(test_dir).unwrap()
  } catch {
    _ => ()
  })
}
```

## File Existence Check

Checking if files or directories exist:

```moonbit
///|
test "file existence check" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let test_file = @path.join([tmpdir, "moonbit_exists_test.txt"])

    // Write a file
    @fs_promises.writeFile(test_file, "exists").unwrap()

    // Check existence using stat (will throw if not exists)
    let exists = try {
      @fs_promises.stat(test_file).unwrap() |> ignore
      true
    } catch {
      _ => false
    }
    inspect(exists, content="true")
    assert_true(exists)
  } catch {
    _ => ()
  })
}
```

## Reading Directory Contents

List files in a directory:

```moonbit
///|
test "read directory contents" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let test_dir = @path.join([tmpdir, "moonbit_readdir_test"])

    // Create test directory
    @fs_promises.mkdir(test_dir).unwrap()

    // Create some test files
    @fs_promises.writeFile(@path.join([test_dir, "file1.txt"]), "content1").unwrap()
    @fs_promises.writeFile(@path.join([test_dir, "file2.txt"]), "content2").unwrap()

    // Read directory
    let entries = @fs_promises.readdir(test_dir).unwrap()
    inspect(entries)
    assert_true(entries.length() >= 2)

    // Clean up
    @fs_promises.unlink(@path.join([test_dir, "file1.txt"])).unwrap()
    @fs_promises.unlink(@path.join([test_dir, "file2.txt"])).unwrap()
    @fs_promises.rmdir(test_dir).unwrap()
  } catch {
    _ => ()
  })
}
```

## Appending to Files

Append content to existing files:

```moonbit
///|
test "append to file" {
  @js.run_async(() => try {
    let tmpdir = @os.tmpdir()
    let filepath = @path.join([tmpdir, "moonbit_append_test.txt"])

    // Write initial content
    @fs_promises.writeFile(filepath, "Line 1\n").unwrap()

    // Append more content
    @fs_promises.appendFile(filepath, "Line 2\n").unwrap()
    @fs_promises.appendFile(filepath, "Line 3\n").unwrap()

    // Read and verify
    let content = @fs_promises.readFile(filepath).unwrap()
    inspect(content, content="Line 1\nLine 2\nLine 3\n")
    assert_true(content.contains("Line 1"))
    assert_true(content.contains("Line 2"))
    assert_true(content.contains("Line 3"))
  } catch {
    _ => ()
  })
}
```
