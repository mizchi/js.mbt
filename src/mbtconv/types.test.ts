import { expect } from "jsr:@std/expect";
import {
  isOk,
  isErr,
  unwrapOk,
  unwrapErr,
  matchResult,
  toResultObject,
  isSome,
  isNone,
  unwrapOr,
  isUnitVariant,
  getVariantName,
  getEnumTag,
  getTupleArgs,
  isMbtMap,
  isTraitObject,
  serializeResult,
  deserializeResult,
  createOk,
  createErr,
  restoreResult,
  createEnumTuple,
  restoreEnum,
  type MbtResult,
  type MbtOption,
  type MbtEnumUnit,
  type MbtEnumTuple,
} from "./types.ts";

// =============================================================================
// Result Tests
// =============================================================================

Deno.test("Result: isOk/isErr", () => {
  // Simulate MoonBit Result by creating objects with proper constructor names
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }
  class Result$Err$1$ {
    constructor(public _0: string) {}
  }

  const ok = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;
  const err = new Result$Err$1$("error") as unknown as MbtResult<
    number,
    string
  >;

  expect(isOk(ok)).toBe(true);
  expect(isErr(ok)).toBe(false);
  expect(isOk(err)).toBe(false);
  expect(isErr(err)).toBe(true);
});

Deno.test("Result: unwrapOk/unwrapErr", () => {
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }
  class Result$Err$1$ {
    constructor(public _0: string) {}
  }

  const ok = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;
  const err = new Result$Err$1$("error") as unknown as MbtResult<
    number,
    string
  >;

  expect(unwrapOk(ok)).toBe(42);
  expect(unwrapErr(err)).toBe("error");
  expect(() => unwrapOk(err)).toThrow();
  expect(() => unwrapErr(ok)).toThrow();
});

Deno.test("Result: matchResult", () => {
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }
  class Result$Err$1$ {
    constructor(public _0: string) {}
  }

  const ok = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;
  const err = new Result$Err$1$("error") as unknown as MbtResult<
    number,
    string
  >;

  const okResult = matchResult(ok, {
    ok: (v) => `value: ${v}`,
    err: (e) => `error: ${e}`,
  });
  expect(okResult).toBe("value: 42");

  const errResult = matchResult(err, {
    ok: (v) => `value: ${v}`,
    err: (e) => `error: ${e}`,
  });
  expect(errResult).toBe("error: error");
});

Deno.test("Result: toResultObject", () => {
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }
  class Result$Err$1$ {
    constructor(public _0: string) {}
  }

  const ok = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;
  const err = new Result$Err$1$("error") as unknown as MbtResult<
    number,
    string
  >;

  expect(toResultObject(ok)).toEqual({ type: "ok", value: 42 });
  expect(toResultObject(err)).toEqual({ type: "err", error: "error" });
});

Deno.test("Result: serializeResult/deserializeResult", () => {
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }

  const ok = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;

  const serialized = serializeResult(ok);
  expect(serialized).toEqual({ _type: "Ok", _0: 42 });

  // Can be safely JSON stringified
  const json = JSON.stringify(serialized);
  const parsed = JSON.parse(json);

  const deserialized = deserializeResult<number, string>(parsed);
  expect(deserialized).toEqual({ type: "ok", value: 42 });
});

// =============================================================================
// Option Tests
// =============================================================================

Deno.test("Option: isSome/isNone", () => {
  const some: MbtOption<number> = 42;
  const none: MbtOption<number> = undefined;

  expect(isSome(some)).toBe(true);
  expect(isNone(some)).toBe(false);
  expect(isSome(none)).toBe(false);
  expect(isNone(none)).toBe(true);
});

Deno.test("Option: unwrapOr", () => {
  const some: MbtOption<number> = 42;
  const none: MbtOption<number> = undefined;

  expect(unwrapOr(some, 0)).toBe(42);
  expect(unwrapOr(none, 0)).toBe(0);
});

// =============================================================================
// Enum Tests
// =============================================================================

Deno.test("Enum: isUnitVariant", () => {
  const unitVariant: MbtEnumUnit = { $tag: 0, $name: "Red" };
  const tupleVariant: MbtEnumTuple = { _0: 255, _1: 0, _2: 0 };

  expect(isUnitVariant(unitVariant)).toBe(true);
  expect(isUnitVariant(tupleVariant)).toBe(false);
});

Deno.test("Enum: getVariantName for unit variant", () => {
  const unitVariant: MbtEnumUnit = { $tag: 0, $name: "Red" };
  expect(getVariantName(unitVariant)).toBe("Red");
});

Deno.test("Enum: getVariantName for tuple variant", () => {
  class Color$Rgb {
    constructor(
      public _0: number,
      public _1: number,
      public _2: number
    ) {}
  }
  const tupleVariant = new Color$Rgb(255, 0, 0);
  expect(getVariantName(tupleVariant)).toBe("Rgb");
});

Deno.test("Enum: getEnumTag", () => {
  const unitVariant = { $tag: 0, $name: "Red" };

  class Color$Rgb {
    $tag = 3;
    constructor(
      public _0: number,
      public _1: number,
      public _2: number
    ) {}
  }
  const tupleVariant = new Color$Rgb(255, 0, 0);

  expect(getEnumTag(unitVariant)).toBe(0);
  expect(getEnumTag(tupleVariant)).toBe(3);
});

Deno.test("Enum: getTupleArgs", () => {
  const tupleVariant: MbtEnumTuple = { _0: 255, _1: 128, _2: 64 };
  expect(getTupleArgs(tupleVariant)).toEqual([255, 128, 64]);
});

// =============================================================================
// Map Tests
// =============================================================================

Deno.test("Map: isMbtMap", () => {
  const mbtMap = {
    entries: [],
    size: 0,
    capacity: 8,
    capacity_mask: 7,
    grow_at: 6,
    head: null,
    tail: null,
  };
  const plainObject = { a: 1, b: 2 };

  expect(isMbtMap(mbtMap)).toBe(true);
  expect(isMbtMap(plainObject)).toBe(false);
});

// =============================================================================
// Trait Object Tests
// =============================================================================

Deno.test("TraitObject: isTraitObject", () => {
  const traitObj = {
    self: "hello",
    method_0: () => {},
  };
  const plainObject = { value: 42 };

  expect(isTraitObject(traitObj)).toBe(true);
  expect(isTraitObject(plainObject)).toBe(false);
});

// =============================================================================
// Safe Serialization Tests
// =============================================================================

/**
 * Safe serialization format for MoonBit types that preserves type information
 * through JSON roundtrip.
 */

interface SafeResult<T, E> {
  _tag: "Ok" | "Err";
  _0: T | E;
}

interface SafeOption<T> {
  _some: boolean;
  _0?: T;
}

interface SafeEnum {
  _tag: number;
  _name: string;
  _args?: unknown[];
}

// Helper functions for safe serialization
function serializeSafeResult<T, E>(
  result: MbtResult<T, E>
): SafeResult<T, E> {
  return {
    _tag: isOk(result) ? "Ok" : "Err",
    _0: result._0,
  };
}

function deserializeSafeResult<T, E>(
  data: SafeResult<T, E>
): { ok: true; value: T } | { ok: false; error: E } {
  if (data._tag === "Ok") {
    return { ok: true, value: data._0 as T };
  }
  return { ok: false, error: data._0 as E };
}

function serializeSafeOption<T>(option: MbtOption<T>): SafeOption<T> {
  if (isSome(option)) {
    return { _some: true, _0: option };
  }
  return { _some: false };
}

function deserializeSafeOption<T>(data: SafeOption<T>): MbtOption<T> {
  if (data._some) {
    return data._0;
  }
  return undefined;
}

Deno.test("SafeSerialization: Result Ok roundtrip", () => {
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }

  const original = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;
  const serialized = serializeSafeResult(original);

  expect(serialized).toEqual({ _tag: "Ok", _0: 42 });

  // JSON roundtrip
  const json = JSON.stringify(serialized);
  expect(json).toBe('{"_tag":"Ok","_0":42}');

  const parsed = JSON.parse(json) as SafeResult<number, string>;
  const restored = deserializeSafeResult(parsed);

  expect(restored).toEqual({ ok: true, value: 42 });
});

Deno.test("SafeSerialization: Result Err roundtrip", () => {
  class Result$Err$1$ {
    constructor(public _0: string) {}
  }

  const original = new Result$Err$1$(
    "error message"
  ) as unknown as MbtResult<number, string>;
  const serialized = serializeSafeResult(original);

  expect(serialized).toEqual({ _tag: "Err", _0: "error message" });

  // JSON roundtrip
  const json = JSON.stringify(serialized);
  expect(json).toBe('{"_tag":"Err","_0":"error message"}');

  const parsed = JSON.parse(json) as SafeResult<number, string>;
  const restored = deserializeSafeResult(parsed);

  expect(restored).toEqual({ ok: false, error: "error message" });
});

Deno.test("SafeSerialization: Option Some roundtrip", () => {
  const original: MbtOption<number> = 42;
  const serialized = serializeSafeOption(original);

  expect(serialized).toEqual({ _some: true, _0: 42 });

  // JSON roundtrip
  const json = JSON.stringify(serialized);
  expect(json).toBe('{"_some":true,"_0":42}');

  const parsed = JSON.parse(json) as SafeOption<number>;
  const restored = deserializeSafeOption(parsed);

  expect(restored).toBe(42);
});

Deno.test("SafeSerialization: Option None roundtrip", () => {
  const original: MbtOption<number> = undefined;
  const serialized = serializeSafeOption(original);

  expect(serialized).toEqual({ _some: false });

  // JSON roundtrip
  const json = JSON.stringify(serialized);
  expect(json).toBe('{"_some":false}');

  const parsed = JSON.parse(json) as SafeOption<number>;
  const restored = deserializeSafeOption(parsed);

  expect(restored).toBe(undefined);
});

Deno.test("SafeSerialization: Complex nested structure", () => {
  interface UserData {
    id: number;
    name: string;
    tags: string[];
  }

  interface Metadata {
    version: string;
    timestamp: number;
  }

  interface ApiResponse {
    success: boolean;
    data: SafeResult<UserData, string>;
    metadata: SafeOption<Metadata>;
  }

  const response: ApiResponse = {
    success: true,
    data: {
      _tag: "Ok",
      _0: { id: 123, name: "Alice", tags: ["admin", "user"] },
    },
    metadata: {
      _some: true,
      _0: { version: "1.0.0", timestamp: 1703001234 },
    },
  };

  // JSON roundtrip
  const json = JSON.stringify(response);
  const parsed = JSON.parse(json) as ApiResponse;

  expect(parsed.success).toBe(true);
  expect(parsed.data._tag).toBe("Ok");
  expect(parsed.data._0).toEqual({
    id: 123,
    name: "Alice",
    tags: ["admin", "user"],
  });
  expect(parsed.metadata._some).toBe(true);
  expect(parsed.metadata._0).toEqual({
    version: "1.0.0",
    timestamp: 1703001234,
  });
});

Deno.test("SafeSerialization: Enum with tag preserved", () => {
  // Unit variant
  const red: SafeEnum = { _tag: 0, _name: "Red" };
  const redJson = JSON.stringify(red);
  expect(redJson).toBe('{"_tag":0,"_name":"Red"}');

  const parsedRed = JSON.parse(redJson) as SafeEnum;
  expect(parsedRed._tag).toBe(0);
  expect(parsedRed._name).toBe("Red");

  // Tuple variant with args
  const rgb: SafeEnum = { _tag: 3, _name: "Rgb", _args: [255, 128, 64] };
  const rgbJson = JSON.stringify(rgb);
  expect(rgbJson).toBe('{"_tag":3,"_name":"Rgb","_args":[255,128,64]}');

  const parsedRgb = JSON.parse(rgbJson) as SafeEnum;
  expect(parsedRgb._tag).toBe(3);
  expect(parsedRgb._name).toBe("Rgb");
  expect(parsedRgb._args).toEqual([255, 128, 64]);
});

Deno.test("SafeSerialization: Interop format compatibility", () => {
  // This test verifies that the TypeScript format matches MoonBit's serialize_* functions
  // MoonBit format: { "_tag": "Ok", "_0": value }

  const mbtResultOk = '{"_tag":"Ok","_0":42}';
  const parsed = JSON.parse(mbtResultOk) as SafeResult<number, string>;
  const result = deserializeSafeResult(parsed);
  expect(result).toEqual({ ok: true, value: 42 });

  const mbtResultErr = '{"_tag":"Err","_0":"error"}';
  const parsedErr = JSON.parse(mbtResultErr) as SafeResult<number, string>;
  const resultErr = deserializeSafeResult(parsedErr);
  expect(resultErr).toEqual({ ok: false, error: "error" });

  // MoonBit Option format: { "_some": bool, "_0"?: value }
  const mbtOptionSome = '{"_some":true,"_0":42}';
  const parsedSome = JSON.parse(mbtOptionSome) as SafeOption<number>;
  expect(deserializeSafeOption(parsedSome)).toBe(42);

  const mbtOptionNone = '{"_some":false}';
  const parsedNone = JSON.parse(mbtOptionNone) as SafeOption<number>;
  expect(deserializeSafeOption(parsedNone)).toBe(undefined);
});

// =============================================================================
// Prototype Restoration Tests
// =============================================================================

Deno.test("createOk/createErr: creates objects that work with isOk/isErr", () => {
  const ok = createOk(42);
  const err = createErr("error");

  expect(isOk(ok)).toBe(true);
  expect(isErr(ok)).toBe(false);
  expect(isOk(err)).toBe(false);
  expect(isErr(err)).toBe(true);

  expect(ok._0).toBe(42);
  expect(err._0).toBe("error");
});

Deno.test("createOk/createErr: constructor.name contains Ok/Err", () => {
  const ok = createOk(42);
  const err = createErr("error");

  expect(ok.constructor.name).toContain("Ok");
  expect(err.constructor.name).toContain("Err");
});

Deno.test("restoreResult: JSON roundtrip with prototype restoration", () => {
  // Simulate serialization from MoonBit
  const serializedOk = '{"_type":"Ok","_0":42}';
  const serializedErr = '{"_type":"Err","_0":"error message"}';

  // Parse and restore
  const restoredOk = restoreResult<number, string>(JSON.parse(serializedOk));
  const restoredErr = restoreResult<number, string>(JSON.parse(serializedErr));

  // isOk/isErr should work
  expect(isOk(restoredOk)).toBe(true);
  expect(isErr(restoredOk)).toBe(false);
  expect(isOk(restoredErr)).toBe(false);
  expect(isErr(restoredErr)).toBe(true);

  // Values should be preserved
  expect(restoredOk._0).toBe(42);
  expect(restoredErr._0).toBe("error message");
});

Deno.test("restoreResult: supports _tag format from MoonBit", () => {
  // MoonBit's serialize_result uses _tag
  const serializedOk = '{"_tag":"Ok","_0":42}';
  const restoredOk = restoreResult<number, string>(JSON.parse(serializedOk));

  expect(isOk(restoredOk)).toBe(true);
  expect(restoredOk._0).toBe(42);
});

Deno.test("createEnumTuple: creates tuple variant with proper prototype", () => {
  const rgb = createEnumTuple("Color", "Rgb", 3, [255, 128, 64]);

  expect(rgb._0).toBe(255);
  expect(rgb._1).toBe(128);
  expect(rgb._2).toBe(64);
  expect(getEnumTag(rgb)).toBe(3);
  expect(getVariantName(rgb)).toBe("Rgb");
});

Deno.test("restoreEnum: restores tuple variant from JSON", () => {
  const serialized = '{"_tag":3,"_name":"Rgb","_args":[255,128,64]}';
  const parsed = JSON.parse(serialized);
  const restored = restoreEnum(parsed, "Color") as MbtEnumTuple;

  expect(restored._0).toBe(255);
  expect(restored._1).toBe(128);
  expect(restored._2).toBe(64);
  expect(getEnumTag(restored)).toBe(3);
  expect(getVariantName(restored)).toBe("Rgb");
});

Deno.test("restoreEnum: unit variant preserved as-is", () => {
  const serialized = '{"_tag":0,"_name":"Red"}';
  const parsed = JSON.parse(serialized);
  const restored = restoreEnum(parsed);

  expect(isUnitVariant(restored)).toBe(true);
  expect(getEnumTag(restored)).toBe(0);
  expect(getVariantName(restored)).toBe("Red");
});

Deno.test("Full roundtrip: serialize -> JSON -> restore -> use", () => {
  // Simulate MoonBit Result
  class Result$Ok$1$ {
    constructor(public _0: number) {}
  }
  const original = new Result$Ok$1$(42) as unknown as MbtResult<number, string>;

  // Serialize
  const serialized = serializeResult(original);
  expect(serialized).toEqual({ _type: "Ok", _0: 42 });

  // JSON roundtrip
  const json = JSON.stringify(serialized);
  const parsed = JSON.parse(json);

  // Restore with prototype
  const restored = restoreResult<number, string>(parsed);

  // Should work exactly like original
  expect(isOk(restored)).toBe(true);
  expect(unwrapOk(restored)).toBe(42);
});
