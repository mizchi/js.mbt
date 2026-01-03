// inject.ts - JavaScript imports for @core WASM module
// Usage: import { createJsCoreImports, loadWasm } from "./inject.ts";

/**
 * Create jscore namespace imports for WebAssembly.instantiate
 * This provides the JavaScript runtime for @core.Any operations in WASM-GC
 */
export function createJsCoreImports() {
  return {
    // Property access
    get: (obj: any, key: string) => obj[key],
    get_by_index: (obj: any, index: number) => obj[index],
    set: (obj: any, key: string, value: any) => {
      obj[key] = value;
    },
    set_by_index: (obj: any, index: number, value: any) => {
      obj[index] = value;
    },

    // Fixed-arity method calls (WASM can't use variadic args)
    call0: (obj: any, name: string) => obj[name](),
    call1: (obj: any, name: string, a1: any) => obj[name](a1),
    call2: (obj: any, name: string, a1: any, a2: any) => obj[name](a1, a2),
    call3: (obj: any, name: string, a1: any, a2: any, a3: any) =>
      obj[name](a1, a2, a3),
    call4: (obj: any, name: string, a1: any, a2: any, a3: any, a4: any) =>
      obj[name](a1, a2, a3, a4),

    // Fixed-arity function invokes
    invoke0: (fn: any) => fn(),
    invoke1: (fn: any, a1: any) => fn(a1),
    invoke2: (fn: any, a1: any, a2: any) => fn(a1, a2),
    invoke3: (fn: any, a1: any, a2: any, a3: any) => fn(a1, a2, a3),
    invoke4: (fn: any, a1: any, a2: any, a3: any, a4: any) =>
      fn(a1, a2, a3, a4),

    // Fixed-arity constructors
    new0: (cls: any) => new cls(),
    new1: (cls: any, a1: any) => new cls(a1),
    new2: (cls: any, a1: any, a2: any) => new cls(a1, a2),
    new3: (cls: any, a1: any, a2: any, a3: any) => new cls(a1, a2, a3),
    new4: (cls: any, a1: any, a2: any, a3: any, a4: any) =>
      new cls(a1, a2, a3, a4),

    // Type checks
    typeof: (v: any) => typeof v,
    is_nullish: (v: any) => v == null,
    is_null: (v: any) => v === null,
    is_undefined: (v: any) => v === undefined,
    is_array: (v: any) => Array.isArray(v),
    is_object: (v: any) => typeof v === "object" && v !== null,
    instanceof: (v: any, cls: any) => v instanceof cls,
    equal: (a: any, b: any) => a === b,

    // Global values
    global_this: () => globalThis,
    undefined: () => undefined,
    null: () => null,

    // Object operations
    new_object: () => ({}),
    new_array: () => [],
    object_keys: (obj: any) => Object.keys(obj),
    object_values: (obj: any) => Object.values(obj),
    object_assign: (target: any, source: any) => Object.assign(target, source),
    object_has_own: (obj: any, key: string) => Object.hasOwn(obj, key),
    array_from: (v: any) => Array.from(v),
    array_length: (arr: any) => arr.length,

    // JSON
    json_stringify: (value: any) => JSON.stringify(value),
    json_stringify_pretty: (value: any, space: number) =>
      JSON.stringify(value, null, space),
    json_parse: (text: string) => JSON.parse(text),

    // Utility
    to_string: (v: any) => (v == null ? String(v) : v.toString()),
    log: (message: any) => console.log(message),
    throw: (value: any) => {
      throw value;
    },
    from: (v: any) => v,

    // Type-specific from functions for ToAny trait in WASM-GC
    // These allow type-safe conversion from MoonBit primitives to externref
    from_int: (v: number) => v,
    from_uint: (v: number) => v,
    from_int64: (v: bigint) => v,
    from_uint64: (v: bigint) => v,
    from_float: (v: number) => v,
    from_double: (v: number) => v,
    from_string: (v: string) => v,
    from_bool: (v: boolean) => v,
    from_bytes: (v: Uint8Array) => v,
    from_array: (v: any[]) => v,

    // BigInt conversion: Int64 (i64) <-> BigInt
    // WASM i64 is automatically converted to/from JS BigInt
    int64_to_bigint: (v: bigint) => v, // i64 comes in as BigInt, return as-is
    bigint_to_int64: (v: any) => BigInt(v), // Convert to BigInt for i64 return
  };
}

/**
 * Load and instantiate a WASM module with jscore imports
 */
export async function loadWasm(wasmUrl: string | URL) {
  const wasmResponse = await fetch(wasmUrl);

  // V8 extension: 3-argument version with builtins option
  const instantiate = WebAssembly.instantiateStreaming as (
    source: Response | PromiseLike<Response>,
    importObject?: WebAssembly.Imports,
    options?: { builtins?: string[]; importedStringConstants?: string }
  ) => Promise<WebAssembly.WebAssemblyInstantiatedSource>;

  const { instance } = await instantiate(
    wasmResponse,
    { jscore: createJsCoreImports() },
    {
      builtins: ["js-string"],
      importedStringConstants: "_",
    }
  );

  return instance.exports;
}

// For browser usage via <script type="module">
if (typeof window !== "undefined") {
  (window as any).jsCoreWasm = { createJsCoreImports, loadWasm };
}
