///|
/// Project templates for moonjs new command

///|
/// Project type for scaffolding
enum ProjectType {
  Bin // Executable binary (default)
  LibNode // Library for Node.js with package.json exports
  LibMbt // Library for MoonBit consumption only
  React // React SPA with Vite
}

///|
fn template_moon_mod_json(name : String) -> String {
  let tmpl =
    #|{
    #|  "name": "$NAME",
    #|  "version": "0.1.0",
    #|  "source": "src",
    #|  "preferred-target": "js",
    #|  "deps": {
    #|    "mizchi/js": "0.5.4",
    #|    "moonbitlang/async": "0.14.1"
    #|  },
    #|  "readme": "README.md",
    #|  "repository": "",
    #|  "license": "MIT",
    #|  "keywords": [],
    #|  "description": ""
    #|}
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_src_pkg_json() -> String {
  let tmpl =
    #|{
    #|  "import": [
    #|    "mizchi/js",
    #|    "moonbitlang/async"
    #|  ]
    #|}
  tmpl
}

///|
fn template_main_pkg_json() -> String {
  let tmpl =
    #|{
    #|  "is_main": true,
    #|  "import": [
    #|    "mizchi/js",
    #|    "moonbitlang/async"
    #|  ]
    #|}
  tmpl
}

///|
fn template_lib_mbt() -> String {
  let tmpl =
    #|///|
    #|pub fn hello() -> String {
    #|  "Hello from MoonBit JS!"
    #|}
  tmpl
}

///|
fn template_main_mbt() -> String {
  let tmpl =
    #|///|
    #|fn main {
    #|  println("Hello, MoonBit JS!")
    #|}
  tmpl
}

///|
fn template_gitignore() -> String {
  let tmpl =
    #|target/
    #|.mooncakes/
  tmpl
}

///|
fn template_readme(name : String) -> String {
  let tmpl =
    #|# $NAME
    #|
    #|A MoonBit JS project.
    #|
    #|## Getting Started
    #|
    #|```bash
    #|# Install dependencies
    #|moon update
    #|
    #|# Run the project
    #|moonjs run src/main
    #|
    #|# Build
    #|moonjs build
    #|
    #|# Test
    #|moonjs test
    #|```
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_src_pkg_json_for(project_type : ProjectType) -> String {
  match project_type {
    Bin => template_src_pkg_json()
    LibNode => template_lib_node_pkg_json()
    LibMbt => template_lib_mbt_pkg_json()
    React => template_react_pkg_json()
  }
}

///|
fn template_lib_node_pkg_json() -> String {
  let tmpl =
    #|{
    #|  "import": [
    #|    "mizchi/js",
    #|    "moonbitlang/async"
    #|  ],
    #|  "link": {
    #|    "js": {
    #|      "exports": [
    #|        "hello"
    #|      ],
    #|      "format": "esm"
    #|    }
    #|  }
    #|}
  tmpl
}

///|
fn template_lib_mbt_pkg_json() -> String {
  let tmpl =
    #|{
    #|  "import": [
    #|    "mizchi/js",
    #|    "moonbitlang/async"
    #|  ]
    #|}
  tmpl
}

///|
fn template_package_json(name : String) -> String {
  let tmpl =
    #|{
    #|  "name": "$NAME",
    #|  "version": "0.1.0",
    #|  "type": "module",
    #|  "exports": {
    #|    ".": {
    #|      "types": "./target/js/release/build/$NAME.d.ts",
    #|      "default": "./target/js/release/build/$NAME.js"
    #|    }
    #|  },
    #|  "files": [
    #|    "target/js/release/build"
    #|  ]
    #|}
  ffi_replace_all(tmpl, "$NAME", name)
}

///|
extern "js" fn ffi_replace_all(
  s : String,
  old : String,
  new_ : String,
) -> String =
  #|(s, old, new_) => s.replaceAll(old, new_)

///|
fn template_readme_for(name : String, project_type : ProjectType) -> String {
  match project_type {
    Bin => template_readme(name)
    LibNode => template_readme_lib_node(name)
    LibMbt => template_readme_lib_mbt(name)
    React => template_readme_react(name)
  }
}

///|
fn template_readme_lib_node(name : String) -> String {
  let tmpl =
    #|# $NAME
    #|
    #|A MoonBit JS library for Node.js.
    #|
    #|## Getting Started
    #|
    #|```bash
    #|# Install dependencies
    #|moon update
    #|
    #|# Build
    #|moonjs build
    #|
    #|# Test
    #|moonjs test
    #|```
    #|
    #|## Usage
    #|
    #|```javascript
    #|import { hello } from '$NAME';
    #|
    #|console.log(hello());
    #|```
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_readme_lib_mbt(name : String) -> String {
  let tmpl =
    #|# $NAME
    #|
    #|A MoonBit library.
    #|
    #|## Getting Started
    #|
    #|```bash
    #|# Install dependencies
    #|moon update
    #|
    #|# Build
    #|moonjs build
    #|
    #|# Test
    #|moonjs test
    #|```
    #|
    #|## Usage
    #|
    #|Add to your `moon.mod.json`:
    #|
    #|```json
    #|{
    #|  "deps": {
    #|    "$NAME": "0.1.0"
    #|  }
    #|}
    #|```
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_react_pkg_json() -> String {
  let tmpl =
    #|{
    #|  "is_main": true,
    #|  "supported-targets": ["js"],
    #|  "import": [
    #|    "mizchi/js",
    #|    "mizchi/js/browser/dom",
    #|    "mizchi/js/npm/react",
    #|    "mizchi/js/npm/react_element",
    #|    "mizchi/js/npm/react_dom_client",
    #|    "moonbitlang/async"
    #|  ]
    #|}
  tmpl
}

///|
fn template_react_main_mbt() -> String {
  let tmpl =
    #|using @react_element { div, h1, p, button }
    #|
    #|///|
    #|fn app(_ : Unit) -> @react.Element {
    #|  let (count, set_count) = @react.useState(0)
    #|  div([
    #|    h1(["Hello, MoonBit React!"]),
    #|    p(["Count: \{count}"]),
    #|    button(on_click=fn(_) { set_count(count + 1) }, ["Click me"]),
    #|  ])
    #|}
    #|
    #|///|
    #|async fn main {
    #|  @react.dynamic_import()
    #|  let client = @react_dom_client.dynamic_import()
    #|  guard @dom.document().querySelector("#app") is Some(root)
    #|  client.create_root(root).render(@react.component(app, ()))
    #|}
  tmpl
}

///|
fn template_react_index_html(name : String) -> String {
  let tmpl =
    #|<!DOCTYPE html>
    #|<html lang="en">
    #|<head>
    #|  <meta charset="UTF-8">
    #|  <meta name="viewport" content="width=device-width, initial-scale=1.0">
    #|  <title>MoonBit React App</title>
    #|</head>
    #|<body>
    #|  <div id="app"></div>
    #|  <script type="module" src="./target/js/release/build/$NAME.js"></script>
    #|</body>
    #|</html>
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_react_package_json(name : String) -> String {
  let tmpl =
    #|{
    #|  "name": "$NAME",
    #|  "version": "0.1.0",
    #|  "private": true,
    #|  "type": "module",
    #|  "scripts": {
    #|    "dev": "moon build --target js && vite",
    #|    "build": "moon build --target js && vite build",
    #|    "test": "moon test --target js"
    #|  },
    #|  "devDependencies": {
    #|    "@testing-library/react": "^16.0.0",
    #|    "global-jsdom": "^26.0.0",
    #|    "react": "^19.0.0",
    #|    "react-dom": "^19.0.0",
    #|    "vite": "^6.0.0"
    #|  }
    #|}
  tmpl.replace(old="$NAME", new=name)
}

///|
fn template_readme_react(name : String) -> String {
  let tmpl =
    #|# $NAME
    #|
    #|A MoonBit React SPA with Vite.
    #|
    #|## Getting Started
    #|
    #|```bash
    #|# Install MoonBit dependencies
    #|moon update
    #|
    #|# Install npm dependencies
    #|npm install
    #|
    #|# Development server
    #|npm run dev
    #|
    #|# Build for production
    #|npm run build
    #|
    #|# Run tests
    #|npm run test
    #|```
  tmpl.replace(old="$NAME", new=name)
}
