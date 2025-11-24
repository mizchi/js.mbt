import { env } from "cloudflare:test";
import { describe, it, expect } from "vitest";
import { get_kv_handler } from "../../target/js/release/build/examples/cfw/cfw.js";

describe("Cloudflare Worker KV - MoonBit", () => {
  const handler = get_kv_handler();
  it("should return help/endpoints at root", async () => {
    const request = new Request("http://localhost/");
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.endpoints).toBeDefined();
    expect(Array.isArray(body.endpoints)).toBe(true);
  });

  it("should put and get a key-value pair", async () => {
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
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    const request = new Request("http://localhost/kv/get?key=nonexistent");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(404);

    const body = await response.json();
    expect(body.error).toBe("Key not found");
  });

  it("should delete a key", async () => {
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    // First put a value
    const putRequest = new Request("http://localhost/kv/put?key=toDelete&value=value");
    await handler(putRequest, env, ctx);

    // Then delete it
    const request = new Request("http://localhost/kv/delete?key=toDelete");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.success).toBe(true);

    // Verify it's deleted
    const getRequest = new Request("http://localhost/kv/get?key=toDelete");
    const getResponse = await handler(getRequest, env, ctx);
    expect(getResponse.status).toBe(404);
  });

  it("should increment counter", async () => {
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
    const ctx = { waitUntil: () => {}, passThroughOnException: () => {} };

    // Put some values first
    await handler(new Request("http://localhost/kv/put?key=key1&value=value1"), env, ctx);
    await handler(new Request("http://localhost/kv/put?key=key2&value=value2"), env, ctx);
    await handler(new Request("http://localhost/kv/put?key=key3&value=value3"), env, ctx);

    const request = new Request("http://localhost/kv/list");
    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.count).toBeGreaterThanOrEqual(3);
    expect(body.keys).toContain("key1");
    expect(body.keys).toContain("key2");
    expect(body.keys).toContain("key3");
  });

  it("should return 400 for missing parameters", async () => {
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
