// WIP

///|

///|
pub(all) enum MessageContent {
  Message(String)
}

///|
pub impl @js.JsImpl for MessageContent with to_any(self) {
  match self {
    Message(m) => m |> @js.any
  }
}

///|
pub(all) enum ModelMessage {
  UserMessage(content~ : MessageContent)
  AssitantMessage(content~ : MessageContent)
  SystemMessage(content~ : MessageContent)
}

///|
pub impl @js.JsImpl for ModelMessage with to_any(self) {
  match self {
    AssitantMessage(content~) =>
      @js.from_map({
        "type": "assitant" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
    UserMessage(content~) =>
      @js.from_map({
        "role": "user" |> @js.any,
        "content": @js.JsImpl::to_any(content),
      })
    SystemMessage(content~) =>
      @js.from_map({
        "role": "system" |> @js.any,
        "content": @js.JsImpl::to_any(content),
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
pub async fn Ai::generate_text(
  self : Self,
  model~ : Model,
  messages~ : Array[ModelMessage],
  // prompt?: String
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self
    .to_any()
    .get("generateText")
    .call_self([
      @js.from_map({
        "model": model |> @js.identity,
        "messages": messages.map(_.to_any()) |> @js.from_array,
      }),
    ]),
  )
  promise.wait()
}

///|
#skip
async test "ai" {
  let ai : Ai = @js.identity(@node.require("ai"))
  let model : Model = @js.identity(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .call_self(["claude-sonnet-4-20250514"]),
  )
  let messages : Array[ModelMessage] = [UserMessage(content=Message("hello"))]
  let result = ai.generate_text(model~, messages~) catch {
    @js.ThrowError::Error(e) => {
      @js.log(e)
      return
    }
    e => {
      @js.log(e)
      return
    }
  }
  @js.log(result)
}
