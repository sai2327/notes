# Pillar 4: Core Security Concepts

## Table of Contents
- [4.1 Core Theory](#41-core-theory)
- [4.2 The CIA Triad](#42-the-cia-triad)
- [4.3 Identity and Access Management (IAM)](#43-identity-and-access-management-iam)
- [4.4 Cryptography Fundamentals](#44-cryptography-fundamentals)
- [4.5 Hashing](#45-hashing)
- [4.6 Digital Certificates & PKI](#46-digital-certificates--pki)
- [4.7 Common Attack Frameworks](#47-common-attack-frameworks)
- [4.8 The Hacker's View](#48-the-hackers-view)
- [4.9 Quick Reference Tables](#49-quick-reference-tables)
- [4.10 Hands-on Challenges](#410-hands-on-challenges)

---

## 4.1 Core Theory

### The Security Mindset

Security is not a product — it's a **process**. The goal is not to make a system "unhackable" (impossible) but to:

1. **Raise the cost** of an attack above the value of the target
2. **Detect** attacks quickly when they occur
3. **Respond** effectively to minimize damage
4. **Recover** to a known-good state

### Defense in Depth

No single control is sufficient. Security uses **layered defenses**:

```
┌─────────────────────────────────────────────────────────┐
│  Physical Security (locks, badges, cameras)              │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Network Security (firewall, IDS/IPS, VPN)        │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │  Host Security (AV, hardening, patching)    │  │  │
│  │  │  ┌───────────────────────────────────────┐  │  │  │
│  │  │  │  Application Security (WAF, coding)   │  │  │  │
│  │  │  │  ┌─────────────────────────────────┐  │  │  │  │
│  │  │  │  │  Data Security (encryption, DLP) │  │  │  │  │
│  │  │  │  └─────────────────────────────────┘  │  │  │  │
│  │  │  └───────────────────────────────────────┘  │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Least Privilege Principle

Every user, process, and system should have **only the minimum access necessary** to perform its function. Nothing more.

---

## 4.2 The CIA Triad

The three fundamental goals of information security:

```
           Confidentiality
                 ▲
                / \
               /   \
              / CIA  \
             /  Triad \
            /___________\
    Integrity ◄────────► Availability
```

### Confidentiality

**Definition:** Only authorized parties can access the information.

| Control | Mechanism | Example |
|---------|-----------|---------|
| Encryption | Transform data into unreadable form | AES-256 on disk, TLS in transit |
| Access Control | Restrict who can view | RBAC, file permissions |
| Data Classification | Label sensitivity levels | Public, Internal, Confidential, Secret |
| Network Segmentation | Isolate sensitive systems | VLANs, DMZ |
| Data Masking | Hide portions of data | `****-****-****-4532` |

**Threats to Confidentiality:**
- Data breaches (unauthorized access)
- Eavesdropping / packet sniffing
- Social engineering / phishing
- Shoulder surfing
- Dumpster diving

### Integrity

**Definition:** Data has not been altered or tampered with in an unauthorized way.

| Control | Mechanism | Example |
|---------|-----------|---------|
| Hashing | Verify data hasn't changed | SHA-256 checksums |
| Digital Signatures | Prove authenticity + integrity | Code signing, email S/MIME |
| Version Control | Track changes | Git, database audit logs |
| Input Validation | Reject malformed data | Whitelist allowed characters |
| Checksums | Verify file integrity | MD5/SHA for downloads |

**Threats to Integrity:**
- Man-in-the-Middle modification
- SQL Injection (modifying database)
- Malware (modifying files)
- Unauthorized insider changes
- Bit rot / hardware failure

### Availability

**Definition:** Systems and data are accessible when authorized users need them.

| Control | Mechanism | Example |
|---------|-----------|---------|
| Redundancy | Eliminate single points of failure | RAID, load balancers, clustering |
| Backups | Recover from data loss | 3-2-1 rule (3 copies, 2 media, 1 offsite) |
| DDoS Protection | Absorb/mitigate floods | CDN, rate limiting, scrubbing centers |
| Patch Management | Prevent exploitation | Regular updates, vulnerability scanning |
| Disaster Recovery | Resume operations after failure | DR site, RTO/RPO planning |

**Threats to Availability:**
- DDoS attacks
- Ransomware
- Hardware failure
- Natural disasters
- Power outages

### CIA Triad — Real-World Scenario

**Online Banking:**
- **Confidentiality:** Only you can see your balance (encryption, MFA)
- **Integrity:** No one can modify your transaction amounts (digital signatures, audit logs)
- **Availability:** You can access your account 24/7 (redundancy, DDoS protection)

---

## 4.3 Identity and Access Management (IAM)

### Authentication vs Authorization

| Concept | Question Answered | Example |
|---------|-------------------|---------|
| **Identification** | "Who are you?" | Username, email |
| **Authentication** | "Prove it." | Password, biometric, token |
| **Authorization** | "What can you do?" | Permissions, roles, policies |
| **Accountability** | "What did you do?" | Audit logs, monitoring |

### Authentication Factors

| Factor | Type | Examples |
|--------|------|----------|
| Something you **know** | Knowledge | Password, PIN, security question |
| Something you **have** | Possession | Smart card, hardware token, phone (SMS/App) |
| Something you **are** | Biometric | Fingerprint, face, iris, voice |
| Somewhere you **are** | Location | GPS, IP geolocation |
| Something you **do** | Behavior | Typing pattern, gait analysis |

**Multi-Factor Authentication (MFA):** Combines 2+ different factor TYPES. (Two passwords = NOT MFA.)

### Access Control Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **DAC** (Discretionary) | Owner decides who gets access | Linux file permissions, Windows NTFS |
| **MAC** (Mandatory) | System enforces based on labels | Military (Top Secret, Secret, Classified) |
| **RBAC** (Role-Based) | Access based on job role | Employee, Manager, Admin |
| **ABAC** (Attribute-Based) | Access based on attributes/context | Allow if: role=doctor AND time=business_hours AND location=hospital |
| **Zero Trust** | Never trust, always verify | Modern cloud environments |

### RBAC Example

```
Roles:
┌──────────────┬─────────────────────────────────────────┐
│ Role         │ Permissions                              │
├──────────────┼─────────────────────────────────────────┤
│ Viewer       │ Read reports                             │
│ Analyst      │ Read + Create reports                    │
│ Manager      │ Read + Create + Approve + Delete reports │
│ Admin        │ Full control + User management           │
└──────────────┴─────────────────────────────────────────┘

Users → Roles:
  Alice → Analyst
  Bob   → Manager
  Carol → Admin
```

### Password Security

| Practice | Recommendation |
|----------|---------------|
| Length | Minimum 12-16 characters |
| Complexity | Mix of upper, lower, numbers, symbols |
| Storage | Never plaintext — use bcrypt/Argon2 hashing |
| Reuse | Never reuse across services |
| Rotation | Change only if compromised (NIST 800-63B) |
| MFA | Always enable where available |

---

## 4.4 Cryptography Fundamentals

### Encryption Overview

**Encryption:** Converting plaintext into ciphertext using an algorithm and a key.  
**Decryption:** Reversing the process using the correct key.

```
Plaintext ──[Algorithm + Key]──► Ciphertext ──[Algorithm + Key]──► Plaintext
  "Hello"       AES-256             "x9#kL..."       AES-256          "Hello"
```

### Symmetric Encryption

**Same key** for encryption AND decryption.

```
Alice ──[Key K]──► Ciphertext ──[Key K]──► Bob
         Encrypt                   Decrypt

Problem: How do Alice and Bob securely share Key K?
```

| Algorithm | Key Size | Speed | Use Case |
|-----------|----------|-------|----------|
| AES-128 | 128 bit | Fast | General data encryption |
| AES-256 | 256 bit | Fast | High-security data at rest |
| ChaCha20 | 256 bit | Fast | Mobile, TLS (alternative to AES) |
| 3DES | 168 bit | Slow | Legacy systems (deprecated) |
| RC4 | Variable | Fast | DEPRECATED (broken) |

**Strengths:** Very fast, efficient for large data.  
**Weakness:** Key distribution problem — both parties need the same secret key.

### Asymmetric Encryption

**Two mathematically linked keys:** Public key (shared) + Private key (secret).

```
Encryption:
  Alice encrypts with Bob's PUBLIC key → Only Bob's PRIVATE key can decrypt

Digital Signature:
  Alice signs with her PRIVATE key → Anyone with Alice's PUBLIC key can verify
```

| Algorithm | Key Size | Speed | Use Case |
|-----------|----------|-------|----------|
| RSA | 2048-4096 bit | Slow | Key exchange, digital signatures |
| ECC | 256-384 bit | Moderate | Modern TLS, mobile |
| Diffie-Hellman | Variable | — | Key exchange only |
| DSA | 2048+ bit | Moderate | Digital signatures |

**Strengths:** Solves key distribution, enables digital signatures.  
**Weakness:** Much slower than symmetric encryption.

### Hybrid Encryption (How TLS/HTTPS Works)

Real-world systems combine both:

```
1. Asymmetric: Exchange a symmetric key securely
   Client → encrypts random key with server's PUBLIC key → Server
   Server → decrypts with PRIVATE key → Both have same symmetric key

2. Symmetric: Encrypt actual data with the shared key (fast)
   Client ←══[AES encrypted traffic]══► Server
```

---

## 4.5 Hashing

### What is Hashing?

A **hash function** converts input of any size into a fixed-size output (digest). It is **one-way** — you cannot reverse a hash back to the original.

```
"Hello"      → SHA-256 → 185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969
"Hello!"     → SHA-256 → 334d016f755cd6dc58c53a86e183882f8ec14f52fb05345887c8a5edd42c87b7
"Hello"      → SHA-256 → 185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969
```

### Properties of a Good Hash

| Property | Meaning |
|----------|---------|
| **Deterministic** | Same input always produces same output |
| **Fixed-length** | Output is always the same size regardless of input |
| **One-way** | Cannot reverse the hash to get original input |
| **Collision-resistant** | Extremely unlikely two inputs produce same hash |
| **Avalanche effect** | Tiny input change → completely different output |

### Common Hash Algorithms

| Algorithm | Output Size | Status | Use |
|-----------|-------------|--------|-----|
| MD5 | 128 bit (32 hex) | BROKEN | File checksums only (not security) |
| SHA-1 | 160 bit (40 hex) | WEAK | Legacy, being phased out |
| SHA-256 | 256 bit (64 hex) | SECURE | Digital signatures, certificates |
| SHA-512 | 512 bit (128 hex) | SECURE | High-security applications |
| bcrypt | Variable | SECURE | Password hashing (includes salt + work factor) |
| Argon2 | Variable | SECURE | Modern password hashing (memory-hard) |

### Hashing vs Encryption

| Feature | Hashing | Encryption |
|---------|---------|------------|
| Reversible? | NO (one-way) | YES (with key) |
| Purpose | Verify integrity | Protect confidentiality |
| Key needed? | No | Yes |
| Output size | Fixed (always same length) | Variable (depends on input) |
| Use cases | Passwords, integrity, signatures | Data at rest, data in transit |

### Password Hashing Best Practices

```
WRONG:
  Store: password123                          (plaintext!)
  Store: 5f4dcc3b5aa765d61d8327deb882cf99    (unsalted MD5)

RIGHT:
  Store: $2b$12$LJ3m4sMvWpSuDnWKL5Xq.eV6hNpGxS3YxK1P7b9O9Kt3vNqYtW
         └─bcrypt─┘└cost┘└────────── salt + hash ──────────────┘

Why salt?
  Without salt: "password123" always → same hash (rainbow table attack)
  With salt:    "password123" + random_salt → unique hash every time
```

### Rainbow Table Attack

```
Precomputed table:
  "password"    → 5f4dcc3b...
  "123456"      → e10adc39...
  "admin"       → 21232f29...
  ... millions of entries

Attack: Attacker steals database of unsalted hashes.
        Looks up each hash in rainbow table → instant crack.

Defense: Salting makes rainbow tables useless (each hash is unique).
```

---

## 4.6 Digital Certificates & PKI

### Public Key Infrastructure (PKI)

**Problem:** How do you know a public key actually belongs to who they claim?  
**Solution:** A trusted third party (Certificate Authority) vouches for it.

```
Certificate Chain:
  Root CA (self-signed, built into browsers/OS)
    └── Intermediate CA (signed by Root)
          └── Server Certificate (signed by Intermediate)
                  Contains: domain name, public key, validity dates, issuer
```

### How HTTPS Uses Certificates

```
1. Browser connects to https://bank.com
2. Server sends its certificate (contains public key)
3. Browser checks:
   ✓ Is it signed by a trusted CA?
   ✓ Is the domain name correct?
   ✓ Is it within validity dates?
   ✓ Is it revoked? (CRL/OCSP check)
4. If valid → use public key for key exchange
5. Establish encrypted session
```

### Certificate Contents

| Field | Example |
|-------|---------|
| Subject | CN=www.bank.com |
| Issuer | CN=DigiCert SHA2 Secure Server CA |
| Valid From | 2024-01-15 |
| Valid To | 2025-01-15 |
| Public Key | RSA 2048-bit |
| Signature Algorithm | SHA256withRSA |
| Serial Number | 0A:1B:2C:3D:... |
| SAN (Subject Alternative Names) | bank.com, www.bank.com, api.bank.com |

---

## 4.7 Common Attack Frameworks

### MITRE ATT&CK Framework

A comprehensive matrix of adversary tactics and techniques:

| Tactic | Goal | Example Techniques |
|--------|------|-------------------|
| Reconnaissance | Gather info about target | OSINT, port scanning, social media |
| Resource Development | Set up infrastructure | Buy domains, create phishing pages |
| Initial Access | Get first foothold | Phishing, exploiting public apps |
| Execution | Run malicious code | PowerShell, cmd, scripting |
| Persistence | Maintain access | Registry keys, scheduled tasks, backdoors |
| Privilege Escalation | Get higher permissions | Exploit SUID, token manipulation |
| Defense Evasion | Avoid detection | Obfuscation, disable AV, log clearing |
| Credential Access | Steal credentials | Mimikatz, keyloggers, brute force |
| Discovery | Map the environment | `net user`, `whoami`, network scanning |
| Lateral Movement | Move to other systems | Pass-the-Hash, RDP, SSH |
| Collection | Gather target data | Screen capture, clipboard, files |
| Exfiltration | Steal data out | HTTPS, DNS tunneling, USB |
| Impact | Disrupt/destroy | Ransomware, wiper, DDoS |

### Cyber Kill Chain (Lockheed Martin)

```
1. Reconnaissance  → Research target (OSINT, scanning)
2. Weaponization   → Create exploit + payload
3. Delivery        → Send to target (email, web, USB)
4. Exploitation    → Trigger the vulnerability
5. Installation    → Install backdoor/malware
6. C2 (Command & Control) → Establish communication
7. Actions on Objective → Achieve goal (steal data, destroy)
```

**Defender's goal:** Break the chain as early as possible.

---

## 4.8 The Hacker's View

### Cryptographic Attacks

| Attack | Target | Description |
|--------|--------|-------------|
| Brute Force | Weak passwords/keys | Try all possible combinations |
| Dictionary Attack | Passwords | Try common words/phrases |
| Rainbow Table | Unsalted hashes | Pre-computed hash lookup |
| Birthday Attack | Hash collisions | Find two inputs with same hash |
| Man-in-the-Middle | Key exchange | Intercept and replace public keys |
| Downgrade Attack | Protocol negotiation | Force use of weaker algorithms |
| Side-Channel | Implementation | Timing, power consumption, EM leaks |
| Known-Plaintext | Encryption | Attacker has both plain and cipher text |

### Authentication Bypass Techniques

```
1. Credential Stuffing
   → Use leaked username:password pairs from other breaches
   → Many people reuse passwords across services

2. Session Hijacking
   → Steal session cookie (via XSS, packet sniffing)
   → Use cookie to impersonate authenticated user

3. Token Manipulation
   → Modify JWT token (if weak/no signature verification)
   → Change role:"user" to role:"admin"

4. Kerberoasting (Windows AD)
   → Request service tickets for service accounts
   → Crack the ticket offline to get service account password
   → Service accounts often have high privileges

5. Pass-the-Hash
   → Steal NTLM hash from memory (Mimikatz)
   → Use hash directly for authentication (no need to crack)
```

### Real-World Breach Pattern

```
Phase 1: Reconnaissance
  → LinkedIn for employee names/roles
  → Shodan for exposed services
  → DNS enumeration for subdomains

Phase 2: Initial Access
  → Spear phishing email to HR department
  → Macro-enabled Word document
  → User enables macros → PowerShell executes

Phase 3: Establish Foothold
  → Download C2 agent
  → Establish encrypted HTTPS callback
  → Create scheduled task for persistence

Phase 4: Privilege Escalation
  → Enumerate local system → find unpatched kernel
  → Exploit → SYSTEM privileges

Phase 5: Lateral Movement
  → Dump credentials (Mimikatz)
  → Pass-the-Hash to domain controller
  → Now: Domain Admin

Phase 6: Exfiltration
  → Identify sensitive file shares
  → Compress + encrypt data
  → Exfiltrate via DNS tunneling (bypasses firewalls)
  → Total time: 4-8 hours (in many real breaches)
```

---

## 4.9 Quick Reference Tables

### Encryption Algorithm Comparison

| Algorithm | Type | Key Size | Speed | Status | Use Case |
|-----------|------|----------|-------|--------|----------|
| AES-256 | Symmetric | 256 bit | Fast | Secure | Data at rest, TLS |
| ChaCha20 | Symmetric | 256 bit | Fast | Secure | Mobile TLS |
| RSA-2048 | Asymmetric | 2048 bit | Slow | Secure | Key exchange, signatures |
| RSA-4096 | Asymmetric | 4096 bit | Very slow | Secure | High-value keys |
| ECC P-256 | Asymmetric | 256 bit | Moderate | Secure | Modern TLS, IoT |
| DES | Symmetric | 56 bit | Fast | BROKEN | — (never use) |
| 3DES | Symmetric | 168 bit | Slow | Deprecated | Legacy only |
| RC4 | Symmetric | Variable | Fast | BROKEN | — (never use) |

### Security Controls Summary

| Control Type | Examples | Purpose |
|-------------|----------|---------|
| **Preventive** | Firewall, encryption, access control | Stop attacks before they happen |
| **Detective** | IDS, SIEM, log analysis | Identify attacks in progress |
| **Corrective** | Patching, incident response | Fix damage after an attack |
| **Deterrent** | Warning banners, security cameras | Discourage attackers |
| **Compensating** | Additional monitoring when patching is delayed | Alternative when primary control isn't possible |
| **Physical** | Locks, biometric doors, guards | Protect physical assets |
| **Technical** | Firewall rules, ACLs, antivirus | Technology-based controls |
| **Administrative** | Policies, training, procedures | People and process controls |

### Key Security Acronyms

| Acronym | Full Form | Meaning |
|---------|-----------|---------|
| CIA | Confidentiality, Integrity, Availability | Core security goals |
| IAM | Identity and Access Management | Who accesses what |
| MFA | Multi-Factor Authentication | 2+ proof types |
| RBAC | Role-Based Access Control | Permissions by job role |
| PKI | Public Key Infrastructure | Certificate trust system |
| IDS | Intrusion Detection System | Detect attacks |
| IPS | Intrusion Prevention System | Block attacks |
| SIEM | Security Information and Event Management | Log aggregation + alerting |
| SOC | Security Operations Center | Monitoring team |
| DLP | Data Loss Prevention | Stop data leaving |
| WAF | Web Application Firewall | Protect web apps |
| VPN | Virtual Private Network | Encrypted tunnel |
| TLS | Transport Layer Security | Encrypted connections |
| OWASP | Open Web Application Security Project | Web security standards |

---

## 4.10 Hands-on Challenges

### Challenge 1: Hashing Lab (Python)

```python
import hashlib
import os

# 1. Hash the same string with MD5, SHA-1, SHA-256
text = "cybersecurity"
# Observe: different lengths, same input always gives same output

# 2. Demonstrate the avalanche effect
text1 = "password"
text2 = "Password"  # Only 1 character different
# Hash both with SHA-256 — compare how different the outputs are

# 3. Implement salted password hashing
def hash_password(password):
    salt = os.urandom(16)
    hashed = hashlib.pbkdf2_hmac('sha256', password.encode(), salt, 100000)
    return salt.hex() + ':' + hashed.hex()

def verify_password(stored, password):
    salt_hex, hash_hex = stored.split(':')
    salt = bytes.fromhex(salt_hex)
    hashed = hashlib.pbkdf2_hmac('sha256', password.encode(), salt, 100000)
    return hashed.hex() == hash_hex

# Test it:
stored = hash_password("MySecretPass123")
print(f"Stored: {stored}")
print(f"Verify correct: {verify_password(stored, 'MySecretPass123')}")
print(f"Verify wrong: {verify_password(stored, 'WrongPassword')}")
```

### Challenge 2: Certificate Inspection

```bash
# Inspect a real website's TLS certificate
openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | openssl x509 -text -noout

# Check specific fields:
# - Who issued it?
# - What's the validity period?
# - What encryption algorithm is used?
# - What Subject Alternative Names (SANs) are listed?

# In a browser: Click the lock icon → Certificate → Details
```

### Challenge 3: Symmetric Encryption Demo (Python)

```python
from cryptography.fernet import Fernet

# Generate a key
key = Fernet.generate_key()
cipher = Fernet(key)

# Encrypt
message = b"This is a secret message"
encrypted = cipher.encrypt(message)
print(f"Encrypted: {encrypted}")

# Decrypt
decrypted = cipher.decrypt(encrypted)
print(f"Decrypted: {decrypted.decode()}")

# Try decrypting with wrong key — what happens?
wrong_key = Fernet.generate_key()
wrong_cipher = Fernet(wrong_key)
try:
    wrong_cipher.decrypt(encrypted)
except Exception as e:
    print(f"Wrong key error: {e}")
```

### Challenge 4: Access Control Audit

```powershell
# On a Windows machine, audit who has admin access:
Get-LocalGroupMember -Group "Administrators"

# Check for accounts that haven't logged in recently:
Get-LocalUser | Select-Object Name, Enabled, LastLogon | 
    Where-Object {$_.Enabled -eq $true}

# Linux equivalent:
# grep -v "nologin\|false" /etc/passwd | cut -d: -f1
# lastlog | grep -v "Never"
```

---

## Quiz Questions

1. A hospital's patient records database goes offline for 6 hours. Which component of the CIA triad is primarily violated, and what controls could prevent this?
2. Explain why bcrypt is preferred over SHA-256 for password storage, even though SHA-256 is "more secure" by bit length.
3. In a hybrid encryption system (like TLS), why not just use asymmetric encryption for all data? What problem does the symmetric component solve?
4. An organization uses RBAC. An employee transfers from Engineering to Marketing. What security action must occur, and what risk exists if it doesn't?
5. You find a database storing passwords as `MD5(password)` without salt. Describe step-by-step how an attacker would exploit this and what the fix should be.

---

## Summary: The Four Pillars Connected

```
┌─────────────────────────────────────────────────────────────┐
│                   SECURITY PROFESSIONAL                       │
├──────────────┬──────────────┬──────────────┬────────────────┤
│  Networking  │      OS      │  Scripting   │  Security      │
├──────────────┼──────────────┼──────────────┼────────────────┤
│ Understand   │ Navigate &   │ Automate &   │ Think like     │
│ how data     │ secure the   │ build tools  │ an attacker,   │
│ moves        │ environment  │ for defense  │ defend like    │
│              │              │ & offense    │ an architect   │
├──────────────┼──────────────┼──────────────┼────────────────┤
│ OSI/TCP-IP   │ Linux CLI    │ Python       │ CIA Triad      │
│ Protocols    │ Windows PS   │ Bash/PS      │ IAM/RBAC       │
│ Subnetting   │ Permissions  │ SQL          │ Cryptography   │
│ DNS/HTTP     │ Processes    │ Automation   │ PKI            │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

> **Congratulations!** You've covered the four foundational pillars of cybersecurity. Next steps: practice with CTFs (TryHackMe, HackTheBox), pursue certifications (CompTIA Security+, CEH), and build a home lab.
