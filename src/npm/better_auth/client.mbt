///|
/// Better Auth Client - Client-side authentication
/// https://www.better-auth.com/docs/concepts/client

///|
/// Auth client instance
#external
pub type AuthClient

///|
pub impl @js.JsImpl for AuthClient

///|
/// Create a new auth client
pub fn createAuthClient(base_url~ : String) -> AuthClient {
  let obj = @js.Object::new()
  obj.set("baseURL", base_url)
  ffi_create_auth_client(obj.to_any()).cast()
}

///|
extern "js" fn ffi_create_auth_client(config : @js.Any) -> @js.Any =
  #|(config) => {
  #|  const { createAuthClient } = require('better-auth/client');
  #|  return createAuthClient(config);
  #|}

///|
/// Sign up namespace
#external
pub type SignUpClient

///|
pub impl @js.JsImpl for SignUpClient

///|
/// Get signUp methods from client
pub fn AuthClient::signUp(self : AuthClient) -> SignUpClient {
  self.get("signUp").cast()
}

///|
/// Sign up with email (client-side)
pub async fn SignUpClient::email(
  self : SignUpClient,
  name~ : String,
  email~ : String,
  password~ : String,
  image? : String,
  callback_url? : String,
) -> AuthResponse {
  let obj = @js.Object::new()
  obj.set("name", name)
  obj.set("email", email)
  obj.set("password", password)
  if image is Some(img) {
    obj.set("image", img)
  }
  if callback_url is Some(url) {
    obj.set("callbackURL", url)
  }
  let promise : @js.Promise[AuthResponse] = self
    .get("email")
    .call_self([obj])
    .cast()
  promise.wait()
}

///|
/// Sign in namespace
#external
pub type SignInClient

///|
pub impl @js.JsImpl for SignInClient

///|
/// Get signIn methods from client
pub fn AuthClient::signIn(self : AuthClient) -> SignInClient {
  self.get("signIn").cast()
}

///|
/// Sign in with email (client-side)
pub async fn SignInClient::email(
  self : SignInClient,
  email~ : String,
  password~ : String,
  remember_me? : Bool,
  callback_url? : String,
) -> AuthResponse {
  let obj = @js.Object::new()
  obj.set("email", email)
  obj.set("password", password)
  if remember_me is Some(rm) {
    obj.set("rememberMe", rm)
  }
  if callback_url is Some(url) {
    obj.set("callbackURL", url)
  }
  let promise : @js.Promise[AuthResponse] = self
    .get("email")
    .call_self([obj])
    .cast()
  promise.wait()
}

///|
/// Sign in with social provider (client-side)
/// provider: "github" | "google"
pub async fn SignInClient::social(
  self : SignInClient,
  provider~ : String,
  callback_url? : String,
) -> @js.Any {
  let obj = @js.Object::new()
  obj.set("provider", provider)
  if callback_url is Some(url) {
    obj.set("callbackURL", url)
  }
  let promise : @js.Promise[@js.Any] = self
    .get("social")
    .call_self([obj])
    .cast()
  promise.wait()
}

///|
/// Get current session
pub async fn AuthClient::getSession(self : AuthClient) -> @js.Any {
  let promise : @js.Promise[@js.Any] = self
    .get("getSession")
    .call_self([])
    .cast()
  promise.wait()
}

///|
/// Sign out (client-side)
pub async fn AuthClient::signOut(self : AuthClient) -> Unit {
  let promise : @js.Promise[Unit] = self.get("signOut").call_self([]).cast()
  promise.wait()
}

///|
/// useSession hook result
#external
pub type UseSessionResult

///|
pub impl @js.JsImpl for UseSessionResult

///|
/// Get session data
pub fn UseSessionResult::data(self : UseSessionResult) -> @js.Any {
  self.get("data")
}

///|
/// Check if session is pending
pub fn UseSessionResult::isPending(self : UseSessionResult) -> Bool {
  self.get("isPending").cast()
}

///|
/// Get error if any
pub fn UseSessionResult::error(self : UseSessionResult) -> @js.Any? {
  @js.identity_option(self.get("error"))
}
