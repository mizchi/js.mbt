// Worker entry point for Cloudflare Workers testing
// This file exports a TestDurableObject implementation for vitest-pool-workers

export interface Env {
  TEST_KV: KVNamespace;
  TEST_DB: D1Database;
  TEST_R2: R2Bucket;
  TEST_DO: DurableObjectNamespace;
}

// Default fetch handler (not used in tests)
export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext,
  ): Promise<Response> {
    return new Response("Test worker", { status: 200 });
  },
};

// Test Durable Object implementation
export class TestDurableObject implements DurableObject {
  private state: DurableObjectState;
  private env: Env;

  constructor(state: DurableObjectState, env: Env) {
    this.state = state;
    this.env = env;
  }

  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    try {
      // Counter operations
      if (path === "/increment") {
        const current = (await this.state.storage.get<number>("counter")) || 0;
        const newValue = current + 1;
        await this.state.storage.put("counter", newValue);
        return new Response(JSON.stringify({ counter: newValue }), {
          headers: { "Content-Type": "application/json" },
        });
      }

      if (path === "/get") {
        const counter = (await this.state.storage.get<number>("counter")) || 0;
        return new Response(JSON.stringify({ counter }), {
          headers: { "Content-Type": "application/json" },
        });
      }

      if (path === "/reset") {
        await this.state.storage.delete("counter");
        return new Response(JSON.stringify({ counter: 0 }), {
          headers: { "Content-Type": "application/json" },
        });
      }

      // Storage operations
      if (path === "/storage/put" && request.method === "POST") {
        const data = await request.json<{ key: string; value: any }>();
        await this.state.storage.put(data.key, data.value);
        return new Response("OK");
      }

      if (path === "/storage/get") {
        const key = url.searchParams.get("key");
        if (!key) {
          return new Response("Missing key", { status: 400 });
        }
        const value = await this.state.storage.get(key);
        return new Response(JSON.stringify({ value }), {
          headers: { "Content-Type": "application/json" },
        });
      }

      // Alarm operations
      if (path === "/alarm/set") {
        const timestamp = parseInt(url.searchParams.get("timestamp") || "0");
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
    } catch (error) {
      return new Response(
        JSON.stringify({
          error: error instanceof Error ? error.message : "Unknown error",
        }),
        {
          status: 500,
          headers: { "Content-Type": "application/json" },
        },
      );
    }
  }

  async alarm(): Promise<void> {
    const current =
      (await this.state.storage.get<number>("alarm_counter")) || 0;
    await this.state.storage.put("alarm_counter", current + 1);
  }
}
