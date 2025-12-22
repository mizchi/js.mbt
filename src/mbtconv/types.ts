/**
 * TypeScript helpers for working with MoonBit types compiled to JavaScript
 *
 * MoonBit compiles its types to JavaScript with specific representations.
 * These helpers provide type-safe ways to work with those representations.
 */

// =============================================================================
// Result Type
// =============================================================================

/**
 * MoonBit's Result[T, E] compiles to:
 * - Ok(value) -> { _0: value } with constructor.name containing "Ok"
 * - Err(error) -> { _0: error } with constructor.name containing "Err"
 *
 * IMPORTANT: JSON.stringify loses Ok/Err distinction (both become {"_0":...})
 */
export interface MbtResultOk<T> {
  _0: T;
}

export interface MbtResultErr<E> {
  _0: E;
}

export type MbtResult<T, E> = MbtResultOk<T> | MbtResultErr<E>;

/**
 * Check if a MoonBit Result is Ok variant
 */
export function isOk<T, E>(result: MbtResult<T, E>): result is MbtResultOk<T> {
  return result.constructor.name.includes("Ok");
}

/**
 * Check if a MoonBit Result is Err variant
 */
export function isErr<T, E>(result: MbtResult<T, E>): result is MbtResultErr<E> {
  return result.constructor.name.includes("Err");
}

/**
 * Unwrap Ok value, throw if Err
 */
export function unwrapOk<T, E>(result: MbtResult<T, E>): T {
  if (isOk(result)) {
    return result._0;
  }
  throw new Error(`Expected Ok, got Err: ${JSON.stringify(result._0)}`);
}

/**
 * Unwrap Err value, throw if Ok
 */
export function unwrapErr<T, E>(result: MbtResult<T, E>): E {
  if (isErr(result)) {
    return result._0;
  }
  throw new Error(`Expected Err, got Ok: ${JSON.stringify(result._0)}`);
}

/**
 * Convert MoonBit Result to standard JS object with explicit type field
 */
export function toResultObject<T, E>(
  result: MbtResult<T, E>
): { type: "ok"; value: T } | { type: "err"; error: E } {
  if (isOk(result)) {
    return { type: "ok", value: result._0 };
  }
  return { type: "err", error: result._0 };
}

/**
 * Match on Result (pattern matching helper)
 */
export function matchResult<T, E, R>(
  result: MbtResult<T, E>,
  handlers: {
    ok: (value: T) => R;
    err: (error: E) => R;
  }
): R {
  if (isOk(result)) {
    return handlers.ok(result._0);
  }
  return handlers.err(result._0);
}

// =============================================================================
// Option Type
// =============================================================================

/**
 * MoonBit's Option[T] compiles to:
 * - Some(value) -> value (unwrapped)
 * - None -> undefined
 */
export type MbtOption<T> = T | undefined;

/**
 * Check if Option is Some
 */
export function isSome<T>(option: MbtOption<T>): option is T {
  return option !== undefined;
}

/**
 * Check if Option is None
 */
export function isNone<T>(option: MbtOption<T>): option is undefined {
  return option === undefined;
}

/**
 * Unwrap Some value, throw if None
 */
export function unwrapSome<T>(option: MbtOption<T>): T {
  if (isSome(option)) {
    return option;
  }
  throw new Error("Expected Some, got None");
}

/**
 * Unwrap Some value, or return default
 */
export function unwrapOr<T>(option: MbtOption<T>, defaultValue: T): T {
  return isSome(option) ? option : defaultValue;
}

// =============================================================================
// Enum Types
// =============================================================================

/**
 * MoonBit enum unit variant (no arguments):
 * { $tag: number, $name: string }
 */
export interface MbtEnumUnit {
  $tag: number;
  $name: string;
}

/**
 * MoonBit enum tuple variant (with arguments):
 * { _0: arg0, _1: arg1, ... }
 * Note: $tag is on prototype (accessible but not own property)
 *
 * After JSON roundtrip, $tag is LOST
 */
export interface MbtEnumTuple {
  _0?: unknown;
  _1?: unknown;
  _2?: unknown;
  _3?: unknown;
  _4?: unknown;
  [key: `_${number}`]: unknown;
}

/**
 * Check if value is a unit variant enum
 */
export function isUnitVariant(value: unknown): value is MbtEnumUnit {
  return (
    typeof value === "object" &&
    value !== null &&
    "$tag" in value &&
    "$name" in value
  );
}

/**
 * Get enum variant name
 * - For unit variants: returns $name
 * - For tuple variants: parses constructor.name (e.g., "Color$Rgb" -> "Rgb")
 */
export function getVariantName(value: object): string {
  if (isUnitVariant(value)) {
    return value.$name;
  }
  const ctorName = value.constructor.name;
  const parts = ctorName.split("$");
  return parts.length > 1 ? parts[parts.length - 1] : ctorName;
}

/**
 * Get enum tag index
 * Works for both unit and tuple variants
 */
export function getEnumTag(value: object): number {
  // @ts-expect-error: $tag may be on prototype
  return value.$tag ?? -1;
}

/**
 * Get tuple variant arguments as array
 */
export function getTupleArgs(value: MbtEnumTuple): unknown[] {
  const args: unknown[] = [];
  let i = 0;
  while (`_${i}` in value) {
    args.push(value[`_${i}` as `_${number}`]);
    i++;
  }
  return args;
}

// =============================================================================
// Struct Types
// =============================================================================

/**
 * MoonBit structs compile directly to JS objects with field names preserved.
 * Example: { x: Int, y: Int } -> { x: 10, y: 20 }
 *
 * Structs are fully JSON-serializable and roundtrip-safe.
 */

// No special helpers needed - use regular TypeScript interfaces

// =============================================================================
// Newtype
// =============================================================================

/**
 * MoonBit newtypes (priv struct Foo(T)) are unwrapped in JS.
 * Example: UserId(123) -> 123
 *
 * No wrapper object exists at runtime.
 */

// No special helpers needed - the value IS the inner type

// =============================================================================
// Special Types
// =============================================================================

/**
 * MoonBit Map[K, V] internal structure
 * NOT a plain object - use mbtconv.from_map() to convert
 */
export interface MbtMap {
  entries: unknown[];
  size: number;
  capacity: number;
  capacity_mask: number;
  grow_at: number;
  head: unknown;
  tail: unknown;
}

/**
 * Check if value is a MoonBit Map (by structure)
 */
export function isMbtMap(value: unknown): value is MbtMap {
  return (
    typeof value === "object" &&
    value !== null &&
    "entries" in value &&
    "size" in value &&
    "capacity" in value
  );
}

// =============================================================================
// Trait Objects
// =============================================================================

/**
 * MoonBit trait objects compile to:
 * { self: actualValue, method_0: fn, method_1: fn, ... }
 */
export interface MbtTraitObject<T = unknown> {
  self: T;
  [key: `method_${number}`]: (...args: unknown[]) => unknown;
}

/**
 * Check if value is a trait object
 */
export function isTraitObject(value: unknown): value is MbtTraitObject {
  return (
    typeof value === "object" &&
    value !== null &&
    "self" in value &&
    "method_0" in value
  );
}

/**
 * Extract the underlying value from a trait object
 */
export function unwrapTraitObject<T>(traitObj: MbtTraitObject<T>): T {
  return traitObj.self;
}

// =============================================================================
// JSON Roundtrip Safety
// =============================================================================

/**
 * Types that survive JSON.stringify -> JSON.parse roundtrip:
 *
 * ✅ Safe:
 * - Primitives (number, string, boolean, null)
 * - Arrays
 * - Structs (plain objects with field names)
 * - Enum unit variants ($tag and $name preserved)
 *
 * ⚠️ Partial:
 * - Enum tuple variants ($tag LOST, only _0, _1... preserved)
 * - Option Some (value preserved, but None becomes null)
 *
 * ❌ Unsafe:
 * - Result (Ok/Err distinction LOST)
 * - Enum labeled variants (labels become _0, _1...)
 * - BigInt (JSON.stringify throws)
 * - Map (internal structure, not serializable)
 * - Functions (not serializable)
 * - Trait objects (functions not serializable)
 */

/**
 * Serialize a Result with type information preserved
 */
export function serializeResult<T, E>(
  result: MbtResult<T, E>
): { _type: "Ok" | "Err"; _0: T | E } {
  return {
    _type: isOk(result) ? "Ok" : "Err",
    _0: result._0,
  };
}

/**
 * Deserialize a Result from serialized form (plain object)
 */
export function deserializeResult<T, E>(
  data: { _type: "Ok" | "Err"; _0: T | E }
): { type: "ok"; value: T } | { type: "err"; error: E } {
  if (data._type === "Ok") {
    return { type: "ok", value: data._0 as T };
  }
  return { type: "err", error: data._0 as E };
}

// =============================================================================
// Prototype Restoration for MoonBit Interop
// =============================================================================

/**
 * Factory classes that mimic MoonBit's Result compilation.
 * These classes have constructor.name that includes "Ok" or "Err",
 * making isOk()/isErr() work after JSON deserialization.
 */

// Create named classes using Function constructor to control constructor.name
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const Result$Ok$1$ = new Function(
  "_0",
  "this._0 = _0;"
) as new <T>(value: T) => MbtResultOk<T>;
Object.defineProperty(Result$Ok$1$, "name", { value: "Result$Ok$1$" });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const Result$Err$1$ = new Function(
  "_0",
  "this._0 = _0;"
) as new <E>(error: E) => MbtResultErr<E>;
Object.defineProperty(Result$Err$1$, "name", { value: "Result$Err$1$" });

/**
 * Create a MoonBit-compatible Ok Result that works with isOk()/isErr()
 */
export function createOk<T>(value: T): MbtResultOk<T> {
  return new Result$Ok$1$(value);
}

/**
 * Create a MoonBit-compatible Err Result that works with isOk()/isErr()
 */
export function createErr<E>(error: E): MbtResultErr<E> {
  return new Result$Err$1$(error);
}

/**
 * Restore a Result from serialized form with proper prototype.
 * The returned object will work with isOk()/isErr().
 */
export function restoreResult<T, E>(
  data: { _type: "Ok" | "Err"; _0: T | E } | { _tag: "Ok" | "Err"; _0: T | E }
): MbtResult<T, E> {
  // Support both _type and _tag formats
  const tag = "_type" in data ? data._type : data._tag;
  if (tag === "Ok") {
    return createOk(data._0 as T);
  }
  return createErr(data._0 as E);
}

/**
 * Enum factory classes for tuple variants
 */
function createEnumClass(enumName: string, variantName: string, tag: number) {
  const className = `${enumName}$${variantName}`;
  // Create a class that stores arguments as _0, _1, etc.
  const EnumClass = function (this: Record<string, unknown>, ...args: unknown[]) {
    args.forEach((arg, i) => {
      this[`_${i}`] = arg;
    });
  } as unknown as new (...args: unknown[]) => MbtEnumTuple;

  Object.defineProperty(EnumClass, "name", { value: className });
  // Add $tag to prototype so getEnumTag() works
  Object.defineProperty(EnumClass.prototype, "$tag", { value: tag, writable: false });

  return EnumClass;
}

// Cache for enum classes
const enumClassCache = new Map<string, new (...args: unknown[]) => MbtEnumTuple>();

/**
 * Create a MoonBit-compatible enum tuple variant
 */
export function createEnumTuple(
  enumName: string,
  variantName: string,
  tag: number,
  args: unknown[]
): MbtEnumTuple {
  const cacheKey = `${enumName}$${variantName}`;
  let EnumClass = enumClassCache.get(cacheKey);
  if (!EnumClass) {
    EnumClass = createEnumClass(enumName, variantName, tag);
    enumClassCache.set(cacheKey, EnumClass);
  }
  return new EnumClass(...args);
}

/**
 * Serialized enum format from MoonBit
 */
export interface SerializedEnum {
  _tag: number;
  _name: string;
  _args?: unknown[];
}

/**
 * Restore an enum from serialized form with proper prototype.
 * For unit variants, returns the plain object (already works).
 * For tuple variants, restores the prototype with $tag.
 */
export function restoreEnum(
  data: SerializedEnum,
  enumName = "Enum"
): MbtEnumUnit | MbtEnumTuple {
  if (!data._args || data._args.length === 0) {
    // Unit variant - convert to proper format
    return { $tag: data._tag, $name: data._name };
  }
  // Tuple variant - create with proper prototype
  return createEnumTuple(enumName, data._name, data._tag, data._args);
}
