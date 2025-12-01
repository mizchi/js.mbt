import { env, SELF } from "cloudflare:test";
import { describe, it, expect, beforeEach } from "vitest";

// Mock Durable Object class for testing
export class TestDurableObject implements DurableObject {
  private state: DurableObjectState;

  constructor(state: DurableObjectState, env: Env) {
    this.state = state;
  }

  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // Simple counter endpoint
    if (path === "/increment") {
      const current = (await this.state.storage.get<number>("counter")) || 0;
      const newValue = current + 1;
      await this.state.storage.put("counter", newValue);
      return new Response(JSON.stringify({ counter: newValue }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Get counter value
    if (path === "/get") {
      const counter = (await this.state.storage.get<number>("counter")) || 0;
      return new Response(JSON.stringify({ counter }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Reset counter
    if (path === "/reset") {
      await this.state.storage.delete("counter");
      return new Response(JSON.stringify({ counter: 0 }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Test storage operations
    if (path === "/storage/put" && request.method === "POST") {
      const data = await request.json<{ key: string; value: any }>();
      await this.state.storage.put(data.key, data.value);
      return new Response("OK");
    }

    if (path === "/storage/get") {
      const key = url.searchParams._get("key");
      if (!key) return new Response("Missing key", { status: 400 });
      const value = await this.state.storage._get(key);
      return new Response(JSON.stringify({ value }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Test alarm
    if (path === "/alarm/set") {
      const timestamp = parseInt(url.searchParams._get("timestamp") || "0");
      await this.state.storage.setAlarm(timestamp);
      return new Response("Alarm set");
    }

    if (path === "/alarm/get") {
      const alarm = await this.state.storage.getAlarm();
      return new Response(JSON.stringify({ alarm }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    return new Response("Not found", { status: 404 });
  }

  async alarm(): Promise<void> {
    const current =
      (await this.state.storage.get<number>("alarm_counter")) || 0;
    await this.state.storage.put("alarm_counter", current + 1);
  }
}

describe("Durable Objects - Namespace", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;

  describe("ID Generation", () => {
    it("should create unique IDs", () => {
      const id1 = namespace.newUniqueId();
      const id2 = namespace.newUniqueId();
      expect(id1.toString()).not.toBe(id2.toString());
    });

    it("should create deterministic IDs from names", () => {
      const id1 = namespace.idFromName("test-object");
      const id2 = namespace.idFromName("test-object");
      expect(id1.toString()).toBe(id2.toString());
    });

    it("should create different IDs for different names", () => {
      const id1 = namespace.idFromName("object-1");
      const id2 = namespace.idFromName("object-2");
      expect(id1.toString()).not.toBe(id2.toString());
    });

    it("should create ID from string", () => {
      const id1 = namespace.newUniqueId();
      const idString = id1.toString();
      const id2 = namespace.idFromString(idString);
      expect(id2.toString()).toBe(idString);
    });

    it("should get name from named ID", () => {
      const id = namespace.idFromName("my-named-object");
      expect(id.name).toBe("my-named-object");
    });

    it("should return undefined name for unique ID", () => {
      const id = namespace.newUniqueId();
      expect(id.name).toBeUndefined();
    });
  });

  describe("ID Comparison", () => {
    it("should compare IDs for equality", () => {
      const name = "comparison-test";
      const id1 = namespace.idFromName(name);
      const id2 = namespace.idFromName(name);
      expect(id1.equals(id2)).toBe(true);
    });

    it("should return false for different IDs", () => {
      const id1 = namespace.idFromName("obj1");
      const id2 = namespace.idFromName("obj2");
      expect(id1.equals(id2)).toBe(false);
    });
  });

  describe("Stub Creation", () => {
    it("should get stub from ID", () => {
      const id = namespace.newUniqueId();
      const stub = namespace._get(id);
      expect(stub).toBeDefined();
      expect(stub.id.toString()).toBe(id.toString());
    });

    it("should get stub from name", () => {
      const name = "named-stub";
      const stub = namespace._get(namespace.idFromName(name));
      expect(stub).toBeDefined();
      expect(stub.name).toBe(name);
    });
  });
});

describe("Durable Objects - Stub Communication", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;

  it("should send fetch request to DO", async () => {
    const id = namespace.idFromName("fetch-test");
    const stub = namespace._get(id);

    const response = await stub.fetch("http://fake-host/get");
    expect(response.status).toBe(200);
    const data = await response.json<{ counter: number }>();
    expect(data.counter).toBe(0);
  });

  it("should increment counter across requests", async () => {
    const id = namespace.idFromName("counter-test");
    const stub = namespace._get(id);

    try {
      // Reset first
      const resetResp = await stub.fetch("http://fake-host/reset");
      await resetResp.text(); // Consume response body

      // Increment
      const resp1 = await stub.fetch("http://fake-host/increment");
      const data1 = await resp1.json<{ counter: number }>();
      expect(data1.counter).toBe(1);

      // Increment again
      const resp2 = await stub.fetch("http://fake-host/increment");
      const data2 = await resp2.json<{ counter: number }>();
      expect(data2.counter).toBe(2);
    } finally {
      // Ensure cleanup
      const cleanupResp = await stub.fetch("http://fake-host/reset");
      await cleanupResp.text();
    }
  });

  it("should maintain separate state per DO instance", async () => {
    const stub1 = namespace._get(namespace.idFromName("instance-1"));
    const stub2 = namespace._get(namespace.idFromName("instance-2"));

    await stub1.fetch("http://fake-host/reset");
    await stub2.fetch("http://fake-host/reset");

    await stub1.fetch("http://fake-host/increment");
    await stub1.fetch("http://fake-host/increment");

    await stub2.fetch("http://fake-host/increment");

    const resp1 = await stub1.fetch("http://fake-host/get");
    const data1 = await resp1.json<{ counter: number }>();
    expect(data1.counter).toBe(2);

    const resp2 = await stub2.fetch("http://fake-host/get");
    const data2 = await resp2.json<{ counter: number }>();
    expect(data2.counter).toBe(1);
  });

  it("should send POST request with body", async () => {
    const id = namespace.idFromName("post-test");
    const stub = namespace._get(id);

    const response = await stub.fetch("http://fake-host/storage/put", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ key: "test-key", value: "test-value" }),
    });

    expect(response.status).toBe(200);

    // Verify it was stored
    const getResp = await stub.fetch(
      "http://fake-host/storage/get?key=test-key",
    );
    const data = await getResp.json<{ value: string }>();
    expect(data.value).toBe("test-value");
  });
});

describe("Durable Objects - Storage", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;
  let stub: DurableObjectStub;

  beforeEach(async () => {
    stub = namespace._get(namespace.idFromName("storage-test-" + Date.now()));
    await stub.fetch("http://fake-host/reset");
  });

  describe("Basic Operations", () => {
    it("should store and retrieve values", async () => {
      await stub.fetch("http://fake-host/storage/put", {
        method: "POST",
        body: JSON.stringify({ key: "name", value: "Alice" }),
      });

      const resp = await stub.fetch("http://fake-host/storage/get?key=name");
      const data = await resp.json<{ value: string }>();
      expect(data.value).toBe("Alice");
    });

    it("should store different data types", async () => {
      const testCases = [
        { key: "string", value: "text" },
        { key: "number", value: 42 },
        { key: "boolean", value: true },
        { key: "object", value: { nested: "data" } },
        { key: "array", value: [1, 2, 3] },
      ];

      for (const { key, value } of testCases) {
        await stub.fetch("http://fake-host/storage/put", {
          method: "POST",
          body: JSON.stringify({ key, value }),
        });

        const resp = await stub.fetch(
          `http://fake-host/storage/get?key=${key}`,
        );
        const data = await resp.json<{ value: any }>();
        expect(data.value).toEqual(value);
      }
    });

    it("should return null for non-existent keys", async () => {
      const resp = await stub.fetch(
        "http://fake-host/storage/get?key=non-existent",
      );
      const data = await resp.json<{ value: any }>();
      expect(data.value).toBeNull();
    });

    it("should overwrite existing values", async () => {
      await stub.fetch("http://fake-host/storage/put", {
        method: "POST",
        body: JSON.stringify({ key: "mutable", value: "first" }),
      });

      await stub.fetch("http://fake-host/storage/put", {
        method: "POST",
        body: JSON.stringify({ key: "mutable", value: "second" }),
      });

      const resp = await stub.fetch("http://fake-host/storage/get?key=mutable");
      const data = await resp.json<{ value: string }>();
      expect(data.value).toBe("second");
    });
  });

  describe("State Persistence", () => {
    it("should persist state across multiple requests", async () => {
      const id = namespace.idFromName("persistent-state");
      const stub = namespace._get(id);

      await stub.fetch("http://fake-host/reset");

      // Multiple increments
      for (let i = 0; i < 5; i++) {
        await stub.fetch("http://fake-host/increment");
      }

      const resp = await stub.fetch("http://fake-host/get");
      const data = await resp.json<{ counter: number }>();
      expect(data.counter).toBe(5);
    });
  });
});

describe("Durable Objects - Alarms", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;
  let stub: DurableObjectStub;

  beforeEach(() => {
    stub = namespace._get(namespace.idFromName("alarm-test-" + Date.now()));
  });

  it("should set and get alarm", async () => {
    const futureTimestamp = Date.now() + 60000; // 1 minute from now

    await stub.fetch(`http://fake-host/alarm/set?timestamp=${futureTimestamp}`);

    const resp = await stub.fetch("http://fake-host/alarm/get");
    const data = await resp.json<{ alarm: number | null }>();
    expect(data.alarm).toBe(futureTimestamp);
  });

  it("should return null when no alarm is set", async () => {
    const resp = await stub.fetch("http://fake-host/alarm/get");
    const data = await resp.json<{ alarm: number | null }>();
    expect(data.alarm).toBeNull();
  });
});

describe("Durable Objects - Edge Cases", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;

  it("should handle concurrent requests to same DO", async () => {
    const id = namespace.idFromName("concurrent-test");
    const stub = namespace._get(id);

    await stub.fetch("http://fake-host/reset");

    // Send multiple concurrent increment requests
    const promises = Array.from({ length: 10 }, () =>
      stub.fetch("http://fake-host/increment"),
    );

    await Promise.all(promises);

    const resp = await stub.fetch("http://fake-host/get");
    const data = await resp.json<{ counter: number }>();
    // All increments should be processed
    expect(data.counter).toBe(10);
  });

  it("should handle unicode in storage keys", async () => {
    const stub = namespace._get(namespace.idFromName("unicode-test"));

    await stub.fetch("http://fake-host/storage/put", {
      method: "POST",
      body: JSON.stringify({ key: "emoji-🚀", value: "rocket" }),
    });

    const resp = await stub.fetch("http://fake-host/storage/get?key=emoji-🚀");
    const data = await resp.json<{ value: string }>();
    expect(data.value).toBe("rocket");
  });

  it("should handle large values in storage", async () => {
    const stub = namespace._get(namespace.idFromName("large-value-test"));
    const largeValue = "x".repeat(100000);

    await stub.fetch("http://fake-host/storage/put", {
      method: "POST",
      body: JSON.stringify({ key: "large", value: largeValue }),
    });

    const resp = await stub.fetch("http://fake-host/storage/get?key=large");
    const data = await resp.json<{ value: string }>();
    expect(data.value).toBe(largeValue);
  });

  it("should handle empty string values", async () => {
    const stub = namespace._get(namespace.idFromName("empty-string-test"));

    await stub.fetch("http://fake-host/storage/put", {
      method: "POST",
      body: JSON.stringify({ key: "empty", value: "" }),
    });

    const resp = await stub.fetch("http://fake-host/storage/get?key=empty");
    const data = await resp.json<{ value: string }>();
    expect(data.value).toBe("");
  });
});

describe("Durable Objects - ID Options", () => {
  const namespace = env.TEST_DO as DurableObjectNamespace;

  it("should create ID with jurisdiction option", () => {
    const id = namespace.newUniqueId({ jurisdiction: "eu" });
    expect(id).toBeDefined();
    expect(id.toString()).toBeTruthy();
  });

  it("should create ID with fedramp jurisdiction", () => {
    const id = namespace.newUniqueId({ jurisdiction: "fedramp" });
    expect(id).toBeDefined();
    expect(id.toString()).toBeTruthy();
  });
});
