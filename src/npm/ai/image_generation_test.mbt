///| Tests for image generation

///|
test "generated image from_any" {
  let base64_str = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk"
  let raw = @js.from_map({
    "base64": base64_str |> @js.any,
    "uint8Array": @js.undefined(),
  })
  let image = @ai.GeneratedImage::from_any(raw)
  assert_true(image.base64.length() > 0)
}

///|
test "generate image result from_any" {
  let image_raw = @js.from_map({
    "base64": "base64data" |> @js.any,
    "uint8Array": @js.undefined(),
  })
  let raw = @js.from_map({
    "image": image_raw,
    "images": @js.from_array([image_raw]),
    "warnings": @js.from_array([]) |> @js.any,
  })
  let result = @ai.GenerateImageResult::from_any(raw)
  assert_eq(result.image.base64, "base64data")
  assert_eq(result.images.length(), 1)
  assert_eq(result.warnings.length(), 0)
}

///|
test "generate image result multiple images" {
  let image1 = @js.from_map({
    "base64": "image1base64" |> @js.any,
    "uint8Array": @js.undefined(),
  })
  let image2 = @js.from_map({
    "base64": "image2base64" |> @js.any,
    "uint8Array": @js.undefined(),
  })
  let raw = @js.from_map({
    "image": image1,
    "images": @js.from_array([image1, image2]),
    "warnings": @js.from_array([]) |> @js.any,
  })
  let result = @ai.GenerateImageResult::from_any(raw)
  assert_eq(result.images.length(), 2)
  assert_eq(result.images[0].base64, "image1base64")
  assert_eq(result.images[1].base64, "image2base64")
}

///|
#skip
async test "generate image with openai" {
  // This test requires actual API key, so skip by default
  let ai = @ai.Ai::require()
  let model : @ai.ImageModel = @js.identity(
    @node.require("@ai-sdk/openai")
    .get("openai")
    .call_self([])
    .get("image")
    .call_self(["dall-e-3"]),
  )
  let result = ai.generateImage(
    model~,
    prompt="A cute cat sitting on a rainbow",
    size="1024x1024",
  )
  @js.log(
    "Generated image base64 length: " + result.image.base64.length().to_string(),
  )
}
