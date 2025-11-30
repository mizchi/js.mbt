///|
/// CDP Session support for Puppeteer
/// See: https://pptr.dev/api/puppeteer.cdpsession

///|
/// CDPSession type
/// Represents a Chrome DevTools Protocol session
#external
pub type CDPSession

///|
pub fn CDPSession::as_any(self : CDPSession) -> @js.Any = "%identity"

// Internal helper functions for method calls

///|
fn CDPSession::call(
  self : CDPSession,
  name : String,
  args : Array[&@js.JsImpl],
) -> @js.Any {
  self.as_any().call(name, args)
}

///| Page methods (CDP)

///|
/// Page: Create CDP session
/// JS: page.createCDPSession()
/// See: https://pptr.dev/api/puppeteer.page.createcdpsession
pub async fn Page::createCDPSession(self : Page) -> CDPSession {
  let promise : @js.Promise[CDPSession] = @js.identity(
    self.as_any().call("createCDPSession", []),
  )
  promise.wait()
}

///| CDPSession methods

///|
/// CDPSession: Detach the session from the target
/// JS: cdpSession.detach()
/// See: https://pptr.dev/api/puppeteer.cdpsession.detach
pub async fn CDPSession::detach(self : CDPSession) -> Unit {
  let promise : @js.Promise[Unit] = @js.identity(self.call("detach", []))
  promise.wait()
}

///|
/// CDPSession: Get the session ID
/// JS: cdpSession.id()
/// See: https://pptr.dev/api/puppeteer.cdpsession.id
pub fn CDPSession::id(self : CDPSession) -> String {
  self.call("id", []).cast()
}

///|
/// CDPSession: Send a CDP command
/// JS: cdpSession.send(method, params)
/// See: https://pptr.dev/api/puppeteer.cdpsession.send
pub async fn CDPSession::send(
  self : CDPSession,
  method_ : String,
  params : @js.Any,
) -> @js.Any {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("send", [@js.any(method_), params]),
  )
  promise.wait()
}

///|
/// CDPSession: Send a CDP command without params
/// JS: cdpSession.send(method)
pub async fn CDPSession::send_simple(
  self : CDPSession,
  method_ : String,
) -> Unit {
  let promise : @js.Promise[@js.Any] = @js.identity(
    self.call("send", [@js.any(method_)]),
  )
  let _ = promise.wait()

}
