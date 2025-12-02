# Yargs Bindings

MoonBit bindings for [Yargs](https://yargs.js.org/), a command-line argument parser for Node.js.

## Installation

```bash
npm install yargs
```

## Usage

```moonbit
fn main {
  let argv = @yargs.yargs_with_args(@process.argv().slice(2))
    .usage("Usage: $0 <command> [options]")
    .option("name", alias_="n", type_="string", description="Your name", demandOption=true)
    .option("port", alias_="p", type_="number", description="Port number", default=@core.any(3000))
    .option("verbose", alias_="v", type_="boolean", description="Enable verbose mode")
    .help()
    .parse()

  // Access parsed values
  match argv.get_string("name") {
    Some(name) => println("Hello, " + name)
    None => println("No name provided")
  }

  let port = argv.get_int("port").or(3000)
  let verbose = argv.get_bool("verbose").or(false)
}
```

## API

### Creating Yargs Instance

- `yargs()` - Create a new yargs instance
- `yargs_with_args(args)` - Create with specific arguments

### Option Configuration

- `option(key, alias_?, type_?, description?, default?, demandOption?, choices?, array?)` - Add an option
- `positional(key, type_?, description?, default?, choices?)` - Configure positional argument
- `alias_(key, alias_name)` - Set an alias for an option
- `describe(key, description)` - Set description
- `default(key, value)` - Set default value
- `boolean(key)` / `string(key)` / `number(key)` / `array(key)` / `count(key)` - Type shortcuts
- `choices(key, values)` - Set valid choices

### Validation

- `demandOption(key, message?)` - Mark option as required
- `demandCommand(min)` - Require at least n commands
- `demandCommand_full(min, max, minMsg?, maxMsg?)` - Full command requirement
- `strict(enabled?)` - Report unrecognized options as errors
- `strictCommands(enabled?)` / `strictOptions(enabled?)` - Strict mode variants

### Commands

- `command(cmd, description)` - Define a command
- `command_with_handler(cmd, description, builder, handler)` - Command with handler
- `command_module(mod)` - Define command with object configuration

### Help & Version

- `help(option?, description?)` - Enable help option
- `version(version?, option?, description?)` - Enable version option
- `usage(message)` - Set usage message
- `example(cmd, description)` - Add an example
- `epilog(message)` - Set epilog message
- `showHelp()` / `showVersion()` - Display help/version

### Parsing

- `parse()` - Parse arguments and return Argv
- `parse_args(args)` - Parse specific arguments
- `parseAsync()` / `parseAsync_args(args)` - Async parsing
- `argv()` - Get argv property

### Behavior

- `exitProcess(enabled)` - Control exit behavior
- `scriptName(name)` - Set script name
- `wrap(columns)` - Set output width
- `locale(locale)` - Set locale

### Argv Methods

- `get_string(key)` / `get_int(key)` / `get_bool(key)` / `get_array(key)` - Get typed values
- `positionals()` - Get positional arguments (argv._)
- `script_name()` - Get script name (argv.$0)
- `has(key)` - Check if flag was provided

## See Also

- [Yargs Documentation](https://yargs.js.org/docs/)
- [Yargs API Reference](https://github.com/yargs/yargs/blob/main/docs/api.md)
