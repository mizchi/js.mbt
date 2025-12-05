# moonbit-optimize-plugin

Optimization plugin for MoonBit-generated JavaScript code. This plugin inlines FFI function calls to reduce bundle size and improve performance.

## Requirements

- **Node.js 24+** - Native TypeScript support (no build step required)

## Features

- ✅ **FFI Inlining** - Automatically inlines MoonBit FFI function calls
- ✅ **Build Tool Integration** - Supports Vite, Rollup, Webpack, and esbuild via unplugin
- ✅ **CLI Tool** - Standalone CLI for one-off optimizations
- ✅ **Zero Config** - Works out of the box with sensible defaults
- ✅ **Bundle Size Reduction** - Significantly reduces bundle size for MoonBit code

## Installation

```bash
npm install moonbit-optimize-plugin
# or
pnpm add moonbit-optimize-plugin
# or
yarn add moonbit-optimize-plugin
```

## Quick Start (MoonBit + Vite)

1. **Install the plugin:**
   ```bash
   pnpm add -D moonbit-optimize-plugin
   ```

2. **Add to `vite.config.ts`:**
   ```typescript
   import { defineConfig } from 'vite';
   import moonbitOptimize from 'moonbit-optimize-plugin/vite';

   export default defineConfig({
     plugins: [moonbitOptimize()],
   });
   ```

3. **Build your MoonBit code:**
   ```bash
   moon build --target js
   ```

4. **Build with Vite:**
   ```bash
   vite build
   ```

The plugin will automatically optimize all MoonBit-generated JavaScript files during the build process.

## Usage

### Vite (Recommended for MoonBit Projects)

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import moonbitOptimize from 'moonbit-optimize-plugin/vite';

export default defineConfig({
  plugins: [
    moonbitOptimize({
      // Include MoonBit-generated JS files
      include: /\.m?js$/,
      // Exclude node_modules
      exclude: /node_modules/,
    }),
  ],
  build: {
    // Recommended: Enable minification for additional size reduction
    minify: 'terser', // or 'esbuild'
    target: 'es2020',
  },
});
```

**Complete MoonBit + Vite setup:**

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import moonbitOptimize from 'moonbit-optimize-plugin/vite';

export default defineConfig({
  plugins: [
    // Apply MoonBit optimization before other transforms
    moonbitOptimize(),
  ],
  build: {
    // Generate sourcemaps for debugging
    sourcemap: true,
    // Minify for production
    minify: 'terser',
    rollupOptions: {
      input: {
        main: './index.html',
      },
    },
  },
  // If importing MoonBit modules directly
  resolve: {
    extensions: ['.js', '.mjs', '.ts'],
  },
});
```

### Rollup

```javascript
// rollup.config.js
import unplugin from 'moonbit-optimize-plugin/rollup';

export default {
  plugins: [
    unplugin({
      include: /\.m?js$/,
    }),
  ],
};
```

### Webpack

```javascript
// webpack.config.js
import unplugin from 'moonbit-optimize-plugin/webpack';

module.exports = {
  plugins: [
    unplugin({
      include: /\.m?js$/,
    }),
  ],
};
```

### esbuild

```javascript
// build.js
import { build } from 'esbuild';
import unplugin from 'moonbit-optimize-plugin/esbuild';

build({
  plugins: [
    unplugin({
      include: /\.m?js$/,
    }),
  ],
});
```

## CLI Usage

Transform a single file:

```bash
npx moonbit-optimize input.js output.js
```

Or pipe through stdin/stdout:

```bash
moon build --output-js | npx moonbit-optimize > output.js
```

## Options

```typescript
interface PluginOptions {
  /**
   * Files to include (default: /\.m?js$/)
   * Can be a RegExp, string, or function
   */
  include?: RegExp | string | ((id: string) => boolean);

  /**
   * Files to exclude (default: /node_modules/)
   * Can be a RegExp, string, or function
   */
  exclude?: RegExp | string | ((id: string) => boolean);
}
```

## How It Works

The plugin analyzes MoonBit-generated JavaScript code and identifies FFI function calls that can be safely inlined. It then replaces these calls with their inline implementations, reducing function call overhead and enabling better minification.

### Real-World Example

**Before optimization (1279 bytes):**

```javascript
const mizchi$js$core$$global_this = () => globalThis;
const mizchi$js$core$$new_object = () => ({});
const mizchi$js$core$$new_array = () => [];
const mizchi$js$core$$is_nullish = (v) => v == null;
const mizchi$js$core$$Any$_get = (obj, key) => obj[key];
const mizchi$js$core$$Any$_set = (obj, key, value) => { obj[key] = value };
const mizchi$js$core$$Any$_call = (obj, key, args) => obj[key](...args);
// ... more FFI functions

function main() {
  const obj = mizchi$js$core$$new_object();
  mizchi$js$core$$Any$_set(obj, "name", "test");
  const value = mizchi$js$core$$Any$_get(obj, "name");
  const arr = mizchi$js$core$$new_array();
  const g = mizchi$js$core$$global_this();

  if (mizchi$js$core$$is_nullish(value)) {
    console.log("is nullish");
  }

  const console_obj = mizchi$js$core$$Any$_get(g, "console");
  const args = mizchi$js$core$$new_array();
  mizchi$js$core$$Any$_call(console_obj, "log", args);
}
```

**After optimization (331 bytes, 74% reduction):**

```javascript
function main() {
  const obj = {};
  obj.name = "test";
  const value = obj.name;
  const arr = [];
  const g = globalThis;

  if (value == null) {
    console.log("is nullish");
  }

  const console_obj = g.console;
  const args = [];
  console_obj.log(...args);
}
```

**Optimization stats:**
- Inlineable functions: 13
- Inlined calls: 9
- Size reduction: **74.1%** (948 bytes saved)

## Performance

Real-world results with MoonBit-generated code:
- **70-80%** size reduction for FFI-heavy code (before minification)
- **40-60%** size reduction for typical applications
- **20-30%** additional reduction when combined with minifiers (oxc-minify, terser)

Best results are achieved when:
- Using `@core` package FFI functions (`Any`, `new_object`, `new_array`, etc.)
- Combining with tree-shaking and minification
- Applied early in the build pipeline (before other transforms)

## Supported FFI Patterns

The plugin automatically inlines the following `@core` package functions:

### Object Operations
- `global_this()` → `globalThis`
- `undefined()` → `undefined`
- `null()` → `null`
- `new_object()` → `{}`
- `new_array()` → `[]`

### Type Checks
- `is_nullish(x)` → `x == null`
- `is_null(x)` → `x === null`
- `is_undefined(x)` → `x === undefined`
- `equal(a, b)` → `a === b`

### Property Access
- `Any$_get(obj, "key")` → `obj.key` or `obj["key"]`
- `Any$_set(obj, "key", val)` → `obj.key = val`
- `Any$_call(obj, "method", args)` → `obj.method(...args)`
- `Any$_invoke(fn, args)` → `fn(...args)`

### Constant Patterns
The plugin also inlines simple constant functions:
```javascript
const get_console = () => console;  // Inlined to: console
const get_42 = () => 42;            // Inlined to: 42
```

## Programmatic API

```typescript
import { transform } from 'moonbit-optimize-plugin';

const code = `
const mizchi$js$core$$new_object = () => ({});
const obj = mizchi$js$core$$new_object();
`;

const { code: optimized, inlineCount, inlineableFns } = transform(code);

console.log(optimized);
// const obj = {};

console.log(`Inlined ${inlineCount} calls from ${inlineableFns} functions`);
```

## License

MIT

## See Also

- [MoonBit Language](https://www.moonbitlang.com/)
- [unplugin](https://github.com/unjs/unplugin) - Universal plugin system
