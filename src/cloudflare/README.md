# Cloudflare Workers Bindings for MoonBit

This package provides type-safe MoonBit bindings for Cloudflare Workers platform services.

## Cloudflare Services Support Status

| Service | Package | Status | Note |
|---------|---------|--------|------|
| **Core Platform** |
| Workers Runtime | `mizchi/js/cloudflare` | 🧪 Tested | Basic runtime bindings |
| Environment Context | `mizchi/js/cloudflare` | 🧪 Tested | Env/ExecutionContext |
| **Storage Services** |
| KV (Key-Value) | `mizchi/js/cloudflare` | 🧪 Tested | Get/Put/Delete/List |
| D1 (SQL Database) | `mizchi/js/cloudflare` | 🧪 Tested | Queries/Prepared/Batch |
| R2 (Object Storage) | `mizchi/js/cloudflare` | 🧪 Tested | Objects/Multipart/Metadata |
| Durable Objects | `mizchi/js/cloudflare` | 🧪 Tested | Storage/Alarms/State |
| **Compute & Network** |
| Workers AI | - | 📅 Planned | AI model inference |
| Vectorize | - | 📅 Planned | Vector database |
| Queues | `mizchi/js/cloudflare` | 🤖 AI Generated | Message queues |
| Workers Analytics Engine | - | 📅 Planned | Analytics data |
| Hyperdrive | - | 📅 Planned | Database acceleration |
| Email Workers | - | 📅 Planned | Email handling |
| Browser Rendering | - | 📅 Planned | Puppeteer API |
| **Security & Auth** |
| Access | - | 📅 Planned | Identity management |
| Turnstile | - | 📅 Planned | CAPTCHA alternative |

### Status Legend

- 🧪 **Tested**: Comprehensive test coverage with Miniflare/Vitest
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

---

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/url",
    "mizchi/js/web/http",
    "mizchi/js/web/worker",
    "mizchi/js/cloudflare"
  ]
}
```

## Supported Services

### KV (Key-Value Storage)

Cloudflare KV is a global, low-latency key-value data store.

**Basic Usage:**

```moonbit
// Get a value
let value = kv.get("my-key").await()

// Put a value
kv.put("my-key", "my-value").await()

// Delete a value
kv.delete("my-key").await()

// List keys
let result = kv.list().await()
```

**Advanced Operations:**

```moonbit
// Get with options
let value = kv.get(
  "my-key",
  type_?=Some("json"),
  cacheTtl?=Some(60)
).await()

// Get as JSON
let json_data = kv.get_json("my-data").await()

// Put with metadata and TTL
kv.put(
  "my-key",
  "my-value",
  expirationTtl?=Some(3600),
  metadata?=Some(js({"version": 1}))
).await()

// List with filtering
let result = kv.list(
  prefix?=Some("user:"),
  limit?=Some(100)
).await()
```

### D1 (SQL Database)

Cloudflare D1 is a serverless SQL database.

**Basic Usage:**

```moonbit
// Prepare and execute a query
let stmt = db.prepare("SELECT * FROM users WHERE id = ?")
let result = stmt.bind1(js(1)).all().await()

// Direct execution
let result = db.exec("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)").await()

// Batch operations
let stmts = [
  db.prepare("INSERT INTO users VALUES (?, ?)").bind2(js(1), js("Alice")),
  db.prepare("INSERT INTO users VALUES (?, ?)").bind2(js(2), js("Bob"))
]
let results = db.batch(stmts).await()
```

**Query Results:**

```moonbit
// Get first row
let first = stmt.first().unwrap()

// Get specific column from first row
let name = stmt.first_col("name").await()

// Get all rows
let result = stmt.all().unwrap()
let rows = result.get_results()

// Raw results as arrays
let raw = stmt.raw().unwrap()
```

### R2 (Object Storage)

Cloudflare R2 is an S3-compatible object storage service.

**Basic Usage:**

```moonbit
// Put an object
let obj = bucket.put("file.txt", js("Hello, World!")).await()

// Get an object
let obj = bucket.get("file.txt").await()
match obj {
  Some(o) => {
    let text = o.text().await()
    // Use text...
  }
  None => ()
}

// Delete an object
bucket.delete("file.txt").await()

// List objects
let objects = bucket.list().await()
```

**Advanced Operations:**

```moonbit
// Put with metadata
let http_meta = R2HttpMetadata::{
  contentType: Some("text/plain"),
  contentLanguage: Some("en"),
  cacheControl: Some("max-age=3600"),
  contentDisposition: None,
  contentEncoding: None,
  cacheExpiry: None
}
bucket.put(
  "file.txt",
  js("content"),
  httpMetadata?=Some(http_meta),
  customMetadata?=Some(js({"author": "Alice"}))
).await()

// Conditional get
let cond = R2Conditional::{
  etagMatches: Some("abc123"),
  etagDoesNotMatch: None,
  uploadedBefore: None,
  uploadedAfter: None
}
let obj = bucket.get(
  "file.txt",
  onlyIf?=Some(cond)
).await()

// List with filtering
let result = bucket.list(
  limit?=Some(1000),
  prefix?=Some("images/"),
  delimiter?=Some("/"),
  include_?=Some(["httpMetadata", "customMetadata"])
).await()

// Multipart upload
let upload = bucket.create_multipart_upload("large-file.bin").await()
let part1 = upload.upload_part(1, js(data1)).await()
let part2 = upload.upload_part(2, js(data2)).await()
let obj = upload.complete([part1, part2]).await()
```

### Durable Objects

Durable Objects provide strongly consistent coordination primitives.

**Namespace Operations:**

```moonbit
// Get by name (deterministic ID)
let stub = namespace.get_by_name("my-object")

// Get by unique ID
let id = namespace.new_unique_id()
let stub = namespace.get(id)

// Get with jurisdiction
let id = namespace.new_unique_id(jurisdiction?=Some("eu"))
```

**Calling Durable Objects:**

```moonbit
// Fetch request
let response = stub.fetch_url("/api/endpoint").await()

// Fetch with init options
let init = js({"method": "POST", "body": "data"})
let response = stub.fetch_url_with_init("/api/endpoint", init).await()
```

**Inside a Durable Object:**

```moonbit
// Access storage
let storage = state.storage()

// Get/Put/Delete
let value = storage.get("counter").await()
storage.put("counter", js(42)).await()
storage.delete("key").await()

// List keys
let entries = storage.list(
  prefix?=Some("user:"),
  limit?=Some(100)
).await()

// Transactions
let closure = js(/* transaction function */)
let result = storage.transaction(closure).await()

// Alarms
storage.set_alarm(timestamp).await()
let alarm_time = storage.get_alarm().await()
storage.delete_alarm().await()

// Wait until
state.wait_until(promise)

// Block concurrency
let callback = js(/* async function */)
state.block_concurrency_while(callback).await()
```

**Storage Options:**

```moonbit
// Get with options
let value = storage.get(
  "key",
  allowConcurrency?=Some(true),
  noCache?=Some(false)
).await()

// Put with options
storage.put(
  "key",
  js(value),
  allowConcurrency?=Some(true),
  allowUnconfirmed?=Some(false),
  noCache?=Some(false)
).await()
```

## Type Conversions

All bindings use `@js.Val` for JavaScript interop:

```moonbit
// Convert to Val
let num = js(42)
let str = js("hello")
let bool = js(true)
let obj = js({"key": "value"})

// Cast from Val
let number : Int = val.cast()
let text : String = val.cast()
```

## Error Handling

Most operations return `Promise[T]` types. Use MoonBit's async/await:

```moonbit
// With error handling
let result = try {
  let value = kv.get("key", None).await()
  Ok(value)
} catch {
  e => Err(e)
}
```

## Testing

This package includes comprehensive tests using `vitest` and `@cloudflare/vitest-pool-workers`.

### Running Tests

```bash
# Run all tests
pnpm test

# Run only Cloudflare tests
pnpm test:cloudflare

# Watch mode
pnpm test:watch
pnpm test:cloudflare:watch
```

### Test Setup

The tests use Miniflare to simulate the Cloudflare Workers environment locally. Configuration is in:

- `vitest.config.ts` - Vitest configuration with workers pool
- `wrangler.toml` - Cloudflare Workers configuration

### Test Coverage

Each service has comprehensive test coverage:

**KV Tests** (`test/cloudflare/kv.test.ts`):
- Basic get/put/delete operations
- Different data types (text, JSON, ArrayBuffer)
- Metadata storage and retrieval
- Expiration and TTL
- List operations with prefix, limit, cursor
- Cache control
- Edge cases (unicode, large values, empty strings)

**D1 Tests** (`test/cloudflare/d1.test.ts`):
- CREATE, INSERT, SELECT, UPDATE, DELETE statements
- Prepared statements with parameter binding
- Query results (all, first, raw)
- Batch operations with transactions
- Metadata (duration, rows affected, last insert ID)
- Error handling (syntax errors, constraints)
- Complex queries (ORDER BY, LIMIT, aggregate functions)

**R2 Tests** (`test/cloudflare/r2.test.ts`):
- Basic put/get/delete/head operations
- Different content types (text, JSON, Blob, ArrayBuffer)
- HTTP metadata (content-type, cache-control, etc.)
- Custom metadata
- Object properties (key, size, etag, version)
- Conditional gets (etag matching)
- Range requests
- List operations with prefix, delimiter, pagination
- Multiple deletes
- Multipart uploads (create, upload parts, complete, abort)
- Edge cases (unicode, large objects, special characters)

**Durable Objects Tests** (`test/cloudflare/durable-objects.test.ts`):
- ID generation (unique, from name, from string)
- ID comparison and properties
- Stub creation and communication
- Storage operations (put, get, delete)
- State persistence across requests
- Alarms (set, get, trigger)
- Concurrent request handling
- Edge cases (unicode keys, large values)
- Jurisdiction options

### Writing New Tests

To add new tests, create a file in `test/cloudflare/` and use the standard vitest API:

```typescript
import { env } from 'cloudflare:test';
import { describe, it, expect } from 'vitest';

describe('My Feature', () => {
  it('should work correctly', async () => {
    const kv = env.TEST_KV as KVNamespace;
    await kv.put('key', 'value');
    const result = await kv.get('key');
    expect(result).toBe('value');
  });
});
```

## References

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [KV Documentation](https://developers.cloudflare.com/kv/)
- [D1 Documentation](https://developers.cloudflare.com/d1/)
- [R2 Documentation](https://developers.cloudflare.com/r2/)
- [Durable Objects Documentation](https://developers.cloudflare.com/durable-objects/)
- [Vitest Pool Workers](https://github.com/cloudflare/workers-sdk/tree/main/fixtures/vitest-pool-workers-examples)
