///|
/// Custom Elements API for defining custom HTML elements
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements

///|
/// CustomElementRegistry provides methods for registering custom elements
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry
#external
pub type CustomElementRegistry

///|
pub fn CustomElementRegistry::as_any(self : CustomElementRegistry) -> @core.Any = "%identity"

///|
/// Returns the custom elements registry
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements
#alias(custom_elements)
pub fn customElements() -> CustomElementRegistry {
  @core.identity(@global.global_this()._get("customElements"))
}

///|
/// Creates a custom element class with lifecycle callbacks
/// Supports optional HTMLElement base class and observed attributes
extern "js" fn create_custom_element_class_full(
  on_connected : () -> Unit,
  on_disconnected : () -> Unit,
  on_adopted : () -> Unit,
  on_attribute_changed : (String, String?, String?, String?) -> Unit,
  html_element_class : @core.Any,
  observed_attributes : @core.Any,
) -> @core.Any =
  #|(onConnected, onDisconnected, onAdopted, onAttributeChanged, HTMLElement, observedAttributes) => {
  #|  const cls = class extends HTMLElement {
  #|    connectedCallback() {
  #|      onConnected();
  #|    }
  #|    disconnectedCallback() {
  #|      onDisconnected();
  #|    }
  #|    adoptedCallback() {
  #|      onAdopted();
  #|    }
  #|    attributeChangedCallback(name, oldValue, newValue, namespace) {
  #|      onAttributeChanged(name, oldValue, newValue, namespace);
  #|    }
  #|  };
  #|  if (observedAttributes) {
  #|    Object.defineProperty(cls, 'observedAttributes', {
  #|      get() { return observedAttributes; }
  #|    });
  #|  }
  #|  return cls;
  #|}

///|
/// Defines a custom element with the given name and lifecycle callbacks
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
///
/// Options:
/// - `on_connected`: Called when the element is added to the document
/// - `on_disconnected`: Called when the element is removed from the document
/// - `on_adopted`: Called when the element is moved to a new document
/// - `on_attribute_changed`: Called when an observed attribute changes
/// - `observed_attributes`: Array of attribute names to observe for changes
/// - `html_element_class`: HTMLElement class to extend (for environments like happy-dom)
pub fn CustomElementRegistry::define_(
  self : Self,
  name : String,
  on_connected? : () -> Unit,
  on_disconnected? : () -> Unit,
  on_adopted? : () -> Unit,
  on_attribute_changed? : (String, String?, String?, String?) -> Unit,
  observed_attributes? : Array[String],
  html_element_class? : @core.Any,
) -> Unit {
  let base_class : @core.Any = match html_element_class {
    Some(c) => c
    None => @global.global_this()._get("HTMLElement").cast()
  }
  let attrs : @core.Any = match observed_attributes {
    Some(a) => @core.any(a)
    None => @core.null()
  }
  let connected = on_connected.unwrap_or(fn() {  })
  let disconnected = on_disconnected.unwrap_or(fn() {  })
  let adopted = on_adopted.unwrap_or(fn() {  })
  let attr_changed = on_attribute_changed.unwrap_or(fn(_, _, _, _) {  })
  let element_class = create_custom_element_class_full(
    connected, disconnected, adopted, attr_changed, base_class, attrs,
  )
  self.as_any()._call("define", [@core.any(name), @core.any(element_class)])
  |> ignore
}

///|
/// Returns the constructor for the custom element with the given name
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/get
pub fn CustomElementRegistry::get(self : Self, name : String) -> @core.Any? {
  let v : @core.Any = self.as_any()._call("get", [@core.any(name)]).cast()
  v |> @core.identity_option
}

///|
/// Returns the name of the custom element for the given constructor
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/getName
pub fn CustomElementRegistry::getName(
  self : Self,
  element_constructor : @core.Any,
) -> String? {
  let v : @core.Any = self
    .as_any()
    ._call("getName", [@core.any(element_constructor)])
    .cast()
  v |> @core.identity_option
}

///|
/// Returns a promise that resolves when the custom element is defined
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/whenDefined
pub async fn CustomElementRegistry::whenDefined(
  self : Self,
  name : String,
) -> Unit {
  let promise : @js.Promise[Unit] = self
    .as_any()
    ._call("whenDefined", [@core.any(name)])
    .cast()
  promise.wait()
}

///|
/// Upgrades a custom element in the shadow root before it is connected
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/upgrade
pub fn CustomElementRegistry::upgrade(self : Self, root : Node) -> Unit {
  self.as_any()._call("upgrade", [root.as_any()]) |> ignore
}
