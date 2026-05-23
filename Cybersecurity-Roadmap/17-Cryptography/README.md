# 🔐 Cryptography

## The Science of Secrets — Encryption, Hashing, and PKI

---

## Overview

Cryptography protects data confidentiality, integrity, and authenticity. Understanding crypto is essential for both attacking (breaking weak crypto) and defending (implementing strong crypto).

---

## Symmetric Encryption

Same key for encryption AND decryption.

```
Plaintext → [Key] → Ciphertext → [Same Key] → Plaintext

Fast, efficient, but key distribution is a problem.
```

| Algorithm | Key Size | Block Size | Status |
|-----------|----------|-----------|--------|
| DES | 56 bit | 64 bit | BROKEN |
| 3DES | 168 bit | 64 bit | Deprecated |
| AES-128 | 128 bit | 128 bit | Secure |
| AES-256 | 256 bit | 128 bit | Very Secure |
| ChaCha20 | 256 bit | Stream | Secure (mobile) |

### AES Example (Python)

```python
from cryptography.fernet import Fernet

# Generate key
key = Fernet.generate_key()
cipher = Fernet(key)

# Encrypt
plaintext = b"Secret message"
ciphertext = cipher.encrypt(plaintext)

# Decrypt
decrypted = cipher.decrypt(ciphertext)
```

---

## Asymmetric Encryption

Two keys: Public (share freely) and Private (keep secret).

```
Encryption: Plaintext → [Public Key] → Ciphertext
Decryption: Ciphertext → [Private Key] → Plaintext

Digital Signature:
Sign:   Message → [Private Key] → Signature
Verify: Signature → [Public Key] → Valid/Invalid
```

| Algorithm | Use | Key Sizes |
|-----------|-----|-----------|
| RSA | Encryption, signatures | 2048, 4096 bit |
| ECC | Faster alternative to RSA | 256, 384 bit |
| Diffie-Hellman | Key exchange | Various |
| Ed25519 | Digital signatures | 256 bit |

---

## Hashing

One-way function: cannot reverse the hash to get the original input.

| Algorithm | Output | Use | Status |
|-----------|--------|-----|--------|
| MD5 | 128 bit | File checksums (NOT security) | Broken |
| SHA-1 | 160 bit | Legacy | Broken |
| SHA-256 | 256 bit | File integrity, blockchain | Secure |
| SHA-512 | 512 bit | High security | Secure |
| bcrypt | Variable | Password storage | Secure |
| Argon2 | Variable | Password storage | Most Secure |

### Why Not MD5/SHA-1 for Passwords?

```
MD5("password") = 5f4dcc3b5aa765d61d8327deb882cf99
→ Same input ALWAYS gives same output
→ Attackers precompute hashes (rainbow tables)
→ Fast to compute = fast to brute force

bcrypt("password") = $2b$12$LJ3m4...random_salt...hashed_result
→ Includes random salt (different every time!)
→ Intentionally SLOW (configurable work factor)
→ Resistant to rainbow tables and brute force
```

---

## TLS/SSL Protocol

```
How HTTPS protects your connection:

1. Client connects to server
2. Server presents certificate (contains public key)
3. Client verifies certificate against trusted CAs
4. Key exchange (Diffie-Hellman) establishes session key
5. All further communication encrypted with session key (AES)
```

---

## PKI (Public Key Infrastructure)

```
┌─────────────────┐
│ Certificate     │  Trusted root authority
│ Authority (CA)  │  (DigiCert, Let's Encrypt)
└────────┬────────┘
         │ Issues certificates
         ▼
┌─────────────────┐
│ Server          │  Proves identity with certificate
│ Certificate     │  Contains: domain, public key, CA signature
└─────────────────┘
```

---

## Cryptographic Attacks

| Attack | Target | Description |
|--------|--------|-------------|
| Brute Force | Weak keys | Try all possible keys |
| Dictionary Attack | Passwords | Try common passwords |
| Rainbow Tables | Unsalted hashes | Precomputed hash lookup |
| Birthday Attack | Hash collisions | Find two inputs with same hash |
| Padding Oracle | Block ciphers | Decrypt by manipulating padding |
| Downgrade Attack | TLS | Force use of weak cipher |
| MITM | Key exchange | Intercept and replace keys |

---

## Practical Exercises

```bash
# Generate RSA key pair
openssl genrsa -out private.key 2048
openssl rsa -in private.key -pubout -out public.key

# Encrypt/decrypt with RSA
openssl rsautl -encrypt -pubin -inkey public.key -in secret.txt -out encrypted.bin
openssl rsautl -decrypt -inkey private.key -in encrypted.bin -out decrypted.txt

# Hash a file
sha256sum file.txt
md5sum file.txt

# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365

# Inspect a certificate
openssl x509 -in cert.pem -text -noout

# Check website's certificate
openssl s_client -connect google.com:443
```

---

**Next:** → [18-CTFs](../18-CTFs/README.md)

*"Cryptography is the last line of defense. Make sure it's strong."*
