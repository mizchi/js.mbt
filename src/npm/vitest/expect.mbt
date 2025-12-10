///|
/// Vitest expect API bindings for MoonBit
/// Uses chai + @vitest/expect plugins for standalone usage (no test runner required)
///
/// Setup: Call setup() once before using expect:
/// ```
/// @vitest.setup()
/// let result = @vitest.expect(1 + 1)
/// result.toBe(2)
/// ```

///| Global initialization

///|
/// Dynamic import for chai module
extern "js" fn import_chai() -> @core.Promise[@core.Any] =
  #|() => import("chai")

///|
/// Dynamic import for @vitest/expect module
extern "js" fn import_vitest_expect() -> @core.Promise[@core.Any] =
  #|() => import("@vitest/expect")

///|
/// Expect assertion object returned by expect()
#external
pub type Expect

///|
/// Cached chai expect function (set up with vitest plugins)
let chai_expect : Ref[@core.Any?] = Ref::new(None)

///|
/// Setup chai with @vitest/expect plugins asynchronously.
/// Call this once before using expect.
pub async fn setup_standalone() -> Unit {
  if chai_expect.val is Some(_) {
    return
  }
  let chai = import_chai().wait()
  let vitest_expect = import_vitest_expect().wait()
  // use() plugins
  let use_fn = chai["use"]
  use_fn._invoke([vitest_expect["JestAsymmetricMatchers"]]) |> ignore
  use_fn._invoke([vitest_expect["JestChaiExpect"]]) |> ignore
  use_fn._invoke([vitest_expect["JestExtend"]]) |> ignore
  chai_expect.val = Some(chai["expect"])
}

///|
/// Setup chai with @vitest/expect plugins synchronously (for testing with require)
pub fn init_vitest(chai : @core.Any, vitest_expect : @core.Any) -> Unit {
  if chai_expect.val is Some(_) {
    return
  }
  let use_fn = chai["use"]
  use_fn._invoke([vitest_expect["JestAsymmetricMatchers"]]) |> ignore
  use_fn._invoke([vitest_expect["JestChaiExpect"]]) |> ignore
  use_fn._invoke([vitest_expect["JestExtend"]]) |> ignore
  chai_expect.val = Some(chai["expect"])
}

///|
/// JS: expect(actual)
/// Creates an expectation object for making assertions.
/// NOTE: Call setup() once before using this function.
pub fn expect(actual : @core.Any) -> Expect {
  guard chai_expect.val is Some(expect_fn) else {
    abort("vitest.setup() must be called before using expect()")
  }
  expect_fn._invoke([actual]).cast()
}

///|
/// JS: expect.not - negates the following assertion
pub fn Expect::not_(self : Expect) -> Expect {
  @core.any(self)["not"].cast()
}

// ============================================================
// Equality & Identity Matchers
// ============================================================

///|
/// JS: expect(actual).toBe(expected)
/// Strict equality check using Object.is
pub fn Expect::toBe(self : Expect, expected : @core.Any) -> Unit {
  @core.any(self)._call("toBe", [expected]) |> ignore
}

///|
/// JS: expect(actual).toEqual(expected)
/// Deep equality check
pub fn Expect::toEqual(self : Expect, expected : @core.Any) -> Unit {
  @core.any(self)._call("toEqual", [expected]) |> ignore
}

///|
/// JS: expect(actual).toStrictEqual(expected)
/// Deep equality with type checking (undefined vs missing properties)
pub fn Expect::toStrictEqual(self : Expect, expected : @core.Any) -> Unit {
  @core.any(self)._call("toStrictEqual", [expected]) |> ignore
}

// ============================================================
// Type & Nullability Checks
// ============================================================

///|
/// JS: expect(actual).toBeDefined()
/// Asserts value is not undefined
pub fn Expect::toBeDefined(self : Expect) -> Unit {
  @core.any(self)._call("toBeDefined", []) |> ignore
}

///|
/// JS: expect(actual).toBeUndefined()
/// Asserts value is undefined
pub fn Expect::toBeUndefined(self : Expect) -> Unit {
  @core.any(self)._call("toBeUndefined", []) |> ignore
}

///|
/// JS: expect(actual).toBeNull()
/// Asserts value is null
pub fn Expect::toBeNull(self : Expect) -> Unit {
  @core.any(self)._call("toBeNull", []) |> ignore
}

///|
/// JS: expect(actual).toBeTruthy()
/// Asserts value is truthy (not false, 0, '', null, undefined, NaN)
pub fn Expect::toBeTruthy(self : Expect) -> Unit {
  @core.any(self)._call("toBeTruthy", []) |> ignore
}

///|
/// JS: expect(actual).toBeFalsy()
/// Asserts value is falsy (false, 0, '', null, undefined, NaN)
pub fn Expect::toBeFalsy(self : Expect) -> Unit {
  @core.any(self)._call("toBeFalsy", []) |> ignore
}

///|
/// JS: expect(actual).toBeNaN()
/// Asserts value is NaN
pub fn Expect::toBeNaN(self : Expect) -> Unit {
  @core.any(self)._call("toBeNaN", []) |> ignore
}

///|
/// JS: expect(actual).toBeTypeOf(type)
/// Asserts typeof value equals type string
pub fn Expect::toBeTypeOf(self : Expect, type_ : String) -> Unit {
  @core.any(self)._call("toBeTypeOf", [@core.any(type_)]) |> ignore
}

///|
/// JS: expect(actual).toBeInstanceOf(ctor)
/// Asserts value is instance of constructor
pub fn Expect::toBeInstanceOf(self : Expect, ctor : @core.Any) -> Unit {
  @core.any(self)._call("toBeInstanceOf", [ctor]) |> ignore
}

// ============================================================
// Numeric Comparisons
// ============================================================

///|
/// JS: expect(actual).toBeGreaterThan(n)
pub fn Expect::toBeGreaterThan(self : Expect, n : Double) -> Unit {
  @core.any(self)._call("toBeGreaterThan", [@core.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeGreaterThanOrEqual(n)
pub fn Expect::toBeGreaterThanOrEqual(self : Expect, n : Double) -> Unit {
  @core.any(self)._call("toBeGreaterThanOrEqual", [@core.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeLessThan(n)
pub fn Expect::toBeLessThan(self : Expect, n : Double) -> Unit {
  @core.any(self)._call("toBeLessThan", [@core.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeLessThanOrEqual(n)
pub fn Expect::toBeLessThanOrEqual(self : Expect, n : Double) -> Unit {
  @core.any(self)._call("toBeLessThanOrEqual", [@core.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeCloseTo(value, numDigits?)
/// Floating-point comparison with precision
pub fn Expect::toBeCloseTo(
  self : Expect,
  value : Double,
  num_digits? : Int,
) -> Unit {
  match num_digits {
    Some(n) =>
      @core.any(self)._call("toBeCloseTo", [@core.any(value), @core.any(n)])
      |> ignore
    None => @core.any(self)._call("toBeCloseTo", [@core.any(value)]) |> ignore
  }
}

// ============================================================
// Collections & Strings
// ============================================================

///|
/// JS: expect(actual).toContain(item)
/// For arrays: checks if array contains item
/// For strings: checks if string contains substring
pub fn Expect::toContain(self : Expect, item : @core.Any) -> Unit {
  @core.any(self)._call("toContain", [item]) |> ignore
}

///|
/// JS: expect(actual).toContainEqual(item)
/// Checks if array contains item with deep equality
pub fn Expect::toContainEqual(self : Expect, item : @core.Any) -> Unit {
  @core.any(self)._call("toContainEqual", [item]) |> ignore
}

///|
/// JS: expect(actual).toHaveLength(length)
/// Asserts object has .length property equal to length
pub fn Expect::toHaveLength(self : Expect, length : Int) -> Unit {
  @core.any(self)._call("toHaveLength", [@core.any(length)]) |> ignore
}

///|
/// JS: expect(actual).toHaveProperty(key, value?)
/// Asserts object has property with optional value check
pub fn Expect::toHaveProperty(
  self : Expect,
  key : String,
  value? : @core.Any,
) -> Unit {
  match value {
    Some(v) =>
      @core.any(self)._call("toHaveProperty", [@core.any(key), v]) |> ignore
    None => @core.any(self)._call("toHaveProperty", [@core.any(key)]) |> ignore
  }
}

///|
/// JS: expect(actual).toMatch(pattern)
/// For strings: matches against string or regex pattern
pub fn Expect::toMatch(self : Expect, pattern : String) -> Unit {
  @core.any(self)._call("toMatch", [@core.any(pattern)]) |> ignore
}

///|
/// JS: expect(actual).toMatchObject(expected)
/// Checks if object matches subset of properties
pub fn Expect::toMatchObject(self : Expect, expected : @core.Any) -> Unit {
  @core.any(self)._call("toMatchObject", [expected]) |> ignore
}

// ============================================================
// Error Handling
// ============================================================

///|
/// JS: expect(fn).toThrow(expected?)
/// Asserts function throws an error
pub fn Expect::toThrow(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => @core.any(self)._call("toThrow", [@core.any(e)]) |> ignore
    None => @core.any(self)._call("toThrow", []) |> ignore
  }
}

///|
/// JS: expect(fn).toThrowError(expected?)
/// Alias for toThrow
pub fn Expect::toThrowError(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => @core.any(self)._call("toThrowError", [@core.any(e)]) |> ignore
    None => @core.any(self)._call("toThrowError", []) |> ignore
  }
}

///|
/// JS: expect(actual).toSatisfy(predicate)
/// Asserts value satisfies custom predicate function
pub fn Expect::toSatisfy(self : Expect, predicate : @core.Any) -> Unit {
  @core.any(self)._call("toSatisfy", [predicate]) |> ignore
}

// ============================================================
// Mock/Spy Assertions
// ============================================================

///|
/// JS: expect(mock).toHaveBeenCalled()
pub fn Expect::toHaveBeenCalled(self : Expect) -> Unit {
  @core.any(self)._call("toHaveBeenCalled", []) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledTimes(amount)
pub fn Expect::toHaveBeenCalledTimes(self : Expect, amount : Int) -> Unit {
  @core.any(self)._call("toHaveBeenCalledTimes", [@core.any(amount)]) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledWith(...args)
pub fn Expect::toHaveBeenCalledWith(
  self : Expect,
  args : Array[@core.Any],
) -> Unit {
  @core.any(self)._call("toHaveBeenCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenLastCalledWith(...args)
pub fn Expect::toHaveBeenLastCalledWith(
  self : Expect,
  args : Array[@core.Any],
) -> Unit {
  @core.any(self)._call("toHaveBeenLastCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenNthCalledWith(time, ...args)
pub fn Expect::toHaveBeenNthCalledWith(
  self : Expect,
  time : Int,
  args : Array[@core.Any],
) -> Unit {
  let all_args : Array[@core.Any] = [@core.any(time)]
  for arg in args {
    all_args.push(arg)
  }
  @core.any(self)._call("toHaveBeenNthCalledWith", all_args) |> ignore
}

///|
/// JS: expect(mock).toHaveReturned()
pub fn Expect::toHaveReturned(self : Expect) -> Unit {
  @core.any(self)._call("toHaveReturned", []) |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedTimes(amount)
pub fn Expect::toHaveReturnedTimes(self : Expect, amount : Int) -> Unit {
  @core.any(self)._call("toHaveReturnedTimes", [@core.any(amount)]) |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedWith(value)
pub fn Expect::toHaveReturnedWith(self : Expect, value : @core.Any) -> Unit {
  @core.any(self)._call("toHaveReturnedWith", [value]) |> ignore
}

///|
/// JS: expect(mock).toHaveLastReturnedWith(value)
pub fn Expect::toHaveLastReturnedWith(self : Expect, value : @core.Any) -> Unit {
  @core.any(self)._call("toHaveLastReturnedWith", [value]) |> ignore
}

// ============================================================
// Async Helpers (resolves/rejects)
// ============================================================

///|
/// JS: expect(promise).resolves
/// Returns new Expect that unwraps promise and asserts on resolved value
pub fn Expect::resolves(self : Expect) -> Expect {
  @core.any(self)["resolves"].cast()
}

///|
/// JS: expect(promise).rejects
/// Returns new Expect that unwraps promise and asserts on rejection reason
pub fn Expect::rejects(self : Expect) -> Expect {
  @core.any(self)["rejects"].cast()
}
