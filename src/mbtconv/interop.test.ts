/**
 * MoonBit-TypeScript Interop Tests
 *
 * This test file verifies that MoonBit types can be correctly
 * serialized/deserialized and used from TypeScript.
 */

import { expect } from "jsr:@std/expect";
import {
  isOk,
  isErr,
  unwrapOk,
  unwrapErr,
  createOk,
  createErr,
  restoreResult,
  restoreEnum,
  getEnumTag,
  getVariantName,
  type MbtResult,
  type MbtEnumTuple,
} from "./types.ts";

// Import the compiled MoonBit module
// This runs setup_interop_test() which exports functions to globalThis
await import(
  "../../target/js/release/build/mbtconv_interop_test/mbtconv_interop_test.js"
);

// Get the exported functions from globalThis
declare const globalThis: {
  mbt_serialize_ok: (v: number) => { _tag: "Ok" | "Err"; _0: number };
  mbt_serialize_err: (e: string) => { _tag: "Ok" | "Err"; _0: string };
  mbt_deserialize_result: (v: unknown) => { type: string; value?: number; error?: string };
  mbt_create_ok: (v: number) => MbtResult<number, string>;
  mbt_create_err: (e: string) => MbtResult<number, string>;
  mbt_serialize_some: (v: number) => { _some: boolean; _0?: number };
  mbt_serialize_none: () => { _some: boolean };
  mbt_deserialize_option: (v: unknown) => number | undefined;
  mbt_serialize_enum_unit: () => { _tag: number; _name: string };
  mbt_serialize_enum_tuple: (r: number, g: number, b: number) => {
    _tag: number;
    _name: string;
    _args: number[];
  };
  mbt_is_result_ok: (v: unknown) => boolean;
  mbt_is_result_err: (v: unknown) => boolean;
  mbt_unwrap_ok: (v: unknown) => number;
  mbt_unwrap_err: (v: unknown) => string;
};

// =============================================================================
// Result Interop Tests
// =============================================================================

Deno.test("Interop: MoonBit serialize_result -> TypeScript restoreResult", () => {
  // MoonBit serializes Ok(42)
  const serializedOk = globalThis.mbt_serialize_ok(42);
  expect(serializedOk).toEqual({ _tag: "Ok", _0: 42 });

  // TypeScript restores with prototype
  const restoredOk = restoreResult<number, string>(serializedOk);
  expect(isOk(restoredOk)).toBe(true);
  expect(unwrapOk(restoredOk)).toBe(42);

  // MoonBit serializes Err("error")
  const serializedErr = globalThis.mbt_serialize_err("error message");
  expect(serializedErr).toEqual({ _tag: "Err", _0: "error message" });

  // TypeScript restores with prototype
  const restoredErr = restoreResult<number, string>(serializedErr);
  expect(isErr(restoredErr)).toBe(true);
  expect(unwrapErr(restoredErr)).toBe("error message");
});

Deno.test("Interop: TypeScript createOk/createErr -> MoonBit is_result_ok/err", () => {
  // TypeScript creates Result
  const tsOk = createOk(123);
  const tsErr = createErr("ts error");

  // MoonBit's is_result_ok/err should work on TypeScript-created Results
  expect(globalThis.mbt_is_result_ok(tsOk)).toBe(true);
  expect(globalThis.mbt_is_result_err(tsOk)).toBe(false);
  expect(globalThis.mbt_is_result_ok(tsErr)).toBe(false);
  expect(globalThis.mbt_is_result_err(tsErr)).toBe(true);

  // MoonBit's unwrap functions should work
  expect(globalThis.mbt_unwrap_ok(tsOk)).toBe(123);
  expect(globalThis.mbt_unwrap_err(tsErr)).toBe("ts error");
});

Deno.test("Interop: Raw MoonBit Result -> TypeScript isOk/isErr", () => {
  // MoonBit creates raw Result (not serialized)
  const mbtOk = globalThis.mbt_create_ok(999);
  const mbtErr = globalThis.mbt_create_err("mbt error");

  // TypeScript's isOk/isErr should work on MoonBit-created Results
  expect(isOk(mbtOk)).toBe(true);
  expect(isErr(mbtOk)).toBe(false);
  expect(isOk(mbtErr)).toBe(false);
  expect(isErr(mbtErr)).toBe(true);

  // TypeScript's unwrap should work
  expect(unwrapOk(mbtOk)).toBe(999);
  expect(unwrapErr(mbtErr)).toBe("mbt error");
});

Deno.test("Interop: Full JSON roundtrip MoonBit -> JSON -> TypeScript -> JSON -> MoonBit", () => {
  // Step 1: MoonBit serializes
  const mbtSerialized = globalThis.mbt_serialize_ok(42);

  // Step 2: JSON roundtrip
  const json = JSON.stringify(mbtSerialized);
  expect(json).toBe('{"_tag":"Ok","_0":42}');

  // Step 3: TypeScript parses and restores
  const parsed = JSON.parse(json);
  const tsRestored = restoreResult<number, string>(parsed);

  // Step 4: TypeScript can use it
  expect(isOk(tsRestored)).toBe(true);
  expect(unwrapOk(tsRestored)).toBe(42);

  // Step 5: MoonBit can deserialize it back
  const mbtDeserialized = globalThis.mbt_deserialize_result(parsed);
  expect(mbtDeserialized.type).toBe("ok");
  expect(mbtDeserialized.value).toBe(42);
});

// =============================================================================
// Option Interop Tests
// =============================================================================

Deno.test("Interop: MoonBit serialize_option -> TypeScript", () => {
  // MoonBit serializes Some(42)
  const serializedSome = globalThis.mbt_serialize_some(42);
  expect(serializedSome).toEqual({ _some: true, _0: 42 });

  // MoonBit serializes None
  const serializedNone = globalThis.mbt_serialize_none();
  expect(serializedNone).toEqual({ _some: false });
});

Deno.test("Interop: TypeScript -> MoonBit deserialize_option", () => {
  // TypeScript creates serialized format
  const tsSome = { _some: true, _0: 123 };
  const tsNone = { _some: false };

  // MoonBit deserializes
  expect(globalThis.mbt_deserialize_option(tsSome)).toBe(123);
  expect(globalThis.mbt_deserialize_option(tsNone)).toBe(undefined);
});

Deno.test("Interop: Option JSON roundtrip", () => {
  // MoonBit serializes
  const mbtSome = globalThis.mbt_serialize_some(42);

  // JSON roundtrip
  const json = JSON.stringify(mbtSome);
  expect(json).toBe('{"_some":true,"_0":42}');

  // Parse and send back to MoonBit
  const parsed = JSON.parse(json);
  const value = globalThis.mbt_deserialize_option(parsed);
  expect(value).toBe(42);
});

// =============================================================================
// Enum Interop Tests
// =============================================================================

Deno.test("Interop: MoonBit serialize_enum -> TypeScript restoreEnum", () => {
  // MoonBit serializes unit variant
  const serializedUnit = globalThis.mbt_serialize_enum_unit();
  expect(serializedUnit).toEqual({ _tag: 0, _name: "Red" });

  // TypeScript restores
  const restoredUnit = restoreEnum(serializedUnit);
  expect(getEnumTag(restoredUnit)).toBe(0);
  expect(getVariantName(restoredUnit)).toBe("Red");

  // MoonBit serializes tuple variant
  const serializedTuple = globalThis.mbt_serialize_enum_tuple(255, 128, 64);
  expect(serializedTuple).toEqual({ _tag: 3, _name: "Rgb", _args: [255, 128, 64] });

  // TypeScript restores with prototype
  const restoredTuple = restoreEnum(serializedTuple, "Color") as MbtEnumTuple;
  expect(getEnumTag(restoredTuple)).toBe(3);
  expect(getVariantName(restoredTuple)).toBe("Rgb");
  expect(restoredTuple._0).toBe(255);
  expect(restoredTuple._1).toBe(128);
  expect(restoredTuple._2).toBe(64);
});

Deno.test("Interop: Enum JSON roundtrip", () => {
  // MoonBit serializes
  const mbtEnum = globalThis.mbt_serialize_enum_tuple(100, 200, 50);

  // JSON roundtrip
  const json = JSON.stringify(mbtEnum);
  expect(json).toBe('{"_tag":3,"_name":"Rgb","_args":[100,200,50]}');

  // TypeScript restores
  const parsed = JSON.parse(json);
  const restored = restoreEnum(parsed, "Color") as MbtEnumTuple;

  // Verify
  expect(getEnumTag(restored)).toBe(3);
  expect(restored._0).toBe(100);
  expect(restored._1).toBe(200);
  expect(restored._2).toBe(50);
});
