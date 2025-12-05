import { defineConfig } from 'vite';
import moonbitOptimize from './packages/moonbit-optimize-plugin/src/unplugin.ts';

export default defineConfig({
  plugins: [
    moonbitOptimize.vite({
      include: /\.m?js$/,
      exclude: /node_modules/,
    }),
  ],
  build: {
    lib: {
      entry: './test-build/input.js',
      name: 'MoonBitTest',
      fileName: 'output',
      formats: ['es'],
    },
    sourcemap: false,
    minify: 'esbuild', // Enable minification
    rollupOptions: {
      output: {
        dir: 'dist-minified',
      },
    },
  },
});
