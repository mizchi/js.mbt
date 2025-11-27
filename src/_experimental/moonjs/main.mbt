///|
/// moonjs - MoonBit JS toolchain CLI
/// Wraps moon CLI with JS-specific extensions

///|
async fn main {
  let args = @process.argv()
  // Skip first two args (node path and script path)
  let cmd_args : Array[String] = []
  for i = 2; i < args.length(); i = i + 1 {
    cmd_args.push(args[i])
  }
  if cmd_args.length() == 0 {
    print_usage()
    @process.exit(0)
  }
  let command = cmd_args[0]
  let rest_args : Array[String] = []
  for i = 1; i < cmd_args.length(); i = i + 1 {
    rest_args.push(cmd_args[i])
  }
  match command {
    "new" => cmd_new(rest_args)
    "run" => cmd_run(rest_args)
    "vite" => cmd_vite(rest_args)
    "help" | "--help" | "-h" => print_usage()
    _ => proxy_to_moon(cmd_args)
  }
}

///|
fn print_usage() -> Unit {
  println(@chalk.bold(@chalk.cyan("moonjs")) + " - MoonBit JS toolchain CLI")
  println("")
  println(
    @chalk.bold("Usage:") + " moonjs " + @chalk.dim("<command>") + " [options]",
  )
  println("")
  println(@chalk.bold("Commands:"))
  println(
    "  " +
    @chalk.green("new") +
    " <name> [--user <user>]  Create a new MoonBit JS project",
  )
  println(
    @chalk.dim(
      "      --user <name>       Username for package namespace (default: username)",
    ),
  )
  println(@chalk.dim("      --bin               Binary project (default)"))
  println(@chalk.dim("      --template react    React SPA with Vite"))
  println(
    @chalk.dim("      --lib=node          Node.js library with package.json"),
  )
  println(@chalk.dim("      --lib=mbt           MoonBit-only library"))
  println("")
  println("  " + @chalk.green("run") + " <pkg> [opts]    Run a package")
  println(@chalk.dim("      --runner <rt>    Use bun|deno|node"))
  println("")
  println("  " + @chalk.green("vite") + " [opts]         Vite integration")
  println(@chalk.dim("      (default)        moon build && npx vite build"))
  println(@chalk.dim("      --tui            TUI mode with Build/Vite/Test"))
  println(@chalk.dim("      Press: t=test, j/k=select, g/G=scroll, q=quit"))
  println("")
  println("  " + @chalk.green("help") + "                Show this help")
  println("")
  println(@chalk.bold("Proxied commands:") + @chalk.dim(" (auto --target js)"))
  println(
    "  " +
    @chalk.cyan("build") +
    ", " +
    @chalk.cyan("test") +
    ", " +
    @chalk.cyan("check") +
    ", " +
    @chalk.cyan("fmt") +
    ", " +
    @chalk.cyan("info") +
    ", " +
    @chalk.cyan("clean") +
    ", ...",
  )
}

///|
fn cmd_new(args : Array[String]) -> Unit {
  if args.length() == 0 {
    println(@chalk.red("Error:") + " missing project name")
    println(
      @chalk.dim("Usage:") +
      " moonjs new <name> [--user <username>] [--bin|--template react|--lib=node|--lib=mbt]",
    )
    @process.exit(1)
  }
  // Parse project type from args
  let project_type = parse_project_type(args)
  // Parse --user option
  let username = parse_user_option(args)
  // Find the project name (first non-option argument)
  let name = find_project_name(args)
  match (name, username) {
    (Some(n), Some(user)) => create_project(n, user, project_type)
    (Some(n), None) => {
      println(
        @chalk.yellow("Warning:") +
        " using default username 'username'. Consider using " +
        @chalk.cyan("--user <your-username>"),
      )
      println(@chalk.dim("  You can change this later in moon.mod.json"))
      println("")
      create_project(n, "username", project_type)
    }
    (None, _) => {
      println(@chalk.red("Error:") + " missing project name")
      println(
        @chalk.dim("Usage:") +
        " moonjs new <name> [--user <username>] [--bin|--template react|--lib=node|--lib=mbt]",
      )
      @process.exit(1)
    }
  }
}

///|
fn parse_user_option(args : Array[String]) -> String? {
  for i = 0; i < args.length(); i = i + 1 {
    let arg = args[i]
    if arg == "--user" && i + 1 < args.length() {
      return Some(args[i + 1])
    }
    if arg.has_prefix("--user=") {
      return Some(ffi_substring(arg, 7))
    }
  }
  None
}

///|
fn parse_project_type(args : Array[String]) -> ProjectType {
  for i = 0; i < args.length(); i = i + 1 {
    let arg = args[i]
    if arg == "--bin" {
      return Bin
    }
    if arg == "--template=react" {
      return React
    }
    if arg == "--template" && i + 1 < args.length() && args[i + 1] == "react" {
      return React
    }
    if arg == "--lib=node" {
      return LibNode
    }
    if arg == "--lib=mbt" {
      return LibMbt
    }
    if arg == "--lib" && i + 1 < args.length() {
      return match args[i + 1] {
        "node" => LibNode
        "mbt" => LibMbt
        _ => Bin
      }
    }
  }
  Bin // Default to binary
}

///|
fn find_project_name(args : Array[String]) -> String? {
  let mut skip_next = false
  for i = 0; i < args.length(); i = i + 1 {
    if skip_next {
      skip_next = false
      continue
    }
    let arg = args[i]
    if arg == "--lib" || arg == "--user" || arg == "--template" {
      skip_next = true
      continue
    }
    if arg.has_prefix("--") {
      continue
    }
    return Some(arg)
  }
  None
}

///|
fn create_project(
  name : String,
  username : String,
  project_type : ProjectType,
) -> Unit {
  // Check if directory exists
  if @fs.existsSync(name) {
    println(
      @chalk.red("Error:") +
      " directory '" +
      @chalk.yellow(name) +
      "' already exists",
    )
    @process.exit(1)
  }
  // Get base name for module name (strip path)
  let base_name = @path.basename(name)
  // Warn if name contains hyphens
  if base_name.contains("-") {
    let suggested = ffi_replace_all(base_name, "-", "_")
    println(
      @chalk.yellow("Warning:") +
      " project name contains hyphens. Consider using snake_case: " +
      @chalk.cyan(suggested),
    )
    println(
      @chalk.dim("  Hyphens work but snake_case is easier to access in MoonBit"),
    )
    println("")
  }
  // Module name includes username namespace
  let module_name = username + "/" + base_name
  // Create directory structure based on project type
  try {
    @fs.mkdirSync(name, recursive=true)
    @fs.mkdirSync(@path.join2(name, "src"), recursive=true)
    match project_type {
      Bin => @fs.mkdirSync(@path.join([name, "src", "main"]), recursive=true)
      LibNode | LibMbt | React => ()
    }
  } catch {
    e => {
      println(@chalk.red("Error creating directories:") + " \{e}")
      @process.exit(1)
    }
  }
  // Write files using templates
  try {
    @fs.writeFileSync(
      @path.join2(name, "moon.mod.json"),
      template_moon_mod_json(module_name),
    )
    // Write src/moon.pkg.json based on project type
    @fs.writeFileSync(
      @path.join([name, "src", "moon.pkg.json"]),
      template_src_pkg_json_for(project_type),
    )
    // Write source file based on project type
    match project_type {
      Bin => {
        @fs.writeFileSync(
          @path.join([name, "src", "main", "moon.pkg.json"]),
          template_main_pkg_json(),
        )
        @fs.writeFileSync(
          @path.join([name, "src", "lib.mbt"]),
          template_lib_mbt(),
        )
        @fs.writeFileSync(
          @path.join([name, "src", "main", "main.mbt"]),
          template_main_mbt(),
        )
      }
      LibNode | LibMbt =>
        @fs.writeFileSync(
          @path.join([name, "src", "lib.mbt"]),
          template_lib_mbt(),
        )
      React => {
        @fs.writeFileSync(
          @path.join([name, "src", "main.mbt"]),
          template_react_main_mbt(),
        )
        @fs.writeFileSync(
          @path.join2(name, "index.html"),
          template_react_index_html(base_name),
        )
        @fs.writeFileSync(
          @path.join2(name, "package.json"),
          template_react_package_json(base_name),
        )
      }
    }
    @fs.writeFileSync(@path.join2(name, ".gitignore"), template_gitignore())
    @fs.writeFileSync(
      @path.join2(name, "README.md"),
      template_readme_for(base_name, project_type),
    )
    // Write package.json for LibNode (React already written above)
    match project_type {
      LibNode =>
        @fs.writeFileSync(
          @path.join2(name, "package.json"),
          template_package_json(base_name),
        )
      Bin | LibMbt | React => ()
    }
  } catch {
    e => {
      println(@chalk.red("Error writing files:") + " \{e}")
      @process.exit(1)
    }
  }
  println(
    @chalk.green("✓") +
    " Created project '" +
    @chalk.bold(@chalk.cyan(name)) +
    "' " +
    @chalk.dim("(\{project_type_name(project_type)})"),
  )
  println("")
  println(@chalk.bold("To get started:"))
  println("  " + @chalk.cyan("cd \{name}"))
  println("  " + @chalk.cyan("moon update"))
  match project_type {
    Bin => println("  " + @chalk.cyan("moonjs run src/main"))
    LibNode => {
      println("  " + @chalk.cyan("moonjs build"))
      println(@chalk.dim("  # Then use as npm package"))
    }
    LibMbt => {
      println("  " + @chalk.cyan("moonjs build"))
      println(@chalk.dim("  # Then import from other MoonBit projects"))
    }
    React => {
      println("  " + @chalk.cyan("npm install"))
      println("  " + @chalk.cyan("npm run dev"))
    }
  }
}

///|
fn project_type_name(pt : ProjectType) -> String {
  match pt {
    Bin => "binary"
    LibNode => "node library"
    LibMbt => "moonbit library"
    React => "react app"
  }
}

///|
fn cmd_run(args : Array[String]) -> Unit {
  if args.length() == 0 {
    println(@chalk.red("Error:") + " missing package path")
    println(
      @chalk.dim("Usage:") +
      " moonjs run <pkg> [--runner bun|deno|node] [options]",
    )
    @process.exit(1)
  }
  let pkg = args[0]
  let rest : Array[String] = []
  for i = 1; i < args.length(); i = i + 1 {
    rest.push(args[i])
  }
  // Parse --runner option
  let runner : @moon_api.Runner? = parse_runner_option(rest)
  let filtered_args = filter_runner_option(rest)
  // Build moon run arguments
  let result = @moon_api.run(
    pkg,
    target=@moon_api.JS,
    runner?,
    args=filtered_args,
  )
  @process.exit(result.exit_code)
}

///|
fn parse_runner_option(args : Array[String]) -> @moon_api.Runner? {
  for i = 0; i < args.length(); i = i + 1 {
    let arg = args[i]
    if arg == "--runner" && i + 1 < args.length() {
      return match args[i + 1] {
        "bun" => Some(@moon_api.Bun)
        "deno" => Some(@moon_api.Deno)
        "node" => Some(@moon_api.Node)
        _ => None
      }
    }
    if arg.has_prefix("--runner=") {
      let value = ffi_substring(arg, 9)
      return match value {
        "bun" => Some(@moon_api.Bun)
        "deno" => Some(@moon_api.Deno)
        "node" => Some(@moon_api.Node)
        _ => None
      }
    }
  }
  None
}

///|
fn filter_runner_option(args : Array[String]) -> Array[String] {
  let result : Array[String] = []
  let mut skip_next = false
  for i = 0; i < args.length(); i = i + 1 {
    if skip_next {
      skip_next = false
      continue
    }
    let arg = args[i]
    if arg == "--runner" {
      skip_next = true
      continue
    }
    if arg.has_prefix("--runner=") {
      continue
    }
    result.push(arg)
  }
  result
}

///|
extern "js" fn ffi_substring(s : String, start : Int) -> String =
  #|(s, start) => s.slice(start)

///|
fn proxy_to_moon(args : Array[String]) -> Unit {
  if args.length() == 0 {
    @process.exit(0)
  }
  let command = args[0]
  let rest : Array[String] = []
  for i = 1; i < args.length(); i = i + 1 {
    rest.push(args[i])
  }
  // For build/test/check, add --target js if not specified
  let needs_js_target = match command {
    "build" | "test" | "check" => not(has_target_option(rest))
    _ => false
  }
  let result = match command {
    "build" =>
      if needs_js_target {
        @moon_api.build(target=@moon_api.JS)
      } else {
        @moon_api.build()
      }
    "test" =>
      if needs_js_target {
        @moon_api.run_test(target=@moon_api.JS)
      } else {
        @moon_api.run_test()
      }
    "check" =>
      if needs_js_target {
        @moon_api.check(target=@moon_api.JS)
      } else {
        @moon_api.check()
      }
    "fmt" => @moon_api.fmt()
    "info" => @moon_api.info()
    "clean" => @moon_api.clean()
    "upgrade" => @moon_api.upgrade()
    "version" => {
      let r = @moon_api.version()
      if r.success {
        println(r.stdout)
      }
      r
    }
    _ =>
      // Fallback: execute moon command directly
      exec_moon_raw(args)
  }
  @process.exit(result.exit_code)
}

///|
fn has_target_option(args : Array[String]) -> Bool {
  for i = 0; i < args.length(); i = i + 1 {
    let arg = args[i]
    if arg.has_prefix("--target") || arg == "-t" {
      return true
    }
  }
  false
}

///|
fn exec_moon_raw(args : Array[String]) -> @moon_api.CommandResult {
  ffi_exec_moon(args)
}

///|
extern "js" fn ffi_exec_moon(args : Array[String]) -> @moon_api.CommandResult =
  #|(args) => {
  #|  const { spawnSync } = require('node:child_process');
  #|  const result = spawnSync('moon', args, {
  #|    stdio: 'inherit'
  #|  });
  #|  return {
  #|    exit_code: result.status || 0,
  #|    stdout: '',
  #|    stderr: '',
  #|    success: result.status === 0
  #|  };
  #|}
