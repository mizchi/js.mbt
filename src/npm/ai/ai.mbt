// WIP

///|
using @js {type Js, trait JsImpl, safe_js, unsafe_cast}

///|
pub(all) enum MessageContent {
  Message(String)
}

///|
pub impl JsImpl for MessageContent with to_js(self) {
  match self {
    Message(m) => m |> safe_js
  }
}

///|
pub(all) enum ModelMessage {
  UserMessage(content~ : MessageContent)
  AssitantMessage(content~ : MessageContent)
  SystemMessage(content~ : MessageContent)
}

///|
pub impl JsImpl for ModelMessage with to_js(self) {
  match self {
    AssitantMessage(content~) =>
      @js.from_map({
        "type": "assitant" |> safe_js,
        "content": JsImpl::to_js(content),
      })
    UserMessage(content~) =>
      @js.from_map({
        "role": "user" |> safe_js,
        "content": JsImpl::to_js(content),
      })
    SystemMessage(content~) =>
      @js.from_map({
        "role": "system" |> safe_js,
        "content": JsImpl::to_js(content),
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
pub impl JsImpl for Ai

///|
pub fn Ai::require() -> Self {
  @node.require("ai") |> unsafe_cast
}

///|
pub fn Ai::generate_text(
  self : Self,
  model~ : Model,
  messages~ : Array[ModelMessage],
  // prompt?: String
) -> @promise.Promise[Js] {
  unsafe_cast(
    self
    .to_js()
    .get("generateText")
    .invoke_self([
      @js.from_map({
        "model": model |> unsafe_cast,
        "messages": messages.map(_.to_js()) |> @js.from_array,
      }),
    ]),
  )
}

///|
#skip
test "ai" {
  let ai : Ai = unsafe_cast(@node.require("ai"))
  let model : Model = unsafe_cast(
    @node.require("@ai-sdk/anthropic")
    .get("anthropic")
    .invoke_self(["claude-sonnet-4-20250514"]),
  )
  let messages : Array[ModelMessage] = [UserMessage(content=Message("hello"))]
  @promise.run_async(() => try {
    let result = ai.generate_text(model~, messages~).unwrap()
    @js.log(result)
  } catch {
    @js.JsThrowError::Error(e) => @js.log(e)
    e => @js.log(e)
  })
}
