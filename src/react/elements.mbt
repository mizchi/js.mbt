// ///|
// pub fn node(
//   tag_name : String,
//   children : Array[&@js.ToJsValue],
//   attributes~ : Map[String, @js.Value],
//   id~ : String?,
//   class~ : String?,
//   key~ : String?,
//   style~ : Map[String, String]?,
//   on_click? : (@dom.Event) -> Unit,
//   on_keydown? : (@dom.Event) -> Unit,
//   on_keyup? : (@dom.Event) -> Unit,
// ) -> VirtualElement {
//   let final_props = @js.Value::new_object()
//   for k, v in attributes {
//     final_props[k] = v
//   }
//   if id is Some(id) {
//     final_props["id"] = @js.Value::cast_from(id)
//   }
//   if class is Some(class) {
//     final_props["className"] = @js.Value::cast_from(class)
//   }
//   if key is Some(key) {
//     final_props["key"] = @js.Value::cast_from(key)
//   }
//   if style is Some(style) {
//     let style_obj = @js.Value::new_object()
//     for k in style.keys() {
//       style_obj[k] = @js.Value::cast_from(style[k])
//     }
//     final_props["style"] = style_obj
//   }
//   if on_click is Some(on_click) {
//     final_props["onClick"] = on_click |> @js.identity
//   }
//   if on_keydown is Some(on_keydown) {
//     final_props["onKeyDown"] = on_keydown |> @js.identity
//   }
//   if on_keyup is Some(on_keyup) {
//     final_props["onKeyUp"] = on_keyup |> @js.identity
//   }
//   create_element_raw(
//     tag_name |> @js.identity,
//     final_props,
//     @js.Value::from_array(children),
//   )
//   |> @js.identity
// }

// ///|
// pub fn div(
//   children : Array[&@js.ToJsValue],
//   attributes? : Map[String, @js.Value],
//   // common
//   id? : String,
//   class? : String,
//   key? : String,
//   style? : Map[String, String],
//   // events
//   on_click? : (@dom.Event) -> Unit,
//   on_keydown? : (@dom.Event) -> Unit,
//   on_keyup? : (@dom.Event) -> Unit,
// ) -> VirtualElement {
//   let final_props : Map[String, @js.Value] = attributes.unwrap_or({})
//   node(
//     "div",
//     attributes=final_props,
//     children,
//     id~,
//     class~,
//     key~,
//     style~,
//     on_click?,
//     on_keydown?,
//     on_keyup?,
//   )
// }

// ///|
// pub fn span(
//   children : Array[&@js.ToJsValue],
//   attributes? : Map[String, @js.Value],
//   // common
//   id? : String,
//   class? : String,
//   key? : String,
//   style? : Map[String, String],
//   // events
//   on_click? : (@dom.Event) -> Unit,
//   on_keydown? : (@dom.Event) -> Unit,
//   on_keyup? : (@dom.Event) -> Unit,
// ) -> VirtualElement {
//   let final_props : Map[String, @js.Value] = attributes.unwrap_or({})
//   node(
//     "span",
//     attributes=final_props,
//     children,
//     id~,
//     class~,
//     key~,
//     style~,
//     on_click?,
//     on_keydown?,
//     on_keyup?,
//   )
// }

// ///|
// pub fn button(
//   children : Array[&@js.ToJsValue],
//   attributes? : Map[String, @js.Value],
//   // common
//   id? : String,
//   class? : String,
//   key? : String,
//   style? : Map[String, String],
//   // events
//   on_click? : (@dom.Event) -> Unit,
//   on_keydown? : (@dom.Event) -> Unit,
//   on_keyup? : (@dom.Event) -> Unit,
// ) -> VirtualElement {
//   let final_props : Map[String, @js.Value] = attributes.unwrap_or({})
//   node(
//     "button",
//     attributes=final_props,
//     children,
//     id~,
//     class~,
//     key~,
//     style~,
//     on_click?,
//     on_keydown?,
//     on_keyup?,
//   )
// }

// ///|
// pub fn form(
//   children : Array[&@js.ToJsValue],
//   attributes? : Map[String, @js.Value],
//   // common
//   id? : String,
//   class? : String,
//   key? : String,
//   style? : Map[String, String],
//   // events
//   on_click? : (@dom.Event) -> Unit,
//   on_keydown? : (@dom.Event) -> Unit,
//   on_keyup? : (@dom.Event) -> Unit,
//   on_submit? : (@dom.Event) -> Unit,
// ) -> VirtualElement {
//   let final_props : Map[String, @js.Value] = attributes.unwrap_or({})
//   if on_submit is Some(on_submit) {
//     final_props["onSubmit"] = on_submit |> @js.identity
//   }
//   node(
//     "form",
//     attributes=final_props,
//     children,
//     id~,
//     class~,
//     key~,
//     style~,
//     on_click?,
//     on_keydown?,
//     on_keyup?,
//   )
// }
