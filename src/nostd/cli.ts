#!/usr/bin/env node
/**
 * MoonBit nostd minifier CLI
 *
 * Pipeline: moon build -> inline-ffi -> oxc-minify
 *
 * Usage:
 *   npx tsx src/nostd/cli.ts <input.js> [output.js]
 *   npx tsx src/nostd/cli.ts --check  # Build and check size of _tests
 */
import { minify } from 'oxc-minify';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { execSync } from 'child_process';
import { transform } from './transform.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function minifyCode(code: string): Promise<string> {
  const result = await minify('input.js', code, {
    mangle: { toplevel: true },
    compress: { passes: 3 }
  });
  return result.code;
}

async function processFile(inputPath: string, outputPath?: string) {
  const code = fs.readFileSync(inputPath, 'utf-8');
  const originalSize = code.length;

  const { code: inlinedCode, inlineCount, inlineableFns } = transform(code);
  const inlinedSize = inlinedCode.length;

  const minifiedCode = await minifyCode(inlinedCode);
  const minifiedSize = minifiedCode.length;

  console.error(`Inlineable functions: ${inlineableFns}`);
  console.error(`Inlined calls: ${inlineCount}`);
  console.error(`Size: ${originalSize} -> ${inlinedSize} (inline) -> ${minifiedSize} (minify) bytes`);

  if (outputPath) {
    fs.writeFileSync(outputPath, minifiedCode);
    console.error(`Output: ${outputPath}`);
  } else {
    console.log(minifiedCode);
  }

  return { originalSize, inlinedSize, minifiedSize };
}

interface CheckSizeOptions {
  print?: boolean;
}

async function checkSize(testName?: string, { print = false }: CheckSizeOptions = {}) {
  const scriptDir = __dirname;
  const projectRoot = path.resolve(scriptDir, '../..');

  console.error('Building...');
  execSync('moon build --target js', { cwd: projectRoot, stdio: 'inherit' });

  const testsDir = path.join(scriptDir, '_tests');
  const testDirs = testName
    ? [testName]
    : fs.readdirSync(testsDir).filter(d => fs.statSync(path.join(testsDir, d)).isDirectory());

  const results: Array<{
    name: string;
    originalSize: number;
    minifiedOnlySize: number;
    inlinedSize: number;
    minifiedSize: number;
  }> = [];

  for (const dir of testDirs) {
    const inputPath = path.join(projectRoot, `target/js/release/build/nostd/_tests/${dir}/${dir}.js`);
    if (!fs.existsSync(inputPath)) {
      console.error(`\n  Skipping ${dir}: ${inputPath} not found`);
      continue;
    }

    console.error(`\n=== Processing: ${dir} ===`);

    const code = fs.readFileSync(inputPath, 'utf-8');
    const originalSize = code.length;

    const minifiedOnly = await minifyCode(code);
    const minifiedOnlySize = minifiedOnly.length;

    const { code: inlinedCode, inlineCount, inlineableFns } = transform(code);
    const inlinedSize = inlinedCode.length;
    const minifiedCode = await minifyCode(inlinedCode);
    const minifiedSize = minifiedCode.length;

    console.error(`Inlineable functions: ${inlineableFns}`);
    console.error(`Inlined calls: ${inlineCount}`);
    console.error(`Size: ${originalSize} -> ${minifiedOnlySize} bytes (minify only)`);
    console.error(`Size: ${originalSize} -> ${inlinedSize} -> ${minifiedSize} bytes (inline + minify)`);
    console.error(`FFI transform saves: ${minifiedOnlySize - minifiedSize} bytes`);

    if (print) {
      console.error('\n--- Minified Code (without FFI transform) ---');
      console.log(minifiedOnly);
      console.error('--- End ---\n');
      console.error('\n--- Inlined Code (with FFI transform) ---');
      console.log(inlinedCode);
      console.error('--- End ---\n');
      console.error('\n--- Minified Code (with FFI transform) ---');
      console.log(minifiedCode);
      console.error('--- End ---\n');
    }

    console.error('Running minified code:');
    try {
      eval(minifiedCode);
    } catch (e) {
      console.error(`Error running ${dir}: ${(e as Error).message}`);
    }

    results.push({ name: dir, originalSize, minifiedOnlySize, inlinedSize, minifiedSize });
  }

  console.error(`\n=== Size Summary ===`);
  console.error('Test           | Original | Minify Only | With FFI | Saved');
  console.error('---------------|----------|-------------|----------|------');
  for (const r of results) {
    const saved = r.minifiedOnlySize - r.minifiedSize;
    console.error(`${r.name.padEnd(14)} | ${String(r.originalSize).padStart(8)} | ${String(r.minifiedOnlySize).padStart(11)} | ${String(r.minifiedSize).padStart(8)} | ${String(saved).padStart(5)}`);
  }

  const failed = results.filter(r => r.minifiedSize > 500);
  if (failed.length > 0) {
    console.error(`\n  Warning: ${failed.length} test(s) exceed 500 bytes`);
    process.exit(1);
  } else {
    console.error(`\n All size checks passed`);
  }
}

// CLI Entry Point
const args = process.argv.slice(2);
if (args[0] === '--check') {
  const printFlag = args.includes('--print');
  const testName = args.find(a => a !== '--check' && a !== '--print');
  checkSize(testName, { print: printFlag }).catch(e => { console.error(e); process.exit(1); });
} else if (args.length === 0) {
  console.log('Usage: npx tsx src/nostd/cli.ts <input.js> [output.js]');
  console.log('       npx tsx src/nostd/cli.ts --check [testName] [--print]');
  process.exit(1);
} else {
  processFile(args[0], args[1]).catch(e => { console.error(e); process.exit(1); });
}
