///|
/// DOM trait hierarchy following TypeScript/Web IDL standards
/// EventTarget_ -> Node_ -> Element_ -> HTMLElement_
///
/// Note: Traits are suffixed with _ to avoid conflicts with existing type names

///|
/// EventTarget_ trait - base interface for objects that can receive events
pub(open) trait EventTarget_ {
  add_event_listener_(Self, String, (Event) -> Unit) -> Unit
  remove_event_listener_(Self, String, (Event) -> Unit) -> Unit
  dispatch_event_(Self, Event) -> Bool
}

///|
/// Node_ trait - base interface for DOM tree nodes
pub(open) trait Node_: EventTarget_ {
  node_type_(Self) -> Int
  node_name_(Self) -> String
  parent_node_(Self) -> Val
  child_nodes_(Self) -> Val
  first_child_(Self) -> Val
  last_child_(Self) -> Val
  previous_sibling_(Self) -> Val
  next_sibling_(Self) -> Val
  append_child_(Self, Val) -> Val
  remove_child_(Self, Val) -> Val
  insert_before_(Self, Val, Val) -> Val
  replace_child_(Self, Val, Val) -> Val
  clone_node_(Self, Bool) -> Val
  contains_(Self, Val) -> Bool
  has_child_nodes_(Self) -> Bool
  text_content_(Self) -> String
  set_text_content_(Self, String) -> Unit
}

///|
/// Element_ trait - base interface for element nodes
pub(open) trait Element_: Node_ {
  tag_name_(Self) -> String
  class_name_(Self) -> String
  set_class_name_(Self, String) -> Unit
  id_(Self) -> String
  set_id_(Self, String) -> Unit
  get_attribute_(Self, String) -> String
  set_attribute_(Self, String, String) -> Unit
  remove_attribute_(Self, String) -> Unit
  has_attribute_(Self, String) -> Bool
  get_elements_by_tag_name_(Self, String) -> Val
  get_elements_by_class_name_(Self, String) -> Val
  query_selector_(Self, String) -> Val
  query_selector_all_(Self, String) -> Val
}

///|
/// HTMLElement_ trait - base interface for HTML elements
pub(open) trait HTMLElement_: Element_ {
  inner_text_(Self) -> String
  set_inner_text_(Self, String) -> Unit
  inner_html_(Self) -> String
  set_inner_html_(Self, String) -> Unit
  outer_html_(Self) -> String
  set_outer_html_(Self, String) -> Unit
}
