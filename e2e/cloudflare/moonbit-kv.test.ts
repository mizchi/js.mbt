import { describe, it, expect, beforeEach } from "vitest";

// Import the worker
const workerPath = "./fixtures/cf-worker-kv.js";
let handler: any;

beforeEach(async () => {
  const module = await import(workerPath);
  handler = module.default.fetch;
});

describe("Cloudflare Worker KV - MoonBit", () => {
  it("should return help/endpoints at root", async () => {
    const request = new Request("http://localhost/");
    const env = { MY_KV: new Map() }; // Mock KV
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.endpoints).toBeDefined();
    expect(Array.isArray(body.endpoints)).toBe(true);
  });

  it("should put and get a key-value pair", async () => {
    // Create a mock KV namespace
    const kvStore = new Map();
    const mockKV = {
      get: async (key: string) => kvStore.get(key) || null,
      put: async (key: string, value: string) => {
        kvStore.set(key, value);
      },
      delete: async (key: string) => {
        kvStore.delete(key);
      },
      list: async () => ({
        keys: Array.from(kvStore.keys()).map((name) => ({ name })),
      }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    // Put a value
    const putRequest = new Request(
      "http://localhost/kv/put?key=test&value=hello",
    );
    const putResponse = await handler(putRequest, env, ctx);
    expect(putResponse.status).toBe(200);

    const putBody = await putResponse.json();
    expect(putBody.success).toBe(true);
    expect(putBody.key).toBe("test");

    // Get the value back
    const getRequest = new Request("http://localhost/kv/get?key=test");
    const getResponse = await handler(getRequest, env, ctx);
    expect(getResponse.status).toBe(200);

    const getBody = await getResponse.json();
    expect(getBody.key).toBe("test");
    expect(getBody.value).toBe("hello");
  });

  it("should return 404 for non-existent key", async () => {
    const mockKV = {
      get: async (key: string) => null,
      put: async (key: string, value: string) => {},
      delete: async (key: string) => {},
      list: async () => ({ keys: [] }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const request = new Request("http://localhost/kv/get?key=nonexistent");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(404);

    const body = await response.json();
    expect(body.error).toBe("Key not found");
  });

  it("should delete a key", async () => {
    const kvStore = new Map();
    kvStore.set("toDelete", "value");

    const mockKV = {
      get: async (key: string) => kvStore.get(key) || null,
      put: async (key: string, value: string) => {
        kvStore.set(key, value);
      },
      delete: async (key: string) => {
        kvStore.delete(key);
      },
      list: async () => ({
        keys: Array.from(kvStore.keys()).map((name) => ({ name })),
      }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const request = new Request("http://localhost/kv/delete?key=toDelete");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.success).toBe(true);
    expect(kvStore.has("toDelete")).toBe(false);
  });

  it("should increment counter", async () => {
    const kvStore = new Map();

    const mockKV = {
      get: async (key: string) => kvStore.get(key) || null,
      put: async (key: string, value: string) => {
        kvStore.set(key, value);
      },
      delete: async (key: string) => {
        kvStore.delete(key);
      },
      list: async () => ({
        keys: Array.from(kvStore.keys()).map((name) => ({ name })),
      }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    // First increment (from 0)
    const inc1Request = new Request("http://localhost/kv/counter/increment");
    const inc1Response = await handler(inc1Request, env, ctx);
    expect(inc1Response.status).toBe(200);

    const inc1Body = await inc1Response.json();
    expect(inc1Body.counter).toBe(1);

    // Second increment
    const inc2Request = new Request("http://localhost/kv/counter/increment");
    const inc2Response = await handler(inc2Request, env, ctx);
    expect(inc2Response.status).toBe(200);

    const inc2Body = await inc2Response.json();
    expect(inc2Body.counter).toBe(2);

    // Get counter
    const getRequest = new Request("http://localhost/kv/counter/get");
    const getResponse = await handler(getRequest, env, ctx);
    expect(getResponse.status).toBe(200);

    const getBody = await getResponse.json();
    expect(getBody.counter).toBe(2);
  });

  it("should list keys", async () => {
    const kvStore = new Map();
    kvStore.set("key1", "value1");
    kvStore.set("key2", "value2");
    kvStore.set("key3", "value3");

    const mockKV = {
      get: async (key: string) => kvStore.get(key) || null,
      put: async (key: string, value: string) => {
        kvStore.set(key, value);
      },
      delete: async (key: string) => {
        kvStore.delete(key);
      },
      list: async () => ({
        keys: Array.from(kvStore.keys()).map((name) => ({ name })),
      }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const request = new Request("http://localhost/kv/list");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.count).toBe(3);
    expect(body.keys).toContain("key1");
    expect(body.keys).toContain("key2");
    expect(body.keys).toContain("key3");
  });

  it("should return 400 for missing parameters", async () => {
    const mockKV = {
      get: async (key: string) => null,
      put: async (key: string, value: string) => {},
      delete: async (key: string) => {},
      list: async () => ({ keys: [] }),
    };

    const env = { MY_KV: mockKV };
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    // Get without key
    const getRequest = new Request("http://localhost/kv/get");
    const getResponse = await handler(getRequest, env, ctx);
    expect(getResponse.status).toBe(400);

    // Put without value
    const putRequest = new Request("http://localhost/kv/put?key=test");
    const putResponse = await handler(putRequest, env, ctx);
    expect(putResponse.status).toBe(400);

    // Delete without key
    const deleteRequest = new Request("http://localhost/kv/delete");
    const deleteResponse = await handler(deleteRequest, env, ctx);
    expect(deleteResponse.status).toBe(400);
  });
});
