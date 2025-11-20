/*
# Cloudflare Worker Example

See `src/examples/cfw/*`

```
moon build
npx -y wrangler dev fixtures/cf-worker.js
```
*/
let handler = null;
export default {
  async fetch(request, env, ctx) {
    if (handler === null) {
      const mod = await import(
        "../target/js/release/build/examples/cfw/cfw.js"
      );
      handler = mod.get_fetch_handler();
    }
    return handler(request, env, ctx);
  },
};
