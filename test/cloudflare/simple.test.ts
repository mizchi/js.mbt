import { env } from 'cloudflare:test';
import { describe, it, expect } from 'vitest';

describe('KV Namespace - Simple Test', () => {
  it('should be defined', () => {
    expect(env.TEST_KV).toBeDefined();
  });

  it('should put and get a value', async () => {
    const kv = env.TEST_KV as KVNamespace;
    await kv.put('test-key', 'test-value');
    const value = await kv.get('test-key');
    expect(value).toBe('test-value');
  });
});
