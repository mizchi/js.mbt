import { test, describe } from 'node:test';
import assert from 'node:assert';
import { transform } from './transform';

describe('transform', () => {
  // ============================================================================
  // Named pattern tests (MoonBit FFI naming conventions)
  // namespace$$funcName pattern, only 'nostd' namespace is inlined
  // ============================================================================

  describe('named patterns (nostd namespace)', () => {
    test('global_this', () => {
      const code = `
        const pkg$nostd$$global_this = () => globalThis;
        const g = pkg$nostd$$global_this();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const g = globalThis'));
      assert.ok(!result.includes('pkg$nostd$$global_this'));
    });

    test('undefined', () => {
      const code = `
        const pkg$nostd$$undefined = () => undefined;
        const u = pkg$nostd$$undefined();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const u = undefined'));
      assert.ok(!result.includes('pkg$nostd$$undefined'));
    });

    test('null', () => {
      const code = `
        const pkg$nostd$$null = () => null;
        const n = pkg$nostd$$null();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const n = null'));
      assert.ok(!result.includes('pkg$nostd$$null'));
    });

    test('JsArray$new', () => {
      const code = `
        const pkg$nostd$$JsArray$new = () => [];
        const arr = pkg$nostd$$JsArray$new();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const arr = []'));
      assert.ok(!result.includes('pkg$nostd$$JsArray$new'));
    });

    test('Object$new', () => {
      const code = `
        const pkg$nostd$$Object$new = () => ({});
        const obj = pkg$nostd$$Object$new();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const obj = {}'));
      assert.ok(!result.includes('pkg$nostd$$Object$new'));
    });

    test('is_nullish', () => {
      const code = `
        const pkg$nostd$$is_nullish = (v) => v == null;
        const x = pkg$nostd$$is_nullish(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo == null'));
      assert.ok(!result.includes('pkg$nostd$$is_nullish'));
    });

    test('is_null', () => {
      const code = `
        const pkg$nostd$$is_null = (v) => v === null;
        const x = pkg$nostd$$is_null(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === null'));
      assert.ok(!result.includes('pkg$nostd$$is_null'));
    });

    test('is_undefined', () => {
      const code = `
        const pkg$nostd$$is_undefined = (v) => v === undefined;
        const x = pkg$nostd$$is_undefined(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === undefined'));
      assert.ok(!result.includes('pkg$nostd$$is_undefined'));
    });

    test('equal', () => {
      const code = `
        const pkg$nostd$$equal = (a, b) => a === b;
        const x = pkg$nostd$$equal(foo, bar);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === bar'));
      assert.ok(!result.includes('pkg$nostd$$equal'));
    });

    test('JsArray$_push', () => {
      const code = `
        const pkg$nostd$$JsArray$_push = (arr, val) => arr.push(val);
        const a = [];
        pkg$nostd$$JsArray$_push(a, 1);
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('a.push(1)'));
      assert.strictEqual(inlineCount, 1);
    });

    test('JsValue$_get with valid identifier key', () => {
      const code = `
        const pkg$nostd$$JsValue$_get = (obj, key) => obj[key];
        const x = pkg$nostd$$JsValue$_get(foo, "bar");
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo.bar'));
      assert.ok(!result.includes('pkg$nostd$$JsValue$_get'));
    });

    test('JsValue$_get with computed key', () => {
      const code = `
        const pkg$nostd$$JsValue$_get = (obj, key) => obj[key];
        const x = pkg$nostd$$JsValue$_get(foo, "123invalid");
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo["123invalid"]'));
    });

    test('JsValue$_set', () => {
      const code = `
        const pkg$nostd$$JsValue$_set = (obj, key, val) => { obj[key] = val };
        pkg$nostd$$JsValue$_set(foo, "bar", 123);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo.bar = 123'));
      assert.ok(!result.includes('pkg$nostd$$JsValue$_set'));
    });

    test('JsValue$_call', () => {
      const code = `
        const pkg$nostd$$JsValue$_call = (obj, key, args) => obj[key](...args);
        const result = pkg$nostd$$JsValue$_call(console, "log", myArgs);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('console.log(...myArgs)'));
      assert.ok(!result.includes('pkg$nostd$$JsValue$_call'));
    });

    test('JsValue$_invoke', () => {
      const code = `
        const pkg$nostd$$JsValue$_invoke = (fn, args) => fn(...args);
        const result = pkg$nostd$$JsValue$_invoke(myFunc, myArgs);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('myFunc(...myArgs)'));
      assert.ok(!result.includes('pkg$nostd$$JsValue$_invoke'));
    });
  });

  // ============================================================================
  // Non-nostd namespace should NOT be inlined
  // ============================================================================

  describe('non-nostd namespace', () => {
    test('other namespace is not inlined', () => {
      const code = `
        const pkg$other$$global_this = () => globalThis;
        const g = pkg$other$$global_this();
      `;
      const { code: result, inlineCount } = transform(code);
      // Should not be inlined because namespace is 'other', not 'nostd'
      assert.ok(result.includes('pkg$other$$global_this'));
      assert.strictEqual(inlineCount, 0);
    });
  });

  // ============================================================================
  // Constant pattern tests (user-defined extern "js" fn)
  // ============================================================================

  describe('constant patterns', () => {
    test('() => identifier', () => {
      const code = `
        const get_console = () => console;
        const x = get_console();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const x = console'));
      assert.ok(!result.includes('get_console'));
    });

    test('() => literal', () => {
      const code = `
        const get_42 = () => 42;
        const x = get_42();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const x = 42'));
      assert.ok(!result.includes('get_42'));
    });

    test('() => []', () => {
      const code = `
        const empty_array = () => [];
        const x = empty_array();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const x = []'));
      assert.ok(!result.includes('empty_array'));
    });

    test('() => {}', () => {
      const code = `
        const empty_obj = () => ({});
        const x = empty_obj();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const x = {}'));
      assert.ok(!result.includes('empty_obj'));
    });
  });

  // ============================================================================
  // Integration tests
  // ============================================================================

  describe('integration', () => {
    test('multiple inlines in same code', () => {
      const code = `
        const pkg$nostd$$JsArray$new = () => [];
        const pkg$nostd$$JsArray$_push = (arr, val) => arr.push(val);
        const pkg$nostd$$JsValue$_get = (obj, key) => obj[key];
        const pkg$nostd$$global_this = () => globalThis;

        const g = pkg$nostd$$global_this();
        const console = pkg$nostd$$JsValue$_get(g, "console");
        const args = pkg$nostd$$JsArray$new();
        pkg$nostd$$JsArray$_push(args, "hello");
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('const g = globalThis'));
      assert.ok(result.includes('const args = []'));
      assert.ok(result.includes('args.push("hello")'));
      assert.ok(result.includes('g.console'));
      assert.strictEqual(inlineCount, 4);
    });

    test('does not inline non-matching patterns', () => {
      const code = `
        const complex = (a, b) => a + b * 2;
        const x = complex(1, 2);
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('const complex'));
      assert.ok(result.includes('complex(1, 2)'));
      assert.strictEqual(inlineCount, 0);
    });

    test('removes unused inlineable functions', () => {
      const code = `
        const pkg$nostd$$global_this = () => globalThis;
        const pkg$nostd$$undefined = () => undefined;
        const x = pkg$nostd$$global_this();
      `;
      const { code: result } = transform(code);
      assert.ok(!result.includes('pkg$nostd$$global_this'));
      assert.ok(!result.includes('pkg$nostd$$undefined'));
      assert.ok(result.includes('const x = globalThis'));
    });

    test('real MoonBit output pattern', () => {
      const code = `
        const mizchi$js$nostd$$is_nullish = (v) => v == null;
        const mizchi$js$nostd$$JsArray$new = () => [];
        const mizchi$js$nostd$$JsArray$_push = (arr, value) => arr.push(value);
        const mizchi$js$nostd$$JsValue$_call = (obj, key, args) => obj[key](...args);
        const mizchi$js$nostd$$JsValue$_get = (obj, key) => obj[key];
        const mizchi$js$nostd$$global_this = () => globalThis;
        const mizchi$js$nostd$_tests$size1$$get_console = () => console;
        (() => {
          const con = mizchi$js$nostd$_tests$size1$$get_console();
          const args = mizchi$js$nostd$$JsArray$new();
          mizchi$js$nostd$$JsArray$_push(args, "hello");
          mizchi$js$nostd$$JsValue$_call(con, "log", args);
          const global = mizchi$js$nostd$$global_this();
          const process = mizchi$js$nostd$$JsValue$_get(global, "process");
          if (mizchi$js$nostd$$is_nullish(process)) {
            return;
          }
        })();
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('const con = console'));
      assert.ok(result.includes('const args = []'));
      assert.ok(result.includes('args.push("hello")'));
      assert.ok(result.includes('con.log(...args)'));
      assert.ok(result.includes('const global = globalThis'));
      assert.ok(result.includes('global.process'));
      assert.ok(result.includes('process == null'));
      assert.strictEqual(inlineCount, 7);
    });

    test('sourcemap generation', () => {
      const code = `
        const pkg$nostd$$global_this = () => globalThis;
        const g = pkg$nostd$$global_this();
      `;
      const { map } = transform(code, { sourcemap: true });
      assert.ok(map);
      assert.ok(map.mappings);
    });
  });
});
