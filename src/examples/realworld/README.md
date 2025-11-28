This is benchmark of productivity with moonbit/js.

---

# Realworld TODO App

A full-stack TODO application built with MoonBit, demonstrating:
- Server-side rendering with Hono
- Authentication with better-auth
- SQLite database with node:sqlite
- Form validation with Zod

## Tech Stack

- **Server**: Hono (Node.js)
- **Auth**: better-auth (email/password)
- **Database**: node:sqlite (Node.js 22.5.0+ built-in SQLite)
- **Validation**: Zod

## Project Structure

```
realworld/
├── main.mbt           # Entry point
├── server/
│   └── server.mbt     # Server implementation (routes, auth, db)
├── client/
│   └── client.mbt     # Client utilities (API client)
└── tests/
    ├── playwright.config.ts
    └── realworld.spec.ts
```

## Development

### Prerequisites

- Node.js 22.5.0+ (for built-in SQLite support)
- MoonBit toolchain
- pnpm

### Build and Run

```bash
# Build the project
moon build --target js

# Run the server
node target/js/release/build/examples/realworld/realworld.js

# Server runs at http://localhost:3000
```

### Development with auto-rebuild

```bash
# Watch for changes and rebuild
moon build --target js --watch

# In another terminal, run the server
node target/js/release/build/examples/realworld/realworld.js
```

### Fresh Start (reset database)

```bash
# Remove the database file and restart
rm -f realworld.db
moon build --target js
node target/js/release/build/examples/realworld/realworld.js
```

## Testing

### Run Playwright E2E Tests

```bash
cd tests
npx playwright test
```

The tests will automatically:
1. Build the project
2. Start the server
3. Run all E2E tests
4. Stop the server

### Test Coverage

- Authentication: register, login, logout, error handling
- TODO CRUD: create, toggle completion, delete, persistence
- Session: persistence across navigation

## Database

The app uses SQLite with the following tables:

- `user` - User accounts
- `session` - Active sessions
- `account` - OAuth accounts (for future social login)
- `verification` - Email verification tokens
- `todos` - User's TODO items

Tables are auto-created on first run. To reset, delete `realworld.db`.

## API Routes

### Pages
- `GET /` - Home (TODO list, requires auth)
- `GET /auth/login` - Login page
- `GET /auth/register` - Register page
- `GET /auth/logout` - Logout

### Form Actions
- `POST /auth/login` - Login form submission
- `POST /auth/register` - Register form submission
- `POST /todos` - Create TODO
- `POST /todos/:id/toggle` - Toggle TODO completion
- `POST /todos/:id/delete` - Delete TODO

### API Endpoints
- `GET /api/todos` - Get all TODOs (JSON)
- `POST /api/todos` - Create TODO (JSON)
- `DELETE /api/todos/:id` - Delete TODO
