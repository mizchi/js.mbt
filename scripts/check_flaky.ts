#!/usr/bin/env node --experimental-strip-types
/**
 * Test Stability Checker for MoonBit
 *
 * This script runs `moon test --verbose` multiple times and analyzes the results
 * to identify flaky tests and compare against a baseline.
 *
 * Usage:
 *   ./scripts/check_flaky.ts [runs] [timeout] [--verbose]
 *
 * Arguments:
 *   runs     - Number of test runs (default: 2)
 *   timeout  - Timeout per run in milliseconds (default: 12000)
 *   --verbose, -v - Show all test output (default: show progress only)
 *
 * Examples:
 *   ./scripts/check_flaky.ts              # Run 2 times with 12s timeout
 *   ./scripts/check_flaky.ts 5            # Run 5 times with 12s timeout
 *   ./scripts/check_flaky.ts 3 180000     # Run 3 times with 180s timeout
 *   ./scripts/check_flaky.ts 5 60000 -v   # Run 5 times with verbose output
 *   ./scripts/check_flaky.ts 10 12000     # Run 10 times, press Ctrl-C to see diff
 *
 * Features:
 *   - Shows progress indicator (100 tests, 200 tests, etc.)
 *   - Immediately displays failed tests
 *   - Shows last test executed on timeout
 *   - Captures all test results with file:line information
 *   - Compares consecutive runs to find flaky tests
 *   - Saves last run as baseline (.test_baseline.json)
 *   - Shows statistics and success rates
 *   - Identifies new failures, new successes, and consistent failures
 *
 * Output:
 *   - Progress updates every 100 tests (unless verbose)
 *   - Real-time diff between consecutive runs
 *   - Summary per run with pass/fail counts
 *   - Analysis of differences between runs
 *   - Comparison with baseline (if exists)
 *   - Statistics (success rate, timeouts, etc.)
 *
 * Exit codes:
 *   0   - All runs passed with consistent test counts
 *   1   - Some runs failed or test counts were inconsistent
 *   130 - Interrupted by user (Ctrl-C)
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
  testKeys: Set<string>;
}

async function runTests(
  timeout: number = 12000,
  verbose: boolean = false,
  previousTests?: Set<string>,
): Promise<RunResult> {
  return new Promise((resolve, reject) => {
    const startTime = Date.now();
    const tests: TestResult[] = [];
    let output = "";
    let lastProgressUpdate = 0;
    const currentTestKeys = new Set<string>();

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

      const lastTest = tests[tests.length - 1];
      console.log(
        `\n⚠️  TIMEOUT after ${timeout}ms - Last test: ${lastTest?.file}:${lastTest?.line} "${lastTest?.name}"`,
      );

      resolve({
        tests,
        totalTests: tests.length,
        passedTests: tests.filter((t) => t.status === "ok").length,
        failedTests: tests.filter((t) => t.status === "failed").length,
        duration: Date.now() - startTime,
        timedOut: true,
        testKeys: currentTestKeys,
      });
    }, timeout);

    proc.stdout.on("data", (data: Buffer) => {
      const chunk = data.toString();
      output += chunk;

      // Show verbose output if requested
      if (verbose) {
        process.stdout.write(chunk);
      }

      // Parse test results from verbose output
      const lines = chunk.split("\n");
      for (const line of lines) {
        // Match: [mizchi/js] test file.mbt:123 ("test name") ok
        const match = line.match(
          /\[mizchi\/js\] test (.+\.mbt):(\d+) \("([^"]+)"\) (ok|failed)/,
        );
        if (match) {
          const [, file, lineNum, name, status] = match;
          const testKey = `${file}:${lineNum}`;

          tests.push({
            name,
            status: status as "ok" | "failed",
            file,
            line: parseInt(lineNum, 10),
          });

          // Track test keys for diff
          if (status === "ok") {
            currentTestKeys.add(testKey);
          }

          // Show progress every 100 tests or if failed
          if (!verbose && (tests.length % 100 === 0 || status === "failed")) {
            const now = Date.now();
            // Update at most once per second to avoid too many updates
            if (now - lastProgressUpdate > 1000 || status === "failed") {
              const passed = tests.filter((t) => t.status === "ok").length;
              const failed = tests.filter((t) => t.status === "failed").length;

              let progressMsg = `\r  Progress: ${tests.length} tests (${passed} passed, ${failed} failed)`;

              // Show diff if we have previous test results
              if (previousTests && previousTests.size > 0) {
                const newTests = [...currentTestKeys].filter(
                  (k) => !previousTests.has(k),
                );
                const missingTests = [...previousTests].filter(
                  (k) => !currentTestKeys.has(k),
                );
                if (newTests.length > 0 || missingTests.length > 0) {
                  progressMsg += ` | diff: +${newTests.length} -${missingTests.length}`;
                }
              }

              process.stdout.write(progressMsg);
              lastProgressUpdate = now;
            }
          }

          // Show failed tests immediately
          if (status === "failed") {
            console.log(`\n❌ FAILED: ${file}:${lineNum} "${name}"`);
          }
        }
      }
    });

    proc.stderr.on("data", (data: Buffer) => {
      if (verbose) {
        process.stderr.write(data);
      }
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
        testKeys: currentTestKeys,
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

  // Parse arguments
  let runs = 2;
  let timeout = 12000;
  let verbose = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "--verbose" || arg === "-v") {
      verbose = true;
    } else if (i === 0 && !isNaN(parseInt(arg, 10))) {
      runs = parseInt(arg, 10);
    } else if (i === 1 && !isNaN(parseInt(arg, 10))) {
      timeout = parseInt(arg, 10);
    }
  }

  console.log(
    `Running moon test ${runs} times with ${timeout}ms timeout${verbose ? " (verbose mode)" : ""}...`,
  );
  console.log("=".repeat(80));

  const results: RunResult[] = [];
  const baselineFile = ".test_baseline.json";

  // Handle Ctrl-C
  process.on("SIGINT", () => {
    console.log("\n\n⚠️  Interrupted by user (Ctrl-C)");
    console.log(`Completed runs: ${results.length}`);

    // Show diff if we have results
    if (results.length >= 2) {
      const lastRun = results[results.length - 1];
      const prevRun = results[results.length - 2];
      console.log("\n" + "=".repeat(80));
      console.log("Difference between last two runs:");
      console.log("=".repeat(80));

      const diff = findDifferences(prevRun, lastRun);
      if (diff.newFailures.length > 0) {
        console.log(`\nNew failures (${diff.newFailures.length}):`);
        for (const test of diff.newFailures) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (diff.newSuccesses.length > 0) {
        console.log(`\nNew successes (${diff.newSuccesses.length}):`);
        for (const test of diff.newSuccesses) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (diff.consistentFailures.length > 0) {
        console.log(
          `\nConsistent failures (${diff.consistentFailures.length}):`,
        );
        for (const test of diff.consistentFailures) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (
        diff.newFailures.length === 0 &&
        diff.newSuccesses.length === 0 &&
        diff.consistentFailures.length === 0
      ) {
        console.log("\nNo differences found");
      }
    } else if (results.length === 1 && baseline) {
      // Compare with baseline if only one run completed
      console.log("\n" + "=".repeat(80));
      console.log("Difference with baseline:");
      console.log("=".repeat(80));

      const diff = findDifferences(baseline, results[0]);
      if (diff.newFailures.length > 0) {
        console.log(`\nNew failures (${diff.newFailures.length}):`);
        for (const test of diff.newFailures) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (diff.newSuccesses.length > 0) {
        console.log(`\nNew successes (${diff.newSuccesses.length}):`);
        for (const test of diff.newSuccesses) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (diff.consistentFailures.length > 0) {
        console.log(
          `\nConsistent failures (${diff.consistentFailures.length}):`,
        );
        for (const test of diff.consistentFailures) {
          console.log(`  - ${test.file}:${test.line} "${test.name}"`);
        }
      }
      if (
        diff.newFailures.length === 0 &&
        diff.newSuccesses.length === 0 &&
        diff.consistentFailures.length === 0
      ) {
        console.log("\nNo differences found");
      }
    } else {
      console.log(
        "\nNot enough runs completed to show differences (need at least 2 runs or 1 run with baseline)",
      );
    }

    process.exit(130); // Standard exit code for SIGINT
  });

  // Load baseline if exists
  let baseline: RunResult | null = null;
  if (existsSync(baselineFile)) {
    try {
      const parsed = JSON.parse(readFileSync(baselineFile, "utf-8"));
      // Convert testKeys array back to Set
      if (parsed.testKeys && Array.isArray(parsed.testKeys)) {
        parsed.testKeys = new Set(parsed.testKeys);
      } else {
        parsed.testKeys = new Set();
      }
      baseline = parsed;
      console.log("Loaded baseline from", baselineFile);
    } catch (e) {
      console.warn("Failed to load baseline:", e);
    }
  }

  // Run tests multiple times
  let previousTestKeys: Set<string> | undefined;
  for (let i = 0; i < runs; i++) {
    console.log(`\n${"=".repeat(80)}`);
    console.log(`Run ${i + 1}/${runs}`);
    console.log("=".repeat(80));

    try {
      const result = await runTests(timeout, verbose, previousTestKeys);
      results.push(result);

      // Save test keys for next run comparison
      previousTestKeys = result.testKeys;

      // Clear progress line
      if (!verbose) {
        process.stdout.write("\r" + " ".repeat(80) + "\r");
      }

      console.log(`\n${"=".repeat(80)}`);
      console.log(`Run ${i + 1} Summary:`);
      console.log(
        `  Total: ${result.totalTests}, Passed: ${result.passedTests}, Failed: ${result.failedTests}`,
      );
      console.log(`  Duration: ${(result.duration / 1000).toFixed(2)}s`);
      if (result.timedOut) {
        console.log(`  ⚠️  Timed out: ${result.timedOut}`);
      }

      // Compare test count with previous run
      if (i > 0) {
        const prevRun = results[i - 1];
        const passedDiff = result.passedTests - prevRun.passedTests;
        if (passedDiff !== 0) {
          console.log(
            `  ⚠️  Passed tests diff: ${passedDiff > 0 ? "+" : ""}${passedDiff} (prev: ${prevRun.passedTests}, current: ${result.passedTests})`,
          );
        }

        // Show symmetric difference (tests that differ between runs)
        const diffTests = prevRun.testKeys.symmetricDifference(
          result.testKeys,
        );
        if (diffTests.size > 0) {
          const missingTests = [...prevRun.testKeys].filter(
            (k) => !result.testKeys.has(k),
          );
          const newTests = [...result.testKeys].filter(
            (k) => !prevRun.testKeys.has(k),
          );

          if (missingTests.length > 0) {
            console.log(
              `  ⚠️  Tests not executed in this run: ${missingTests.length}`,
            );
            if (missingTests.length <= 10) {
              for (const key of missingTests) {
                console.log(`    - ${key}`);
              }
            } else {
              console.log(`    (showing first 10 of ${missingTests.length})`);
              for (const key of missingTests.slice(0, 10)) {
                console.log(`    - ${key}`);
              }
            }
          }

          if (newTests.length > 0) {
            console.log(`  ℹ️  New tests in this run: ${newTests.length}`);
            if (newTests.length <= 10) {
              for (const key of newTests) {
                console.log(`    + ${key}`);
              }
            } else {
              console.log(`    (showing first 10 of ${newTests.length})`);
              for (const key of newTests.slice(0, 10)) {
                console.log(`    + ${key}`);
              }
            }
          }
        }
      }

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
    // Convert Set to array for JSON serialization
    const serializable = {
      ...lastRun,
      testKeys: Array.from(lastRun.testKeys),
    };
    writeFileSync(baselineFile, JSON.stringify(serializable, null, 2));
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
          `  Consistent failures (${diff.consistentFailures.length}):`,
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
        `\nConsistent failures (${diff.consistentFailures.length}):`,
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

  const passedCounts = results.map((r) => r.passedTests);
  const successRates = results.map(
    (r) => (r.passedTests / r.totalTests) * 100,
  );
  const avgSuccessRate =
    successRates.reduce((a, b) => a + b, 0) / successRates.length;
  const timeouts = results.filter((r) => r.timedOut).length;

  console.log(`Passed tests: ${passedCounts.join(", ")}`);
  const uniquePassedCounts = new Set(passedCounts);
  if (uniquePassedCounts.size > 1) {
    console.log(
      `  ⚠️  Inconsistent passed test counts! Min: ${Math.min(...passedCounts)}, Max: ${Math.max(...passedCounts)}`,
    );
  }

  console.log(
    `Success rate: ${successRates.map((r) => r.toFixed(1) + "%").join(", ")}`,
  );
  console.log(`Average success rate: ${avgSuccessRate.toFixed(1)}%`);
  console.log(`Timeouts: ${timeouts}/${results.length}`);

  // Exit with error if there were failures, timeouts, or inconsistent test counts
  const hasFailures = results.some((r) => r.failedTests > 0 || r.timedOut);
  const hasInconsistentCounts = uniquePassedCounts.size > 1;
  process.exit(hasFailures || hasInconsistentCounts ? 1 : 0);
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
