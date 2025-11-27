///|
/// Better Auth - Authentication library for TypeScript
/// https://www.better-auth.com/

///|
/// Auth instance
#external
pub type Auth

///|
pub impl @js.JsImpl for Auth

///|
/// User type
#external
pub type User

///|
pub impl @js.JsImpl for User

///|
/// Get user id
pub fn User::id(self : User) -> String {
  self.get("id").cast()
}

///|
/// Get user email
pub fn User::email(self : User) -> String {
  self.get("email").cast()
}

///|
/// Get user name
pub fn User::name(self : User) -> String? {
  @js.identity_option(self.get("name"))
}

///|
/// Get user image
pub fn User::image(self : User) -> String? {
  @js.identity_option(self.get("image"))
}

///|
/// Get user emailVerified
pub fn User::emailVerified(self : User) -> Bool {
  self.get("emailVerified").cast()
}

///|
/// Session type
#external
pub type Session

///|
pub impl @js.JsImpl for Session

///|
/// Get session id
pub fn Session::id(self : Session) -> String {
  self.get("id").cast()
}

///|
/// Get session userId
pub fn Session::userId(self : Session) -> String {
  self.get("userId").cast()
}

///|
/// Get session token
pub fn Session::token(self : Session) -> String {
  self.get("token").cast()
}

///|
/// Get session expiresAt
pub fn Session::expiresAt(self : Session) -> @js.Any {
  self.get("expiresAt")
}

///|
/// Auth API - server-side methods
#external
pub type AuthApi

///|
pub impl @js.JsImpl for AuthApi

///|
/// Get the API from auth instance
pub fn Auth::api(self : Auth) -> AuthApi {
  self.get("api").cast()
}

///|
/// Auth handler for HTTP frameworks
pub fn Auth::handler(self : Auth) -> @js.Any {
  self.get("handler")
}

///|
/// Provider trait - abstraction for auth providers
pub trait Provider {
  /// Apply provider configuration to the auth config object
  apply(Self, @js.Any) -> Unit
}

///|
/// Email and password provider
pub(all) struct EmailPassword {
  enabled : Bool
}

///|
pub impl Provider for EmailPassword with apply(self, config) {
  let obj = @js.Object::new()
  obj.set("enabled", self.enabled)
  config.set("emailAndPassword", obj)
}

///|
/// GitHub OAuth provider
pub(all) struct GitHub {
  client_id : String
  client_secret : String
}

///|
pub impl Provider for GitHub with apply(self, config) {
  let sp = get_or_create_social_providers(config)
  let obj = @js.Object::new()
  obj.set("clientId", self.client_id)
  obj.set("clientSecret", self.client_secret)
  sp.set("github", obj)
}

///|
/// Google OAuth provider
pub(all) struct Google {
  client_id : String
  client_secret : String
}

///|
pub impl Provider for Google with apply(self, config) {
  let sp = get_or_create_social_providers(config)
  let obj = @js.Object::new()
  obj.set("clientId", self.client_id)
  obj.set("clientSecret", self.client_secret)
  sp.set("google", obj)
}

///|
fn get_or_create_social_providers(config : @js.Any) -> @js.Any {
  let existing = config.get("socialProviders")
  if @js.is_nullish(existing) {
    let sp = @js.Object::new()
    config.set("socialProviders", sp)
    sp
  } else {
    existing
  }
}

///|
/// Create a new Auth instance with providers
pub fn betterAuth(
  database~ : @js.Any,
  providers~ : Array[&Provider],
  base_url? : String,
  secret? : String,
) -> Auth {
  let config = @js.Object::new()
  config.set("database", database)
  for provider in providers {
    provider.apply(config)
  }
  if base_url is Some(url) {
    config.set("baseURL", url)
  }
  if secret is Some(s) {
    config.set("secret", s)
  }
  ffi_better_auth(config).cast()
}

///|
extern "js" fn ffi_better_auth(config : @js.Any) -> @js.Any =
  #|(config) => {
  #|  const { betterAuth } = require('better-auth');
  #|  return betterAuth(config);
  #|}

///|
/// Auth response containing user and session
#external
pub type AuthResponse

///|
pub impl @js.JsImpl for AuthResponse

///|
/// Get user from response
pub fn AuthResponse::user(self : AuthResponse) -> User {
  self.get("user").cast()
}

///|
/// Get session from response
pub fn AuthResponse::session(self : AuthResponse) -> Session {
  self.get("session").cast()
}

///|
/// Sign up with email
pub async fn AuthApi::signUpEmail(
  self : AuthApi,
  name~ : String,
  email~ : String,
  password~ : String,
  image? : String,
  callback_url? : String,
) -> AuthResponse {
  let body = @js.Object::new()
  body.set("name", name)
  body.set("email", email)
  body.set("password", password)
  if image is Some(img) {
    body.set("image", img)
  }
  if callback_url is Some(url) {
    body.set("callbackURL", url)
  }
  let req_obj = @js.Object::new()
  req_obj.set("body", body)
  let promise : @js.Promise[AuthResponse] = self
    .get("signUpEmail")
    .call_self([req_obj])
    .cast()
  promise.wait()
}

///|
/// Sign in with email
pub async fn AuthApi::signInEmail(
  self : AuthApi,
  email~ : String,
  password~ : String,
  remember_me? : Bool,
  callback_url? : String,
  headers? : @js.Any,
) -> AuthResponse {
  let body = @js.Object::new()
  body.set("email", email)
  body.set("password", password)
  if remember_me is Some(rm) {
    body.set("rememberMe", rm)
  }
  if callback_url is Some(url) {
    body.set("callbackURL", url)
  }
  let req_obj = @js.Object::new()
  req_obj.set("body", body)
  if headers is Some(h) {
    req_obj.set("headers", h)
  }
  let promise : @js.Promise[AuthResponse] = self
    .get("signInEmail")
    .call_self([req_obj])
    .cast()
  promise.wait()
}

///|
/// Sign in with social provider (returns redirect URL)
pub async fn AuthApi::signInSocial(
  self : AuthApi,
  provider~ : String,
  callback_url? : String,
) -> @js.Any {
  let body = @js.Object::new()
  body.set("provider", provider)
  if callback_url is Some(url) {
    body.set("callbackURL", url)
  }
  let req_obj = @js.Object::new()
  req_obj.set("body", body)
  let promise : @js.Promise[@js.Any] = self
    .get("signInSocial")
    .call_self([req_obj])
    .cast()
  promise.wait()
}

///|
/// Get session from request headers
pub async fn AuthApi::getSession(self : AuthApi, headers : @js.Any) -> @js.Any {
  let req_obj = @js.Object::new()
  req_obj.set("headers", headers)
  let promise : @js.Promise[@js.Any] = self
    .get("getSession")
    .call_self([req_obj])
    .cast()
  promise.wait()
}

///|
/// Sign out
pub async fn AuthApi::signOut(self : AuthApi, headers : @js.Any) -> Unit {
  let req_obj = @js.Object::new()
  req_obj.set("headers", headers)
  let promise : @js.Promise[Unit] = self
    .get("signOut")
    .call_self([req_obj])
    .cast()
  promise.wait()
}
