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

///|
/// Expect assertion object returned by expect()
#external
pub type Expect

///|
impl @js.JsImpl for Expect

///|
/// Cached chai expect function (set up with vitest plugins)
let chai_expect : Ref[@js.Any?] = Ref::new(None)

///|
/// Setup chai with @vitest/expect plugins.
/// Call this once before using expect.
pub fn setup_standalone() -> Unit {
  if chai_expect.val is Some(_) {
    return
  }
  let chai = @node.require("chai")
  let vitest_expect = @node.require("@vitest/expect")
  // use() plugins
  let use_fn = chai.get("use")
  use_fn.call_self([vitest_expect.get("JestAsymmetricMatchers")]) |> ignore
  use_fn.call_self([vitest_expect.get("JestChaiExpect")]) |> ignore
  use_fn.call_self([vitest_expect.get("JestExtend")]) |> ignore
  chai_expect.val = Some(chai.get("expect"))
}

///|
/// JS: expect(actual)
/// Creates an expectation object for making assertions.
/// NOTE: Call setup() once before using this function.
pub fn[T : @js.JsImpl] expect(actual : T) -> Expect {
  guard chai_expect.val is Some(expect_fn) else {
    abort("vitest.setup() must be called before using expect()")
  }
  expect_fn.call_self([actual]).cast()
}

///|
/// JS: expect.not - negates the following assertion
pub fn Expect::not_(self : Expect) -> Expect {
  self.get("not").cast()
}

// ============================================================
// Equality & Identity Matchers
// ============================================================

///|
/// JS: expect(actual).toBe(expected)
/// Strict equality check using Object.is
pub fn[T : @js.JsImpl] Expect::toBe(self : Expect, expected : T) -> Unit {
  self.call1("toBe", expected) |> ignore
}

///|
/// JS: expect(actual).toEqual(expected)
/// Deep equality check
pub fn[T : @js.JsImpl] Expect::toEqual(self : Expect, expected : T) -> Unit {
  self.call1("toEqual", expected) |> ignore
}

///|
/// JS: expect(actual).toStrictEqual(expected)
/// Deep equality with type checking (undefined vs missing properties)
pub fn[T : @js.JsImpl] Expect::toStrictEqual(
  self : Expect,
  expected : T,
) -> Unit {
  self.call1("toStrictEqual", expected) |> ignore
}

// ============================================================
// Type & Nullability Checks
// ============================================================

///|
/// JS: expect(actual).toBeDefined()
/// Asserts value is not undefined
pub fn Expect::toBeDefined(self : Expect) -> Unit {
  self.call0("toBeDefined") |> ignore
}

///|
/// JS: expect(actual).toBeUndefined()
/// Asserts value is undefined
pub fn Expect::toBeUndefined(self : Expect) -> Unit {
  self.call0("toBeUndefined") |> ignore
}

///|
/// JS: expect(actual).toBeNull()
/// Asserts value is null
pub fn Expect::toBeNull(self : Expect) -> Unit {
  self.call0("toBeNull") |> ignore
}

///|
/// JS: expect(actual).toBeTruthy()
/// Asserts value is truthy (not false, 0, '', null, undefined, NaN)
pub fn Expect::toBeTruthy(self : Expect) -> Unit {
  self.call0("toBeTruthy") |> ignore
}

///|
/// JS: expect(actual).toBeFalsy()
/// Asserts value is falsy (false, 0, '', null, undefined, NaN)
pub fn Expect::toBeFalsy(self : Expect) -> Unit {
  self.call0("toBeFalsy") |> ignore
}

///|
/// JS: expect(actual).toBeNaN()
/// Asserts value is NaN
pub fn Expect::toBeNaN(self : Expect) -> Unit {
  self.call0("toBeNaN") |> ignore
}

///|
/// JS: expect(actual).toBeTypeOf(type)
/// Asserts typeof value equals type string
pub fn Expect::toBeTypeOf(self : Expect, type_ : String) -> Unit {
  self.call1("toBeTypeOf", type_) |> ignore
}

///|
/// JS: expect(actual).toBeInstanceOf(ctor)
/// Asserts value is instance of constructor
pub fn[T : @js.JsImpl] Expect::toBeInstanceOf(self : Expect, ctor : T) -> Unit {
  self.call1("toBeInstanceOf", ctor) |> ignore
}

// ============================================================
// Numeric Comparisons
// ============================================================

///|
/// JS: expect(actual).toBeGreaterThan(n)
pub fn Expect::toBeGreaterThan(self : Expect, n : Double) -> Unit {
  self.call1("toBeGreaterThan", n) |> ignore
}

///|
/// JS: expect(actual).toBeGreaterThanOrEqual(n)
pub fn Expect::toBeGreaterThanOrEqual(self : Expect, n : Double) -> Unit {
  self.call1("toBeGreaterThanOrEqual", n) |> ignore
}

///|
/// JS: expect(actual).toBeLessThan(n)
pub fn Expect::toBeLessThan(self : Expect, n : Double) -> Unit {
  self.call1("toBeLessThan", n) |> ignore
}

///|
/// JS: expect(actual).toBeLessThanOrEqual(n)
pub fn Expect::toBeLessThanOrEqual(self : Expect, n : Double) -> Unit {
  self.call1("toBeLessThanOrEqual", n) |> ignore
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
    Some(n) => self.call2("toBeCloseTo", value, n) |> ignore
    None => self.call1("toBeCloseTo", value) |> ignore
  }
}

// ============================================================
// Collections & Strings
// ============================================================

///|
/// JS: expect(actual).toContain(item)
/// For arrays: checks if array contains item
/// For strings: checks if string contains substring
pub fn[T : @js.JsImpl] Expect::toContain(self : Expect, item : T) -> Unit {
  self.call1("toContain", item) |> ignore
}

///|
/// JS: expect(actual).toContainEqual(item)
/// Checks if array contains item with deep equality
pub fn[T : @js.JsImpl] Expect::toContainEqual(self : Expect, item : T) -> Unit {
  self.call1("toContainEqual", item) |> ignore
}

///|
/// JS: expect(actual).toHaveLength(length)
/// Asserts object has .length property equal to length
pub fn Expect::toHaveLength(self : Expect, length : Int) -> Unit {
  self.call1("toHaveLength", length) |> ignore
}

///|
/// JS: expect(actual).toHaveProperty(key, value?)
/// Asserts object has property with optional value check
pub fn Expect::toHaveProperty(
  self : Expect,
  key : String,
  value? : @js.Any,
) -> Unit {
  match value {
    Some(v) => self.call2("toHaveProperty", key, v) |> ignore
    None => self.call1("toHaveProperty", key) |> ignore
  }
}

///|
/// JS: expect(actual).toMatch(pattern)
/// For strings: matches against string or regex pattern
pub fn Expect::toMatch(self : Expect, pattern : String) -> Unit {
  self.call1("toMatch", pattern) |> ignore
}

///|
/// JS: expect(actual).toMatchObject(expected)
/// Checks if object matches subset of properties
pub fn[T : @js.JsImpl] Expect::toMatchObject(
  self : Expect,
  expected : T,
) -> Unit {
  self.call1("toMatchObject", expected) |> ignore
}

// ============================================================
// Error Handling
// ============================================================

///|
/// JS: expect(fn).toThrow(expected?)
/// Asserts function throws an error
pub fn Expect::toThrow(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => self.call1("toThrow", e) |> ignore
    None => self.call0("toThrow") |> ignore
  }
}

///|
/// JS: expect(fn).toThrowError(expected?)
/// Alias for toThrow
pub fn Expect::toThrowError(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => self.call1("toThrowError", e) |> ignore
    None => self.call0("toThrowError") |> ignore
  }
}

///|
/// JS: expect(actual).toSatisfy(predicate)
/// Asserts value satisfies custom predicate function
pub fn Expect::toSatisfy(self : Expect, predicate : @js.Any) -> Unit {
  self.call1("toSatisfy", predicate) |> ignore
}

// ============================================================
// Mock/Spy Assertions
// ============================================================

///|
/// JS: expect(mock).toHaveBeenCalled()
pub fn Expect::toHaveBeenCalled(self : Expect) -> Unit {
  self.call0("toHaveBeenCalled") |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledTimes(amount)
pub fn Expect::toHaveBeenCalledTimes(self : Expect, amount : Int) -> Unit {
  self.call1("toHaveBeenCalledTimes", amount) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledWith(...args)
pub fn Expect::toHaveBeenCalledWith(
  self : Expect,
  args : Array[&@js.JsImpl],
) -> Unit {
  self.call("toHaveBeenCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenLastCalledWith(...args)
pub fn Expect::toHaveBeenLastCalledWith(
  self : Expect,
  args : Array[&@js.JsImpl],
) -> Unit {
  self.call("toHaveBeenLastCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenNthCalledWith(time, ...args)
pub fn Expect::toHaveBeenNthCalledWith(
  self : Expect,
  time : Int,
  args : Array[&@js.JsImpl],
) -> Unit {
  let all_args : Array[&@js.JsImpl] = [time]
  for arg in args {
    all_args.push(arg)
  }
  self.call("toHaveBeenNthCalledWith", all_args) |> ignore
}

///|
/// JS: expect(mock).toHaveReturned()
pub fn Expect::toHaveReturned(self : Expect) -> Unit {
  self.call0("toHaveReturned") |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedTimes(amount)
pub fn Expect::toHaveReturnedTimes(self : Expect, amount : Int) -> Unit {
  self.call1("toHaveReturnedTimes", amount) |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedWith(value)
pub fn[T : @js.JsImpl] Expect::toHaveReturnedWith(
  self : Expect,
  value : T,
) -> Unit {
  self.call1("toHaveReturnedWith", value) |> ignore
}

///|
/// JS: expect(mock).toHaveLastReturnedWith(value)
pub fn[T : @js.JsImpl] Expect::toHaveLastReturnedWith(
  self : Expect,
  value : T,
) -> Unit {
  self.call1("toHaveLastReturnedWith", value) |> ignore
}

// ============================================================
// Async Helpers (resolves/rejects)
// ============================================================

///|
/// JS: expect(promise).resolves
/// Returns new Expect that unwraps promise and asserts on resolved value
pub fn Expect::resolves(self : Expect) -> Expect {
  self.get("resolves").cast()
}

///|
/// JS: expect(promise).rejects
/// Returns new Expect that unwraps promise and asserts on rejection reason
pub fn Expect::rejects(self : Expect) -> Expect {
  self.get("rejects").cast()
}
