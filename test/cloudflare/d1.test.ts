import { env } from "cloudflare:test";
import { describe, it, expect, beforeEach, afterEach } from "vitest";

describe("D1 Database", () => {
  const TEST_DB = env.TEST_DB as D1Database;

  beforeEach(async () => {
    // Create test table using prepare().run() instead of exec()
    await TEST_DB.prepare(
      `
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        age INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `,
    ).run();
  });

  afterEach(async () => {
    // Clean up using prepare().run() instead of exec()
    await TEST_DB.prepare("DROP TABLE IF EXISTS users").run();
  });

  describe("Basic Operations", () => {
    it("should execute CREATE TABLE statement", async () => {
      const result = await TEST_DB.prepare(
        `
        CREATE TABLE IF NOT EXISTS posts (
          id INTEGER PRIMARY KEY,
          title TEXT
        )
      `,
      ).run();
      expect(result).toBeDefined();
      expect(result.success).toBe(true);
      await TEST_DB.prepare("DROP TABLE IF EXISTS posts").run();
    });

    it("should prepare and execute INSERT statement", async () => {
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      const result = await stmt.bind("Alice", "alice@example.com", 30).run();
      expect(result.success).toBe(true);
      expect(result.meta?.last_row_id).toBeGreaterThan(0);
    });

    it("should prepare and execute SELECT statement", async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Bob", "bob@example.com", 25)
        .run();

      const result = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Bob")
        .all();

      expect(result.success).toBe(true);
      expect(result.results).toBeDefined();
      expect(result.results?.length).toBe(1);
      expect(result.results?.[0].name).toBe("Bob");
    });

    it("should execute UPDATE statement", async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Charlie", "charlie@example.com", 35)
        .run();

      const result = await TEST_DB.prepare(
        "UPDATE users SET age = ? WHERE name = ?",
      )
        .bind(36, "Charlie")
        .run();

      expect(result.success).toBe(true);
      expect(result.meta?.changes).toBe(1);
    });

    it("should execute DELETE statement", async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Dave", "dave@example.com", 40)
        .run();

      const result = await TEST_DB.prepare("DELETE FROM users WHERE name = ?")
        .bind("Dave")
        .run();

      expect(result.success).toBe(true);
      expect(result.meta?.changes).toBe(1);
    });
  });

  describe("Query Results", () => {
    beforeEach(async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Alice", "alice@example.com", 30)
        .run();
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Bob", "bob@example.com", 25)
        .run();
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Charlie", "charlie@example.com", 35)
        .run();
    });

    it("should return all rows with .all()", async () => {
      const result = await TEST_DB.prepare(
        "SELECT * FROM users ORDER BY name",
      ).all();
      expect(result.results?.length).toBe(3);
      expect(result.results?.[0].name).toBe("Alice");
      expect(result.results?.[1].name).toBe("Bob");
      expect(result.results?.[2].name).toBe("Charlie");
    });

    it("should return first row with .first()", async () => {
      const row = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Alice")
        .first();
      expect(row).toBeDefined();
      expect(row?.name).toBe("Alice");
      expect(row?.age).toBe(30);
    });

    it("should return first column value with .first(columnName)", async () => {
      const name = await TEST_DB.prepare("SELECT name FROM users WHERE age = ?")
        .bind(25)
        .first("name");
      expect(name).toBe("Bob");
    });

    it("should return null for non-existent row", async () => {
      const row = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("NonExistent")
        .first();
      expect(row).toBeNull();
    });

    it("should return raw results as arrays", async () => {
      const raw = await TEST_DB.prepare(
        "SELECT name, age FROM users ORDER BY age",
      ).raw();
      expect(Array.isArray(raw)).toBe(true);
      expect(raw.length).toBe(3);
      expect(raw[0]).toEqual(["Bob", 25]);
      expect(raw[1]).toEqual(["Alice", 30]);
      expect(raw[2]).toEqual(["Charlie", 35]);
    });

    it("should include column names in raw results", async () => {
      const raw = await TEST_DB.prepare(
        "SELECT name, age FROM users LIMIT 1",
      ).raw({ columnNames: true });
      expect(raw.length).toBe(2);
      expect(raw[0]).toEqual(["name", "age"]);
    });
  });

  describe("Parameter Binding", () => {
    it("should bind single parameter", async () => {
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      const result = await stmt.bind("Eve", "eve@example.com", 28).run();
      expect(result.success).toBe(true);
    });

    it("should bind multiple parameters", async () => {
      const stmt = TEST_DB.prepare(
        "SELECT * FROM users WHERE age > ? AND age < ?",
      );
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Young", "young@example.com", 20)
        .run();
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Old", "old@example.com", 50)
        .run();

      const result = await stmt.bind(18, 40).all();
      expect(result.results?.length).toBe(1);
      expect(result.results?.[0].name).toBe("Young");
    });

    it("should bind parameters with different types", async () => {
      const stmt = TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      );
      await stmt.bind("Frank", "frank@example.com", 45).run();

      const result = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Frank")
        .first();
      expect(result?.age).toBe(45);
    });
  });

  describe("Batch Operations", () => {
    it("should execute multiple statements in batch", async () => {
      const statements = [
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("User1", "user1@example.com", 20),
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("User2", "user2@example.com", 21),
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("User3", "user3@example.com", 22),
      ];

      const results = await TEST_DB.batch(statements);
      expect(results.length).toBe(3);
      expect(results.every((r) => r.success)).toBe(true);
    });

    it("should rollback batch on error", async () => {
      const statements = [
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("Valid", "valid@example.com", 30),
        TEST_DB.prepare("INSERT INTO users (invalid_column) VALUES (?)").bind(
          "Invalid",
        ), // This will fail
      ];

      try {
        await TEST_DB.batch(statements);
        expect.fail("Should have thrown an error");
      } catch (error) {
        // Batch should have rolled back
        const count = await TEST_DB.prepare(
          "SELECT COUNT(*) as count FROM users",
        ).first("count");
        expect(count).toBe(0); // No rows should be inserted
      }
    });
  });

  describe("Metadata", () => {
    it("should return query metadata", async () => {
      const result = await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Meta", "meta@example.com", 33)
        .run();

      expect(result.meta).toBeDefined();
      expect(result.meta?.last_row_id).toBeGreaterThan(0);
      expect(result.meta?.changes).toBe(1);
      // duration is optional in meta
    });

    it("should include rows_read and rows_written", async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Reader", "reader@example.com", 27)
        .run();

      const result = await TEST_DB.prepare("SELECT * FROM users WHERE name = ?")
        .bind("Reader")
        .all();

      expect(result.meta).toBeDefined();
      expect(result.meta?.rows_read).toBeGreaterThanOrEqual(0);
    });
  });

  describe("Error Handling", () => {
    it("should handle SQL syntax errors", async () => {
      try {
        await TEST_DB.prepare("INVALID SQL STATEMENT").run();
        expect.fail("Should have thrown an error");
      } catch (error) {
        expect(error).toBeDefined();
      }
    });

    it("should handle constraint violations", async () => {
      await TEST_DB.prepare(
        "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
      )
        .bind("Unique", "unique@example.com", 30)
        .run();

      try {
        await TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        )
          .bind("Another", "unique@example.com", 31)
          .run();
        expect.fail("Should have thrown a unique constraint error");
      } catch (error) {
        expect(error).toBeDefined();
      }
    });

    it("should handle missing parameters", async () => {
      try {
        await TEST_DB.prepare("SELECT * FROM users WHERE name = ?").all();
        expect.fail("Should have thrown an error for missing parameter");
      } catch (error) {
        expect(error).toBeDefined();
      }
    });
  });

  describe("Complex Queries", () => {
    beforeEach(async () => {
      const users = [
        ["Alice", "alice@example.com", 30],
        ["Bob", "bob@example.com", 25],
        ["Charlie", "charlie@example.com", 35],
        ["Dave", "dave@example.com", 28],
        ["Eve", "eve@example.com", 32],
      ];

      for (const [name, email, age] of users) {
        await TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        )
          .bind(name, email, age)
          .run();
      }
    });

    it("should execute ORDER BY query", async () => {
      const result = await TEST_DB.prepare(
        "SELECT * FROM users ORDER BY age DESC",
      ).all();
      expect(result.results?.[0].name).toBe("Charlie");
      expect(result.results?.[4].name).toBe("Bob");
    });

    it("should execute LIMIT and OFFSET", async () => {
      const result = await TEST_DB.prepare(
        "SELECT * FROM users ORDER BY name LIMIT 2 OFFSET 2",
      ).all();
      expect(result.results?.length).toBe(2);
      expect(result.results?.[0].name).toBe("Charlie");
      expect(result.results?.[1].name).toBe("Dave");
    });

    it("should execute aggregate functions", async () => {
      const avgAge = await TEST_DB.prepare(
        "SELECT AVG(age) as avg_age FROM users",
      ).first("avg_age");
      expect(avgAge).toBe(30); // (30+25+35+28+32)/5 = 30

      const count = await TEST_DB.prepare(
        "SELECT COUNT(*) as count FROM users",
      ).first("count");
      expect(count).toBe(5);
    });

    it("should execute GROUP BY query", async () => {
      const result = await TEST_DB.prepare(
        `
        SELECT
          CASE
            WHEN age < 30 THEN 'young'
            ELSE 'old'
          END as age_group,
          COUNT(*) as count
        FROM users
        GROUP BY age_group
      `,
      ).all();

      expect(result.results?.length).toBe(2);
    });
  });

  describe("Transaction-like Operations", () => {
    it("should maintain consistency in batch operations", async () => {
      const statements = [
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("Tx1", "tx1@example.com", 40),
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("Tx2", "tx2@example.com", 41),
        TEST_DB.prepare(
          "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
        ).bind("Tx3", "tx3@example.com", 42),
      ];

      const results = await TEST_DB.batch(statements);

      const count = await TEST_DB.prepare(
        "SELECT COUNT(*) as count FROM users",
      ).first("count");
      expect(count).toBe(3);

      results.forEach((result) => {
        expect(result.success).toBe(true);
      });
    });
  });
});
