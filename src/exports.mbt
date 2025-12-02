///|
/// JavaScript: AbortController and AbortSignal
/// for future integration with async operations
pub using @js_async {type AbortController, type AbortSignal}

///|
pub using @core {
  type Any,
  type Nullable,
  type Nullish,
  identity,
  any,
  typeof_,
  from_fn0,
  from_fn1,
  from_fn2,
  from_fn3,
  new,
  run_async,
  suspend,
}

///|
pub using @object {type Object}

///|
pub using @symbol {type Symbol, symbol}

///|
pub using @arraybuffer {
  type ArrayBuffer,
  type TypedArray,
  type DataView,
  type SharedArrayBuffer,
}
