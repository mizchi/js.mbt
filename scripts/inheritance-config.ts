/**
 * 継承階層の設定ファイル
 */

export type InheritanceChain = {
  typeName: string;
  extends: string | null;
  castMethod: string | null;
  sourceFile: string;
};

export type HierarchyConfig = {
  name: string;
  types: InheritanceChain[];
  outputDir: string;
  skipPatterns: RegExp[];
};

// DOM 継承階層
const domHierarchy: InheritanceChain[] = [
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
  domHierarchy.push({
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
    domHierarchy.push({
      typeName: elementType,
      extends: "Element",
      castMethod: "as_element",
      sourceFile: "src/browser/dom/svg_elements.mbt"
    });
  } else {
    domHierarchy.push({
      typeName: elementType,
      extends: "SVGElement",
      castMethod: "as_svg_element",
      sourceFile: "src/browser/dom/svg_elements.mbt"
    });
  }
}

// Node.js Stream 継承階層
const streamHierarchy: InheritanceChain[] = [
  {
    typeName: "EventEmitter",
    extends: null,
    castMethod: null,
    sourceFile: "src/node/events/event_emitter.mbt"
  },
  {
    typeName: "Stream",
    extends: "EventEmitter",
    castMethod: "as_event_emitter",
    sourceFile: "src/node/stream/stream.mbt"
  },
  {
    typeName: "Readable",
    extends: "Stream",
    castMethod: "as_stream",
    sourceFile: "src/node/stream/stream.mbt"
  },
  {
    typeName: "Writable",
    extends: "Stream",
    castMethod: "as_stream",
    sourceFile: "src/node/stream/stream.mbt"
  },
];

// 設定のエクスポート
export const hierarchies: HierarchyConfig[] = [
  {
    name: "dom",
    types: domHierarchy,
    outputDir: "src/browser/dom",
    skipPatterns: [
      /as_any\(/,
      /as_event_target\(/,
      /as_node\(/,
      /as_element\(/,
      /as_html_element\(/,
      /as_svg_element\(/,
      /#external/,
      /pub type /,
      /pub\(all\) struct/,
    ],
  },
  {
    name: "stream",
    types: streamHierarchy,
    outputDir: "src/node/stream",
    skipPatterns: [
      /as_any\(/,
      /as_event_emitter\(/,
      /as_stream\(/,
      /to_any\(/,
      /#external/,
      /pub type /,
      /pub\(all\) struct/,
    ],
  },
];
