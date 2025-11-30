# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

## MoonBit Language Reference

If you're unsure about MoonBit syntax, refer to the [MoonBit Cheatsheet](src/examples/moonbit_cheatsheet.mbt.md) - it covers common patterns, differences from Rust, and key language features.

## Project Structure

- MoonBit packages are organized per directory, for each directory, there is a
  `moon.pkg.json` file listing its dependencies. Each package has its files and
  blackbox test files (common, ending in `_test.mbt`) and whitebox test files
  (ending in `_wbtest.mbt`).

- In the toplevel directory, this is a `moon.mod.json` file listing about the
  module and some meta information.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check the test is passed. MoonBit supports snapshot
  testing, so when your changes indeed change the behavior of the code, you
  should run `moon test --update` to update the snapshot.

- You can run `moon check` to check the code is linted correctly.

- When writing tests, you are encouraged to use `inspect` and run
  `moon test --update` to update the snapshots, only use assertions like
  `assert_eq` when you are in some loops where each snapshot may vary. You can
  use `moon coverage analyze > uncovered.log` to see which parts of your code
  are not covered by tests.
- `moon coverage analyze --package pkgName` is also useful to see the coverage of a
  specific package.
- CLAUDE.md has some small tasks that are easy for AI to pick up, agent is
  welcome to finish the tasks and check the box when you are done

## Testing

```bash
moon test
moon build
pnpm test:cloudflare
deno test -A
```

### Async Test Resource Management

When writing `async test` that creates servers or network resources (HTTP, HTTPS, HTTP/2, Net), **ALWAYS** use `defer` immediately after resource creation to ensure proper cleanup:

```moonbit
async test "Server test example" {
  let server = createServer()
  defer server.close() |> ignore  // REQUIRED: Add this immediately after creation

  // Test code here...
}

async test "Socket test example" {
  let socket = createConnection()
  defer socket.destroy() |> ignore  // REQUIRED: Add this immediately after creation

  // Test code here...
}
```

**Rules:**
- Place `defer` statement **immediately after** resource creation (server, socket, etc.)
- This applies to all async tests in:
  - `src/node/http/*_test.mbt`
  - `src/node/https/*_test.mbt`
  - `src/node/http2/*_test.mbt`
  - `src/node/net/*_test.mbt`
- The `defer` ensures cleanup even if the test fails or times out
- You may still call explicit cleanup (e.g., `server.close(callback=...)`) for verification purposes, but `defer` is mandatory for safety

**Test Stability:**
- Use `./scripts/check_flaky.ts` to verify test stability
- Run multiple times to identify flaky tests: `./scripts/check_flaky.ts 10 12000`
- All tests should consistently pass without timeouts

## MoonBit to JavaScript Type Mapping

### Primitive Types (Zero-cost)

| MoonBit Type | JavaScript Type |
|--------------|-----------------|
| `String` | `string` |
| `Bool` | `boolean` |
| `Int`, `UInt`, `Float`, `Double` | `number` |
| `BigInt` | `bigint` |
| `Bytes` | `Uint8Array` |
| `Array[T]` | `Array<T>` |
| Function Type | `Function` |

### Collection Type Conversion Overhead (minified)

| MoonBit Type | Conversion | Overhead |
|--------------|------------|----------|
| `Array[T]` | `%identity` | +31B (zero-cost) |
| `HashSet[T]` | iterate + push | +4.6KB |
| `Map[String, T]` | iterate + set | +6.2KB |
| `Json` | recursive match | +6.9KB |
| `@immut/array.T[T]` | iterate + push | +7.2KB |
| `@immut/hashmap.HashMap` | iterate + set | +11.6KB |

See [docs/runtime-cost.md](docs/runtime-cost.md) for detailed analysis.
