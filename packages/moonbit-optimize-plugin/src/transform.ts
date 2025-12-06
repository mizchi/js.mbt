/**
 * MoonBit FFI optimization transform
 *
 * Inlines MoonBit FFI function calls from @core and @nostd packages
 * for smaller bundle sizes and better performance.
 *
 * Achieves up to 74% size reduction on FFI-heavy code.
 */
import MagicString from 'magic-string';
import * as acorn from 'acorn';
import * as astring from 'astring';

// ============================================================================
// Types
// ============================================================================

type AstNode = acorn.Node & {
  body?: AstNode | AstNode[];
  declarations?: AstNode[];
  init?: AstNode;
  id?: AstNode;
  name?: string;
  type: string;
  params?: AstNode[];
  elements?: AstNode[];
  properties?: AstNode[];
  callee?: AstNode;
  arguments?: AstNode[];
  object?: AstNode;
  property?: AstNode;
  computed?: boolean;
  value?: unknown;
  raw?: string;
  operator?: string;
  left?: AstNode;
  right?: AstNode;
  argument?: AstNode;
  optional?: boolean;
};

interface InlineableNamed {
  type: 'named';
  funcName: string;
}

interface InlineableConstant {
  type: 'constant';
  body: AstNode;
}

type InlineableInfo = InlineableNamed | InlineableConstant;

interface DeclRange {
  start: number;
  end: number;
}

interface TransformResult {
  code: string;
  map?: ReturnType<MagicString['generateMap']>;
  inlineCount: number;
  inlineableFns: number;
}

interface TransformOptions {
  sourcemap?: boolean;
}

// ============================================================================
// AST Helpers
// ============================================================================

const isValidIdentifier = (str: string): boolean => /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(str);

const id = (name: string): AstNode => ({ type: 'Identifier', name, start: 0, end: 0 });

const literal = (value: unknown, raw: string): AstNode => ({ type: 'Literal', value, raw, start: 0, end: 0 });

const member = (object: AstNode | null, property: AstNode, computed = false): AstNode => ({
  type: 'MemberExpression', object: object!, property, computed, optional: false, start: 0, end: 0
});

const call = (callee: AstNode, args: AstNode[]): AstNode => ({
  type: 'CallExpression', callee, arguments: args, optional: false, start: 0, end: 0
});

const binary = (operator: string, left: AstNode, right: AstNode): AstNode => ({
  type: 'BinaryExpression', operator, left, right, start: 0, end: 0
});

const assign = (left: AstNode, right: AstNode): AstNode => ({
  type: 'AssignmentExpression', operator: '=', left, right, start: 0, end: 0
});

const spread = (argument: AstNode): AstNode => ({ type: 'SpreadElement', argument, start: 0, end: 0 });

const toDotNotation = (keyArg: AstNode): AstNode => {
  if (keyArg.type === 'Literal' && typeof keyArg.value === 'string' && isValidIdentifier(keyArg.value)) {
    return member(null, id(keyArg.value), false);
  }
  return member(null, keyArg, true);
};

// ============================================================================
// FFI Patterns
// ============================================================================

const INLINEABLE_NAMESPACES = ['core'];

type PatternBuilder = (args: AstNode[]) => AstNode;

const inlinePatterns: Record<string, PatternBuilder> = {
  'global_this': () => id('globalThis'),
  'globalThis': () => id('globalThis'),

  'undefined': () => id('undefined'),
  'null': () => literal(null, 'null'),
  'new_array': () => ({ type: 'ArrayExpression', elements: [], start: 0, end: 0 }),
  'new_object': () => ({ type: 'ObjectExpression', properties: [], start: 0, end: 0 }),
  'is_nullish': (args) => binary('==', args[0], literal(null, 'null')),
  'is_null': (args) => binary('===', args[0], literal(null, 'null')),
  'is_undefined': (args) => binary('===', args[0], id('undefined')),
  'equal': (args) => binary('===', args[0], args[1]),
  'Any$_get': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return m;
  },
  // TODO
  // 'JsValue$_get_by_index': (args) => {
  //   const m = toDotNotation(args[1]);
  //   m.object = args[0];
  //   return m;
  // },
  'Any$_set': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return assign(m, args[2]);
  },
  'Any$_call': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    // If args[2] is an array literal, use its elements directly; otherwise use spread
    const callArgs = args[2].type === 'ArrayExpression' && args[2].elements
      ? args[2].elements as AstNode[]
      : [spread(args[2])];
    return call(m, callArgs);
  },
  'Any$_invoke': (args) => {
    // If args[1] is an array literal, use its elements directly; otherwise use spread
    const callArgs = args[1].type === 'ArrayExpression' && args[1].elements
      ? args[1].elements as AstNode[]
      : [spread(args[1])];
    return call(args[0], callArgs);
  },
};

function parseMoonBitName(name: string): { namespace: string; funcName: string } | null {
  const idx = name.lastIndexOf('$$');
  if (idx === -1) return null;
  return { namespace: name.slice(0, idx), funcName: name.slice(idx + 2) };
}

function analyzeConstantPattern(init: AstNode): InlineableConstant | null {
  if (init.type !== 'ArrowFunctionExpression' || !init.params || init.params.length !== 0) return null;
  const body = init.body as AstNode;
  if (body.type === 'Identifier' || body.type === 'Literal') return { type: 'constant', body };
  if (body.type === 'ArrayExpression' && (!body.elements || body.elements.length === 0)) return { type: 'constant', body };
  if (body.type === 'ObjectExpression' && (!body.properties || body.properties.length === 0)) return { type: 'constant', body };
  return null;
}

// ============================================================================
// Transform Logic
// ============================================================================

/**
 * Transform code with FFI inlining
 */
export function transform(code: string, options: TransformOptions = {}): TransformResult {
  const { sourcemap = false } = options;
  const ast = acorn.parse(code, { ecmaVersion: 'latest', sourceType: 'module', locations: true }) as AstNode;
  const ms = new MagicString(code);

  // Find inlineable functions
  const inlineable = new Map<string, InlineableInfo>();
  const declRanges = new Map<string, DeclRange>();

  const bodyNodes = Array.isArray(ast.body) ? ast.body : [];
  for (const node of bodyNodes) {
    if (node.type !== 'VariableDeclaration') continue;

    for (const decl of node.declarations || []) {
      if (!decl.init || decl.init.type !== 'ArrowFunctionExpression') continue;

      const name = decl.id?.name;
      if (!name) continue;

      const parsed = parseMoonBitName(name);

      if (parsed && INLINEABLE_NAMESPACES.some(ns => parsed.namespace.endsWith(ns))) {
        if (inlinePatterns[parsed.funcName]) {
          inlineable.set(name, { type: 'named', funcName: parsed.funcName });
          declRanges.set(name, { start: node.start, end: node.end });
          continue;
        }
      }

      const shouldCheckConstant = !parsed || !inlinePatterns[parsed.funcName];
      if (shouldCheckConstant) {
        const pattern = analyzeConstantPattern(decl.init);
        if (pattern) {
          inlineable.set(name, pattern);
          declRanges.set(name, { start: node.start, end: node.end });
        }
      }
    }
  }

  if (inlineable.size === 0) {
    return { code, map: sourcemap ? ms.generateMap({ hires: true }) : undefined, inlineCount: 0, inlineableFns: 0 };
  }

  // Recursively try to inline a node
  function tryInlineNode(node: AstNode): AstNode | null {
    if (!node || typeof node !== 'object') return null;
    if (node.type === 'CallExpression' && node.callee?.type === 'Identifier' && node.callee.name) {
      const fnInfo = inlineable.get(node.callee.name);
      if (fnInfo) {
        const args = (node.arguments || []) as AstNode[];
        // Recursively inline arguments first
        const inlinedArgs = args.map(arg => tryInlineNode(arg) || arg);

        if (fnInfo.type === 'named') {
          const builder = inlinePatterns[fnInfo.funcName];
          return builder ? builder(inlinedArgs) : null;
        } else if (fnInfo.type === 'constant') {
          return fnInfo.body;
        }
      }
    }
    return null;
  }

  // Collect all inlineable calls first
  const inlineableCallsToReplace: Array<{ node: AstNode; replacement: string }> = [];
  const inlinedCalls = new Set<AstNode>();

  function collectInlineable(node: AstNode | null): void {
    if (!node || typeof node !== 'object') return;

    // Collect call expressions that can be inlined
    if (node.type === 'CallExpression' && node.callee?.type === 'Identifier' && node.callee.name) {
      const fnInfo = inlineable.get(node.callee.name);
      if (fnInfo) {
        // Try to inline with recursive argument inlining
        const inlined = tryInlineNode(node);

        if (inlined) {
          const replacement = astring.generate(inlined as any);
          inlineableCallsToReplace.push({ node, replacement });
          inlinedCalls.add(node);
          // Don't recurse into this node's children since they're already processed by tryInlineNode
          return;
        }
      }
    }

    // Recurse to collect all inlineable calls
    for (const key of Object.keys(node)) {
      const child = (node as any)[key];
      if (Array.isArray(child)) {
        for (const item of child) {
          if (item && typeof item === 'object' && item.type) collectInlineable(item);
        }
      } else if (child && typeof child === 'object' && child.type) {
        collectInlineable(child);
      }
    }
  }

  collectInlineable(ast);

  // Sort by range size (ascending) to process nested calls first, then by position (descending)
  // This ensures nested calls are inlined before their parent calls
  inlineableCallsToReplace.sort((a, b) => {
    const sizeA = a.node.end - a.node.start;
    const sizeB = b.node.end - b.node.start;
    if (sizeA !== sizeB) return sizeA - sizeB; // Smaller range first (inner calls)
    return b.node.start - a.node.start; // If same size, process from end to start
  });

  let inlineCount = 0;
  const replacedRanges: Array<{ start: number; end: number }> = [];
  for (const { node, replacement } of inlineableCallsToReplace) {
    // Skip if this node is within the range of a previously replaced node (nested call)
    const isNested = replacedRanges.some(range => node.start >= range.start && node.end <= range.end);
    if (isNested) {
      continue;
    }
    ms.overwrite(node.start, node.end, replacement);
    replacedRanges.push({ start: node.start, end: node.end });
    inlineCount++;
  }

  // Count remaining references (excluding inlined calls and declarations)
  const refCounts = new Map<string, number>();
  for (const name of inlineable.keys()) refCounts.set(name, 0);

  function countRefs(node: AstNode | null, isDecl = false): void {
    if (!node || typeof node !== 'object') return;

    // Skip counting if this is an inlined call (the reference was replaced)
    if (inlinedCalls.has(node)) return;

    // Count identifier references (but not in declarations)
    if (node.type === 'Identifier' && node.name && refCounts.has(node.name) && !isDecl) {
      refCounts.set(node.name, refCounts.get(node.name)! + 1);
    }

    // Recurse, marking declaration ids
    for (const key of Object.keys(node)) {
      const child = (node as any)[key];
      const isIdOfDecl = node.type === 'VariableDeclarator' && key === 'id';
      if (Array.isArray(child)) {
        for (const item of child) {
          if (item && typeof item === 'object' && item.type) countRefs(item, isIdOfDecl);
        }
      } else if (child && typeof child === 'object' && child.type) {
        countRefs(child, isIdOfDecl);
      }
    }
  }

  countRefs(ast);

  // Remove unused declarations
  for (const [name, range] of declRanges) {
    const count = refCounts.get(name) || 0;
    if (count === 0) {
      let end = range.end;
      while (end < code.length && code[end] !== '\n') end++;
      if (code[end] === '\n') end++;
      ms.remove(range.start, end);
    }
  }

  return {
    code: ms.toString(),
    map: sourcemap ? ms.generateMap({ hires: true }) : undefined,
    inlineCount,
    inlineableFns: inlineable.size
  };
}
