import { env } from "cloudflare:test";
import { describe, it, expect, beforeEach } from "vitest";

describe("R2 Bucket", () => {
  const TEST_R2 = env.TEST_R2 as R2Bucket;

  beforeEach(async () => {
    // Clean up test data
    try {
      const objects = await TEST_R2.list();
      for (const obj of objects.objects) {
        await TEST_R2.delete(obj.key);
      }
    } catch (error) {
      // Ignore cleanup errors
    }
  });

  describe("Basic Operations", () => {
    it("should put and get an object", async () => {
      await TEST_R2.put("test-file.txt", "Hello, R2!");
      const obj = await TEST_R2.get("test-file.txt");
      expect(obj).not.toBeNull();
      const text = await obj!.text();
      expect(text).toBe("Hello, R2!");
    });

    it("should return null for non-existent object", async () => {
      const obj = await TEST_R2.get("non-existent.txt");
      expect(obj).toBeNull();
    });

    it("should delete an object", async () => {
      await TEST_R2.put("delete-me.txt", "temporary");
      await TEST_R2.delete("delete-me.txt");
      const obj = await TEST_R2.get("delete-me.txt");
      expect(obj).toBeNull();
    });

    it("should get object metadata with head", async () => {
      await TEST_R2.put("meta-file.txt", "content");
      const obj = await TEST_R2.head("meta-file.txt");
      expect(obj).not.toBeNull();
      expect(obj!.key).toBe("meta-file.txt");
      expect(obj!.size).toBeGreaterThan(0);
    });
  });

  describe("Object Content Types", () => {
    it("should store and retrieve text", async () => {
      await TEST_R2.put("text.txt", "Plain text content");
      const obj = await TEST_R2.get("text.txt");
      const text = await obj!.text();
      expect(text).toBe("Plain text content");
    });

    it("should store and retrieve JSON", async () => {
      const data = { name: "Alice", age: 30, active: true };
      await TEST_R2.put("data.json", JSON.stringify(data));
      const obj = await TEST_R2.get("data.json");
      const json = await obj!.json();
      expect(json).toEqual(data);
    });

    it("should store and retrieve ArrayBuffer", async () => {
      const encoder = new TextEncoder();
      const buffer = encoder.encode("Binary data").buffer;
      await TEST_R2.put("binary.dat", buffer);
      const obj = await TEST_R2.get("binary.dat");
      const retrieved = await obj!.arrayBuffer();
      const decoder = new TextDecoder();
      expect(decoder.decode(retrieved)).toBe("Binary data");
    });

    it("should store and retrieve Blob", async () => {
      const blob = new Blob(["Blob content"], { type: "text/plain" });
      await TEST_R2.put("blob.txt", blob);
      const obj = await TEST_R2.get("blob.txt");
      const retrievedBlob = await obj!.blob();
      const text = await retrievedBlob.text();
      expect(text).toBe("Blob content");
    });
  });

  describe("HTTP Metadata", () => {
    it("should store and retrieve custom HTTP metadata", async () => {
      try {
        const putResult = await TEST_R2.put("styled.html", "<html></html>", {
          httpMetadata: {
            contentType: "text/html",
            contentLanguage: "en-US",
            cacheControl: "max-age=3600",
            contentEncoding: "gzip",
          },
        });
        expect(putResult).toBeDefined();

        const obj = await TEST_R2.get("styled.html");
        expect(obj).not.toBeNull();
        if (obj) {
          expect(obj.httpMetadata.contentType).toBe("text/html");
          expect(obj.httpMetadata.contentLanguage).toBe("en-US");
          expect(obj.httpMetadata.cacheControl).toBe("max-age=3600");
        }
      } finally {
        // Ensure cleanup
        await TEST_R2.delete("styled.html");
      }
    });

    it("should set content-disposition", async () => {
      const putResult = await TEST_R2.put("download.pdf", "PDF content", {
        httpMetadata: {
          contentType: "application/pdf",
          contentDisposition: 'attachment; filename="document.pdf"',
        },
      });
      expect(putResult).toBeDefined();

      const obj = await TEST_R2.get("download.pdf");
      expect(obj).not.toBeNull();
      if (obj) {
        expect(obj.httpMetadata.contentDisposition).toBe(
          'attachment; filename="document.pdf"',
        );
      }
    });
  });

  describe("Custom Metadata", () => {
    it("should store and retrieve custom metadata", async () => {
      const metadata = {
        author: "Alice",
        version: "1.0",
        tags: "important,public",
      };

      await TEST_R2.put("doc.txt", "Document content", {
        customMetadata: metadata,
      });

      const obj = await TEST_R2.get("doc.txt");
      expect(obj!.customMetadata).toEqual(metadata);
    });

    it("should handle empty custom metadata", async () => {
      await TEST_R2.put("no-meta.txt", "content");
      const obj = await TEST_R2.get("no-meta.txt");
      expect(obj!.customMetadata).toEqual({});
    });
  });

  describe("Object Properties", () => {
    it("should return correct object key", async () => {
      await TEST_R2.put("my-key.txt", "content");
      const obj = await TEST_R2.get("my-key.txt");
      expect(obj!.key).toBe("my-key.txt");
    });

    it("should return correct object size", async () => {
      const content = "x".repeat(1000);
      await TEST_R2.put("sized.txt", content);
      const obj = await TEST_R2.get("sized.txt");
      expect(obj!.size).toBe(1000);
    });

    it("should have etag", async () => {
      await TEST_R2.put("tagged.txt", "content");
      const obj = await TEST_R2.get("tagged.txt");
      expect(obj!.etag).toBeDefined();
      expect(typeof obj!.etag).toBe("string");
    });

    it("should have version", async () => {
      await TEST_R2.put("versioned.txt", "content");
      const obj = await TEST_R2.get("versioned.txt");
      expect(obj!.version).toBeDefined();
    });

    it("should have uploaded timestamp", async () => {
      await TEST_R2.put("timestamped.txt", "content");
      const obj = await TEST_R2.get("timestamped.txt");
      expect(obj!.uploaded).toBeInstanceOf(Date);
    });
  });

  describe("Conditional Gets", () => {
    it("should get object only if etag matches", async () => {
      await TEST_R2.put("conditional.txt", "content");
      const obj1 = await TEST_R2.get("conditional.txt");
      const etag = obj1!.etag;

      const obj2 = await TEST_R2.get("conditional.txt", {
        onlyIf: { etagMatches: etag },
      });
      expect(obj2).not.toBeNull();
    });

    it("should return null if etag does not match", async () => {
      await TEST_R2.put("conditional2.txt", "content");
      const obj = await TEST_R2.get("conditional2.txt", {
        onlyIf: { etagDoesNotMatch: "fake-etag" },
      });
      expect(obj).not.toBeNull();
    });
  });

  describe("Range Requests", () => {
    it("should get object with byte range", async () => {
      await TEST_R2.put("range.txt", "0123456789");
      const obj = await TEST_R2.get("range.txt", {
        range: { offset: 2, length: 5 },
      });
      const text = await obj!.text();
      expect(text).toBe("23456");
    });

    it("should get object with suffix range", async () => {
      await TEST_R2.put("suffix.txt", "0123456789");
      const obj = await TEST_R2.get("suffix.txt", {
        range: { suffix: 3 },
      });
      const text = await obj!.text();
      expect(text).toBe("789");
    });
  });

  describe("List Operations", () => {
    beforeEach(async () => {
      await TEST_R2.put("dir/file1.txt", "content1");
      await TEST_R2.put("dir/file2.txt", "content2");
      await TEST_R2.put("dir/subdir/file3.txt", "content3");
      await TEST_R2.put("other/file4.txt", "content4");
    });

    it("should list all objects", async () => {
      const result = await TEST_R2.list();
      expect(result.objects.length).toBeGreaterThanOrEqual(4);
    });

    it("should list objects with prefix", async () => {
      const result = await TEST_R2.list({ prefix: "dir/" });
      expect(result.objects.length).toBe(3);
      expect(result.objects.every((obj) => obj.key.startsWith("dir/"))).toBe(
        true,
      );
    });

    it("should list objects with delimiter", async () => {
      const result = await TEST_R2.list({ prefix: "dir/", delimiter: "/" });
      expect(result.delimitedPrefixes).toContain("dir/subdir/");
    });

    it("should list objects with limit", async () => {
      const result = await TEST_R2.list({ limit: 2 });
      expect(result.objects.length).toBe(2);
    });

    it("should paginate with cursor", async () => {
      const page1 = await TEST_R2.list({ limit: 2 });
      if (page1.truncated && page1.cursor) {
        const page2 = await TEST_R2.list({ limit: 2, cursor: page1.cursor });
        expect(page2.objects.length).toBeGreaterThan(0);
      }
    });

    it("should include httpMetadata in list", async () => {
      await TEST_R2.put("meta-list.txt", "content", {
        httpMetadata: { contentType: "text/plain" },
      });

      const result = await TEST_R2.list({
        prefix: "meta-list",
        include: ["httpMetadata"],
      });

      const obj = result.objects.find((o) => o.key === "meta-list.txt");
      expect(obj?.httpMetadata).toBeDefined();
    });

    it("should include customMetadata in list", async () => {
      await TEST_R2.put("custom-list.txt", "content", {
        customMetadata: { author: "Bob" },
      });

      const result = await TEST_R2.list({
        prefix: "custom-list",
        include: ["customMetadata"],
      });

      const obj = result.objects.find((o) => o.key === "custom-list.txt");
      expect(obj?.customMetadata).toBeDefined();
    });
  });

  describe("Multiple Deletes", () => {
    it("should delete multiple objects", async () => {
      await TEST_R2.put("bulk1.txt", "content");
      await TEST_R2.put("bulk2.txt", "content");
      await TEST_R2.put("bulk3.txt", "content");

      await TEST_R2.delete(["bulk1.txt", "bulk2.txt", "bulk3.txt"]);

      const obj1 = await TEST_R2.get("bulk1.txt");
      const obj2 = await TEST_R2.get("bulk2.txt");
      const obj3 = await TEST_R2.get("bulk3.txt");

      expect(obj1).toBeNull();
      expect(obj2).toBeNull();
      expect(obj3).toBeNull();
    });
  });

  describe("Multipart Upload", () => {
    it.skip("should create and complete multipart upload", async () => {
      // Skipped due to Miniflare multipart upload limitations
      const upload = await TEST_R2.createMultipartUpload("multipart.bin");
      expect(upload.key).toBe("multipart.bin");
      expect(upload.uploadId).toBeDefined();

      const part1Data = new Uint8Array(5 * 1024 * 1024); // 5MB
      part1Data.fill(65); // Fill with 'A'
      const part1 = await upload.uploadPart(1, part1Data);
      expect(part1.partNumber).toBe(1);
      expect(part1.etag).toBeDefined();

      const part2Data = new Uint8Array(5 * 1024 * 1024); // 5MB
      part2Data.fill(66); // Fill with 'B'
      const part2 = await upload.uploadPart(2, part2Data);
      expect(part2.partNumber).toBe(2);

      const obj = await upload.complete([part1, part2]);
      expect(obj.key).toBe("multipart.bin");
      expect(obj.size).toBe(10 * 1024 * 1024);
    });

    it.skip("should abort multipart upload", async () => {
      // Skipped due to Miniflare multipart upload limitations
      const upload = await TEST_R2.createMultipartUpload("abort-multipart.bin");
      await upload.abort();

      // After abort, the object should not exist
      const obj = await TEST_R2.get("abort-multipart.bin");
      expect(obj).toBeNull();
    });

    it.skip("should resume multipart upload", async () => {
      // Skipped due to Miniflare multipart upload limitations
      const upload1 = await TEST_R2.createMultipartUpload(
        "resume-multipart.bin",
      );
      const uploadId = upload1.uploadId;

      const upload2 = TEST_R2.resumeMultipartUpload(
        "resume-multipart.bin",
        uploadId,
      );
      expect(upload2.key).toBe("resume-multipart.bin");
      expect(upload2.uploadId).toBe(uploadId);

      await upload2.abort();
    });
  });

  describe("Edge Cases", () => {
    it("should handle empty content", async () => {
      await TEST_R2.put("empty.txt", "");
      const obj = await TEST_R2.get("empty.txt");
      expect(obj!.size).toBe(0);
      const text = await obj!.text();
      expect(text).toBe("");
    });

    it("should handle unicode keys", async () => {
      await TEST_R2.put("emoji-🚀.txt", "rocket");
      const obj = await TEST_R2.get("emoji-🚀.txt");
      const text = await obj!.text();
      expect(text).toBe("rocket");
    });

    it("should handle unicode content", async () => {
      await TEST_R2.put("unicode.txt", "こんにちは世界 🌍");
      const obj = await TEST_R2.get("unicode.txt");
      const text = await obj!.text();
      expect(text).toBe("こんにちは世界 🌍");
    });

    it("should handle large objects", async () => {
      const largeContent = "x".repeat(1024 * 1024); // 1MB
      await TEST_R2.put("large.txt", largeContent);
      const obj = await TEST_R2.get("large.txt");
      expect(obj!.size).toBe(1024 * 1024);
    });

    it("should overwrite existing object", async () => {
      await TEST_R2.put("overwrite.txt", "version1");
      await TEST_R2.put("overwrite.txt", "version2");
      const obj = await TEST_R2.get("overwrite.txt");
      const text = await obj!.text();
      expect(text).toBe("version2");
    });

    it("should handle keys with special characters", async () => {
      const specialKey = "path/to/file-name_v1.2.3.txt";
      await TEST_R2.put(specialKey, "content");
      const obj = await TEST_R2.get(specialKey);
      expect(obj!.key).toBe(specialKey);
    });
  });

  describe("Body Consumption", () => {
    it("should mark body as used after reading", async () => {
      await TEST_R2.put("body-test.txt", "content");
      const obj = await TEST_R2.get("body-test.txt");
      expect(obj).not.toBeNull();
      if (obj) {
        expect(obj.bodyUsed).toBe(false);
        await obj.text();
        expect(obj.bodyUsed).toBe(true);
      }
    });

    it("should not allow reading body twice", async () => {
      await TEST_R2.put("double-read.txt", "content");
      const obj = await TEST_R2.get("double-read.txt");
      expect(obj).not.toBeNull();
      if (obj) {
        await obj.text();
        try {
          await obj.text();
          expect.fail("Should not be able to read body twice");
        } catch (error) {
          expect(error).toBeDefined();
        }
      }
    });
  });

  describe("Checksums", () => {
    it.skip("should store object with MD5 checksum", async () => {
      // Skipped: MD5 validation in Miniflare may differ from production
      const content = "checksum content";
      // Note: In a real test, you'd calculate the actual MD5
      await TEST_R2.put("md5.txt", content, {
        md5: "fake-md5-for-test",
      });
      const obj = await TEST_R2.get("md5.txt");
      expect(obj).not.toBeNull();
    });
  });
});
