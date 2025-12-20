/**
 * Runtime tests for enum converter
 *
 * Tests that generated conversion code actually works with MoonBit's JS representation
 */

import { assertEquals, assertThrows } from "jsr:@std/assert";
import { parse } from "./mod.ts";
import { generateEnumModule } from "./enum-converter.ts";

// =============================================================================
// Test: Unit variant enum (WebSocketReadyState)
// =============================================================================

const UNIT_ENUM_MBTI = `package "test"
pub enum WebSocketReadyState {
  Connecting
  Open
  Closing
  Closed
}
`;

Deno.test("runtime: unit variant - fromMbt converts correctly", async () => {
  const ast = parse(UNIT_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState")!;
  const code = generateEnumModule(enumDef);

  // Create a module from the generated code
  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Simulate MoonBit unit variant representation
    const mbtConnecting = { $tag: 0, $name: "Connecting" };
    const mbtOpen = { $tag: 1, $name: "Open" };
    const mbtClosing = { $tag: 2, $name: "Closing" };
    const mbtClosed = { $tag: 3, $name: "Closed" };

    // Convert from MoonBit to TypeScript
    const tsConnecting = mod.webSocketReadyStateFromMbt(mbtConnecting);
    const tsOpen = mod.webSocketReadyStateFromMbt(mbtOpen);
    const tsClosing = mod.webSocketReadyStateFromMbt(mbtClosing);
    const tsClosed = mod.webSocketReadyStateFromMbt(mbtClosed);

    // Verify TypeScript representation
    assertEquals(tsConnecting.$tag, "Connecting");
    assertEquals(tsOpen.$tag, "Open");
    assertEquals(tsClosing.$tag, "Closing");
    assertEquals(tsClosed.$tag, "Closed");

    // Verify type guards work
    assertEquals(mod.WebSocketReadyState.isConnecting(tsConnecting), true);
    assertEquals(mod.WebSocketReadyState.isOpen(tsOpen), true);
    assertEquals(mod.WebSocketReadyState.isClosing(tsClosing), true);
    assertEquals(mod.WebSocketReadyState.isClosed(tsClosed), true);

    // Verify cross-checks
    assertEquals(mod.WebSocketReadyState.isConnecting(tsOpen), false);
    assertEquals(mod.WebSocketReadyState.isOpen(tsConnecting), false);
  } finally {
    URL.revokeObjectURL(url);
  }
});

Deno.test("runtime: unit variant - toMbt converts correctly", async () => {
  const ast = parse(UNIT_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Create TypeScript values
    const tsConnecting = mod.WebSocketReadyState.Connecting;
    const tsOpen = mod.WebSocketReadyState.Open;

    // Convert to MoonBit representation
    const mbtConnecting = mod.webSocketReadyStateToMbt(tsConnecting);
    const mbtOpen = mod.webSocketReadyStateToMbt(tsOpen);

    // Verify MoonBit representation
    assertEquals(mbtConnecting.$tag, 0);
    assertEquals(mbtConnecting.$name, "Connecting");
    assertEquals(mbtOpen.$tag, 1);
    assertEquals(mbtOpen.$name, "Open");
  } finally {
    URL.revokeObjectURL(url);
  }
});

Deno.test("runtime: unit variant - roundtrip conversion", async () => {
  const ast = parse(UNIT_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Start with MoonBit value
    const originalMbt = { $tag: 2, $name: "Closing" };

    // MoonBit -> TypeScript -> MoonBit
    const ts = mod.webSocketReadyStateFromMbt(originalMbt);
    const backToMbt = mod.webSocketReadyStateToMbt(ts);

    assertEquals(backToMbt.$tag, originalMbt.$tag);
    assertEquals(backToMbt.$name, originalMbt.$name);

    // Start with TypeScript value
    const originalTs = mod.WebSocketReadyState.Open;

    // TypeScript -> MoonBit -> TypeScript
    const mbt = mod.webSocketReadyStateToMbt(originalTs);
    const backToTs = mod.webSocketReadyStateFromMbt(mbt);

    assertEquals(backToTs.$tag, originalTs.$tag);
  } finally {
    URL.revokeObjectURL(url);
  }
});

Deno.test("runtime: unit variant - match function works", async () => {
  const ast = parse(UNIT_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    const result = mod.WebSocketReadyState.match(
      mod.WebSocketReadyState.Open,
      {
        Connecting: () => "connecting",
        Open: () => "open",
        Closing: () => "closing",
        Closed: () => "closed",
      }
    );

    assertEquals(result, "open");
  } finally {
    URL.revokeObjectURL(url);
  }
});

// =============================================================================
// Test: Tuple variant enum (Result-like)
// =============================================================================

const TUPLE_ENUM_MBTI = `package "test"
pub enum MyResult {
  Ok(String)
  Err(String)
}
`;

Deno.test("runtime: tuple variant - fromMbt converts correctly", async () => {
  const ast = parse(TUPLE_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "MyResult")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Simulate MoonBit tuple variant representation
    // MoonBit uses constructor.name = "EnumName$VariantName"
    class MyResult$Ok {
      static $tag = 0;
      _0: string;
      constructor(value: string) {
        this._0 = value;
      }
    }
    Object.defineProperty(MyResult$Ok.prototype, "$tag", { value: 0 });

    class MyResult$Err {
      static $tag = 1;
      _0: string;
      constructor(value: string) {
        this._0 = value;
      }
    }
    Object.defineProperty(MyResult$Err.prototype, "$tag", { value: 1 });

    const mbtOk = new MyResult$Ok("success");
    const mbtErr = new MyResult$Err("failure");

    // Convert from MoonBit to TypeScript
    const tsOk = mod.myResultFromMbt(mbtOk);
    const tsErr = mod.myResultFromMbt(mbtErr);

    // Verify TypeScript representation
    assertEquals(tsOk.$tag, "Ok");
    assertEquals(tsOk.$0, "success");
    assertEquals(tsErr.$tag, "Err");
    assertEquals(tsErr.$0, "failure");

    // Verify type guards
    assertEquals(mod.MyResult.isOk(tsOk), true);
    assertEquals(mod.MyResult.isErr(tsErr), true);
    assertEquals(mod.MyResult.isOk(tsErr), false);
    assertEquals(mod.MyResult.isErr(tsOk), false);
  } finally {
    URL.revokeObjectURL(url);
  }
});

Deno.test("runtime: tuple variant - toMbt converts correctly", async () => {
  const ast = parse(TUPLE_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "MyResult")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Create TypeScript values
    const tsOk = mod.MyResult.Ok("hello");
    const tsErr = mod.MyResult.Err("world");

    // Convert to MoonBit representation
    const mbtOk = mod.myResultToMbt(tsOk);
    const mbtErr = mod.myResultToMbt(tsErr);

    // Verify MoonBit representation (plain object with _0)
    assertEquals(mbtOk._0, "hello");
    assertEquals(mbtErr._0, "world");
  } finally {
    URL.revokeObjectURL(url);
  }
});

Deno.test("runtime: tuple variant - match function works", async () => {
  const ast = parse(TUPLE_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "MyResult")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    const okResult = mod.MyResult.match(mod.MyResult.Ok("success"), {
      Ok: (v: string) => `Got: ${v}`,
      Err: (e: string) => `Error: ${e}`,
    });

    const errResult = mod.MyResult.match(mod.MyResult.Err("failed"), {
      Ok: (v: string) => `Got: ${v}`,
      Err: (e: string) => `Error: ${e}`,
    });

    assertEquals(okResult, "Got: success");
    assertEquals(errResult, "Error: failed");
  } finally {
    URL.revokeObjectURL(url);
  }
});

// =============================================================================
// Test: Error cases
// =============================================================================

Deno.test("runtime: fromMbt throws on invalid input", async () => {
  const ast = parse(UNIT_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState")!;
  const code = generateEnumModule(enumDef);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Test with null
    assertThrows(
      () => mod.webSocketReadyStateFromMbt(null),
      Error,
      "Expected MoonBit enum object"
    );

    // Test with unknown variant
    assertThrows(
      () => mod.webSocketReadyStateFromMbt({ $tag: 99, $name: "Unknown" }),
      Error,
      "Unknown variant: Unknown"
    );
  } finally {
    URL.revokeObjectURL(url);
  }
});

// =============================================================================
// Test: Mixed enum (unit + tuple variants)
// =============================================================================

const MIXED_ENUM_MBTI = `package "test"
pub enum LoadState {
  Idle
  Loading
  Success(String)
  Error(String)
}
`;

Deno.test("runtime: mixed enum - both variant types work", async () => {
  const ast = parse(MIXED_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "LoadState")!;
  const code = generateEnumModule(enumDef);

  console.log("Generated code for mixed enum:");
  console.log(code);

  const blob = new Blob([code], { type: "application/typescript" });
  const url = URL.createObjectURL(blob);

  try {
    const mod = await import(url);

    // Test unit variants
    const mbtIdle = { $tag: 0, $name: "Idle" };
    const tsIdle = mod.loadStateFromMbt(mbtIdle);
    assertEquals(tsIdle.$tag, "Idle");

    // Test TypeScript constructors
    const tsLoading = mod.LoadState.Loading;
    const tsSuccess = mod.LoadState.Success("data loaded");
    const tsError = mod.LoadState.Error("network error");

    assertEquals(tsLoading.$tag, "Loading");
    assertEquals(tsSuccess.$tag, "Success");
    assertEquals(tsSuccess.$0, "data loaded");
    assertEquals(tsError.$tag, "Error");
    assertEquals(tsError.$0, "network error");

    // Test match with all variants
    const matchResult = mod.LoadState.match(tsSuccess, {
      Idle: () => "idle",
      Loading: () => "loading",
      Success: (data: string) => `success: ${data}`,
      Error: (err: string) => `error: ${err}`,
    });

    assertEquals(matchResult, "success: data loaded");
  } finally {
    URL.revokeObjectURL(url);
  }
});
