///|
/// Tests for client_s3 against MinIO
///
/// To run these tests, start MinIO server first:
///   minio server /tmp/minio-data
///
/// MinIO will start on http://127.0.0.1:9000
/// Default credentials: minioadmin/minioadmin
///
/// Then run: moon test --package client_s3

///|
/// Create a test client for MinIO
fn create_test_client() -> @client_s3.S3Client {
  @client_s3.S3Client::new(
    region="us-east-1",
    endpoint="http://127.0.0.1:9000",
    accessKeyId="minioadmin",
    secretAccessKey="minioadmin",
    forcePathStyle=true,
  )
}

///|
/// Test bucket name (unique per test run)
fn test_bucket() -> String {
  "moonbit-test-bucket"
}

///|
#skip
async test "create and delete bucket" {
  let client = create_test_client()
  let bucket = test_bucket() + "-create"
  // Create bucket
  @client_s3.create_bucket(client, bucket)
  // List buckets to verify
  let result = @client_s3.list_buckets(client)
  let found = result.buckets.iter().any(fn(b) { b.name == Some(bucket) })
  assert_true(found)
  // Delete bucket
  @client_s3.delete_bucket(client, bucket)
}

///|
#skip
async test "put, get, and delete object" {
  let client = create_test_client()
  let bucket = test_bucket() + "-objects"
  // Create bucket first
  @client_s3.create_bucket(client, bucket)
  // Put object
  let key = "test-file.txt"
  let body = "Hello, MinIO from MoonBit!"
  let put_result = @client_s3.put_object(
    client,
    bucket,
    key,
    body,
    contentType="text/plain",
  )
  assert_true(put_result.etag is Some(_))
  // Get object
  let get_result = @client_s3.get_object(client, bucket, key)
  let content = get_result.body_as_string()
  assert_eq(content, body)
  assert_eq(get_result.content_type, Some("text/plain"))
  // Delete object
  @client_s3.delete_object(client, bucket, key) |> ignore
  // Delete bucket
  @client_s3.delete_bucket(client, bucket)
}

///|
#skip
async test "head object" {
  let client = create_test_client()
  let bucket = test_bucket() + "-head"
  @client_s3.create_bucket(client, bucket)
  // Put object
  let key = "test-head.txt"
  let body = "Test content for head"
  @client_s3.put_object(client, bucket, key, body) |> ignore
  // Head object
  let head_result = @client_s3.head_object(client, bucket, key)
  assert_true(head_result.etag is Some(_))
  assert_eq(head_result.content_length, Some(body.length()))
  // Cleanup
  @client_s3.delete_object(client, bucket, key) |> ignore
  @client_s3.delete_bucket(client, bucket)
}

///|
#skip
async test "list objects" {
  let client = create_test_client()
  let bucket = test_bucket() + "-list"
  @client_s3.create_bucket(client, bucket)
  // Put multiple objects
  @client_s3.put_object(client, bucket, "file1.txt", "content1") |> ignore
  @client_s3.put_object(client, bucket, "file2.txt", "content2") |> ignore
  @client_s3.put_object(client, bucket, "dir/file3.txt", "content3") |> ignore
  // List all objects
  let list_result = @client_s3.list_objects_v2(client, bucket)
  assert_eq(list_result.contents.length(), 3)
  // List with prefix
  let list_dir = @client_s3.list_objects_v2(client, bucket, prefix="dir/")
  assert_eq(list_dir.contents.length(), 1)
  // Cleanup
  @client_s3.delete_object(client, bucket, "file1.txt") |> ignore
  @client_s3.delete_object(client, bucket, "file2.txt") |> ignore
  @client_s3.delete_object(client, bucket, "dir/file3.txt") |> ignore
  @client_s3.delete_bucket(client, bucket)
}

///|
#skip
async test "copy object" {
  let client = create_test_client()
  let bucket = test_bucket() + "-copy"
  @client_s3.create_bucket(client, bucket)
  // Put source object
  let source_key = "source.txt"
  let body = "Content to copy"
  @client_s3.put_object(client, bucket, source_key, body) |> ignore
  // Copy object
  let dest_key = "dest.txt"
  let copy_result = @client_s3.copy_object(
    client, bucket, source_key, bucket, dest_key,
  )
  assert_true(copy_result.etag is Some(_))
  // Verify copied object
  let get_result = @client_s3.get_object(client, bucket, dest_key)
  let content = get_result.body_as_string()
  assert_eq(content, body)
  // Cleanup
  @client_s3.delete_object(client, bucket, source_key) |> ignore
  @client_s3.delete_object(client, bucket, dest_key) |> ignore
  @client_s3.delete_bucket(client, bucket)
}
