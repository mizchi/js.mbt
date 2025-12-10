# Node.js Test Timing Report

Measured on 2025-12-10.

## Summary

**Bottleneck: `src/node/http`** - 7 tests take **1.538s**, which is significantly slower than other packages.

## Results (sorted by time, descending)

| Package | Tests | Time | Notes |
|---------|-------|------|-------|
| **http** | 7 | **1.538s** | Slowest |
| http2 | 1 | 0.665s | |
| child_process | 45 | 0.647s | |
| v8 | 31 | 0.558s | |
| assert | 11 | 0.399s | |
| fs_promises | 19 | 0.395s | |
| module | 16 | 0.382s | |
| net | 8 | 0.286s | |
| events | 11 | 0.257s | |
| async_hooks | 7 | 0.243s | |
| buffer | 19 | 0.233s | |
| stream | 18 | 0.232s | |
| dns | 1 | 0.228s | |
| sqlite | 42 | 0.225s | |
| fs | 38 | 0.216s | |
| test | 12 | 0.215s | |
| stream_promises | 10 | 0.212s | |
| vm | 18 | 0.205s | |
| path | 16 | 0.204s | |
| os | 21 | 0.202s | |
| zlib | 3 | 0.198s | |
| url | 7 | 0.192s | |
| wasi | 10 | 0.190s | |
| assert_strict | 11 | 0.182s | |
| util | 5 | 0.175s | |
| inspector | 4 | 0.168s | |
| worker_threads | 3 | 0.166s | |
| process | 1 | 0.165s | |
| tls | 0 | 0.165s | |
| https | 3 | 0.164s | |
| tty | 2 | 0.161s | |
| readline | 0 | 0.161s | |
| readline_promises | 0 | 0.178s | |

## Observations

- `http` is 2.3x slower than the second slowest (`http2`)
- Network-related tests (http, http2, net) tend to be slower due to server setup/teardown
- `child_process` is slow due to process spawning overhead (45 tests)
- `v8` has many tests (31) with serialization/deserialization operations

## Potential Optimizations

1. Investigate `http` tests for unnecessary delays or timeouts
2. Consider parallel test execution for independent tests
3. Reduce server startup/shutdown overhead in network tests
