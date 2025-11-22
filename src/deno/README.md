# mizchi/js/deno

MoonBit bindings for Deno runtime APIs.

## Deno API Support Status

| Category | API | Status | Note |
|----------|-----|--------|------|
| **Runtime** |
| Environment Variables | `env_get/set/delete/toObject` | 🧪 Tested | Process environment |
| Process | `cwd/exit/args` | 🧪 Tested | Process information |
| **File System** |
| Read/Write Text | `readTextFile/writeTextFile` | 🧪 Tested | Text file operations |
| Read/Write Binary | `readFile/writeFile` | 🧪 Tested | Binary file operations |
| Directory | `readDir/mkdir/remove` | 🧪 Tested | Directory operations |
| **Testing** |
| Test Definition | `test_/test_async/test_only` | 🧪 Tested | Test framework |
| **Permissions** |
| Query/Request/Revoke | `permissions_*` | 🧪 Tested | Permission management |
| PermissionStatus | `state/is_granted` | 🧪 Tested | Permission state |
| **Planned APIs** |
| Network | `connect/listen/serve` | 📅 Planned | TCP/HTTP networking |
| Subprocess | `Command/run` | 📅 Planned | Process spawning |
| KV | `openKv` | 📅 Planned | Key-value storage |
| FFI | `dlopen` | 📅 Planned | Foreign function interface |
| WebGPU | `Deno.gpu` | 📅 Planned | GPU acceleration |

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage
- 📅 **Planned**: Scheduled for future implementation

### Using Node.js APIs in Deno

For APIs not yet implemented in the Deno-specific bindings, you can use Node.js compatibility packages:

```moonbit
// Use Node.js fs instead of Deno's file APIs
fn example() -> Unit {
  @js.run_async(fn() {
    let content = @fs_promises.readFile("file.txt", "utf-8").await
    @console.log(content)
  })
}
```

Deno provides built-in Node.js compatibility. See:
- [Deno Node.js Compatibility](https://docs.deno.com/runtime/fundamentals/node/) - Official compatibility guide
- [mizchi/js/node](../node/README.md) - Available Node.js bindings

---

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/deno"
  ]
}
```

## API

### Process/Runtime APIs

- `Deno::env_get(key)` - Get environment variable
- `Deno::env_set(key, value)` - Set environment variable
- `Deno::env_delete(key)` - Delete environment variable
- `Deno::env_toObject()` - Get all environment variables
- `Deno::cwd()` - Get current working directory
- `Deno::exit(code?)` - Exit the process
- `Deno::args()` - Get command line arguments

### File System APIs

- `Deno::readTextFile(path)` - Read text file (returns Promise[String])
- `Deno::writeTextFile(path, data)` - Write text file (returns Promise[Unit])
- `Deno::readFile(path)` - Read file as Uint8Array (returns Promise[Js])
- `Deno::writeFile(path, data)` - Write file from Uint8Array (returns Promise[Unit])
- `Deno::remove(path, recursive?)` - Remove file or directory (returns Promise[Unit])
- `Deno::mkdir(path, recursive?)` - Create directory (returns Promise[Unit])
- `Deno::readDir(path)` - Read directory entries

### Test APIs

- `Deno::test_(name, fn)` - Define a test (synchronous)
- `Deno::test_async(name, fn)` - Define a test (asynchronous)
- `Deno::test_only(name, fn)` - Define a test marked as "only"

### Permissions API

- `Deno::permissions_query(name, path?)` - Query permission status (returns Promise[PermissionStatus])
- `Deno::permissions_request(name, path?)` - Request permission (returns Promise[PermissionStatus])
- `Deno::permissions_revoke(name, path?)` - Revoke permission (returns Promise[PermissionStatus])
- `PermissionStatus::state()` - Get permission state ("granted", "denied", "prompt")
- `PermissionStatus::is_granted()` - Check if permission is granted

## Example

```moonbit
fn main {
  let d = @deno.deno()
  
  // Environment variables
  d.env_set("MY_VAR", "hello")
  let value = d.env_get("MY_VAR")
  
  // Current directory
  let cwd = d.cwd()
  println(cwd)
  
  // Command line args
  let args = d.args()
  
  // File operations (async)
  d.writeTextFile("test.txt", "Hello, Deno!").await()
  let content = d.readTextFile("test.txt").await()
  println(content)
  
  // Permissions
  let status = d.permissions_query("read", path="/tmp").await()
  if status.is_granted() {
    println("Read permission granted")
  }
}
```

## Testing with Deno

To use these bindings with Deno's test runner, create a test file:

```moonbit
fn main {
  let d = @deno.deno()
  
  d.test_async("file operations", fn(_ctx) {
    d.writeTextFile("test.txt", "content").await()
    let result = d.readTextFile("test.txt").await()
    assert_eq(result, "content")
    d.remove("test.txt").await()
  })
}
```

Then run with:
```bash
moon build --target js
deno test --allow-all target/js/release/build/deno/deno.js
```

## Notes

- Most file system operations require `--allow-read` and `--allow-write` permissions
- Network operations require `--allow-net` permission
- Environment variable access requires `--allow-env` permission
- For testing, use `--allow-all` or specify individual permissions

## Status

This is a basic implementation of Deno APIs. More APIs will be added as needed.
