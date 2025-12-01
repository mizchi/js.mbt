///|
/// Better Auth Client - Client-side authentication
/// https://www.better-auth.com/docs/concepts/client

///|
/// Auth client instance
#external
pub type AuthClient

///|
pub fn AuthClient::to_any(self : AuthClient) -> @nostd.Any = "%identity"

///|
/// Create a new auth client
pub fn createAuthClient(base_url~ : String) -> AuthClient {
  let obj = @nostd.Object::new()
  obj["baseURL"] = @nostd.any(base_url)
  ffi_create_auth_client(obj |> @js.identity) |> @nostd.identity
}

///|
extern "js" fn ffi_create_auth_client(config : @nostd.Any) -> @nostd.Any =
  #|(config) => {
  #|  const { createAuthClient } = require('better-auth/client');
  #|  return createAuthClient(config);
  #|}

///|
/// Sign up namespace
#external
pub type SignUpClient

///|
pub fn SignUpClient::to_any(self : SignUpClient) -> @nostd.Any = "%identity"

///|
/// Get signUp methods from client
pub fn AuthClient::signUp(self : AuthClient) -> SignUpClient {
  self.to_any()["signUp"] |> @nostd.identity
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
  let obj = @nostd.Object::new()
  obj["name"] = @nostd.any(name)
  obj["email"] = @nostd.any(email)
  obj["password"] = @nostd.any(password)
  if image is Some(img) {
    obj["image"] = @nostd.any(img)
  }
  if callback_url is Some(url) {
    obj["callbackURL"] = @nostd.any(url)
  }
  let promise : @js.Promise[AuthResponse] = self
    .to_any()["email"]
    ._invoke([obj])
    |> @js.identity
  promise.wait()
}

///|
/// Sign in namespace
#external
pub type SignInClient

///|
pub fn SignInClient::to_any(self : SignInClient) -> @nostd.Any = "%identity"

///|
/// Get signIn methods from client
pub fn AuthClient::signIn(self : AuthClient) -> SignInClient {
  self.to_any()["signIn"] |> @nostd.identity
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
  let obj = @nostd.Object::new()
  obj["email"] = @nostd.any(email)
  obj["password"] = @nostd.any(password)
  if remember_me is Some(rm) {
    obj["rememberMe"] = @nostd.any(rm)
  }
  if callback_url is Some(url) {
    obj["callbackURL"] = @nostd.any(url)
  }
  let promise : @js.Promise[AuthResponse] = self
    .to_any()["email"]
    ._invoke([obj])
    |> @js.identity
  promise.wait()
}

///|
/// Sign in with social provider (client-side)
/// provider: "github" | "google"
pub async fn SignInClient::social(
  self : SignInClient,
  provider~ : String,
  callback_url? : String,
) -> @nostd.Any {
  let obj = @nostd.Object::new()
  obj["provider"] = @nostd.any(provider)
  if callback_url is Some(url) {
    obj["callbackURL"] = @nostd.any(url)
  }
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()["social"]
    ._invoke([obj])
    |> @js.identity
  promise.wait()
}

///|
/// Get current session
pub async fn AuthClient::getSession(self : AuthClient) -> @nostd.Any {
  let promise : @js.Promise[@nostd.Any] = self
    .to_any()["getSession"]
    ._invoke([])
    |> @js.identity
  promise.wait()
}

///|
/// Sign out (client-side)
pub async fn AuthClient::signOut(self : AuthClient) -> Unit {
  let promise : @js.Promise[Unit] = self.to_any()["signOut"]._invoke([])
    |> @js.identity
  promise.wait()
}

///|
/// useSession hook result
#external
pub type UseSessionResult

///|
pub fn UseSessionResult::to_any(self : UseSessionResult) -> @nostd.Any =
  "%identity"

///|
/// Get session data
pub fn UseSessionResult::data(self : UseSessionResult) -> @nostd.Any {
  self.to_any()["data"] |> @js.identity
}

///|
/// Check if session is pending
pub fn UseSessionResult::isPending(self : UseSessionResult) -> Bool {
  self.to_any()["isPending"].cast()
}

///|
/// Get error if any
pub fn UseSessionResult::error(self : UseSessionResult) -> @nostd.Any? {
  @nostd.identity_option(self.to_any()["error"])
}
