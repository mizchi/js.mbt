# mizchi/js/web/crypto

Web Crypto API for cryptographic operations.

## Installation

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/web/crypto"
  ]
}
```

## Overview

Provides bindings for the Web Crypto API for secure cryptographic operations.

## Usage Example

```moonbit
fn main {
  // Generate random values
  let array = @typedarray.Uint8Array::from_size(16)
  @crypto.get_random_values(array)
  
  // Generate UUID
  let uuid = @crypto.random_uuid()  // e.g., "a1b2c3d4-e5f6-..."
  
  // Access SubtleCrypto for advanced operations
  let subtle = @crypto.subtle()
  
  // Generate key pair (requires async)
  // let key_pair = subtle.generate_key(algorithm, extractable, usages)
  
  // Encrypt/Decrypt
  // let encrypted = subtle.encrypt(algorithm, key, data)
  // let decrypted = subtle.decrypt(algorithm, key, encrypted_data)
  
  // Hash data
  // let hash = subtle.digest("SHA-256", data)
}
```

## Available Features

- **getRandomValues()** - Cryptographically secure random numbers
- **randomUUID()** - Generate RFC 4122 UUIDs
- **SubtleCrypto** - Advanced cryptographic operations
  - Key generation and management
  - Encryption/Decryption (AES, RSA)
  - Signing/Verification (HMAC, ECDSA, RSA-PSS)
  - Hashing (SHA-256, SHA-384, SHA-512)
  - Key derivation (PBKDF2, HKDF)

## Reference

- [MDN: Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)
- [MDN: Crypto](https://developer.mozilla.org/en-US/docs/Web/API/Crypto)
- [MDN: SubtleCrypto](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto)
