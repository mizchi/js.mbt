# Cloudflare Workers Tests

This directory contains comprehensive integration tests for Cloudflare Workers bindings implemented in MoonBit.

## Overview

Tests are written using [Vitest](https://vitest.dev/) and [@cloudflare/vitest-pool-workers](https://github.com/cloudflare/workers-sdk/tree/main/fixtures/vitest-pool-workers-examples), which provides a local Miniflare environment that simulates Cloudflare Workers runtime.

## Prerequisites

```bash
pnpm install
```

This will install:
- `vitest` - Test framework
- `@cloudflare/vitest-pool-workers` - Cloudflare Workers test environment
- `wrangler` - Cloudflare Workers CLI

## Running Tests

```bash
# Run all tests
pnpm test

# Run only Cloudflare tests
pnpm test:cloudflare

# Watch mode for development
pnpm test:cloudflare:watch

# Run specific test file
pnpm vitest test/cloudflare/kv.test.ts
```

## Test Files

### `kv.test.ts` - KV Namespace Tests

Tests for Cloudflare KV (Key-Value Storage):

- **Basic Operations**: get, put, delete
- **Data Types**: text, JSON, ArrayBuffer, stream
- **Metadata**: Custom metadata storage and retrieval
- **Expiration**: TTL and absolute expiration timestamps
- **List Operations**: Prefix filtering, pagination with cursors, limits
- **Cache Control**: cacheTtl option
- **Edge Cases**: Unicode, empty strings, large values, key overwrites

**Example:**
```typescript
it('should put and get a value', async () => {
  await TEST_KV.put('test-key', 'test-value');
  const value = await TEST_KV._get('test-key');
  expect(value).toBe('test-value');
});
```

### `d1.test.ts` - D1 Database Tests

Tests for Cloudflare D1 (Serverless SQL Database):

- **Basic Operations**: CREATE, INSERT, SELECT, UPDATE, DELETE
- **Prepared Statements**: Parameter binding with type safety
- **Query Results**: .all(), .first(), .first(column), .raw()
- **Batch Operations**: Transactional multi-statement execution
- **Metadata**: Query duration, rows read/written, last insert ID
- **Error Handling**: SQL errors, constraint violations
- **Complex Queries**: Aggregations, GROUP BY, ORDER BY, LIMIT/OFFSET

**Example:**
```typescript
it('should prepare and execute INSERT', async () => {
  const stmt = TEST_DB.prepare('INSERT INTO users (name, age) VALUES (?, ?)');
  const result = await stmt.bind('Alice', 30).run();
  expect(result.success).toBe(true);
  expect(result.meta?.last_row_id).toBeGreaterThan(0);
});
```

### `r2.test.ts` - R2 Object Storage Tests

Tests for Cloudflare R2 (S3-compatible Object Storage):

- **Basic Operations**: put, get, delete, head
- **Content Types**: text, JSON, Blob, ArrayBuffer
- **HTTP Metadata**: content-type, cache-control, content-disposition
- **Custom Metadata**: User-defined key-value pairs
- **Object Properties**: key, size, etag, version, uploaded timestamp
- **Conditional Gets**: etag matching, upload time conditions
- **Range Requests**: Byte ranges, suffix ranges
- **List Operations**: Prefix, delimiter, pagination, metadata inclusion
- **Multipart Uploads**: Create, upload parts, complete, abort, resume
- **Edge Cases**: Unicode, large objects, empty content

**Example:**
```typescript
it('should put and get an object', async () => {
  await TEST_R2.put('file.txt', 'Hello, R2!');
  const obj = await TEST_R2._get('file.txt');
  const text = await obj!.text();
  expect(text).toBe('Hello, R2!');
});
```

### `durable-objects.test.ts` - Durable Objects Tests

Tests for Cloudflare Durable Objects (Stateful coordination):

- **ID Generation**: Unique IDs, deterministic name-based IDs
- **ID Operations**: toString, equals, name property
- **Namespace Operations**: get stub, create IDs with jurisdiction
- **Stub Communication**: fetch requests, POST with body
- **Storage Operations**: put, get, delete, persistence
- **State Isolation**: Separate state per DO instance
- **Alarms**: Set, get, trigger scheduled execution
- **Concurrency**: Handling concurrent requests
- **Edge Cases**: Unicode keys, large values, empty strings

**Example:**
```typescript
it('should increment counter across requests', async () => {
  const stub = namespace._get(namespace.idFromName('counter'));
  
  await stub.fetch('http://fake-host/increment');
  await stub.fetch('http://fake-host/increment');
  
  const resp = await stub.fetch('http://fake-host/get');
  const data = await resp.json();
  expect(data.counter).toBe(2);
});
```

## Test Configuration

### `vitest.config.ts`

Configures Vitest with the Cloudflare Workers pool:

```typescript
export default defineWorkersConfig({
  test: {
    poolOptions: {
      workers: {
        wrangler: { configPath: './wrangler.toml' },
        miniflare: {
          kvNamespaces: ['TEST_KV'],
          d1Databases: ['TEST_DB'],
          r2Buckets: ['TEST_R2'],
          durableObjects: { TEST_DO: 'TestDurableObject' },
        },
      },
    },
  },
});
```

### `wrangler.toml`

Defines Cloudflare Workers bindings for testing:

```toml
[env.test]
[[env.test.kv_namespaces]]
binding = "TEST_KV"
id = "test-kv-id"

[[env.test.d1_databases]]
binding = "TEST_DB"
database_name = "test-db"

[[env.test.r2_buckets]]
binding = "TEST_R2"
bucket_name = "test-r2"

[[env.test.durable_objects.bindings]]
name = "TEST_DO"
class_name = "TestDurableObject"
```

## Writing New Tests

### 1. Import Test Utilities

```typescript
import { env } from 'cloudflare:test';
import { describe, it, expect, beforeEach } from 'vitest';
```

### 2. Access Bindings

```typescript
describe('My Feature', () => {
  const TEST_KV = env.TEST_KV as KVNamespace;
  const TEST_DB = env.TEST_DB as D1Database;
  const TEST_R2 = env.TEST_R2 as R2Bucket;
  const TEST_DO = env.TEST_DO as DurableObjectNamespace;
});
```

### 3. Clean Up Test Data

```typescript
beforeEach(async () => {
  // Clean up KV
  const keys = await TEST_KV.list();
  for (const key of keys.keys) {
    await TEST_KV.delete(key.name);
  }
  
  // Clean up R2
  const objects = await TEST_R2.list();
  for (const obj of objects.objects) {
    await TEST_R2.delete(obj.key);
  }
  
  // Clean up D1
  await TEST_DB.exec('DROP TABLE IF EXISTS test_table');
});
```

### 4. Write Tests

```typescript
it('should test my feature', async () => {
  // Arrange
  await TEST_KV.put('key', 'value');
  
  // Act
  const result = await TEST_KV._get('key');
  
  // Assert
  expect(result).toBe('value');
});
```

## Best Practices

1. **Isolation**: Each test should be independent and not rely on other tests
2. **Cleanup**: Use `beforeEach` or `afterEach` to clean up test data
3. **Async/Await**: All Cloudflare API calls are asynchronous
4. **Type Safety**: Use TypeScript types from `@cloudflare/workers-types`
5. **Descriptive Names**: Use clear, descriptive test names
6. **Edge Cases**: Test boundary conditions, errors, and edge cases
7. **Assertions**: Use specific assertions (toBe, toEqual, toBeGreaterThan, etc.)

## Debugging

### Enable Verbose Logging

```bash
DEBUG=* pnpm test:cloudflare
```

### Run Single Test

```bash
pnpm vitest test/cloudflare/kv.test.ts -t "should put and get a value"
```

### Use --ui for Interactive Debugging

```bash
pnpm vitest --ui test/cloudflare
```

## Common Issues

### "Module not found: cloudflare:test"

Make sure you're using `@cloudflare/vitest-pool-workers` and the config is set up correctly.

### Binding Not Available

Check `wrangler.toml` and `vitest.config.ts` to ensure bindings are properly configured.

### Tests Timeout

Increase timeout in vitest config:

```typescript
export default defineWorkersConfig({
  test: {
    testTimeout: 30000, // 30 seconds
  },
});
```

### Type Errors

Install `@cloudflare/workers-types`:

```bash
pnpm add -D @cloudflare/workers-types
```

## CI/CD Integration

For GitHub Actions:

```yaml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm test:cloudflare
```

## Resources

- [Vitest Documentation](https://vitest.dev/)
- [Vitest Pool Workers](https://github.com/cloudflare/workers-sdk/tree/main/fixtures/vitest-pool-workers-examples)
- [Miniflare Documentation](https://miniflare.dev/)
- [Cloudflare Workers Testing Guide](https://developers.cloudflare.com/workers/testing/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
