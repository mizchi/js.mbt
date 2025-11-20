import { env } from "cloudflare:test";
import { describe, it, expect, beforeEach, afterEach } from "vitest";

describe("D1 Database with MoonBit bind implementation", () => {
  const TEST_DB = env.TEST_DB as D1Database;

  beforeEach(async () => {
    // Create test table using prepare().run() instead of exec()
    await TEST_DB.prepare(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        age INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `).run();
  });

  afterEach(async () => {
    // Clean up using prepare().run() instead of exec()
    await TEST_DB.prepare("DROP TABLE IF EXISTS users").run();
  });

  describe("MoonBit-style bind with Array", () => {
    it("should work when using Function.prototype.apply for spreading", async () => {
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );

      // Simulate MoonBit's bind implementation using apply
      const params = ["Alice", "alice@example.com", 30];
      const bindFn = (stmt as any).bind;
      const boundStmt = bindFn.apply(stmt, params);

      const result = await boundStmt.run();
      expect(result.success).toBe(true);
      expect(result.meta?.last_row_id).toBeGreaterThan(0);
    });

    it("should retrieve data after MoonBit-style insert", async () => {
      const insertStmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      const params = ["Bob", "bob@example.com", 25];
      const bindFn = (insertStmt as any).bind;
      await bindFn.apply(insertStmt, params).run();

      const result = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Bob")
        .all();

      expect(result.success).toBe(true);
      expect(result.results).toBeDefined();
      expect(result.results?.length).toBe(1);
      expect(result.results?.[0].name).toBe("Bob");
    });

    it("should work with different parameter types", async () => {
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      const params = ["Charlie", "charlie@example.com", 35];
      const bindFn = (stmt as any).bind;
      const result = await bindFn.apply(stmt, params).run();

      expect(result.success).toBe(true);

      const selectResult = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Charlie")
        .first();

      expect(selectResult?.age).toBe(35);
    });
  });

  describe("Comparison: Direct bind vs Apply", () => {
    it("both methods should produce identical results", async () => {
      // Direct bind (current TypeScript approach)
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      ).bind("DirectUser", "direct@example.com", 40).run();

      // Apply-based bind (MoonBit approach)
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      const params = ["ApplyUser", "apply@example.com", 41];
      const bindFn = (stmt as any).bind;
      await bindFn.apply(stmt, params).run();

      // Check both were inserted correctly
      const count = await TEST_DB.prepare(
        "SELECT COUNT(*) as count FROM users",
      ).first("count");

      expect(count).toBe(2);
    });
  });
});
