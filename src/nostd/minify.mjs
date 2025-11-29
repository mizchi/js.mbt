#!/usr/bin/env node
/**
 * MoonBit nostd minifier
 *
 * Pipeline: moon build -> inline-ffi -> oxc-minify
 *
 * Usage:
 *   node minify.mjs <input.js> [output.js]
 *   node minify.mjs --check  # Build and check size of _tests/check_size
 */
import { minify } from 'oxc-minify';
import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import * as acorn from 'acorn';
import * as astring from 'astring';

// ============================================================================
// AST Helpers
// ============================================================================

const isValidIdentifier = (str) => /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(str);

const cloneNode = (node) => JSON.parse(JSON.stringify(node));

const id = (name) => ({ type: 'Identifier', name });

const literal = (value, raw) => ({ type: 'Literal', value, raw });

const member = (object, property, computed = false) => ({
  type: 'MemberExpression', object, property, computed, optional: false
});

const call = (callee, args) => ({
  type: 'CallExpression', callee, arguments: args, optional: false
});

const binary = (operator, left, right) => ({
  type: 'BinaryExpression', operator, left, right
});

const assign = (left, right) => ({
  type: 'AssignmentExpression', operator: '=', left, right
});

const spread = (argument) => ({ type: 'SpreadElement', argument });

/** Convert string literal key to dot notation if valid identifier */
const toDotNotation = (keyArg) => {
  if (keyArg.type === 'Literal' && typeof keyArg.value === 'string' && isValidIdentifier(keyArg.value)) {
    return member(null, id(keyArg.value), false);
  }
  return member(null, keyArg, true);
};

// ============================================================================
// Function Name Patterns (MoonBit FFI naming conventions)
// ============================================================================

/**
 * MoonBit generates function names like: namespace$$functionName
 * e.g., mizchi$js$nostd$$is_nullish, mizchi$js$nostd$$JsArray$new
 *
 * We match the part after $$ to inline the calls.
 * Only functions from 'nostd' namespace are inlined.
 */
const NOSTD_NAMESPACE = 'nostd';

const inlinePatterns = {
  // Constants: () => value
  'global_this': () => id('globalThis'),
  'undefined': () => id('undefined'),
  'null': () => literal(null, 'null'),
  'JsArray$new': () => ({ type: 'ArrayExpression', elements: [] }),
  'Object$new': () => ({ type: 'ObjectExpression', properties: [] }),

  // Single param checks
  'is_nullish': (args) => binary('==', args[0], literal(null, 'null')),
  'is_null': (args) => binary('===', args[0], literal(null, 'null')),
  'is_undefined': (args) => binary('===', args[0], id('undefined')),

  // Two param operations
  'equal': (args) => binary('===', args[0], args[1]),

  // Array operations
  'JsArray$_push': (args) => call(member(args[0], id('push')), [args[1]]),

  // Object member access
  'JsValue$_get': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return m;
  },
  'JsValue$_set': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return assign(m, args[2]);
  },

  // Method/function calls
  'JsValue$_call': (args) => {
    const m = toDotNotation(args[1]);
    m.object = args[0];
    return call(m, [spread(args[2])]);
  },
  'JsValue$_invoke': (args) => call(args[0], [spread(args[1])]),
};

/**
 * Parse MoonBit function name: namespace$$functionName
 * Returns { namespace, funcName } or null if not matching pattern
 */
function parseMoonBitName(name) {
  const idx = name.lastIndexOf('$$');
  if (idx === -1) return null;
  const namespace = name.slice(0, idx);
  const funcName = name.slice(idx + 2);
  return { namespace, funcName };
}

// ============================================================================
// Pattern Matching for User-Defined FFI Functions
// ============================================================================

/**
 * Analyze arrow function to determine if it's a simple constant pattern.
 * Used for user-defined `extern "js" fn` like `() => console`
 */
function analyzeConstantPattern(init) {
  if (init.type !== 'ArrowFunctionExpression') return null;
  if (init.params.length !== 0) return null;

  const body = init.body;
  // () => identifier (e.g., () => console, () => globalThis)
  if (body.type === 'Identifier') {
    return { type: 'constant', body };
  }
  // () => literal (e.g., () => null, () => undefined handled above)
  if (body.type === 'Literal') {
    return { type: 'constant', body };
  }
  // () => []
  if (body.type === 'ArrayExpression' && body.elements.length === 0) {
    return { type: 'constant', body };
  }
  // () => {}
  if (body.type === 'ObjectExpression' && body.properties.length === 0) {
    return { type: 'constant', body };
  }
  return null;
}

// ============================================================================
// Inlining Logic
// ============================================================================

function findInlineableFunctions(ast) {
  const inlineable = new Map();

  for (const node of ast.body) {
    if (node.type !== 'VariableDeclaration') continue;

    for (const decl of node.declarations) {
      if (!decl.init || decl.init.type !== 'ArrowFunctionExpression') continue;

      const name = decl.id.name;
      const parsed = parseMoonBitName(name);

      // Check name-based patterns (only for nostd namespace)
      if (parsed && parsed.namespace.endsWith(NOSTD_NAMESPACE)) {
        const funcName = parsed.funcName;
        if (inlinePatterns[funcName]) {
          inlineable.set(name, { type: 'named', funcName, paramCount: decl.init.params.length });
          continue;
        }
      }

      // Check for constant pattern (user-defined extern "js" fn)
      // Only apply if:
      // 1. No namespace (no $$), or
      // 2. Has namespace but funcName is not in inlinePatterns (user-defined in other package)
      const shouldCheckConstant = !parsed || !inlinePatterns[parsed.funcName];
      if (shouldCheckConstant) {
        const pattern = analyzeConstantPattern(decl.init);
        if (pattern) {
          inlineable.set(name, pattern);
        }
      }
    }
  }

  return inlineable;
}

function buildInlinedExpr(fnInfo, callArgs) {
  const args = callArgs.map(cloneNode);

  if (fnInfo.type === 'named') {
    const builder = inlinePatterns[fnInfo.funcName];
    return builder ? builder(args) : null;
  }

  if (fnInfo.type === 'constant') {
    return cloneNode(fnInfo.body);
  }

  return null;
}

function inlineCalls(ast, inlineableFns) {
  let inlineCount = 0;

  function visit(node) {
    if (!node || typeof node !== 'object') return node;

    // Visit children first
    for (const key of Object.keys(node)) {
      const child = node[key];
      if (Array.isArray(child)) {
        for (let i = 0; i < child.length; i++) child[i] = visit(child[i]);
      } else if (child && typeof child === 'object') {
        node[key] = visit(child);
      }
    }

    // Check if this is an inlineable call
    if (node.type === 'CallExpression' && node.callee.type === 'Identifier') {
      const fnInfo = inlineableFns.get(node.callee.name);
      if (fnInfo) {
        const inlined = buildInlinedExpr(fnInfo, node.arguments);
        if (inlined) {
          inlineCount++;
          return inlined;
        }
      }
    }

    return node;
  }

  return { ast: visit(ast), inlineCount };
}

function removeUnused(ast, inlineableFns) {
  // Count references to inlineable functions
  const refCounts = new Map();
  for (const name of inlineableFns.keys()) refCounts.set(name, 0);

  function countRefs(node) {
    if (!node || typeof node !== 'object') return;
    if (node.type === 'Identifier' && refCounts.has(node.name)) {
      refCounts.set(node.name, refCounts.get(node.name) + 1);
    }
    for (const key of Object.keys(node)) {
      const child = node[key];
      if (Array.isArray(child)) child.forEach(countRefs);
      else if (child && typeof child === 'object') countRefs(child);
    }
  }
  countRefs(ast);

  // Remove declarations with refCount <= 1 (only the declaration itself)
  ast.body = ast.body.filter(node => {
    if (node.type !== 'VariableDeclaration') return true;
    node.declarations = node.declarations.filter(decl => {
      const name = decl.id.name;
      return !(refCounts.has(name) && refCounts.get(name) <= 1);
    });
    return node.declarations.length > 0;
  });

  return ast;
}

// ============================================================================
// Public API
// ============================================================================

export function inlineFfi(code) {
  const ast = acorn.parse(code, { ecmaVersion: 'latest', sourceType: 'module' });
  const inlineableFns = findInlineableFunctions(ast);
  const { ast: inlinedAst, inlineCount } = inlineCalls(ast, inlineableFns);
  const finalAst = removeUnused(inlinedAst, inlineableFns);
  return { code: astring.generate(finalAst), inlineCount, inlineableFns: inlineableFns.size };
}

// ============================================================================
// CLI Functions
// ============================================================================

async function minifyCode(code) {
  const result = await minify('input.js', code, {
    mangle: { toplevel: true },
    compress: { passes: 3 }
  });
  return result.code;
}

async function processFile(inputPath, outputPath) {
  const code = fs.readFileSync(inputPath, 'utf-8');
  const originalSize = code.length;

  const { code: inlinedCode, inlineCount, inlineableFns } = inlineFfi(code);
  const inlinedSize = inlinedCode.length;

  const minifiedCode = await minifyCode(inlinedCode);
  const minifiedSize = minifiedCode.length;

  console.error(`Inlineable functions: ${inlineableFns}`);
  console.error(`Inlined calls: ${inlineCount}`);
  console.error(`Size: ${originalSize} -> ${inlinedSize} (inline) -> ${minifiedSize} (minify) bytes`);

  if (outputPath) {
    fs.writeFileSync(outputPath, minifiedCode);
    console.error(`Output: ${outputPath}`);
  } else {
    console.log(minifiedCode);
  }

  return { originalSize, inlinedSize, minifiedSize };
}

async function checkSize(testName, { print = false } = {}) {
  const scriptDir = import.meta.dirname;
  const projectRoot = path.resolve(scriptDir, '../..');

  console.error('Building...');
  execSync('moon build --target js', { cwd: projectRoot, stdio: 'inherit' });

  const testsDir = path.join(scriptDir, '_tests');
  const testDirs = testName
    ? [testName]
    : fs.readdirSync(testsDir).filter(d => fs.statSync(path.join(testsDir, d)).isDirectory());

  const results = [];

  for (const dir of testDirs) {
    const inputPath = path.join(projectRoot, `target/js/release/build/nostd/_tests/${dir}/${dir}.js`);
    if (!fs.existsSync(inputPath)) {
      console.error(`\n  Skipping ${dir}: ${inputPath} not found`);
      continue;
    }

    console.error(`\n=== Processing: ${dir} ===`);

    const code = fs.readFileSync(inputPath, 'utf-8');
    const originalSize = code.length;

    const minifiedOnly = await minifyCode(code);
    const minifiedOnlySize = minifiedOnly.length;

    const { code: inlinedCode, inlineCount, inlineableFns } = inlineFfi(code);
    const inlinedSize = inlinedCode.length;
    const minifiedCode = await minifyCode(inlinedCode);
    const minifiedSize = minifiedCode.length;

    console.error(`Inlineable functions: ${inlineableFns}`);
    console.error(`Inlined calls: ${inlineCount}`);
    console.error(`Size: ${originalSize} -> ${minifiedOnlySize} bytes (minify only)`);
    console.error(`Size: ${originalSize} -> ${inlinedSize} -> ${minifiedSize} bytes (inline + minify)`);
    console.error(`FFI transform saves: ${minifiedOnlySize - minifiedSize} bytes`);

    if (print) {
      console.error('\n--- Minified Code (without FFI transform) ---');
      console.log(minifiedOnly);
      console.error('--- End ---\n');
      console.error('\n--- Inlined Code (with FFI transform) ---');
      console.log(inlinedCode);
      console.error('--- End ---\n');
      console.error('\n--- Minified Code (with FFI transform) ---');
      console.log(minifiedCode);
      console.error('--- End ---\n');
    }

    console.error('Running minified code:');
    try {
      eval(minifiedCode);
    } catch (e) {
      console.error(`Error running ${dir}: ${e.message}`);
    }

    results.push({ name: dir, originalSize, minifiedOnlySize, inlinedSize, minifiedSize });
  }

  console.error(`\n=== Size Summary ===`);
  console.error('Test           | Original | Minify Only | With FFI | Saved');
  console.error('---------------|----------|-------------|----------|------');
  for (const r of results) {
    const saved = r.minifiedOnlySize - r.minifiedSize;
    console.error(`${r.name.padEnd(14)} | ${String(r.originalSize).padStart(8)} | ${String(r.minifiedOnlySize).padStart(11)} | ${String(r.minifiedSize).padStart(8)} | ${String(saved).padStart(5)}`);
  }

  const failed = results.filter(r => r.minifiedSize > 500);
  if (failed.length > 0) {
    console.error(`\n  Warning: ${failed.length} test(s) exceed 500 bytes`);
    process.exit(1);
  } else {
    console.error(`\n All size checks passed`);
  }
}

// ============================================================================
// CLI Entry Point
// ============================================================================

if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);
  if (args[0] === '--check') {
    const printFlag = args.includes('--print');
    const testName = args.find(a => a !== '--check' && a !== '--print');
    checkSize(testName, { print: printFlag }).catch(e => { console.error(e); process.exit(1); });
  } else if (args.length === 0) {
    console.log('Usage: node minify.mjs <input.js> [output.js]');
    console.log('       node minify.mjs --check [testName] [--print]  # Build and check size');
    process.exit(1);
  } else {
    processFile(args[0], args[1]).catch(e => { console.error(e); process.exit(1); });
  }
}
