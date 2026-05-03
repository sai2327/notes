# 07. Cryptography (In-Depth)

## Table of Contents
- [7.1 What is Cryptography?](#71-what-is-cryptography)
- [7.2 Symmetric Encryption](#72-symmetric-encryption)
- [7.3 Asymmetric Encryption](#73-asymmetric-encryption)
- [7.4 Hashing (Deep Dive)](#74-hashing-deep-dive)
- [7.5 Digital Signatures](#75-digital-signatures)
- [7.6 SSL/TLS — How HTTPS Works](#76-ssltls--how-https-works)
- [7.7 Practical Cryptography Commands](#77-practical-cryptography-commands)
- [7.8 Common Mistakes & Interview Tips](#78-common-mistakes--interview-tips)
- [7.9 Practice & Assessment](#79-practice--assessment)

---

## 7.1 What is Cryptography?

### Definition
**Cryptography** is the science of securing information by converting it into an unreadable format (encryption) that can only be read by authorized parties (decryption).

### Key Terminology

| Term | Meaning | Example |
|------|---------|---------|
| **Plaintext** | Original readable data | "Hello World" |
| **Ciphertext** | Encrypted unreadable data | "x9$kL#mQ2z" |
| **Encryption** | Plaintext → Ciphertext | Locking a message |
| **Decryption** | Ciphertext → Plaintext | Unlocking a message |
| **Key** | Secret value used in encryption/decryption | A specific password/number |
| **Cipher** | Algorithm for encryption | AES, RSA, DES |

### Real-World Analogy

```
PLAINTEXT:    "Meet me at 5pm"
                    │
              ┌─────▼─────┐
              │  ENCRYPT   │  ← Key: "SecretKey123"
              │  (AES-256) │
              └─────┬─────┘
                    │
CIPHERTEXT:   "aG9kZXJmOiB3b3JsZA=="
                    │
              ┌─────▼─────┐
              │  DECRYPT   │  ← Same Key: "SecretKey123"
              │  (AES-256) │
              └─────┬─────┘
                    │
PLAINTEXT:    "Meet me at 5pm"
```

---

## 7.2 Symmetric Encryption

### How It Works
**Same key** is used for both encryption AND decryption. Both parties must share the secret key.

```
Alice                                    Bob
  │                                       │
  │── Encrypt with Key K ──► Ciphertext ──│── Decrypt with Key K ──► Plaintext
  │                                       │
  Problem: How do Alice and Bob share Key K securely?
```

### Algorithms

| Algorithm | Key Size | Block Size | Status | Use Case |
|-----------|----------|-----------|--------|----------|
| **AES-128** | 128-bit | 128-bit | ✅ Secure | General encryption |
| **AES-256** | 256-bit | 128-bit | ✅ Secure | Government, military, high-security |
| **ChaCha20** | 256-bit | — (stream) | ✅ Secure | Mobile, TLS 1.3 |
| **3DES** | 168-bit | 64-bit | ⚠️ Deprecated | Legacy systems only |
| **DES** | 56-bit | 64-bit | ❌ Broken | Never use |
| **RC4** | Variable | — (stream) | ❌ Broken | Never use |

### AES Modes of Operation

| Mode | Name | Use | Parallelizable? |
|------|------|-----|----------------|
| ECB | Electronic Codebook | ❌ Never use (patterns visible) | Yes |
| CBC | Cipher Block Chaining | File encryption | Encrypt: No, Decrypt: Yes |
| CTR | Counter | Disk encryption, streaming | Yes |
| GCM | Galois/Counter Mode | TLS, authenticated encryption | Yes |

### Practical — AES Encryption with OpenSSL

```bash
# Encrypt a file with AES-256-CBC
openssl enc -aes-256-cbc -salt -in secret.txt -out secret.enc -pass pass:MyPassword123

# Decrypt the file
openssl enc -d -aes-256-cbc -in secret.enc -out decrypted.txt -pass pass:MyPassword123

# Verify
diff secret.txt decrypted.txt
# No output = files are identical ✓
```

---

## 7.3 Asymmetric Encryption

### How It Works
**Two mathematically linked keys**: Public key (shared with everyone) + Private key (kept secret).

```
ENCRYPTION (Confidentiality):
  Alice encrypts with Bob's PUBLIC key ──► Only Bob's PRIVATE key can decrypt

DIGITAL SIGNATURE (Authentication):
  Alice signs with her PRIVATE key ──► Anyone with Alice's PUBLIC key can verify
```

### Algorithms

| Algorithm | Key Size | Speed | Use Case |
|-----------|----------|-------|----------|
| **RSA-2048** | 2048-bit | Slow | Key exchange, digital signatures |
| **RSA-4096** | 4096-bit | Very slow | High-security keys |
| **ECC P-256** | 256-bit | Moderate | Modern TLS, mobile (smaller keys) |
| **Ed25519** | 256-bit | Fast | SSH keys, modern signatures |
| **Diffie-Hellman** | Variable | — | Key exchange only |

### RSA vs ECC

| Feature | RSA-2048 | ECC P-256 |
|---------|----------|-----------|
| Key size | 2048 bits | 256 bits |
| Security level | 112-bit | 128-bit |
| Performance | Slower | Faster |
| Certificate size | Larger | Smaller |
| Adoption | Universal | Growing |

### Practical — RSA Key Generation

```bash
# Generate RSA private key (2048-bit)
openssl genrsa -out private.pem 2048

# Extract public key from private key
openssl rsa -in private.pem -pubout -out public.pem

# Encrypt a file with public key
openssl rsautl -encrypt -pubin -inkey public.pem -in message.txt -out encrypted.bin

# Decrypt with private key
openssl rsautl -decrypt -inkey private.pem -in encrypted.bin -out decrypted.txt
```

### Practical — SSH Key Generation

```bash
# Generate SSH key pair (Ed25519 — modern, recommended)
ssh-keygen -t ed25519 -C "user@email.com"

# Generate SSH key pair (RSA — compatible)
ssh-keygen -t rsa -b 4096 -C "user@email.com"

# Copy public key to server
ssh-copy-id user@server_ip

# Now login without password
ssh user@server_ip
```

---

## 7.4 Hashing (Deep Dive)

### How Hashing Works

```
Input (any size)  ──► Hash Function ──► Fixed-size output (digest)

"Hello"           ──► SHA-256 ──► 185f8db32271fe25f561a6fc938b2e26...
"Hello!"          ──► SHA-256 ──► 334d016f755cd6dc58c53a86e183882f...
"Hello"           ──► SHA-256 ──► 185f8db32271fe25f561a6fc938b2e26...
                                  ↑ Same input = ALWAYS same output
```

### Hash vs Encryption

| Feature | Hashing | Encryption |
|---------|---------|------------|
| Direction | One-way (irreversible) | Two-way (reversible) |
| Key needed? | No | Yes |
| Output size | Fixed | Variable |
| Purpose | Verify integrity | Protect confidentiality |
| Can recover original? | No | Yes (with key) |

### Password Storage — Why Hashing Matters

```
❌ WRONG: Store password in plaintext
   Database: admin | password123

❌ WRONG: Store unsalted hash
   Database: admin | ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
   Problem: Same password → same hash (rainbow table attack)

✅ RIGHT: Store salted hash with slow algorithm
   Database: admin | $2b$12$LJ3m4sMvWpSuDnW...
   
   How salting works:
   password + "x7Km9Q" (random salt) → hash → unique result
   password + "pR3nZw" (different salt) → hash → different result!
   Same password, different hashes. Rainbow tables useless.
```

### Practical — Hashing Commands

```bash
# Generate hashes (Linux)
echo -n "Hello" | md5sum
echo -n "Hello" | sha1sum
echo -n "Hello" | sha256sum
echo -n "Hello" | sha512sum

# Hash a file
sha256sum important_file.txt

# Verify file integrity (compare hashes)
sha256sum downloaded_file.iso
# Compare with hash from official website

# Generate password hash (Linux)
openssl passwd -6 -salt randomsalt MyPassword
# $6$randomsalt$<hash>  ← SHA-512 with salt
```

### Hash Cracking (Ethical/Lab Use Only)

```bash
# John the Ripper
echo "admin:5f4dcc3b5aa765d61d8327deb882cf99" > hashes.txt
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
john --show hashes.txt

# Hashcat (GPU-accelerated)
hashcat -m 0 -a 0 hash.txt rockyou.txt
# -m 0 = MD5
# -m 100 = SHA1
# -m 1400 = SHA256
# -m 1000 = NTLM (Windows)
# -m 3200 = bcrypt
```

---

## 7.5 Digital Signatures

### How Digital Signatures Work

```
SIGNING (Sender):
  1. Hash the document → digest
  2. Encrypt digest with sender's PRIVATE key → signature
  3. Send document + signature

VERIFICATION (Receiver):
  1. Decrypt signature with sender's PUBLIC key → original digest
  2. Hash the received document → new digest
  3. Compare: original digest == new digest?
     YES → Document is authentic and unmodified ✓
     NO  → Document was tampered with ✗
```

```
            Document
               │
         ┌─────▼─────┐
         │   SHA-256  │─────────────── Hash (Digest)
         └───────────┘                     │
                                    ┌──────▼──────┐
                                    │ Encrypt with │
                                    │ PRIVATE key  │
                                    └──────┬──────┘
                                           │
                                    Digital Signature
```

### What Digital Signatures Provide

| Property | Meaning |
|----------|---------|
| **Authentication** | Proves who sent the message |
| **Integrity** | Proves message wasn't changed |
| **Non-repudiation** | Sender cannot deny sending it |

### Practical — Create & Verify Digital Signature

```bash
# 1. Create a document
echo "This is an important contract." > document.txt

# 2. Sign the document (creates signature file)
openssl dgst -sha256 -sign private.pem -out signature.bin document.txt

# 3. Verify the signature
openssl dgst -sha256 -verify public.pem -signature signature.bin document.txt
# Output: "Verified OK" ← authentic and unmodified

# 4. Tamper with document and re-verify
echo "Modified!" >> document.txt
openssl dgst -sha256 -verify public.pem -signature signature.bin document.txt
# Output: "Verification Failure" ← document was changed!
```

---

## 7.6 SSL/TLS — How HTTPS Works

### TLS Handshake (Simplified)

```
Client (Browser)                          Server (Website)
      │                                        │
  1.  │── ClientHello ────────────────────────►│
      │   (supported ciphers, TLS version)     │
      │                                        │
  2.  │◄── ServerHello ───────────────────────│
      │   (chosen cipher, TLS version)         │
      │                                        │
  3.  │◄── Certificate ──────────────────────│
      │   (server's public key + CA signature) │
      │                                        │
  4.  │   Browser verifies certificate:        │
      │   ✓ Signed by trusted CA?              │
      │   ✓ Domain name matches?               │
      │   ✓ Not expired?                       │
      │   ✓ Not revoked?                       │
      │                                        │
  5.  │── Key Exchange ──────────────────────►│
      │   (pre-master secret encrypted with    │
      │    server's public key)                │
      │                                        │
  6.  │   Both derive session key (symmetric)  │
      │                                        │
  7.  │◄══ Encrypted data (AES) ════════════►│
```

### TLS Versions

| Version | Year | Status | Notes |
|---------|------|--------|-------|
| SSL 2.0 | 1995 | ❌ Broken | Never use |
| SSL 3.0 | 1996 | ❌ Broken (POODLE) | Never use |
| TLS 1.0 | 1999 | ❌ Deprecated | Don't use |
| TLS 1.1 | 2006 | ❌ Deprecated | Don't use |
| TLS 1.2 | 2008 | ✅ Acceptable | Widely used |
| TLS 1.3 | 2018 | ✅ Recommended | Faster, more secure |

### Practical — Inspect TLS Certificates

```bash
# Check a website's TLS certificate
openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | \
  openssl x509 -text -noout | head -30

# Check certificate expiry
echo | openssl s_client -connect example.com:443 2>/dev/null | \
  openssl x509 -noout -dates

# Check which TLS versions a server supports
nmap --script ssl-enum-ciphers -p 443 example.com

# Test for weak SSL/TLS (using testssl.sh)
./testssl.sh https://example.com
```

---

## 7.7 Practical Cryptography Commands

### Complete Reference

```bash
# ═══════════════════════════════════════
# HASHING
# ═══════════════════════════════════════
echo -n "text" | md5sum              # MD5 (don't use for security)
echo -n "text" | sha256sum           # SHA-256
sha256sum file.txt                   # Hash a file
sha256sum -c checksums.txt           # Verify checksums

# ═══════════════════════════════════════
# SYMMETRIC ENCRYPTION (AES)
# ═══════════════════════════════════════
# Encrypt
openssl enc -aes-256-cbc -salt -pbkdf2 -in file.txt -out file.enc
# Decrypt
openssl enc -d -aes-256-cbc -pbkdf2 -in file.enc -out file.txt

# ═══════════════════════════════════════
# ASYMMETRIC ENCRYPTION (RSA)
# ═══════════════════════════════════════
# Generate key pair
openssl genrsa -out private.pem 4096
openssl rsa -in private.pem -pubout -out public.pem

# Encrypt with public key
openssl rsautl -encrypt -pubin -inkey public.pem -in msg.txt -out msg.enc
# Decrypt with private key
openssl rsautl -decrypt -inkey private.pem -in msg.enc

# ═══════════════════════════════════════
# DIGITAL SIGNATURES
# ═══════════════════════════════════════
# Sign
openssl dgst -sha256 -sign private.pem -out sig.bin document.txt
# Verify
openssl dgst -sha256 -verify public.pem -signature sig.bin document.txt

# ═══════════════════════════════════════
# CERTIFICATES
# ═══════════════════════════════════════
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
# View certificate
openssl x509 -in cert.pem -text -noout

# ═══════════════════════════════════════
# BASE64 ENCODING (NOT encryption!)
# ═══════════════════════════════════════
echo -n "Hello" | base64              # Encode: SGVsbG8=
echo "SGVsbG8=" | base64 -d           # Decode: Hello
```

---

## 7.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|-----------------|
| Using MD5 for passwords | Broken, fast to crack | Use bcrypt or Argon2 |
| Encoding ≠ Encryption | Base64 is NOT security | Use AES/RSA for security |
| Storing encryption keys with data | Key compromise = data compromise | Separate key management (KMS) |
| Using ECB mode | Patterns in plaintext visible in ciphertext | Use GCM or CBC mode |
| Hardcoding keys in source code | Anyone reading code gets the key | Use environment variables or vaults |

### Interview Questions

**Q: What is the difference between symmetric and asymmetric encryption?**
> Symmetric uses one shared key for both encryption and decryption (fast, key distribution problem). Asymmetric uses a public/private key pair (slower, solves key distribution).

**Q: Why can't you reverse a hash?**
> Hash functions are one-way mathematical operations designed to lose information. Multiple inputs can produce the same output (many-to-one mapping), making reversal mathematically impossible.

**Q: What is the difference between hashing and encryption?**
> Hashing is one-way (cannot recover original), used for integrity verification. Encryption is two-way (can recover original with key), used for confidentiality.

**Q: How does HTTPS protect data?**
> TLS uses asymmetric encryption for key exchange, then symmetric encryption (AES) for actual data transfer. This combines the security of asymmetric with the speed of symmetric.

**Q: What is a digital signature and what does it prove?**
> A digital signature is created by hashing a document and encrypting the hash with the sender's private key. It proves authentication (who sent it), integrity (not modified), and non-repudiation (sender can't deny it).

---

## 7.9 Practice & Assessment

### MCQs

**Q1.** AES is a type of:
- A) Asymmetric encryption
- B) Symmetric encryption
- C) Hashing algorithm
- D) Digital signature

**Answer:** B) Symmetric encryption

---

**Q2.** SHA-256 output is always:
- A) 128 bits
- B) 160 bits
- C) 256 bits
- D) Variable length

**Answer:** C) 256 bits (64 hex characters)

---

**Q3.** The main problem with symmetric encryption is:
- A) It's too slow
- B) Key distribution — sharing the secret key securely
- C) It can't encrypt large files
- D) It requires the internet

**Answer:** B) Key distribution

---

**Q4.** Which of these provides non-repudiation?
- A) Symmetric encryption
- B) Hashing
- C) Digital signatures
- D) Base64 encoding

**Answer:** C) Digital signatures

---

**Q5.** TLS 1.3 is recommended because:
- A) It's the oldest version
- B) It removes insecure ciphers and is faster
- C) It doesn't use encryption
- D) It uses MD5

**Answer:** B) It removes insecure ciphers and is faster

---

### Tool-Based Exercises

**Exercise 1:** Generate a SHA-256 hash of the string "cybersecurity" using the command line. Then change one character and hash again. Compare the outputs.

**Exercise 2:** Use OpenSSL to encrypt a file with AES-256-CBC, then decrypt it and verify the contents match.

**Exercise 3:** Generate an RSA key pair, encrypt a small message with the public key, and decrypt with the private key.

---

> **Next Topic:** [08 - Web Security](08-web-security.md)
