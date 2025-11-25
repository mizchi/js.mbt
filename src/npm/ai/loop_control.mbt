///| AI SDK Loop Control
/// Provides utilities for controlling agent execution flow
/// Based on https://v6.ai-sdk.dev/docs/agents/loop-control

///|
/// Context passed to stop conditions for evaluation
pub(all) struct StopConditionContext {
  /// Current step number (1-indexed)
  step_number : Int
  /// Messages in the conversation
  messages : Array[@js.Any]
  /// Tool calls made in this step
  tool_calls : Array[ToolCall]
  /// Finish reason of this step
  finish_reason : FinishReason
}

///|
/// Stop condition function type
/// Returns true if the agent loop should stop
pub suberror StopCondition (StopConditionContext) -> Bool

///|
/// Create a stop condition that stops after a specific number of steps
/// This is the default behavior with maxSteps parameter
pub fn step_count_is(max_steps : Int) -> StopCondition {
  StopCondition(fn(ctx) { ctx.step_number >= max_steps })
}

///|
/// Create a stop condition that stops when a specific tool is called
pub fn has_tool_call(tool_name : String) -> StopCondition {
  StopCondition(fn(ctx) {
    ctx.tool_calls.iter().any(fn(tc) { tc.tool_name == tool_name })
  })
}

///|
/// Create a stop condition that stops when any of the specified tools is called
pub fn has_any_tool_call(tool_names : Array[String]) -> StopCondition {
  StopCondition(fn(ctx) {
    ctx.tool_calls
    .iter()
    .any(fn(tc) { tool_names.iter().any(fn(name) { name == tc.tool_name }) })
  })
}

///|
/// Create a stop condition that stops when the model stops naturally (no tool calls)
pub fn model_finished() -> StopCondition {
  StopCondition(fn(ctx) {
    ctx.finish_reason == Stop && ctx.tool_calls.is_empty()
  })
}

///|
/// Combine multiple stop conditions with OR logic
pub fn any_of(conditions : Array[StopCondition]) -> StopCondition {
  StopCondition(fn(ctx) {
    conditions
    .iter()
    .any(fn(cond) {
      let StopCondition(f) = cond
      f(ctx)
    })
  })
}

///|
/// Combine multiple stop conditions with AND logic
pub fn all_of(conditions : Array[StopCondition]) -> StopCondition {
  StopCondition(fn(ctx) {
    conditions
    .iter()
    .all(fn(cond) {
      let StopCondition(f) = cond
      f(ctx)
    })
  })
}

///|
/// Context passed to prepareStep callback
pub(all) struct PrepareStepContext {
  /// Current step number (1-indexed)
  step_number : Int
  /// Messages in the conversation so far
  messages : Array[@js.Any]
  /// Previous step results (if any)
  steps : Array[StepResult]
}

///|
/// Result from prepareStep callback
/// All fields are optional - only non-None values will be applied
pub(all) struct PrepareStepResult {
  /// Override model for this step
  model : Model?
  /// Override active tools for this step
  active_tools : Array[String]?
  /// Override messages for this step
  messages : Array[@js.Any]?
  /// Override system prompt for this step
  system : String?
  /// Override max tokens for this step
  max_tokens : Int?
  /// Override temperature for this step
  temperature : Double?
}

///|
/// Create an empty PrepareStepResult (no overrides)
pub fn PrepareStepResult::empty() -> PrepareStepResult {
  {
    model: None,
    active_tools: None,
    messages: None,
    system: None,
    max_tokens: None,
    temperature: None,
  }
}

///|
/// Create PrepareStepResult with model override
pub fn PrepareStepResult::with_model(model : Model) -> PrepareStepResult {
  { ..PrepareStepResult::empty(), model: Some(model) }
}

///|
/// Create PrepareStepResult with active tools override
pub fn PrepareStepResult::with_active_tools(
  tools : Array[String],
) -> PrepareStepResult {
  { ..PrepareStepResult::empty(), active_tools: Some(tools) }
}

///|
/// Create PrepareStepResult with messages override
pub fn PrepareStepResult::with_messages(
  messages : Array[@js.Any],
) -> PrepareStepResult {
  { ..PrepareStepResult::empty(), messages: Some(messages) }
}

///|
/// PrepareStep callback type
pub suberror PrepareStep async (PrepareStepContext) -> PrepareStepResult

///|
/// Convert PrepareStepResult to JS options object
pub fn PrepareStepResult::to_any(self : PrepareStepResult) -> @js.Any {
  let obj = @js.Object::new()
  if self.model is Some(m) {
    obj.set("model", m.to_any())
  }
  if self.active_tools is Some(tools) {
    obj.set("activeTools", tools |> @js.from_array)
  }
  if self.messages is Some(msgs) {
    obj.set("messages", msgs |> @js.from_array)
  }
  if self.system is Some(s) {
    obj.set("system", s)
  }
  if self.max_tokens is Some(t) {
    obj.set("maxTokens", t)
  }
  if self.temperature is Some(t) {
    obj.set("temperature", t)
  }
  obj.to_any()
}

///|
/// Convert StopCondition to JS function for AI SDK
pub fn StopCondition::to_any(self : StopCondition) -> @js.Any {
  let StopCondition(f) = self
  @js.identity(fn(ctx_raw : @js.Any) -> Bool {
    let step_number : Int = ctx_raw.get("stepNumber").cast()
    let messages : Array[@js.Any] = @js.identity(ctx_raw.get("messages"))
    let tool_calls_raw = ctx_raw.get("toolCalls")
    let tool_calls : Array[ToolCall] = if @js.is_undefined(tool_calls_raw) ||
      @js.is_null(tool_calls_raw) {
      []
    } else {
      let arr : Array[@js.Any] = @js.identity(tool_calls_raw)
      arr.map(ToolCall::from_any)
    }
    let finish_reason = FinishReason::from_string(
      ctx_raw.get("finishReason").cast(),
    )
    let ctx : StopConditionContext = {
      step_number,
      messages,
      tool_calls,
      finish_reason,
    }
    f(ctx)
  })
}

///|
/// Convert PrepareStep callback to JS function for AI SDK
pub fn PrepareStep::to_any(self : PrepareStep) -> @js.Any {
  let PrepareStep(f) = self
  let promisified = @js.promisify1(async fn(ctx_raw : @js.Any) -> @js.Any {
    let step_number : Int = ctx_raw.get("stepNumber").cast()
    let messages : Array[@js.Any] = @js.identity(ctx_raw.get("messages"))
    let steps_raw = ctx_raw.get("steps")
    let steps : Array[StepResult] = if @js.is_undefined(steps_raw) ||
      @js.is_null(steps_raw) {
      []
    } else {
      let arr : Array[@js.Any] = @js.identity(steps_raw)
      arr.map(StepResult::from_any)
    }
    let ctx : PrepareStepContext = { step_number, messages, steps }
    let result = f(ctx)
    result.to_any()
  })
  @js.identity(promisified)
}
