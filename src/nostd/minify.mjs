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

// Inline FFI helpers from inline-ffi.mjs logic
import * as acorn from 'acorn';
import * as astring from 'astring';

function isValidIdentifier(str) {
  return /^[a-zA-Z_$][a-zA-Z0-9_$]*$/.test(str);
}

function analyzeArrowFunction(body, params) {
  const paramNames = params.map(p => p.name);
  if (params.length === 0) return { type: 'constant', body };
  if (params.length === 1 && body.type === 'Identifier' && body.name === paramNames[0]) {
    return { type: 'identity', paramIdx: 0 };
  }
  // Check array_push pattern first (more specific than static_method_call)
  if (body.type === 'CallExpression' && body.callee.type === 'MemberExpression' &&
      !body.callee.computed && body.callee.property.type === 'Identifier' &&
      body.callee.property.name === 'push' && body.callee.object.type === 'Identifier' &&
      body.arguments.length === 1 && body.arguments[0].type === 'Identifier') {
    const arrIdx = paramNames.indexOf(body.callee.object.name);
    const valIdx = paramNames.indexOf(body.arguments[0].name);
    if (arrIdx !== -1 && valIdx !== -1) return { type: 'array_push', arrIdx, valIdx };
  }
  // static_method_call: object is NOT a parameter (e.g., console.log)
  if (body.type === 'CallExpression' && body.callee.type === 'MemberExpression' &&
      !body.callee.computed && body.callee.object.type === 'Identifier') {
    const objName = body.callee.object.name;
    const methodName = body.callee.property.name;
    // Only match if object is NOT a parameter (static object like console, Math)
    if (!paramNames.includes(objName)) {
      const argMappings = body.arguments.map(arg => arg.type === 'Identifier' ? paramNames.indexOf(arg.name) : -1);
      if (argMappings.every(i => i !== -1)) {
        return { type: 'static_method_call', object: objName, method: methodName, argMappings };
      }
    }
  }
  if (body.type === 'MemberExpression' && body.computed &&
      body.object.type === 'Identifier' && body.property.type === 'Identifier') {
    const objIdx = paramNames.indexOf(body.object.name);
    const keyIdx = paramNames.indexOf(body.property.name);
    if (objIdx !== -1 && keyIdx !== -1) return { type: 'member_get', objIdx, keyIdx };
  }
  if (body.type === 'BlockStatement' && body.body.length === 1 &&
      body.body[0].type === 'ExpressionStatement' &&
      body.body[0].expression.type === 'AssignmentExpression') {
    const assign = body.body[0].expression;
    if (assign.left.type === 'MemberExpression' && assign.left.computed &&
        assign.left.object.type === 'Identifier' && assign.left.property.type === 'Identifier' &&
        assign.right.type === 'Identifier') {
      const objIdx = paramNames.indexOf(assign.left.object.name);
      const keyIdx = paramNames.indexOf(assign.left.property.name);
      const valIdx = paramNames.indexOf(assign.right.name);
      if (objIdx !== -1 && keyIdx !== -1 && valIdx !== -1) {
        return { type: 'member_set', objIdx, keyIdx, valIdx };
      }
    }
  }
  if (body.type === 'CallExpression' && body.callee.type === 'MemberExpression' &&
      body.callee.computed && body.callee.object.type === 'Identifier' &&
      body.callee.property.type === 'Identifier' && body.arguments.length === 1 &&
      body.arguments[0].type === 'SpreadElement' && body.arguments[0].argument.type === 'Identifier') {
    const objIdx = paramNames.indexOf(body.callee.object.name);
    const keyIdx = paramNames.indexOf(body.callee.property.name);
    const argsIdx = paramNames.indexOf(body.arguments[0].argument.name);
    if (objIdx !== -1 && keyIdx !== -1 && argsIdx !== -1) {
      return { type: 'member_call', objIdx, keyIdx, argsIdx };
    }
  }
  if (body.type === 'CallExpression' && body.callee.type === 'Identifier' &&
      body.arguments.length === 1 && body.arguments[0].type === 'SpreadElement' &&
      body.arguments[0].argument.type === 'Identifier') {
    const funcIdx = paramNames.indexOf(body.callee.name);
    const argsIdx = paramNames.indexOf(body.arguments[0].argument.name);
    if (funcIdx !== -1 && argsIdx !== -1) return { type: 'func_call', funcIdx, argsIdx };
  }
  // v == null (nullish check)
  if (body.type === 'BinaryExpression' && body.operator === '==' &&
      body.left.type === 'Identifier' && body.right.type === 'Literal' && body.right.value === null) {
    const paramIdx = paramNames.indexOf(body.left.name);
    if (paramIdx !== -1) return { type: 'nullish_check', paramIdx };
  }
  // v === null (strict null check)
  if (body.type === 'BinaryExpression' && body.operator === '===' &&
      body.left.type === 'Identifier' && body.right.type === 'Literal' && body.right.value === null) {
    const paramIdx = paramNames.indexOf(body.left.name);
    if (paramIdx !== -1) return { type: 'null_check', paramIdx };
  }
  // v === undefined (strict undefined check)
  if (body.type === 'BinaryExpression' && body.operator === '===' &&
      body.left.type === 'Identifier' && body.right.type === 'Identifier' && body.right.name === 'undefined') {
    const paramIdx = paramNames.indexOf(body.left.name);
    if (paramIdx !== -1) return { type: 'undefined_check', paramIdx };
  }
  // a === b (strict equality)
  if (body.type === 'BinaryExpression' && body.operator === '===' &&
      body.left.type === 'Identifier' && body.right.type === 'Identifier') {
    const leftIdx = paramNames.indexOf(body.left.name);
    const rightIdx = paramNames.indexOf(body.right.name);
    if (leftIdx !== -1 && rightIdx !== -1) return { type: 'strict_equal', leftIdx, rightIdx };
  }
  return null;
}

function findInlineableFunctions(ast) {
  const inlineable = new Map();
  for (const node of ast.body) {
    if (node.type === 'VariableDeclaration') {
      for (const decl of node.declarations) {
        if (decl.init?.type === 'ArrowFunctionExpression') {
          const name = decl.id.name;
          const params = decl.init.params;
          const body = decl.init.body;
          const pattern = analyzeArrowFunction(body, params);
          if (pattern) inlineable.set(name, { params, body, pattern });
        }
      }
    }
  }
  return inlineable;
}

function cloneNode(node) {
  return JSON.parse(JSON.stringify(node));
}

function buildInlinedExpr(pattern, callArgs) {
  // Clone callArgs to avoid AST mutation issues
  const args = callArgs.map(cloneNode);
  switch (pattern.type) {
    case 'constant': return cloneNode(pattern.body);
    case 'identity': return args[pattern.paramIdx];
    case 'static_method_call':
      return {
        type: 'CallExpression',
        callee: { type: 'MemberExpression', object: { type: 'Identifier', name: pattern.object },
                  property: { type: 'Identifier', name: pattern.method }, computed: false, optional: false },
        arguments: pattern.argMappings.map(i => args[i]), optional: false
      };
    case 'member_get': {
      const keyArg = args[pattern.keyIdx];
      const isStringLiteral = keyArg.type === 'Literal' && typeof keyArg.value === 'string';
      const canUseDotNotation = isStringLiteral && isValidIdentifier(keyArg.value);
      return {
        type: 'MemberExpression', object: args[pattern.objIdx],
        property: canUseDotNotation ? { type: 'Identifier', name: keyArg.value } : keyArg,
        computed: !canUseDotNotation, optional: false
      };
    }
    case 'member_set': {
      const keyArg = args[pattern.keyIdx];
      const isStringLiteral = keyArg.type === 'Literal' && typeof keyArg.value === 'string';
      const canUseDotNotation = isStringLiteral && isValidIdentifier(keyArg.value);
      return {
        type: 'AssignmentExpression', operator: '=',
        left: { type: 'MemberExpression', object: args[pattern.objIdx],
                property: canUseDotNotation ? { type: 'Identifier', name: keyArg.value } : keyArg,
                computed: !canUseDotNotation, optional: false },
        right: args[pattern.valIdx]
      };
    }
    case 'member_call': {
      const keyArg = args[pattern.keyIdx];
      const isStringLiteral = keyArg.type === 'Literal' && typeof keyArg.value === 'string';
      const canUseDotNotation = isStringLiteral && isValidIdentifier(keyArg.value);
      return {
        type: 'CallExpression',
        callee: { type: 'MemberExpression', object: args[pattern.objIdx],
                  property: canUseDotNotation ? { type: 'Identifier', name: keyArg.value } : keyArg,
                  computed: !canUseDotNotation, optional: false },
        arguments: [{ type: 'SpreadElement', argument: args[pattern.argsIdx] }], optional: false
      };
    }
    case 'func_call':
      return {
        type: 'CallExpression', callee: args[pattern.funcIdx],
        arguments: [{ type: 'SpreadElement', argument: args[pattern.argsIdx] }], optional: false
      };
    case 'array_push':
      return {
        type: 'CallExpression',
        callee: { type: 'MemberExpression', object: args[pattern.arrIdx],
                  property: { type: 'Identifier', name: 'push' }, computed: false, optional: false },
        arguments: [args[pattern.valIdx]], optional: false
      };
    case 'nullish_check':
      return {
        type: 'BinaryExpression', operator: '==',
        left: args[pattern.paramIdx], right: { type: 'Literal', value: null, raw: 'null' }
      };
    case 'null_check':
      return {
        type: 'BinaryExpression', operator: '===',
        left: args[pattern.paramIdx], right: { type: 'Literal', value: null, raw: 'null' }
      };
    case 'undefined_check':
      return {
        type: 'BinaryExpression', operator: '===',
        left: args[pattern.paramIdx], right: { type: 'Identifier', name: 'undefined' }
      };
    case 'strict_equal':
      return {
        type: 'BinaryExpression', operator: '===',
        left: args[pattern.leftIdx], right: args[pattern.rightIdx]
      };
    default: return null;
  }
}

function inlineCalls(ast, inlineableFns) {
  let inlineCount = 0;
  function visit(node) {
    if (!node || typeof node !== 'object') return node;
    for (const key of Object.keys(node)) {
      const child = node[key];
      if (Array.isArray(child)) {
        for (let i = 0; i < child.length; i++) child[i] = visit(child[i]);
      } else if (child && typeof child === 'object') {
        node[key] = visit(child);
      }
    }
    if (node.type === 'CallExpression' && node.callee.type === 'Identifier') {
      const fnInfo = inlineableFns.get(node.callee.name);
      if (fnInfo) {
        const inlined = buildInlinedExpr(fnInfo.pattern, node.arguments);
        if (inlined) { inlineCount++; return inlined; }
      }
    }
    return node;
  }
  ast = visit(ast);
  return { ast, inlineCount };
}

function removeUnused(ast, inlineableFns) {
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
  ast.body = ast.body.filter(node => {
    if (node.type === 'VariableDeclaration') {
      node.declarations = node.declarations.filter(decl => {
        const name = decl.id.name;
        return !(refCounts.has(name) && refCounts.get(name) <= 1);
      });
      return node.declarations.length > 0;
    }
    return true;
  });
  return ast;
}

function inlineFfi(code) {
  const ast = acorn.parse(code, { ecmaVersion: 'latest', sourceType: 'module' });
  const inlineableFns = findInlineableFunctions(ast);
  const { ast: inlinedAst, inlineCount } = inlineCalls(ast, inlineableFns);
  const finalAst = removeUnused(inlinedAst, inlineableFns);
  return { code: astring.generate(finalAst), inlineCount, inlineableFns: inlineableFns.size };
}

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

  // Step 1: Inline FFI
  const { code: inlinedCode, inlineCount, inlineableFns } = inlineFfi(code);
  const inlinedSize = inlinedCode.length;

  // Step 2: Minify with oxc
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
  // Resolve paths relative to script location
  const scriptDir = import.meta.dirname;
  const projectRoot = path.resolve(scriptDir, '../..');

  // Build
  console.error('Building...');
  execSync('moon build --target js', { cwd: projectRoot, stdio: 'inherit' });

  // Find test directories
  const testsDir = path.join(scriptDir, '_tests');
  let testDirs;
  if (testName) {
    testDirs = [testName];
  } else {
    testDirs = fs.readdirSync(testsDir).filter(d =>
      fs.statSync(path.join(testsDir, d)).isDirectory()
    );
  }

  const results = [];

  for (const dir of testDirs) {
    const inputPath = path.join(projectRoot, `target/js/release/build/nostd/_tests/${dir}/${dir}.js`);
    if (!fs.existsSync(inputPath)) {
      console.error(`\n⚠️  Skipping ${dir}: ${inputPath} not found`);
      continue;
    }

    console.error(`\n=== Processing: ${dir} ===`);

    const code = fs.readFileSync(inputPath, 'utf-8');
    const originalSize = code.length;

    // Without FFI transform (minify only)
    const minifiedOnly = await minifyCode(code);
    const minifiedOnlySize = minifiedOnly.length;

    // With FFI transform (inline + minify)
    const { code: inlinedCode, inlineCount, inlineableFns } = inlineFfi(code);
    const inlinedSize = inlinedCode.length;
    const minifiedCode = await minifyCode(inlinedCode);
    const minifiedSize = minifiedCode.length;

    console.error(`Inlineable functions: ${inlineableFns}`);
    console.error(`Inlined calls: ${inlineCount}`);
    console.error(`Size: ${originalSize} -> ${minifiedOnlySize} bytes (minify only)`);
    console.error(`Size: ${originalSize} -> ${inlinedSize} -> ${minifiedSize} bytes (inline + minify)`);
    console.error(`FFI transform saves: ${minifiedOnlySize - minifiedSize} bytes`);

    // Print minified code if requested
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

    // Verify functionality
    console.error('Running minified code:');
    try {
      eval(minifiedCode);
    } catch (e) {
      console.error(`Error running ${dir}: ${e.message}`);
    }

    results.push({ name: dir, originalSize, minifiedOnlySize, inlinedSize, minifiedSize });
  }

  // Summary
  console.error(`\n=== Size Summary ===`);
  console.error('Test           | Original | Minify Only | With FFI | Saved');
  console.error('---------------|----------|-------------|----------|------');
  for (const r of results) {
    const saved = r.minifiedOnlySize - r.minifiedSize;
    console.error(`${r.name.padEnd(14)} | ${String(r.originalSize).padStart(8)} | ${String(r.minifiedOnlySize).padStart(11)} | ${String(r.minifiedSize).padStart(8)} | ${String(saved).padStart(5)}`);
  }

  // Check all pass (< 500 bytes)
  const failed = results.filter(r => r.minifiedSize > 500);
  if (failed.length > 0) {
    console.error(`\n⚠️  Warning: ${failed.length} test(s) exceed 500 bytes`);
    process.exit(1);
  } else {
    console.error(`\n✓ All size checks passed`);
  }
}

// CLI
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
