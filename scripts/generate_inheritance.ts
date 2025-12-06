#!/usr/bin/env node

/**
 * 継承関係の自動生成スクリプト（汎用版）
 *
 * 各型の継承関係を解析して、親クラスのメソッドを子クラスで直接呼べるように
 * ラッパーメソッドを生成します。
 *
 * 例: element.appendChild(...) の代わりに element.as_node().appendChild(...) と書く必要がない
 */

import { readFile, writeFile, readdir, unlink } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { exec } from "node:child_process";
import { promisify } from "node:util";
import { hierarchies, type InheritanceChain, type HierarchyConfig } from "./inheritance-config.js";

const execAsync = promisify(exec);

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const projectRoot = join(__dirname, "..");

// メソッド定義のパース
type MethodSignature = {
  name: string;
  params: string;
  returnType: string;
  isAsync: boolean;
  alias?: string;
};

/**
 * ソースファイルからpublicメソッドを抽出
 */
async function extractPublicMethods(
  filePath: string,
  typeName: string,
  skipPatterns: RegExp[]
): Promise<MethodSignature[]> {
  try {
    const fullPath = join(projectRoot, filePath);
    const content = await readFile(fullPath, "utf-8");
    const methods: MethodSignature[] = [];

    // メソッド定義の正規表現
    // pub (async)? fn TypeName::methodName(self : Self, params) -> ReturnType
    const methodRegex = new RegExp(
      `(#alias\\((\\w+)\\)\\s+)?pub (async )?fn ${typeName}::(\\w+)\\(([^)]*)\\)\\s*->\\s*([^{=]+)`,
      'g'
    );

    let match;
    while ((match = methodRegex.exec(content)) !== null) {
      const fullMatch = match[0];

      // スキップパターンに一致する場合はスキップ
      if (skipPatterns.some(pattern => pattern.test(fullMatch))) {
        continue;
      }

      const alias = match[2];
      const isAsync = match[3] === 'async ';
      const methodName = match[4];
      const params = match[5];
      const returnType = match[6].trim();

      // self: Self パラメータを除外
      const filteredParams = params
        .split(',')
        .filter(p => !p.trim().startsWith('self'))
        .map(p => p.trim())
        .filter(p => p.length > 0)
        .join(', ');

      methods.push({
        name: methodName,
        params: filteredParams,
        returnType,
        isAsync,
        alias,
      });
    }

    return methods;
  } catch (error: any) {
    if (error.code === 'ENOENT') {
      console.warn(`Warning: File not found: ${filePath}`);
      return [];
    }
    throw error;
  }
}

/**
 * ターゲット型に既に存在するメソッドを抽出
 */
async function extractExistingMethods(
  filePath: string,
  typeName: string
): Promise<Set<string>> {
  try {
    const fullPath = join(projectRoot, filePath);
    const content = await readFile(fullPath, "utf-8");
    const existingMethods = new Set<string>();

    // メソッド名を抽出
    const methodRegex = new RegExp(
      `pub (?:async )?fn ${typeName}::(\\w+)\\(`,
      'g'
    );

    let match;
    while ((match = methodRegex.exec(content)) !== null) {
      existingMethods.add(match[1]);
    }

    return existingMethods;
  } catch (error: any) {
    if (error.code === 'ENOENT') {
      return new Set();
    }
    throw error;
  }
}

/**
 * 型の全ての祖先型を取得
 */
function getAncestors(typeName: string, hierarchy: InheritanceChain[]): InheritanceChain[] {
  const ancestors: InheritanceChain[] = [];
  let current = hierarchy.find(t => t.typeName === typeName);

  while (current?.extends) {
    const parent = hierarchy.find(t => t.typeName === current!.extends);
    if (!parent) break;
    ancestors.push(parent);
    current = parent;
  }

  return ancestors;
}

/**
 * ラッパーメソッドを生成
 */
function generateWrapperMethod(
  targetType: string,
  method: MethodSignature,
  parentType: string,
  castChain: string[]
): string {
  const asyncPrefix = method.isAsync ? 'async ' : '';
  const aliasAttr = method.alias ? `#alias(${method.alias})\n` : '';

  // パラメータリストの生成
  const selfParam = 'self : Self';
  const fullParams = method.params
    ? `${selfParam}, ${method.params}`
    : selfParam;

  // 引数名の抽出（型を除く）
  const paramNames = method.params
    .split(',')
    .map(p => {
      const match = p.trim().match(/^(\w+)\s*:/);
      return match ? match[1] : '';
    })
    .filter(n => n.length > 0)
    .join(', ');

  // キャストチェーンの構築
  const castExpression = castChain.length > 0
    ? castChain.map(c => `.${c}()`).join('')
    : '';

  // 引数付きの呼び出し
  const methodCall = paramNames
    ? `self${castExpression}.${method.name}(${paramNames})`
    : `self${castExpression}.${method.name}()`;

  return `///|
/// Inherited from ${parentType}
${aliasAttr}pub ${asyncPrefix}fn ${targetType}::${method.name}(${fullParams}) -> ${method.returnType} {
  ${methodCall}
}`;
}

/**
 * 型のキャストチェーンを取得
 */
function getCastChain(fromType: string, toType: string, hierarchy: InheritanceChain[]): string[] {
  const chain: string[] = [];

  let current = hierarchy.find(t => t.typeName === fromType);
  while (current && current.typeName !== toType) {
    if (current.castMethod) {
      chain.push(current.castMethod);
    }
    current = hierarchy.find(t => t.typeName === current!.extends);
  }

  return chain;
}

/**
 * 型の継承メソッドを生成
 */
async function generateInheritedMethods(
  typeName: string,
  targetFile: string | undefined,
  config: HierarchyConfig
): Promise<string> {
  const ancestors = getAncestors(typeName, config.types);
  const sections: string[] = [];

  // 既存のメソッドを取得（重複を避けるため）
  const existingMethods = targetFile
    ? await extractExistingMethods(targetFile, typeName)
    : new Set<string>();

  // 生成済みのメソッド名を追跡（同一型内での重複を防ぐ）
  const generatedMethods = new Set<string>();

  for (const ancestor of ancestors) {
    const methods = await extractPublicMethods(
      ancestor.sourceFile,
      ancestor.typeName,
      config.skipPatterns
    );

    if (methods.length === 0) continue;

    const castChain = getCastChain(typeName, ancestor.typeName, config.types);

    for (const method of methods) {
      // 既に存在する、または既に生成したメソッドはスキップ
      if (existingMethods.has(method.name) || generatedMethods.has(method.name)) {
        continue;
      }

      const wrapper = generateWrapperMethod(
        typeName,
        method,
        ancestor.typeName,
        castChain
      );
      sections.push(wrapper);
      generatedMethods.add(method.name);
    }
  }

  return sections.join('\n\n');
}

/**
 * 指定ディレクトリの古い生成ファイルを削除
 */
async function cleanOldGeneratedFiles(outputDir: string) {
  try {
    const fullPath = join(projectRoot, outputDir);
    const files = await readdir(fullPath);
    const generatedFiles = files.filter(f => f.startsWith('_generated_') && f.endsWith('.mbt'));

    for (const file of generatedFiles) {
      await unlink(join(fullPath, file));
      console.log(`  🗑️  Removed old file: ${outputDir}/${file}`);
    }
  } catch (error: any) {
    if (error.code !== 'ENOENT') {
      throw error;
    }
  }
}

/**
 * 単一の階層設定を処理
 */
async function processHierarchy(config: HierarchyConfig) {
  console.log(`\n📦 Processing ${config.name} hierarchy...`);

  // 古い生成ファイルを削除
  await cleanOldGeneratedFiles(config.outputDir);

  // 各基底型の継承メソッドを生成
  const baseTypes = config.types.filter(t =>
    t.extends &&
    !t.sourceFile.includes('html_elements.mbt') &&
    !t.sourceFile.includes('svg_elements.mbt')
  );

  for (const type of baseTypes) {
    const methods = await generateInheritedMethods(type.typeName, undefined, config);
    if (methods) {
      // CamelCase を snake_case に変換（連続する大文字に対応）
      const snakeCaseName = type.typeName
        .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')  // HTMLElement -> HTML_Element
        .replace(/([a-z])([A-Z])/g, '$1_$2')        // camelCase -> camel_Case
        .toLowerCase();

      const fileName = `_generated_${snakeCaseName}.mbt`;
      const outputPath = join(projectRoot, config.outputDir, fileName);
      const content = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_inheritance.ts

${methods}
`;
      await writeFile(outputPath, content, "utf-8");
      console.log(`  ✅ Generated: ${config.outputDir}/${fileName}`);
    }
  }

  // HTML要素やSVG要素などのグループ化された型を処理
  const htmlElements = config.types.filter(t =>
    t.sourceFile.includes('html_elements.mbt') && t.extends
  );

  if (htmlElements.length > 0) {
    let allElementsContent = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_inheritance.ts

`;

    for (const elementType of htmlElements) {
      const methods = await generateInheritedMethods(
        elementType.typeName,
        elementType.sourceFile,
        config
      );
      if (methods) {
        allElementsContent += `///| ${elementType.typeName} inherited methods\n\n${methods}\n\n`;
      }
    }

    const fileName = "_generated_html_elements.mbt";
    await writeFile(
      join(projectRoot, config.outputDir, fileName),
      allElementsContent,
      "utf-8"
    );
    console.log(`  ✅ Generated: ${config.outputDir}/${fileName}`);
  }

  // SVG要素の処理
  const svgElements = config.types.filter(t =>
    t.sourceFile.includes('svg_elements.mbt') && t.extends
  );

  if (svgElements.length > 0) {
    let allSvgElementsContent = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_inheritance.ts

`;

    for (const elementType of svgElements) {
      const methods = await generateInheritedMethods(
        elementType.typeName,
        elementType.sourceFile,
        config
      );
      if (methods) {
        allSvgElementsContent += `///| ${elementType.typeName} inherited methods\n\n${methods}\n\n`;
      }
    }

    const fileName = "_generated_svg_elements.mbt";
    await writeFile(
      join(projectRoot, config.outputDir, fileName),
      allSvgElementsContent,
      "utf-8"
    );
    console.log(`  ✅ Generated: ${config.outputDir}/${fileName}`);
  }
}

/**
 * メイン処理
 */
async function main() {
  console.log("🚀 Generating inheritance wrappers...");

  // コマンドライン引数から特定の階層を指定可能
  const targetHierarchy = process.argv[2];

  const configsToProcess = targetHierarchy
    ? hierarchies.filter(h => h.name === targetHierarchy)
    : hierarchies;

  if (configsToProcess.length === 0) {
    console.error(`❌ Hierarchy "${targetHierarchy}" not found`);
    console.log(`Available hierarchies: ${hierarchies.map(h => h.name).join(', ')}`);
    process.exit(1);
  }

  for (const config of configsToProcess) {
    await processHierarchy(config);
  }

  // 生成後にフォーマット
  console.log("\n🎨 Formatting generated files...");
  try {
    await execAsync("moon fmt", { cwd: projectRoot });
    console.log("✅ Formatting complete");
  } catch (error: any) {
    console.warn("⚠️  Formatting failed:", error.message);
  }

  console.log("\n✨ All done!");
}

main().catch(console.error);
