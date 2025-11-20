import { env } from 'cloudflare:test';
import { describe, it, expect, beforeEach } from 'vitest';

describe('KV Namespace', () => {
  const TEST_KV = env.TEST_KV as KVNamespace;

  beforeEach(async () => {
    // Clean up test data
    const keys = await TEST_KV.list();
    for (const key of keys.keys) {
      await TEST_KV.delete(key.name);
    }
  });

  describe('Basic Operations', () => {
    it('should put and get a value', async () => {
      await TEST_KV.put('test-key', 'test-value');
      const value = await TEST_KV.get('test-key');
      expect(value).toBe('test-value');
    });

    it('should return null for non-existent key', async () => {
      const value = await TEST_KV.get('non-existent');
      expect(value).toBeNull();
    });

    it('should delete a key', async () => {
      await TEST_KV.put('delete-me', 'value');
      await TEST_KV.delete('delete-me');
      const value = await TEST_KV.get('delete-me');
      expect(value).toBeNull();
    });
  });

  describe('Data Types', () => {
    it('should store and retrieve text', async () => {
      await TEST_KV.put('text-key', 'Hello, World!');
      const value = await TEST_KV.get('text-key', { type: 'text' });
      expect(value).toBe('Hello, World!');
    });

    it('should store and retrieve JSON', async () => {
      const data = { name: 'Alice', age: 30 };
      await TEST_KV.put('json-key', JSON.stringify(data));
      const value = await TEST_KV.get('json-key', { type: 'json' });
      expect(value).toEqual(data);
    });

    it('should store and retrieve arrayBuffer', async () => {
      const encoder = new TextEncoder();
      const data = encoder.encode('Binary data');
      await TEST_KV.put('binary-key', data);
      const value = await TEST_KV.get('binary-key', { type: 'arrayBuffer' });
      expect(value).toBeInstanceOf(ArrayBuffer);
      const decoder = new TextDecoder();
      expect(decoder.decode(value as ArrayBuffer)).toBe('Binary data');
    });
  });

  describe('Metadata', () => {
    it('should store and retrieve metadata', async () => {
      const metadata = { author: 'Alice', version: 1 };
      await TEST_KV.put('meta-key', 'value', { metadata });
      const result = await TEST_KV.getWithMetadata('meta-key');
      expect(result.value).toBe('value');
      expect(result.metadata).toEqual(metadata);
    });

    it('should return null metadata for keys without metadata', async () => {
      await TEST_KV.put('no-meta-key', 'value');
      const result = await TEST_KV.getWithMetadata('no-meta-key');
      expect(result.value).toBe('value');
      expect(result.metadata).toBeNull();
    });
  });

  describe('Expiration', () => {
    it('should set expiration with expirationTtl', async () => {
      await TEST_KV.put('ttl-key', 'value', { expirationTtl: 60 });
      const value = await TEST_KV.get('ttl-key');
      expect(value).toBe('value');
      // Note: Can't easily test actual expiration in unit tests
    });

    it('should set expiration with absolute timestamp', async () => {
      const futureTimestamp = Math.floor(Date.now() / 1000) + 3600;
      await TEST_KV.put('exp-key', 'value', { expiration: futureTimestamp });
      const value = await TEST_KV.get('exp-key');
      expect(value).toBe('value');
    });
  });

  describe('List Operations', () => {
    beforeEach(async () => {
      // Populate test data
      await TEST_KV.put('user:1', 'Alice');
      await TEST_KV.put('user:2', 'Bob');
      await TEST_KV.put('user:3', 'Charlie');
      await TEST_KV.put('post:1', 'Hello');
      await TEST_KV.put('post:2', 'World');
    });

    it('should list all keys', async () => {
      const result = await TEST_KV.list();
      expect(result.keys.length).toBeGreaterThanOrEqual(5);
    });

    it('should list keys with prefix', async () => {
      const result = await TEST_KV.list({ prefix: 'user:' });
      expect(result.keys.length).toBe(3);
      expect(result.keys.every(k => k.name.startsWith('user:'))).toBe(true);
    });

    it('should list keys with limit', async () => {
      const result = await TEST_KV.list({ limit: 2 });
      expect(result.keys.length).toBe(2);
    });

    it('should paginate results with cursor', async () => {
      const page1 = await TEST_KV.list({ limit: 2 });
      expect(page1.keys.length).toBe(2);

      if (!page1.list_complete && page1.cursor) {
        const page2 = await TEST_KV.list({ limit: 2, cursor: page1.cursor });
        expect(page2.keys.length).toBeGreaterThan(0);
        // Ensure no duplicate keys
        const page1Keys = new Set(page1.keys.map(k => k.name));
        const page2Keys = new Set(page2.keys.map(k => k.name));
        const intersection = [...page1Keys].filter(k => page2Keys.has(k));
        expect(intersection.length).toBe(0);
      }
    });

    it('should include metadata in list', async () => {
      const metadata = { type: 'user' };
      await TEST_KV.put('meta-user:1', 'Dave', { metadata });
      const result = await TEST_KV.list({ prefix: 'meta-user:' });
      const key = result.keys.find(k => k.name === 'meta-user:1');
      expect(key?.metadata).toEqual(metadata);
    });
  });

  describe('Cache Control', () => {
    it('should respect cacheTtl option', async () => {
      await TEST_KV.put('cache-key', 'cached-value');
      const value = await TEST_KV.get('cache-key', { cacheTtl: 300 });
      expect(value).toBe('cached-value');
    });
  });

  describe('Edge Cases', () => {
    it('should handle empty string value', async () => {
      await TEST_KV.put('empty-key', '');
      const value = await TEST_KV.get('empty-key');
      expect(value).toBe('');
    });

    it('should handle unicode keys and values', async () => {
      await TEST_KV.put('emoji-🚀', 'こんにちは');
      const value = await TEST_KV.get('emoji-🚀');
      expect(value).toBe('こんにちは');
    });

    it('should handle large values', async () => {
      const largeValue = 'x'.repeat(10000);
      await TEST_KV.put('large-key', largeValue);
      const value = await TEST_KV.get('large-key');
      expect(value).toBe(largeValue);
    });

    it('should overwrite existing key', async () => {
      await TEST_KV.put('overwrite-key', 'value1');
      await TEST_KV.put('overwrite-key', 'value2');
      const value = await TEST_KV.get('overwrite-key');
      expect(value).toBe('value2');
    });
  });
});
