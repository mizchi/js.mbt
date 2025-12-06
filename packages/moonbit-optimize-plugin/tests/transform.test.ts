import { test, describe } from 'node:test';
import assert from 'node:assert';
import { transform } from '../src/transform.ts';

describe('transform', () => {
  // ============================================================================
  // Named pattern tests (MoonBit FFI naming conventions)
  // namespace$$funcName pattern, only 'core' namespace is inlined
  // ============================================================================

  describe('named patterns (core namespace)', () => {
    test('global_this', () => {
      const code = `
        const pkg$core$$global_this = () => globalThis;
        const g = pkg$core$$global_this();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const g = globalThis'));
      assert.ok(!result.includes('pkg$core$$global_this'));
    });

    test('undefined', () => {
      const code = `
        const pkg$core$$undefined = () => undefined;
        const u = pkg$core$$undefined();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const u = undefined'));
      assert.ok(!result.includes('pkg$core$$undefined'));
    });

    test('null', () => {
      const code = `
        const pkg$core$$null = () => null;
        const n = pkg$core$$null();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const n = null'));
      assert.ok(!result.includes('pkg$core$$null'));
    });

    test('JsArray$new', () => {
      const code = `
        const pkg$core$$JsArray$new = () => [];
        const arr = pkg$core$$JsArray$new();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const arr = []'));
      assert.ok(!result.includes('pkg$core$$JsArray$new'));
    });

    test('Object$new', () => {
      const code = `
        const pkg$core$$Object$new = () => ({});
        const obj = pkg$core$$Object$new();
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const obj = {}'));
      assert.ok(!result.includes('pkg$core$$Object$new'));
    });

    test('is_nullish', () => {
      const code = `
        const pkg$core$$is_nullish = (v) => v == null;
        const x = pkg$core$$is_nullish(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo == null'));
      assert.ok(!result.includes('pkg$core$$is_nullish'));
    });

    test('is_null', () => {
      const code = `
        const pkg$core$$is_null = (v) => v === null;
        const x = pkg$core$$is_null(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === null'));
      assert.ok(!result.includes('pkg$core$$is_null'));
    });

    test('is_undefined', () => {
      const code = `
        const pkg$core$$is_undefined = (v) => v === undefined;
        const x = pkg$core$$is_undefined(foo);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === undefined'));
      assert.ok(!result.includes('pkg$core$$is_undefined'));
    });

    test('equal', () => {
      const code = `
        const pkg$core$$equal = (a, b) => a === b;
        const x = pkg$core$$equal(foo, bar);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo === bar'));
      assert.ok(!result.includes('pkg$core$$equal'));
    });

    test('Any$_get with valid identifier key', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const x = pkg$core$$Any$_get(foo, "bar");
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo.bar'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
    });

    test('Any$_get with computed key', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const x = pkg$core$$Any$_get(foo, "123invalid");
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo["123invalid"]'));
    });

    test('Any$_set', () => {
      const code = `
        const pkg$core$$Any$_set = (obj, key, val) => { obj[key] = val };
        pkg$core$$Any$_set(foo, "bar", 123);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('foo.bar = 123'));
      assert.ok(!result.includes('pkg$core$$Any$_set'));
    });

    test('Any$_call', () => {
      const code = `
        const pkg$core$$Any$_call = (obj, key, args) => obj[key](...args);
        const result = pkg$core$$Any$_call(console, "log", myArgs);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('console.log(...myArgs)'));
      assert.ok(!result.includes('pkg$core$$Any$_call'));
    });

    test('Any$_invoke', () => {
      const code = `
        const pkg$core$$Any$_invoke = (fn, args) => fn(...args);
        const result = pkg$core$$Any$_invoke(myFunc, myArgs);
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('myFunc(...myArgs)'));
      assert.ok(!result.includes('pkg$core$$Any$_invoke'));
    });

    test('Any$_invoke with array literal - should expand to natural form', () => {
      const code = `
        const pkg$core$$Any$_invoke = (fn, args) => fn(...args);
        const result = pkg$core$$Any$_invoke(myFunc, [1, 2, 3]);
      `;
      const { code: result } = transform(code);
      // Should be myFunc(1, 2, 3) not myFunc(...[1, 2, 3])
      assert.ok(result.includes('myFunc(1, 2, 3)'));
      assert.ok(!result.includes('...'));
      assert.ok(!result.includes('pkg$core$$Any$_invoke'));
    });

    test('Any$_call with array literal - should expand to natural form', () => {
      const code = `
        const pkg$core$$Any$_call = (obj, key, args) => obj[key](...args);
        const result = pkg$core$$Any$_call(console, "log", [1, 2, 3]);
      `;
      const { code: result } = transform(code);
      // Should be console.log(1, 2, 3) not console.log(...[1, 2, 3])
      assert.ok(result.includes('console.log(1, 2, 3)'));
      assert.ok(!result.includes('...'));
      assert.ok(!result.includes('pkg$core$$Any$_call'));
    });

    test('Any$_invoke with variable - should use spread', () => {
      const code = `
        const pkg$core$$Any$_invoke = (fn, args) => fn(...args);
        const myArgs = [1, 2, 3];
        const result = pkg$core$$Any$_invoke(myFunc, myArgs);
      `;
      const { code: result } = transform(code);
      // Should be myFunc(...myArgs) with spread
      assert.ok(result.includes('myFunc(...myArgs)'));
      assert.ok(!result.includes('pkg$core$$Any$_invoke'));
    });
  });

  // ============================================================================
  // Non-core namespace should NOT be inlined
  // ============================================================================

  describe('non-core namespace', () => {
    test('other namespace is not inlined', () => {
      const code = `
        const pkg$other$$global_this = () => globalThis;
        const g = pkg$other$$global_this();
      `;
      const { code: result, inlineCount } = transform(code);
      // Should not be inlined because namespace is 'other', not 'core'
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
        const pkg$core$$JsArray$new = () => [];
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$global_this = () => globalThis;

        const g = pkg$core$$global_this();
        const console = pkg$core$$Any$_get(g, "console");
        const args = pkg$core$$JsArray$new();
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('const g = globalThis'));
      assert.ok(result.includes('const args = []'));
      assert.ok(result.includes('g.console'));
      assert.strictEqual(inlineCount, 3);
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
        const pkg$core$$global_this = () => globalThis;
        const pkg$core$$undefined = () => undefined;
        const x = pkg$core$$global_this();
      `;
      const { code: result } = transform(code);
      assert.ok(!result.includes('pkg$core$$global_this'));
      assert.ok(!result.includes('pkg$core$$undefined'));
      assert.ok(result.includes('const x = globalThis'));
    });

    test('real MoonBit output pattern', () => {
      const code = `
        const mizchi$js$core$$is_nullish = (v) => v == null;
        const mizchi$js$core$$JsArray$new = () => [];
        const mizchi$js$core$$Any$_call = (obj, key, args) => obj[key](...args);
        const mizchi$js$core$$Any$_get = (obj, key) => obj[key];
        const mizchi$js$core$$global_this = () => globalThis;
        const mizchi$js$nostd$_tests$size1$$get_console = () => console;
        (() => {
          const con = mizchi$js$nostd$_tests$size1$$get_console();
          const args = mizchi$js$core$$JsArray$new();
          mizchi$js$core$$Any$_call(con, "log", args);
          const global = mizchi$js$core$$global_this();
          const process = mizchi$js$core$$Any$_get(global, "process");
          if (mizchi$js$core$$is_nullish(process)) {
            return;
          }
        })();
      `;
      const { code: result, inlineCount } = transform(code);
      assert.ok(result.includes('const con = console'));
      assert.ok(result.includes('const args = []'));
      assert.ok(result.includes('con.log(...args)'));
      assert.ok(result.includes('const global = globalThis'));
      assert.ok(result.includes('global.process'));
      assert.ok(result.includes('process == null'));
      assert.strictEqual(inlineCount, 6);
    });

    test('sourcemap generation', () => {
      const code = `
        const pkg$core$$global_this = () => globalThis;
        const g = pkg$core$$global_this();
      `;
      const { map } = transform(code, { sourcemap: true });
      assert.ok(map);
      assert.ok(map.mappings);
    });

    test('keeps declaration when function is used as value', () => {
      const code = `
        const pkg$core$$global_this = () => globalThis;
        const a = pkg$core$$global_this();
        const b = pkg$core$$global_this;
      `;
      const { code: result, inlineCount } = transform(code);
      // First call should be inlined
      assert.ok(result.includes('const a = globalThis'));
      // But declaration must be kept because `b` references it as a value
      assert.ok(result.includes('pkg$core$$global_this'));
      assert.ok(result.includes('const b = pkg$core$$global_this'));
      assert.strictEqual(inlineCount, 1);
    });

    test('keeps declaration when function is passed as argument', () => {
      const code = `
        const pkg$core$$global_this = () => globalThis;
        const a = pkg$core$$global_this();
        const funcs = [pkg$core$$global_this];
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const a = globalThis'));
      assert.ok(result.includes('pkg$core$$global_this'));
      assert.ok(result.includes('[pkg$core$$global_this]'));
    });

    test('nested Any$_set calls', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$Any$_set = (obj, key, val) => { obj[key] = val };

        function test(obj) {
          pkg$core$$Any$_set(pkg$core$$Any$_get(obj, "nested"), "key", 123);
        }
      `;
      const { code: result } = transform(code);
      // Should inline both: obj.nested.key = 123
      assert.ok(result.includes('obj.nested.key = 123'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$Any$_set'));
    });

    test('nested Any$_call with Any$_get', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$Any$_call = (obj, key, args) => obj[key](...args);

        function test(obj) {
          const args = [1, 2, 3];
          pkg$core$$Any$_call(pkg$core$$Any$_get(obj, "console"), "log", args);
        }
      `;
      const { code: result } = transform(code);
      // Should inline both: obj.console.log(...args)
      assert.ok(result.includes('obj.console.log(...args)'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$Any$_call'));
    });

    test('nested Any$_invoke with function from Any$_get', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$Any$_invoke = (fn, args) => fn(...args);

        function test(obj) {
          const args = [1, 2, 3];
          pkg$core$$Any$_invoke(pkg$core$$Any$_get(obj, "fn"), args);
        }
      `;
      const { code: result } = transform(code);
      // Should inline both: obj.fn(...args)
      assert.ok(result.includes('obj.fn(...args)'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$Any$_invoke'));
    });

    test('deeply nested calls (3 levels)', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$is_nullish = (v) => v == null;
        const pkg$core$$global_this = () => globalThis;

        function test() {
          if (pkg$core$$is_nullish(pkg$core$$Any$_get(pkg$core$$global_this(), "process"))) {
            return;
          }
        }
      `;
      const { code: result } = transform(code);
      // Should inline all three: globalThis.process == null
      assert.ok(result.includes('globalThis.process == null'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$is_nullish'));
      assert.ok(!result.includes('pkg$core$$global_this'));
    });

    test('multiple nested calls in same expression', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$equal = (a, b) => a === b;

        function test(obj1, obj2) {
          if (pkg$core$$equal(pkg$core$$Any$_get(obj1, "value"), pkg$core$$Any$_get(obj2, "value"))) {
            return true;
          }
        }
      `;
      const { code: result } = transform(code);
      // Should inline all: obj1.value === obj2.value
      assert.ok(result.includes('obj1.value === obj2.value'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$equal'));
    });

    test('Any$_set with nested value', () => {
      const code = `
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$Any$_set = (obj, key, val) => { obj[key] = val };

        function test(obj, source) {
          pkg$core$$Any$_set(obj, "value", pkg$core$$Any$_get(source, "value"));
        }
      `;
      const { code: result } = transform(code);
      // Should inline both: obj.value = source.value
      assert.ok(result.includes('obj.value = source.value'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$Any$_set'));
    });

    test('complex real-world pattern', () => {
      const code = `
        const pkg$core$$is_nullish = (v) => v == null;
        const pkg$core$$Any$_get = (obj, key) => obj[key];
        const pkg$core$$Any$_call = (obj, key, args) => obj[key](...args);
        const pkg$core$$new_array = () => [];
        const pkg$core$$global_this = () => globalThis;

        function test() {
          const g = pkg$core$$global_this();
          const console = pkg$core$$Any$_get(g, "console");
          const args = pkg$core$$new_array();
          pkg$core$$Any$_call(console, "log", args);

          if (pkg$core$$is_nullish(pkg$core$$Any$_get(g, "process"))) {
            return;
          }
        }
      `;
      const { code: result } = transform(code);
      assert.ok(result.includes('const g = globalThis'));
      assert.ok(result.includes('const console = g.console'));
      assert.ok(result.includes('const args = []'));
      assert.ok(result.includes('console.log(...args)'));
      assert.ok(result.includes('g.process == null'));
      assert.ok(!result.includes('pkg$core$$is_nullish'));
      assert.ok(!result.includes('pkg$core$$Any$_get'));
      assert.ok(!result.includes('pkg$core$$Any$_call'));
      assert.ok(!result.includes('pkg$core$$new_array'));
      assert.ok(!result.includes('pkg$core$$global_this'));
    });
  });
});
