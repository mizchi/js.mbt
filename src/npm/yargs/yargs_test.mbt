///|
/// Yargs bindings tests

///|
test "yargs basic parsing" {
  let y = @yargs.yargs_with_args(["--name", "Alice", "--count", "3"])
  let argv = y
    .option("name", alias_="n", type_="string", description="Your name")
    .option("count", alias_="c", type_="number", description="Count")
    .parse()
  inspect(argv.get_string("name"), content="Some(\"Alice\")")
  inspect(argv.get_int("count"), content="Some(3)")
}

///|
test "yargs boolean option" {
  let y = @yargs.yargs_with_args(["--verbose"])
  let argv = y.boolean("verbose").parse()
  inspect(argv.get_bool("verbose"), content="Some(true)")
}

///|
test "yargs positional arguments" {
  let y = @yargs.yargs_with_args(["hello", "world", "--flag"])
  let argv = y.boolean("flag").parse()
  let positionals = argv.positionals()
  inspect(positionals.length(), content="2")
  inspect(positionals[0], content="hello")
  inspect(positionals[1], content="world")
  inspect(argv.get_bool("flag"), content="Some(true)")
}

///|
test "yargs default value" {
  let y = @yargs.yargs_with_args([])
  let argv = y.option("port", type_="number", default=@nostd.any(8080)).parse()
  inspect(argv.get_int("port"), content="Some(8080)")
}

///|
test "yargs alias" {
  let y = @yargs.yargs_with_args(["-v"])
  let argv = y.boolean("verbose").alias_("verbose", "v").parse()
  inspect(argv.get_bool("verbose"), content="Some(true)")
  inspect(argv.get_bool("v"), content="Some(true)")
}

///|
test "yargs has" {
  let y = @yargs.yargs_with_args(["--present"])
  let argv = y.boolean("present").boolean("absent").parse()
  inspect(argv.has("present"), content="true")
  inspect(argv.has("absent"), content="false")
}

///|
test "yargs array option" {
  let y = @yargs.yargs_with_args(["--files", "a.txt", "b.txt", "c.txt"])
  let argv = y.array("files").parse()
  let files = argv.get_array("files")
  inspect(files is None, content="false")
}

///|
test "yargs count option" {
  let y = @yargs.yargs_with_args(["-v", "-v", "-v"])
  let argv = y.count("v").parse()
  inspect(argv.get_int("v"), content="Some(3)")
}

///|
test "yargs chaining" {
  let argv = @yargs.yargs_with_args(["--name", "test", "--debug"])
    .string("name")
    .boolean("debug")
    .default("port", @nostd.any(3000))
    .parse()
  inspect(argv.get_string("name"), content="Some(\"test\")")
  inspect(argv.get_bool("debug"), content="Some(true)")
  inspect(argv.get_int("port"), content="Some(3000)")
}
