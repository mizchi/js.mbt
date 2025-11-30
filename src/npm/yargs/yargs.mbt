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
pub extern "js" fn Yargs::as_any(self : Yargs) -> @nostd.Any =
  #| (x) => x

///|
/// Parsed arguments object
#external
pub type Argv

///|
pub extern "js" fn Argv::as_any(self : Argv) -> @nostd.Any =
  #| (x) => x

///| FFI Functions

///|
extern "js" fn ffi_yargs() -> Yargs =
  #| () => {
  #|   const yargs = require('yargs');
  #|   return yargs();
  #| }

///|
extern "js" fn ffi_yargs_with_args(args : @nostd.Any) -> Yargs =
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
  ffi_yargs_with_args(@nostd.any(args))
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
  default? : @nostd.Any,
  demandOption? : Bool,
  choices? : Array[String],
  array? : Bool,
) -> Yargs {
  let opt = @nostd.Object::new()
  if alias_ is Some(v) {
    opt["alias"] = @nostd.any(v)
  }
  if type_ is Some(v) {
    opt["type"] = @nostd.any(v)
  }
  if description is Some(v) {
    opt["describe"] = @nostd.any(v)
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if demandOption is Some(v) {
    opt["demandOption"] = @nostd.any(v)
  }
  if choices is Some(v) {
    opt["choices"] = @nostd.any(v)
  }
  if array is Some(v) {
    opt["array"] = @nostd.any(v)
  }
  self.as_any()._call("option", [@nostd.any(key), opt]).cast()
}

///|
/// Add a positional argument (use in command builder)
pub fn Yargs::positional(
  self : Yargs,
  key : String,
  type_? : String,
  description? : String,
  default? : @nostd.Any,
  choices? : Array[String],
) -> Yargs {
  let opt = @nostd.Object::new()
  if type_ is Some(v) {
    opt["type"] = @nostd.any(v)
  }
  if description is Some(v) {
    opt["describe"] = @nostd.any(v)
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if choices is Some(v) {
    opt["choices"] = @nostd.any(v)
  }
  self.as_any()._call("positional", [@nostd.any(key), opt]).cast()
}

///|
/// Set an alias for an option
pub fn Yargs::alias_(self : Yargs, key : String, alias_name : String) -> Yargs {
  self.as_any()._call("alias", [@nostd.any(key), @nostd.any(alias_name)]).cast()
}

///|
/// Set description for an option
pub fn Yargs::describe(
  self : Yargs,
  key : String,
  description : String,
) -> Yargs {
  self
  .as_any()
  ._call("describe", [@nostd.any(key), @nostd.any(description)])
  .cast()
}

///|
/// Set default value for an option
pub fn Yargs::default(self : Yargs, key : String, value : @nostd.Any) -> Yargs {
  self.as_any()._call("default", [@nostd.any(key), value]).cast()
}

///|
/// Mark option as boolean type
pub fn Yargs::boolean(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("boolean", [@nostd.any(key)]).cast()
}

///|
/// Mark option as string type
pub fn Yargs::string(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("string", [@nostd.any(key)]).cast()
}

///|
/// Mark option as number type
pub fn Yargs::number(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("number", [@nostd.any(key)]).cast()
}

///|
/// Mark option as array type
pub fn Yargs::array(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("array", [@nostd.any(key)]).cast()
}

///|
/// Mark option as count type (count occurrences)
pub fn Yargs::count(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("count", [@nostd.any(key)]).cast()
}

///|
/// Set valid choices for an option
pub fn Yargs::choices(
  self : Yargs,
  key : String,
  values : Array[String],
) -> Yargs {
  self.as_any()._call("choices", [@nostd.any(key), @nostd.any(values)]).cast()
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
      self
      .as_any()
      ._call("demandOption", [@nostd.any(key), @nostd.any(msg)])
      .cast()
    None => self.as_any()._call("demandOption", [@nostd.any(key)]).cast()
  }
}

///|
/// Require at least n commands (min only)
pub fn Yargs::demandCommand(self : Yargs, min : Int) -> Yargs {
  self.as_any()._call("demandCommand", [@nostd.any(min)]).cast()
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
      self
      .as_any()
      ._call("demandCommand", [
        @nostd.any(min),
        @nostd.any(max),
        @nostd.any(minM),
        @nostd.any(maxM),
      ])
      .cast()
    (Some(minM), None) =>
      self
      .as_any()
      ._call("demandCommand", [
        @nostd.any(min),
        @nostd.any(max),
        @nostd.any(minM),
      ])
      .cast()
    _ =>
      self
      .as_any()
      ._call("demandCommand", [@nostd.any(min), @nostd.any(max)])
      .cast()
  }
}

///|
/// Enable strict mode (report unrecognized options as errors)
pub fn Yargs::strict(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strict", [@nostd.any(v)]).cast()
    None => self.as_any()._call("strict", []).cast()
  }
}

///|
/// Enable strict commands mode
pub fn Yargs::strictCommands(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strictCommands", [@nostd.any(v)]).cast()
    None => self.as_any()._call("strictCommands", []).cast()
  }
}

///|
/// Enable strict options mode
pub fn Yargs::strictOptions(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strictOptions", [@nostd.any(v)]).cast()
    None => self.as_any()._call("strictOptions", []).cast()
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
  self
  .as_any()
  ._call("command", [@nostd.any(cmd), @nostd.any(description)])
  .cast()
}

///|
/// Define a command with builder and handler
pub fn Yargs::command_with_handler(
  self : Yargs,
  cmd : String,
  description : String,
  builder : @nostd.Any,
  handler : @nostd.Any,
) -> Yargs {
  self
  .as_any()
  ._call("command", [@nostd.any(cmd), @nostd.any(description), builder, handler])
  .cast()
}

///|
/// Define a command with object configuration
pub fn Yargs::command_module(self : Yargs, mod : @nostd.Any) -> Yargs {
  self.as_any()._call("command", [mod]).cast()
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
      self.as_any()._call("help", [@nostd.any(opt), @nostd.any(desc)]).cast()
    (Some(opt), None) => self.as_any()._call("help", [@nostd.any(opt)]).cast()
    (None, _) => self.as_any()._call("help", []).cast()
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
      self
      .as_any()
      ._call("version", [@nostd.any(opt), @nostd.any(desc), @nostd.any(ver)])
      .cast()
    (Some(opt), None, Some(ver)) =>
      self.as_any()._call("version", [@nostd.any(opt), @nostd.any(ver)]).cast()
    (None, None, Some(ver)) =>
      self.as_any()._call("version", [@nostd.any(ver)]).cast()
    _ => self.as_any()._call("version", []).cast()
  }
}

///|
/// Set usage message
pub fn Yargs::usage(self : Yargs, message : String) -> Yargs {
  self.as_any()._call("usage", [@nostd.any(message)]).cast()
}

///|
/// Add an example
pub fn Yargs::example(
  self : Yargs,
  cmd : String,
  description : String,
) -> Yargs {
  self
  .as_any()
  ._call("example", [@nostd.any(cmd), @nostd.any(description)])
  .cast()
}

///|
/// Set epilog message (shown at end of help)
pub fn Yargs::epilog(self : Yargs, message : String) -> Yargs {
  self.as_any()._call("epilog", [@nostd.any(message)]).cast()
}

///|
/// Show help message
pub fn Yargs::showHelp(self : Yargs) -> Unit {
  self.as_any()._call("showHelp", []) |> ignore
}

///|
/// Show version
pub fn Yargs::showVersion(self : Yargs) -> Unit {
  self.as_any()._call("showVersion", []) |> ignore
}

///| Yargs Methods - Parsing

///|
/// Parse arguments and return argv object
pub fn Yargs::parse(self : Yargs) -> Argv {
  self.as_any()._call("parse", []).cast()
}

///|
/// Parse specific arguments
pub fn Yargs::parse_args(self : Yargs, args : Array[String]) -> Argv {
  self.as_any()._call("parse", [@nostd.any(args)]).cast()
}

///|
/// Parse arguments asynchronously
pub async fn Yargs::parseAsync(self : Yargs) -> Argv {
  let promise : @nostd.Promise[Argv] = self
    .as_any()
    ._call("parseAsync", [])
    .cast()
  promise.wait()
}

///|
/// Parse specific arguments asynchronously
pub async fn Yargs::parseAsync_args(self : Yargs, args : Array[String]) -> Argv {
  let promise : @nostd.Promise[Argv] = self
    .as_any()
    ._call("parseAsync", [@nostd.any(args)])
    .cast()
  promise.wait()
}

///|
/// Get the argv object (property access)
pub fn Yargs::argv(self : Yargs) -> Argv {
  self.as_any()["argv"].cast()
}

///| Yargs Methods - Behavior

///|
/// Control whether to exit on error
pub fn Yargs::exitProcess(self : Yargs, enabled : Bool) -> Yargs {
  self.as_any()._call("exitProcess", [@nostd.any(enabled)]).cast()
}

///|
/// Set script name (shown in help)
pub fn Yargs::scriptName(self : Yargs, name : String) -> Yargs {
  self.as_any()._call("scriptName", [@nostd.any(name)]).cast()
}

///|
/// Wrap output at specified width
pub fn Yargs::wrap(self : Yargs, columns : Int) -> Yargs {
  self.as_any()._call("wrap", [@nostd.any(columns)]).cast()
}

///|
/// Set locale for error messages
pub fn Yargs::locale(self : Yargs, locale : String) -> Yargs {
  self.as_any()._call("locale", [@nostd.any(locale)]).cast()
}

///| Argv Methods

///|
/// Get a string value from argv
pub fn Argv::get_string(self : Argv, key : String) -> String? {
  let value = self.as_any()[key]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an int value from argv
pub fn Argv::get_int(self : Argv, key : String) -> Int? {
  let value = self.as_any()[key]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get a bool value from argv
pub fn Argv::get_bool(self : Argv, key : String) -> Bool? {
  let value = self.as_any()[key]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an array of strings from argv
pub fn Argv::get_array(self : Argv, key : String) -> Array[String]? {
  let value = self.as_any()[key]
  if @nostd.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get positional arguments (argv._)
pub fn Argv::positionals(self : Argv) -> Array[String] {
  self.as_any()["_"].cast()
}

///|
/// Get script name (argv.$0)
pub fn Argv::script_name(self : Argv) -> String {
  self.as_any()["$0"].cast()
}

///|
/// Check if a flag was provided
pub fn Argv::has(self : Argv, key : String) -> Bool {
  not(@nostd.is_nullish(self.as_any()[key]))
}
