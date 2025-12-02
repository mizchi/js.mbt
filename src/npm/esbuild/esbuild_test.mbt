///|
test "Format enum to_string" {
  assert_eq(Format::Iife.to_string(), "iife")
  assert_eq(Format::Cjs.to_string(), "cjs")
  assert_eq(Format::Esm.to_string(), "esm")
}

///|
test "Platform enum to_string" {
  assert_eq(Platform::Browser.to_string(), "browser")
  assert_eq(Platform::Node.to_string(), "node")
  assert_eq(Platform::Neutral.to_string(), "neutral")
}

///|
test "Loader enum to_string" {
  assert_eq(Loader::Js.to_string(), "js")
  assert_eq(Loader::Jsx.to_string(), "jsx")
  assert_eq(Loader::Ts.to_string(), "ts")
  assert_eq(Loader::Tsx.to_string(), "tsx")
  assert_eq(Loader::Css.to_string(), "css")
  assert_eq(Loader::Json.to_string(), "json")
  assert_eq(Loader::Text.to_string(), "text")
  assert_eq(Loader::Base64.to_string(), "base64")
  assert_eq(Loader::Binary.to_string(), "binary")
  assert_eq(Loader::Dataurl.to_string(), "dataurl")
  assert_eq(Loader::File.to_string(), "file")
  assert_eq(Loader::Copy.to_string(), "copy")
}

///|
test "esbuild module exists" {
  let es = esbuild()
  @core.typeof_(es.as_any()._get("build")) |> assert_eq("function")
  @core.typeof_(es.as_any()._get("transform")) |> assert_eq("function")
  @core.typeof_(es.as_any()._get("buildSync")) |> assert_eq("function")
  @core.typeof_(es.as_any()._get("transformSync")) |> assert_eq("function")
}

///|
test "transformSync minify JS" {
  let es = esbuild()
  let result = es.transform_sync(
    "const x = 1 + 2;\nconsole.log(x);",
    loader=Js,
    minify=true,
  )
  let code = result.code()
  assert_true(code.length() < 30)
  assert_true(code.contains("console.log"))
}

///|
test "transformSync TypeScript" {
  let es = esbuild()
  let result = es.transform_sync(
    "const greet = (name: string): string => `Hello, ${name}`;",
    loader=Ts,
  )
  let code = result.code()
  // TypeScript syntax should be removed
  assert_false(code.contains(": string"))
  assert_true(code.contains("greet"))
}

///|
test "transformSync TSX" {
  let es = esbuild()
  let result = es.transform_sync(
    "const App = () => <div>Hello</div>;",
    loader=Tsx,
  )
  let code = result.code()
  // JSX should be transformed
  assert_false(code.contains("<div>"))
  assert_true(code.contains("App"))
}

///|
test "transformSync with sourcemap" {
  let es = esbuild()
  let result = es.transform_sync("const x = 1;", loader=Js, sourcemap=true)
  let map = result.map()
  assert_true(map.length() > 0)
  assert_true(map.contains("mappings"))
}

///|
test "transformSync with format cjs" {
  let es = esbuild()
  let result = es.transform_sync("export const x = 1;", loader=Js, format=Cjs)
  let code = result.code()
  // ESM export should be converted to CJS
  assert_true(code.contains("exports") || code.contains("module"))
}

///|
test "transformSync with target" {
  let es = esbuild()
  let result = es.transform_sync(
    "const fn = async () => await Promise.resolve(1);",
    loader=Js,
    target="es2017",
  )
  let code = result.code()
  // async/await should be preserved in ES2017+
  assert_true(code.contains("async"))
}

///|
async test "transform async" {
  let es = esbuild()
  let result = es.transform("const x = 1 + 2;", loader=Js, minify=true)
  let code = result.code()
  assert_true(code.length() < 20)
}

///|
async test "build with write=false" {
  let es = esbuild()
  // Create a temp file first
  @fs.write_file_sync(
    "/tmp/esbuild_test_entry.js",
    "export const x = 42;" |> @core.any,
  )
  let result = es.build(
    entry_points=["/tmp/esbuild_test_entry.js"],
    write=false,
    bundle=true,
    format=Esm,
  )
  let output_files = result.output_files()
  assert_true(output_files.length() > 0)
  let first_file = output_files[0]
  let text = first_file.text()
  assert_true(text.contains("42"))
  // Cleanup
  @fs.unlink_sync("/tmp/esbuild_test_entry.js")
}

///|
async test "build with minify" {
  let es = esbuild()
  @fs.write_file_sync(
    "/tmp/esbuild_minify_test.js",
    "export function longFunctionName() { return 1 + 2 + 3; }" |> @core.any,
  )
  let result = es.build(
    entry_points=["/tmp/esbuild_minify_test.js"],
    write=false,
    bundle=true,
    minify=true,
    format=Esm,
  )
  let output_files = result.output_files()
  assert_true(output_files.length() > 0)
  let text = output_files[0].text()
  // Minified code should be shorter
  assert_true(text.length() < 100)
  @fs.unlink_sync("/tmp/esbuild_minify_test.js")
}
