#!/usr/bin/env node

/**
 * DOM 継承関係の自動生成スクリプト
 *
 * 各型の継承関係を解析して、親クラスのメソッドを子クラスで直接呼べるように
 * ラッパーメソッドを生成します。
 *
 * 例: element.appendChild(...) の代わりに element.as_node().appendChild(...) と書く必要がない
 */

import { readFile, writeFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const projectRoot = join(__dirname, "..");

// 継承階層の定義
type InheritanceChain = {
  typeName: string;
  extends: string | null;
  castMethod: string | null; // as_node(), as_element(), etc.
  sourceFile: string; // メソッド定義のソースファイル
};

// DOM 型の継承関係
const inheritanceHierarchy: InheritanceChain[] = [
  {
    typeName: "EventTarget",
    extends: null,
    castMethod: null,
    sourceFile: "src/event/event_target.mbt"
  },
  {
    typeName: "Node",
    extends: "EventTarget",
    castMethod: "as_event_target",
    sourceFile: "src/browser/dom/node.mbt"
  },
  {
    typeName: "Element",
    extends: "Node",
    castMethod: "as_node",
    sourceFile: "src/browser/dom/element.mbt"
  },
  {
    typeName: "HTMLElement",
    extends: "Element",
    castMethod: "as_element",
    sourceFile: "src/browser/dom/html_element.mbt"
  },
  {
    typeName: "Document",
    extends: "Node",
    castMethod: "as_node",
    sourceFile: "src/browser/dom/document.mbt"
  },
];

// HTML要素の型定義
const htmlElementTypes = [
  "HTMLDivElement",
  "HTMLSpanElement",
  "HTMLBodyElement",
  "HTMLHeadElement",
  "HTMLHtmlElement",
  "HTMLAnchorElement",
  "HTMLButtonElement",
  "HTMLInputElement",
  "HTMLTextAreaElement",
  "HTMLCanvasElement",
  "HTMLIFrameElement",
  "HTMLFormElement",
  "HTMLSelectElement",
  "HTMLOptionElement",
  "HTMLLabelElement",
  "HTMLImageElement",
  "HTMLParagraphElement",
  "HTMLHeadingElement",
  "HTMLUListElement",
  "HTMLOListElement",
  "HTMLLIElement",
];

// HTML要素型を継承階層に追加
for (const elementType of htmlElementTypes) {
  inheritanceHierarchy.push({
    typeName: elementType,
    extends: "HTMLElement",
    castMethod: "as_html_element",
    sourceFile: "src/browser/dom/html_elements.mbt"
  });
}

// SVG要素の型定義
const svgElementTypes = [
  "SVGElement",
  "SVGSVGElement",
  "SVGCircleElement",
  "SVGRectElement",
  "SVGPathElement",
  "SVGLineElement",
  "SVGPolylineElement",
  "SVGPolygonElement",
  "SVGTextElement",
  "SVGGElement",
];

for (const elementType of svgElementTypes) {
  if (elementType === "SVGElement") {
    inheritanceHierarchy.push({
      typeName: elementType,
      extends: "Element",
      castMethod: "as_element",
      sourceFile: "src/browser/dom/svg_elements.mbt"
    });
  } else {
    inheritanceHierarchy.push({
      typeName: elementType,
      extends: "SVGElement",
      castMethod: "as_svg_element",
      sourceFile: "src/browser/dom/svg_elements.mbt"
    });
  }
}

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
  typeName: string
): Promise<MethodSignature[]> {
  try {
    const fullPath = join(projectRoot, filePath);
    const content = await readFile(fullPath, "utf-8");
    const methods: MethodSignature[] = [];

    // as_* メソッドや型定義をスキップするためのパターン
    const skipPatterns = [
      /as_any\(/,
      /as_event_target\(/,
      /as_node\(/,
      /as_element\(/,
      /as_html_element\(/,
      /as_svg_element\(/,
      /#external/,
      /pub type /,
      /pub\(all\) struct/,
    ];

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
function getAncestors(typeName: string): InheritanceChain[] {
  const ancestors: InheritanceChain[] = [];
  let current = inheritanceHierarchy.find(t => t.typeName === typeName);

  while (current?.extends) {
    const parent = inheritanceHierarchy.find(t => t.typeName === current!.extends);
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
function getCastChain(fromType: string, toType: string): string[] {
  const chain: string[] = [];

  let current = inheritanceHierarchy.find(t => t.typeName === fromType);
  while (current && current.typeName !== toType) {
    if (current.castMethod) {
      chain.push(current.castMethod);
    }
    current = inheritanceHierarchy.find(t => t.typeName === current!.extends);
  }

  return chain;
}

/**
 * 型の継承メソッドを生成
 */
async function generateInheritedMethods(
  typeName: string,
  targetFile?: string
): Promise<string> {
  const ancestors = getAncestors(typeName);
  const sections: string[] = [];

  // 既存のメソッドを取得（重複を避けるため）
  const existingMethods = targetFile
    ? await extractExistingMethods(targetFile, typeName)
    : new Set<string>();

  // 生成済みのメソッド名を追跡（同一型内での重複を防ぐ）
  const generatedMethods = new Set<string>();

  for (const ancestor of ancestors) {
    const methods = await extractPublicMethods(ancestor.sourceFile, ancestor.typeName);

    if (methods.length === 0) continue;

    const castChain = getCastChain(typeName, ancestor.typeName);

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
 * メイン処理
 */
async function main() {
  console.log("🚀 Generating DOM inheritance wrappers...\n");

  // Element の生成メソッドを生成
  const elementMethods = await generateInheritedMethods("Element");
  if (elementMethods) {
    const outputPath = join(projectRoot, "src/browser/dom/element_generated.mbt");
    const content = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_dom_inheritance.ts

${elementMethods}
`;
    await writeFile(outputPath, content, "utf-8");
    console.log(`✅ Generated: src/browser/dom/element_generated.mbt`);
  }

  // HTMLElement の継承メソッドを生成
  const htmlElementMethods = await generateInheritedMethods("HTMLElement");
  if (htmlElementMethods) {
    const outputPath = join(projectRoot, "src/browser/dom/html_element_generated.mbt");
    const content = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_dom_inheritance.ts

${htmlElementMethods}
`;
    await writeFile(outputPath, content, "utf-8");
    console.log(`✅ Generated: src/browser/dom/html_element_generated.mbt`);
  }

  // Document の継承メソッドを生成
  const documentMethods = await generateInheritedMethods("Document");
  if (documentMethods) {
    const outputPath = join(projectRoot, "src/browser/dom/document_generated.mbt");
    const content = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_dom_inheritance.ts

${documentMethods}
`;
    await writeFile(outputPath, content, "utf-8");
    console.log(`✅ Generated: src/browser/dom/document_generated.mbt`);
  }

  // 各HTML要素型の継承メソッドを生成
  let allHtmlElementsContent = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_dom_inheritance.ts

`;

  for (const elementType of htmlElementTypes) {
    const methods = await generateInheritedMethods(
      elementType,
      "src/browser/dom/html_elements.mbt"
    );
    if (methods) {
      allHtmlElementsContent += `///| ${elementType} inherited methods\n\n${methods}\n\n`;
    }
  }

  await writeFile(
    join(projectRoot, "src/browser/dom/html_elements_generated.mbt"),
    allHtmlElementsContent,
    "utf-8"
  );
  console.log(`✅ Generated: src/browser/dom/html_elements_generated.mbt`);

  // SVG要素の継承メソッドを生成
  let allSvgElementsContent = `// This file is auto-generated. Do not edit manually.
// Generated by scripts/generate_dom_inheritance.ts

`;

  for (const elementType of svgElementTypes) {
    const methods = await generateInheritedMethods(
      elementType,
      "src/browser/dom/svg_elements.mbt"
    );
    if (methods) {
      allSvgElementsContent += `///| ${elementType} inherited methods\n\n${methods}\n\n`;
    }
  }

  await writeFile(
    join(projectRoot, "src/browser/dom/svg_elements_generated.mbt"),
    allSvgElementsContent,
    "utf-8"
  );
  console.log(`✅ Generated: src/browser/dom/svg_elements_generated.mbt`);

  console.log("\n✨ All done!");
}

main().catch(console.error);
