///|
/// Custom Elements API for defining custom HTML elements
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements

///|
/// CustomElementRegistry provides methods for registering custom elements
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry
#external
pub type CustomElementRegistry

///|
pub impl Js for CustomElementRegistry with to_js(self) {
  self |> js
}

///|
/// Returns the custom elements registry
/// https://developer.mozilla.org/en-US/docs/Web/API/Window/customElements
pub fn custom_elements() -> CustomElementRegistry {
  @js.global_this().get("customElements").cast()
}

///|
/// Lifecycle callbacks for custom elements
pub struct CustomElementCallbacks {
  on_connected : () -> Unit
  on_disconnected : () -> Unit
  on_adopted : () -> Unit
  on_attribute_changed : (String, String?, String?, String?) -> Unit
}

///|
/// Creates a custom element class with lifecycle callbacks
/// https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements
extern "js" fn create_custom_element_class(
  callbacks : CustomElementCallbacks,
) -> Val =
  #|(callbacks) => {
  #|  return class extends HTMLElement {
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
/// Defines a custom element with the given name and callbacks
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
pub fn CustomElementRegistry::define_element(
  self : Self,
  name : String,
  callbacks : CustomElementCallbacks,
) -> Unit {
  let element_class = create_custom_element_class(callbacks)
  ignore(self.to_js().invoke("define", [name, element_class]))
}

///|
/// Defines a custom element with observed attributes
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
extern "js" fn create_custom_element_class_with_attributes(
  callbacks : CustomElementCallbacks,
  observed_attributes : Array[String],
) -> Val =
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
  ignore(self.to_js().invoke("define", [name, element_class]))
}

///|
/// Returns the constructor for the custom element with the given name
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/get
pub fn CustomElementRegistry::get(self : Self, name : String) -> Val? {
  self.to_js().invoke("get", [name]).cast_option()
}

///|
/// Returns the name of the custom element for the given constructor
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/getName
pub fn CustomElementRegistry::get_name(
  self : Self,
  element_constructor : Val,
) -> String? {
  self.to_js().invoke("getName", [element_constructor]).cast_option()
}

///|
/// Returns a promise that resolves when the custom element is defined
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/whenDefined
pub fn CustomElementRegistry::when_defined(
  self : Self,
  name : String,
) -> Promise[Unit] {
  self.to_js().invoke("whenDefined", [name]).cast()
}

///|
/// Upgrades a custom element in the shadow root before it is connected
/// https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/upgrade
pub fn CustomElementRegistry::upgrade(self : Self, root : Node) -> Unit {
  ignore(self.to_js().invoke("upgrade", [root.to_js()]))
}

///|
/// Helper function to create default callbacks
pub fn CustomElementCallbacks::new(
  on_connected? : () -> Unit = fn() { () },
  on_disconnected? : () -> Unit = fn() { () },
  on_adopted? : () -> Unit = fn() { () },
  on_attribute_changed? : (String, String?, String?, String?) -> Unit = fn(
    _,
    _,
    _,
    _,
  ) {
    ()
  },
) -> CustomElementCallbacks {
  { on_connected, on_disconnected, on_adopted, on_attribute_changed }
}
