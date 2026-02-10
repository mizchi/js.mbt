///| Tagged Template Support
/// Enables calling JavaScript tagged template functions from MoonBit.
/// Template format uses ${@0}, ${@1}, etc. as placeholders to avoid
/// conflict with MoonBit's \{} string interpolation.

///|
/// TemplateStringsArray - corresponds to TypeScript's TemplateStringsArray.
///
/// In JavaScript tagged templates, the first argument is an array of string
/// literals with a `raw` property containing the raw (unescaped) versions.
///
/// TypeScript definition:
/// ```typescript
/// interface TemplateStringsArray extends ReadonlyArray<string> {
///     readonly raw: ReadonlyArray<string>;
/// }
/// ```
///
/// See: https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html
#external
pub type TemplateStringsArray

///|
pub fn TemplateStringsArray::to_any(self : TemplateStringsArray) -> Any = "%identity"

///|
/// Get the string at the given index
pub fn TemplateStringsArray::op_get(
  self : TemplateStringsArray,
  index : Int,
) -> String {
  let arr : Any = identity(self)
  arr._get_by_index(index).cast()
}

///|
/// Get the length of the template strings array
pub fn TemplateStringsArray::length(self : TemplateStringsArray) -> Int {
  let arr : Any = identity(self)
  arr["length"].cast()
}

///|
/// Get the raw (unescaped) string at the given index
pub fn TemplateStringsArray::raw_get(
  self : TemplateStringsArray,
  index : Int,
) -> String {
  let arr : Any = identity(self)
  arr["raw"]._get_by_index(index).cast()
}

///|
/// Get the raw array
pub fn TemplateStringsArray::raw(self : TemplateStringsArray) -> Array[String] {
  let arr : Any = identity(self)
  arr["raw"].cast()
}

///|
/// Internal: Call a tagged template function with parsed template and args.
/// The JS side handles parsing ${@N} placeholders and invoking the tag function.
/// Note: MoonBit tag functions receive (TemplateStringsArray, Array[Any])
/// instead of JS's (strings, ...values) spread syntax.
extern "js" fn ffi_call_tagged_template(
  tag_fn : Any,
  template : String,
  args : Array[Any],
) -> Any =
  #| (tagFn, template, args) => {
  #|   const [strings, values] = template.split(/\$\{@(\d+)\}/).reduce(
  #|     ([s, v], x, i) => i % 2 ? [s, [...v, args[+x]]] : [[...s, x], v], [[], []]
  #|   );
  #|   return tagFn((strings.raw = strings, strings), values);
  #| }

///|
/// Call a JavaScript tagged template function with type safety.
///
/// This function enables MoonBit code to call JavaScript tagged template
/// literals like `css\`color: \${color}\`` or `html\`<div>\${content}</div>\``.
///
/// # Template Format
///
/// Use `${@0}`, `${@1}`, etc. as placeholders (0-indexed):
/// - `"color: ${@0}; font-size: ${@1}px"` with args `["red", "16"]`
///
/// # Tag Function Type
///
/// The tag function should have the signature:
/// ```moonbit nocheck
/// fn(TemplateStringsArray, Array[Any]) -> T
/// ```
///
/// TypeScript equivalent:
/// ```typescript
/// type TagFn<T> = (strings: TemplateStringsArray, ...values: any[]) => T
/// ```
///
/// # Example
///
/// ```moonbit nocheck
/// // Define a typed tag function
/// fn my_css(
///   strings : @core.TemplateStringsArray,
///   values : Array[@core.Any],
/// ) -> String {
///   let mut result = strings[0]
///   for i, v in values {
///     result = result + v.to_string() + strings[i + 1]
///   }
///   result
/// }
///
/// // Call it
///
/// let result : String = tag(my_css, "color: ${@0}", [@core.any("red")])
/// ```
///
/// # How It Works
///
/// JavaScript tagged templates receive:
/// 1. An array of string parts (with a `raw` property)
/// 2. The interpolation values as separate arguments
///
/// For template `"a${@0}b${@1}c"` with args `[1, 2]`:
/// - strings: `["a", "b", "c"]` (with strings.raw = ["a", "b", "c"])
/// - values: `[1, 2]`
/// - Calls: `tagFn(strings, 1, 2)`
pub fn[T] tag(
  tag_fn : (TemplateStringsArray, Array[Any]) -> T,
  template : String,
  args : Array[Any],
) -> T {
  let result = ffi_call_tagged_template(any(tag_fn), template, args)
  identity(result)
}
