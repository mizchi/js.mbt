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
pub extern "js" fn Yargs::as_any(self : Yargs) -> @core.Any =
  #| (x) => x

///|
/// Parsed arguments object
#external
pub type Argv

///|
pub extern "js" fn Argv::as_any(self : Argv) -> @core.Any =
  #| (x) => x

///| FFI Functions

///|
#module("yargs")
extern "js" fn ffi_yargs_default() -> (Array[String]) -> Yargs = "default"

///| Module Functions

///|
/// Create a new yargs instance
pub fn yargs() -> Yargs {
  ffi_yargs_default()([])
}

///|
/// Create a yargs instance with specific arguments
pub fn yargs_with_args(args : Array[String]) -> Yargs {
  ffi_yargs_default()(args)
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
  default? : @core.Any,
  demandOption? : Bool,
  choices? : Array[String],
  array? : Bool,
) -> Yargs {
  let opt = @core.new_object()
  if alias_ is Some(v) {
    opt["alias"] = @core.any(v)
  }
  if type_ is Some(v) {
    opt["type"] = @core.any(v)
  }
  if description is Some(v) {
    opt["describe"] = @core.any(v)
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if demandOption is Some(v) {
    opt["demandOption"] = @core.any(v)
  }
  if choices is Some(v) {
    opt["choices"] = @core.any(v)
  }
  if array is Some(v) {
    opt["array"] = @core.any(v)
  }
  self.as_any()._call("option", [@core.any(key), opt]).cast()
}

///|
/// Add a positional argument (use in command builder)
pub fn Yargs::positional(
  self : Yargs,
  key : String,
  type_? : String,
  description? : String,
  default? : @core.Any,
  choices? : Array[String],
) -> Yargs {
  let opt = @core.new_object()
  if type_ is Some(v) {
    opt["type"] = @core.any(v)
  }
  if description is Some(v) {
    opt["describe"] = @core.any(v)
  }
  if default is Some(v) {
    opt["default"] = v
  }
  if choices is Some(v) {
    opt["choices"] = @core.any(v)
  }
  self.as_any()._call("positional", [@core.any(key), opt]).cast()
}

///|
/// Set an alias for an option
pub fn Yargs::alias_(self : Yargs, key : String, alias_name : String) -> Yargs {
  self.as_any()._call("alias", [@core.any(key), @core.any(alias_name)]).cast()
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
  ._call("describe", [@core.any(key), @core.any(description)])
  .cast()
}

///|
/// Set default value for an option
pub fn Yargs::default(self : Yargs, key : String, value : @core.Any) -> Yargs {
  self.as_any()._call("default", [@core.any(key), value]).cast()
}

///|
/// Mark option as boolean type
pub fn Yargs::boolean(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("boolean", [@core.any(key)]).cast()
}

///|
/// Mark option as string type
pub fn Yargs::string(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("string", [@core.any(key)]).cast()
}

///|
/// Mark option as number type
pub fn Yargs::number(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("number", [@core.any(key)]).cast()
}

///|
/// Mark option as array type
pub fn Yargs::array(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("array", [@core.any(key)]).cast()
}

///|
/// Mark option as count type (count occurrences)
pub fn Yargs::count(self : Yargs, key : String) -> Yargs {
  self.as_any()._call("count", [@core.any(key)]).cast()
}

///|
/// Set valid choices for an option
pub fn Yargs::choices(
  self : Yargs,
  key : String,
  values : Array[String],
) -> Yargs {
  self.as_any()._call("choices", [@core.any(key), @core.any(values)]).cast()
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
      ._call("demandOption", [@core.any(key), @core.any(msg)])
      .cast()
    None => self.as_any()._call("demandOption", [@core.any(key)]).cast()
  }
}

///|
/// Require at least n commands (min only)
pub fn Yargs::demandCommand(self : Yargs, min : Int) -> Yargs {
  self.as_any()._call("demandCommand", [@core.any(min)]).cast()
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
        @core.any(min),
        @core.any(max),
        @core.any(minM),
        @core.any(maxM),
      ])
      .cast()
    (Some(minM), None) =>
      self
      .as_any()
      ._call("demandCommand", [@core.any(min), @core.any(max), @core.any(minM)])
      .cast()
    _ =>
      self
      .as_any()
      ._call("demandCommand", [@core.any(min), @core.any(max)])
      .cast()
  }
}

///|
/// Enable strict mode (report unrecognized options as errors)
pub fn Yargs::strict(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strict", [@core.any(v)]).cast()
    None => self.as_any()._call("strict", []).cast()
  }
}

///|
/// Enable strict commands mode
pub fn Yargs::strictCommands(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strictCommands", [@core.any(v)]).cast()
    None => self.as_any()._call("strictCommands", []).cast()
  }
}

///|
/// Enable strict options mode
pub fn Yargs::strictOptions(self : Yargs, enabled? : Bool) -> Yargs {
  match enabled {
    Some(v) => self.as_any()._call("strictOptions", [@core.any(v)]).cast()
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
  ._call("command", [@core.any(cmd), @core.any(description)])
  .cast()
}

///|
/// Define a command with builder and handler
pub fn Yargs::command_with_handler(
  self : Yargs,
  cmd : String,
  description : String,
  builder : @core.Any,
  handler : @core.Any,
) -> Yargs {
  self
  .as_any()
  ._call("command", [@core.any(cmd), @core.any(description), builder, handler])
  .cast()
}

///|
/// Define a command with object configuration
pub fn Yargs::command_module(self : Yargs, mod : @core.Any) -> Yargs {
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
      self.as_any()._call("help", [@core.any(opt), @core.any(desc)]).cast()
    (Some(opt), None) => self.as_any()._call("help", [@core.any(opt)]).cast()
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
      ._call("version", [@core.any(opt), @core.any(desc), @core.any(ver)])
      .cast()
    (Some(opt), None, Some(ver)) =>
      self.as_any()._call("version", [@core.any(opt), @core.any(ver)]).cast()
    (None, None, Some(ver)) =>
      self.as_any()._call("version", [@core.any(ver)]).cast()
    _ => self.as_any()._call("version", []).cast()
  }
}

///|
/// Set usage message
pub fn Yargs::usage(self : Yargs, message : String) -> Yargs {
  self.as_any()._call("usage", [@core.any(message)]).cast()
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
  ._call("example", [@core.any(cmd), @core.any(description)])
  .cast()
}

///|
/// Set epilog message (shown at end of help)
pub fn Yargs::epilog(self : Yargs, message : String) -> Yargs {
  self.as_any()._call("epilog", [@core.any(message)]).cast()
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
  self.as_any()._call("parse", [@core.any(args)]).cast()
}

///|
/// Parse arguments asynchronously
pub async fn Yargs::parseAsync(self : Yargs) -> Argv {
  let promise : @core.Promise[Argv] = self
    .as_any()
    ._call("parseAsync", [])
    .cast()
  promise.wait()
}

///|
/// Parse specific arguments asynchronously
pub async fn Yargs::parseAsync_args(self : Yargs, args : Array[String]) -> Argv {
  let promise : @core.Promise[Argv] = self
    .as_any()
    ._call("parseAsync", [@core.any(args)])
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
  self.as_any()._call("exitProcess", [@core.any(enabled)]).cast()
}

///|
/// Set script name (shown in help)
pub fn Yargs::scriptName(self : Yargs, name : String) -> Yargs {
  self.as_any()._call("scriptName", [@core.any(name)]).cast()
}

///|
/// Wrap output at specified width
pub fn Yargs::wrap(self : Yargs, columns : Int) -> Yargs {
  self.as_any()._call("wrap", [@core.any(columns)]).cast()
}

///|
/// Set locale for error messages
pub fn Yargs::locale(self : Yargs, locale : String) -> Yargs {
  self.as_any()._call("locale", [@core.any(locale)]).cast()
}

///| Argv Methods

///|
/// Get a string value from argv
pub fn Argv::get_string(self : Argv, key : String) -> String? {
  let value = self.as_any()[key]
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an int value from argv
pub fn Argv::get_int(self : Argv, key : String) -> Int? {
  let value = self.as_any()[key]
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get a bool value from argv
pub fn Argv::get_bool(self : Argv, key : String) -> Bool? {
  let value = self.as_any()[key]
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

///|
/// Get an array of strings from argv
pub fn Argv::get_array(self : Argv, key : String) -> Array[String]? {
  let value = self.as_any()[key]
  if @core.is_nullish(value) {
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
  not(@core.is_nullish(self.as_any()[key]))
}
