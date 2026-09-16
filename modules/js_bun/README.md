# mizchi/js_bun

MoonBit bindings for [Bun](https://bun.sh)-specific APIs — the `Bun` global and
the runtime's own extras. Everything else a Bun program needs (`fetch`, `URL`,
streams, the JS built-ins) lives in
[`mizchi/js_web`](../js_web/README.md) and
[`mizchi/js_builtin`](../js_builtin/README.md).

Single package: import it as `mizchi/js_bun`.

## API Support Status

Status reflects what `bun_test/` actually exercises — 🧪 covered, 🚧 bound but
untested. Note that the `bun test` step in CI is `continue-on-error: true`, so
these are advisory rather than gating.

| Category | API | Status | Note |
|----------|-----|--------|------|
| **Entry point** |
| `Bun` global | `bun()`, `is_bun()` | 🧪 Tested | `is_bun()` guards non-Bun runtimes |
| **Process** |
| Process info | `argv()`, `cwd()`, `main_()`, `version()` | 🧪 Tested | |
| Environment | `env()`, `env_get()` | 🚧 Partially | |
| Build info | `revision()` | 🚧 Partially | |
| Exit | `exit(code?)` | 🚧 Partially | |
| **File I/O** |
| Read | `file_text()`, `file_arrayBuffer()` | 🧪 Tested | `Bun.file(path).text()` / `.arrayBuffer()` |
| Write | `write(path, data)` | 🧪 Tested | Returns bytes written |
| Delete | `unlink_sync(path)` | 🧪 Tested | |
| **Subprocess** |
| Spawn | `spawn(SpawnOptions)` | 🧪 Tested | `Subprocess` exposes `pid`, `exitCode`, `exited()`, `kill()`, stdio |
| Spawn (sync) | `spawnSync()` | 🚧 Partially | |
| Lookup | `which(cmd)` | 🧪 Tested | |
| **HTTP server** |
| Serve | `serve(port?, hostname?, handler)` | 🚧 Partially | `Server` exposes `port`, `hostname`, `stop()` |
| **Hashing / crypto** |
| Hash | `hash_(data, algorithm?)` | 🧪 Tested | |
| Passwords | `password_hash()`, `password_verify()` | 🧪 Tested | Argon2 by default |
| UUID | `random_uuid_v7()` | 🧪 Tested | |
| `CryptoHasher` | `new()`, `update()`, `digest_hex/base64/buffer()` | 🚧 Partially | |
| **Glob** |
| Matching | `Glob::new()`, `match_()`, `scan(cwd?)` | 🚧 Partially | |
| **Test runner** |
| Define | `test_()`, `test_async()` | 🧪 Tested | `bun test`; this module's own suite uses them |
| Assert | `expect()` → `toBe`, `toEqual`, `toContain`, `toBeTruthy`, `toBeFalsy`, `toBeNull`, `toBeDefined`, `toBeUndefined` | 🧪 Tested | |
| **Misc** |
| Timing | `nanoseconds()`, `sleep(ms)` | 🧪 Tested | |
| Strings | `escapeHTML()`, `stringWidth()` | 🧪 Tested | |
| Lazy promises | `peek(v)` | 🚧 Partially | |

## Usage

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_bun@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_bun" @bun,
}
```

The module root's default alias would be `@js_bun`, so give it `@bun` as
above.

```moonbit
///|
pub async fn read_config() -> String {
  @bun.bun().file_text("config.json")
}
```

See the [User Guide](../../docs/guide.md) for picking modules and aliases.
