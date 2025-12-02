///|
/// Custom Elements API for defining custom HTML elements
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements

///|
/// CustomElementRegistry provides methods for registering custom elements
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry
#external
pub type CustomElementRegistry

///|
pub fn CustomElementRegistry::as_any(
  self : CustomElementRegistry,
) -> @nostd.Any = "%identity"

///|
/// Returns the custom elements registry
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements
#alias(custom_elements)
pub fn customElements() -> CustomElementRegistry {
  @nostd.identity(@global.global_this()._get("customElements"))
}

///|
/// Lifecycle callbacks for custom elements
pub struct CustomElementCallbacks {
  onConnected : () -> Unit
  onDisconnected : () -> Unit
  onAdopted : () -> Unit
  onAttributeChanged : (String, String?, String?, String?) -> Unit
}

///|
/// Creates a custom element class with lifecycle callbacks
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements
extern "js" fn create_custom_element_class(
  callbacks : CustomElementCallbacks,
) -> @nostd.Any =
  #|(callbacks) => {
  #|  return class extends HTMLElement {
  #|    connectedCallback() {
  #|      callbacks.onConnected();
  #|    }
  #|    disconnectedCallback() {
  #|      callbacks.onDisconnected();
  #|    }
  #|    adoptedCallback() {
  #|      callbacks.onAdopted();
  #|    }
  #|    attributeChangedCallback(name, oldValue, newValue, namespace) {
  #|      callbacks.onAttribute_changed(name, oldValue, newValue, namespace);
  #|    }
  #|  };
  #|}

///|
/// Defines a custom element with the given name and callbacks
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
pub fn CustomElementRegistry::define_(
  self : Self,
  name : String,
  callbacks : CustomElementCallbacks,
) -> Unit {
  let element_class = create_custom_element_class(callbacks)
  self.as_any()._call("define", [@nostd.any(name), @nostd.any(element_class)])
  |> ignore
}

///|
/// Defines a custom element with observed attributes
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
extern "js" fn create_custom_element_class_with_attributes(
  callbacks : CustomElementCallbacks,
  observedAttributes : Array[String],
) -> @nostd.Any =
  #|(callbacks, observedAttributes) => {
  #|  return class extends HTMLElement {
  #|    static get observedAttributes() {
  #|      return observedAttributes;
  #|    }
  #|    connectedCallback() {
  #|      callbacks.on_connected();
  #|    }
  #|    disconnectedCallback() {
  #|      callbacks.on_disconnected();
  #|    }
  #|    adoptedCallback() {
  #|      callbacks.on_adopted();
  #|    }
  #|    attributeChangedCallback(name, oldValue, newValue, namespace) {
  #|      callbacks.on_attribute_changed(name, oldValue, newValue, namespace);
  #|    }
  #|  };
  #|}

///|
/// Defines a custom element with observed attributes
pub fn CustomElementRegistry::define_element_with_attributes(
  self : Self,
  name : String,
  callbacks : CustomElementCallbacks,
  observed_attributes : Array[String],
) -> Unit {
  let element_class = create_custom_element_class_with_attributes(
    callbacks, observed_attributes,
  )
  self.as_any()._call("define", [@nostd.any(name), @nostd.any(element_class)])
  |> ignore
}

///|
/// Returns the constructor for the custom element with the given name
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/get
pub fn CustomElementRegistry::get(self : Self, name : String) -> @nostd.Any? {
  let v : @nostd.Any = self.as_any()._call("get", [@nostd.any(name)]).cast()
  v |> @nostd.identity_option
}

///|
/// Returns the name of the custom element for the given constructor
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/getName
pub fn CustomElementRegistry::getName(
  self : Self,
  element_constructor : @nostd.Any,
) -> String? {
  let v : @nostd.Any = self
    .as_any()
    ._call("getName", [@nostd.any(element_constructor)])
    .cast()
  v |> @nostd.identity_option
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
    ._call("whenDefined", [@nostd.any(name)])
    .cast()
  promise.wait()
}

///|
/// Upgrades a custom element in the shadow root before it is connected
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/upgrade
pub fn CustomElementRegistry::upgrade(self : Self, root : Node) -> Unit {
  self.as_any()._call("upgrade", [root.as_any()]) |> ignore
}

///|
/// Helper function to create default callbacks
pub fn CustomElementCallbacks::new(
  onConnected? : () -> Unit = fn() { () },
  onDisconnected? : () -> Unit = fn() { () },
  onAdopted? : () -> Unit = fn() { () },
  onAttributeChanged? : (String, String?, String?, String?) -> Unit = fn(
    _,
    _,
    _,
    _,
  ) {
    ()
  },
) -> CustomElementCallbacks {
  { onConnected, onDisconnected, onAdopted, onAttributeChanged }
}
