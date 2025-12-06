import { defineConfig } from 'vite';
import moonbitOptimize from './packages/moonbit-optimize-plugin/src/unplugin.ts';

export default defineConfig({
  plugins: [
    process.env.USE_EXPERIMENTAL_OPTIMIZE ? moonbitOptimize.vite({
      include: /\.m?js$/,
      exclude: /node_modules/,
    }) : undefined,
  ],
});
