# mizchi/npm_typed/better_auth

MoonBit FFI bindings for [better-auth](https://www.better-auth.com/) - Authentication library for TypeScript.

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install better-auth
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/core",
    "mizchi/npm_typed/better_auth"
  ]
}
```

## Documentation

- Official docs: https://www.better-auth.com/
- SQLite adapter: https://www.better-auth.com/docs/adapters/sqlite

## Database Setup

Before using better-auth, you need to generate and run database migrations:

```bash
# Generate migration files
npx @better-auth/cli@latest generate

# Apply migrations to database
npx @better-auth/cli@latest migrate
```

## Example Usage

```moonbit
let db = @sqlite.DatabaseSync::new("app.db")
let auth = @better_auth.betterAuth(
  database=db |> @js.identity,
  providers=[@better_auth.EmailPassword::{ enabled: true }],
  secret="your-secret-key",
)

// Sign up
let response = auth.api().signUpEmail(
  name="John Doe",
  email="john@example.com",
  password="password123",
)
if not(response.hasError()) {
  let user = response.user()
  let token = response.token()
  // Set cookie: better-auth.session_token=token
}

// Sign in
let response = auth.api().signInEmail(
  email="john@example.com",
  password="password123",
)
if not(response.hasError()) {
  let token = response.token()
  // Set cookie: better-auth.session_token=token
}

// Get session
let session = auth.api().getSession(headers)
match session {
  Some(s) => {
    let user = s.user()
    let session = s.session()
  }
  None => {
    // Not authenticated
  }
}
```

## API Response Structure

- `signUpEmail` / `signInEmail` returns `{ token, user }` on success, `{ error }` on failure
- `getSession` returns `{ session, user }` if authenticated, `null` otherwise

## See Also

- Full example: `src/examples/realworld/` - TODO app with authentication
