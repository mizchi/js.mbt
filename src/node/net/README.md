# mizchi/js/node/net

## node:net

TCP/IPC server and socket APIs

### Server
- [x] Server type (extends EventEmitter)
- [x] Server::new(options?, connectionListener?) - Create server
- [x] listen(port?, host?, backlog?, callback?) - Start listening
- [x] listen_path(path, backlog?, callback?) - Listen on Unix socket
- [x] close(callback?) - Stop accepting connections
- [x] address() - Get server address information
- [x] getConnections(callback) - Get connection count
- [x] Events: 'connection', 'listening', 'close', 'error'

### Socket
- [x] Socket type (extends Duplex stream)
- [x] Socket::new(options?) - Create socket
- [x] connect(port, host?, connectListener?) - Connect to server
- [x] connect_path(path, connectListener?) - Connect to Unix socket
- [x] write(data, encoding?, callback?) - Write data
- [x] end(data?, encoding?, callback?) - End connection
- [x] destroy(error?) - Destroy socket
- [x] pause() - Pause reading
- [x] resume() - Resume reading
- [x] setTimeout(timeout, callback?) - Set timeout
- [x] setKeepAlive(enable?, initialDelay?) - Configure keep-alive
- [x] setNoDelay(noDelay?) - Configure Nagle algorithm
- [x] Properties: remoteAddress, remotePort, localAddress, localPort
- [x] Events: 'connect', 'data', 'end', 'error', 'close', 'timeout'

### Utility Functions
- [x] createServer(options?, connectionListener?) - Create TCP server
- [x] createConnection(port, host?, connectListener?) - Create client connection
- [x] isIP(input) - Check if valid IP address (returns 0, 4, or 6)
- [x] isIPv4(input) - Check if valid IPv4 address
- [x] isIPv6(input) - Check if valid IPv6 address

## Test Coverage
Tests in src/_tests/node_net_test.mbt
