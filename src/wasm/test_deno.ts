// test_deno.ts - Run WASM tests in Deno
// Usage: deno run --allow-read src/wasm/test_deno.ts

import { createJsCoreImports } from "./inject.ts";

const WASM_PATH = new URL(
  "../../target/wasm-gc/release/build/wasm/wasm.wasm",
  import.meta.url
);

interface TestExports {
  test_core: () => string;
  test_object_ops: () => string;
  test_null_undefined: () => string;
  test_type_checks: () => string;
  test_global_this: () => string;
  test_method_calls: () => string;
  test_json: () => string;
  test_dom: () => void;
}

async function main() {
  console.log("=== MoonBit WASM-GC Tests (Deno) ===\n");

  const wasmBytes = await Deno.readFile(WASM_PATH);
  console.log(`WASM size: ${wasmBytes.length} bytes\n`);

  // Instantiate with js-string-builtins
  const { instance } = await (WebAssembly.instantiate as any)(
    wasmBytes,
    { jscore: createJsCoreImports() },
    { builtins: ["js-string"], importedStringConstants: "_" }
  );

  const exports = instance.exports as TestExports;
  console.log("Available exports:", Object.keys(exports).filter(k => k.startsWith("test_")).join(", "));
  console.log("");

  // Run tests
  const tests: Array<[string, () => string]> = [
    ["test_core", exports.test_core],
    ["test_object_ops", exports.test_object_ops],
    ["test_null_undefined", exports.test_null_undefined],
    ["test_type_checks", exports.test_type_checks],
    ["test_global_this", exports.test_global_this],
    ["test_method_calls", exports.test_method_calls],
    ["test_json", exports.test_json],
  ];

  let passed = 0;
  let failed = 0;

  for (const [name, fn] of tests) {
    try {
      const result = fn();
      console.log(`✅ ${name}`);
      console.log(`   Result: ${result}`);
      passed++;
    } catch (e: any) {
      console.log(`❌ ${name}`);
      console.log(`   Error: ${e.message}`);
      failed++;
    }
  }

  console.log(`\n=== Results: ${passed} passed, ${failed} failed ===`);

  if (failed > 0) {
    Deno.exit(1);
  }
}

main().catch((e) => {
  console.error("Fatal error:", e.message);
  Deno.exit(1);
});
