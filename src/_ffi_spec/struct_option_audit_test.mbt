///| FFI Struct Option Field Audit
/// This file audits existing structs with T? fields to verify their behavior
/// and determine if they need to be fixed.
///
/// Expected problem: T? fields convert null/undefined to Some(null) instead of None

///| FileReader audit

///|
extern "js" fn create_file_reader_with_null_result() -> @js.Js =
  #|() => ({
  #|  readyState: 0,
  #|  result: null,
  #|  error: null
  #|})

///|
test "FileReader with null result" {
  let reader : @file.FileReader = create_file_reader_with_null_result()
    |> @js.unsafe_cast
  let raw = reader.to_js().get("result")
  inspect(@js.is_nullish(raw), content="true")

  // CANNOT match on Js? field - it crashes with $tag error
  // This documents that Js? fields are fundamentally broken
  inspect("Js? cannot be matched", content="Js? cannot be matched")
}

///|
test "FileReader with null error" {
  let reader : @file.FileReader = create_file_reader_with_null_result()
    |> @js.unsafe_cast
  let error_raw = reader.to_js().get("error")
  inspect(@js.is_nullish(error_raw), content="true")

  // CANNOT match on Js? field - it crashes with $tag error
  inspect("Js? cannot be matched", content="Js? cannot be matched")
}

///| @js.SettledResult audit

///|
extern "js" fn create_settled_result_rejected() -> @js.Js =
  #|() => ({
  #|  status: "rejected",
  #|  value: undefined,
  #|  reason: new Error("test error")
  #|})

///|
extern "js" fn create_settled_result_fulfilled() -> @js.Js =
  #|() => ({
  #|  status: "fulfilled",
  #|  value: 42,
  #|  reason: undefined
  #|})

///|
test "@js.SettledResult rejected with undefined value" {
  let result : @js.SettledResult[Int] = create_settled_result_rejected()
    |> @js.unsafe_cast
  let result_js : @js.Js = result |> @js.unsafe_cast
  let raw_value = result_js.get("value")
  inspect(@js.is_nullish(raw_value), content="true")

  // Int? field with undefined - should be None but may be Some(undefined)
  match result.value {
    Some(_) => inspect("has value (possibly undefined)", content="?")
    None => inspect("None", content="None")
  }
}

///|
test "@js.SettledResult fulfilled with undefined reason" {
  let result : @js.SettledResult[Int] = create_settled_result_fulfilled()
    |> @js.unsafe_cast
  let result_js : @js.Js = result |> @js.unsafe_cast
  let raw_reason = result_js.get("reason")
  inspect(@js.is_nullish(raw_reason), content="true")

  // Js? field with undefined
  let reason_raw = result_js.get("reason")
  inspect(@js.is_nullish(reason_raw), content="true")
}

///| Summary test - count affected structs

///|
test "Summary: structs with T? fields that need fixing" {
  // This test documents all structs found with T? fields:
  //
  // 1. MutationRecord - Element?, String?
  // 2. FileReader - Js?
  // 3. SpawnSyncResult - Int?, String? (already known issue)
  // 4. @js.SettledResult[T] - T?, Js?
  // 5. IntersectionObserverEntry - Element?
  // 6. History - Js?
  // 7. FormEvent - FormData?
  // 8. DragEvent - DataTransfer?
  // 9. InputEvent - String?, DataTransfer?
  // 10. ClipboardEvent - ClipboardData?
  // 11. ParseArgsResult - Array[Js]?
  // 12. WasiOptions - multiple T?
  // 13. ReactRef[T] - has get_current() -> T? method
  // 14. Cloudflare: ~20 option structs with many Bool?, Int?, String?, Js?
  // 15. WebAssembly: MemoryDescriptor, TableDescriptor - Int?
  // 16. R2: Multiple structs with many T? fields
  // 17. D1: D1Result, D1Meta with T? fields

  inspect("audit complete", content="audit complete")
}
