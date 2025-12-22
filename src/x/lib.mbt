///|
test {
  // Store any value
  let any = @any.of(42)

  // Query type information
  @json.inspect(any.type_name(), content="Int")

  // Retrieve with type checking
  let value : Int = any.to()
  @json.inspect(value, content=42)

  // Type mismatch raises TypeMismatch error
  let value : Result[Bool, @any.TypeMismatch] = try? any.to()
  @json.inspect(value, content={
    "Err": { "TypeMismatch": { "expect": "Bool", "actual": "Int" } },
  })
}
