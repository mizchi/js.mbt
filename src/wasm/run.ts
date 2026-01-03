// run.ts - Script to load and run WASM-GC module with jscore imports
//
// NOTE: js-string-builtins is NOT supported in Node.js/Deno as of 2025-01.
// Use browser testing instead:
//   1. npx serve .
//   2. Open http://localhost:3000/src/wasm/test.html in Chrome
//
// This script is kept for future compatibility when Node.js supports
// the js-string-builtins proposal.

import { createJsCoreImports } from "./inject.ts";
import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const WASM_PATH = resolve(__dirname, "../../target/wasm-gc/release/build/wasm/wasm.wasm");

async function main() {
  console.log("Loading WASM module from:", WASM_PATH);

  const wasmBytes = await readFile(WASM_PATH);

  // V8 extension: 3-argument version with builtins option
  const instantiate = WebAssembly.instantiate as (
    source: BufferSource,
    importObject?: WebAssembly.Imports,
    options?: { builtins?: string[]; importedStringConstants?: string }
  ) => Promise<WebAssembly.WebAssemblyInstantiatedSource>;

  // Instantiate with jscore imports and js-string-builtins
  const { instance } = await instantiate(
    wasmBytes,
    { jscore: createJsCoreImports() },
    {
      builtins: ["js-string"],
      importedStringConstants: "_",
    }
  );

  const exports = instance.exports as {
    _start?: () => void;
    test_core: () => string;
    test_dom: () => void;
  };

  console.log("WASM exports:", Object.keys(exports));

  // Call _start if exists (initializer)
  if (exports._start) {
    console.log("Calling _start...");
    exports._start();
  }

  // Call test_core
  console.log("\nCalling test_core...");
  const result = exports.test_core();
  console.log("test_core returned:", result);
}

main().catch(console.error);
