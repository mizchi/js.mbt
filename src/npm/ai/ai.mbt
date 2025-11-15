// WIP

///|
using @js {type Val, trait Js, js, unsafe_cast, from_builtin_map}

///|
pub(all) enum MessageContent {
  Message(String)
}

///|
pub impl Js for MessageContent with to_js(self) {
  match self {
    Message(m) => m |> js
  }
}

///|
pub(all) enum ModelMessage {
  UserMessage(content~ : MessageContent)
  AssitantMessage(content~ : MessageContent)
  SystemMessage(content~ : MessageContent)
}

///|
pub impl Js for ModelMessage with to_js(self) {
  match self {
    AssitantMessage(content~) =>
      from_builtin_map({
        "type": "assitant" |> js,
        "content": Js::to_js(content),
      })
    UserMessage(content~) =>
      from_builtin_map({ "role": "user" |> js, "content": Js::to_js(content) })
    SystemMessage(content~) =>
      from_builtin_map({ "role": "system" |> js, "content": Js::to_js(content) })
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
pub impl Js for Ai

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
) -> @async.Promise[Val] {
  unsafe_cast(
    self
    .to_js()
    .get("generateText")
    .invoke_self([
      from_builtin_map({
        "model": model |> js,
        "messages": messages.map(_.to_js()) |> js,
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
  @async.run_async(() => try {
    let result = ai.generate_text(model~, messages~).unwrap()
    @js.log(result)
  } catch {
    @js.JsError(e) => @js.log(e)
    e => @js.log(e)
  })
}
