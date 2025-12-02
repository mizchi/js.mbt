///|
/// CDP Session support for Puppeteer
/// See: https://pptr.dev/api/puppeteer.cdpsession

///|
/// CDPSession type
/// Represents a Chrome DevTools Protocol session
#external
pub type CDPSession

///|
pub fn CDPSession::to_any(self : CDPSession) -> @nostd.Any = "%identity"

///| Page methods (CDP)

///|
/// Page: Create CDP session
/// JS: page.createCDPSession()
/// See: https://pptr.dev/api/puppeteer.page.createcdpsession
pub async fn Page::createCDPSession(self : Page) -> CDPSession {
  let promise : @js.Promise[CDPSession] = self
    .to_any()
    ._call("createCDPSession", [])
    |> @nostd.identity
  promise.wait()
}

///| CDPSession methods

///|
/// CDPSession: Detach the session from the target
/// JS: cdpSession.detach()
/// See: https://pptr.dev/api/puppeteer.cdpsession.detach
pub async fn CDPSession::detach(self : CDPSession) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()._call("detach", [])
    |> @nostd.identity
  promise.wait()
}

///|
/// CDPSession: Get the session ID
/// JS: cdpSession.id()
/// See: https://pptr.dev/api/puppeteer.cdpsession.id
pub fn CDPSession::id(self : CDPSession) -> String {
  self.to_any()._call("id", []).cast()
}

///|
/// CDPSession: Send a CDP command
/// JS: cdpSession.send(method, params)
/// See: https://pptr.dev/api/puppeteer.cdpsession.send
pub async fn CDPSession::send(
  self : CDPSession,
  method_ : String,
  params : @nostd.Any,
) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("send", [@nostd.any(method_), @nostd.any(params)])
    |> @nostd.identity
  promise.wait()
}

///|
/// CDPSession: Send a CDP command without params
/// JS: cdpSession.send(method)
pub async fn CDPSession::send_simple(
  self : CDPSession,
  method_ : String,
) -> Unit {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()
    ._call("send", [@nostd.any(method_)])
    |> @nostd.identity
  let _ = promise.wait()

}
