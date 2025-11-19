# mizchi/js/node/buffer

## node:buffer

Buffer type for binary data manipulation

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/node/buffer"
  ]
}
```

### Buffer Creation
- [x] Buffer::from_string(str, encoding?) - Create from string
- [x] Buffer::from_array(arr) - Create from byte array
- [x] Buffer::from_arraybuffer(ab, byteOffset?, length?) - Create from ArrayBuffer
- [x] Buffer::from_buffer(buf) - Copy from another buffer
- [x] Buffer::alloc(size, fill?, encoding?) - Allocate zero-filled buffer
- [x] Buffer::allocUnsafe(size) - Allocate uninitialized buffer (faster)

### Static Methods
- [x] Buffer::isBuffer(obj) - Check if object is a Buffer
- [x] Buffer::isEncoding(encoding) - Check if encoding is valid
- [x] Buffer::compare(buf1, buf2) - Compare two buffers
- [x] Buffer::concat(buffers, totalLength?) - Concatenate buffers
- [x] Buffer::byteLength(str, encoding?) - Get byte length of string

### Instance Methods
- [x] length() - Get buffer length
- [x] toString(encoding?, start?, end?) - Convert to string
- [x] toJSON() - Convert to JSON representation
- [x] slice(start?, end?) - Create view of buffer
- [x] copy(target, targetStart?, sourceStart?, sourceEnd?) - Copy to target
- [x] fill(value, offset?, end?, encoding?) - Fill with value
- [x] equals(other) - Check equality
- [x] compare(target, targetStart?, targetEnd?, sourceStart?, sourceEnd?) - Compare buffers
- [x] indexOf(value, byteOffset?, encoding?) - Find index of value
- [x] lastIndexOf(value, byteOffset?, encoding?) - Find last index
- [x] includes(value, byteOffset?, encoding?) - Check if contains value

### Read Methods
- [x] readUInt8(offset)
- [x] readUInt16LE(offset)
- [x] readUInt16BE(offset)
- [x] readUInt32LE(offset)
- [x] readUInt32BE(offset)
- [x] readInt8(offset)
- [x] readInt16LE(offset)
- [x] readInt16BE(offset)
- [x] readInt32LE(offset)
- [x] readInt32BE(offset)
- [x] readFloatLE(offset)
- [x] readFloatBE(offset)
- [x] readDoubleLE(offset)
- [x] readDoubleBE(offset)

### Write Methods
- [x] writeUInt8(value, offset)
- [x] writeUInt16LE(value, offset)
- [x] writeUInt16BE(value, offset)
- [x] writeUInt32LE(value, offset)
- [x] writeUInt32BE(value, offset)
- [x] writeInt8(value, offset)
- [x] writeInt16LE(value, offset)
- [x] writeInt16BE(value, offset)
- [x] writeInt32LE(value, offset)
- [x] writeInt32BE(value, offset)
- [x] writeFloatLE(value, offset)
- [x] writeFloatBE(value, offset)
- [x] writeDoubleLE(value, offset)
- [x] writeDoubleBE(value, offset)

### Iteration
- [x] entries() - Get iterator of [index, byte] pairs
- [x] keys() - Get iterator of indices
- [x] values() - Get iterator of byte values

## External Types
- [x] ArrayBuffer - JavaScript ArrayBuffer type
