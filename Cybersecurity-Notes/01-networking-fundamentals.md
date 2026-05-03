# Pillar 1: Networking Fundamentals

## Table of Contents
- [1.1 Core Theory](#11-core-theory)
- [1.2 The OSI Model](#12-the-osi-model)
- [1.3 TCP/IP Suite](#13-tcpip-suite)
- [1.4 IP Addressing & Subnetting](#14-ip-addressing--subnetting)
- [1.5 Common Protocols](#15-common-protocols)
- [1.6 DNS Deep Dive](#16-dns-deep-dive)
- [1.7 HTTP/HTTPS](#17-httphttps)
- [1.8 The Hacker's View](#18-the-hackers-view)
- [1.9 Quick Reference Tables](#19-quick-reference-tables)
- [1.10 Hands-on Challenges](#110-hands-on-challenges)

---

## 1.1 Core Theory

### Why Networking Matters in Security

Every cyberattack involves data in motion. Whether it's an attacker exfiltrating stolen credentials, a malware payload being delivered, or a command-and-control (C2) channel communicating with a compromised host — **the network is the battlefield**.

Understanding networking answers critical questions:
- **Where** in the communication stack is an attack happening?
- **How** is malicious traffic disguised as legitimate?
- **What** defensive controls (firewalls, IDS/IPS, segmentation) can disrupt the attack?

### Real-World Analogy

Think of networking like the postal system:
- **IP Address** = Street address (where to deliver)
- **Port Number** = Apartment number (which service/app receives it)
- **Protocol** = Language on the envelope (rules both sides agree on)
- **Router** = Post office (decides where mail goes next)
- **Firewall** = Security guard (checks if mail is allowed through)
- **Packet** = The letter itself (your actual data, broken into pieces)

---

## 1.2 The OSI Model

The **Open Systems Interconnection (OSI)** model is a conceptual framework that standardizes network communication into **7 layers**. Each layer handles a specific job and passes data to the next.

### The Seven Layers

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 7 - Application    │ What the USER sees              │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 6 - Presentation   │ Data FORMAT (encryption, codec) │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 5 - Session        │ MANAGES connections             │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 4 - Transport      │ RELIABILITY (TCP/UDP)           │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 3 - Network        │ ROUTING (IP addresses)          │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 2 - Data Link      │ LOCAL delivery (MAC addresses)  │
├───────────────────────────┼─────────────────────────────────┤
│  Layer 1 - Physical       │ BITS on the wire                │
└─────────────────────────────────────────────────────────────┘
```

### Layer-by-Layer Breakdown

| Layer | Name | Data Unit | Function | Protocols/Devices | Security Relevance |
|-------|------|-----------|----------|-------------------|--------------------|
| 7 | Application | Data | User-facing services | HTTP, DNS, FTP, SMTP, SSH | Phishing, SQLi, XSS |
| 6 | Presentation | Data | Encryption, compression, translation | SSL/TLS, JPEG, ASCII | Weak encryption, cert spoofing |
| 5 | Session | Data | Session management, authentication | NetBIOS, RPC, PPTP | Session hijacking |
| 4 | Transport | Segment | End-to-end delivery, flow control | TCP, UDP | SYN flood, port scanning |
| 3 | Network | Packet | Logical addressing, routing | IP, ICMP, OSPF, BGP | IP spoofing, route hijacking |
| 2 | Data Link | Frame | Physical addressing, error detection | Ethernet, ARP, switches | ARP spoofing, MAC flooding |
| 1 | Physical | Bits | Physical transmission | Cables, hubs, Wi-Fi signals | Wiretapping, jamming |

### Mnemonic

**Top-down:** "All People Seem To Need Data Processing"  
**Bottom-up:** "Please Do Not Throw Sausage Pizza Away"

### Encapsulation Process

When data travels DOWN the stack, each layer wraps (encapsulates) it:

```
Application Data
    → [Transport Header + Data] = Segment
        → [Network Header + Segment] = Packet
            → [Data Link Header + Packet + Trailer] = Frame
                → 101010010110... = Bits
```

When data travels UP, each layer strips its header (de-encapsulation).

---

## 1.3 TCP/IP Suite

The **TCP/IP model** is the practical implementation of networking (the OSI model is the theory). It has **4 layers**:

| TCP/IP Layer | OSI Equivalent | Protocols |
|--------------|---------------|-----------|
| Application | Layers 5-7 | HTTP, DNS, SSH, FTP, SMTP |
| Transport | Layer 4 | TCP, UDP |
| Internet | Layer 3 | IP, ICMP, ARP |
| Network Access | Layers 1-2 | Ethernet, Wi-Fi, PPP |

### TCP vs UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented (3-way handshake) | Connectionless |
| Reliability | Guaranteed delivery (ACK) | Best effort, no guarantee |
| Order | Data arrives in order | No ordering |
| Speed | Slower (overhead) | Faster (lightweight) |
| Use Cases | HTTP, SSH, FTP, Email | DNS, VoIP, streaming, gaming |
| Header Size | 20 bytes minimum | 8 bytes |
| Security Attack | SYN Flood | UDP Flood, DNS Amplification |

### TCP Three-Way Handshake

```
Client                     Server
  │                           │
  │──── SYN (seq=100) ──────►│   1. "I want to connect"
  │                           │
  │◄── SYN-ACK (seq=300,     │   2. "OK, I acknowledge"
  │     ack=101) ─────────────│
  │                           │
  │──── ACK (ack=301) ──────►│   3. "Connection established"
  │                           │
  │◄═══ DATA TRANSFER ══════►│
```

### TCP Four-Way Termination

```
Client                     Server
  │──── FIN ────────────────►│   1. "I'm done sending"
  │◄─── ACK ─────────────────│   2. "Got it"
  │◄─── FIN ─────────────────│   3. "I'm done too"
  │──── ACK ────────────────►│   4. "Acknowledged, connection closed"
```

---

## 1.4 IP Addressing & Subnetting

### IPv4 Addressing

An IPv4 address is a **32-bit** number written as four octets in dotted decimal:

```
192.168.1.100
 │    │   │  │
 8bit 8bit 8bit 8bit = 32 bits total
```

### Address Classes

| Class | Range | Default Mask | Networks | Hosts/Network | Use |
|-------|-------|-------------|----------|---------------|-----|
| A | 1.0.0.0 – 126.255.255.255 | /8 (255.0.0.0) | 126 | ~16.7M | Large orgs |
| B | 128.0.0.0 – 191.255.255.255 | /16 (255.255.0.0) | 16,384 | ~65K | Medium orgs |
| C | 192.0.0.0 – 223.255.255.255 | /24 (255.255.255.0) | ~2M | 254 | Small orgs |
| D | 224.0.0.0 – 239.255.255.255 | — | — | — | Multicast |
| E | 240.0.0.0 – 255.255.255.255 | — | — | — | Experimental |

### Private IP Ranges (RFC 1918)

| Class | Range | CIDR |
|-------|-------|------|
| A | 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 |
| B | 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 |
| C | 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 |

### Subnetting

**Purpose:** Divide a large network into smaller, manageable sub-networks.

**Formula:**
- Hosts per subnet = $2^{(32 - \text{prefix})} - 2$
- Subnets = $2^{\text{borrowed bits}}$

**Example:** Subnet 192.168.1.0/26

```
/26 means 26 network bits, 6 host bits
Hosts per subnet = 2^6 - 2 = 62
Subnet mask: 255.255.255.192

Subnets:
  192.168.1.0/26    → Hosts: .1 to .62    (Broadcast: .63)
  192.168.1.64/26   → Hosts: .65 to .126  (Broadcast: .127)
  192.168.1.128/26  → Hosts: .129 to .190 (Broadcast: .191)
  192.168.1.192/26  → Hosts: .193 to .254 (Broadcast: .255)
```

### IPv6

- **128-bit** address (vs 32-bit IPv4)
- Written in hexadecimal: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`
- Shortened: `2001:db8:85a3::8a2e:370:7334`
- No NAT needed (every device gets a unique public address)
- Built-in IPsec support

---

## 1.5 Common Protocols

### Application Layer Protocols

| Protocol | Port | Transport | Purpose | Security Concern |
|----------|------|-----------|---------|-----------------|
| HTTP | 80 | TCP | Web traffic (unencrypted) | Data visible in plaintext |
| HTTPS | 443 | TCP | Encrypted web traffic | Weak certs, SSL stripping |
| DNS | 53 | UDP/TCP | Name → IP resolution | DNS spoofing, tunneling |
| FTP | 20/21 | TCP | File transfer | Credentials in plaintext |
| SFTP | 22 | TCP | Secure file transfer | Brute force |
| SSH | 22 | TCP | Encrypted remote access | Key management |
| Telnet | 23 | TCP | Remote access (unencrypted) | Everything in plaintext |
| SMTP | 25 | TCP | Send email | Open relay, spoofing |
| POP3 | 110 | TCP | Retrieve email | Plaintext credentials |
| IMAP | 143 | TCP | Retrieve email (sync) | Plaintext credentials |
| DHCP | 67/68 | UDP | Automatic IP assignment | Rogue DHCP server |
| SNMP | 161 | UDP | Network management | Default community strings |
| RDP | 3389 | TCP | Remote desktop (Windows) | Brute force, BlueKeep |
| LDAP | 389 | TCP | Directory services | Injection, cleartext |

---

## 1.6 DNS Deep Dive

### How DNS Resolution Works

```
User types: www.example.com

1. Browser Cache → Found? Done.
2. OS Cache (hosts file) → Found? Done.
3. Recursive Resolver (ISP) → Found in cache? Done.
4. Root Server → "Try .com TLD server"
5. TLD Server (.com) → "Try example.com's nameserver"
6. Authoritative NS → "www.example.com = 93.184.216.34"
7. Response cached at each level
```

### DNS Record Types

| Record | Purpose | Example |
|--------|---------|---------|
| A | Domain → IPv4 | `example.com → 93.184.216.34` |
| AAAA | Domain → IPv6 | `example.com → 2606:2800:...` |
| CNAME | Alias → another domain | `www.example.com → example.com` |
| MX | Mail server | `example.com → mail.example.com` |
| NS | Nameserver for domain | `example.com → ns1.example.com` |
| TXT | Arbitrary text (SPF, DKIM) | `v=spf1 include:...` |
| PTR | IP → Domain (reverse) | `34.216.184.93 → example.com` |
| SOA | Zone authority info | Serial, refresh, retry times |

---

## 1.7 HTTP/HTTPS

### HTTP Request Structure

```
GET /login HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
Cookie: session=abc123
```

### HTTP Response Structure

```
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: session=xyz789
Content-Length: 1234

<html>...</html>
```

### HTTP Methods

| Method | Purpose | Safe? | Idempotent? |
|--------|---------|-------|-------------|
| GET | Retrieve data | Yes | Yes |
| POST | Submit data (create) | No | No |
| PUT | Replace resource | No | Yes |
| PATCH | Partial update | No | No |
| DELETE | Remove resource | No | Yes |
| HEAD | GET without body | Yes | Yes |
| OPTIONS | Check allowed methods | Yes | Yes |

### Status Codes

| Code | Category | Examples |
|------|----------|----------|
| 1xx | Informational | 100 Continue |
| 2xx | Success | 200 OK, 201 Created |
| 3xx | Redirect | 301 Moved, 302 Found, 304 Not Modified |
| 4xx | Client Error | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found |
| 5xx | Server Error | 500 Internal, 502 Bad Gateway, 503 Service Unavailable |

### TLS/HTTPS Handshake (Simplified)

```
Client                              Server
  │── ClientHello (supported ciphers) ──►│
  │◄── ServerHello (chosen cipher) ──────│
  │◄── Certificate (public key) ─────────│
  │── Key Exchange (pre-master secret) ──►│
  │── ChangeCipherSpec ─────────────────►│
  │◄── ChangeCipherSpec ──────────────────│
  │◄═══ Encrypted Communication ════════►│
```

---

## 1.8 The Hacker's View

### Attack Vectors by Layer

| Layer | Attack | Description |
|-------|--------|-------------|
| 7 - Application | SQL Injection, XSS | Exploit vulnerable web apps |
| 6 - Presentation | SSL Stripping | Downgrade HTTPS to HTTP |
| 5 - Session | Session Hijacking | Steal session cookies/tokens |
| 4 - Transport | SYN Flood (DoS) | Exhaust connection table with half-open connections |
| 3 - Network | IP Spoofing, ICMP Flood | Forge source IP, overwhelming ping |
| 2 - Data Link | ARP Spoofing | Associate attacker's MAC with gateway IP |
| 1 - Physical | Wiretapping | Physical interception of cable/wireless |

### DNS-Based Attacks

**DNS Spoofing / Cache Poisoning:**
1. Attacker sends forged DNS responses to a resolver.
2. Resolver caches the fake record: `bank.com → attacker's IP`.
3. Victim visits `bank.com` and lands on a phishing page.
4. Victim enters credentials → attacker captures them.

**DNS Tunneling:**
- Encodes data inside DNS queries to exfiltrate data through firewalls that allow DNS.
- Example: `encoded-stolen-data.attacker.com` → data hidden in the subdomain.

### Man-in-the-Middle (MITM) via ARP Spoofing

```
Normal:    Victim ←→ Gateway ←→ Internet
Attack:    Victim ←→ [Attacker] ←→ Gateway ←→ Internet

1. Attacker sends fake ARP replies:
   - To Victim: "Gateway's IP is at MY MAC address"
   - To Gateway: "Victim's IP is at MY MAC address"
2. All traffic passes through attacker
3. Attacker can read, modify, or inject packets
```

### SYN Flood Attack

```
Attacker sends thousands of SYN packets with spoofed IPs:
  → SYN (fake IP 1)
  → SYN (fake IP 2)
  → SYN (fake IP 3)
  ... (thousands more)

Server responds SYN-ACK to each, waits for ACK that never comes.
Server's connection table fills up → legitimate users can't connect.
```

---

## 1.9 Quick Reference Tables

### Critical Ports to Memorize

| Port | Service | Encrypted? |
|------|---------|-----------|
| 20/21 | FTP | No |
| 22 | SSH/SFTP | Yes |
| 23 | Telnet | No |
| 25 | SMTP | No |
| 53 | DNS | No |
| 67/68 | DHCP | No |
| 80 | HTTP | No |
| 110 | POP3 | No |
| 143 | IMAP | No |
| 443 | HTTPS | Yes |
| 445 | SMB | No |
| 3306 | MySQL | No |
| 3389 | RDP | Partial |
| 5432 | PostgreSQL | No |
| 8080 | HTTP Alt | No |

### Key Networking Commands

| Command | OS | Purpose |
|---------|----|---------|
| `ipconfig /all` | Windows | Show IP configuration |
| `ip a` / `ifconfig` | Linux | Show IP configuration |
| `ping <host>` | Both | Test connectivity (ICMP) |
| `tracert` / `traceroute` | Both | Trace route to destination |
| `nslookup <domain>` | Both | Query DNS records |
| `netstat -an` | Both | Show active connections |
| `arp -a` | Both | Show ARP cache |
| `nmap <target>` | Both | Network/port scanner |
| `tcpdump` | Linux | Capture packets |
| `wireshark` | Both | GUI packet analysis |

---

## 1.10 Hands-on Challenges

### Challenge 1: Capture & Analyze Traffic with Wireshark

**Objective:** See the TCP 3-way handshake and HTTP traffic in action.

1. Install Wireshark (wireshark.org).
2. Start capturing on your active network interface.
3. Open a browser and visit `http://neverssl.com` (HTTP, not HTTPS).
4. Stop the capture.
5. Apply filter: `tcp.flags.syn == 1`
6. Find the SYN → SYN-ACK → ACK sequence.
7. Apply filter: `http` — read the plaintext request and response.
8. **Security Question:** Can you see the full URL and page content? This is why HTTPS matters.

### Challenge 2: DNS Enumeration

```bash
# Query different DNS record types
nslookup -type=A example.com
nslookup -type=MX example.com
nslookup -type=NS example.com
nslookup -type=TXT example.com

# Trace the full DNS resolution path
nslookup -debug example.com
```

### Challenge 3: Port Scanning with Nmap (on your OWN network only)

```bash
# Discover live hosts on your subnet
nmap -sn 192.168.1.0/24

# Scan top 1000 ports on a target
nmap -sT 192.168.1.1

# Detect services and versions
nmap -sV 192.168.1.1

# Full TCP SYN scan (stealth)
sudo nmap -sS 192.168.1.1
```

> **Legal Warning:** Only scan networks you own or have explicit written permission to test.

---

## Quiz Questions

1. At which OSI layer does a router operate, and what addressing does it use?
2. Explain why a SYN Flood attack targets Layer 4 and how SYN cookies mitigate it.
3. If a subnet mask is /27, how many usable host addresses are available per subnet?
4. What is the difference between DNS spoofing and DNS tunneling from an attacker's perspective?
5. A packet capture shows traffic on port 443 but the content is unreadable. What layer is protecting the data, and what protocol is in use?

---

> **Next Pillar:** [02 - Operating Systems (Linux & Windows)](02-operating-systems.md)
