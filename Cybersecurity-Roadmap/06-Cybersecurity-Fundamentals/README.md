# 🔒 Cybersecurity Fundamentals

## Core Security Concepts Every Professional Must Master

---

## 📌 Table of Contents

1. [The CIA Triad](#the-cia-triad)
2. [Authentication, Authorization, Accounting](#authentication-authorization-accounting)
3. [Security Principles](#security-principles)
4. [Encryption and Hashing](#encryption-and-hashing)
5. [SSL/TLS](#ssltls)
6. [Threat Landscape](#threat-landscape)
7. [MITRE ATT&CK Framework](#mitre-attck-framework)
8. [Security Models](#security-models)
9. [Risk Management](#risk-management)
10. [Vulnerability Management](#vulnerability-management)

---

## The CIA Triad

The foundation of ALL security decisions:

```
            ┌─────────────────┐
            │ CONFIDENTIALITY │
            │                 │
            │  "Only authorized│
            │  people can see  │
            │  the data"       │
            └────────┬────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
┌──────────────┐          ┌──────────────┐
│  INTEGRITY   │          │ AVAILABILITY │
│              │          │              │
│ "Data hasn't │          │ "Data is     │
│  been altered│          │  accessible  │
│  unauthorized│          │  when needed"│
└──────────────┘          └──────────────┘
```

| Principle | Meaning | Attack Example | Defense |
|-----------|---------|---------------|---------|
| **Confidentiality** | Prevent unauthorized access | Data breach, eavesdropping | Encryption, access control |
| **Integrity** | Prevent unauthorized modification | Data tampering, MITM | Hashing, digital signatures |
| **Availability** | Ensure systems are accessible | DDoS, ransomware | Redundancy, backups |

---

## Authentication, Authorization, Accounting (AAA)

### Authentication — "Who are you?"

| Factor | Type | Example |
|--------|------|---------|
| Something you **know** | Knowledge | Password, PIN |
| Something you **have** | Possession | Phone, hardware token |
| Something you **are** | Biometric | Fingerprint, face scan |

**Multi-Factor Authentication (MFA):** Combining 2+ factors.

### Authorization — "What can you do?"

| Model | Description |
|-------|-------------|
| DAC (Discretionary) | Owner decides who gets access |
| MAC (Mandatory) | System enforces access (clearance levels) |
| RBAC (Role-Based) | Access based on job role |
| ABAC (Attribute-Based) | Access based on attributes (time, location) |

### Accounting — "What did you do?"

Logging all actions for audit and forensics.

---

## Security Principles

| Principle | Meaning | Example |
|-----------|---------|---------|
| Least Privilege | Minimum access needed | User doesn't need admin rights |
| Defense in Depth | Multiple layers | Firewall + IDS + encryption |
| Separation of Duties | No one person has all power | Two people needed to deploy |
| Need to Know | Only access what's necessary | Developer can't see production DB |
| Zero Trust | Never trust, always verify | Verify every request, every time |
| Fail Secure | Deny access on failure | Locked door stays locked on power failure |
| Keep It Simple | Complexity breeds vulnerability | Simple firewall rules > complex ones |

---

## Encryption and Hashing

### Symmetric Encryption

Same key encrypts AND decrypts:

```
Plaintext → [ENCRYPT with Key] → Ciphertext → [DECRYPT with same Key] → Plaintext

Algorithms: AES-256, ChaCha20, (deprecated: DES, 3DES)
Use: Encrypting stored data, disk encryption, VPN tunnels
```

### Asymmetric Encryption

Two keys: Public (encrypt) and Private (decrypt):

```
Sender has: Recipient's PUBLIC key
Recipient has: Their own PRIVATE key

Plaintext → [ENCRYPT with Public Key] → Ciphertext → [DECRYPT with Private Key] → Plaintext

Algorithms: RSA, ECC, Diffie-Hellman
Use: Key exchange, digital signatures, HTTPS
```

### Hashing (One-Way)

```
Input → [HASH Function] → Fixed-length output (digest)

"password" → MD5  → 5f4dcc3b5aa765d61d8327deb882cf99
"password" → SHA1 → 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
"passwore" → MD5  → completely different hash (avalanche effect)

Properties:
- One-way (cannot reverse)
- Deterministic (same input = same output)
- Avalanche effect (tiny change = completely different hash)
- Fixed size output

Use: Password storage, file integrity, digital signatures
```

| Algorithm | Output Size | Status |
|-----------|-------------|--------|
| MD5 | 128 bit | BROKEN — never use for security |
| SHA-1 | 160 bit | DEPRECATED — collisions found |
| SHA-256 | 256 bit | CURRENT STANDARD |
| SHA-512 | 512 bit | Very secure |
| bcrypt | Variable | BEST for passwords |
| Argon2 | Variable | NEWEST for passwords |

---

## SSL/TLS

Secures communication between client and server (HTTPS):

```
Without TLS:  Client ──── [plaintext data] ──── Server
              Anyone on the network can read the data!

With TLS:     Client ──── [encrypted data] ──── Server
              Only client and server can read the data
```

### TLS Versions

| Version | Status | Notes |
|---------|--------|-------|
| SSL 2.0 | INSECURE | Never use |
| SSL 3.0 | INSECURE | POODLE attack |
| TLS 1.0 | DEPRECATED | Weak |
| TLS 1.1 | DEPRECATED | Weak |
| TLS 1.2 | CURRENT | Widely used |
| TLS 1.3 | LATEST | Most secure, fastest |

---

## Threat Landscape

### Threat Actors

| Actor | Motivation | Capability | Example |
|-------|-----------|-----------|---------|
| Script Kiddies | Fun, fame | Low (use existing tools) | Defacing websites |
| Hacktivists | Political/social | Medium | Anonymous, LulzSec |
| Cybercriminals | Financial gain | High | Ransomware gangs |
| Nation-States (APT) | Espionage, warfare | Very High | APT28, Lazarus Group |
| Insiders | Revenge, money | Variable (has access) | Disgruntled employees |

### Malware Types

| Type | Behavior | Example |
|------|----------|---------|
| Virus | Attaches to files, self-replicates | ILOVEYOU |
| Worm | Self-propagates through networks | WannaCry, NotPetya |
| Trojan | Disguised as legitimate software | Remote Access Trojans |
| Ransomware | Encrypts files, demands payment | LockBit, REvil |
| Spyware | Monitors activity | Pegasus |
| Rootkit | Hides deep in OS | TDL4 |
| Botnet | Network of infected machines | Mirai |
| Keylogger | Records keystrokes | — |

### Cyber Kill Chain

```
1. Reconnaissance    → Research target (OSINT, scanning)
2. Weaponization     → Create exploit/payload
3. Delivery          → Send to target (email, web, USB)
4. Exploitation      → Trigger vulnerability
5. Installation      → Install malware/backdoor
6. Command & Control → Establish communication channel
7. Actions on Obj.   → Achieve goal (exfiltrate, destroy)
```

---

## MITRE ATT&CK Framework

A knowledge base of adversary tactics and techniques:

| Tactic | Description | Example Techniques |
|--------|-------------|-------------------|
| Reconnaissance | Gathering information | Active scanning, phishing for info |
| Resource Development | Setting up infrastructure | Acquire domains, develop malware |
| Initial Access | Getting in | Phishing, exploiting public apps |
| Execution | Running code | PowerShell, command line |
| Persistence | Maintaining access | Registry keys, scheduled tasks |
| Privilege Escalation | Getting higher access | Exploit SUID, token manipulation |
| Defense Evasion | Avoiding detection | Obfuscation, disabling security |
| Credential Access | Stealing creds | Keylogging, dumping hashes |
| Discovery | Mapping the environment | Network scanning, AD enumeration |
| Lateral Movement | Moving through network | Pass-the-Hash, RDP |
| Collection | Gathering target data | Screen capture, email collection |
| Exfiltration | Stealing data out | DNS tunneling, encrypted channels |
| Impact | Disruption/destruction | Ransomware, data destruction |

---

## Risk Management

### Risk Formula

```
Risk = Threat × Vulnerability × Impact

Example:
- Threat: Ransomware gangs targeting healthcare (HIGH)
- Vulnerability: Unpatched Windows servers (HIGH)  
- Impact: Patient data lost, operations halted (CRITICAL)
- Risk: CRITICAL — immediate action needed
```

### Risk Treatment Options

| Option | Description | Example |
|--------|-------------|---------|
| **Avoid** | Eliminate the risk source | Don't use the vulnerable software |
| **Mitigate** | Reduce likelihood or impact | Patch, add firewall, train users |
| **Transfer** | Shift risk to third party | Buy cyber insurance |
| **Accept** | Acknowledge and monitor | Low-risk, low-impact items |

---

## Vulnerability Management

### Vulnerability Lifecycle

```
Discover → Assess → Prioritize → Remediate → Verify → Monitor
```

### CVSS Scoring

| Score | Severity | Action |
|-------|----------|--------|
| 0.0 | None | No action |
| 0.1 - 3.9 | Low | Schedule fix |
| 4.0 - 6.9 | Medium | Fix in next cycle |
| 7.0 - 8.9 | High | Fix immediately |
| 9.0 - 10.0 | Critical | Emergency patch |

---

## Exercises

1. For each CIA principle, give 3 real-world attack examples
2. Identify the authentication factors in your daily life
3. Calculate the MD5 and SHA-256 hash of your name
4. Research 3 recent CVEs and determine their CVSS scores
5. Map a recent breach to the Cyber Kill Chain stages

---

## Interview Questions

1. **Q: Explain the CIA triad with examples.**
2. **Q: What is the difference between encryption and hashing?**
3. **Q: Describe Defense in Depth. Give an example with 5 layers.**
4. **Q: What is Zero Trust and why is it important?**
5. **Q: Explain the difference between a vulnerability, threat, and risk.**

---

**Next:** → [07-Web-Security](../07-Web-Security/README.md)

*"Security is not a product. It's a process."* — Bruce Schneier
