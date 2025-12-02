///| Loop Control Tests

///|
test "step_count_is creates stop condition" {
  let cond = step_count_is(5)
  let StopCondition(f) = cond
  // Step 4 should not stop
  let ctx4 : StopConditionContext = {
    step_number: 4,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx4), false)
  // Step 5 should stop
  let ctx5 : StopConditionContext = {
    step_number: 5,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx5), true)
  // Step 6 should also stop
  let ctx6 : StopConditionContext = {
    step_number: 6,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx6), true)
}

///|
test "has_tool_call creates stop condition" {
  let cond = has_tool_call("finish")
  let StopCondition(f) = cond
  // No tool calls - should not stop
  let ctx1 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx1), false)
  // Different tool call - should not stop
  let ctx2 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "search", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx2), false)
  // Matching tool call - should stop
  let ctx3 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "2", tool_name: "finish", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx3), true)
}

///|
test "has_any_tool_call creates stop condition" {
  let cond = has_any_tool_call(["submit", "done", "finish"])
  let StopCondition(f) = cond
  // No matching tool - should not stop
  let ctx1 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "search", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx1), false)
  // One matching tool - should stop
  let ctx2 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "2", tool_name: "done", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx2), true)
}

///|
test "model_finished creates stop condition" {
  let cond = model_finished()
  let StopCondition(f) = cond
  // Tool calls present - should not stop
  let ctx1 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "search", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx1), false)
  // No tool calls but finish_reason is ToolCalls - should not stop
  let ctx2 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx2), false)
  // No tool calls and finish_reason is Stop - should stop
  let ctx3 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx3), true)
}

///|
test "any_of combines conditions with OR" {
  let cond = any_of([step_count_is(3), has_tool_call("finish")])
  let StopCondition(f) = cond
  // Neither condition met
  let ctx1 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx1), false)
  // Step count met
  let ctx2 : StopConditionContext = {
    step_number: 3,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx2), true)
  // Tool call met
  let ctx3 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "finish", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx3), true)
}

///|
test "all_of combines conditions with AND" {
  let cond = all_of([step_count_is(2), has_tool_call("finish")])
  let StopCondition(f) = cond
  // Only step count met
  let ctx1 : StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [],
    finish_reason: Stop,
  }
  assert_eq(f(ctx1), false)
  // Only tool call met
  let ctx2 : StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "finish", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx2), false)
  // Both conditions met
  let ctx3 : StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [
      { tool_call_id: "1", tool_name: "finish", input: @global.undefined() },
    ],
    finish_reason: ToolCalls,
  }
  assert_eq(f(ctx3), true)
}

///|
test "PrepareStepResult::empty creates empty result" {
  let result = PrepareStepResult::empty()
  assert_true(result.model is None)
  assert_true(result.active_tools is None)
  assert_true(result.messages is None)
  assert_true(result.system is None)
  assert_true(result.max_tokens is None)
  assert_true(result.temperature is None)
}

///|
test "PrepareStepResult::with_active_tools" {
  let result = PrepareStepResult::with_active_tools(["search", "analyze"])
  assert_true(result.model is None)
  match result.active_tools {
    Some(tools) => {
      assert_eq(tools.length(), 2)
      assert_eq(tools[0], "search")
      assert_eq(tools[1], "analyze")
    }
    None => fail("Expected Some(tools)")
  }
}

///|
test "PrepareStepResult::with_messages" {
  let msgs : Array[@core.Any] = [@core.any("hello")]
  let result = PrepareStepResult::with_messages(msgs)
  assert_true(result.model is None)
  assert_true(result.active_tools is None)
  match result.messages {
    Some(messages) => assert_eq(messages.length(), 1)
    None => fail("Expected Some(messages)")
  }
}

///|
test "PrepareStepResult as_any creates JS object" {
  let result : PrepareStepResult = {
    model: None,
    active_tools: Some(["search"]),
    messages: None,
    system: Some("You are helpful"),
    max_tokens: Some(100),
    temperature: None,
  }
  let js_obj = result.as_any()
  // Check activeTools is set
  let active_tools = js_obj._get("activeTools")
  assert_false(@core.is_undefined(active_tools))
  // Check system is set
  let system : String = js_obj._get("system").cast()
  assert_eq(system, "You are helpful")
  // Check maxTokens is set
  let max_tokens : Int = js_obj._get("maxTokens").cast()
  assert_eq(max_tokens, 100)
  // Check model is not set
  assert_true(@core.is_undefined(js_obj._get("model")))
  // Check temperature is not set
  assert_true(@core.is_undefined(js_obj._get("temperature")))
}

///|
test "StopCondition as_any creates JS function" {
  let cond = step_count_is(3)
  let js_fn = cond.as_any()
  // Verify it's a function
  assert_false(@core.is_undefined(js_fn))
  // Call it with a mock context
  let ctx = @core.Object::new()
  ctx._set("stepNumber", 2 |> @core.any)
  let empty_arr : Array[@core.Any] = []
  ctx._set("messages", empty_arr |> @core.any)
  ctx._set("toolCalls", empty_arr |> @core.any)
  ctx._set("finishReason", "stop" |> @core.any)
  let result1 : Bool = js_fn._invoke([ctx]).cast()
  assert_eq(result1, false)
  // Call with step 3
  ctx._set("stepNumber", 3 |> @core.any)
  let result2 : Bool = js_fn._invoke([ctx]).cast()
  assert_eq(result2, true)
}
