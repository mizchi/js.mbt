name = "mizchi/js"

version = "0.13.0"

import {
  "mizchi/js_builtin@0.13.0",
  "mizchi/js_core@0.13.0",
  "moonbitlang/async@0.20.5",
}

readme = "src/README.mbt.md"

repository = "https://github.com/mizchi/js.mbt"

license = "MIT"

keywords = [ "js", "ffi", "meta", "facade" ]

description = "js bindings for MoonBit: re-exports mizchi/js_core + mizchi/js_builtin (web/node/browser/deno/bun split into mizchi/js_* modules)"

source = "src"

preferred_target = "js"
