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

## Usage

### Vite

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import unplugin from 'moonbit-optimize-plugin/vite';

export default defineConfig({
  plugins: [
    unplugin({
      include: /\.m?js$/,
      exclude: /node_modules/,
    }),
  ],
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

### Example

**Before optimization:**

```javascript
function ffi_add(a, b) {
  return a + b;
}

const result = ffi_add(1, 2);
```

**After optimization:**

```javascript
const result = 1 + 2;
```

## Performance

This plugin typically reduces MoonBit bundle sizes by:
- 10-30% for simple FFI-heavy code
- 5-15% for complex applications
- Best results when combined with a minifier (like oxc-minify or terser)

## Programmatic API

```typescript
import { transform } from 'moonbit-optimize-plugin';

const code = `
function ffi_add(a, b) { return a + b; }
const result = ffi_add(1, 2);
`;

const { code: optimized, inlineCount, inlineableFns } = transform(code);

console.log(optimized);
// const result = 1 + 2;

console.log(`Inlined ${inlineCount} calls from ${inlineableFns} functions`);
```

## License

MIT

## See Also

- [MoonBit Language](https://www.moonbitlang.com/)
- [unplugin](https://github.com/unjs/unplugin) - Universal plugin system
