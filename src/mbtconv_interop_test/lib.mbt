///| MoonBit-TypeScript Interop Test

///|
/// This module exports functions to verify that MoonBit types
/// can be correctly serialized and used from TypeScript.

///|
priv enum Color {
  Red
  Green
  Blue
  Rgb(Int, Int, Int)
} derive(Eq, Show)

///|
/// Export test functions to global scope for TypeScript to call
pub fn setup_interop_test() -> Unit {
  let g = @core.global_this()

  // Result serialization
  g._set(
    "mbt_serialize_ok",
    @core.any(fn(v : Int) -> @core.Any {
      let result : Result[Int, String] = Ok(v)
      @mbtconv.serialize_result(result)
    }),
  )
  g._set(
    "mbt_serialize_err",
    @core.any(fn(e : String) -> @core.Any {
      let result : Result[Int, String] = Err(e)
      @mbtconv.serialize_result(result)
    }),
  )

  // Result deserialization
  g._set(
    "mbt_deserialize_result",
    @core.any(fn(v : @core.Any) -> @core.Any {
      let result : Result[Int, String] = @mbtconv.deserialize_result(v)
      // Return as object with type info
      let obj = @core.new_object()
      match result {
        Ok(val) => {
          obj["type"] = @core.any("ok")
          obj["value"] = @core.any(val)
        }
        Err(err) => {
          obj["type"] = @core.any("err")
          obj["error"] = @core.any(err)
        }
      }
      obj
    }),
  )

  // Raw Result (not serialized) for isOk/isErr test
  g._set(
    "mbt_create_ok",
    @core.any(fn(v : Int) -> @core.Any {
      let result : Result[Int, String] = Ok(v)
      @core.any(result)
    }),
  )
  g._set(
    "mbt_create_err",
    @core.any(fn(e : String) -> @core.Any {
      let result : Result[Int, String] = Err(e)
      @core.any(result)
    }),
  )

  // Option serialization
  g._set(
    "mbt_serialize_some",
    @core.any(fn(v : Int) -> @core.Any { @mbtconv.serialize_option(Some(v)) }),
  )
  g._set(
    "mbt_serialize_none",
    @core.any(fn() -> @core.Any {
      let none : Int? = None
      @mbtconv.serialize_option(none)
    }),
  )

  // Option deserialization
  g._set(
    "mbt_deserialize_option",
    @core.any(fn(v : @core.Any) -> @core.Any {
      let opt : Int? = @mbtconv.deserialize_option(v)
      match opt {
        Some(val) => @core.any(val)
        None => @core.undefined()
      }
    }),
  )

  // Enum serialization
  g._set(
    "mbt_serialize_enum_unit",
    @core.any(fn() -> @core.Any { serialize_color(Red) }),
  )
  g._set(
    "mbt_serialize_enum_tuple",
    @core.any(fn(r : Int, g : Int, b : Int) -> @core.Any {
      serialize_color(Rgb(r, g, b))
    }),
  )

  // Result check functions (using MoonBit's mbtconv)
  g._set("mbt_is_result_ok", @core.any(@mbtconv.is_result_ok))
  g._set("mbt_is_result_err", @core.any(@mbtconv.is_result_err))
  // Need explicit type annotation for generic functions
  g._set(
    "mbt_unwrap_ok",
    @core.any(fn(v : @core.Any) -> Int { @mbtconv.unwrap_ok(v) }),
  )
  g._set(
    "mbt_unwrap_err",
    @core.any(fn(v : @core.Any) -> String { @mbtconv.unwrap_err(v) }),
  )
}

///|
fn serialize_color(color : Color) -> @core.Any {
  let obj = @core.new_object()
  match color {
    Red => {
      obj["_tag"] = @core.any(0)
      obj["_name"] = @core.any("Red")
    }
    Green => {
      obj["_tag"] = @core.any(1)
      obj["_name"] = @core.any("Green")
    }
    Blue => {
      obj["_tag"] = @core.any(2)
      obj["_name"] = @core.any("Blue")
    }
    Rgb(r, g, b) => {
      obj["_tag"] = @core.any(3)
      obj["_name"] = @core.any("Rgb")
      obj["_args"] = @core.any([r, g, b])
    }
  }
  obj
}

///|
fn main {
  setup_interop_test()
}
