import { test, describe } from 'node:test';
import assert from 'node:assert';
import { inlineFfi } from './minify.mjs';

describe('inlineFfi', () => {
  test('constant pattern: () => value', () => {
    const code = `
      const get_console = () => console;
      const x = get_console();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const x = console'));
    assert.ok(!result.includes('get_console'));
  });

  test('constant pattern: () => globalThis', () => {
    const code = `
      const global_this = () => globalThis;
      const g = global_this();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const g = globalThis'));
    assert.ok(!result.includes('global_this'));
  });

  test('constant pattern: () => []', () => {
    const code = `
      const array_new = () => [];
      const arr = array_new();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const arr = []'));
    assert.ok(!result.includes('array_new'));
  });

  test('constant pattern: () => undefined', () => {
    const code = `
      const get_undefined = () => undefined;
      const u = get_undefined();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const u = undefined'));
    assert.ok(!result.includes('get_undefined'));
  });

  test('constant pattern: () => null', () => {
    const code = `
      const get_null = () => null;
      const n = get_null();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const n = null'));
    assert.ok(!result.includes('get_null'));
  });

  test('array_push pattern: arr.push(value)', () => {
    const code = `
      const push = (arr, val) => arr.push(val);
      const a = [];
      push(a, 1);
    `;
    const { code: result, inlineCount } = inlineFfi(code);
    assert.ok(result.includes('a.push(1)'));
    assert.strictEqual(inlineCount, 1);
  });

  test('member_get pattern: obj[key]', () => {
    const code = `
      const get = (obj, key) => obj[key];
      const x = get(foo, "bar");
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo.bar') || result.includes('foo["bar"]'));
    assert.ok(!result.includes('const get'));
  });

  test('member_get with dot notation for valid identifiers', () => {
    const code = `
      const get = (obj, key) => obj[key];
      const x = get(foo, "validKey");
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo.validKey'));
  });

  test('member_set pattern: obj[key] = value', () => {
    const code = `
      const set = (obj, key, val) => { obj[key] = val };
      set(foo, "bar", 123);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo.bar = 123') || result.includes('foo["bar"] = 123'));
    assert.ok(!result.includes('const set'));
  });

  test('member_call pattern: obj[key](...args)', () => {
    const code = `
      const call = (obj, key, args) => obj[key](...args);
      const result = call(console, "log", myArgs);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('console.log(...myArgs)'));
    assert.ok(!result.includes('const call'));
  });

  test('nullish_check pattern: v == null', () => {
    const code = `
      const is_nullish = (v) => v == null;
      const x = is_nullish(foo);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo == null'));
    assert.ok(!result.includes('is_nullish'));
  });

  test('null_check pattern: v === null', () => {
    const code = `
      const is_null = (v) => v === null;
      const x = is_null(foo);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo === null'));
    assert.ok(!result.includes('is_null'));
  });

  test('undefined_check pattern: v === undefined', () => {
    const code = `
      const is_undefined = (v) => v === undefined;
      const x = is_undefined(foo);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo === undefined'));
    assert.ok(!result.includes('is_undefined'));
  });

  test('strict_equal pattern: a === b', () => {
    const code = `
      const equal = (a, b) => a === b;
      const x = equal(foo, bar);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('foo === bar'));
    assert.ok(!result.includes('const equal'));
  });

  test('static_method_call pattern: console.log(msg)', () => {
    const code = `
      const log = (msg) => console.log(msg);
      log("hello");
    `;
    const { code: result, inlineCount } = inlineFfi(code);
    assert.ok(result.includes('console.log("hello")'));
    assert.strictEqual(inlineCount, 1);
  });

  test('func_call pattern: func(...args)', () => {
    const code = `
      const invoke = (fn, args) => fn(...args);
      const result = invoke(myFunc, myArgs);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('myFunc(...myArgs)'));
    assert.ok(!result.includes('const invoke'));
  });

  test('identity pattern: (v) => v', () => {
    const code = `
      const identity = (v) => v;
      const x = identity(foo);
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(result.includes('const x = foo'));
    assert.ok(!result.includes('identity'));
  });

  test('multiple inlines in same code', () => {
    const code = `
      const array_new = () => [];
      const push = (arr, val) => arr.push(val);
      const get = (obj, key) => obj[key];
      const global_this = () => globalThis;

      const g = global_this();
      const console = get(g, "console");
      const args = array_new();
      push(args, "hello");
    `;
    const { code: result, inlineCount } = inlineFfi(code);
    assert.ok(result.includes('const g = globalThis'));
    assert.ok(result.includes('const args = []'));
    assert.ok(result.includes('args.push("hello")'));
    assert.ok(result.includes('g.console') || result.includes('g["console"]'));
    assert.strictEqual(inlineCount, 4);
  });

  test('does not inline non-matching patterns', () => {
    const code = `
      const complex = (a, b) => a + b * 2;
      const x = complex(1, 2);
    `;
    const { code: result, inlineCount } = inlineFfi(code);
    assert.ok(result.includes('const complex'));
    assert.ok(result.includes('complex(1, 2)'));
    assert.strictEqual(inlineCount, 0);
  });

  test('removes unused inlineable functions', () => {
    const code = `
      const used = () => console;
      const unused = () => globalThis;
      const x = used();
    `;
    const { code: result } = inlineFfi(code);
    assert.ok(!result.includes('const used'));
    assert.ok(!result.includes('const unused'));
    assert.ok(result.includes('const x = console'));
  });
});
