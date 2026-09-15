#!/usr/bin/env node --experimental-strip-types
/**
 * Workspace release publisher.
 *
 * Publishes `mizchi/js` and the split modules to mooncakes in the correct
 * order so that downstream modules can resolve the freshly-published root:
 *
 *   1. mizchi/js_core           (everything depends on it)
 *   2. moon update               (refresh registry index)
 *   3. mizchi/js                 (repo root)
 *   4. moon update
 *   5. mizchi/js_web            (js_browser / js_deno / js_node depend on it)
 *   6. moon update
 *   7. mizchi/js_browser
 *      mizchi/js_deno
 *      mizchi/js_bun
 *      mizchi/js_node
 *      mizchi/js_webextensions
 *
 * All workspace modules must already be bumped to the same version in their
 * own `moon.mod` (see CHANGELOG / release commit).
 *
 * Usage:
 *   ./scripts/release.ts                # publish everything
 *   ./scripts/release.ts --dry-run      # print steps only, run nothing
 *   ./scripts/release.ts --skip-root    # root already on mooncakes, do modules
 *   ./scripts/release.ts --only=js_deno # publish just one module (path or name)
 */

import { spawn, spawnSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { resolve, join } from "node:path";
import { fileURLToPath } from "node:url";

const REPO_ROOT = resolve(fileURLToPath(import.meta.url), "../..");

type Mod = { path: string; label: string };

const ROOT: Mod = { path: ".", label: "mizchi/js" };

// Publish order is dependency order. mizchi/js_core is the foundation that
// every other module (including the root) imports, and mizchi/js_web sits
// between the root and js_browser / js_deno / js_node. Each has to be
// resolvable on mooncakes before its dependents go up.
const CORE: Mod = { path: "modules/js_core", label: "mizchi/js_core" };
const WEB: Mod = { path: "modules/js_web", label: "mizchi/js_web" };

const MODULES: Mod[] = [
  { path: "modules/js_browser", label: "mizchi/js_browser" },
  { path: "modules/js_deno", label: "mizchi/js_deno" },
  { path: "modules/js_bun", label: "mizchi/js_bun" },
  { path: "modules/js_node", label: "mizchi/js_node" },
  { path: "modules/js_webextensions", label: "mizchi/js_webextensions" },
];

function readVersion(modPath: string): string {
  const file = join(REPO_ROOT, modPath, "moon.mod");
  const source = readFileSync(file, "utf8");
  const version = source.match(/^version\s*=\s*"([^"]+)"\s*$/m)?.[1];
  if (version === undefined) {
    throw new Error(`No version field in ${file}`);
  }
  return version;
}

function run(cmd: string, args: string[], cwd: string): void {
  console.log(`$ (${cwd}) ${cmd} ${args.join(" ")}`);
  const result = spawnSync(cmd, args, {
    cwd,
    stdio: "inherit",
  });
  if (result.status !== 0) {
    throw new Error(
      `${cmd} ${args.join(" ")} (in ${cwd}) exited with ${result.status}`,
    );
  }
}

function runCapture(
  cmd: string,
  args: string[],
  cwd: string,
): Promise<{ code: number; output: string }> {
  console.log(`$ (${cwd}) ${cmd} ${args.join(" ")}`);
  return new Promise((resolveP) => {
    const child = spawn(cmd, args, { cwd });
    let output = "";
    child.stdout.on("data", (chunk: Buffer) => {
      const s = chunk.toString();
      output += s;
      process.stdout.write(s);
    });
    child.stderr.on("data", (chunk: Buffer) => {
      const s = chunk.toString();
      output += s;
      process.stderr.write(s);
    });
    child.on("close", (code) => resolveP({ code: code ?? 1, output }));
  });
}

const DUPLICATE_VERSION_PATTERNS = [
  /409 Conflict/i,
  /is duplicated with an existing version/i,
  /Version Error: The version you are attempting to upload .* is duplicated/i,
];

function isAlreadyPublished(output: string): boolean {
  return DUPLICATE_VERSION_PATTERNS.some((re) => re.test(output));
}

async function publishOne(
  mod: Mod,
  version: string,
  dryRun: boolean,
): Promise<void> {
  console.log(`\n=== ${mod.label} @ ${version} ===`);
  if (dryRun) {
    console.log(`[dry-run] would run: moon publish (cwd=${mod.path})`);
    return;
  }
  const { code, output } = await runCapture(
    "moon",
    ["publish"],
    join(REPO_ROOT, mod.path),
  );
  if (code === 0) return;
  if (isAlreadyPublished(output)) {
    console.log(
      `[already published] ${mod.label}@${version} is on mooncakes — skipping`,
    );
    return;
  }
  throw new Error(
    `moon publish failed for ${mod.label} (exit ${code}) — see output above`,
  );
}

function moonUpdate(dryRun: boolean): void {
  console.log(`\n=== moon update (refresh registry index) ===`);
  if (dryRun) {
    console.log(`[dry-run] would run: moon update`);
    return;
  }
  run("moon", ["update"], REPO_ROOT);
}

function parseArgs(argv: string[]): {
  dryRun: boolean;
  skipRoot: boolean;
  only: string | null;
  help: boolean;
} {
  let dryRun = false;
  let skipRoot = false;
  let only: string | null = null;
  let help = false;
  for (const a of argv) {
    if (a === "--dry-run") dryRun = true;
    else if (a === "--skip-root") skipRoot = true;
    else if (a === "-h" || a === "--help") help = true;
    else if (a.startsWith("--only=")) only = a.slice("--only=".length);
    else throw new Error(`Unknown argument: ${a}`);
  }
  return { dryRun, skipRoot, only, help };
}

function printHelp(): void {
  console.log(
    `Usage: scripts/release.ts [options]

Publishes mizchi/js and the split modules to mooncakes in the correct
order. Run after bumping versions in moon.mod.json and committing the
release commit.

Options:
  --dry-run         Print the steps without invoking moon
  --skip-root       Skip publishing the root (use when mizchi/js is
                    already on mooncakes and only the *_browser/_deno/
                    _bun/_webextensions modules need a retry)
  --only=<name>     Publish a single module. Accepts a module name
                    (js_deno) or path (modules/js_deno). Skips moon
                    update; combine with --skip-root if needed.
  -h, --help        Show this help`,
  );
}

async function main(): Promise<void> {
  let opts: ReturnType<typeof parseArgs>;
  try {
    opts = parseArgs(process.argv.slice(2));
  } catch (e) {
    console.error((e as Error).message);
    printHelp();
    process.exit(2);
  }
  if (opts.help) {
    printHelp();
    return;
  }

  const all = [CORE, ROOT, WEB, ...MODULES];

  // Sanity: every workspace module must be at the same version.
  const versions = new Map<string, string>(
    all.map((m) => [m.label, readVersion(m.path)]),
  );
  const rootVersion = versions.get(ROOT.label)!;
  const mismatched = [...versions.entries()].filter(
    ([, v]) => v !== rootVersion,
  );
  if (mismatched.length > 0) {
    console.error("Version mismatch across workspace modules:");
    for (const [k, v] of versions) console.error(`  ${k}: ${v}`);
    console.error(
      "Bump every moon.mod to the same version before releasing.",
    );
    process.exit(1);
  }
  console.log(`Releasing workspace at v${rootVersion}`);

  if (opts.only !== null) {
    const want = opts.only;
    const target = all.find(
      (m) => m.path === want || m.path === `modules/${want}` || m.label === want
        || m.label === `mizchi/${want}`,
    );
    if (!target) {
      console.error(`--only target not found: ${want}`);
      console.error(`Available: ${all.map((m) => m.label).join(", ")}`);
      process.exit(1);
    }
    await publishOne(target, rootVersion, opts.dryRun);
    console.log(`\nDone. (--only=${target.label})`);
    return;
  }

  // mizchi/js_core first: the root module itself imports it.
  await publishOne(CORE, rootVersion, opts.dryRun);
  moonUpdate(opts.dryRun);

  if (!opts.skipRoot) {
    await publishOne(ROOT, rootVersion, opts.dryRun);
    moonUpdate(opts.dryRun);
  } else {
    console.log(`\n[--skip-root] skipping ${ROOT.label} publish`);
  }

  // js_browser / js_deno / js_node depend on mizchi/js_web, so it has to be
  // on mooncakes (and in the refreshed index) before they are published.
  await publishOne(WEB, rootVersion, opts.dryRun);
  moonUpdate(opts.dryRun);

  for (const mod of MODULES) {
    await publishOne(mod, rootVersion, opts.dryRun);
  }

  console.log(`\nAll modules published at v${rootVersion}.`);
  console.log(`Tag manually with:`);
  console.log(`  git tag v${rootVersion} && git push origin v${rootVersion}`);
}

main().catch((e) => {
  console.error(e instanceof Error ? e.message : String(e));
  process.exit(1);
});
