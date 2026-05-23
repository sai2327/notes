# 🎓 Cybersecurity Certifications

## Complete Guide to Certifications — What to Get, When, and How to Pass

---

## Table of Contents

1. [Certification Strategy](#certification-strategy)
2. [CompTIA Security+ (SY0-701)](#comptia-security-sy0-701)
3. [CompTIA CySA+ (CS0-003)](#comptia-cysa-cs0-003)
4. [eJPT (eLearnSecurity Junior Penetration Tester)](#ejpt)
5. [PNPT (Practical Network Penetration Tester)](#pnpt)
6. [OSCP (Offensive Security Certified Professional)](#oscp)
7. [CEH (Certified Ethical Hacker)](#ceh)
8. [CISSP (Certified Information Systems Security Professional)](#cissp)
9. [AWS Security Specialty](#aws-security-specialty)
10. [SANS/GIAC Certifications](#sansgiac-certifications)
11. [Certification Roadmap by Career Path](#certification-roadmap-by-career-path)
12. [Study Strategies](#study-strategies)
13. [Budget-Friendly Options](#budget-friendly-options)

---

## Certification Strategy

### When to Get Certifications

```
Career Stage → Recommended Certifications
─────────────────────────────────────────────────
Student/Entry Level:
  → CompTIA Security+ (baseline, HR filter)
  → eJPT (practical skills proof)
  → CompTIA Network+ (if weak on networking)

1-2 Years Experience:
  → CySA+ (blue team) OR PNPT (red team)
  → AWS/Azure Security (if cloud-focused)
  → CEH (if employer values it)

3-5 Years Experience:
  → OSCP (gold standard for pentest)
  → SANS GIAC courses (specialized)
  → CISSP (management track)

5+ Years / Leadership:
  → CISSP (required for many senior roles)
  → CISM (management focus)
  → OSEP/OSED (expert-level offensive)
```

### ROI Analysis

```
Certification     | Cost      | Salary Impact | Time to Study | Difficulty
─────────────────────────────────────────────────────────────────────────
Security+         | $392      | +$10-15K      | 4-8 weeks     | ★★☆☆☆
CySA+             | $392      | +$10-15K      | 6-10 weeks    | ★★★☆☆
eJPT              | $249      | +$5-10K       | 4-6 weeks     | ★★☆☆☆
PNPT              | $399      | +$10-15K      | 8-12 weeks    | ★★★☆☆
CEH               | $1,199    | +$10-15K      | 8-12 weeks    | ★★★☆☆
OSCP              | $1,599    | +$20-30K      | 3-6 months    | ★★★★★
CISSP             | $749      | +$25-40K      | 3-6 months    | ★★★★☆
AWS Security      | $300      | +$15-20K      | 6-10 weeks    | ★★★☆☆
SANS GIAC         | $7,000+   | +$15-25K      | varies        | ★★★★☆
```

---

## CompTIA Security+ (SY0-701)

### Exam Overview

```
Format:         Maximum 90 questions
Types:          Multiple choice + Performance-based questions (PBQs)
Time:           90 minutes
Passing Score:  750/900
Cost:           $392 USD
Prerequisites:  None (Network+ recommended)
Validity:       3 years (requires renewal)
```

### Domain Breakdown (SY0-701)

```
Domain                                          Weight
──────────────────────────────────────────────────────
1.0 General Security Concepts                   12%
2.0 Threats, Vulnerabilities & Mitigations      22%
3.0 Security Architecture                       18%
4.0 Security Operations                         28%
5.0 Security Program Management & Oversight     20%
```

### Study Plan (8 Weeks)

```
Week 1-2: General Security Concepts (Domain 1)
├── CIA Triad, AAA framework
├── Security controls (technical, managerial, operational, physical)
├── Zero Trust architecture
├── Encryption concepts (symmetric, asymmetric, hashing)
├── PKI and certificate management
├── Authentication methods (MFA, biometrics, tokens)
└── Practice: 50 questions/day

Week 3-4: Threats, Vulnerabilities & Mitigations (Domain 2)
├── Threat actor types and motivations
├── Attack vectors and surfaces
├── Vulnerability types (software, hardware, human)
├── Malware types (ransomware, trojans, rootkits, etc.)
├── Social engineering techniques
├── Cryptographic attacks
├── Indicators of compromise (IOCs)
└── Practice: 50 questions/day + labs

Week 5-6: Security Architecture + Operations (Domains 3 & 4)
├── Network security (firewalls, IDS/IPS, VPN, NAC)
├── Secure protocols (TLS, SSH, IPSec)
├── Cloud security models (IaaS, PaaS, SaaS)
├── Incident response process
├── Digital forensics basics
├── Log analysis and monitoring
├── Vulnerability management
├── Data protection (DLP, classification)
└── Practice: 75 questions/day + PBQ practice

Week 7-8: Program Management + Review (Domain 5)
├── Governance, risk, and compliance (GRC)
├── Security policies and procedures
├── Risk management (frameworks, assessment)
├── Regulations (GDPR, HIPAA, PCI-DSS, SOX)
├── Security awareness training
├── Auditing and assessments
├── Full practice exams (2-3 full tests)
└── Focus on weak areas identified in practice tests
```

### Top Resources

```
Free:
- Professor Messer YouTube (complete video course)
- Professor Messer study groups (live sessions)
- CompTIA Security+ objectives document
- Cybrary free tier

Paid (Recommended):
- Jason Dion Udemy course ($15-20 on sale)
- Jason Dion Practice exams ($15 on sale)
- CompTIA CertMaster Labs ($119)

Books:
- Darril Gibson "Get Certified Get Ahead" 
- CompTIA Security+ Study Guide (Sybex)
```

### PBQ Tips

```
Performance-Based Questions (PBQs) test hands-on skills:
- Drag-and-drop firewall rules
- Configure network security settings
- Analyze log entries
- Match attacks to mitigation strategies
- Network diagram analysis

Strategy:
1. Skip PBQs initially, do multiple choice first
2. Return to PBQs with remaining time
3. PBQs are weighted heavily - don't leave blank
4. Practice with CertMaster Labs or equivalent
```

---

## eJPT

### Exam Overview

```
Format:         Practical exam (real penetration test)
Environment:    Browser-based lab (no VPN needed)
Time:           48 hours
Passing Score:  70% (answer 15/20 questions correctly)
Cost:           $249 USD (exam + training)
Prerequisites:  None
Validity:       3 years
```

### What Makes eJPT Special

```
Unlike multiple-choice exams:
- You get a real network to hack
- Find flags by actually exploiting machines
- Use real tools (Nmap, Metasploit, Burp Suite)
- Must demonstrate practical skills
- Perfect stepping stone to OSCP

Skills tested:
- Network scanning and enumeration
- Web application testing
- System exploitation
- Brute force attacks
- Pivoting through networks
- Information gathering
```

### Study Plan (6 Weeks)

```
Week 1: Networking Fundamentals
├── TCP/IP, OSI model
├── Subnetting and routing
├── Common services and ports
├── Wireshark packet analysis
└── Lab: Set up practice network

Week 2: Information Gathering
├── Passive reconnaissance (OSINT)
├── Active scanning (Nmap)
├── Service enumeration
├── Directory brute forcing
└── Lab: Enumerate practice machines

Week 3: Web Application Attacks
├── OWASP Top 10
├── SQL injection (manual + sqlmap)
├── Cross-site scripting (XSS)
├── Directory traversal
├── Burp Suite usage
└── Lab: DVWA, bWAPP, WebGoat

Week 4: System Exploitation
├── Metasploit framework
├── Searching for exploits
├── Payload generation
├── Post-exploitation basics
└── Lab: Metasploitable, HTB easy boxes

Week 5: Network Exploitation
├── SMB exploitation
├── SSH brute force
├── Pivoting concepts
├── Pass-the-hash
└── Lab: Build multi-subnet practice network

Week 6: Exam Preparation
├── Practice full penetration tests
├── Time management (48 hours is plenty)
├── Documentation practice
├── TryHackMe "eJPT Prep" path
└── Review weak areas
```

---

## PNPT (Practical Network Penetration Tester)

### Exam Overview

```
Format:         5-day practical exam + report
Environment:    VPN-connected lab network
Time:           5 days for testing + 2 days for report
Passing Score:  Complete objectives + professional report
Cost:           $399 USD (includes 1 retake)
Prerequisites:  None (eJPT-level recommended)
Validity:       Lifetime
```

### Why PNPT is Valuable

```
- Most realistic certification exam in the industry
- Requires FULL penetration test methodology
- Active Directory attack chain required
- Professional report is graded
- Covers internal network testing (not just web apps)
- Created by TCM Security (Heath Adams)
- Increasingly recognized by employers
```

### Domain Coverage

```
1. Practical Ethical Hacking (main course)
   - Linux/networking fundamentals
   - Reconnaissance methodology
   - Scanning and enumeration
   - Exploitation
   - Active Directory attacks
   - Post-exploitation
   - Report writing

2. Open-Source Intelligence (OSINT)
   - Finding people/organizations online
   - Email gathering
   - Social media intelligence
   - Physical security assessment

3. External Pentest Playbook
   - External network testing methodology
   - Cloud enumeration
   - Public-facing asset discovery

4. Windows Privilege Escalation
   - Service exploits
   - Token impersonation
   - DLL hijacking
   - Unquoted service paths
   - AlwaysInstallElevated

5. Linux Privilege Escalation
   - SUID/SGID exploitation
   - Cron job abuse
   - Kernel exploits
   - Capability abuse
   - Path manipulation
```

### Study Plan (12 Weeks)

```
Week 1-2: Fundamentals
├── Complete PEH course networking section
├── Linux command line mastery
├── Set up Kali/Parrot and practice VM
└── Basic Python scripting

Week 3-4: Reconnaissance & Scanning
├── OSINT course (full)
├── Nmap deep dive
├── Service enumeration (SMB, FTP, HTTP, SNMP)
└── External Pentest Playbook

Week 5-6: Exploitation
├── Metasploit mastery
├── Manual exploitation techniques
├── Web app testing (SQLi, command injection)
├── Custom payload creation
└── Practice: 5 HTB/THM machines per week

Week 7-8: Active Directory
├── AD fundamentals (how it works)
├── LLMNR/NBT-NS poisoning
├── SMB relay attacks
├── IPv6 attacks
├── Kerberoasting & AS-REP Roasting
├── Pass-the-hash/Pass-the-ticket
├── Token impersonation
├── Lateral movement
├── DCSync
└── Lab: Set up AD lab and practice full chain

Week 9-10: Privilege Escalation
├── Windows PrivEsc course (full)
├── Linux PrivEsc course (full)
├── Practice on retired HTB boxes
└── Automate enumeration (winPEAS, linPEAS)

Week 11: Report Writing
├── Study professional pentest reports
├── Practice writing findings
├── Learn executive summary format
├── Use template for consistency
└── Practice: Write report for practice pentest

Week 12: Full Practice Runs
├── Do complete pentest on practice network
├── Time yourself (practice under 5-day limit)
├── Write professional report
├── Review and identify weak spots
└── Final review of all techniques
```

---

## OSCP (Offensive Security Certified Professional)

### Exam Overview

```
Format:         23 hours 45 minutes practical exam + report
Environment:    VPN-connected machines (3 standalone + 1 AD set)
Points:         100 total, 70 to pass
                - 3 standalone machines (20 points each)
                - 1 AD set (40 points for full chain)
                - Bonus points (10) for lab report
Cost:           $1,599 (90 days lab access + exam)
Prerequisites:  None (strong experience recommended)
Validity:       Lifetime
```

### Why OSCP is the Gold Standard

```
- Most recognized offensive security certification globally
- Proves you can actually hack machines under pressure
- "Try Harder" methodology builds problem-solving skills
- Required for most senior pentest positions
- HR filters often specify "OSCP preferred"
- Lifetime validity (no renewal needed)
```

### PEN-200 Course Modules

```
1. Penetration Testing with Kali Linux
2. Topics covered:
   - Information gathering (passive + active)
   - Vulnerability scanning
   - Web application attacks
   - Buffer overflow (Windows + Linux)
   - Client-side attacks
   - Public exploits (finding + modifying)
   - File transfers
   - Antivirus evasion
   - Privilege escalation (Win + Linux)
   - Password attacks
   - Port forwarding and pivoting
   - Active Directory attacks
   - Tunneling through deep networks
   - Metasploit framework
   - PowerShell empire
```

### Study Plan (4-6 Months)

```
Month 1: Course Material
├── Complete all PEN-200 modules
├── Do all course exercises
├── Take detailed notes
├── Build cheat sheets per topic
└── Set up personal lab mirrors

Month 2: Lab Machines (Easy → Medium)
├── Start with recommended "easy" machines
├── Do 5-10 machines per week
├── Document methodology for each
├── Join Discord/forums for hints when stuck
├── Focus on enumeration (90% of the work)
└── Target: 20-30 machines completed

Month 3: Lab Machines (Medium → Hard)
├── Tackle harder machines
├── Practice Active Directory attacks
├── Learn pivoting through networks
├── Focus on weak areas identified
├── Try machines without Metasploit
├── Target: 40-50 total machines
└── Write mini-reports for practice

Month 4: Exam Preparation
├── Prove Grounds Practice (Play + Practice)
├── HackTheBox retired OSCP-like machines
├── Practice buffer overflow to be < 1 hour
├── Time management practice (12 hours is tight)
├── Active Directory full chain practice
├── Build exam-day methodology
└── Practice report writing

Month 5 (if needed): Final Push
├── Focus exclusively on weak areas
├── Redo difficult machines from memory
├── Mock exam: 24 hours, no hints
├── Ensure all topics covered
└── Schedule exam when consistently solving 70% of practice

Exam Day Strategy:
1. Start with AD set (40 points, do first while fresh)
2. Enumerate everything before exploiting
3. Take screenshots immediately (for report)
4. Don't spend > 2 hours on one machine
5. Sleep 4-6 hours if needed (long exam)
6. Save 4+ hours for report writing
```

### OSCP Machine Methodology

```
Methodology for each machine:
──────────────────────────────

1. SCAN (15-20 minutes)
   nmap -sC -sV -oA nmap/initial $IP
   nmap -p- -oA nmap/allports $IP
   
2. ENUMERATE (vary by service)
   Web: gobuster, nikto, manual browsing, source code
   SMB: smbclient, smbmap, enum4linux
   FTP: anonymous login, file listing
   SNMP: snmpwalk with community strings
   
3. IDENTIFY VULNERABILITIES
   searchsploit for version-specific exploits
   Check for misconfigurations
   Default credentials
   
4. EXPLOIT
   Try least-effort exploit first
   Modify public exploits if needed
   Manual exploitation if automated fails
   
5. POST-EXPLOITATION
   Stabilize shell
   Enumerate for privesc (linpeas/winpeas)
   Check sudo, SUID, services, cron, etc.
   
6. PRIVILEGE ESCALATION
   Use identified vector
   Get root/SYSTEM proof
   
7. DOCUMENT
   Screenshot proof.txt
   Note all commands used
   Record exploitation path
```

---

## CISSP (Certified Information Systems Security Professional)

### Exam Overview

```
Format:         CAT (Computer Adaptive Testing) for English
                100-150 questions
Time:           3 hours
Passing Score:  700/1000
Cost:           $749 USD
Prerequisites:  5 years experience (or 4 with degree)
                Can pass exam first, get "Associate of (ISC)²"
Validity:       3 years (requires CPE credits)
```

### Eight Domains

```
Domain                                              Weight
────────────────────────────────────────────────────────────
1. Security and Risk Management                     16%
2. Asset Security                                   10%
3. Security Architecture and Engineering            13%
4. Communication and Network Security               13%
5. Identity and Access Management (IAM)             13%
6. Security Assessment and Testing                  12%
7. Security Operations                              13%
8. Software Development Security                    10%
```

### Study Plan (16 Weeks)

```
Week 1-2: Domain 1 - Security and Risk Management (16%)
├── Security governance principles
├── Compliance and regulatory issues
├── Legal/regulatory investigations
├── Professional ethics
├── Security policies, standards, procedures, guidelines
├── Business continuity planning
├── Personnel security policies
├── Risk management concepts
├── Threat modeling
├── Supply chain risk management
└── Key concept: "Think like a MANAGER, not a technician"

Week 3-4: Domain 2 - Asset Security (10%)
├── Information and asset classification
├── Asset ownership and accountability
├── Privacy protection
├── Data retention policies
├── Data security controls
├── Data handling requirements
└── Data remanence

Week 5-6: Domain 3 - Security Architecture and Engineering (13%)
├── Security design principles
├── Security models (Bell-LaPadula, Biba, Clark-Wilson)
├── Security evaluation models (TCSEC, ITSEC, Common Criteria)
├── Security capabilities of information systems
├── Vulnerabilities in architectures
├── Cryptography fundamentals and applications
├── Physical security
└── Key concept: Security models will be on the exam!

Week 7-8: Domain 4 - Communication and Network Security (13%)
├── Secure network architecture design
├── Network components (firewalls, proxies, etc.)
├── Secure communication channels
├── Network attacks and countermeasures
├── OSI and TCP/IP models
└── Key concept: Understand protocols at all layers

Week 9-10: Domain 5 - Identity and Access Management (13%)
├── Physical and logical access control
├── Identification and authentication
├── Identity as a service (IDaaS)
├── Third-party identity services
├── Access control attacks
├── Identity and access provisioning lifecycle
└── Key concept: Least privilege, separation of duties

Week 11-12: Domain 6 - Security Assessment and Testing (12%)
├── Assessment and test strategies
├── Security control testing
├── Vulnerability assessments
├── Penetration testing
├── Log reviews and auditing
├── Synthetic transactions
└── Key concept: Test types and when to use them

Week 13-14: Domain 7 - Security Operations (13%)
├── Investigation and incident management
├── Logging and monitoring
├── Resource protection
├── Disaster recovery
├── Business continuity
├── Physical security
├── Personnel safety
└── Key concept: Incident response steps (DRMRRRL)

Week 15-16: Domain 8 + Full Review
├── Software Development Security (10%)
├── SDLC security
├── Development environment security
├── Software security effectiveness
├── FULL practice exams (4-5 total)
├── Review weak domains
└── Key concept: Think managerial, pick BEST answer
```

### CISSP Mindset

```
The #1 secret to passing CISSP:
Think like a RISK-AWARE SECURITY MANAGER, not a technician.

When choosing between answers:
1. Safety of human life ALWAYS comes first
2. Then protect assets
3. Prefer preventive over detective controls
4. Management solutions over technical solutions
5. Address ROOT CAUSE, not symptoms
6. If all else fails, pick the LEAST wrong answer

CAT exam tips:
- First questions establish your baseline
- Questions get harder when you're above passing
- Questions get easier when you're below
- You can't go back to previous questions
- Exam ends between 100-150 questions
- Ending at 100 = you clearly passed or failed
- Ending at 150 = borderline (could go either way)
```

---

## Certification Roadmap by Career Path

### SOC Analyst Path

```
Year 1: Security+ → CySA+
Year 2: Splunk Core Certified → GCIA or BTL1
Year 3: GCIH → CISSP (if moving to management)

Key skills to build alongside:
- SIEM proficiency (Splunk/Elastic)
- Incident response procedures
- Threat intelligence analysis
- Log analysis and correlation
```

### Penetration Tester Path

```
Year 1: eJPT → Security+
Year 2: PNPT → OSCP
Year 3: OSEP or CRTO → OSWE (web focus)

Key skills to build alongside:
- Active Directory exploitation
- Web application testing
- Buffer overflow/exploit development
- Report writing
- Programming (Python, C)
```

### Cloud Security Path

```
Year 1: Security+ → AWS Cloud Practitioner
Year 2: AWS Security Specialty → Azure Security Engineer
Year 3: CCSP → GCP Security

Key skills to build alongside:
- Infrastructure as Code (Terraform)
- Container security (Docker, Kubernetes)
- Cloud-native security tools
- Serverless security
- CI/CD pipeline security
```

---

## Study Strategies

### The Active Recall Method

```
1. Read/watch material on a topic
2. Close the source material
3. Write down everything you remember
4. Check what you missed
5. Focus on missed items
6. Repeat next day (spaced repetition)

Tools:
- Anki (free flashcard app with spaced repetition)
- Notion/Obsidian for organized notes
- Handwritten notes (proven better retention)
```

### Practice Test Strategy

```
1. Take first practice test cold (establish baseline)
2. Score each domain separately
3. Study weakest domains first (biggest improvement potential)
4. Take practice test after studying each domain
5. Track progress over time
6. Final week: full-length timed tests only
7. Target: consistently scoring 85%+ before real exam
8. Don't memorize answers - understand WHY each answer is correct
```

---

## Budget-Friendly Options

```
Free Learning Resources:
- Professor Messer (Security+, full video courses)
- Cybrary (free tier has good content)
- TryHackMe free rooms
- YouTube (NetworkChuck, David Bombal, etc.)
- Open source labs (VulnHub, DVWA)
- CompTIA exam objectives (free study guide basically)

Discounted Exams:
- CompTIA academic pricing (students)
- Employer-sponsored certification
- Veterans get free vouchers (through programs)
- Black Friday/Cyber Monday sales
- CompTIA Stackable certifications

High-ROI Budget Path:
$249 - eJPT (practical + affordable)
$392 - Security+ (industry requirement)
$0   - TryHackMe/HTB free tier for practice
$399 - PNPT (includes all training)
Total: $1,040 for 3 certifications that cover entry-level requirements
```

---

## Interview Questions About Certifications

```
Q: Why did you pursue [certification]?
A: Frame around career goals and practical application.
   "I pursued OSCP because I wanted to prove I can perform
   real penetration tests under pressure, and it's the industry
   standard for demonstrating offensive security skills."

Q: How do you keep your skills current after certification?
A: "I maintain skills through continuous lab practice (HTB/THM),
   attending security conferences, contributing to open source
   security tools, and staying current with threat intelligence
   feeds and security blogs."

Q: Certifications vs. experience - which matters more?
A: "They complement each other. Certifications prove structured
   knowledge and get past HR filters. Experience proves you can
   apply that knowledge in complex, real-world situations. The
   ideal is both, supported by demonstrable projects."
```

---

**Next:** → [23-Interview-Preparation](../23-Interview-Preparation/README.md)

*"Certifications open doors. Skills keep you in the room. Projects prove you belong there."*
