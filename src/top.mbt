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
  atob,
  btoa,
  encodeURI,
  decodeURI,
  encodeURIComponent,
  decodeURIComponent,
  structuredClone,
  setTimeout,
  clearTimeout,
  setInterval,
  clearInterval,
  queueMicrotask,
  dynamic_import,
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

///| JavaScript Math

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math
pub using @math {type Math}

///| JavaScript Date

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
pub using @date {type Date}

///| JavaScript RegExp

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp
pub using @regexp {type RegExp, type RegExpMatchArray, type RegExpResult}

///| JavaScript Collections (Map and Set)

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
pub using @collection {type JsMap, type JsSet}

///| JavaScript BigInt

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt
pub using @bigint {type JsBigInt}

///| JavaScript Weak References

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry
pub using @weak {
  type WeakMap,
  type WeakSet,
  type WeakRef,
  type FinalizationRegistry,
}

///| JavaScript Proxy

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy
pub using @proxy {type Proxy}

///| JavaScript Reflect

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect
pub using @reflect {
  apply,
  construct,
  defineProperty,
  deleteProperty,
  get,
  getOwnPropertyDescriptor,
  getPrototypeOf,
  has,
  isExtensible,
  ownKeys,
  preventExtensions,
  set,
  setPrototypeOf,
}

///| JavaScript Atomics

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
pub using @atomics {type Atomics, type AtomicsWaitResult}

///| JavaScript Function

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function
pub using @function {type Function}

///| JavaScript Disposable Resources

///|
/// @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DisposableStack
pub using @disposable {type DisposableStack, type AsyncDisposableStack}
