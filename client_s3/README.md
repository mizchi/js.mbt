# mizchi/npm_typed/client_s3

MoonBit wrapper for `@aws-sdk/client-s3`. Works with S3-compatible storage services.

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install @aws-sdk/client-s3
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/core",
    "mizchi/npm_typed/client_s3"
  ]
}
```

## Supported Services

- **AWS S3** - Standard S3 service
- **Google Cloud Storage (GCS)** - Via S3-compatible endpoint
- **Cloudflare R2** - Cloudflare's object storage
- **MinIO** - Self-hosted S3-compatible storage

For detailed setup instructions for each service, see: https://zenn.dev/mizchi/articles/s3-compatible-client

## Usage

### AWS S3

```moonbit
let client = @client_s3.S3Client::new(
  region="ap-northeast-1",
  accessKeyId="YOUR_ACCESS_KEY",
  secretAccessKey="YOUR_SECRET_KEY",
)
```

### Google Cloud Storage (GCS)

```moonbit
let client = @client_s3.S3Client::new(
  region="auto",
  endpoint="https://storage.googleapis.com",
  accessKeyId="YOUR_HMAC_ACCESS_KEY",
  secretAccessKey="YOUR_HMAC_SECRET_KEY",
)
```

### Cloudflare R2

```moonbit
let client = @client_s3.S3Client::new(
  region="auto",
  endpoint="https://<ACCOUNT_ID>.r2.cloudflarestorage.com",
  accessKeyId="YOUR_R2_ACCESS_KEY",
  secretAccessKey="YOUR_R2_SECRET_KEY",
)
```

### MinIO (Local Development)

```moonbit
let client = @client_s3.S3Client::new(
  region="us-east-1",
  endpoint="http://127.0.0.1:9000",
  accessKeyId="minioadmin",
  secretAccessKey="minioadmin",
  forcePathStyle=true,  // Required for MinIO
)
```

## API

### Bucket Operations

```moonbit
// Create bucket
@client_s3.create_bucket(client, "my-bucket")

// List buckets
let result = @client_s3.list_buckets(client)

// Delete bucket
@client_s3.delete_bucket(client, "my-bucket")
```

### Object Operations

```moonbit
// Upload object
let put_result = @client_s3.put_object(
  client, "bucket", "key.txt", "content",
  contentType="text/plain",
)

// Upload bytes
let put_result = @client_s3.put_object_bytes(
  client, "bucket", "key.bin", bytes,
  contentType="application/octet-stream",
)

// Download object
let get_result = @client_s3.get_object(client, "bucket", "key.txt")
let content = get_result.body_as_string()

// Get object metadata
let head_result = @client_s3.head_object(client, "bucket", "key.txt")

// List objects
let list_result = @client_s3.list_objects_v2(client, "bucket", prefix="dir/")

// Copy object
let copy_result = @client_s3.copy_object(
  client, "src-bucket", "src-key", "dest-bucket", "dest-key",
)

// Delete object
@client_s3.delete_object(client, "bucket", "key.txt")
```

## Testing with MinIO

Start MinIO server:

```bash
minio server /tmp/minio-data
```

MinIO will start on http://127.0.0.1:9000 with default credentials `minioadmin/minioadmin`.

Run tests:

```bash
moon test --package client_s3
```

Note: Tests are skipped by default. Remove `#skip` from test files to run them.
