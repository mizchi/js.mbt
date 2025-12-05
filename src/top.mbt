///| Core JavaScript types and utilities

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects
pub using @core {
  type Any,
  type Nullable,
  type Nullish,
  type Promise,
  type PromiseResolvers,
  type ThrowError,
  identity,
  any,
  typeof_,
  from_fn0,
  from_fn1,
  from_fn2,
  from_fn3,
  promisify0,
  promisify1,
  promisify2,
  promisify3,
  new_object,
  new_array,
  new,
  run_async,
  suspend,
  log,
  throwable,
}

///| JavaScript Global Functions

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects
pub using @global {
  type Timer,
  globalThis,
  undefined,
  isNaN,
  isFinite,
  parseInt,
  parseFloat,
  parse_float,
  atob,
  btoa,
  encodeURI,
  decodeURI,
  encodeURIComponent,
  dynamic_import,
  setTimeout,
  set_timeout,
  clearTimeout,
  clear_timeout,
  setInterval,
  set_interval,
  clearInterval,
  clear_interval,
  queueMicrotask,
  queue_microtask,
}

///| JavaScript Error types

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
pub using @error {
  type JsError,
  type TypeError,
  type RangeError,
  type ReferenceError,
  type SyntaxError,
  type URIError,
  type EvalError,
  type AggregateError,
}

///| JavaScript Object

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object
pub using @object {type Object}

///| JavaScript Symbol

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
pub using @symbol {type Symbol, symbol}

///| JavaScript ArrayBuffer and TypedArrays

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
pub using @arraybuffer {
  type ArrayBuffer,
  type TypedArray,
  type DataView,
  type SharedArrayBuffer,
}

///| JavaScript Array (JsArray to avoid conflict with MoonBit's Array)

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array
pub using @array {type JsArray}

///| JavaScript String (JsString for consistency)

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String
pub using @string {type JsString}

///| JavaScript JSON

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON
pub using @json {type JSON}

///| JavaScript Iterators

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols
pub using @iterator {type JsIterator, type AsyncIterator}

///| JavaScript AbortController and AbortSignal

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/API/AbortController
pub using @js_async {type AbortController, type AbortSignal}
