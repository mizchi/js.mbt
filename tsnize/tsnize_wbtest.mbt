// Whitebox tests for tsnize - test with real mbti files

///|
test "snapshot: enum dts generation" {
  let content =
    #|package "test"
    #|
    #|pub enum Status {
    #|  Pending
    #|  Active
    #|  Done
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect!(dts, content=(
    
    #|// Generated from .mbti file - DO NOT EDIT
    #|
    #|export interface Status_Pending { readonly $tag: "Pending"; }
    #|export interface Status_Active { readonly $tag: "Active"; }
    #|export interface Status_Done { readonly $tag: "Done"; }
    #|export type Status = Status_Pending | Status_Active | Status_Done;
    #|
    #|export const Status = {
    #|  Pending: { $tag: "Pending" } as Status_Pending,
    #|  Active: { $tag: "Active" } as Status_Active,
    #|  Done: { $tag: "Done" } as Status_Done,
    #|
    #|  isPending(value: Status): value is Status_Pending { return value.$tag === "Pending"; },
    #|  isActive(value: Status): value is Status_Active { return value.$tag === "Active"; },
    #|  isDone(value: Status): value is Status_Done { return value.$tag === "Done"; },
    #|
    #|  match<R>(value: Status, handlers: {
    #|    Pending: () => R;
    #|    Active: () => R;
    #|    Done: () => R;
    #|  }): R {
    #|    switch (value.$tag) {
    #|      case "Pending": return handlers.Pending();
    #|      case "Active": return handlers.Active();
    #|      case "Done": return handlers.Done();
    #|    }
    #|  },
    #|} as const;
  ))
}

///|
test "snapshot: struct dts generation" {
  let content =
    #|package "test"
    #|
    #|pub struct User {
    #|  name : String
    #|  age : Int
    #|  mut email : String
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect!(dts, content=(
    
    #|// Generated from .mbti file - DO NOT EDIT
    #|
    #|export interface User {
    #|  readonly name: string;
    #|  readonly age: number;
    #|  email: string;
    #|}
  ))
}

///|
test "snapshot: tuple variant enum dts generation" {
  let content =
    #|package "test"
    #|
    #|pub enum MyResult {
    #|  Ok(String)
    #|  Err(String)
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect!(dts, content=(
    
    #|// Generated from .mbti file - DO NOT EDIT
    #|
    #|export interface MyResult_Ok { readonly $tag: "Ok"; readonly $0: string; }
    #|export interface MyResult_Err { readonly $tag: "Err"; readonly $0: string; }
    #|export type MyResult = MyResult_Ok | MyResult_Err;
    #|
    #|export const MyResult = {
    #|  Ok($0: string): MyResult_Ok { return { $tag: "Ok", $0 }; },
    #|  Err($0: string): MyResult_Err { return { $tag: "Err", $0 }; },
    #|
    #|  isOk(value: MyResult): value is MyResult_Ok { return value.$tag === "Ok"; },
    #|  isErr(value: MyResult): value is MyResult_Err { return value.$tag === "Err"; },
    #|
    #|  match<R>(value: MyResult, handlers: {
    #|    Ok: ($0: string) => R;
    #|    Err: ($0: string) => R;
    #|  }): R {
    #|    switch (value.$tag) {
    #|      case "Ok": return handlers.Ok((value as MyResult_Ok).$0);
    #|      case "Err": return handlers.Err((value as MyResult_Err).$0);
    #|    }
    #|  },
    #|} as const;
  ))
}

///|
test "snapshot: mixed enum dts generation" {
  let content =
    #|package "test"
    #|
    #|pub enum LoadState {
    #|  Idle
    #|  Loading
    #|  Success(String)
    #|  Error(String)
    #|}
    #|
  let mbti = parse_mbti(content, "test.mbti")
  let dts = generate_dts(mbti)
  inspect!(dts, content=(
    
    #|// Generated from .mbti file - DO NOT EDIT
    #|
    #|export interface LoadState_Idle { readonly $tag: "Idle"; }
    #|export interface LoadState_Loading { readonly $tag: "Loading"; }
    #|export interface LoadState_Success { readonly $tag: "Success"; readonly $0: string; }
    #|export interface LoadState_Error { readonly $tag: "Error"; readonly $0: string; }
    #|export type LoadState = LoadState_Idle | LoadState_Loading | LoadState_Success | LoadState_Error;
    #|
    #|export const LoadState = {
    #|  Idle: { $tag: "Idle" } as LoadState_Idle,
    #|  Loading: { $tag: "Loading" } as LoadState_Loading,
    #|  Success($0: string): LoadState_Success { return { $tag: "Success", $0 }; },
    #|  Error($0: string): LoadState_Error { return { $tag: "Error", $0 }; },
    #|
    #|  isIdle(value: LoadState): value is LoadState_Idle { return value.$tag === "Idle"; },
    #|  isLoading(value: LoadState): value is LoadState_Loading { return value.$tag === "Loading"; },
    #|  isSuccess(value: LoadState): value is LoadState_Success { return value.$tag === "Success"; },
    #|  isError(value: LoadState): value is LoadState_Error { return value.$tag === "Error"; },
    #|
    #|  match<R>(value: LoadState, handlers: {
    #|    Idle: () => R;
    #|    Loading: () => R;
    #|    Success: ($0: string) => R;
    #|    Error: ($0: string) => R;
    #|  }): R {
    #|    switch (value.$tag) {
    #|      case "Idle": return handlers.Idle();
    #|      case "Loading": return handlers.Loading();
    #|      case "Success": return handlers.Success((value as LoadState_Success).$0);
    #|      case "Error": return handlers.Error((value as LoadState_Error).$0);
    #|    }
    #|  },
    #|} as const;
  ))
}

///|
test "snapshot: functions and types" {
  let content =
    #|package "mizchi/js/core"
    #|
    #|fn[T] any(T) -> Any
    #|
    #|fn global_this() -> Any
    #|
    #|fn sleep(Double) -> Promise[Unit]
    #|
    #|pub(all) struct Any {
    #|}
    #|
    #|pub struct Promise[T] {
    #|}
    #|
  let mbti = parse_mbti(content, "core.mbti")
  let dts = generate_dts(mbti)
  inspect!(dts, content=(
    
    #|// Generated from .mbti file - DO NOT EDIT
    #|
    #|export function any<T>(arg0: T): Any;
    #|
    #|export function globalThis(): Any;
    #|
    #|export function sleep(arg0: number): Promise<void>;
    #|
    #|export interface Any {
    #|}
    #|
    #|export interface Promise<T> {
    #|}
  ))
}

///|
test "to_camel_case" {
  inspect!(to_camel_case("hello_world"), content="helloWorld")
  inspect!(to_camel_case("get_user_name"), content="getUserName")
  inspect!(to_camel_case("simple"), content="simple")
}

///|
test "char_to_upper" {
  assert_eq!(char_to_upper('a'), 'A')
  assert_eq!(char_to_upper('z'), 'Z')
  assert_eq!(char_to_upper('A'), 'A')
  assert_eq!(char_to_upper('1'), '1')
}
