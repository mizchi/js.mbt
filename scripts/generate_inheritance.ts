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
import { hierarchies, type InheritanceChain, type HierarchyConfig } from "./inheritance-config.ts";

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
 * `open` にある `(` に対応する `)` の位置を返す（入れ子対応）。
 * 見つからなければ -1。
 *
 * パラメータリストには `handler : (@core.Any) -> Unit` のような関数型が
 * 現れるため、`[^)]*` では最初の `)` で切れてしまう。
 */
function findMatchingParen(source: string, open: number): number {
  let depth = 0;
  for (let i = open; i < source.length; i++) {
    const c = source[i];
    if (c === "(") depth++;
    else if (c === ")") {
      depth--;
      if (depth === 0) return i;
    }
  }
  return -1;
}

/**
 * `-> ` の直後から戻り値型を読み取る。
 * ネストの外側に現れた最初の `{`（本体）または `=`（`= "%identity"` 等）で終端。
 */
function takeReturnType(source: string): string {
  let depth = 0;
  for (let i = 0; i < source.length; i++) {
    const c = source[i];
    if (c === "(" || c === "[") depth++;
    else if (c === ")" || c === "]") depth--;
    else if (depth === 0 && (c === "{" || c === "=")) return source.slice(0, i);
  }
  return source;
}

/**
 * ソースファイルが定義している public な型名を集める。
 *
 * 祖先型が出力先とは別パッケージにある場合、そのメソッドシグネチャに現れる
 * 非修飾の型名（`Event` 等）は出力先では解決できないため、修飾子を付ける
 * 必要がある。その対象を知るために使う。
 */
function collectDeclaredTypes(content: string): Set<string> {
  const names = new Set<string>();
  const declRegex =
    /^\s*pub(?:\(all\))?\s+(?:type|struct|enum|trait)!?\s+(\w+)/gm;
  let m;
  while ((m = declRegex.exec(content)) !== null) {
    names.add(m[1]);
  }
  return names;
}

/**
 * 型式に現れる `declared` の型名を `alias.` で修飾する。
 * 既に `@pkg.` が付いているもの、単語の一部であるものは触らない。
 */
function qualifyTypes(
  typeExpr: string,
  declared: Set<string>,
  alias: string
): string {
  if (declared.size === 0 || alias === "") return typeExpr;
  return typeExpr.replace(/(@[\w/]+\.)?\b([A-Z]\w*)\b/g, (whole, pkg, name) => {
    if (pkg) return whole; // 既に修飾済み
    if (!declared.has(name)) return whole;
    return `${alias}.${name}`;
  });
}

/**
 * パラメータリストをトップレベルの `,` で分割する（入れ子対応）。
 * `f : (Int, String) -> Unit` を 1 つのパラメータとして保つため、
 * 素朴な `split(",")` は使えない。
 */
function splitParams(params: string): string[] {
  const out: string[] = [];
  let depth = 0;
  let start = 0;
  for (let i = 0; i < params.length; i++) {
    const c = params[i];
    if (c === "(" || c === "[") depth++;
    else if (c === ")" || c === "]") depth--;
    else if (c === "," && depth === 0) {
      out.push(params.slice(start, i));
      start = i + 1;
    }
  }
  out.push(params.slice(start));
  return out.map((p) => p.trim()).filter((p) => p.length > 0);
}

/**
 * ソースファイルからpublicメソッドを抽出
 */
async function extractPublicMethods(
  filePath: string,
  typeName: string,
  skipPatterns: RegExp[],
  /**
   * 祖先型が出力先とは別パッケージにある場合の修飾子（例: `@event`）。
   * 空文字なら同一パッケージなので修飾しない。
   */
  qualifier: string = ""
): Promise<MethodSignature[]> {
  try {
    const fullPath = join(projectRoot, filePath);
    const content = await readFile(fullPath, "utf-8");
    const methods: MethodSignature[] = [];
    const declared = qualifier ? collectDeclaredTypes(content) : new Set<string>();

    // メソッドのヘッダだけを正規表現で探し、パラメータリストと戻り値型は
    // 括弧の対応を数えて切り出す（関数型パラメータやトップレベル以外の `,`
    // を正しく扱うため）。
    // pub (async)? (extern "js")? fn TypeName::methodName(
    const headerRegex = new RegExp(
      `(#alias\\((\\w+)\\)\\s+)?pub (async )?(extern "js" )?fn ${typeName}::(\\w+)\\(`,
      'g'
    );

    let match;
    while ((match = headerRegex.exec(content)) !== null) {
      const alias = match[2];
      const isAsync = match[3] === 'async ';
      // match[4] is extern "js" (optional)
      const methodName = match[5];

      // マッチ末尾の `(` から対応する `)` までがパラメータリスト
      const openParen = match.index + match[0].length - 1;
      const closeParen = findMatchingParen(content, openParen);
      if (closeParen === -1) continue;
      const params = content.slice(openParen + 1, closeParen);

      // `)` の直後は `-> 戻り値型`
      const afterParams = content.slice(closeParen + 1);
      const arrow = afterParams.match(/^\s*->\s*/);
      if (!arrow) continue;
      const returnType = takeReturnType(
        afterParams.slice(arrow[0].length)
      ).trim();

      // スキップパターンはシグネチャ全体に対して評価する
      const fullMatch = content.slice(
        match.index,
        closeParen + 1 + arrow[0].length + returnType.length
      );
      if (skipPatterns.some(pattern => pattern.test(fullMatch))) {
        continue;
      }

      const splitted = splitParams(params);

      // selfパラメータがないメソッド（静的メソッド）はスキップ
      if (!splitted.some(p => p.startsWith('self'))) {
        continue;
      }

      // self: Self パラメータを除外し、別パッケージ由来の型を修飾する
      const filteredParams = splitted
        .filter(p => !p.startsWith('self'))
        .map(p => qualifyTypes(p, declared, qualifier))
        .join(', ');

      methods.push({
        name: methodName,
        params: filteredParams,
        returnType: qualifyTypes(returnType, declared, qualifier),
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
  // オプショナルパラメータの呼び出し:
  // - デフォルト値なし（param? : Type）: param? で渡す
  // - デフォルト値あり（param? : Type = default）: param~ で渡す
  const paramNames = splitParams(method.params)
    .map(trimmed => {
      // パラメータ名、オプショナル?、型、デフォルト値を抽出
      const match = trimmed.match(/^(\w+)(\??)(\s*:\s*[^=]+)(=.*)?$/);
      if (!match) return '';
      const paramName = match[1];
      const isOptional = match[2] === '?';
      const hasDefault = match[4] !== undefined;
      if (!isOptional) return paramName;
      // デフォルト値ありなら ~ 記法、なしなら ? 記法
      return hasDefault ? `${paramName}~` : `${paramName}?`;
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

  // 継承ラッパーでは @core.identity は不要（MoonBit の型システムが自動解決）
  const finalMethodCall = methodCall;

  return `///|
/// Inherited from ${parentType}
${aliasAttr}pub ${asyncPrefix}fn ${targetType}::${method.name}(${fullParams}) -> ${method.returnType} {
  ${finalMethodCall}
}`;
}

/**
 * アップキャスト用の cast_from_* メソッドを生成
 * 例: HTMLDivElement::cast_from_node(node: Node) -> HTMLDivElement
 */
function generateCastFromMethods(
  typeName: string,
  hierarchy: InheritanceChain[]
): string[] {
  const methods: string[] = [];
  const ancestors = getAncestors(typeName, hierarchy);

  for (const ancestor of ancestors) {
    // snake_case に変換
    const snakeCaseName = ancestor.typeName
      .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
      .replace(/([a-z])([A-Z])/g, '$1_$2')
      .toLowerCase();

    // パッケージ修飾子付きの型名を使用（外部パッケージの型の場合）
    const paramTypeName = ancestor.qualifiedTypeName || ancestor.typeName;

    methods.push(`///|
/// Upcast from ${ancestor.typeName} to ${typeName}
pub fn ${typeName}::cast_from_${snakeCaseName}(value : ${paramTypeName}) -> ${typeName} = "%identity"`);
  }

  return methods;
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

  // cast_from_* メソッドを先に追加
  const castFromMethods = generateCastFromMethods(typeName, config.types);
  sections.push(...castFromMethods);

  // 既存のメソッドを取得（重複を避けるため）
  const existingMethods = targetFile
    ? await extractExistingMethods(targetFile, typeName)
    : new Set<string>();

  // 生成済みのメソッド名を追跡（同一型内での重複を防ぐ）
  const generatedMethods = new Set<string>();

  for (const ancestor of ancestors) {
    // 祖先が別パッケージにある (qualifiedTypeName が設定されている) 場合、
    // そのシグネチャに現れる非修飾の型名を同じ alias で修飾する。
    const ancestorAlias = ancestor.qualifiedTypeName
      ? ancestor.qualifiedTypeName.slice(
          0,
          ancestor.qualifiedTypeName.lastIndexOf(".")
        )
      : "";
    const methods = await extractPublicMethods(
      ancestor.sourceFile,
      ancestor.typeName,
      config.skipPatterns,
      ancestorAlias
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
 * 生成結果が使っているパッケージ alias が出力先の moon.pkg に import されて
 * いるか確認し、不足していれば警告する。
 *
 * 別パッケージの祖先型を追加すると、そのシグネチャに現れる型 (`@js_async`
 * 等) の import が出力先に必要になる。生成器は moon.pkg を書き換えないので、
 * 気付かないまま `moon check` が落ちるのを防ぐ。
 */
async function warnMissingImports(outputDir: string) {
  let pkg: string;
  try {
    pkg = await readFile(join(projectRoot, outputDir, "moon.pkg"), "utf-8");
  } catch {
    return;
  }

  // `"path" @alias,` なら alias、`"path",` ならパス末尾がデフォルト alias
  const imported = new Set<string>();
  for (const m of pkg.matchAll(/"([^"]+)"\s*(?:@(\w+))?\s*,/g)) {
    imported.add(m[2] ?? m[1].split("/").pop()!);
  }

  const dir = join(projectRoot, outputDir);
  const files = (await readdir(dir)).filter(
    f => f.startsWith("_generated_") && f.endsWith(".mbt")
  );

  const missing = new Map<string, string>();
  for (const file of files) {
    const content = await readFile(join(dir, file), "utf-8");
    for (const m of content.matchAll(/@(\w+)\./g)) {
      if (!imported.has(m[1]) && !missing.has(m[1])) missing.set(m[1], file);
    }
  }

  for (const [alias, file] of missing) {
    console.warn(
      `  ⚠️  ${outputDir}/moon.pkg imports nothing aliased @${alias} ` +
        `(used by ${file}) — add it or \`moon check\` will fail`
    );
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

  await warnMissingImports(config.outputDir);
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
