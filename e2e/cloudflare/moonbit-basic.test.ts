import { describe, it, expect } from "vitest";
import { get_fetch_handler } from "../../target/js/release/build/examples/cfw/cfw.js";

describe("MoonBit Cloudflare Worker - Basic HTTP Routes", () => {
  const handler = get_fetch_handler();

  it("should return HTML homepage at /", async () => {
    const request = new Request("http://localhost/");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const text = await response.text();
    expect(text).toContain("Cloudflare Worker with MoonBit");
    expect(text).toContain("Available routes");
  });

  it("should return JSON at /api/hello", async () => {
    const request = new Request("http://localhost/api/hello");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);
    expect(response.headers.get("content-type")).toContain("application/json");

    const json = await response.json();
    expect(json.message).toBe("Hello from MoonBit Worker!");
  });

  it("should echo URL at /api/echo", async () => {
    const testUrl = "http://localhost/api/echo";
    const request = new Request(testUrl);
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const json = await response.json();
    expect(json.url).toBe(testUrl);
  });

  it("should return plain text at /api/text", async () => {
    const request = new Request("http://localhost/api/text");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);
    expect(response.headers.get("content-type")).toContain("text/plain");

    const text = await response.text();
    expect(text).toBe("Plain text response from MoonBit");
  });

  it("should return 404 for unknown routes", async () => {
    const request = new Request("http://localhost/unknown/route");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(404);

    const json = await response.json();
    expect(json.error).toBe("Route not found");
  });

  it("should return custom headers at /api/headers", async () => {
    const request = new Request("http://localhost/api/headers");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);
    expect(response.headers.get("x-custom-header")).toBe("MoonBit-Worker");
    expect(response.headers.get("x-powered-by")).toBe("Cloudflare");
  });

  it("should parse query parameters at /api/query", async () => {
    const request = new Request(
      "http://localhost/api/query?name=Alice&message=Hi",
    );
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.greeting).toBe("Hi, Alice!");
  });

  it("should use defaults for missing query parameters", async () => {
    const request = new Request("http://localhost/api/query");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.greeting).toBe("Hello, World!");
  });

  it("should return health status", async () => {
    const request = new Request("http://localhost/health");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.status).toBe("healthy");
    expect(body.service).toBe("moonbit-worker");
  });

  it("should handle math add endpoint", async () => {
    const request = new Request("http://localhost/api/math/add?a=5&b=3");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body.result).toBeDefined();
  });

  it("should return 400 for missing math parameters", async () => {
    const request = new Request("http://localhost/api/math/add?a=5");
    const env = {};
    const ctx = { waitUntil: () => { }, passThroughOnException: () => { } };

    const response = await handler(request, env, ctx);
    expect(response.status).toBe(400);

    const body = await response.json();
    expect(body.error).toBeDefined();
  });
});
