///| Tests for image generation

///|
test "generated image from_any" {
  let base64_str = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk"
  let raw = @nostd.from_entries([
    ("base64", base64_str |> @nostd.any),
    ("uint8Array", @global.undefined() |> @nostd.any),
  ]).cast()
  let image = @ai.GeneratedImage::from_any(raw)
  assert_true(image.base64.length() > 0)
}

///|
test "generate image result from_any" {
  let image_raw_nostd = @nostd.from_entries([
    ("base64", @nostd.any("base64data")),
    ("uint8Array", @global.undefined() |> @nostd.any),
  ])
  let image_raw = image_raw_nostd.cast()
  let empty_warnings : Array[@nostd.Any] = []
  let raw = @nostd.from_entries([
    ("image", image_raw_nostd),
    ("images", [image_raw_nostd] |> @nostd.any),
    ("warnings", @js.from_array(empty_warnings) |> @nostd.any),
  ]).cast()
  let result = @ai.GenerateImageResult::from_any(raw)
  assert_eq(result.image.base64, "base64data")
  assert_eq(result.images.length(), 1)
  assert_eq(result.warnings.length(), 0)
}

///|
test "generate image result multiple images" {
  let image1_nostd = @nostd.from_entries([
    ("base64", @nostd.any("image1base64")),
    ("uint8Array", @global.undefined() |> @nostd.any),
  ])
  let image1 = image1_nostd.cast()
  let image2_nostd = @nostd.from_entries([
    ("base64", @nostd.any("image2base64")),
    ("uint8Array", @global.undefined() |> @nostd.any),
  ])
  let image2 = image2_nostd.cast()
  let empty_warnings : Array[@nostd.Any] = []
  let raw = @nostd.from_entries([
    ("image", image1_nostd),
    ("images", [image1_nostd, image2_nostd] |> @nostd.any),
    ("warnings", @js.from_array(empty_warnings) |> @nostd.any),
  ]).cast()
  let result = @ai.GenerateImageResult::from_any(raw)
  assert_eq(result.images.length(), 2)
  assert_eq(result.images[0].base64, "image1base64")
  assert_eq(result.images[1].base64, "image2base64")
}

///|
#skip
async test "generate image with openai" {
  // This test requires actual API key, so skip by default
  let model : @ai.ImageModel = @js.identity(
    @node.require("@ai-sdk/openai")
    ._get("openai")
    .call_self([])
    ._get("image")
    .call_self(["dall-e-3"]),
  )
  let result = @ai.generateImage(
    model~,
    prompt="A cute cat sitting on a rainbow",
    size="1024x1024",
  )
  @js.log(
    "Generated image base64 length: " + result.image.base64.length().to_string(),
  )
}
