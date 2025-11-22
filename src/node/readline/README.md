# @mizchi/js/node/readline

Node.js Readline module bindings for MoonBit.

## Overview

This package provides bindings to Node.js's `readline` module for reading input from a Readable stream (such as `process.stdin`) one line at a time.

## Usage

### Creating a Readline Interface

```moonbit
let options = InterfaceOptions::new(
  @node/process.stdin,
  output=Some(@node/process.stdout)
)
let rl = @node/readline.create_interface(options)
```

### Handling Line Input

```moonbit
rl.on_line(fn(line) {
  println("You entered: " + line)
})
```

### Setting and Displaying Prompt

```moonbit
rl.set_prompt("Enter your name: ")
rl.prompt()
```

### Closing the Interface

```moonbit
rl.on_close(fn() {
  println("Goodbye!")
})
rl.close()
```

## API Reference

### Types

- `Interface` - The readline interface type
- `InterfaceOptions` - Configuration options for creating an interface

### Functions

#### Interface Creation

- `create_interface(options: InterfaceOptions) -> Interface` - Create a new readline interface

#### Interface Methods

- `Interface::set_prompt(prompt: String)` - Set the prompt string
- `Interface::prompt(~preserve_cursor: Bool = false)` - Display the prompt
- `Interface::write(data: String, ~key: Object? = None)` - Write to output
- `Interface::pause()` - Pause the input stream
- `Interface::resume()` - Resume the input stream
- `Interface::close()` - Close the interface

#### Event Handlers

- `Interface::on_line(callback: (String) -> Unit)` - Handle line input
- `Interface::on_close(callback: () -> Unit)` - Handle interface close
- `Interface::on_pause(callback: () -> Unit)` - Handle pause event
- `Interface::on_resume(callback: () -> Unit)` - Handle resume event
- `Interface::on_sigint(callback: () -> Unit)` - Handle SIGINT (Ctrl+C)
- `Interface::on_sigtstp(callback: () -> Unit)` - Handle SIGTSTP (Ctrl+Z)
- `Interface::on_sigcont(callback: () -> Unit)` - Handle SIGCONT

#### Utility Functions

- `clear_line(stream: Writable, dir: Int) -> Bool` - Clear the current line
- `clear_screen_down(stream: Writable) -> Bool` - Clear screen from cursor down
- `cursor_to(stream: Writable, x: Int, ~y: Int? = None) -> Bool` - Move cursor to position
- `move_cursor(stream: Writable, dx: Int, dy: Int) -> Bool` - Move cursor relative
- `emit_keypress_events(stream: Readable, ~interface_: Interface? = None)` - Emit keypress events

## References

- [Node.js Readline Documentation](https://nodejs.org/api/readline.html)
