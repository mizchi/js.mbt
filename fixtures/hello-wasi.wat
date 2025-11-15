(module
  ;; Import WASI fd_write function
  (import "wasi_snapshot_preview1" "fd_write"
    (func $fd_write (param i32 i32 i32 i32) (result i32)))

  ;; Memory
  (memory 1)
  (export "memory" (memory 0))

  ;; Data section with "Hello, WASI!\n"
  (data (i32.const 8) "Hello, WASI!\n")

  ;; _start function
  (func $_start
    ;; Create an iovec structure at offset 0
    ;; iovec.buf = 8 (pointer to our string)
    (i32.store (i32.const 0) (i32.const 8))
    ;; iovec.buf_len = 13 (length of our string)
    (i32.store (i32.const 4) (i32.const 13))

    ;; Call fd_write(1, 0, 1, 24)
    ;; fd=1 (stdout), iovs=0, iovs_len=1, nwritten=24
    (call $fd_write
      (i32.const 1)   ;; stdout
      (i32.const 0)   ;; pointer to iovec array
      (i32.const 1)   ;; number of iovecs
      (i32.const 24)) ;; pointer to store number of bytes written
    drop
  )
  (export "_start" (func $_start))
)
