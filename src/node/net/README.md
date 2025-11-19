# mizchi/js/node/net

## node:net

TCP/IPC server and socket APIs

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/node/events",
    "mizchi/js/stream",
    "mizchi/js/node/net"
  ]
}
```

### Server
- [x] Server type (extends EventEmitter)
- [x] listen(port, host?) - Start listening
- [x] close() - Stop accepting connections
- [x] address() - Get server address information
- [x] listening() - Check if server is listening
- [x] maxConnections() - Get max connections
- [x] set_maxConnections(max) - Set max connections
- [x] Events: 'connection', 'listening', 'close', 'error' (via EventEmitterImpl)

### Socket
- [x] Socket type (extends Duplex stream, EventEmitter)
- [x] as_duplex() - Cast to Duplex stream
- [x] connect(port, host?) - Connect to server
- [x] write(data) - Write data (returns Bool)
- [x] end() - End connection
- [x] destroy() - Destroy socket
- [x] pause() - Pause reading
- [x] resume_() - Resume reading
- [x] setEncoding(encoding) - Set encoding
- [x] setKeepAlive(enable) - Configure keep-alive
- [x] setNoDelay(noDelay) - Configure Nagle algorithm
- [x] setTimeout(timeout) - Set timeout
- [x] remoteAddress() - Get remote address
- [x] remotePort() - Get remote port
- [x] localAddress() - Get local address
- [x] localPort() - Get local port
- [x] destroyed() - Check if socket is destroyed
- [x] bytesRead() - Get bytes read
- [x] bytesWritten() - Get bytes written
- [x] Events: 'connect', 'data', 'end', 'error', 'close', 'timeout' (via EventEmitterImpl)

### Utility Functions
- [x] createServer(connectionListener?) - Create TCP server
- [x] createConnection(port, host?) - Create client connection (alias: connect)
- [x] connect(port, host?) - Alias for createConnection
- [x] isIP(input) - Check if valid IP address (returns 0, 4, or 6)
- [x] isIPv4(input) - Check if valid IPv4 address
- [x] isIPv6(input) - Check if valid IPv6 address

## Test Coverage
Tests in src/_tests/node_net_test.mbt
