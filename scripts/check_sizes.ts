#!/usr/bin/env node --experimental-strip-types
/**
 * Bundle Size Checker for MoonBit Examples
 *
 * Analyzes bundle sizes of compiled MoonBit examples in target/js output.
 * Measures raw, readable-minified, terser-minified, and esbuild-bundled sizes.
 *
 * Prerequisites:
 *   Run `moon build --target js` before using this script.
 *
 * Usage:
 *   ./scripts/check_sizes.ts [options]
 *
 * Options:
 *   --save              Save current results as baseline (.bundle_size_baseline.json)
 *   --compare           Compare with saved baseline and show diff
 *   --json              Output results as JSON
 *   --output-files      Output processed files to tmp/check-sizes/
 *   --example <name>    Only analyze specific example(s) (can be repeated)
 *
 * Examples:
 *   ./scripts/check_sizes.ts                    # Analyze all examples
 *   ./scripts/check_sizes.ts --save             # Save as baseline
 *   ./scripts/check_sizes.ts --compare          # Compare with baseline
 *   ./scripts/check_sizes.ts --output-files     # Output files to tmp/check-sizes/
 *   ./scripts/check_sizes.ts --example realworld --example hono_app
 *   ./scripts/check_sizes.ts --json             # JSON output
 *
 * Output Files (with --output-files):
 *   tmp/check-sizes/<example>/
 *     <example>-raw.js           Original compiled JS
 *     <example>-readable-min.js  Terser compress only (no mangle, beautified)
 *     <example>-min.js           Terser full minification
 *     <example>-bundle.js        Esbuild bundled + minified
 *
 * Size Columns:
 *   Raw      - Original compiled JS file size
 *   Readable - Terser with compress only, beautified (for inspecting optimizations)
 *   Terser   - Full terser minification (compress + mangle)
 *   Esbuild  - Esbuild bundle + minify (external packages excluded)
 *
 * Example Output:
 *   ========================================================
 *   Bundle Size Analysis
 *   ========================================================
 *
 *   Example              | Raw             | Readable        | Terser          | Esbuild
 *   --------------------------------------------------------
 *   aisdk                |       112.48 KB |       110.49 KB |        80.49 KB |        34.92 KB
 *   hono_app             |        97.49 KB |        97.76 KB |        73.24 KB |        31.05 KB
 *   realworld            |       260.49 KB |       256.65 KB |       186.80 KB |        77.82 KB
 *   --------------------------------------------------------
 *   TOTAL                |         1.19 MB |         1.18 MB |       891.05 KB |       364.45 KB
 */

import { readFileSync, writeFileSync, existsSync, readdirSync, statSync, mkdirSync, copyFileSync } from "node:fs";
import { join, basename } from "node:path";
import { execSync } from "node:child_process";
import { tmpdir } from "node:os";

interface ExampleSize {
  name: string;
  raw: number;
  readableMinified: number;
  terserMinified: number;
  esbuildBundled: number;
  files: string[];
}

interface Baseline {
  timestamp: string;
  examples: ExampleSize[];
}

interface SizeComparison {
  name: string;
  raw: { current: number; baseline: number; diff: number; diffPercent: number };
  readableMinified: { current: number; baseline: number; diff: number; diffPercent: number };
  terserMinified: { current: number; baseline: number; diff: number; diffPercent: number };
  esbuildBundled: { current: number; baseline: number; diff: number; diffPercent: number };
}

const PROJECT_ROOT = process.cwd();
const TARGET_DIR = join(PROJECT_ROOT, "target/js/release/build/examples");
const BASELINE_FILE = join(PROJECT_ROOT, ".bundle_size_baseline.json");
const OUTPUT_DIR = join(PROJECT_ROOT, "tmp/check-sizes");

function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(2)} KB`;
  return `${(bytes / 1024 / 1024).toFixed(2)} MB`;
}

function formatDiff(diff: number, diffPercent: number): string {
  const sign = diff >= 0 ? "+" : "";
  const percentStr = `${sign}${diffPercent.toFixed(1)}%`;
  const bytesStr = `${sign}${formatBytes(Math.abs(diff))}`;
  if (diff === 0) return "  0";
  return `${bytesStr} (${percentStr})`;
}

function findJsFiles(dir: string): string[] {
  const files: string[] = [];
  try {
    const entries = readdirSync(dir);
    for (const entry of entries) {
      const fullPath = join(dir, entry);
      const stat = statSync(fullPath);
      if (stat.isDirectory()) {
        files.push(...findJsFiles(fullPath));
      } else if (entry.endsWith(".js") && !entry.endsWith(".d.ts")) {
        files.push(fullPath);
      }
    }
  } catch {
    // Directory doesn't exist or not readable
  }
  return files;
}

function getFileSize(filePath: string): number {
  try {
    return statSync(filePath).size;
  } catch {
    return 0;
  }
}

function ensureDir(dir: string): void {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
}

function getReadableMinifiedSize(filePath: string, outputPath?: string): number {
  try {
    const tmpFile = outputPath || join(tmpdir(), `terser_readable_${Date.now()}_${basename(filePath)}`);

    // Use terser CLI with compress only, no mangle, beautify output with proper formatting
    // --format beautify=true,indent_level=2 keeps whitespace and indentation
    // This shows logical folding without obfuscation
    execSync(`npx terser "${filePath}" -c --format beautify=true,indent_level=2 -o "${tmpFile}"`, {
      cwd: PROJECT_ROOT,
      stdio: "pipe",
    });

    const size = getFileSize(tmpFile);

    // Clean up if not outputting
    if (!outputPath) {
      try {
        execSync(`rm "${tmpFile}"`, { stdio: "pipe" });
      } catch {}
    }

    return size;
  } catch (err) {
    console.error(`Error creating readable minified ${filePath} with terser:`, err);
    return 0;
  }
}

function getTerserMinifiedSize(filePath: string, outputPath?: string): number {
  try {
    const tmpFile = outputPath || join(tmpdir(), `terser_${Date.now()}_${basename(filePath)}`);

    // Use terser CLI to minify
    execSync(`npx terser "${filePath}" -c -m -o "${tmpFile}"`, {
      cwd: PROJECT_ROOT,
      stdio: "pipe",
    });

    const size = getFileSize(tmpFile);

    // Clean up if not outputting
    if (!outputPath) {
      try {
        execSync(`rm "${tmpFile}"`, { stdio: "pipe" });
      } catch {}
    }

    return size;
  } catch (err) {
    console.error(`Error minifying ${filePath} with terser:`, err);
    return 0;
  }
}

function getEsbuildBundledSize(filePath: string, outputPath?: string): number {
  try {
    const tmpFile = outputPath || join(tmpdir(), `esbuild_${Date.now()}_${basename(filePath)}`);

    // Use esbuild to bundle (mark all node_modules as external)
    execSync(
      `npx esbuild "${filePath}" --bundle --minify --platform=node --packages=external --outfile="${tmpFile}"`,
      {
        cwd: PROJECT_ROOT,
        stdio: "pipe",
      }
    );

    const size = getFileSize(tmpFile);

    // Clean up if not outputting
    if (!outputPath) {
      try {
        execSync(`rm "${tmpFile}"`, { stdio: "pipe" });
      } catch {}
    }

    return size;
  } catch (err) {
    console.error(`Error bundling ${filePath} with esbuild:`, err);
    return 0;
  }
}

function analyzeExample(exampleDir: string, outputFiles: boolean): ExampleSize | null {
  const name = basename(exampleDir);
  const jsFiles = findJsFiles(exampleDir);

  if (jsFiles.length === 0) {
    return null;
  }

  // Find the main JS file (usually named after the example)
  const mainFile = jsFiles.find((f) => basename(f) === `${name}.js`) || jsFiles[0];

  // Prepare output paths if needed
  let rawOutputPath: string | undefined;
  let readableOutputPath: string | undefined;
  let terserOutputPath: string | undefined;
  let esbuildOutputPath: string | undefined;

  if (outputFiles) {
    const exampleOutputDir = join(OUTPUT_DIR, name);
    ensureDir(exampleOutputDir);
    rawOutputPath = join(exampleOutputDir, `${name}-raw.js`);
    readableOutputPath = join(exampleOutputDir, `${name}-readable-min.js`);
    terserOutputPath = join(exampleOutputDir, `${name}-min.js`);
    esbuildOutputPath = join(exampleOutputDir, `${name}-bundle.js`);

    // Copy raw file
    copyFileSync(mainFile, rawOutputPath);
  }

  const raw = getFileSize(mainFile);
  const readableMinified = getReadableMinifiedSize(mainFile, readableOutputPath);
  const terserMinified = getTerserMinifiedSize(mainFile, terserOutputPath);
  const esbuildBundled = getEsbuildBundledSize(mainFile, esbuildOutputPath);

  return {
    name,
    raw,
    readableMinified,
    terserMinified,
    esbuildBundled,
    files: jsFiles.map((f) => f.replace(TARGET_DIR + "/", "")),
  };
}

function loadBaseline(): Baseline | null {
  if (!existsSync(BASELINE_FILE)) {
    return null;
  }
  try {
    return JSON.parse(readFileSync(BASELINE_FILE, "utf-8"));
  } catch {
    return null;
  }
}

function saveBaseline(examples: ExampleSize[]): void {
  const baseline: Baseline = {
    timestamp: new Date().toISOString(),
    examples,
  };
  writeFileSync(BASELINE_FILE, JSON.stringify(baseline, null, 2));
  console.log(`Baseline saved to ${BASELINE_FILE}`);
}

function compareWithBaseline(current: ExampleSize[], baseline: Baseline): SizeComparison[] {
  const comparisons: SizeComparison[] = [];

  for (const example of current) {
    const baselineExample = baseline.examples.find((e) => e.name === example.name);
    if (!baselineExample) continue;

    const calcDiff = (cur: number, base: number) => ({
      current: cur,
      baseline: base,
      diff: cur - base,
      diffPercent: base > 0 ? ((cur - base) / base) * 100 : 0,
    });

    comparisons.push({
      name: example.name,
      raw: calcDiff(example.raw, baselineExample.raw),
      readableMinified: calcDiff(example.readableMinified, baselineExample.readableMinified || 0),
      terserMinified: calcDiff(example.terserMinified, baselineExample.terserMinified),
      esbuildBundled: calcDiff(example.esbuildBundled, baselineExample.esbuildBundled),
    });
  }

  return comparisons;
}

function printResults(examples: ExampleSize[], comparisons: SizeComparison[] | null, outputFiles: boolean): void {
  console.log("=".repeat(120));
  console.log("Bundle Size Analysis");
  console.log("=".repeat(120));
  console.log();

  // Header
  const headers = ["Example", "Raw", "Readable", "Terser", "Esbuild"];
  const colWidths = [20, 15, 15, 15, 15];

  console.log(
    headers.map((h, i) => h.padEnd(colWidths[i])).join(" | ")
  );
  console.log("-".repeat(120));

  // Rows
  for (const example of examples) {
    const row = [
      example.name.padEnd(colWidths[0]),
      formatBytes(example.raw).padStart(colWidths[1]),
      formatBytes(example.readableMinified).padStart(colWidths[2]),
      formatBytes(example.terserMinified).padStart(colWidths[3]),
      formatBytes(example.esbuildBundled).padStart(colWidths[4]),
    ];
    console.log(row.join(" | "));
  }

  console.log("-".repeat(120));

  // Totals
  const totals = examples.reduce(
    (acc, e) => ({
      raw: acc.raw + e.raw,
      readableMinified: acc.readableMinified + e.readableMinified,
      terserMinified: acc.terserMinified + e.terserMinified,
      esbuildBundled: acc.esbuildBundled + e.esbuildBundled,
    }),
    { raw: 0, readableMinified: 0, terserMinified: 0, esbuildBundled: 0 }
  );

  console.log(
    [
      "TOTAL".padEnd(colWidths[0]),
      formatBytes(totals.raw).padStart(colWidths[1]),
      formatBytes(totals.readableMinified).padStart(colWidths[2]),
      formatBytes(totals.terserMinified).padStart(colWidths[3]),
      formatBytes(totals.esbuildBundled).padStart(colWidths[4]),
    ].join(" | ")
  );

  console.log();

  // Comparison with baseline
  if (comparisons && comparisons.length > 0) {
    console.log("=".repeat(120));
    console.log("Comparison with Baseline");
    console.log("=".repeat(120));
    console.log();

    const diffHeaders = ["Example", "Raw Diff", "Readable Diff", "Terser Diff", "Esbuild Diff"];
    const diffColWidths = [20, 22, 22, 22, 22];

    console.log(
      diffHeaders.map((h, i) => h.padEnd(diffColWidths[i])).join(" | ")
    );
    console.log("-".repeat(120));

    for (const comp of comparisons) {
      const row = [
        comp.name.padEnd(diffColWidths[0]),
        formatDiff(comp.raw.diff, comp.raw.diffPercent).padStart(diffColWidths[1]),
        formatDiff(comp.readableMinified.diff, comp.readableMinified.diffPercent).padStart(diffColWidths[2]),
        formatDiff(comp.terserMinified.diff, comp.terserMinified.diffPercent).padStart(diffColWidths[3]),
        formatDiff(comp.esbuildBundled.diff, comp.esbuildBundled.diffPercent).padStart(diffColWidths[4]),
      ];
      console.log(row.join(" | "));
    }

    console.log();
  }

  if (outputFiles) {
    console.log(`Files output to: ${OUTPUT_DIR}`);
    console.log();
  }
}

function printJson(examples: ExampleSize[], comparisons: SizeComparison[] | null): void {
  const output = {
    timestamp: new Date().toISOString(),
    examples,
    comparisons: comparisons || undefined,
  };
  console.log(JSON.stringify(output, null, 2));
}

async function main() {
  const args = process.argv.slice(2);

  // Parse arguments
  let save = false;
  let compare = false;
  let json = false;
  let outputFiles = false;
  const selectedExamples: string[] = [];

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "--save") {
      save = true;
    } else if (arg === "--compare") {
      compare = true;
    } else if (arg === "--json") {
      json = true;
    } else if (arg === "--output-files") {
      outputFiles = true;
    } else if (arg === "--example" && args[i + 1]) {
      selectedExamples.push(args[++i]);
    }
  }

  // Check if target directory exists
  if (!existsSync(TARGET_DIR)) {
    console.error(`Error: Target directory not found: ${TARGET_DIR}`);
    console.error("Please run 'moon build --target js' first.");
    process.exit(1);
  }

  // Get example directories
  let exampleDirs: string[];
  try {
    const entries = readdirSync(TARGET_DIR);
    exampleDirs = entries
      .map((e) => join(TARGET_DIR, e))
      .filter((d) => statSync(d).isDirectory());
  } catch (err) {
    console.error("Error reading target directory:", err);
    process.exit(1);
  }

  // Filter if specific examples requested
  if (selectedExamples.length > 0) {
    exampleDirs = exampleDirs.filter((d) => selectedExamples.includes(basename(d)));
    if (exampleDirs.length === 0) {
      console.error("No matching examples found for:", selectedExamples.join(", "));
      process.exit(1);
    }
  }

  // Create output directory if needed
  if (outputFiles) {
    ensureDir(OUTPUT_DIR);
  }

  if (!json) {
    console.log(`Analyzing ${exampleDirs.length} examples...\n`);
  }

  // Analyze each example
  const examples: ExampleSize[] = [];
  for (const dir of exampleDirs) {
    if (!json) {
      process.stdout.write(`  Analyzing ${basename(dir)}...`);
    }
    const result = analyzeExample(dir, outputFiles);
    if (result) {
      examples.push(result);
      if (!json) {
        console.log(" done");
      }
    } else {
      if (!json) {
        console.log(" (no JS files found)");
      }
    }
  }

  if (!json) {
    console.log();
  }

  // Sort by name
  examples.sort((a, b) => a.name.localeCompare(b.name));

  // Load baseline for comparison
  let comparisons: SizeComparison[] | null = null;
  if (compare) {
    const baseline = loadBaseline();
    if (baseline) {
      comparisons = compareWithBaseline(examples, baseline);
      if (!json) {
        console.log(`Loaded baseline from ${baseline.timestamp}`);
        console.log();
      }
    } else if (!json) {
      console.log("No baseline found. Run with --save to create one.");
      console.log();
    }
  }

  // Output results
  if (json) {
    printJson(examples, comparisons);
  } else {
    printResults(examples, comparisons, outputFiles);
  }

  // Save baseline if requested
  if (save) {
    saveBaseline(examples);
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
