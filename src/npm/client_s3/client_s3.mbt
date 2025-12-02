///|
/// AWS S3 Client wrapper for @aws-sdk/client-s3
/// Compatible with S3-compatible storage like MinIO, R2, etc.

///|
/// S3Client - the main client type
#external
pub type S3Client

///|
pub fn S3Client::as_any(self : S3Client) -> @nostd.Any = "%identity"

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
  let config = @nostd.Object::new()
  config["region"] = region |> @nostd.any
  if endpoint is Some(ep) {
    config["endpoint"] = ep |> @nostd.any
  }
  config["forcePathStyle"] = forcePathStyle |> @nostd.any
  if accessKeyId is Some(ak) && secretAccessKey is Some(sk) {
    let creds = @nostd.Object::new()
    creds["accessKeyId"] = ak |> @nostd.any
    creds["secretAccessKey"] = sk |> @nostd.any
    config["credentials"] = creds |> @nostd.any
  }
  ffi_new_s3_client(config |> @nostd.any) |> @nostd.identity
}

///|
extern "js" fn ffi_new_s3_client(config : @nostd.Any) -> @nostd.Any =
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
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  input["Key"] = key |> @nostd.any
  input["Body"] = body |> @nostd.any
  if contentType is Some(ct) {
    input["ContentType"] = ct |> @nostd.any
  }
  let result = ffi_put_object(client |> @nostd.identity, input).wait()
  { etag: result["ETag"].cast() }
}

///|
pub struct PutObjectOutput {
  etag : String?
}

///|
extern "js" fn ffi_put_object(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
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
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  input["Key"] = key |> @nostd.any
  input["Body"] = @typedarray.bytes_to_uint8array(body) |> @nostd.any
  if contentType is Some(ct) {
    input["ContentType"] = ct |> @nostd.any
  }
  let result = ffi_put_object(client |> @nostd.identity, input).wait()
  { etag: result["ETag"].cast() }
}

///|
/// GetObject - download an object from S3
pub async fn get_object(
  client : S3Client,
  bucket : String,
  key : String,
) -> GetObjectOutput {
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  input["Key"] = key |> @nostd.any
  let result = ffi_get_object(client |> @nostd.identity, input).wait()
  {
    body: result["Body"].cast(),
    content_type: result["ContentType"].cast(),
    content_length: result["ContentLength"].cast(),
    etag: result["ETag"].cast(),
  }
}

///|
pub struct GetObjectOutput {
  body : @nostd.Any
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
extern "js" fn ffi_stream_to_string(body : @nostd.Any) -> @js.Promise[String] =
  #|async (body) => {
  #|  const chunks = [];
  #|  for await (const chunk of body) {
  #|    chunks.push(chunk);
  #|  }
  #|  return Buffer.concat(chunks).toString('utf-8');
  #|}

///|
extern "js" fn ffi_get_object(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
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
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  input["Key"] = key |> @nostd.any
  let result = ffi_delete_object(client |> @nostd.identity, input).wait()
  { delete_marker: result["DeleteMarker"].cast() }
}

///|
pub struct DeleteObjectOutput {
  delete_marker : Bool?
}

///|
extern "js" fn ffi_delete_object(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
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
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  input["Key"] = key |> @nostd.any
  let result = ffi_head_object(client |> @nostd.identity, input).wait()
  {
    content_type: result["ContentType"].cast(),
    content_length: result["ContentLength"].cast(),
    etag: result["ETag"].cast(),
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
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
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
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  if prefix is Some(p) {
    input["Prefix"] = p |> @nostd.any
  }
  if maxKeys is Some(mk) {
    input["MaxKeys"] = mk |> @nostd.any
  }
  if continuationToken is Some(ct) {
    input["ContinuationToken"] = ct |> @nostd.any
  }
  let result = ffi_list_objects_v2(client |> @nostd.identity, input).wait()
  let contents_raw : Array[@nostd.Any] = result["Contents"] |> @nostd.identity
  let contents = contents_raw.map(fn(obj) {
    {
      key: obj["Key"].cast(),
      size: obj["Size"].cast(),
      etag: obj["ETag"].cast(),
      last_modified: obj["LastModified"].cast(),
    }
  })
  {
    contents,
    is_truncated: result["IsTruncated"].cast(),
    next_continuation_token: result["NextContinuationToken"].cast(),
  }
}

///|
pub(all) struct ListObjectsV2Output {
  contents : Array[S3Object]
  is_truncated : Bool?
  next_continuation_token : String?
}

///|
pub struct S3Object {
  key : String?
  size : Int?
  etag : String?
  last_modified : @nostd.Any
}

///|
extern "js" fn ffi_list_objects_v2(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (client, input) => {
  #|  const { ListObjectsV2Command } = require('@aws-sdk/client-s3');
  #|  const result = await client.send(new ListObjectsV2Command(input));
  #|  return { ...result, Contents: result.Contents || [] };
  #|}

///|
/// CreateBucket - create a new bucket
pub async fn create_bucket(client : S3Client, bucket : String) -> Unit {
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  ffi_create_bucket(client |> @nostd.identity, input).wait() |> ignore
}

///|
extern "js" fn ffi_create_bucket(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (client, input) => {
  #|  const { CreateBucketCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new CreateBucketCommand(input));
  #|}

///|
/// DeleteBucket - delete a bucket
pub async fn delete_bucket(client : S3Client, bucket : String) -> Unit {
  let input = @nostd.Object::new()
  input["Bucket"] = bucket |> @nostd.any
  ffi_delete_bucket(client |> @nostd.identity, input).wait() |> ignore
}

///|
extern "js" fn ffi_delete_bucket(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (client, input) => {
  #|  const { DeleteBucketCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new DeleteBucketCommand(input));
  #|}

///|
/// ListBuckets - list all buckets
pub async fn list_buckets(client : S3Client) -> ListBucketsOutput {
  let result = ffi_list_buckets(client |> @nostd.identity).wait()
  let buckets_raw : Array[@nostd.Any] = result["Buckets"].cast()
  let buckets = buckets_raw.map(fn(b) { { name: b["Name"].cast() } })
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
extern "js" fn ffi_list_buckets(client : @nostd.Any) -> @js.Promise[@nostd.Any] =
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
  let input = @nostd.Object::new()
  input["CopySource"] = (sourceBucket + "/" + sourceKey) |> @nostd.any
  input["Bucket"] = destBucket |> @nostd.any
  input["Key"] = destKey |> @nostd.any
  let result = ffi_copy_object(client |> @nostd.identity, input).wait()
  let copy_result = result["CopyObjectResult"]
  { etag: copy_result["ETag"] |> @nostd.identity }
}

///|
pub struct CopyObjectOutput {
  etag : String?
}

///|
extern "js" fn ffi_copy_object(
  client : @nostd.Any,
  input : @nostd.Any,
) -> @js.Promise[@nostd.Any] =
  #|async (client, input) => {
  #|  const { CopyObjectCommand } = require('@aws-sdk/client-s3');
  #|  return client.send(new CopyObjectCommand(input));
  #|}
