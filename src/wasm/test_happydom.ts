// test_happydom.ts - Test WASM-GC DOM operations with happy-dom
// Run: deno run --allow-read --allow-env src/wasm/test_happydom.ts

import { Window } from "npm:happy-dom";

// Create jscore imports for WASM
function createJsCoreImports() {
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

    // Fixed-arity method calls
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
    invoke4: (fn: any, a1: any, a2: any, a3: any, a4: any) => fn(a1, a2, a3, a4),

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

    // Global values - will be overridden with happy-dom's window
    global_this: () => (globalThis as any).__happyDomWindow ?? globalThis,
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
    log: (message: any) => console.log("[WASM]", message),
    throw: (value: any) => {
      throw value;
    },
    from: (v: any) => v,

    // Type-specific from functions
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
    int64_to_bigint: (v: bigint) => v,
    bigint_to_int64: (v: any) => BigInt(v),
  };
}

async function main() {
  console.log("=== MoonBit WASM-GC DOM Tests with Happy-DOM ===\n");

  // Create happy-dom window
  const window = new Window({
    url: "https://localhost:8080",
    width: 1024,
    height: 768,
  });

  // Set up global references for WASM
  (globalThis as any).__happyDomWindow = window;
  (globalThis as any).document = window.document;

  // Load WASM
  const wasmPath = "./target/wasm-gc/release/build/wasm/wasm.wasm";
  const wasmBytes = await Deno.readFile(wasmPath);

  console.log(`WASM size: ${wasmBytes.length} bytes\n`);

  // Instantiate with happy-dom environment
  const { instance } = await (WebAssembly.instantiate as any)(
    wasmBytes,
    { jscore: createJsCoreImports() },
    {
      builtins: ["js-string"],
      importedStringConstants: "_",
    }
  );

  const exports = instance.exports as Record<string, () => any>;

  // DOM test functions
  const domTests = [
    "test_dom",
    "test_dom_nested",
    "test_dom_attributes",
    "test_dom_inner_html",
    "test_dom_query_selector",
    // Extended DOM tests
    "test_class_list",
    "test_dataset",
    "test_dom_traversal",
    "test_query_selector_all",
    "test_form_elements",
    "test_clone_replace",
    "test_attributes",
  ];

  let passed = 0;
  let failed = 0;

  for (const testName of domTests) {
    if (typeof exports[testName] !== "function") {
      console.log(`⚠️  ${testName} - not exported`);
      continue;
    }

    try {
      // Clear body before each test
      window.document.body.innerHTML = "";

      exports[testName]();

      // Verify DOM was modified
      const bodyHtml = window.document.body.innerHTML;
      const hasContent = bodyHtml.length > 0;

      if (hasContent) {
        console.log(`✅ ${testName}`);
        console.log(`   Body HTML (${bodyHtml.length} chars):`);
        // Show first 200 chars of HTML
        const preview = bodyHtml.substring(0, 200);
        console.log(`   ${preview}${bodyHtml.length > 200 ? "..." : ""}`);
        passed++;
      } else {
        console.log(`⚠️  ${testName} - no DOM output`);
        failed++;
      }
    } catch (e) {
      console.log(`❌ ${testName}`);
      console.log(`   Error: ${(e as Error).message}`);
      failed++;
    }
    console.log();
  }

  // Test test_dom_extended (runs all extended DOM tests)
  console.log("--- Running test_dom_extended ---");
  try {
    window.document.body.innerHTML = "";
    exports.test_dom_extended();

    const bodyHtml = window.document.body.innerHTML;
    console.log(`✅ test_dom_extended`);
    console.log(`   Total body HTML: ${bodyHtml.length} chars`);

    // Count created elements
    const elementCount = window.document.body.querySelectorAll("*").length;
    console.log(`   Created elements: ${elementCount}`);

    // Show structure
    const children = Array.from(window.document.body.children).map(
      (el: any) => `<${el.tagName.toLowerCase()}>`
    );
    console.log(`   Top-level elements: ${children.join(", ")}`);
    passed++;
  } catch (e) {
    console.log(`❌ test_dom_extended`);
    console.log(`   Error: ${(e as Error).message}`);
    failed++;
  }

  // Test test_dom_all
  console.log("\n--- Running test_dom_all ---");
  try {
    window.document.body.innerHTML = "";
    exports.test_dom_all();

    const bodyHtml = window.document.body.innerHTML;
    console.log(`✅ test_dom_all`);
    console.log(`   Total body HTML: ${bodyHtml.length} chars`);
    passed++;
  } catch (e) {
    console.log(`❌ test_dom_all`);
    console.log(`   Error: ${(e as Error).message}`);
    failed++;
  }

  console.log(`\n=== Results: ${passed} passed, ${failed} failed ===`);

  // Cleanup
  await window.happyDOM.close();

  Deno.exit(failed > 0 ? 1 : 0);
}

main();
