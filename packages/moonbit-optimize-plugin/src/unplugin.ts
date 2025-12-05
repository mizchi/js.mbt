/**
 * MoonBit FFI optimization unplugin
 *
 * Provides build plugins for Vite, Rollup, Webpack, and esbuild
 * that inline MoonBit FFI function calls for smaller bundle sizes.
 *
 * Supports @core and @nostd package FFI functions.
 *
 * Usage:
 *   import moonbitOptimize from 'moonbit-optimize-plugin/vite';
 *   // or
 *   import { vite, rollup, webpack, esbuild } from 'moonbit-optimize-plugin';
 */
import { createUnplugin } from 'unplugin';
import { transform } from './transform.ts';

// ============================================================================
// Plugin Options
// ============================================================================

export interface PluginOptions {
  /** Files to include (default: /\.m?js$/) */
  include?: RegExp | string | ((id: string) => boolean);
  /** Files to exclude (default: /node_modules/) */
  exclude?: RegExp | string | ((id: string) => boolean);
}

// ============================================================================
// Unplugin Definition
// ============================================================================

const unplugin = createUnplugin((options: PluginOptions = {}) => {
  const {
    include = /\.m?js$/,
    exclude = /node_modules/,
  } = options;

  function shouldTransform(id: string): boolean {
    if (typeof exclude === 'function' ? exclude(id) : typeof exclude === 'string' ? id.includes(exclude) : exclude.test(id)) {
      return false;
    }
    if (typeof include === 'function' ? include(id) : typeof include === 'string' ? id.includes(include) : include.test(id)) {
      return true;
    }
    return false;
  }

  return {
    name: 'moonbit-optimize',
    enforce: 'pre' as const,

    transformInclude(id: string) {
      return shouldTransform(id);
    },

    transform(code: string, _id: string) {
      const result = transform(code, { sourcemap: true });
      if (result.inlineCount === 0) return null;

      return {
        code: result.code,
        map: result.map
      };
    }
  };
});

export default unplugin;
export const vite = unplugin.vite;
export const rollup = unplugin.rollup;
export const webpack = unplugin.webpack;
export const esbuild = unplugin.esbuild;
export const rspack = unplugin.rspack;
