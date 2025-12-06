///|
/// Service Worker API bindings for MoonBit
/// https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API
///
/// Provides access to Service Worker registration, lifecycle, and messaging.

///| Types

///|
/// ServiceWorkerContainer - accessed via navigator.serviceWorker
/// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerContainer
#external
pub type ServiceWorkerContainer

///|
pub fn ServiceWorkerContainer::as_any(
  self : ServiceWorkerContainer,
) -> @core.Any = "%identity"

///|
/// ServiceWorkerRegistration - represents a service worker registration
/// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration
#external
pub type ServiceWorkerRegistration

///|
pub fn ServiceWorkerRegistration::as_any(
  self : ServiceWorkerRegistration,
) -> @core.Any = "%identity"

///|
/// ServiceWorker - represents a service worker
/// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker
#external
pub type ServiceWorker

///|
pub fn ServiceWorker::as_any(self : ServiceWorker) -> @core.Any = "%identity"

///|
/// RegistrationOptions for register()
#external
pub type RegistrationOptions

///|
pub fn RegistrationOptions::as_any(self : RegistrationOptions) -> @core.Any = "%identity"

///| ServiceWorkerContainer FFI

///|
extern "js" fn ffi_sw_register(
  container : ServiceWorkerContainer,
  script_url : String,
) -> @js.Promise[ServiceWorkerRegistration] =
  #| (container, scriptURL) => container.register(scriptURL)

///|
extern "js" fn ffi_sw_register_with_options(
  container : ServiceWorkerContainer,
  script_url : String,
  options : @core.Any,
) -> @js.Promise[ServiceWorkerRegistration] =
  #| (container, scriptURL, options) => container.register(scriptURL, options)

///|
extern "js" fn ffi_sw_get_registration(
  container : ServiceWorkerContainer,
  client_url : String,
) -> @js.Promise[ServiceWorkerRegistration?] =
  #| (container, clientURL) => container.getRegistration(clientURL)

///|
extern "js" fn ffi_sw_get_registration_default(
  container : ServiceWorkerContainer,
) -> @js.Promise[ServiceWorkerRegistration?] =
  #| (container) => container.getRegistration()

///|
extern "js" fn ffi_sw_get_registrations(
  container : ServiceWorkerContainer,
) -> @js.Promise[@core.Any] =
  #| (container) => container.getRegistrations()

///|
extern "js" fn ffi_sw_controller(
  container : ServiceWorkerContainer,
) -> ServiceWorker? =
  #| (container) => container.controller

///|
extern "js" fn ffi_sw_ready(
  container : ServiceWorkerContainer,
) -> @js.Promise[ServiceWorkerRegistration] =
  #| (container) => container.ready

///|
extern "js" fn ffi_sw_start_messages(
  container : ServiceWorkerContainer,
) -> Unit =
  #| (container) => container.startMessages()

///| ServiceWorkerRegistration FFI

///|
extern "js" fn ffi_reg_scope(reg : ServiceWorkerRegistration) -> String =
  #| (reg) => reg.scope

///|
extern "js" fn ffi_reg_update_via_cache(
  reg : ServiceWorkerRegistration,
) -> String =
  #| (reg) => reg.updateViaCache

///|
extern "js" fn ffi_reg_installing(
  reg : ServiceWorkerRegistration,
) -> ServiceWorker? =
  #| (reg) => reg.installing

///|
extern "js" fn ffi_reg_waiting(
  reg : ServiceWorkerRegistration,
) -> ServiceWorker? =
  #| (reg) => reg.waiting

///|
extern "js" fn ffi_reg_active(
  reg : ServiceWorkerRegistration,
) -> ServiceWorker? =
  #| (reg) => reg.active

///|
extern "js" fn ffi_reg_update(
  reg : ServiceWorkerRegistration,
) -> @js.Promise[ServiceWorkerRegistration] =
  #| (reg) => reg.update()

///|
extern "js" fn ffi_reg_unregister(
  reg : ServiceWorkerRegistration,
) -> @js.Promise[Bool] =
  #| (reg) => reg.unregister()

///| ServiceWorker FFI

///|
extern "js" fn ffi_worker_script_url(worker : ServiceWorker) -> String =
  #| (worker) => worker.scriptURL

///|
extern "js" fn ffi_worker_state(worker : ServiceWorker) -> String =
  #| (worker) => worker.state

///|
extern "js" fn ffi_worker_post_message(
  worker : ServiceWorker,
  message : @core.Any,
) -> Unit =
  #| (worker, message) => worker.postMessage(message)

///|
extern "js" fn ffi_worker_post_message_with_transfer(
  worker : ServiceWorker,
  message : @core.Any,
  transfer : @core.Any,
) -> Unit =
  #| (worker, message, transfer) => worker.postMessage(message, transfer)

///| ServiceWorkerContainer Methods

///|
/// Get the global ServiceWorkerContainer (navigator.serviceWorker)
pub extern "js" fn serviceWorkerContainer() -> ServiceWorkerContainer =
  #| () => navigator.serviceWorker

///|
/// Register a service worker
pub async fn ServiceWorkerContainer::register(
  self : ServiceWorkerContainer,
  script_url : String,
  scope? : String,
  type_? : String,
  update_via_cache? : String,
) -> ServiceWorkerRegistration {
  let has_options = scope is Some(_) ||
    type_ is Some(_) ||
    update_via_cache is Some(_)
  if has_options {
    let options = @core.new_object()
    let o = @core.any(options)
    match scope {
      Some(s) => o._set("scope", @core.any(s))
      None => ()
    }
    match type_ {
      Some(t) => o._set("type", @core.any(t))
      None => ()
    }
    match update_via_cache {
      Some(u) => o._set("updateViaCache", @core.any(u))
      None => ()
    }
    ffi_sw_register_with_options(self, script_url, options).wait()
  } else {
    ffi_sw_register(self, script_url).wait()
  }
}

///|
/// Get a registration for a specific client URL
pub async fn ServiceWorkerContainer::getRegistration(
  self : ServiceWorkerContainer,
  client_url? : String,
) -> ServiceWorkerRegistration? {
  match client_url {
    Some(url) => ffi_sw_get_registration(self, url).wait()
    None => ffi_sw_get_registration_default(self).wait()
  }
}

///|
/// Get all registrations
pub async fn ServiceWorkerContainer::getRegistrations(
  self : ServiceWorkerContainer,
) -> Array[ServiceWorkerRegistration] {
  @core.identity(ffi_sw_get_registrations(self).wait())
}

///|
/// Get the controller service worker
pub fn ServiceWorkerContainer::controller(
  self : ServiceWorkerContainer,
) -> ServiceWorker? {
  ffi_sw_controller(self)
}

///|
/// Get a promise that resolves when a service worker is active
pub fn ServiceWorkerContainer::ready(
  self : ServiceWorkerContainer,
) -> @js.Promise[ServiceWorkerRegistration] {
  ffi_sw_ready(self)
}

///|
/// Start receiving messages from service worker
pub fn ServiceWorkerContainer::startMessages(
  self : ServiceWorkerContainer,
) -> Unit {
  ffi_sw_start_messages(self)
}

///|
/// Set oncontrollerchange event handler
pub fn ServiceWorkerContainer::onControllerChange(
  self : ServiceWorkerContainer,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["oncontrollerchange"] = @core.any(@js.from_fn1(handler))
}

///|
/// Set onmessage event handler
pub fn ServiceWorkerContainer::onMessage(
  self : ServiceWorkerContainer,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["onmessage"] = @core.any(@js.from_fn1(handler))
}

///|
/// Set onmessageerror event handler
pub fn ServiceWorkerContainer::onMessageError(
  self : ServiceWorkerContainer,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["onmessageerror"] = @core.any(@js.from_fn1(handler))
}

///| ServiceWorkerRegistration Methods

///|
/// Get registration scope
pub fn ServiceWorkerRegistration::scope(
  self : ServiceWorkerRegistration,
) -> String {
  ffi_reg_scope(self)
}

///|
/// Get update via cache mode
pub fn ServiceWorkerRegistration::updateViaCache(
  self : ServiceWorkerRegistration,
) -> String {
  ffi_reg_update_via_cache(self)
}

///|
/// Get installing service worker
pub fn ServiceWorkerRegistration::installing(
  self : ServiceWorkerRegistration,
) -> ServiceWorker? {
  ffi_reg_installing(self)
}

///|
/// Get waiting service worker
pub fn ServiceWorkerRegistration::waiting(
  self : ServiceWorkerRegistration,
) -> ServiceWorker? {
  ffi_reg_waiting(self)
}

///|
/// Get active service worker
pub fn ServiceWorkerRegistration::active(
  self : ServiceWorkerRegistration,
) -> ServiceWorker? {
  ffi_reg_active(self)
}

///|
/// Update the registration
pub async fn ServiceWorkerRegistration::update(
  self : ServiceWorkerRegistration,
) -> ServiceWorkerRegistration {
  ffi_reg_update(self).wait()
}

///|
/// Unregister the service worker
pub async fn ServiceWorkerRegistration::unregister(
  self : ServiceWorkerRegistration,
) -> Bool {
  ffi_reg_unregister(self).wait()
}

///|
/// Set onupdatefound event handler
pub fn ServiceWorkerRegistration::onUpdateFound(
  self : ServiceWorkerRegistration,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["onupdatefound"] = @core.any(@js.from_fn1(handler))
}

///| ServiceWorker Methods

///|
/// Get the script URL
pub fn ServiceWorker::scriptUrl(self : ServiceWorker) -> String {
  ffi_worker_script_url(self)
}

///|
/// Get the state (installing, installed, activating, activated, redundant)
pub fn ServiceWorker::state(self : ServiceWorker) -> String {
  ffi_worker_state(self)
}

///|
/// Post a message to the service worker
pub fn ServiceWorker::postMessage(
  self : ServiceWorker,
  message : @core.Any,
) -> Unit {
  ffi_worker_post_message(self, message)
}

///|
/// Post a message with transferable objects
pub fn ServiceWorker::postMessageWithTransfer(
  self : ServiceWorker,
  message : @core.Any,
  transfer : Array[@core.Any],
) -> Unit {
  ffi_worker_post_message_with_transfer(self, message, @core.any(transfer))
}

///|
/// Set onstatechange event handler
pub fn ServiceWorker::onStateChange(
  self : ServiceWorker,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["onstatechange"] = @core.any(@js.from_fn1(handler))
}

///|
/// Set onerror event handler
pub fn ServiceWorker::onError(
  self : ServiceWorker,
  handler : (@core.Any) -> Unit,
) -> Unit {
  self.as_any()["onerror"] = @core.any(@js.from_fn1(handler))
}
