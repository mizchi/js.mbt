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
/// Cached chai expect function (set up with vitest plugins)
let chai_expect : Ref[@nostd.Any?] = Ref::new(None)

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
  let use_fn = @nostd.any(chai)["use"]
  use_fn._invoke([@nostd.any(vitest_expect)["JestAsymmetricMatchers"]])
  |> ignore
  use_fn._invoke([@nostd.any(vitest_expect)["JestChaiExpect"]]) |> ignore
  use_fn._invoke([@nostd.any(vitest_expect)["JestExtend"]]) |> ignore
  chai_expect.val = Some(@nostd.any(chai)["expect"])
}

///|
/// JS: expect(actual)
/// Creates an expectation object for making assertions.
/// NOTE: Call setup() once before using this function.
pub fn expect(actual : @nostd.Any) -> Expect {
  guard chai_expect.val is Some(expect_fn) else {
    abort("vitest.setup() must be called before using expect()")
  }
  expect_fn._invoke([actual]).cast()
}

///|
/// JS: expect.not - negates the following assertion
pub fn Expect::not_(self : Expect) -> Expect {
  @nostd.any(self)["not"].cast()
}

// ============================================================
// Equality & Identity Matchers
// ============================================================

///|
/// JS: expect(actual).toBe(expected)
/// Strict equality check using Object.is
pub fn Expect::toBe(self : Expect, expected : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toBe", [expected]) |> ignore
}

///|
/// JS: expect(actual).toEqual(expected)
/// Deep equality check
pub fn Expect::toEqual(self : Expect, expected : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toEqual", [expected]) |> ignore
}

///|
/// JS: expect(actual).toStrictEqual(expected)
/// Deep equality with type checking (undefined vs missing properties)
pub fn Expect::toStrictEqual(self : Expect, expected : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toStrictEqual", [expected]) |> ignore
}

// ============================================================
// Type & Nullability Checks
// ============================================================

///|
/// JS: expect(actual).toBeDefined()
/// Asserts value is not undefined
pub fn Expect::toBeDefined(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeDefined", []) |> ignore
}

///|
/// JS: expect(actual).toBeUndefined()
/// Asserts value is undefined
pub fn Expect::toBeUndefined(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeUndefined", []) |> ignore
}

///|
/// JS: expect(actual).toBeNull()
/// Asserts value is null
pub fn Expect::toBeNull(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeNull", []) |> ignore
}

///|
/// JS: expect(actual).toBeTruthy()
/// Asserts value is truthy (not false, 0, '', null, undefined, NaN)
pub fn Expect::toBeTruthy(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeTruthy", []) |> ignore
}

///|
/// JS: expect(actual).toBeFalsy()
/// Asserts value is falsy (false, 0, '', null, undefined, NaN)
pub fn Expect::toBeFalsy(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeFalsy", []) |> ignore
}

///|
/// JS: expect(actual).toBeNaN()
/// Asserts value is NaN
pub fn Expect::toBeNaN(self : Expect) -> Unit {
  @nostd.any(self)._call("toBeNaN", []) |> ignore
}

///|
/// JS: expect(actual).toBeTypeOf(type)
/// Asserts typeof value equals type string
pub fn Expect::toBeTypeOf(self : Expect, type_ : String) -> Unit {
  @nostd.any(self)._call("toBeTypeOf", [@nostd.any(type_)]) |> ignore
}

///|
/// JS: expect(actual).toBeInstanceOf(ctor)
/// Asserts value is instance of constructor
pub fn Expect::toBeInstanceOf(self : Expect, ctor : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toBeInstanceOf", [ctor]) |> ignore
}

// ============================================================
// Numeric Comparisons
// ============================================================

///|
/// JS: expect(actual).toBeGreaterThan(n)
pub fn Expect::toBeGreaterThan(self : Expect, n : Double) -> Unit {
  @nostd.any(self)._call("toBeGreaterThan", [@nostd.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeGreaterThanOrEqual(n)
pub fn Expect::toBeGreaterThanOrEqual(self : Expect, n : Double) -> Unit {
  @nostd.any(self)._call("toBeGreaterThanOrEqual", [@nostd.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeLessThan(n)
pub fn Expect::toBeLessThan(self : Expect, n : Double) -> Unit {
  @nostd.any(self)._call("toBeLessThan", [@nostd.any(n)]) |> ignore
}

///|
/// JS: expect(actual).toBeLessThanOrEqual(n)
pub fn Expect::toBeLessThanOrEqual(self : Expect, n : Double) -> Unit {
  @nostd.any(self)._call("toBeLessThanOrEqual", [@nostd.any(n)]) |> ignore
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
      @nostd.any(self)._call("toBeCloseTo", [@nostd.any(value), @nostd.any(n)])
      |> ignore
    None => @nostd.any(self)._call("toBeCloseTo", [@nostd.any(value)]) |> ignore
  }
}

// ============================================================
// Collections & Strings
// ============================================================

///|
/// JS: expect(actual).toContain(item)
/// For arrays: checks if array contains item
/// For strings: checks if string contains substring
pub fn Expect::toContain(self : Expect, item : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toContain", [item]) |> ignore
}

///|
/// JS: expect(actual).toContainEqual(item)
/// Checks if array contains item with deep equality
pub fn Expect::toContainEqual(self : Expect, item : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toContainEqual", [item]) |> ignore
}

///|
/// JS: expect(actual).toHaveLength(length)
/// Asserts object has .length property equal to length
pub fn Expect::toHaveLength(self : Expect, length : Int) -> Unit {
  @nostd.any(self)._call("toHaveLength", [@nostd.any(length)]) |> ignore
}

///|
/// JS: expect(actual).toHaveProperty(key, value?)
/// Asserts object has property with optional value check
pub fn Expect::toHaveProperty(
  self : Expect,
  key : String,
  value? : @nostd.Any,
) -> Unit {
  match value {
    Some(v) =>
      @nostd.any(self)._call("toHaveProperty", [@nostd.any(key), v]) |> ignore
    None =>
      @nostd.any(self)._call("toHaveProperty", [@nostd.any(key)]) |> ignore
  }
}

///|
/// JS: expect(actual).toMatch(pattern)
/// For strings: matches against string or regex pattern
pub fn Expect::toMatch(self : Expect, pattern : String) -> Unit {
  @nostd.any(self)._call("toMatch", [@nostd.any(pattern)]) |> ignore
}

///|
/// JS: expect(actual).toMatchObject(expected)
/// Checks if object matches subset of properties
pub fn Expect::toMatchObject(self : Expect, expected : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toMatchObject", [expected]) |> ignore
}

// ============================================================
// Error Handling
// ============================================================

///|
/// JS: expect(fn).toThrow(expected?)
/// Asserts function throws an error
pub fn Expect::toThrow(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => @nostd.any(self)._call("toThrow", [@nostd.any(e)]) |> ignore
    None => @nostd.any(self)._call("toThrow", []) |> ignore
  }
}

///|
/// JS: expect(fn).toThrowError(expected?)
/// Alias for toThrow
pub fn Expect::toThrowError(self : Expect, expected? : String) -> Unit {
  match expected {
    Some(e) => @nostd.any(self)._call("toThrowError", [@nostd.any(e)]) |> ignore
    None => @nostd.any(self)._call("toThrowError", []) |> ignore
  }
}

///|
/// JS: expect(actual).toSatisfy(predicate)
/// Asserts value satisfies custom predicate function
pub fn Expect::toSatisfy(self : Expect, predicate : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toSatisfy", [predicate]) |> ignore
}

// ============================================================
// Mock/Spy Assertions
// ============================================================

///|
/// JS: expect(mock).toHaveBeenCalled()
pub fn Expect::toHaveBeenCalled(self : Expect) -> Unit {
  @nostd.any(self)._call("toHaveBeenCalled", []) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledTimes(amount)
pub fn Expect::toHaveBeenCalledTimes(self : Expect, amount : Int) -> Unit {
  @nostd.any(self)._call("toHaveBeenCalledTimes", [@nostd.any(amount)])
  |> ignore
}

///|
/// JS: expect(mock).toHaveBeenCalledWith(...args)
pub fn Expect::toHaveBeenCalledWith(
  self : Expect,
  args : Array[@nostd.Any],
) -> Unit {
  @nostd.any(self)._call("toHaveBeenCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenLastCalledWith(...args)
pub fn Expect::toHaveBeenLastCalledWith(
  self : Expect,
  args : Array[@nostd.Any],
) -> Unit {
  @nostd.any(self)._call("toHaveBeenLastCalledWith", args) |> ignore
}

///|
/// JS: expect(mock).toHaveBeenNthCalledWith(time, ...args)
pub fn Expect::toHaveBeenNthCalledWith(
  self : Expect,
  time : Int,
  args : Array[@nostd.Any],
) -> Unit {
  let all_args : Array[@nostd.Any] = [@nostd.any(time)]
  for arg in args {
    all_args.push(arg)
  }
  @nostd.any(self)._call("toHaveBeenNthCalledWith", all_args) |> ignore
}

///|
/// JS: expect(mock).toHaveReturned()
pub fn Expect::toHaveReturned(self : Expect) -> Unit {
  @nostd.any(self)._call("toHaveReturned", []) |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedTimes(amount)
pub fn Expect::toHaveReturnedTimes(self : Expect, amount : Int) -> Unit {
  @nostd.any(self)._call("toHaveReturnedTimes", [@nostd.any(amount)]) |> ignore
}

///|
/// JS: expect(mock).toHaveReturnedWith(value)
pub fn Expect::toHaveReturnedWith(self : Expect, value : @nostd.Any) -> Unit {
  @nostd.any(self)._call("toHaveReturnedWith", [value]) |> ignore
}

///|
/// JS: expect(mock).toHaveLastReturnedWith(value)
pub fn Expect::toHaveLastReturnedWith(
  self : Expect,
  value : @nostd.Any,
) -> Unit {
  @nostd.any(self)._call("toHaveLastReturnedWith", [value]) |> ignore
}

// ============================================================
// Async Helpers (resolves/rejects)
// ============================================================

///|
/// JS: expect(promise).resolves
/// Returns new Expect that unwraps promise and asserts on resolved value
pub fn Expect::resolves(self : Expect) -> Expect {
  @nostd.any(self)["resolves"].cast()
}

///|
/// JS: expect(promise).rejects
/// Returns new Expect that unwraps promise and asserts on rejection reason
pub fn Expect::rejects(self : Expect) -> Expect {
  @nostd.any(self)["rejects"].cast()
}
