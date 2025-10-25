## How to use

```js
import React from "react";
import * as ReactApi from "react";
import { createRoot } from "react-dom/client";
globalThis.__ReactApi = {
  ...ReactApi,
  render(element: React.ReactElement, container: any) {
    const root = createRoot(container);
    root.render(element);
  },
};

async function main() {
  // your entrypoint
  await import("./target/js/release/build/examples/examples.js");
}

await main();
```

# TODO

- [ ] forwardRef
- [ ] ErrorBoundary
- [ ] useActionState
- [ ] use
- [ ] useReducer
