///|
/// Better Auth - Authentication library for TypeScript
///
/// Documentation: https://www.better-auth.com/
///
/// Database Setup:
///   Before using better-auth, you need to generate and run migrations:
///   ```bash
///   npx @better-auth/cli@latest generate
///   npx @better-auth/cli@latest migrate
///   ```
///   See: https://www.better-auth.com/docs/adapters/sqlite

///|
/// Auth instance
#external
pub type Auth

///|
pub fn Auth::to_any(self : Auth) -> @core.Any = "%identity"

///|
/// User type returned from better-auth API
#external
pub type User

///|
pub fn User::to_any(self : User) -> @core.Any = "%identity"

///|
/// Get user id
pub fn User::id(self : User) -> String {
  self.to_any()["id"].cast()
}

///|
/// Get user email
pub fn User::email(self : User) -> String {
  self.to_any()["email"].cast()
}

///|
/// Get user name
pub fn User::name(self : User) -> String? {
  @core.identity_option(self.to_any()["name"])
}

///|
/// Get user image
pub fn User::image(self : User) -> String? {
  @core.identity_option(self.to_any()["image"])
}

///|
/// Get user emailVerified
pub fn User::emailVerified(self : User) -> Bool {
  self.to_any()["emailVerified"].cast()
}

///|
/// Get user createdAt
pub fn User::createdAt(self : User) -> String {
  self.to_any()["createdAt"].cast()
}

///|
/// Get user updatedAt
pub fn User::updatedAt(self : User) -> String {
  self.to_any()["updatedAt"].cast()
}

///|
/// Session type stored in database
#external
pub type Session

///|
pub fn Session::to_any(self : Session) -> @core.Any = "%identity"

///|
/// Get session id
pub fn Session::id(self : Session) -> String {
  self.to_any()["id"].cast()
}

///|
/// Get session userId
pub fn Session::userId(self : Session) -> String {
  self.to_any()["userId"].cast()
}

///|
/// Get session token
pub fn Session::token(self : Session) -> String {
  self.to_any()["token"].cast()
}

///|
/// Get session expiresAt
pub fn Session::expiresAt(self : Session) -> String {
  self.to_any()["expiresAt"].cast()
}

///|
/// Get session ipAddress
pub fn Session::ipAddress(self : Session) -> String? {
  @core.identity_option(self.to_any()["ipAddress"])
}

///|
/// Get session userAgent
pub fn Session::userAgent(self : Session) -> String? {
  @core.identity_option(self.to_any()["userAgent"])
}

///|
/// Auth API - server-side methods
#external
pub type AuthApi

///|
pub fn AuthApi::to_any(self : AuthApi) -> @core.Any = "%identity"

///|
/// Get the API from auth instance
pub fn Auth::api(self : Auth) -> AuthApi {
  self.to_any()["api"] |> @core.identity
}

///|
/// Auth handler for HTTP frameworks
pub fn Auth::handler(self : Auth) -> @core.Any {
  self.to_any()["handler"] |> @core.identity
}

///|
/// Provider trait - abstraction for auth providers
pub trait Provider {
  /// Apply provider configuration to the auth config object
  apply(Self, @core.Any) -> Unit
}

///|
/// Email and password provider
pub(all) struct EmailPassword {
  enabled : Bool
}

///|
pub impl Provider for EmailPassword with apply(self, config) {
  let obj = @core.Object::new()
  obj["enabled"] = @core.any(self.enabled)
  config._set("emailAndPassword", obj)
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
  let obj = @core.Object::new()
  obj["clientId"] = @core.any(self.client_id)
  obj["clientSecret"] = @core.any(self.client_secret)
  sp._set("github", obj)
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
  let obj = @core.Object::new()
  obj["clientId"] = @core.any(self.client_id)
  obj["clientSecret"] = @core.any(self.client_secret)
  sp._set("google", obj)
}

///|
fn get_or_create_social_providers(config : @core.Any) -> @core.Any {
  let existing = config["socialProviders"]
  if @core.is_nullish(existing) {
    let sp = @core.Object::new()
    config._set("socialProviders", sp)
    sp
  } else {
    existing
  }
}

///|
/// Create a new Auth instance with providers
pub fn betterAuth(
  database~ : @core.Any,
  providers~ : Array[&Provider],
  base_url? : String,
  secret? : String,
) -> Auth {
  let config = @core.Object::new()
  config["database"] = @core.any(database)
  for provider in providers {
    provider.apply(config)
  }
  if base_url is Some(url) {
    config["baseURL"] = @core.any(url)
  }
  if secret is Some(s) {
    config["secret"] = @core.any(s)
  }
  ffi_better_auth(config |> @core.identity) |> @core.identity
}

///|
extern "js" fn ffi_better_auth(config : @core.Any) -> @core.Any =
  #|(config) => {
  #|  const { betterAuth } = require('better-auth');
  #|  return betterAuth(config);
  #|}

///|
/// Auth response from signUpEmail/signInEmail API
/// Returns { token, user } on success, or { error } on failure
#external
pub type AuthResponse

///|
pub fn AuthResponse::to_any(self : AuthResponse) -> @core.Any = "%identity"

///|
/// Get user from response
pub fn AuthResponse::user(self : AuthResponse) -> User {
  self.to_any()["user"] |> @core.identity
}

///|
/// Get session token from response (for cookie setting)
/// Note: signInEmail returns token directly, not nested in session
pub fn AuthResponse::token(self : AuthResponse) -> String {
  self.to_any()["token"].cast()
}

///|
/// Check if response has error
pub fn AuthResponse::hasError(self : AuthResponse) -> Bool {
  not(@core.is_nullish(self.to_any()["error"]))
}

///|
/// Get error from response if present
pub fn AuthResponse::error(self : AuthResponse) -> @core.Any {
  self.to_any()["error"] |> @core.identity
}

///|
/// Get error message from response if present
pub fn AuthResponse::errorMessage(self : AuthResponse) -> String? {
  let err = self.to_any()["error"]
  if @core.is_nullish(err) {
    None
  } else {
    Some(err["message"].cast())
  }
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
  let body = @core.Object::new()
  body["name"] = @core.any(name)
  body["email"] = @core.any(email)
  body["password"] = @core.any(password)
  if image is Some(img) {
    body["image"] = @core.any(img)
  }
  if callback_url is Some(url) {
    body["callbackURL"] = @core.any(url)
  }
  let req_obj = @core.Object::new()
  req_obj["body"] = body
  let promise = ffi_call_auth_api_with_catch(
    self.to_any()["signUpEmail"] |> @core.identity,
    req_obj |> @core.identity,
  )
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
  headers? : @core.Any,
) -> AuthResponse {
  let body = @core.Object::new()
  body["email"] = @core.any(email)
  body["password"] = @core.any(password)
  if remember_me is Some(rm) {
    body["rememberMe"] = @core.any(rm)
  }
  if callback_url is Some(url) {
    body["callbackURL"] = @core.any(url)
  }
  let req_obj = @core.Object::new()
  req_obj["body"] = body
  if headers is Some(h) {
    req_obj["headers"] = @core.any(h)
  }
  let promise = ffi_call_auth_api_with_catch(
    self.to_any()["signInEmail"] |> @core.identity,
    req_obj |> @core.identity,
  )
  promise.wait()
}

///|
/// Sign in with social provider (returns redirect URL)
pub async fn AuthApi::signInSocial(
  self : AuthApi,
  provider~ : String,
  callback_url? : String,
) -> @core.Any {
  let body = @core.Object::new()
  body["provider"] = @core.any(provider)
  if callback_url is Some(url) {
    body["callbackURL"] = @core.any(url)
  }
  let req_obj = @core.Object::new()
  req_obj["body"] = body
  let promise : @js.Promise[@core.Any] = self.to_any()["signInSocial"]._invoke([
      req_obj,
    ])
    |> @core.identity
  promise.wait()
}

///|
/// Session response from getSession API
/// Returns { session, user } on success, or null if not authenticated
#external
pub type SessionResponse

///|
pub fn SessionResponse::to_any(self : SessionResponse) -> @core.Any = "%identity"

///|
/// Get session from response
pub fn SessionResponse::session(self : SessionResponse) -> Session {
  self.to_any()["session"] |> @core.identity
}

///|
/// Get user from response
pub fn SessionResponse::user(self : SessionResponse) -> User {
  self.to_any()["user"] |> @core.identity
}

///|
/// Get session from request headers
/// Returns SessionResponse with { session, user } if authenticated, or null
pub async fn AuthApi::getSession(
  self : AuthApi,
  headers : @core.Any,
) -> SessionResponse? {
  let req_obj = @core.Object::new()
  req_obj["headers"] = @core.any(headers)
  let promise : @js.Promise[@core.Any] = self.to_any()["getSession"]._invoke([
      req_obj,
    ])
    |> @core.identity
  let result : @core.Any = promise.wait() |> @core.any
  if @core.is_nullish(result) || @core.is_nullish(result["user"]) {
    None
  } else {
    Some(result |> @core.identity)
  }
}

///|
/// Sign out
pub async fn AuthApi::signOut(self : AuthApi, headers : @core.Any) -> Unit {
  let req_obj = @core.Object::new()
  req_obj["headers"] = @core.any(headers)
  let promise : @js.Promise[Unit] = self.to_any()["signOut"]._invoke([req_obj])
    |> @core.identity
  promise.wait()
}

///|
/// Helper to call auth API methods and catch errors, converting them to { error: { message } }
extern "js" fn ffi_call_auth_api_with_catch(
  fn_ : @core.Any,
  args : @core.Any,
) -> @js.Promise[AuthResponse] =
  #|(fn_, args) => {
  #|  return fn_(args).catch(err => {
  #|    // Convert error to { error: { message } } format
  #|    const message = err.body?.message || err.message || 'Unknown error';
  #|    return { error: { message, code: err.body?.code || 'ERROR' } };
  #|  });
  #|}
