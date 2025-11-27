///|
/// AWS S3 Client wrapper for @aws-sdk/client-s3
/// Compatible with S3-compatible storage like MinIO, R2, etc.

///|
/// S3Client - the main client type
#external
pub type S3Client

///|
pub impl @js.JsImpl for S3Client

///|
/// Create a new S3Client
/// endpoint: custom endpoint URL for S3-compatible storage (e.g., "http://127.0.0.1:9000" for MinIO)
/// forcePathStyle: use path-style URLs (required for MinIO)
pub fn S3Client::new(
  region? : String = "us-east-1",
  endpoint? : String,
  accessKeyId? : String,
  secretAccessKey? : String,
  forcePathStyle? : Bool = false,
) -> S3Client {
  let config = @js.Object::new()
  config.set("region", region)
  if endpoint is Some(ep) {
    config.set("endpoint", ep)
  }
  config.set("forcePathStyle", forcePathStyle)
  if accessKeyId is Some(ak) && secretAccessKey is Some(sk) {
    let creds = @js.Object::new()
    creds.set("accessKeyId", ak)
    creds.set("secretAccessKey", sk)
    config.set("credentials", creds.to_any())
  }
  ffi_new_s3_client(config.to_any()) |> @js.identity
}

///|
extern "js" fn ffi_new_s3_client(config : @js.Any) -> @js.Any =
  #|(config) => {
  #|  const { S3Client } = require('@aws-sdk/client-s3');
  #|  return new S3Client(config);
  #|}

///|
/// PutObject - upload an object to S3
pub async fn put_object(
  client : S3Client,
  bucket : String,
  key : String,
  body : String,
  contentType? : String,
) -> PutObjectOutput {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  input.set("Key", key)
  input.set("Body", body)
  if contentType is Some(ct) {
    input.set("ContentType", ct)
  }
  let result = ffi_put_object(client |> @js.identity, input.to_any()).wait()
  { etag: result.get("ETag") |> @js.identity }
}

///|
pub struct PutObjectOutput {
  etag : String?
}

///|
extern "js" fn ffi_put_object(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { PutObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new PutObjectCommand(input));
  #|}

///|
/// PutObject with Bytes body
pub async fn put_object_bytes(
  client : S3Client,
  bucket : String,
  key : String,
  body : Bytes,
  contentType? : String,
) -> PutObjectOutput {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  input.set("Key", key)
  input.set("Body", @typedarray.bytes_to_uint8array(body))
  if contentType is Some(ct) {
    input.set("ContentType", ct)
  }
  let result = ffi_put_object(client |> @js.identity, input.to_any()).wait()
  { etag: result.get("ETag") |> @js.identity }
}

///|
/// GetObject - download an object from S3
pub async fn get_object(
  client : S3Client,
  bucket : String,
  key : String,
) -> GetObjectOutput {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  input.set("Key", key)
  let result = ffi_get_object(client |> @js.identity, input.to_any()).wait()
  {
    body: result.get("Body") |> @js.identity,
    content_type: result.get("ContentType") |> @js.identity,
    content_length: result.get("ContentLength") |> @js.identity,
    etag: result.get("ETag") |> @js.identity,
  }
}

///|
pub struct GetObjectOutput {
  body : @js.Any
  content_type : String?
  content_length : Int?
  etag : String?
}

///|
/// Get body as string
pub async fn GetObjectOutput::body_as_string(self : GetObjectOutput) -> String {
  ffi_stream_to_string(self.body).wait()
}

///|
extern "js" fn ffi_stream_to_string(body : @js.Any) -> @js.Promise[String] =
  #|async (body) => {
  #|  const chunks = [];
  #|  for await (const chunk of body) {
  #|    chunks.push(chunk);
  #|  }
  #|  return Buffer.concat(chunks).toString('utf-8');
  #|}

///|
extern "js" fn ffi_get_object(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { GetObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new GetObjectCommand(input));
  #|}

///|
/// DeleteObject - delete an object from S3
pub async fn delete_object(
  client : S3Client,
  bucket : String,
  key : String,
) -> DeleteObjectOutput {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  input.set("Key", key)
  let result = ffi_delete_object(client |> @js.identity, input.to_any()).wait()
  { delete_marker: result.get("DeleteMarker") |> @js.identity }
}

///|
pub struct DeleteObjectOutput {
  delete_marker : Bool?
}

///|
extern "js" fn ffi_delete_object(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { DeleteObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new DeleteObjectCommand(input));
  #|}

///|
/// HeadObject - get object metadata without downloading
pub async fn head_object(
  client : S3Client,
  bucket : String,
  key : String,
) -> HeadObjectOutput {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  input.set("Key", key)
  let result = ffi_head_object(client |> @js.identity, input.to_any()).wait()
  {
    content_type: result.get("ContentType") |> @js.identity,
    content_length: result.get("ContentLength") |> @js.identity,
    etag: result.get("ETag") |> @js.identity,
  }
}

///|
pub struct HeadObjectOutput {
  content_type : String?
  content_length : Int?
  etag : String?
}

///|
extern "js" fn ffi_head_object(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { HeadObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new HeadObjectCommand(input));
  #|}

///|
/// ListObjectsV2 - list objects in a bucket
pub async fn list_objects_v2(
  client : S3Client,
  bucket : String,
  prefix? : String,
  maxKeys? : Int,
  continuationToken? : String,
) -> ListObjectsV2Output {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  if prefix is Some(p) {
    input.set("Prefix", p)
  }
  if maxKeys is Some(mk) {
    input.set("MaxKeys", mk)
  }
  if continuationToken is Some(ct) {
    input.set("ContinuationToken", ct)
  }
  let result = ffi_list_objects_v2(client |> @js.identity, input.to_any()).wait()
  let contents_raw : Array[@js.Any] = result.get("Contents") |> @js.identity
  let contents = contents_raw.map(fn(obj) {
    {
      key: obj.get("Key") |> @js.identity,
      size: obj.get("Size") |> @js.identity,
      etag: obj.get("ETag") |> @js.identity,
      last_modified: obj.get("LastModified") |> @js.identity,
    }
  })
  {
    contents,
    is_truncated: result.get("IsTruncated") |> @js.identity,
    next_continuation_token: result.get("NextContinuationToken") |> @js.identity,
  }
}

///|
pub struct ListObjectsV2Output {
  contents : Array[S3Object]
  is_truncated : Bool?
  next_continuation_token : String?
}

///|
pub struct S3Object {
  key : String?
  size : Int?
  etag : String?
  last_modified : @js.Any
}

///|
extern "js" fn ffi_list_objects_v2(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { ListObjectsV2Command } = require('@aws-sdk/client-s3');
  #|  const result = await client.send(new ListObjectsV2Command(input));
  #|  return { ...result, Contents: result.Contents || [] };
  #|}

///|
/// CreateBucket - create a new bucket
pub async fn create_bucket(client : S3Client, bucket : String) -> Unit {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  ffi_create_bucket(client |> @js.identity, input.to_any()).wait() |> ignore
}

///|
extern "js" fn ffi_create_bucket(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { CreateBucketCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new CreateBucketCommand(input));
  #|}

///|
/// DeleteBucket - delete a bucket
pub async fn delete_bucket(client : S3Client, bucket : String) -> Unit {
  let input = @js.Object::new()
  input.set("Bucket", bucket)
  ffi_delete_bucket(client |> @js.identity, input.to_any()).wait() |> ignore
}

///|
extern "js" fn ffi_delete_bucket(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { DeleteBucketCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new DeleteBucketCommand(input));
  #|}

///|
/// ListBuckets - list all buckets
pub async fn list_buckets(client : S3Client) -> ListBucketsOutput {
  let result = ffi_list_buckets(client |> @js.identity).wait()
  let buckets_raw : Array[@js.Any] = result.get("Buckets") |> @js.identity
  let buckets = buckets_raw.map(fn(b) {
    { name: b.get("Name") |> @js.identity }
  })
  { buckets, }
}

///|
pub struct ListBucketsOutput {
  buckets : Array[Bucket]
}

///|
pub struct Bucket {
  name : String?
}

///|
extern "js" fn ffi_list_buckets(client : @js.Any) -> @js.Promise[@js.Any] =
  #|async (client) => {
  #|  const { ListBucketsCommand } = require('@aws-sdk/client-s3');
  #|  const result = await client.send(new ListBucketsCommand({}));
  #|  return { ...result, Buckets: result.Buckets || [] };
  #|}

///|
/// CopyObject - copy an object within S3
pub async fn copy_object(
  client : S3Client,
  sourceBucket : String,
  sourceKey : String,
  destBucket : String,
  destKey : String,
) -> CopyObjectOutput {
  let input = @js.Object::new()
  input.set("CopySource", sourceBucket + "/" + sourceKey)
  input.set("Bucket", destBucket)
  input.set("Key", destKey)
  let result = ffi_copy_object(client |> @js.identity, input.to_any()).wait()
  let copy_result = result.get("CopyObjectResult")
  { etag: copy_result.get("ETag") |> @js.identity }
}

///|
pub struct CopyObjectOutput {
  etag : String?
}

///|
extern "js" fn ffi_copy_object(
  client : @js.Any,
  input : @js.Any,
) -> @js.Promise[@js.Any] =
  #|async (client, input) => {
  #|  const { CopyObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new CopyObjectCommand(input));
  #|}
