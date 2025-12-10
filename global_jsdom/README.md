# mizchi/npm_typed/global_jsdom

Global JSDOM setup for Node.js test environments.

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install jsdom global-jsdom
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/npm_typed/global_jsdom"
  ]
}
```

## Usage

Call `register()` to set up the global DOM environment for testing:

```moonbit
fn init_jsdom() {
  @global_jsdom.register()
}
```
