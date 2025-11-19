# mizchi/js/node/readline_promises

## node:readline/promises

Promise-based readline interface for interactive input

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js/node/readline_promises"
  ]
}
```

### Interface
- [x] Interface type
- [x] createInterface(options) - Create readline interface
  - Options: input, output, completer, terminal, historySize, prompt, crlfDelay, removeHistoryDuplicates
- [x] question(query, options?) - Ask question and return promise
- [x] close() - Close interface

### Usage
Used for creating interactive command-line interfaces with Promise-based API.

```moonbit
let rl = createInterface(input=process.stdin, output=process.stdout)
rl.question("Your name: ").then(fn(answer) {
  // Handle answer
  rl.close()
})
```
