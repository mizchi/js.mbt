/**
 * MoonBit nostd FFI inlining transform
 *
 * Inlines MoonBit FFI function calls for smaller bundle sizes.
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

const NOSTD_NAMESPACE = 'nostd';

type PatternBuilder = (args: AstNode[]) => AstNode;

const inlinePatterns: Record<string, PatternBuilder> = {
  'global_this': () => id('globalThis'),
  'undefined': () => id('undefined'),
  'null': () => literal(null, 'null'),
  'JsArray$new': () => ({ type: 'ArrayExpression', elements: [], start: 0, end: 0 }),
  'Object$new': () => ({ type: 'ObjectExpression', properties: [], start: 0, end: 0 }),
  'is_nullish': (args) => binary('==', args[0], literal(null, 'null')),
  'is_null': (args) => binary('===', args[0], literal(null, 'null')),
  'is_undefined': (args) => binary('===', args[0], id('undefined')),
  'equal': (args) => binary('===', args[0], args[1]),
  'JsArray$_push': (args) => call(member(args[0], id('push')), [args[1]]),
  'JsValue$_get': (args) => {
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

  'JsValue$_set': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return assign(m, args[2]);
  },
  'JsValue$_call': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return call(m, [spread(args[2])]);
  },
  'JsValue$_invoke': (args) => call(args[0], [spread(args[1])]),
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

      if (parsed && parsed.namespace.endsWith(NOSTD_NAMESPACE)) {
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

  // Inline calls and track which functions are still referenced
  let inlineCount = 0;
  const inlinedCalls = new Set<AstNode>(); // Track inlined CallExpression nodes

  function inlineVisit(node: AstNode | null): void {
    if (!node || typeof node !== 'object') return;

    // Inline call expressions
    if (node.type === 'CallExpression' && node.callee?.type === 'Identifier' && node.callee.name) {
      const fnInfo = inlineable.get(node.callee.name);
      if (fnInfo) {
        let inlined: AstNode | null = null;
        const args = (node.arguments || []) as AstNode[];

        if (fnInfo.type === 'named') {
          const builder = inlinePatterns[fnInfo.funcName];
          inlined = builder ? builder(args) : null;
        } else if (fnInfo.type === 'constant') {
          inlined = fnInfo.body;
        }

        if (inlined) {
          const replacement = astring.generate(inlined as any);
          ms.overwrite(node.start, node.end, replacement);
          inlineCount++;
          inlinedCalls.add(node);
        }
      }
    }

    // Recurse
    for (const key of Object.keys(node)) {
      const child = (node as any)[key];
      if (Array.isArray(child)) {
        for (const item of child) {
          if (item && typeof item === 'object' && item.type) inlineVisit(item);
        }
      } else if (child && typeof child === 'object' && child.type) {
        inlineVisit(child);
      }
    }
  }

  inlineVisit(ast);

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
    if (count <= 1) {
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
