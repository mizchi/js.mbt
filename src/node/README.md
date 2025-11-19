# mizchi/js/node

Node.js global objects and variables.

This package will move to `mizchi/node` in future.

## Supported

- cjs
  - [x] `require`
  - [x] `require.resolve`
  - [ ] `module`
  - [x] `__filename`
  - [x] `__dirname`
- esm
  - [x] `import.meta.url`
  - [x] `import.meta.resolve`
  - [x] `import.meta.resolve`
  - [x] `import.meta.filename`
  - [x] `import.meta.dirname`  

## Not Supported

- `process`
  - Use `mizchi/js/node/process`
- `Buffer`
  - Use `mizchi/js/node/buffer`
