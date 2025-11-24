#!/usr/bin/env node --experimental-strip-types
/**
 * Test Stability Checker for MoonBit
 *
 * This script runs `moon test --verbose` multiple times and analyzes the results
 * to identify flaky tests and compare against a baseline.
 *
 * Usage:
 *   ./check_test.ts [runs] [timeout]
 *
 * Arguments:
 *   runs    - Number of test runs (default: 2)
 *   timeout - Timeout per run in milliseconds (default: 120000)
 *
 * Examples:
 *   ./check_test.ts          # Run 2 times with 120s timeout
 *   ./check_test.ts 5        # Run 5 times with 120s timeout
 *   ./check_test.ts 3 180000 # Run 3 times with 180s timeout
 *
 * Features:
 *   - Captures all test results with file:line information
 *   - Compares consecutive runs to find flaky tests
 *   - Saves last run as baseline (.test_baseline.json)
 *   - Shows statistics and success rates
 *   - Identifies new failures, new successes, and consistent failures
 */
import { spawn } from "node:child_process";
import { writeFileSync, readFileSync, existsSync } from "node:fs";

interface TestResult {
  name: string;
  status: "ok" | "failed" | "timeout";
  file: string;
  line: number;
}

interface RunResult {
  tests: TestResult[];
  totalTests: number;
  passedTests: number;
  failedTests: number;
  duration: number;
  timedOut: boolean;
}

async function runTests(timeout: number = 120000): Promise<RunResult> {
  return new Promise((resolve, reject) => {
    const startTime = Date.now();
    const tests: TestResult[] = [];
    let output = "";

    const proc = spawn("moon", ["test", "--target", "js", "--verbose"], {
      cwd: process.cwd(),
      stdio: ["ignore", "pipe", "pipe"],
      timeout: 100000,
    });

    const timer = setTimeout(() => {
      proc.kill("SIGTERM");

      // Clean up event listeners on timeout
      proc.stdout?.removeAllListeners();
      proc.stderr?.removeAllListeners();
      proc.removeAllListeners();

      resolve({
        tests,
        totalTests: tests.length,
        passedTests: tests.filter((t) => t.status === "ok").length,
        failedTests: tests.filter((t) => t.status === "failed").length,
        duration: Date.now() - startTime,
        timedOut: true,
      });
    }, timeout);

    proc.stdout.on("data", (data: Buffer) => {
      const chunk = data.toString();
      output += chunk;
      process.stdout.write(chunk);

      // Parse test results from verbose output
      const lines = chunk.split("\n");
      for (const line of lines) {
        // Match: [mizchi/js] test file.mbt:123 ("test name") ok
        const match = line.match(
          /\[mizchi\/js\] test (.+\.mbt):(\d+) \("([^"]+)"\) (ok|failed)/,
        );
        if (match) {
          const [, file, lineNum, name, status] = match;
          tests.push({
            name,
            status: status as "ok" | "failed",
            file,
            line: parseInt(lineNum, 10),
          });
        }
      }
    });

    proc.stderr.on("data", (data: Buffer) => {
      process.stderr.write(data);
    });

    proc.on("close", (_code) => {
      clearTimeout(timer);

      // Clean up event listeners to prevent hanging
      proc.stdout?.removeAllListeners();
      proc.stderr?.removeAllListeners();
      proc.removeAllListeners();

      const duration = Date.now() - startTime;

      // Parse summary line: Total tests: 1465, passed: 1465, failed: 0.
      const summaryMatch = output.match(
        /Total tests: (\d+), passed: (\d+), failed: (\d+)/,
      );
      let totalTests = tests.length;
      let passedTests = tests.filter((t) => t.status === "ok").length;
      let failedTests = tests.filter((t) => t.status === "failed").length;

      if (summaryMatch) {
        totalTests = parseInt(summaryMatch[1], 10);
        passedTests = parseInt(summaryMatch[2], 10);
        failedTests = parseInt(summaryMatch[3], 10);
      }

      resolve({
        tests,
        totalTests,
        passedTests,
        failedTests,
        duration,
        timedOut: false,
      });
    });

    proc.on("error", (err) => {
      clearTimeout(timer);

      // Clean up event listeners on error
      proc.stdout?.removeAllListeners();
      proc.stderr?.removeAllListeners();
      proc.removeAllListeners();

      reject(err);
    });
  });
}

function findDifferences(
  run1: RunResult,
  run2: RunResult,
): {
  newFailures: TestResult[];
  newSuccesses: TestResult[];
  consistentFailures: TestResult[];
} {
  const run1Map = new Map<string, TestResult>();
  const run2Map = new Map<string, TestResult>();

  for (const test of run1.tests) {
    const key = `${test.file}:${test.line}`;
    run1Map.set(key, test);
  }

  for (const test of run2.tests) {
    const key = `${test.file}:${test.line}`;
    run2Map.set(key, test);
  }

  const newFailures: TestResult[] = [];
  const newSuccesses: TestResult[] = [];
  const consistentFailures: TestResult[] = [];

  // Find tests that failed in run2 but passed in run1
  for (const [key, test2] of run2Map) {
    const test1 = run1Map.get(key);
    if (test1) {
      if (test1.status === "ok" && test2.status === "failed") {
        newFailures.push(test2);
      } else if (test1.status === "failed" && test2.status === "ok") {
        newSuccesses.push(test2);
      } else if (test1.status === "failed" && test2.status === "failed") {
        consistentFailures.push(test2);
      }
    }
  }

  return { newFailures, newSuccesses, consistentFailures };
}

async function main() {
  const args = process.argv.slice(2);
  const runs = parseInt(args[0] || "2", 10);
  const timeout = parseInt(args[1] || "120000", 10);

  console.log(`Running moon test ${runs} times with ${timeout}ms timeout...`);
  console.log("=".repeat(80));

  const results: RunResult[] = [];
  const baselineFile = ".test_baseline.json";

  // Load baseline if exists
  let baseline: RunResult | null = null;
  if (existsSync(baselineFile)) {
    try {
      baseline = JSON.parse(readFileSync(baselineFile, "utf-8"));
      console.log("Loaded baseline from", baselineFile);
    } catch (e) {
      console.warn("Failed to load baseline:", e);
    }
  }

  // Run tests multiple times
  for (let i = 0; i < runs; i++) {
    console.log(`\n${"=".repeat(80)}`);
    console.log(`Run ${i + 1}/${runs}`);
    console.log("=".repeat(80));

    try {
      const result = await runTests(timeout);
      results.push(result);

      console.log(`\n${"=".repeat(80)}`);
      console.log(`Run ${i + 1} Summary:`);
      console.log(
        `  Total: ${result.totalTests}, Passed: ${result.passedTests}, Failed: ${result.failedTests}`,
      );
      console.log(`  Duration: ${(result.duration / 1000).toFixed(2)}s`);
      console.log(`  Timed out: ${result.timedOut}`);
      console.log("=".repeat(80));

      if (result.failedTests > 0) {
        console.log("\nFailed tests:");
        const failed = result.tests.filter((t) => t.status === "failed");
        for (const test of failed) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
    } catch (err) {
      console.error(`Run ${i + 1} error:`, err);
    }
  }

  // Save last run as baseline
  if (results.length > 0) {
    const lastRun = results[results.length - 1];
    writeFileSync(baselineFile, JSON.stringify(lastRun, null, 2));
    console.log(`\nSaved last run as baseline to ${baselineFile}`);
  }

  // Compare runs
  console.log(`\n${"=".repeat(80)}`);
  console.log("Analysis:");
  console.log("=".repeat(80));

  if (results.length >= 2) {
    console.log("\nComparing consecutive runs:");
    for (let i = 1; i < results.length; i++) {
      const diff = findDifferences(results[i - 1], results[i]);
      console.log(`\nRun ${i} vs Run ${i + 1}:`);

      if (diff.newFailures.length > 0) {
        console.log(`  New failures (${diff.newFailures.length}):`);
        for (const test of diff.newFailures) {
          console.log(`    - ${test.file}:${test.line} "${test.name}"`);
        }
      }

      if (diff.newSuccesses.length > 0) {
        console.log(`  New successes (${diff.newSuccesses.length}):`);
        for (const test of diff.newSuccesses) {
          console.log(`    - ${test.file}:${test.line} "${test.name}"`);
        }
      }

      if (diff.consistentFailures.length > 0) {
        console.log(
          `  Consistent failures (${diff.consistentFailures.length}):`
        );
        for (const test of diff.consistentFailures) {
          console.log(`    - ${test.file}:${test.line} "${test.name}"`);
        }
      }

      if (
        diff.newFailures.length === 0 &&
        diff.newSuccesses.length === 0 &&
        diff.consistentFailures.length === 0
      ) {
        console.log("  No differences found");
      }
    }
  }

  // Compare against baseline
  if (baseline && results.length > 0) {
    console.log("\n" + "=".repeat(80));
    console.log("Comparison with baseline:");
    console.log("=".repeat(80));

    const lastRun = results[results.length - 1];
    const diff = findDifferences(baseline, lastRun);

    if (diff.newFailures.length > 0) {
      console.log(`\nNew failures compared to baseline (${diff.newFailures.length}):`);
      for (const test of diff.newFailures) {
        console.log(`  - ${test.file}:${test.line} "${test.name}"`);
      }
    }

    if (diff.newSuccesses.length > 0) {
      console.log(`\nFixed tests compared to baseline (${diff.newSuccesses.length}):`);
      for (const test of diff.newSuccesses) {
        console.log(`  - ${test.file}:${test.line} "${test.name}"`);
      }
    }

    if (diff.consistentFailures.length > 0) {
      console.log(
        `\nConsistent failures (${diff.consistentFailures.length}):`
      );
      for (const test of diff.consistentFailures) {
        console.log(`  - ${test.file}:${test.line} "${test.name}"`);
      }
    }
  }

  // Statistics
  console.log("\n" + "=".repeat(80));
  console.log("Statistics:");
  console.log("=".repeat(80));

  const successRates = results.map(
    (r) => (r.passedTests / r.totalTests) * 100,
  );
  const avgSuccessRate =
    successRates.reduce((a, b) => a + b, 0) / successRates.length;
  const timeouts = results.filter((r) => r.timedOut).length;

  console.log(
    `Success rate: ${successRates.map((r) => r.toFixed(1) + "%").join(", ")}`,
  );
  console.log(`Average success rate: ${avgSuccessRate.toFixed(1)}%`);
  console.log(`Timeouts: ${timeouts}/${results.length}`);

  // Exit with error if there were failures or timeouts
  const hasFailures = results.some((r) => r.failedTests > 0 || r.timedOut);
  process.exit(hasFailures ? 1 : 0);
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
