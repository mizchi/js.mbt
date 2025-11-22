## NPM Library bindings

In near future, we split these bindings into a separate package.

### Dynamic Import Usage

**Important**: Until MoonBit adds native ESM support, packages intended for frontend development with bundlers like Vite should use `dynamic_import_async()` for initialization. This approach:

- Uses dynamic `import()` which doesn't support tree-shaking
- Stores modules in `globalThis` for access
- Should be replaced with static imports when MoonBit adds ESM support

Example:
```moonbit
fn main {
  @js.run_async(fn() try {
    @react.dynamic_import_async()
    @react_dom_client.dynamic_import_async()
    // Modules are now ready to use
  } catch {
    err => @js.log("Error during initialization: \{err}")
  })
}
```

- `mizchi/js/npm/react`
  - npm `react`
  - `mizchi/js/npm/react/element`
    - Typed HTML elements binding for Moonbit + React`
- `mizchi/js/npm/react_dom_client`
  - npm `react-dom/client`
- `mizchi/js/npm/react_dom_server`
  - npm `react-dom/server`
- `mizchi/js/npm/react_router`
  - npm: `react-router`
  - Only `BrowserRouter` related api
- `mizchi/js/npm/react_testing_library`
  - npm: `@testing-library/react`

## TODO: Planned implementations

- `date-fns` - Modern JavaScript date utility library
- `ajv` - JSON schema validator
- `zod` - TypeScript-first schema validation
- `chalk` - Terminal string styling
- `yargs` - Command-line argument parser
