# 19. Final Practice Section

> Comprehensive assessment covering ALL topics. Includes MCQs, short answers, scenario-based questions, tool-based exercises, and real-world attack analysis.

---

## Section A: Multiple Choice Questions (50 MCQs)

### Fundamentals (Q1–Q10)

**Q1.** The CIA Triad stands for:
- A) Control, Information, Access
- B) Confidentiality, Integrity, Availability
- C) Cybersecurity, Intelligence, Analysis
- D) Classification, Identification, Authentication

**Answer:** B

---

**Q2.** Which type of hacker has NO authorization but claims good intentions?
- A) White hat
- B) Black hat
- C) Grey hat
- D) Script kiddie

**Answer:** C

---

**Q3.** Two-factor authentication requires:
- A) Two passwords
- B) Two factors from DIFFERENT categories (know/have/are)
- C) Two security questions
- D) Two email addresses

**Answer:** B

---

**Q4.** The OSI model has how many layers?
- A) 4
- B) 5
- C) 7
- D) 10

**Answer:** C

---

**Q5.** A private IP address is:
- A) Routable on the internet
- B) Used only within a local network
- C) Assigned by ICANN
- D) Always static

**Answer:** B

---

**Q6.** TCP performs a ___-way handshake to establish connections.
- A) 2
- B) 3
- C) 4
- D) 5

**Answer:** B (SYN → SYN-ACK → ACK)

---

**Q7.** DNS translates:
- A) IP to MAC address
- B) Domain name to IP address
- C) MAC to IP address
- D) Port number to IP address

**Answer:** B

---

**Q8.** The default port for HTTPS is:
- A) 80
- B) 8080
- C) 443
- D) 8443

**Answer:** C

---

**Q9.** Which protocol is connectionless?
- A) TCP
- B) UDP
- C) SSH
- D) HTTP

**Answer:** B

---

**Q10.** Least privilege means:
- A) Giving everyone admin access
- B) Giving minimum access needed for the job
- C) Using the weakest password possible
- D) Removing all access controls

**Answer:** B

---

### Threats & Attacks (Q11–Q20)

**Q11.** Ransomware:
- A) Steals passwords
- B) Encrypts files and demands payment
- C) Creates backdoors
- D) Sends spam emails

**Answer:** B

---

**Q12.** A phishing email that targets a specific executive is called:
- A) Spear phishing
- B) Whaling
- C) Vishing
- D) Smishing

**Answer:** B (Whaling targets C-level executives)

---

**Q13.** An attacker intercepts communication between two parties. This is:
- A) DoS attack
- B) Brute force
- C) Man-in-the-Middle (MITM)
- D) SQL injection

**Answer:** C

---

**Q14.** A DDoS attack uses:
- A) A single powerful computer
- B) Multiple compromised systems (botnet)
- C) Social engineering
- D) SQL queries

**Answer:** B

---

**Q15.** ARP spoofing is used for:
- A) DNS attacks
- B) Man-in-the-Middle attacks on local networks
- C) Password cracking
- D) Phishing

**Answer:** B

---

**Q16.** XSS (Cross-Site Scripting) injects:
- A) SQL code
- B) JavaScript code into web pages
- C) Assembly code
- D) Python scripts

**Answer:** B

---

**Q17.** CSRF (Cross-Site Request Forgery) makes:
- A) Server crash
- B) Authenticated user perform unwanted actions
- C) Database leak data
- D) Firewall disable

**Answer:** B

---

**Q18.** A zero-day vulnerability:
- A) Was patched yesterday
- B) Has no available patch
- C) Affects only old systems
- D) Is a low-severity bug

**Answer:** B

---

**Q19.** Social engineering primarily exploits:
- A) Software bugs
- B) Network protocols
- C) Human psychology
- D) Hardware flaws

**Answer:** C

---

**Q20.** A rootkit:
- A) Hides its presence on a system
- B) Is a legitimate admin tool
- C) Can only run on Linux
- D) Is easily detected by antivirus

**Answer:** A

---

### Cryptography (Q21–Q25)

**Q21.** AES is a _____ encryption algorithm.
- A) Asymmetric
- B) Symmetric
- C) Hashing
- D) Steganographic

**Answer:** B

---

**Q22.** RSA uses:
- A) Same key for encryption and decryption
- B) Public key for encryption, private key for decryption
- C) No keys at all
- D) Only hashing

**Answer:** B

---

**Q23.** Hashing is:
- A) Reversible encryption
- B) Two-way function
- C) One-way function (cannot be reversed)
- D) Symmetric encryption

**Answer:** C

---

**Q24.** A salt in password hashing:
- A) Makes the hash shorter
- B) Adds random data to prevent rainbow table attacks
- C) Encrypts the hash
- D) Is the same for all users

**Answer:** B

---

**Q25.** Which is the strongest hashing algorithm for passwords?
- A) MD5
- B) SHA1
- C) bcrypt/Argon2
- D) CRC32

**Answer:** C

---

### Tools & Techniques (Q26–Q35)

**Q26.** Nmap `-sS` performs:
- A) Full TCP connect scan
- B) SYN (stealth) scan
- C) UDP scan
- D) Ping sweep

**Answer:** B

---

**Q27.** In Metasploit, `RHOSTS` is:
- A) Your IP
- B) Target IP
- C) Gateway IP
- D) DNS server

**Answer:** B

---

**Q28.** Wireshark is used for:
- A) Password cracking
- B) Packet capture and analysis
- C) Vulnerability scanning
- D) Web crawling

**Answer:** B

---

**Q29.** Hashcat is faster than John because:
- A) Better algorithms
- B) GPU acceleration
- C) Cloud-based
- D) Uses quantum computing

**Answer:** B

---

**Q30.** SQLMap automates:
- A) Port scanning
- B) SQL injection testing
- C) Password cracking
- D) Phishing campaigns

**Answer:** B

---

**Q31.** Hydra is used for:
- A) Offline hash cracking
- B) Online brute force attacks
- C) Packet sniffing
- D) Disk imaging

**Answer:** B

---

**Q32.** Gobuster is used for:
- A) Password cracking
- B) Directory and file brute forcing on web servers
- C) Network scanning
- D) Malware analysis

**Answer:** B

---

**Q33.** The Burp Suite Repeater tab is for:
- A) Automated scanning
- B) Manually modifying and resending requests
- C) Encoding data
- D) Crawling websites

**Answer:** B

---

**Q34.** `nc -lvnp 4444` does:
- A) Scans port 4444
- B) Listens on port 4444 for incoming connections
- C) Connects to port 4444
- D) Blocks port 4444

**Answer:** B

---

**Q35.** Nmap `--script vuln` runs:
- A) All Nmap scripts
- B) Only vulnerability detection scripts
- C) Only safe scripts
- D) Only brute force scripts

**Answer:** B

---

### Defense & Security (Q36–Q45)

**Q36.** A NGFW includes:
- A) Only packet filtering
- B) Deep packet inspection + application awareness + IPS
- C) Only antivirus
- D) Only VPN

**Answer:** B

---

**Q37.** IDS is _____ while IPS is _____.
- A) Active; Passive
- B) Passive (alerts only); Active (blocks)
- C) Network-based; Host-based
- D) Free; Paid

**Answer:** B

---

**Q38.** In the Shared Responsibility Model, who secures the OS on a cloud VM (IaaS)?
- A) Cloud provider
- B) Customer
- C) Internet service provider
- D) No one

**Answer:** B

---

**Q39.** GDPR requires breach notification within:
- A) 24 hours
- B) 72 hours
- C) 7 days
- D) 30 days

**Answer:** B

---

**Q40.** Which Wi-Fi standard is BROKEN?
- A) WPA3
- B) WPA2
- C) WPA
- D) WEP

**Answer:** D (WEP can be cracked in minutes)

---

**Q41.** VPN creates:
- A) A new network
- B) An encrypted tunnel over untrusted network
- C) A wireless hotspot
- D) A firewall rule

**Answer:** B

---

**Q42.** PPTP VPN protocol should NOT be used because:
- A) It's too slow
- B) Its encryption is broken
- C) It's too expensive
- D) It only works on Windows

**Answer:** B

---

**Q43.** SIEM does:
- A) Blocks malware
- B) Collects and correlates logs from multiple sources
- C) Encrypts data
- D) Manages user accounts

**Answer:** B

---

**Q44.** Chain of custody in forensics ensures:
- A) Evidence is collected quickly
- B) Evidence integrity and legal admissibility
- C) Evidence is encrypted
- D) Evidence is public

**Answer:** B

---

**Q45.** The MITRE ATT&CK framework:
- A) Is a vulnerability scanner
- B) Maps adversary tactics and techniques
- C) Is an encryption algorithm
- D) Is a firewall product

**Answer:** B

---

### Advanced (Q46–Q50)

**Q46.** Ghidra is:
- A) A web scanner
- B) A reverse engineering tool
- C) A password cracker
- D) An antivirus

**Answer:** B

---

**Q47.** In incident response, the FIRST step is:
- A) Containment
- B) Eradication
- C) Preparation
- D) Recovery

**Answer:** C

---

**Q48.** Purple team is:
- A) Attackers only
- B) Defenders only
- C) Collaboration between red (attack) and blue (defense) teams
- D) Management team

**Answer:** C

---

**Q49.** Static malware analysis means:
- A) Running malware in a sandbox
- B) Analyzing malware without executing it
- C) Sending malware to the vendor
- D) Deleting malware

**Answer:** B

---

**Q50.** Under India's IT Act, cyber terrorism (Section 66F) carries:
- A) Fine only
- B) 3 years imprisonment
- C) 7 years imprisonment
- D) Life imprisonment

**Answer:** D

---

## Section B: Short Answer Questions

**Q1.** Define the CIA Triad and give one example for each component.

> **Confidentiality:** Only authorized access. Example: Encryption protects data.
> **Integrity:** Data is accurate and unmodified. Example: Hashing verifies file integrity.
> **Availability:** Systems accessible when needed. Example: Redundant servers prevent downtime.

---

**Q2.** What is the difference between symmetric and asymmetric encryption?

> Symmetric uses the same key for encryption and decryption (e.g., AES). Asymmetric uses a key pair — public key encrypts, private key decrypts (e.g., RSA). Symmetric is faster; asymmetric solves key distribution.

---

**Q3.** Explain the Nmap command: `nmap -sS -sV -O -p 1-1000 -T4 192.168.1.100`

> `-sS`: SYN stealth scan. `-sV`: Detect service versions. `-O`: Detect OS. `-p 1-1000`: Scan ports 1-1000. `-T4`: Aggressive timing. Target: 192.168.1.100.

---

**Q4.** What is SQL injection and how do you prevent it?

> SQL injection inserts malicious SQL into user input fields to manipulate the database. Prevention: Use parameterized queries / prepared statements, input validation, least privilege DB accounts, and WAF.

---

**Q5.** What are the five phases of ethical hacking?

> 1. Reconnaissance (information gathering)
> 2. Scanning (finding vulnerabilities)
> 3. Gaining Access (exploitation)
> 4. Maintaining Access (persistence)
> 5. Reporting (documenting findings and remediation)

---

## Section C: Scenario-Based Questions

### Scenario 1: Suspicious Login Activity

```
Your SIEM shows 500 failed SSH login attempts from IP 45.33.32.x
to your server in the last 10 minutes, all with different usernames.
```

**Q:** What type of attack is this? What actions do you take?

> **Attack:** SSH brute force attack (username enumeration + password guessing).
> **Actions:**
> 1. Block the IP immediately: `sudo iptables -A INPUT -s 45.33.32.0/24 -j DROP`
> 2. Check if any login succeeded: `grep "Accepted" /var/log/auth.log`
> 3. Install fail2ban to auto-block: `sudo apt install fail2ban`
> 4. Disable password auth, use SSH keys only
> 5. Change SSH port from default 22
> 6. Report the IP to abuse contact

---

### Scenario 2: Data Breach Suspected

```
A web application shows unusual database queries in logs.
SELECT * FROM users WHERE id=1 UNION SELECT username,password FROM admin--
```

**Q:** What attack is this? What is the attacker trying to do? How do you respond?

> **Attack:** SQL Injection (UNION-based).
> **Goal:** Extract admin usernames and passwords from the admin table.
> **Response:**
> 1. Take the application offline or block the attacker's IP
> 2. Review all logs to determine what data was accessed
> 3. Fix the vulnerable code with parameterized queries
> 4. Reset all admin passwords
> 5. Check if data was exfiltrated
> 6. Notify affected users if personal data was exposed
> 7. Report as per legal requirements (GDPR: 72 hours)

---

### Scenario 3: Ransomware Attack

```
Multiple employees report their files are encrypted with .locked extension.
A ransom note demands 5 BTC for decryption keys.
```

**Q:** Walk through your incident response.

> **Response:**
> 1. **Contain:** Immediately isolate infected machines from the network (disconnect cables, disable Wi-Fi)
> 2. **Identify scope:** How many machines affected? What data is encrypted?
> 3. **Preserve evidence:** Image affected drives before any cleanup
> 4. **Do NOT pay ransom** (no guarantee of decryption, funds criminal activity)
> 5. Check for decryptors at nomoreransom.org
> 6. **Eradicate:** Identify entry point (phishing? RDP? exploit?), remove malware
> 7. **Recover:** Restore from clean backups
> 8. **Harden:** Patch the entry point, improve email filtering, enable MFA
> 9. **Report:** Notify law enforcement and affected parties
> 10. **Learn:** Update IR plan, conduct security awareness training

---

### Scenario 4: Nmap Output Analysis

```
PORT     STATE    SERVICE     VERSION
22/tcp   open     ssh         OpenSSH 7.2p2
80/tcp   open     http        Apache 2.4.18
443/tcp  open     ssl/http    Apache 2.4.18
3306/tcp open     mysql       MySQL 5.7.12
8080/tcp filtered http-proxy
```

**Q:** What security concerns do you see? What would you recommend?

> **Concerns:**
> 1. MySQL (3306) is open — database should NOT be publicly accessible
> 2. OpenSSH 7.2p2 has known vulnerabilities — needs update
> 3. Apache 2.4.18 is outdated — needs update
> 4. Port 8080 is filtered (firewall blocking) — verify this is intentional
>
> **Recommendations:**
> 1. Restrict MySQL to localhost or private network only
> 2. Update OpenSSH to latest version
> 3. Update Apache to latest version
> 4. Verify 8080 is not needed, keep firewall blocking it
> 5. Enable HTTPS only (redirect port 80 → 443)

---

### Scenario 5: Wireshark Capture Analysis

```
You notice many ARP replies from two different MAC addresses claiming
to be the gateway (192.168.1.1):
  00:11:22:33:44:55 → I am 192.168.1.1
  AA:BB:CC:DD:EE:FF → I am 192.168.1.1
```

**Q:** What attack is happening? How do you defend?

> **Attack:** ARP Spoofing / ARP Poisoning — an attacker is sending fake ARP replies to redirect traffic through their machine (MITM attack).
> **Defense:**
> 1. Identify which MAC is legitimate (check router's actual MAC)
> 2. Set static ARP entry: `arp -s 192.168.1.1 00:11:22:33:44:55`
> 3. Enable Dynamic ARP Inspection (DAI) on managed switches
> 4. Use encrypted protocols (HTTPS, SSH) to protect data even if intercepted
> 5. Deploy ARP monitoring tools (arpwatch)

---

## Section D: Tool-Based Exercises

**Exercise 1:** Use Nmap to scan scanme.nmap.org (authorized target). Run a SYN scan with version detection on the top 100 ports. Save output in all formats.

```bash
sudo nmap -sS -sV --top-ports 100 -oA scanme_results scanme.nmap.org
```

---

**Exercise 2:** Create an MD5 hash of the word "cybersecurity" and crack it using John the Ripper with rockyou.txt.

```bash
echo -n "cybersecurity" | md5sum > hash.txt
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
john --show --format=raw-md5 hash.txt
```

---

**Exercise 3:** Write an iptables rule that allows only SSH (port 22) and HTTPS (port 443) and blocks everything else.

```bash
sudo iptables -F
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
```

---

**Exercise 4:** Write a Wireshark display filter to find all HTTP POST requests containing the word "password".

```
http.request.method == "POST" && http contains "password"
```

---

## Section E: Real-World Attack Analysis

### Case Study: WannaCry Ransomware (2017)

```
Attack Vector:  EternalBlue exploit (MS17-010) targeting Windows SMBv1
Spread Method:  Worm — self-propagating across networks
Impact:         200,000+ systems in 150 countries
                Hospitals (UK NHS), telecoms, factories shut down
Kill Switch:    Security researcher registered a domain the malware
                checked before encrypting — stopped the spread

Lessons:
  1. Patch systems promptly (MS had released patch 2 months before)
  2. Disable SMBv1
  3. Segment networks (limit worm spread)
  4. Maintain offline backups
  5. Don't pay ransom
```

### Case Study: SolarWinds Supply Chain Attack (2020)

```
Attack Vector:  Compromised SolarWinds Orion software update
Attacker:       APT29 (Russian state-sponsored)
Spread Method:  Malicious code in legitimate software update
Impact:         18,000+ organizations including US government agencies
Dwell Time:     ~9 months undetected

Lessons:
  1. Supply chain attacks are devastating
  2. Monitor for unusual network behavior even from trusted software
  3. Implement zero trust architecture
  4. Verify software integrity (hash checking, code signing)
  5. Limit third-party software privileges
```

---

## Score Guide

| Section | Questions | Max Score |
|---------|-----------|-----------|
| A: MCQs | 50 | 50 |
| B: Short Answer | 5 | 25 (5 each) |
| C: Scenarios | 5 | 50 (10 each) |
| D: Tool Exercises | 4 | 20 (5 each) |
| E: Case Studies | 2 | 5 (analysis) |
| **Total** | | **150** |

| Score | Grade | Level |
|-------|-------|-------|
| 135+ | A+ | Expert — Ready for certifications |
| 120-134 | A | Advanced — Strong foundation |
| 100-119 | B | Intermediate — Good understanding |
| 80-99 | C | Developing — Review weak areas |
| < 80 | D | Beginner — Revisit all topics |

---

> **Congratulations!** You have completed the full Cybersecurity Notes series (01–19). Review any weak areas and practice with hands-on labs (TryHackMe, HackTheBox, OverTheWire) for real-world experience.
