///| Tests for loop control utilities

///|
test "step_count_is should stop at max steps" {
  let condition = @ai.step_count_is(3)
  let @ai.StopCondition(f) = condition
  // Step 2 - should not stop
  let ctx2 : @ai.StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_false(f(ctx2))
  // Step 3 - should stop (at max)
  let ctx3 : @ai.StopConditionContext = {
    step_number: 3,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_true(f(ctx3))
  // Step 4 - should stop (beyond max)
  let ctx4 : @ai.StopConditionContext = {
    step_number: 4,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_true(f(ctx4))
}

///|
test "has_tool_call should detect specific tool" {
  let condition = @ai.has_tool_call("search")
  let @ai.StopCondition(f) = condition
  // No tool calls - should not stop
  let ctx_empty : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_empty))
  // Different tool called - should not stop
  let other_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "other" |> @nostd.any,
      "toolCallId": "1" |> @nostd.any,
    }).cast(),
  )
  let ctx_other : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [other_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_other))
  // Target tool called - should stop
  let search_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "search" |> @nostd.any,
      "toolCallId": "2" |> @nostd.any,
    }).cast(),
  )
  let ctx_found : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [search_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_true(f(ctx_found))
}

///|
test "has_any_tool_call should detect any of specified tools" {
  let condition = @ai.has_any_tool_call(["search", "execute"])
  let @ai.StopCondition(f) = condition
  // No matching tools
  let other_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "read" |> @nostd.any,
      "toolCallId": "1" |> @nostd.any,
    }).cast(),
  )
  let ctx_no_match : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [other_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_no_match))
  // First matching tool
  let search_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "search" |> @nostd.any,
      "toolCallId": "2" |> @nostd.any,
    }).cast(),
  )
  let ctx_search : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [search_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_true(f(ctx_search))
  // Second matching tool
  let execute_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "execute" |> @nostd.any,
      "toolCallId": "3" |> @nostd.any,
    }).cast(),
  )
  let ctx_execute : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [execute_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_true(f(ctx_execute))
}

///|
test "model_finished should detect natural stop" {
  let condition = @ai.model_finished()
  let @ai.StopCondition(f) = condition
  // Stop with no tool calls - should stop
  let ctx_finished : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_true(f(ctx_finished))
  // Stop with tool calls - should not stop
  let tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "test" |> @nostd.any,
      "toolCallId": "1" |> @nostd.any,
    }).cast(),
  )
  let ctx_tool_calls : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [tool],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_false(f(ctx_tool_calls))
  // Tool calls reason - should not stop
  let ctx_tool_reason : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_tool_reason))
}

///|
test "any_of should combine conditions with OR" {
  let cond1 = @ai.step_count_is(2)
  let cond2 = @ai.has_tool_call("done")
  let combined = @ai.any_of([cond1, cond2])
  let @ai.StopCondition(f) = combined
  // Neither condition met
  let ctx_none : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_false(f(ctx_none))
  // First condition met (step count)
  let ctx_step : @ai.StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_true(f(ctx_step))
  // Second condition met (tool call)
  let done_tool = @ai.ToolCall::from_any(
    @mbtconv.from_map({
      "toolName": "done" |> @nostd.any,
      "toolCallId": "1" |> @nostd.any,
    }).cast(),
  )
  let ctx_tool : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [done_tool],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_true(f(ctx_tool))
}

///|
test "all_of should combine conditions with AND" {
  let cond1 = @ai.step_count_is(2)
  let cond2 = @ai.model_finished()
  let combined = @ai.all_of([cond1, cond2])
  let @ai.StopCondition(f) = combined
  // Neither condition met
  let ctx_none : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_none))
  // Only first condition met
  let ctx_step_only : @ai.StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::ToolCalls,
  }
  assert_false(f(ctx_step_only))
  // Only second condition met
  let ctx_finish_only : @ai.StopConditionContext = {
    step_number: 1,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_false(f(ctx_finish_only))
  // Both conditions met
  let ctx_both : @ai.StopConditionContext = {
    step_number: 2,
    messages: [],
    tool_calls: [],
    finish_reason: @ai.FinishReason::Stop,
  }
  assert_true(f(ctx_both))
}

///|
test "PrepareStepResult::empty should have all None" {
  let result = @ai.PrepareStepResult::empty()
  assert_true(result.model is None)
  assert_true(result.active_tools is None)
  assert_true(result.messages is None)
  assert_true(result.system is None)
  assert_true(result.max_tokens is None)
  assert_true(result.temperature is None)
}

///|
test "PrepareStepResult::with_active_tools should set tools" {
  let result = @ai.PrepareStepResult::with_active_tools(["search", "execute"])
  assert_true(result.model is None)
  guard result.active_tools is Some(tools)
  assert_eq(tools.length(), 2)
  assert_eq(tools[0], "search")
  assert_eq(tools[1], "execute")
}

///|
test "PrepareStepResult::with_messages should set messages" {
  let msg : @js.Any = @nostd.from_entries([("role", "user" |> @nostd.any)]).cast()
  let result = @ai.PrepareStepResult::with_messages([msg])
  assert_true(result.model is None)
  guard result.messages is Some(msgs)
  assert_eq(msgs.length(), 1)
}

///|
test "PrepareStepResult::as_any with empty" {
  let result = @ai.PrepareStepResult::empty()
  let js_obj = result.as_any()
  assert_true(@js.is_undefined(js_obj.get("model")))
  assert_true(@js.is_undefined(js_obj.get("activeTools")))
  assert_true(@js.is_undefined(js_obj.get("messages")))
  assert_true(@js.is_undefined(js_obj.get("system")))
  assert_true(@js.is_undefined(js_obj.get("maxTokens")))
  assert_true(@js.is_undefined(js_obj.get("temperature")))
}

///|
test "PrepareStepResult::as_any with active_tools" {
  let result = @ai.PrepareStepResult::with_active_tools(["tool1", "tool2"])
  let js_obj = result.as_any()
  let tools_arr : Array[String] = @js.identity(js_obj.get("activeTools"))
  assert_eq(tools_arr.length(), 2)
  assert_eq(tools_arr[0], "tool1")
}

///|
test "PrepareStepResult::as_any with system and temperature" {
  let result : @ai.PrepareStepResult = {
    ..@ai.PrepareStepResult::empty(),
    system: Some("You are a helpful assistant"),
    temperature: Some(0.7),
  }
  let js_obj = result.as_any()
  let system : String = js_obj.get("system").cast()
  assert_eq(system, "You are a helpful assistant")
  let temp : Double = js_obj.get("temperature").cast()
  assert_eq(temp, 0.7)
}

///|
test "PrepareStepResult::as_any with max_tokens" {
  let result : @ai.PrepareStepResult = {
    ..@ai.PrepareStepResult::empty(),
    max_tokens: Some(1000),
  }
  let js_obj = result.as_any()
  let max_tokens : Int = js_obj.get("maxTokens").cast()
  assert_eq(max_tokens, 1000)
}

///|
test "StopCondition::as_any creates JS function" {
  let condition = @ai.step_count_is(5)
  let js_fn = condition.as_any()
  // The result should be a function
  assert_false(@js.is_undefined(js_fn))
  assert_false(@js.is_null(js_fn))
}
