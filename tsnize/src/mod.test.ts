import { assertEquals } from "jsr:@std/assert";
import { generate, parse } from "./mod.ts";

const WEBSOCKET_MBTI = `// Generated using \`moon info\`, DON'T EDIT IT
package "mizchi/js/web/websocket"

import(
  "mizchi/js/core"
)

// Values
pub fn get_close_code(@core.Any) -> Int

// Errors

// Types and methods
pub(all) struct WebSocket {
  url : String
  readyState : Int
  mut binaryType : String
}
pub fn WebSocket::new(String, protocols? : Array[String]) -> Self
pub fn WebSocket::close(Self, code? : Int, reason? : String) -> Unit
pub fn WebSocket::send_string(Self, String) -> Unit

pub enum WebSocketReadyState {
  Connecting
  Open
  Closing
  Closed
}
pub fn WebSocketReadyState::to_int(Self) -> Int
pub impl Eq for WebSocketReadyState

// Type aliases

// Traits

`;

Deno.test("parse mbti - package", () => {
  const ast = parse(WEBSOCKET_MBTI);
  assertEquals(ast.package, "mizchi/js/web/websocket");
});

Deno.test("parse mbti - imports", () => {
  const ast = parse(WEBSOCKET_MBTI);
  assertEquals(ast.imports, ["mizchi/js/core"]);
});

Deno.test("parse mbti - struct", () => {
  const ast = parse(WEBSOCKET_MBTI);
  const wsType = ast.types.find((t) => t.name === "WebSocket");
  assertEquals(wsType?.kind, "struct");
  assertEquals(wsType?.fields?.length, 3);
  assertEquals(wsType?.fields?.[0].name, "url");
  assertEquals(wsType?.fields?.[0].type.name, "String");
  assertEquals(wsType?.fields?.[2].isMutable, true);
});

Deno.test("parse mbti - enum", () => {
  const ast = parse(WEBSOCKET_MBTI);
  const enumType = ast.types.find((t) => t.name === "WebSocketReadyState");
  assertEquals(enumType?.kind, "enum");
  assertEquals(enumType?.variants?.length, 4);
  assertEquals(enumType?.variants?.map((v) => v.name), [
    "Connecting",
    "Open",
    "Closing",
    "Closed",
  ]);
});

Deno.test("parse mbti - methods", () => {
  const ast = parse(WEBSOCKET_MBTI);
  const wsType = ast.types.find((t) => t.name === "WebSocket");
  assertEquals(wsType?.methods.length, 3);
  const newMethod = wsType?.methods.find((m) => m.name === "new");
  assertEquals(newMethod?.typeName, "WebSocket");
});

Deno.test("parse mbti - values", () => {
  const ast = parse(WEBSOCKET_MBTI);
  assertEquals(ast.values.length, 1);
  assertEquals(ast.values[0].name, "get_close_code");
});

Deno.test("generate dts - basic", () => {
  const dts = generate(WEBSOCKET_MBTI);
  console.log(dts);
  // Check that it contains expected elements
  assertEquals(dts.includes("export interface WebSocket"), true);
  assertEquals(dts.includes("readonly url: string"), true);
  assertEquals(dts.includes("binaryType: string"), true); // mutable, no readonly
  assertEquals(dts.includes("WebSocketReadyState_Connecting"), true);
  assertEquals(dts.includes('$tag: "Connecting"'), true);
});

// Test with a more complex mbti
const CORE_MBTI = `// Generated using \`moon info\`, DON'T EDIT IT
package "mizchi/js/core"

// Values
pub fn[T] any(T) -> Any
pub fn[A] from_async(async () -> A) -> Promise[A]
pub fn[A, B] identity(A) -> B
pub async fn sleep(Int) -> Unit noraise

// Errors
pub suberror JsError String

// Types and methods
#external
pub type Any
pub fn Any::cast[T](Self) -> T
pub fn Any::to_string(Self) -> String
pub impl Show for Any

#external
pub type Promise[T]
pub async fn[T] Promise::wait(Self[T]) -> T
pub fn[A, B] Promise::then(Self[A], (A) -> Self[B] raise) -> Self[B]

pub(all) struct PromiseResolvers[T] {
  promise : Promise[T]
  resolve : (T) -> Unit
  reject : (Error) -> Unit
}

// Type aliases

// Traits

`;

Deno.test("parse core mbti - generics", () => {
  const ast = parse(CORE_MBTI);

  // Check generic function
  const anyFn = ast.values.find((f) => f.name === "any");
  assertEquals(anyFn?.typeParams, ["T"]);

  // Check Promise type
  const promiseType = ast.types.find((t) => t.name === "Promise");
  assertEquals(promiseType?.typeParams, ["T"]);
});

Deno.test("parse core mbti - async functions", () => {
  const ast = parse(CORE_MBTI);
  const sleepFn = ast.values.find((f) => f.name === "sleep");
  assertEquals(sleepFn?.isAsync, true);
});

Deno.test("parse core mbti - errors", () => {
  const ast = parse(CORE_MBTI);
  assertEquals(ast.errors.length, 1);
  assertEquals(ast.errors[0].name, "JsError");
});

Deno.test("generate core dts", () => {
  const dts = generate(CORE_MBTI);
  console.log(dts);
  assertEquals(dts.includes("export function any<T>"), true);
  assertEquals(dts.includes("export interface Promise<T>"), true);
  assertEquals(dts.includes("Promise<void>"), true); // async sleep returns Promise<void>
});
