# mizchi/js_builtin

MoonBit bindings for JavaScript's built-in global objects — the things that
exist in every JS runtime, browser or server.

Depends only on [`mizchi/js_core`](../js_core/README.md). One package per
built-in, so you import just the ones you use.

## Packages

| Package | Binds | Note |
|---------|-------|------|
| `array` | `JsArray` | JS `Array` as a non-generic `Array[Any]`; converts to MoonBit `Array[T]` |
| `arraybuffer` | `ArrayBuffer`, `SharedArrayBuffer`, `DataView`, `TypedArray` | All typed arrays (`Uint8Array`, `Float64Array`, `BigInt64Array`, …); zero-cost `Bytes` ⇔ `Uint8Array` |
| `atomics` | `Atomics` | `add`/`load`/`store`/`wait`/`notify` on shared memory |
| `bigint` | `JsBigInt` | Arbitrary-precision integers |
| `collection` | `JsMap`, `JsSet` | JS `Map` and `Set` |
| `date` | `Date` | Timestamps, components, formatting |
| `disposable` | `DisposableStack`, `AsyncDisposableStack` | Explicit resource management |
| `error` | `JsError`, `TypeError`, `RangeError`, `ReferenceError`, `SyntaxError`, `URIError`, `EvalError`, `AggregateError` | The error hierarchy |
| `function` | `Function` | `call`/`apply`/`bind` |
| `global` | `Timer` and the global functions | `setTimeout`, `setInterval`, `queueMicrotask`, `globalThis`, `undefined`, `parseInt`, `atob`/`btoa`, `encodeURIComponent`, `structuredClone`, `dynamic_import`, … |
| `iterator` | `JsIterator`, `AsyncIterator` | The iteration protocols |
| `json` | `JSON` | `JSON.parse` / `JSON.stringify` |
| `math` | `Math` | The `Math` namespace |
| `object` | `Object`, `PropertyDescriptor` | `keys`/`values`/`entries`/`assign`/`freeze`/`defineProperty`, … |
| `proxy` | `Proxy` | Proxy traps |
| `reflect` | `Reflect` | The `Reflect` namespace |
| `regexp` | `RegExp`, `RegExpMatchArray`, `RegExpResult` | Native JS regex |
| `string` | `JsString` | JS `String` methods not in MoonBit's `String` |
| `symbol` | `Symbol` | Well-known and user symbols |
| `weak` | `WeakMap`, `WeakSet`, `WeakRef`, `FinalizationRegistry` | Weak references |

Several packages have their own README with fuller API tables: `arraybuffer`,
`bigint`, `collection`, `date`, `error`, `global`, `math`, `proxy`, `reflect`,
`regexp`, `weak`.

## Usage

```
# moon.mod
import {
  "mizchi/js_core@0.13.0",
  "mizchi/js_builtin@0.13.0",
}
```

```
# moon.pkg
import {
  "mizchi/js_core" @core,
  "mizchi/js_builtin/json",
  "mizchi/js_builtin/object",
}
```

Package aliases are the last path segment, so these are `@json` and `@object`.

```moonbit
///|
pub fn describe() -> String {
  let o = @core.new_object()
  o["k"] = @core.any(1)
  let any : @core.Any = o |> @core.identity
  let _ = @object.Object::entries(any)
  @json.JSON::stringify(any)
}
```

If you would rather have one import for core plus all the built-ins, depend on
[`mizchi/js`](../js/README.mbt.md) — it re-exports both.

See the [User Guide](../../docs/guide.md) for picking modules and aliases.
