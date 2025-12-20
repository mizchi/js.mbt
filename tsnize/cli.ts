#!/usr/bin/env -S deno run -A
// CLI for tsnize - generate TypeScript .d.ts from MoonBit .mbti files

import { generate } from "./src/mod.ts";

const args = Deno.args;

if (args.length === 0) {
  console.log("Usage: tsnize <input.mbti> [output.d.ts]");
  console.log("       tsnize --stdin  (read from stdin)");
  Deno.exit(1);
}

let content: string;
let outputPath: string | undefined;

if (args[0] === "--stdin") {
  const decoder = new TextDecoder();
  const bytes = await Deno.readAll(Deno.stdin);
  content = decoder.decode(bytes);
  outputPath = args[1];
} else {
  content = await Deno.readTextFile(args[0]);
  outputPath = args[1] ?? args[0].replace(/\.mbti$/, ".d.ts");
}

try {
  const dts = generate(content);

  if (outputPath) {
    await Deno.writeTextFile(outputPath, dts);
    console.log(`Generated: ${outputPath}`);
  } else {
    console.log(dts);
  }
} catch (e) {
  console.error(`Error: ${e.message}`);
  Deno.exit(1);
}
