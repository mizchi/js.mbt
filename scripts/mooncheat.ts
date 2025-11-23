#!/usr/bin/env node
/**
 * mooncheat - MoonBit cheatsheet and reference CLI tool
 *
 * Usage:
 *   mooncheat pkg --all
 *   mooncheat pkg --search json
 *   mooncheat pkg --search moonbitlang/core
 */

import { join } from "node:path";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { homedir } from "node:os";

interface PackageInfo {
  name: string;
  version: string;
  readme?: string;
  repository?: string;
  license?: string;
  keywords?: string[];
  description?: string;
  checksum: string;
  created_at: string;
}

interface PackageEntry {
  name: string;
  latestVersion: string;
  description: string;
  repository: string;
  keywords: string[];
  license: string;
}

function getRegistryPath(): string {
  const home = homedir();
  if (!home) {
    throw new Error("Cannot determine home directory");
  }
  return join(home, ".moon", "registry", "index", "user");
}

function collectPackages(): Map<string, PackageEntry> {
  const registryPath = getRegistryPath();

  if (!existsSync(registryPath)) {
    throw new Error(`Registry path not found: ${registryPath}`);
  }

  const packages = new Map<string, PackageEntry>();

  // Read all user directories
  const userEntries = readdirSync(registryPath, { withFileTypes: true });
  for (const userEntry of userEntries) {
    if (!userEntry.isDirectory()) continue;

    const userPath = join(registryPath, userEntry.name);

    // Read all .index files in user directory
    const pkgEntries = readdirSync(userPath, { withFileTypes: true });
    for (const pkgEntry of pkgEntries) {
      if (!pkgEntry.name.endsWith(".index")) continue;

      const indexPath = join(userPath, pkgEntry.name);
      const content = readFileSync(indexPath, "utf-8");

      // Each line is a JSON object representing a version
      const lines = content.trim().split("\n");
      let latestInfo: PackageInfo | null = null;

      for (const line of lines) {
        if (!line.trim()) continue;

        try {
          const info: PackageInfo = JSON.parse(line);

          // Keep only the latest version (last entry)
          if (!latestInfo || compareVersions(info.version, latestInfo.version) > 0) {
            latestInfo = info;
          }
        } catch (err) {
          console.error(`Failed to parse ${indexPath}:`, err);
        }
      }

      if (latestInfo) {
        packages.set(latestInfo.name, {
          name: latestInfo.name,
          latestVersion: latestInfo.version,
          description: latestInfo.description || "",
          repository: latestInfo.repository || "",
          keywords: latestInfo.keywords || [],
          license: latestInfo.license || "",
        });
      }
    }
  }

  return packages;
}

function compareVersions(v1: string, v2: string): number {
  const parts1 = v1.split(".").map(Number);
  const parts2 = v2.split(".").map(Number);

  for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
    const p1 = parts1[i] || 0;
    const p2 = parts2[i] || 0;
    if (p1 > p2) return 1;
    if (p1 < p2) return -1;
  }
  return 0;
}

function generateMarkdown(packages: Map<string, PackageEntry>): string {
  const sortedPackages = Array.from(packages.values()).sort((a, b) =>
    a.name.localeCompare(b.name)
  );

  // Group by category (based on keywords or package name)
  const categories = new Map<string, PackageEntry[]>();

  for (const pkg of sortedPackages) {
    const category = categorizePackage(pkg);
    if (!categories.has(category)) {
      categories.set(category, []);
    }
    categories.get(category)!.push(pkg);
  }

  let md = `# MoonBit Libraries Reference

Generated from \`~/.moon/registry/index/\` on ${new Date().toISOString().split('T')[0]}

Total packages: ${packages.size}

`;

  // Add table of contents
  md += `## Categories\n\n`;
  for (const [category] of Array.from(categories.entries()).sort()) {
    md += `- [${category}](#${category.toLowerCase().replace(/\s+/g, '-')})\n`;
  }
  md += `\n---\n\n`;

  // Add each category
  for (const [category, pkgs] of Array.from(categories.entries()).sort()) {
    md += `## ${category}\n\n`;
    md += `| Package | Version | Description | Repository |\n`;
    md += `|---------|---------|-------------|------------|\n`;

    for (const pkg of pkgs) {
      const repo = pkg.repository
        ? `[🔗](${pkg.repository})`
        : '-';
      const desc = pkg.description || '-';
      md += `| \`${pkg.name}\` | ${pkg.latestVersion} | ${desc} | ${repo} |\n`;
    }
    md += `\n`;
  }

  // Add usage instructions
  md += `## Usage\n\n`;
  md += `Add to your \`moon.pkg.json\`:\n\n`;
  md += `\`\`\`json\n`;
  md += `{\n`;
  md += `  "import": [\n`;
  md += `    "username/package"\n`;
  md += `  ]\n`;
  md += `}\n`;
  md += `\`\`\`\n\n`;
  md += `Install dependencies:\n\n`;
  md += `\`\`\`bash\n`;
  md += `moon install\n`;
  md += `\`\`\`\n`;

  return md;
}

function categorizePackage(pkg: PackageEntry): string {
  const keywords = pkg.keywords.map(k => k.toLowerCase());
  const name = pkg.name.toLowerCase();

  // Categorize based on keywords
  if (keywords.some(k => k.includes('web') || k.includes('http') || k.includes('fetch'))) {
    return 'Web & HTTP';
  }
  if (keywords.some(k => k.includes('json') || k.includes('xml') || k.includes('yaml'))) {
    return 'Data Formats';
  }
  if (keywords.some(k => k.includes('test') || k.includes('testing'))) {
    return 'Testing';
  }
  if (keywords.some(k => k.includes('math') || k.includes('numeric'))) {
    return 'Math & Algorithms';
  }
  if (keywords.some(k => k.includes('parse') || k.includes('parser') || k.includes('scanning'))) {
    return 'Parsing & Scanning';
  }
  if (keywords.some(k => k.includes('ui') || k.includes('dom') || k.includes('react'))) {
    return 'UI & DOM';
  }
  if (keywords.some(k => k.includes('crypto') || k.includes('hash'))) {
    return 'Cryptography';
  }
  if (keywords.some(k => k.includes('data structure') || k.includes('collection'))) {
    return 'Data Structures';
  }

  // Categorize based on package name
  if (name.includes('moonbitlang/core')) {
    return 'Core Libraries';
  }

  return 'Utilities';
}

interface ParsedArgs {
  subcommand: string | null;
  all: boolean;
  search: string | null;
  builtinSymbols: boolean;
  pkgs: boolean;
  symbols: boolean;
  mbtiArgs: string[];
}

function parseArgs(): ParsedArgs {
  const args = process.argv.slice(2);
  const subcommand = args[0] || null;
  let all = false;
  let search: string | null = null;
  let builtinSymbols = false;
  let pkgs = false;
  let symbols = false;
  const mbtiArgs: string[] = [];

  // Parse options after subcommand
  for (let i = 1; i < args.length; i++) {
    if (args[i] === "--all") {
      all = true;
    } else if (args[i] === "--search" && i + 1 < args.length) {
      search = args[i + 1];
      i++;
    } else if (args[i] === "--builtin-symbols") {
      builtinSymbols = true;
    } else if (args[i] === "--pkgs") {
      pkgs = true;
    } else if (args[i] === "--symbols") {
      symbols = true;
    } else if (args[i] === "mbti" && i + 1 < args.length) {
      // Collect all remaining args as mbti package names
      mbtiArgs.push(...args.slice(i + 1));
      break;
    }
  }

  return { subcommand, all, search, builtinSymbols, pkgs, symbols, mbtiArgs };
}

function printPackages(packages: Map<string, PackageEntry>, query?: string) {
  const sortedPackages = Array.from(packages.values())
    .filter((pkg) => !query || pkg.name.toLowerCase().includes(query.toLowerCase()))
    .sort((a, b) => a.name.localeCompare(b.name));

  if (sortedPackages.length === 0) {
    console.log("No packages found.");
    return;
  }

  console.log(`Found ${sortedPackages.length} package(s):\n`);

  for (const pkg of sortedPackages) {
    console.log(`${pkg.name} (v${pkg.latestVersion})`);
    if (pkg.description) {
      console.log(`  Description: ${pkg.description}`);
    }
    if (pkg.repository) {
      console.log(`  Repository: ${pkg.repository}`);
    }
    if (pkg.keywords.length > 0) {
      console.log(`  Keywords: ${pkg.keywords.join(", ")}`);
    }
    if (pkg.license) {
      console.log(`  License: ${pkg.license}`);
    }
    console.log();
  }
}

function showUsage() {
  console.log(`mooncheat - MoonBit cheatsheet and reference CLI

Usage:
  mooncheat pkg --all
  mooncheat pkg --search <query>
  mooncheat core --builtin-symbols
  mooncheat core --pkgs
  mooncheat core mbti <pkg>
  mooncheat self --symbols

Subcommands:
  pkg                Browse MoonBit packages from registry
  core               Browse core library (builtin)
  self               Browse current project

Package Options:
  --all              Show all available packages
  --search <query>   Search packages by name (partial match)

Core Options:
  --builtin-symbols  Show all builtin symbols
  --pkgs             List all core packages
  mbti <pkg>         Show .mbti file for a core package

Self Options:
  --symbols          Show symbols in current project

Examples:
  mooncheat pkg --all
  mooncheat pkg --search json
  mooncheat core --builtin-symbols
  mooncheat core --pkgs
  mooncheat core mbti builtin
  mooncheat self --symbols
`);
}

function getCoreLibPath(): string {
  const home = homedir();
  if (!home) {
    throw new Error("Cannot determine home directory");
  }
  return join(home, ".moon", "lib", "core");
}

function handleCoreCommand(builtinSymbols: boolean, pkgs: boolean, mbtiArgs: string[]) {
  const coreLibPath = getCoreLibPath();

  if (!existsSync(coreLibPath)) {
    console.error(`Error: Core library path not found: ${coreLibPath}`);
    process.exit(1);
  }

  if (builtinSymbols) {
    // Show builtin symbols from core library
    const symbols = collectCoreSymbols(coreLibPath);
    console.log(`Found ${symbols.length} builtin symbols:\n`);
    for (const symbol of symbols) {
      console.log(symbol);
    }
  } else if (pkgs) {
    // List core packages
    const packages = listCorePackages(coreLibPath);
    console.log(`Core packages (${packages.length}):\n`);
    for (const pkg of packages) {
      console.log(`  ${pkg}`);
    }
  } else if (mbtiArgs.length > 0) {
    // Show .mbti file for specific package
    const pkgName = mbtiArgs[0];
    showCoreMbti(coreLibPath, pkgName);
  } else {
    console.error('Error: core command requires --builtin-symbols, --pkgs, or mbti <pkg>\n');
    showUsage();
    process.exit(1);
  }
}

function collectCoreSymbols(coreLibPath: string): string[] {
  const symbols: string[] = [];

  function walkDir(dir: string, prefix: string = "") {
    const entries = readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = join(dir, entry.name);

      if (entry.isDirectory()) {
        const pkgName = prefix ? `${prefix}/${entry.name}` : entry.name;
        walkDir(fullPath, pkgName);
      } else if (entry.name.endsWith(".mbti")) {
        const pkgName = prefix || entry.name.replace(".mbti", "");
        const content = readFileSync(fullPath, "utf-8");
        const pkgSymbols = extractSymbolsFromMbti(content, pkgName);
        symbols.push(...pkgSymbols);
      }
    }
  }

  walkDir(coreLibPath);
  return symbols.sort();
}

function extractSymbolsFromMbti(content: string, pkgName: string): string[] {
  const symbols: string[] = [];
  const lines = content.split('\n');

  for (const line of lines) {
    const trimmed = line.trim();
    // Extract function signatures, types, structs, etc.
    if (trimmed.startsWith('pub fn') ||
        trimmed.startsWith('pub struct') ||
        trimmed.startsWith('pub enum') ||
        trimmed.startsWith('pub type') ||
        trimmed.startsWith('pub trait')) {
      // Extract the name
      const match = trimmed.match(/pub\s+(?:fn|struct|enum|type|trait)\s+(\w+)/);
      if (match) {
        symbols.push(`${pkgName}::${match[1]}`);
      }
    }
  }

  return symbols;
}

function listCorePackages(coreLibPath: string): string[] {
  const packages: string[] = [];

  function walkDir(dir: string, prefix: string = "") {
    const entries = readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
      if (entry.isDirectory()) {
        const pkgName = prefix ? `${prefix}/${entry.name}` : entry.name;
        packages.push(pkgName);
        walkDir(join(dir, entry.name), pkgName);
      }
    }
  }

  walkDir(coreLibPath);
  return packages.sort();
}

function showCoreMbti(coreLibPath: string, pkgName: string) {
  // Try to find the .mbti file for the package
  const possiblePaths = [
    join(coreLibPath, pkgName, `pkg.generated.mbti`),
    join(coreLibPath, pkgName, `${pkgName.split('/').pop()}.mbti`),
    join(coreLibPath, pkgName, `lib.mbti`),
    join(coreLibPath, `${pkgName}.mbti`),
  ];

  for (const path of possiblePaths) {
    if (existsSync(path)) {
      const content = readFileSync(path, "utf-8");
      console.log(`// ${pkgName} (${path})\n`);
      console.log(content);
      return;
    }
  }

  console.error(`Error: .mbti file not found for package: ${pkgName}`);
  console.error(`Searched paths:`);
  for (const path of possiblePaths) {
    console.error(`  - ${path}`);
  }
  process.exit(1);
}

function handleSelfCommand(symbols: boolean) {
  if (symbols) {
    // Show symbols from current project
    const projectSymbols = collectProjectSymbols();
    console.log(`Found ${projectSymbols.length} project symbols:\n`);
    for (const symbol of projectSymbols) {
      console.log(symbol);
    }
  } else {
    console.error('Error: self command requires --symbols\n');
    showUsage();
    process.exit(1);
  }
}

function collectProjectSymbols(): string[] {
  const symbols: string[] = [];
  const cwd = process.cwd();

  function walkDir(dir: string, prefix: string = "") {
    if (!existsSync(dir)) return;

    const entries = readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = join(dir, entry.name);

      // Skip common directories
      if (entry.isDirectory() && ['node_modules', '.git', 'target'].includes(entry.name)) {
        continue;
      }

      if (entry.isDirectory()) {
        walkDir(fullPath, entry.name);
      } else if (entry.name.endsWith(".mbti")) {
        const pkgName = prefix || entry.name.replace(".mbti", "");
        const content = readFileSync(fullPath, "utf-8");
        const pkgSymbols = extractSymbolsFromMbti(content, pkgName);
        symbols.push(...pkgSymbols);
      }
    }
  }

  walkDir(cwd);
  return symbols.sort();
}

function handlePkgCommand(all: boolean, search: string | null) {
  if (!all && !search) {
    console.error('Error: pkg command requires --all or --search option\n');
    showUsage();
    process.exit(1);
  }

  const packages = collectPackages();

  if (all) {
    printPackages(packages);
  } else if (search) {
    printPackages(packages, search);
  }
}

function main() {
  // Ignore EPIPE errors (when output is piped to head, etc.)
  process.stdout.on('error', (err) => {
    if (err.code === 'EPIPE') {
      process.exit(0);
    }
    throw err;
  });

  const { subcommand, all, search, builtinSymbols, pkgs, symbols, mbtiArgs } = parseArgs();

  if (!subcommand) {
    showUsage();
    process.exit(1);
  }

  switch (subcommand) {
    case 'pkg':
      handlePkgCommand(all, search);
      break;
    case 'core':
      handleCoreCommand(builtinSymbols, pkgs, mbtiArgs);
      break;
    case 'self':
      handleSelfCommand(symbols);
      break;
    default:
      console.error(`Error: Unknown subcommand '${subcommand}'\n`);
      showUsage();
      process.exit(1);
  }
}

main();
