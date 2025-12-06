#!/usr/bin/env node
/**
 * MoonBit optimization CLI
 *
 * Pipeline: moon build -> inline-ffi -> oxc-minify
 *
 * Usage:
 *   moonbit-optimize <input.js> [output.js]
 *   moonbit-optimize --check [testName] [--print] [--update]
 *
 * Requires Node.js 24+ (native TypeScript support)
 */
import { minify } from 'oxc-minify';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { execSync } from 'child_process';
import { transform } from '../src/transform.ts';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function minifyCode(code: string): Promise<string> {
  const result = await minify('input.js', code, {
    mangle: { toplevel: true },
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

interface SizeRecord {
  original: number;
  minifyOnly: number;
  withFfi: number;
}

interface SizesJson {
  [testName: string]: SizeRecord;
}

interface CheckSizeOptions {
  print?: boolean;
  update?: boolean;
}

async function checkSize(testName?: string, { print = false, update = false }: CheckSizeOptions = {}) {
  const scriptDir = __dirname;
  const projectRoot = path.resolve(scriptDir, '../..');
  const sizesJsonPath = path.join(scriptDir, '_sizes.json');

  console.error('Building...');
  execSync('moon build --target js', { cwd: projectRoot, stdio: 'inherit' });

  const testsDir = path.join(scriptDir, '_tests');
  const testDirs = testName
    ? [testName]
    : fs.readdirSync(testsDir).filter(d => fs.statSync(path.join(testsDir, d)).isDirectory());

  // Load previous sizes if exists
  let previousSizes: SizesJson = {};
  if (fs.existsSync(sizesJsonPath)) {
    try {
      previousSizes = JSON.parse(fs.readFileSync(sizesJsonPath, 'utf-8'));
    } catch {
      previousSizes = {};
    }
  }

  const currentSizes: SizesJson = {};
  const results: Array<{
    name: string;
    originalSize: number;
    minifiedOnlySize: number;
    minifiedSize: number;
    prevMinifiedSize?: number;
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
    const minifiedCode = await minifyCode(inlinedCode);
    const minifiedSize = minifiedCode.length;

    console.error(`Inlineable functions: ${inlineableFns}`);
    console.error(`Inlined calls: ${inlineCount}`);
    console.error(`Size: ${originalSize} -> ${minifiedOnlySize} bytes (minify only)`);
    console.error(`Size: ${originalSize} -> ${minifiedSize} bytes (inline + minify)`);
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
    // try {
    //   eval(minifiedCode);
    // } catch (e) {
    //   console.error(`Error running ${dir}: ${(e as Error).message}`);
    // }

    currentSizes[dir] = {
      original: originalSize,
      minifyOnly: minifiedOnlySize,
      withFfi: minifiedSize,
    };

    results.push({
      name: dir,
      originalSize,
      minifiedOnlySize,
      minifiedSize,
      prevMinifiedSize: previousSizes[dir]?.withFfi,
    });
  }

  // Print summary with diff
  console.error(`\n=== Size Summary ===`);
  console.error('Test           | Original | Minify Only | With FFI |  Diff');
  console.error('---------------|----------|-------------|----------|-------');

  let hasRegression = false;
  for (const r of results) {
    const diff = r.prevMinifiedSize !== undefined
      ? r.minifiedSize - r.prevMinifiedSize
      : undefined;

    let diffStr: string;
    if (diff === undefined) {
      diffStr = '  new';
    } else if (diff === 0) {
      diffStr = '    0';
    } else if (diff > 0) {
      diffStr = `  +${diff}`;
      hasRegression = true;
    } else {
      diffStr = `  ${diff}`;
    }

    console.error(
      `${r.name.padEnd(14)} | ${String(r.originalSize).padStart(8)} | ${String(r.minifiedOnlySize).padStart(11)} | ${String(r.minifiedSize).padStart(8)} | ${diffStr}`
    );
  }

  // Update or check
  if (update) {
    // Merge with existing sizes (keep entries not in current test run)
    const mergedSizes = { ...previousSizes, ...currentSizes };
    fs.writeFileSync(sizesJsonPath, JSON.stringify(mergedSizes, null, 2) + '\n');
    console.error(`\n✓ Updated ${sizesJsonPath}`);
  } else if (hasRegression) {
    console.error(`\n✗ Size regression detected! Run with --update to accept new sizes.`);
    process.exit(1);
  } else {
    console.error(`\n✓ All size checks passed`);
  }
}

// CLI Entry Point
const args = process.argv.slice(2);
if (args[0] === '--check') {
  const printFlag = args.includes('--print');
  const updateFlag = args.includes('--update');
  const testName = args.find(a => !a.startsWith('--'));
  checkSize(testName, { print: printFlag, update: updateFlag }).catch(e => { console.error(e); process.exit(1); });
} else if (args.length === 0) {
  console.log('Usage: moonbit-optimize <input.js> [output.js]');
  console.log('       moonbit-optimize --check [testName] [--print] [--update]');
  process.exit(1);
} else {
  processFile(args[0], args[1]).catch(e => { console.error(e); process.exit(1); });
}
