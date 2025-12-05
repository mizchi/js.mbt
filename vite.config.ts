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
    sourcemap: true,
    minify: 'esbuild',
    rollupOptions: {
      input: {
        main: './index.html',
      },
      output: {
        dir: 'dist',
        // Preserve original structure for easier comparison
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name].js',
      },
    },
  },
});
