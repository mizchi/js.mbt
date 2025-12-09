///|
/// MSW Browser adapter - Worker API
/// https://mswjs.io/docs/api/setup-worker
///
/// Browser specific functionality for MSW using Service Workers.
/// Use MswBrowser for mocking in browser environments.

///| Browser Types

///|
/// MSW Browser module instance containing setupWorker
#external
pub type MswBrowser

///|
pub fn MswBrowser::as_any(self : MswBrowser) -> @core.Any = "%identity"

///|
/// Mock worker instance (Browser)
#external
pub type SetupWorker

///|
pub fn SetupWorker::as_any(self : SetupWorker) -> @core.Any = "%identity"

///|
/// StartOptions for worker.start()
#external
pub type StartOptions

///|
pub fn StartOptions::as_any(self : StartOptions) -> @core.Any = "%identity"

///| Worker FFI (msw/browser)

///|
/// Dynamic import for msw/browser module
extern "js" fn ffi_import_msw_browser() -> @core.Promise[@core.Any] =
  #|() => import("msw/browser")

///|
/// Import msw/browser module and return MswBrowser instance
pub async fn import_msw_browser() -> MswBrowser {
  ffi_import_msw_browser().wait().cast()
}

///|
extern "js" fn get_setup_worker_fn(msw_browser : MswBrowser) -> @core.Any =
  #|(msw_browser) => msw_browser.setupWorker

///|
extern "js" fn call_setup_worker(
  setup_worker : @core.Any,
  handlers : @core.Any,
) -> SetupWorker =
  #| (sw, handlers) => sw(...handlers)

///|
extern "js" fn call_setup_worker_empty(setup_worker : @core.Any) -> SetupWorker =
  #| (sw) => sw()

///|
pub extern "js" fn worker_start(
  worker : SetupWorker,
  options? : @core.Any,
) -> @core.Promise[Unit] =
  #| (worker, options) => {
  #|   return options !== undefined ?
  #|     worker.start(options) :
  #|     worker.start();
  #| }

///|
extern "js" fn ffi_worker_stop(worker : SetupWorker) -> Unit =
  #| (worker) => worker.stop()

///|
extern "js" fn ffi_worker_reset_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.resetHandlers()

///|
extern "js" fn ffi_worker_reset_handlers_with(
  worker : SetupWorker,
  handlers : @core.Any,
) -> Unit =
  #| (worker, handlers) => worker.resetHandlers(...handlers)

///|
extern "js" fn ffi_worker_use(
  worker : SetupWorker,
  handlers : @core.Any,
) -> Unit =
  #| (worker, handlers) => worker.use(...handlers)

///|
extern "js" fn ffi_worker_restore_handlers(worker : SetupWorker) -> Unit =
  #| (worker) => worker.restoreHandlers()

///|
extern "js" fn ffi_worker_list_handlers(worker : SetupWorker) -> @core.Any =
  #| (worker) => worker.listHandlers()

///| MswBrowser Methods

///|
/// Setup mock worker with handlers (Browser)
pub fn MswBrowser::setupWorker(
  self : MswBrowser,
  handlers : Array[RequestHandler],
) -> SetupWorker {
  let setup_worker_fn = get_setup_worker_fn(self)
  if handlers.length() == 0 {
    call_setup_worker_empty(setup_worker_fn)
  } else {
    call_setup_worker(
      setup_worker_fn,
      @core.any(handlers.map(fn(h) { h.as_any() })),
    )
  }
}

///| SetupWorker Methods

///|
/// Start the service worker (async)
///
/// # Options
/// - `serviceWorkerUrl`: Custom URL to the worker script (default: "/mockServiceWorker.js")
/// - `quiet`: Disables logging of intercepted requests (default: false)
/// - `onUnhandledRequest`: How to handle unhandled requests ("bypass" | "warn" | "error")
pub async fn SetupWorker::start(
  self : SetupWorker,
  serviceWorkerUrl? : String,
  quiet? : Bool,
  onUnhandledRequest? : String,
) -> Unit {
  let has_options = serviceWorkerUrl is Some(_) ||
    quiet is Some(_) ||
    onUnhandledRequest is Some(_)
  if has_options {
    let options = @core.new_object()
    match serviceWorkerUrl {
      Some(url) => {
        let sw = @core.new_object()
        sw["url"] = @core.any(url)
        options["serviceWorker"] = sw
      }
      None => ()
    }
    match quiet {
      Some(q) => options["quiet"] = @core.any(q)
      None => ()
    }
    match onUnhandledRequest {
      Some(mode) => options["onUnhandledRequest"] = @core.any(mode)
      None => ()
    }
    worker_start(self, options~).wait()
  } else {
    worker_start(self).wait()
  }
}

///|
/// Stop the service worker
pub fn SetupWorker::stop(self : SetupWorker) -> Unit {
  ffi_worker_stop(self)
}

///|
/// Reset handlers to initial state
pub fn SetupWorker::resetHandlers(self : SetupWorker) -> Unit {
  ffi_worker_reset_handlers(self)
}

///|
/// Reset handlers with new handlers
pub fn SetupWorker::resetHandlersWith(
  self : SetupWorker,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_worker_reset_handlers_with(
    self,
    @core.any(handlers.map(fn(h) { h.as_any() })),
  )
}

///|
/// Add runtime request handlers
pub fn SetupWorker::useHandlers(
  self : SetupWorker,
  handlers : Array[RequestHandler],
) -> Unit {
  ffi_worker_use(self, @core.any(handlers.map(fn(h) { h.as_any() })))
}

///|
/// Restore handlers to initial state
pub fn SetupWorker::restoreHandlers(self : SetupWorker) -> Unit {
  ffi_worker_restore_handlers(self)
}

///|
/// List all current handlers
pub fn SetupWorker::listHandlers(self : SetupWorker) -> @core.Any {
  ffi_worker_list_handlers(self)
}
