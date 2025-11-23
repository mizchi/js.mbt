#!/usr/bin/env node
/**
 * Generate MoonBit library cheatsheet from registry index
 *
 * Usage:
 *   node scripts/generate_library_cheatsheet.ts
 *   # or with tsx
 *   tsx scripts/generate_library_cheatsheet.ts
 */

import { join } from "node:path";
import { existsSync, readFileSync, writeFileSync, readdirSync } from "node:fs";
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

function main() {
  console.log("Collecting packages from ~/.moon/registry/index/...");
  const packages = collectPackages();

  console.log(`Found ${packages.size} packages`);

  const markdown = generateMarkdown(packages);

  const outputPath = "docs/moonbit_libraries.md";
  writeFileSync(outputPath, markdown, "utf-8");

  console.log(`✅ Generated: ${outputPath}`);
}

main();
