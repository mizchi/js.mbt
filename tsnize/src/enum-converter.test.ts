import { assertEquals } from "jsr:@std/assert";
import { parse } from "./mod.ts";
import { generateEnumModule } from "./enum-converter.ts";

const WEBSOCKET_ENUM_MBTI = `package "test"

// Types and methods
pub enum WebSocketReadyState {
  Connecting
  Open
  Closing
  Closed
}
`;

Deno.test("generate enum module - unit variants", () => {
  const ast = parse(WEBSOCKET_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "WebSocketReadyState");

  if (!enumDef) {
    throw new Error("Enum not found");
  }

  const module = generateEnumModule(enumDef);
  console.log(module);

  // Check TypeScript types
  assertEquals(module.includes('interface WebSocketReadyState_Connecting'), true);
  assertEquals(module.includes('$tag: "Connecting"'), true);

  // Check constructor object
  assertEquals(module.includes('Connecting: { $tag: "Connecting" }'), true);

  // Check type guards
  assertEquals(module.includes('isConnecting(value: WebSocketReadyState)'), true);

  // Check match function
  assertEquals(module.includes('match<R>(value: WebSocketReadyState'), true);

  // Check converter types
  assertEquals(module.includes('MbtWebSocketReadyStateUnit'), true);

  // Check fromMbt
  assertEquals(module.includes('webSocketReadyStateFromMbt'), true);

  // Check toMbt
  assertEquals(module.includes('webSocketReadyStateToMbt'), true);
});

const RESULT_LIKE_ENUM_MBTI = `package "test"

// Types and methods
pub enum MyResult {
  Ok(String)
  Err(String)
}
`;

Deno.test("generate enum module - tuple variants", () => {
  const ast = parse(RESULT_LIKE_ENUM_MBTI);
  const enumDef = ast.types.find((t) => t.name === "MyResult");

  if (!enumDef) {
    throw new Error("Enum not found");
  }

  const module = generateEnumModule(enumDef);
  console.log(module);

  // Check TypeScript types with payload
  assertEquals(module.includes('interface MyResult_Ok { readonly $tag: "Ok"; readonly $0: unknown; }'), true);

  // Check constructor function for tuple variant
  assertEquals(module.includes('Ok(value: unknown): MyResult_Ok'), true);

  // Check MoonBit tuple type
  assertEquals(module.includes('MbtMyResultTuple'), true);

  // Check fromMbt handles tuple variants
  assertEquals(module.includes('(value as MbtMyResultTuple)._0'), true);
});

// Test actual conversion at runtime
Deno.test("enum converter - runtime conversion", () => {
  // Simulate MoonBit unit variant
  const mbtUnit = { $tag: 0, $name: "Connecting" };

  // This would be the generated code behavior
  const tsValue = { $tag: "Connecting" as const };

  assertEquals(tsValue.$tag, "Connecting");

  // Simulate converting back
  const backToMbt = { $tag: 0, $name: "Connecting" };
  assertEquals(backToMbt.$name, "Connecting");
});
