// TypeScript runner for xany wasm-gc tests
// Usage: deno test -A src/xany/_test/run.ts

import { test } from "node:test";
import { strict as assert } from "node:assert";

const wasmPath = new URL(
  "../../../target/wasm-gc/release/build/xany/_test/_test.wasm",
  import.meta.url
);

// Host-provided xany helper functions
const xanyImports = {
  global_this: () => globalThis,
  get: (obj: any, key: string) => obj[key],
  get_by_index: (obj: any, index: number) => obj[index],
  set: (obj: any, key: string, value: any) => {
    obj[key] = value;
  },
  call0: (obj: any, name: string) => obj[name](),
  call1: (obj: any, name: string, a1: any) => obj[name](a1),
  call2: (obj: any, name: string, a1: any, a2: any) => obj[name](a1, a2),
  call3: (obj: any, name: string, a1: any, a2: any, a3: any) =>
    obj[name](a1, a2, a3),
  call4: (obj: any, name: string, a1: any, a2: any, a3: any, a4: any) =>
    obj[name](a1, a2, a3, a4),
  invoke0: (fn: any) => fn(),
  invoke1: (fn: any, a1: any) => fn(a1),
  invoke2: (fn: any, a1: any, a2: any) => fn(a1, a2),
  invoke3: (fn: any, a1: any, a2: any, a3: any) => fn(a1, a2, a3),
  invoke4: (fn: any, a1: any, a2: any, a3: any, a4: any) => fn(a1, a2, a3, a4),
  new0: (cls: any) => new cls(),
  new1: (cls: any, a1: any) => new cls(a1),
  new2: (cls: any, a1: any, a2: any) => new cls(a1, a2),
  new3: (cls: any, a1: any, a2: any, a3: any) => new cls(a1, a2, a3),
  new4: (cls: any, a1: any, a2: any, a3: any, a4: any) =>
    new cls(a1, a2, a3, a4),
  typeof: (v: any) => typeof v,
  is_nullish: (v: any) => v == null,
  instanceof: (v: any, cls: any) => v instanceof cls,
  equal: (a: any, b: any) => a === b,
  to_string: (v: any) => (v == null ? String(v) : v.toString()),
  undefined: () => undefined,
  null: () => null,
  from: (v: any) => v,
};

async function loadWasm() {
  const wasmResponse = await fetch(wasmPath);
  // V8 extension: 3-argument version with builtins option
  const instantiate = WebAssembly.instantiateStreaming as (
    source: Response | PromiseLike<Response>,
    importObject?: WebAssembly.Imports,
    options?: { builtins?: string[]; importedStringConstants?: string }
  ) => Promise<WebAssembly.WebAssemblyInstantiatedSource>;

  const { instance } = await instantiate(
    wasmResponse,
    { xany: xanyImports },
    {
      builtins: ["js-string"],
      importedStringConstants: "_",
    }
  );
  return instance.exports as {
    test_math_random: () => number;
    _start: () => void;
  };
}

test("xany wasm-gc: Math.random returns number between 0 and 1", async () => {
  const exports = await loadWasm();
  const result = exports.test_math_random();

  assert.equal(typeof result, "number");
  assert.ok(result >= 0, `Expected result >= 0, got ${result}`);
  assert.ok(result < 1, `Expected result < 1, got ${result}`);
});

test("xany wasm-gc: main function runs without error", async () => {
  const exports = await loadWasm();
  // Should not throw
  exports._start();
});
