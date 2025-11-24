// WIP

///|

///|
pub(all) enum MessageContent {
  Message(String)
}

///|
pub impl @js.JsImpl for MessageContent with to_js(self) {
  match self {
    Message(m) => m |> @js.js
  }
}

///|
pub(all) enum ModelMessage {
  UserMessage(content~ : MessageContent)
  AssitantMessage(content~ : MessageContent)
  SystemMessage(content~ : MessageContent)
}

///|
pub impl @js.JsImpl for ModelMessage with to_js(self) {
  match self {
    AssitantMessage(content~) =>
      @js.from_map({
        "type": "assitant" |> @js.js,
        "content": @js.JsImpl::to_js(content),
      })
    UserMessage(content~) =>
      @js.from_map({
        "role": "user" |> @js.js,
        "content": @js.JsImpl::to_js(content),
      })
    SystemMessage(content~) =>
      @js.from_map({
        "role": "system" |> @js.js,
        "content": @js.JsImpl::to_js(content),
      })
  }
}

///|
/// npm:ai
#external
pub type Ai

///|
#external
pub type Model

///|
pub impl @js.JsImpl for Ai

///|
pub fn Ai::require() -> Self {
  @node.require("ai") |> @js.identity
}

///|
pub fn Ai::generate_text(
  self : Self,
  model~ : Model,
  messages~ : Array[ModelMessage],
  // prompt?: String
) -> @js.Promise[@js.Any] {
  @js.identity(
    self
    .to_js()
    .get("generateText")
    .call_self([
      @js.from_map({
        "model": model |> @js.identity,
        "messages": messages.map(_.to_js()) |> @js.from_array,
      }),
    ]),
  )
}

///|
#skip
test "ai" {
  let ai : Ai = @js.identity(@node.require("ai"))
  let model : Model = @js.identity(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .call_self(["claude-sonnet-4-20250514"]),
  )
  let messages : Array[ModelMessage] = [UserMessage(content=Message("hello"))]
  @js.run_async(() => try {
    let result = ai.generate_text(model~, messages~).wait()
    @js.log(result)
  } catch {
    @js.ThrowError::Error(e) => @js.log(e)
    e => @js.log(e)
  })
}
