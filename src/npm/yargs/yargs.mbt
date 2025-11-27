///|
/// Yargs bindings for MoonBit
/// https://yargs.js.org/
///
/// Yargs is a command-line argument parser for Node.js.

///| Yargs Type

///|
/// Yargs instance for building command-line interfaces
#external
pub type Yargs

///|
pub impl @js.JsImpl for Yargs

///|
/// Parsed arguments object
#external
pub type Argv

///|
pub impl @js.JsImpl for Argv

///| FFI Functions

///|
extern "js" fn ffi_yargs() -> Yargs =
  #| () => {
  #|   const yargs = require('yargs');
  #|   return yargs();
  #| }

///|
extern "js" fn ffi_yargs_with_args(args : @js.Any) -> Yargs =
  #| (args) => {
  #|   const yargs = require('yargs');
  #|   return yargs(args);
  #| }

///| Module Functions

///|
/// Create a new yargs instance
pub fn yargs() -> Yargs {
  ffi_yargs()
}

///|
/// Create a yargs instance with specific arguments
pub fn yargs_with_args(args : Array[String]) -> Yargs {
  ffi_yargs_with_args(@js.from_array(args))
}

///| Yargs Methods - Option Configuration

///|
/// Add an option with configuration
pub fn Yargs::option(
  self : Yargs,
  key : String,
  alias_? : String,
  type_? : String,
  description? : String,
  default? : @js.Any,
  demandOption? : Bool,
  choices? : Array[String],
  array? : Bool,
) -> Yargs {
  let opt = @js.Object::new()
  if alias_ is Some(v) {
    opt["alias"] = v
  }
  if type_ is Some(v) {
    opt["type"] = v
  }
  if description is Some(v) {
    opt["describe"] = v
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if demandOption is Some(v) {
    opt["demandOption"] = v
  }
  if choices is Some(v) {
    opt["choices"] = @js.from_array(v)
  }
  if array is Some(v) {
    opt["array"] = v
  }
  @js.identity(self.call("option", [@js.any(key), opt.to_any()]))
}

///|
/// Add a positional argument (use in command builder)
pub fn Yargs::positional(
  self : Yargs,
  key : String,
  type_? : String,
  description? : String,
  default? : @js.Any,
  choices? : Array[String],
) -> Yargs {
  let opt = @js.Object::new()
  if type_ is Some(v) {
    opt["type"] = v
  }
  if description is Some(v) {
    opt["describe"] = v
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if choices is Some(v) {
    opt["choices"] = @js.from_array(v)
  }
  @js.identity(self.call("positional", [@js.any(key), opt.to_any()]))
}

///|
/// Set an alias for an option
pub fn Yargs::alias_(self : Yargs, key : String, alias_name : String) -> Yargs {
  @js.identity(self.call("alias", [@js.any(key), @js.any(alias_name)]))
}

///|
/// Set description for an option
pub fn Yargs::describe(
  self : Yargs,
  key : String,
  description : String,
) -> Yargs {
  @js.identity(self.call("describe", [@js.any(key), @js.any(description)]))
}

///|
/// Set default value for an option
pub fn Yargs::default(self : Yargs, key : String, value : @js.Any) -> Yargs {
  @js.identity(self.call("default", [@js.any(key), value]))
}

///|
/// Mark option as boolean type
pub fn Yargs::boolean(self : Yargs, key : String) -> Yargs {
  @js.identity(self.call("boolean", [@js.any(key)]))
}

///|
/// Mark option as string type
pub fn Yargs::string(self : Yargs, key : String) -> Yargs {
  @js.identity(self.call("string", [@js.any(key)]))
}

///|
/// Mark option as number type
pub fn Yargs::number(self : Yargs, key : String) -> Yargs {
  @js.identity(self.call("number", [@js.any(key)]))
}

///|
/// Mark option as array type
pub fn Yargs::array(self : Yargs, key : String) -> Yargs {
  @js.identity(self.call("array", [@js.any(key)]))
}

///|
/// Mark option as count type (count occurrences)
pub fn Yargs::count(self : Yargs, key : String) -> Yargs {
  @js.identity(self.call("count", [@js.any(key)]))
}

///|
/// Set valid choices for an option
pub fn Yargs::choices(
  self : Yargs,
  key : String,
  values : Array[String],
) -> Yargs {
  @js.identity(self.call("choices", [@js.any(key), @js.from_array(values)]))
}

///| Yargs Methods - Validation

///|
/// Mark option as required
pub fn Yargs::demandOption(
  self : Yargs,
  key : String,
  message? : String,
) -> Yargs {
  match message {
    Some(msg) =>
      @js.identity(self.call("demandOption", [@js.any(key), @js.any(msg)]))
    None => @js.identity(self.call("demandOption", [@js.any(key)]))
  }
}

///|
/// Require at least n commands (min only)
pub fn Yargs::demandCommand(self : Yargs, min : Int) -> Yargs {
  @js.identity(self.call("demandCommand", [@js.any(min)]))
}

///|
/// Require commands with min/max and messages
pub fn Yargs::demandCommand_full(
  self : Yargs,
  min : Int,
  max : Int,
  minMsg? : String,
  maxMsg? : String,
) -> Yargs {
  match (minMsg, maxMsg) {
    (Some(minM), Some(maxM)) =>
      @js.identity(
        self.call("demandCommand", [
          @js.any(min),
          @js.any(max),
          @js.any(minM),
          @js.any(maxM),
        ]),
      )
    (Some(minM), None) =>
      @js.identity(
        self.call("demandCommand", [@js.any(min), @js.any(max), @js.any(minM)]),
      )
    _ => @js.identity(self.call("demandCommand", [@js.any(min), @js.any(max)]))
  }
}

///|
/// Enable strict mode (report unrecognized options as errors)
pub fn Yargs::strict(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => @js.identity(self.call("strict", [@js.any(v)]))
    None => @js.identity(self.call("strict", []))
  }
}

///|
/// Enable strict commands mode
pub fn Yargs::strictCommands(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => @js.identity(self.call("strictCommands", [@js.any(v)]))
    None => @js.identity(self.call("strictCommands", []))
  }
}

///|
/// Enable strict options mode
pub fn Yargs::strictOptions(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => @js.identity(self.call("strictOptions", [@js.any(v)]))
    None => @js.identity(self.call("strictOptions", []))
  }
}

///| Yargs Methods - Commands

///|
/// Define a command (basic, no builder/handler)
pub fn Yargs::command(
  self : Yargs,
  cmd : String,
  description : String,
) -> Yargs {
  @js.identity(self.call("command", [@js.any(cmd), @js.any(description)]))
}

///|
/// Define a command with builder and handler
pub fn Yargs::command_with_handler(
  self : Yargs,
  cmd : String,
  description : String,
  builder : @js.Any,
  handler : @js.Any,
) -> Yargs {
  @js.identity(
    self.call("command", [@js.any(cmd), @js.any(description), builder, handler]),
  )
}

///|
/// Define a command with object configuration
pub fn Yargs::command_module(self : Yargs, mod : @js.Any) -> Yargs {
  @js.identity(self.call("command", [mod]))
}

///| Yargs Methods - Help & Version

///|
/// Enable help option
pub fn Yargs::help(
  self : Yargs,
  option? : String,
  description? : String,
) -> Yargs {
  match (option, description) {
    (Some(opt), Some(desc)) =>
      @js.identity(self.call("help", [@js.any(opt), @js.any(desc)]))
    (Some(opt), None) => @js.identity(self.call("help", [@js.any(opt)]))
    (None, _) => @js.identity(self.call("help", []))
  }
}

///|
/// Enable version option
pub fn Yargs::version(
  self : Yargs,
  version? : String,
  option? : String,
  description? : String,
) -> Yargs {
  match (option, description, version) {
    (Some(opt), Some(desc), Some(ver)) =>
      @js.identity(
        self.call("version", [@js.any(opt), @js.any(desc), @js.any(ver)]),
      )
    (Some(opt), None, Some(ver)) =>
      @js.identity(self.call("version", [@js.any(opt), @js.any(ver)]))
    (None, None, Some(ver)) =>
      @js.identity(self.call("version", [@js.any(ver)]))
    _ => @js.identity(self.call("version", []))
  }
}

///|
/// Set usage message
pub fn Yargs::usage(self : Yargs, message : String) -> Yargs {
  @js.identity(self.call("usage", [@js.any(message)]))
}

///|
/// Add an example
pub fn Yargs::example(
  self : Yargs,
  cmd : String,
  description : String,
) -> Yargs {
  @js.identity(self.call("example", [@js.any(cmd), @js.any(description)]))
}

///|
/// Set epilog message (shown at end of help)
pub fn Yargs::epilog(self : Yargs, message : String) -> Yargs {
  @js.identity(self.call("epilog", [@js.any(message)]))
}

///|
/// Show help message
pub fn Yargs::showHelp(self : Yargs) -> Unit {
  let _ = self.call("showHelp", [])

}

///|
/// Show version
pub fn Yargs::showVersion(self : Yargs) -> Unit {
  let _ = self.call("showVersion", [])

}

///| Yargs Methods - Parsing

///|
/// Parse arguments and return argv object
pub fn Yargs::parse(self : Yargs) -> Argv {
  @js.identity(self.call("parse", []))
}

///|
/// Parse specific arguments
pub fn Yargs::parse_args(self : Yargs, args : Array[String]) -> Argv {
  @js.identity(self.call("parse", [@js.from_array(args)]))
}

///|
/// Parse arguments asynchronously
pub async fn Yargs::parseAsync(self : Yargs) -> Argv {
  let promise : @js.Promise[Argv] = @js.identity(self.call("parseAsync", []))
  promise.wait()
}

///|
/// Parse specific arguments asynchronously
pub async fn Yargs::parseAsync_args(self : Yargs, args : Array[String]) -> Argv {
  let promise : @js.Promise[Argv] = @js.identity(
    self.call("parseAsync", [@js.from_array(args)]),
  )
  promise.wait()
}

///|
/// Get the argv object (property access)
pub fn Yargs::argv(self : Yargs) -> Argv {
  @js.identity(self.get("argv"))
}

///| Yargs Methods - Behavior

///|
/// Control whether to exit on error
pub fn Yargs::exitProcess(self : Yargs, enabled : Bool) -> Yargs {
  @js.identity(self.call("exitProcess", [@js.any(enabled)]))
}

///|
/// Set script name (shown in help)
pub fn Yargs::scriptName(self : Yargs, name : String) -> Yargs {
  @js.identity(self.call("scriptName", [@js.any(name)]))
}

///|
/// Wrap output at specified width
pub fn Yargs::wrap(self : Yargs, columns : Int) -> Yargs {
  @js.identity(self.call("wrap", [@js.any(columns)]))
}

///|
/// Set locale for error messages
pub fn Yargs::locale(self : Yargs, locale : String) -> Yargs {
  @js.identity(self.call("locale", [@js.any(locale)]))
}

///| Argv Methods

///|
/// Get a string value from argv
pub fn Argv::get_string(self : Argv, key : String) -> String? {
  let value = self.get(key)
  if @js.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an int value from argv
pub fn Argv::get_int(self : Argv, key : String) -> Int? {
  let value = self.get(key)
  if @js.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get a bool value from argv
pub fn Argv::get_bool(self : Argv, key : String) -> Bool? {
  let value = self.get(key)
  if @js.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an array of strings from argv
pub fn Argv::get_array(self : Argv, key : String) -> Array[String]? {
  let value = self.get(key)
  if @js.is_nullish(value) {
    None
  } else {
    Some(@js.identity(value))
  }
}

///|
/// Get positional arguments (argv._)
pub fn Argv::positionals(self : Argv) -> Array[String] {
  @js.identity(self.get("_"))
}

///|
/// Get script name (argv.$0)
pub fn Argv::script_name(self : Argv) -> String {
  self.get("$0").cast()
}

///|
/// Check if a flag was provided
pub fn Argv::has(self : Argv, key : String) -> Bool {
  not(@js.is_nullish(self.get(key)))
}
