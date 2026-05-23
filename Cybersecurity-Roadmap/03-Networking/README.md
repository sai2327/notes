# 🌐 Networking Fundamentals

## Understanding Networks — The Language of the Internet

---

## 📌 Table of Contents

1. [Introduction](#introduction)
2. [Why Networking for Cybersecurity](#why-networking-for-cybersecurity)
3. [OSI Model — Deep Dive](#osi-model--deep-dive)
4. [TCP/IP Model](#tcpip-model)
5. [IP Addressing and Subnetting](#ip-addressing-and-subnetting)
6. [Core Protocols](#core-protocols)
7. [TCP — Transmission Control Protocol](#tcp--transmission-control-protocol)
8. [UDP — User Datagram Protocol](#udp--user-datagram-protocol)
9. [DNS — Domain Name System](#dns--domain-name-system)
10. [HTTP/HTTPS](#httphttps)
11. [ARP — Address Resolution Protocol](#arp--address-resolution-protocol)
12. [DHCP](#dhcp)
13. [Network Devices](#network-devices)
14. [Firewalls and NAT](#firewalls-and-nat)
15. [VPNs and Tunneling](#vpns-and-tunneling)
16. [Wireless Networks](#wireless-networks)
17. [Packet Analysis with Wireshark](#packet-analysis-with-wireshark)
18. [Network Attacks](#network-attacks)
19. [Exercises](#exercises)
20. [Labs](#labs)
21. [Interview Questions](#interview-questions)
22. [Summary](#summary)

---

## Introduction

Every cyberattack travels through a network. Every piece of data you protect flows through network protocols. Understanding networking isn't optional in cybersecurity — it's the foundation everything else is built upon.

This section teaches you how data travels from one computer to another, what happens at each step, and how attackers exploit each layer.

---

## Why Networking for Cybersecurity

| Security Role | Networking Knowledge Needed |
|--------------|---------------------------|
| Penetration Tester | Port scanning, protocol exploitation, pivoting |
| SOC Analyst | Packet analysis, anomaly detection, log correlation |
| Malware Analyst | C2 communication, DNS tunneling, traffic analysis |
| Cloud Security | VPC, security groups, network segmentation |
| Forensics | Packet captures, network artifacts, timeline reconstruction |
| Bug Bounty | HTTP deep understanding, request manipulation |

---

## OSI Model — Deep Dive

The OSI (Open Systems Interconnection) model describes how data travels through a network in 7 layers.

### The 7 Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│ Layer 7: APPLICATION    │ What the user interacts with              │
│ (HTTP, DNS, FTP, SMTP)  │ Protocols that serve end-user services    │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 6: PRESENTATION   │ Data formatting and encryption            │
│ (SSL/TLS, JPEG, ASCII)  │ Translates data between formats          │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 5: SESSION        │ Manages connections                       │
│ (NetBIOS, RPC)          │ Establishes, maintains, terminates        │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 4: TRANSPORT      │ Reliable delivery (TCP) or fast (UDP)     │
│ (TCP, UDP)              │ Port numbers, segmentation                │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 3: NETWORK        │ Routing between networks                  │
│ (IP, ICMP, IPSec)       │ IP addresses, routers                    │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 2: DATA LINK      │ Node-to-node delivery                     │
│ (Ethernet, WiFi, ARP)   │ MAC addresses, switches                  │
├─────────────────────────────────────────────────────────────────────┤
│ Layer 1: PHYSICAL       │ Bits on the wire                          │
│ (Cables, Signals, Hubs) │ Electrical/optical signals                │
└─────────────────────────────────────────────────────────────────────┘
```

### Mnemonic to Remember

**Top-down:** All People Seem To Need Data Processing
**Bottom-up:** Please Do Not Throw Sausage Pizza Away

### Data Encapsulation

As data moves down the layers, each layer adds its own header:

```
Application Layer:  [DATA]
Transport Layer:    [TCP Header][DATA]                    → Segment
Network Layer:      [IP Header][TCP Header][DATA]        → Packet
Data Link Layer:    [ETH Header][IP][TCP][DATA][ETH Trailer] → Frame
Physical Layer:     101010010101010110101...              → Bits
```

### Attacks at Each Layer

| Layer | Protocol | Attack Example |
|-------|----------|---------------|
| 7 - Application | HTTP, DNS | SQL Injection, XSS, DNS poisoning |
| 6 - Presentation | SSL/TLS | SSL stripping, POODLE, Heartbleed |
| 5 - Session | RPC, NetBIOS | Session hijacking, replay attacks |
| 4 - Transport | TCP, UDP | SYN flood, port scanning |
| 3 - Network | IP, ICMP | IP spoofing, ICMP redirect, ping of death |
| 2 - Data Link | Ethernet, ARP | ARP spoofing, MAC flooding, VLAN hopping |
| 1 - Physical | Cables | Wiretapping, jamming |

---

## TCP/IP Model

The practical model used on the internet (4 layers vs OSI's 7):

```
┌──────────────────────────────────────────┐
│ Application Layer                         │
│ (HTTP, DNS, FTP, SMTP, SSH)              │ ← OSI Layers 5-7
├──────────────────────────────────────────┤
│ Transport Layer                           │
│ (TCP, UDP)                               │ ← OSI Layer 4
├──────────────────────────────────────────┤
│ Internet Layer                            │
│ (IP, ICMP, ARP)                          │ ← OSI Layer 3
├──────────────────────────────────────────┤
│ Network Access Layer                      │
│ (Ethernet, WiFi)                         │ ← OSI Layers 1-2
└──────────────────────────────────────────┘
```

---

## IP Addressing and Subnetting

### IPv4 Addresses

An IPv4 address is a 32-bit number written as four octets:

```
192.168.1.100
│   │   │ │
│   │   │ └── Fourth octet (0-255)
│   │   └── Third octet (0-255)
│   └── Second octet (0-255)
└── First octet (0-255)

Binary representation:
192     .168     .1       .100
11000000.10101000.00000001.01100100
```

### IP Address Classes

| Class | Range | Default Mask | Networks | Hosts/Network |
|-------|-------|-------------|----------|---------------|
| A | 1.0.0.0 - 126.255.255.255 | 255.0.0.0 (/8) | 126 | 16,777,214 |
| B | 128.0.0.0 - 191.255.255.255 | 255.255.0.0 (/16) | 16,384 | 65,534 |
| C | 192.0.0.0 - 223.255.255.255 | 255.255.255.0 (/24) | 2,097,152 | 254 |
| D | 224.0.0.0 - 239.255.255.255 | — | Multicast | — |
| E | 240.0.0.0 - 255.255.255.255 | — | Experimental | — |

### Private IP Ranges (RFC 1918)

| Class | Range | CIDR | Common Use |
|-------|-------|------|-----------|
| A | 10.0.0.0 - 10.255.255.255 | 10.0.0.0/8 | Large enterprises |
| B | 172.16.0.0 - 172.31.255.255 | 172.16.0.0/12 | Medium networks |
| C | 192.168.0.0 - 192.168.255.255 | 192.168.0.0/16 | Home networks |

### Subnetting

Subnetting divides a network into smaller segments.

**Example: Subnetting 192.168.1.0/24 into 4 subnets:**

```
Original: 192.168.1.0/24 = 254 hosts

Borrow 2 bits: /24 → /26 (4 subnets, 62 hosts each)

Subnet 1: 192.168.1.0/26    (Hosts: .1 - .62,   Broadcast: .63)
Subnet 2: 192.168.1.64/26   (Hosts: .65 - .126, Broadcast: .127)
Subnet 3: 192.168.1.128/26  (Hosts: .129 - .190, Broadcast: .191)
Subnet 4: 192.168.1.192/26  (Hosts: .193 - .254, Broadcast: .255)
```

**CIDR Notation Quick Reference:**

| CIDR | Subnet Mask | Hosts | Networks (/24 divided) |
|------|-------------|-------|----------------------|
| /24 | 255.255.255.0 | 254 | 1 |
| /25 | 255.255.255.128 | 126 | 2 |
| /26 | 255.255.255.192 | 62 | 4 |
| /27 | 255.255.255.224 | 30 | 8 |
| /28 | 255.255.255.240 | 14 | 16 |
| /29 | 255.255.255.248 | 6 | 32 |
| /30 | 255.255.255.252 | 2 | 64 |
| /32 | 255.255.255.255 | 1 | Single host |

---

## Core Protocols

### Common Ports and Protocols

| Port | Protocol | Service | Security Notes |
|------|----------|---------|---------------|
| 20/21 | TCP | FTP | Cleartext credentials, anonymous access |
| 22 | TCP | SSH | Brute force target, key-based preferred |
| 23 | TCP | Telnet | Cleartext everything! Never use. |
| 25 | TCP | SMTP | Email relay abuse, phishing |
| 53 | TCP/UDP | DNS | DNS tunneling, cache poisoning |
| 67/68 | UDP | DHCP | Rogue DHCP, starvation |
| 80 | TCP | HTTP | Web vulnerabilities, cleartext |
| 110 | TCP | POP3 | Cleartext email retrieval |
| 111 | TCP/UDP | RPC | NFS exploitation |
| 135 | TCP | MS-RPC | Windows exploitation |
| 137-139 | TCP/UDP | NetBIOS | Windows enumeration |
| 143 | TCP | IMAP | Cleartext email |
| 161/162 | UDP | SNMP | Community string default |
| 389 | TCP | LDAP | AD enumeration |
| 443 | TCP | HTTPS | Encrypted web |
| 445 | TCP | SMB | EternalBlue, ransomware |
| 993 | TCP | IMAPS | Encrypted IMAP |
| 995 | TCP | POP3S | Encrypted POP3 |
| 1433 | TCP | MSSQL | Database attacks |
| 1521 | TCP | Oracle | Database attacks |
| 3306 | TCP | MySQL | Database attacks |
| 3389 | TCP | RDP | Brute force, BlueKeep |
| 5432 | TCP | PostgreSQL | Database attacks |
| 5900 | TCP | VNC | Weak authentication |
| 8080 | TCP | HTTP Proxy | Alternative web |
| 8443 | TCP | HTTPS Alt | Alternative secure web |

---

## TCP — Transmission Control Protocol

### The TCP Three-Way Handshake

```
Client                                Server
  │                                     │
  │──── SYN (seq=100) ────────────────→│  Step 1: Client initiates
  │                                     │
  │←─── SYN-ACK (seq=300,ack=101) ────│  Step 2: Server acknowledges
  │                                     │
  │──── ACK (seq=101,ack=301) ────────→│  Step 3: Client confirms
  │                                     │
  │         CONNECTION ESTABLISHED       │
  │                                     │
  │←────── Data Transfer ──────────────→│
  │                                     │
  │──── FIN ───────────────────────────→│  Connection teardown
  │←─── ACK ───────────────────────────│
  │←─── FIN ───────────────────────────│
  │──── ACK ───────────────────────────→│
  │                                     │
```

### TCP Flags

| Flag | Name | Purpose | Attack Use |
|------|------|---------|-----------|
| SYN | Synchronize | Initiate connection | SYN flood DoS |
| ACK | Acknowledge | Confirm receipt | ACK flood |
| FIN | Finish | Close connection | FIN scan (stealth) |
| RST | Reset | Abort connection | RST injection |
| PSH | Push | Send immediately | — |
| URG | Urgent | Priority data | — |

### TCP Header

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                        Sequence Number                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Acknowledgment Number                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Data |       |U|A|P|R|S|F|                                  |
| Offset|  Res  |R|C|S|S|Y|I|            Window                |
|       |       |G|K|H|T|N|N|                                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           Checksum            |         Urgent Pointer        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### SYN Flood Attack

```
Attacker sends thousands of SYN packets with spoofed source IPs:

Attacker → SYN (src: fake1) → Server
Attacker → SYN (src: fake2) → Server
Attacker → SYN (src: fake3) → Server
... (thousands more)

Server tries to respond to all fake IPs:
Server → SYN-ACK → fake1 (no response)
Server → SYN-ACK → fake2 (no response)
Server → SYN-ACK → fake3 (no response)

Server's connection table fills up → Legitimate users can't connect!

Defense: SYN cookies, rate limiting, firewalls
```

---

## UDP — User Datagram Protocol

### TCP vs UDP Comparison

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | Best effort |
| Ordering | Ordered delivery | No ordering |
| Speed | Slower (overhead) | Faster |
| Header size | 20 bytes minimum | 8 bytes |
| Use cases | Web, email, file transfer | DNS, video, gaming |
| Handshake | Three-way handshake | None |
| Flow control | Yes (windowing) | No |

### Security Implications

- **UDP Amplification Attacks:** Small UDP request → large response. Spoof source IP → flood victim with responses.
- **DNS Amplification:** 60-byte query → 4000-byte response (60x amplification)
- **NTP Amplification:** monlist command → massive response

---

## DNS — Domain Name System

### How DNS Works

```
You type: www.example.com

1. Browser checks local cache
2. OS checks /etc/hosts (or hosts file on Windows)
3. Query goes to configured DNS resolver (e.g., 8.8.8.8)
4. Resolver checks its cache
5. If not cached, resolver queries root servers → TLD servers → authoritative server

┌──────────┐    Query     ┌──────────────┐
│  Client  │─────────────→│ DNS Resolver │
│          │←─────────────│ (8.8.8.8)    │
└──────────┘    Answer    └──────┬───────┘
                                 │
                    ┌────────────┼────────────┐
                    ▼            ▼            ▼
              ┌──────────┐ ┌──────────┐ ┌──────────────┐
              │   Root   │ │  .com    │ │ example.com  │
              │  Server  │ │  TLD     │ │ Authoritative│
              └──────────┘ └──────────┘ └──────────────┘
```

### DNS Record Types

| Record | Purpose | Example |
|--------|---------|---------|
| A | IPv4 address | example.com → 93.184.216.34 |
| AAAA | IPv6 address | example.com → 2606:2800:220:1:248:... |
| CNAME | Alias | www.example.com → example.com |
| MX | Mail server | example.com → mail.example.com |
| NS | Name server | example.com → ns1.example.com |
| TXT | Text record | SPF, DKIM, domain verification |
| PTR | Reverse DNS | IP → hostname |
| SOA | Start of Authority | Zone info (serial, refresh) |
| SRV | Service location | _ldap._tcp.domain.com |

### DNS Security Attacks

| Attack | Description | Defense |
|--------|-------------|---------|
| DNS Cache Poisoning | Inject false records into resolver cache | DNSSEC |
| DNS Tunneling | Encode data in DNS queries to bypass firewalls | DNS monitoring |
| DNS Hijacking | Redirect DNS to attacker's server | DNSSEC, DoH |
| DNS Amplification | DDoS using DNS reflection | Rate limiting |
| Zone Transfer | Dump all DNS records (misconfiguration) | Restrict zone transfers |
| Subdomain Takeover | Claim abandoned subdomains | Monitor DNS records |

### DNS Commands

```bash
# Basic lookup
nslookup example.com
dig example.com

# Specific record types
dig example.com MX
dig example.com NS
dig example.com TXT
dig example.com ANY

# Reverse lookup
dig -x 93.184.216.34

# Specify DNS server
dig @8.8.8.8 example.com

# Short output
dig +short example.com

# Trace the full resolution path
dig +trace example.com

# Zone transfer attempt (security test)
dig axfr @ns1.target.com target.com

# Check for DNS tunneling indicators
# Look for unusually long subdomain names
# Look for high volume of TXT queries
```

---

## HTTP/HTTPS

### HTTP Request Structure

```
GET /index.html HTTP/1.1          ← Request line (Method, Path, Version)
Host: www.example.com             ← Required header
User-Agent: Mozilla/5.0           ← Browser identification
Accept: text/html                 ← Acceptable content types
Accept-Language: en-US            ← Language preference
Accept-Encoding: gzip, deflate   ← Compression support
Connection: keep-alive            ← Connection management
Cookie: session=abc123            ← Session cookies
                                  ← Empty line separates headers from body
[Request body if POST/PUT]
```

### HTTP Response Structure

```
HTTP/1.1 200 OK                   ← Status line (Version, Code, Reason)
Date: Mon, 15 Jan 2024 10:30:00 GMT
Server: Apache/2.4.41            ← Server identification (info leak!)
Content-Type: text/html          ← Content format
Content-Length: 1234             ← Body size
Set-Cookie: session=xyz789       ← Setting cookies
X-Frame-Options: DENY            ← Security header
                                 ← Empty line
<html>...</html>                 ← Response body
```

### HTTP Methods

| Method | Purpose | Idempotent | Security Notes |
|--------|---------|-----------|---------------|
| GET | Retrieve data | Yes | Parameters in URL (visible in logs) |
| POST | Submit data | No | Body data, form submissions |
| PUT | Update/replace | Yes | May allow file upload |
| DELETE | Remove resource | Yes | Destructive operation |
| PATCH | Partial update | No | Partial modifications |
| HEAD | Get headers only | Yes | Reconnaissance |
| OPTIONS | Get allowed methods | Yes | CORS preflight, enumeration |
| TRACE | Echo request back | Yes | XST attack vector |

### HTTP Status Codes

| Range | Category | Common Codes |
|-------|----------|-------------|
| 1xx | Informational | 100 Continue |
| 2xx | Success | 200 OK, 201 Created, 204 No Content |
| 3xx | Redirection | 301 Moved, 302 Found, 304 Not Modified |
| 4xx | Client Error | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found |
| 5xx | Server Error | 500 Internal Error, 502 Bad Gateway, 503 Unavailable |

### HTTPS and TLS

```
HTTPS = HTTP + TLS/SSL encryption

TLS Handshake:
┌──────────┐                           ┌──────────┐
│  Client  │                           │  Server  │
└────┬─────┘                           └────┬─────┘
     │                                      │
     │──── ClientHello ───────────────────→│  Supported versions, ciphers
     │                                      │
     │←─── ServerHello ───────────────────│  Chosen version, cipher
     │←─── Certificate ───────────────────│  Server's public certificate
     │←─── ServerHelloDone ───────────────│
     │                                      │
     │──── ClientKeyExchange ─────────────→│  Pre-master secret (encrypted)
     │──── ChangeCipherSpec ──────────────→│  Switching to encrypted
     │──── Finished ──────────────────────→│
     │                                      │
     │←─── ChangeCipherSpec ──────────────│
     │←─── Finished ──────────────────────│
     │                                      │
     │← Encrypted Communication →│
```

---

## ARP — Address Resolution Protocol

### How ARP Works

ARP maps IP addresses to MAC addresses on a local network.

```
Computer A wants to send data to 192.168.1.5
but only knows its IP, not its MAC address.

1. Computer A broadcasts: "Who has 192.168.1.5?"
   (ARP Request → sent to FF:FF:FF:FF:FF:FF)

2. Computer B (192.168.1.5) responds:
   "I am 192.168.1.5, my MAC is AA:BB:CC:DD:EE:FF"
   (ARP Reply → sent directly to Computer A)

3. Computer A caches this mapping
```

### ARP Spoofing (Man-in-the-Middle)

```
Normal:
Victim → Gateway (Router) → Internet

ARP Spoofing Attack:
Attacker tells Victim: "I am the Gateway" (fake ARP reply)
Attacker tells Gateway: "I am the Victim" (fake ARP reply)

Result:
Victim → Attacker → Gateway → Internet
                ↑
         Attacker sees ALL traffic!

Tool: arpspoof, Ettercap, Bettercap
Defense: Static ARP entries, ARP inspection, encryption
```

### ARP Commands

```bash
# View ARP cache
arp -a
ip neigh

# Clear ARP cache
sudo ip neigh flush all

# Static ARP entry (defense)
sudo arp -s 192.168.1.1 AA:BB:CC:DD:EE:FF
```

---

## DHCP

### How DHCP Works (DORA Process)

```
┌──────────┐                           ┌──────────────┐
│  Client  │                           │ DHCP Server  │
└────┬─────┘                           └──────┬───────┘
     │                                        │
     │──── DISCOVER (broadcast) ─────────────→│  "I need an IP!"
     │                                        │
     │←─── OFFER ────────────────────────────│  "Here's 192.168.1.50"
     │                                        │
     │──── REQUEST ──────────────────────────→│  "I'll take it!"
     │                                        │
     │←─── ACKNOWLEDGE ──────────────────────│  "It's yours!"
     │                                        │

Client now has:
- IP Address: 192.168.1.50
- Subnet Mask: 255.255.255.0
- Default Gateway: 192.168.1.1
- DNS Server: 8.8.8.8
- Lease Time: 24 hours
```

### DHCP Attacks

| Attack | Description | Defense |
|--------|-------------|---------|
| DHCP Starvation | Request all available IPs | Port security, DHCP snooping |
| Rogue DHCP | Set up fake DHCP server | DHCP snooping |
| DHCP Spoofing | Respond with malicious settings (fake gateway) | DHCP snooping |

---

## Network Devices

### Device Comparison

| Device | OSI Layer | Function | Intelligence |
|--------|-----------|----------|-------------|
| Hub | 1 (Physical) | Broadcasts all traffic to all ports | None |
| Switch | 2 (Data Link) | Forwards based on MAC address | MAC table |
| Router | 3 (Network) | Forwards based on IP address | Routing table |
| Firewall | 3-7 | Filters traffic based on rules | Rule-based |
| Load Balancer | 4-7 | Distributes traffic | Algorithm-based |
| WAF | 7 (Application) | Filters web attacks | Signature/behavior |

### Switch Security Issues

| Attack | Description | Result |
|--------|-------------|--------|
| MAC Flooding | Overwhelm switch MAC table | Switch acts as hub (sniffing) |
| VLAN Hopping | Jump between VLANs | Access restricted segments |
| MAC Spoofing | Clone another device's MAC | Bypass port security |

---

## Firewalls and NAT

### Firewall Types

| Type | Layer | Description |
|------|-------|-------------|
| Packet Filter | 3-4 | Examines IP/port, stateless |
| Stateful | 3-4 | Tracks connection state |
| Application (WAF) | 7 | Inspects application data |
| Next-Gen (NGFW) | 3-7 | Deep packet inspection + more |

### NAT (Network Address Translation)

```
Private Network              NAT Router              Internet
┌──────────────┐         ┌────────────┐         ┌──────────┐
│ 192.168.1.10 │────────→│            │────────→│          │
│ 192.168.1.11 │────────→│ Public IP: │         │ Web      │
│ 192.168.1.12 │────────→│ 203.0.113.5│────────→│ Server   │
└──────────────┘         └────────────┘         └──────────┘

All internal devices share ONE public IP address.
NAT translates private ←→ public addresses.
```

### Linux Firewall (iptables)

```bash
# View rules
sudo iptables -L -n -v

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Drop all other incoming
sudo iptables -A INPUT -j DROP

# Allow outgoing
sudo iptables -A OUTPUT -j ACCEPT

# Block specific IP
sudo iptables -A INPUT -s 10.10.10.50 -j DROP

# Save rules
sudo iptables-save > /etc/iptables/rules.v4
```

---

## VPNs and Tunneling

### VPN Types

| Type | Description | Use Case |
|------|-------------|----------|
| Site-to-Site | Connect two networks | Office to office |
| Remote Access | Connect user to network | Remote workers |
| SSL/TLS VPN | Browser-based | Easy deployment |
| IPSec | Network-layer encryption | Strongest security |
| WireGuard | Modern, fast | Performance |
| OpenVPN | Open source, flexible | General purpose |

### SSH Tunneling

```bash
# Local port forwarding
# Access remote_host:3306 via localhost:9906
ssh -L 9906:localhost:3306 user@remote_host

# Remote port forwarding
# Make your localhost:8080 available on remote as :9090
ssh -R 9090:localhost:8080 user@remote_host

# Dynamic port forwarding (SOCKS proxy)
ssh -D 1080 user@remote_host
# Configure browser to use SOCKS5 proxy: localhost:1080

# Proxychains through SSH tunnel
proxychains nmap -sT 10.10.10.0/24
```

---

## Wireless Networks

### WiFi Security Protocols

| Protocol | Security Level | Encryption | Status |
|----------|--------------|------------|--------|
| WEP | Very Weak | RC4 | Broken — never use |
| WPA | Weak | TKIP (RC4) | Deprecated |
| WPA2-PSK | Good | AES-CCMP | Current standard |
| WPA2-Enterprise | Strong | AES + RADIUS | Enterprise |
| WPA3 | Strongest | SAE + AES | Latest standard |

### WiFi Attacks

| Attack | Target | Tool |
|--------|--------|------|
| Deauthentication | Any WiFi | aireplay-ng |
| WPA2 Handshake Capture | WPA2-PSK | airodump-ng |
| Password Cracking | Captured handshake | hashcat, aircrack-ng |
| Evil Twin | Any network | hostapd, wifiphisher |
| KARMA | Auto-connecting devices | WiFi-Pumpkin |

---

## Packet Analysis with Wireshark

### Wireshark Basics

```
Capture → Analyze → Filter → Interpret

Essential Display Filters:
┌──────────────────────────────────────────────────────────────┐
│ ip.addr == 192.168.1.100        Show traffic to/from IP      │
│ tcp.port == 80                   Show HTTP traffic            │
│ dns                              Show DNS queries             │
│ http.request.method == "POST"    Show POST requests           │
│ tcp.flags.syn == 1               Show SYN packets (scans)    │
│ !(arp or dns or icmp)            Exclude noise               │
│ tcp.analysis.retransmission      Show retransmissions        │
│ frame.len > 1000                 Large packets               │
│ http.request.uri contains "pass" Possible credential leak    │
│ tcp.stream eq 5                  Follow specific stream      │
└──────────────────────────────────────────────────────────────┘
```

### What to Look For (Security Analysis)

| Indicator | Possible Attack |
|-----------|----------------|
| Many SYN packets, no ACKs | Port scan or SYN flood |
| ARP requests to all IPs | Network reconnaissance |
| DNS queries to unusual domains | Malware C2, data exfiltration |
| Large DNS TXT responses | DNS tunneling |
| HTTP with passwords in cleartext | Credential theft |
| Unusual ports with data | Backdoor, C2 |
| Repeated failed connections | Brute force attack |
| ICMP with data payloads | ICMP tunneling |

### tcpdump (Command-Line Packet Capture)

```bash
# Capture all traffic on eth0
sudo tcpdump -i eth0

# Capture and save to file
sudo tcpdump -i eth0 -w capture.pcap

# Filter by host
sudo tcpdump -i eth0 host 192.168.1.100

# Filter by port
sudo tcpdump -i eth0 port 80

# Filter by protocol
sudo tcpdump -i eth0 tcp
sudo tcpdump -i eth0 udp
sudo tcpdump -i eth0 icmp

# Show packet contents (ASCII)
sudo tcpdump -i eth0 -A port 80

# Show packet contents (hex + ASCII)
sudo tcpdump -i eth0 -XX port 80

# Complex filter
sudo tcpdump -i eth0 'tcp port 80 and host 192.168.1.100'

# Read pcap file
tcpdump -r capture.pcap

# Capture only N packets
sudo tcpdump -i eth0 -c 100 -w sample.pcap
```

---

## Network Attacks

### Common Network Attacks Overview

| Attack | Layer | Description | Defense |
|--------|-------|-------------|---------|
| ARP Spoofing | 2 | Fake ARP replies → MITM | ARP inspection, static entries |
| MAC Flooding | 2 | Overflow switch MAC table | Port security |
| VLAN Hopping | 2 | Access other VLANs | Proper VLAN config |
| IP Spoofing | 3 | Fake source IP | Ingress filtering, uRPF |
| ICMP Redirect | 3 | Reroute traffic | Disable ICMP redirects |
| SYN Flood | 4 | Exhaust connection table | SYN cookies, rate limiting |
| DNS Poisoning | 7 | Fake DNS responses | DNSSEC |
| MITM | Various | Intercept communications | Encryption, certificate pinning |
| BGP Hijacking | 3 | Reroute internet traffic | RPKI |

### Man-in-the-Middle (MITM) Attack

```
Normal Communication:
Alice ←──── Encrypted ────→ Bob

MITM Attack:
Alice ←── Encrypted ──→ Eve ←── Encrypted ──→ Bob
                         │
                    Eve decrypts,
                    reads/modifies,
                    re-encrypts

Tools: Bettercap, mitmproxy, Ettercap
Defense: TLS, certificate pinning, HSTS
```

---

## Exercises

### Exercise 1: Subnetting Practice
Calculate the following:
1. Network 10.0.0.0/22 — How many hosts? What's the broadcast address?
2. Given 172.16.50.100/28 — What's the network address? Valid host range?
3. Divide 192.168.10.0/24 into 8 equal subnets. List all network addresses.

### Exercise 2: Protocol Analysis
1. Capture a DNS query using tcpdump or Wireshark
2. Identify the query type, domain, and response IP
3. Capture an HTTP request and identify all headers
4. Capture a TCP handshake and label SYN, SYN-ACK, ACK

### Exercise 3: Network Enumeration
```bash
# Discover live hosts on your network
nmap -sn 192.168.1.0/24

# Identify your gateway
ip route | grep default

# Trace route to google.com
traceroute google.com

# Find open ports on your gateway
nmap -sV 192.168.1.1
```

### Exercise 4: DNS Investigation
```bash
# Find all DNS records for a domain
dig example.com ANY

# Perform reverse DNS on an IP
dig -x 8.8.8.8

# Test for zone transfer vulnerability
dig axfr @ns1.example.com example.com

# Use multiple DNS servers and compare results
dig @8.8.8.8 example.com
dig @1.1.1.1 example.com
```

---

## Labs

### Lab 1: Wireshark Analysis
1. Download sample pcap files from wireshark.org/sample
2. Analyze a TCP handshake
3. Follow an HTTP stream
4. Identify credentials in cleartext traffic
5. Detect a port scan

### Lab 2: ARP Spoofing (In YOUR Lab Only!)
1. Set up 3 VMs (attacker, victim, gateway)
2. Perform ARP spoofing with arpspoof or bettercap
3. Capture victim's traffic
4. Implement defense (static ARP)

### Lab 3: Network Scanning
1. Set up a target VM with various services
2. Perform host discovery
3. Port scan and identify services
4. Detect OS fingerprint
5. Document findings

---

## Interview Questions

1. **Q: Explain the TCP three-way handshake and why it's important for security.**
   A: SYN → SYN-ACK → ACK establishes a reliable connection. Security relevance: SYN flood attacks exhaust the server's connection table by sending SYN packets without completing the handshake. SYN cookies and rate limiting defend against this.

2. **Q: What is the difference between TCP and UDP? Give security examples for each.**
   A: TCP is connection-oriented, reliable (web, SSH, email). UDP is connectionless, fast (DNS, VoIP, gaming). Security: TCP SYN floods, UDP amplification attacks (DNS amp, NTP amp).

3. **Q: How would you detect a network scan?**
   A: Look for: many SYN packets to different ports from one source, rapid sequential port connections, unusual ICMP activity, connections to uncommon ports, many connection resets. Tools: IDS (Snort/Suricata), SIEM correlation, Wireshark analysis.

4. **Q: Explain DNS tunneling and how to detect it.**
   A: DNS tunneling encodes data in DNS queries/responses to bypass firewalls. Detection: unusually long subdomain names, high volume of TXT queries, uncommon query patterns, communication with unusual DNS servers, high DNS traffic volume from one host.

5. **Q: What is ARP spoofing and how do you prevent it?**
   A: ARP spoofing sends fake ARP replies to associate the attacker's MAC with a legitimate IP (usually the gateway), enabling MITM. Prevention: Dynamic ARP Inspection (DAI) on switches, static ARP entries for critical hosts, encrypted protocols (HTTPS, SSH), network monitoring for ARP anomalies.

---

## Summary

| Topic | Key Takeaway |
|-------|-------------|
| OSI Model | 7 layers — each has attack surfaces |
| TCP | Reliable, handshake — SYN floods |
| UDP | Fast, connectionless — amplification attacks |
| DNS | Name resolution — tunneling, poisoning |
| HTTP | Web protocol — cleartext, manipulation |
| ARP | MAC resolution — spoofing enables MITM |
| Subnetting | Network division — segmentation is security |
| Firewalls | Traffic filtering — defense in depth |
| Wireshark | Packet analysis — see everything |

**Next:** → [04-Programming](../04-Programming/README.md)

---

*"The network is the battlefield. The packet is the bullet. Understanding both is your armor."*
