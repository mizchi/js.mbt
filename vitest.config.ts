import { defineWorkersConfig } from "@cloudflare/vitest-pool-workers/config";

export default defineWorkersConfig({
  test: {
    poolOptions: {
      workers: {
        wrangler: { configPath: "./wrangler.toml" },
        miniflare: {
          // Add any Miniflare-specific options here
          kvNamespaces: ["TEST_KV"],
          d1Databases: ["TEST_DB"],
          r2Buckets: ["TEST_R2"],
          durableObjects: {
            TEST_DO: "TestDurableObject",
          },
        },
      },
    },
  },
});
