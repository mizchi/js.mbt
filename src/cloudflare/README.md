# Cloudflare Workers Bindings for MoonBit

This package provides type-safe MoonBit bindings for Cloudflare Workers platform services.

## Cloudflare Services Support Status

| Service | Package | Status | Note |
|---------|---------|--------|------|
| **Core Platform** |
| Workers Runtime | `mizchi/js/cloudflare` | ✅ Tested | Basic runtime bindings |
| Environment Context | `mizchi/js/cloudflare` | ✅ Tested | Env/ExecutionContext |
| **Storage Services** |
| KV (Key-Value) | `mizchi/js/cloudflare` | ✅ Tested | Get/Put/Delete/List |
| D1 (SQL Database) | `mizchi/js/cloudflare` | ✅ Tested | Queries/Prepared/Batch |
| R2 (Object Storage) | `mizchi/js/cloudflare` | ✅ Tested | Objects/Multipart/Metadata |
| Durable Objects | `mizchi/js/cloudflare` | ✅ Tested | Storage/Alarms/State |
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

- ✅ **Tested**: Comprehensive test coverage with Miniflare/Vitest
- 🤖 **AI Generated**: FFI bindings created, needs testing
- 📅 **Planned**: Scheduled for future implementation

---

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/url",
    "mizchi/js/http",
    "mizchi/js/worker",
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
let value = kv.get("my-key", None).await()

// Put a value
kv.put("my-key", "my-value", None).await()

// Delete a value
kv.delete("my-key").await()

// List keys
let result = kv.list(None).await()
```

**Advanced Operations:**

```moonbit
// Get with options
let options = { type_: Some("json"), cache_ttl: Some(60) }
let value = kv.get("my-key", Some(options)).await()

// Get as JSON
let json_data = kv.get_json("my-data").await()

// Put with metadata and TTL
let put_opts = { 
  expiration: None,
  expiration_ttl: Some(3600), 
  metadata: Some(js({"version": 1}))
}
kv.put("my-key", "my-value", Some(put_opts)).await()

// List with filtering
let list_opts = { prefix: Some("user:"), limit: Some(100), cursor: None }
let result = kv.list(Some(list_opts)).await()
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
let http_meta = {
  content_type: Some("text/plain"),
  content_language: Some("en"),
  cache_control: Some("max-age=3600"),
  content_disposition: None,
  content_encoding: None,
  cache_expiry: None
}
let put_opts = { 
  http_metadata: Some(http_meta),
  custom_metadata: Some(js({"author": "Alice"})),
  md5: None, sha1: None, sha256: None, sha384: None, sha512: None
}
bucket.put_with_options("file.txt", js("content"), put_opts).await()

// Conditional get
let cond = {
  etag_matches: Some("abc123"),
  etag_does_not_match: None,
  uploaded_before: None,
  uploaded_after: None
}
let get_opts = { only_if: Some(cond), range: None }
let obj = bucket.get_with_options("file.txt", get_opts).await()

// List with filtering
let list_opts = {
  limit: Some(1000),
  prefix: Some("images/"),
  cursor: None,
  delimiter: Some("/"),
  start_after: None,
  include_: Some(["httpMetadata", "customMetadata"])
}
let result = bucket.list_with_options(list_opts).await()

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
let opts = { jurisdiction: Some("eu") }
let id = namespace.new_unique_id_with_options(opts)
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
let list_opts = {
  prefix: Some("user:"),
  limit: Some(100),
  start: None, start_after: None, end: None,
  reverse: None,
  allow_concurrency: None, no_cache: None
}
let entries = storage.list_with_options(list_opts).await()

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
let opts = { allow_concurrency: Some(true), no_cache: Some(false) }
let value = storage.get_with_options("key", opts).await()

// Put with options
let opts = { 
  allow_concurrency: Some(true), 
  allow_unconfirmed: Some(false),
  no_cache: Some(false)
}
storage.put_with_options("key", js(value), opts).await()
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
