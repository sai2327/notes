# 17. Advanced Topics

## Table of Contents
- [17.1 Reverse Engineering](#171-reverse-engineering)
- [17.2 Malware Analysis](#172-malware-analysis)
- [17.3 Zero-Day Vulnerabilities](#173-zero-day-vulnerabilities)
- [17.4 Security Architecture & Design](#174-security-architecture--design)
- [17.5 Threat Intelligence](#175-threat-intelligence)
- [17.6 Incident Response](#176-incident-response)
- [17.7 Red Team vs Blue Team vs Purple Team](#177-red-team-vs-blue-team-vs-purple-team)
- [17.8 Common Mistakes & Interview Tips](#178-common-mistakes--interview-tips)
- [17.9 Practice & Assessment](#179-practice--assessment)

---

## 17.1 Reverse Engineering

### Definition
**Reverse engineering** is analyzing software or hardware to understand its internal workings without access to source code.

### Why It's Used

```
Legitimate uses:
  → Malware analysis (understand what malware does)
  → Vulnerability research (find bugs in binaries)
  → Compatibility (make software work with other systems)
  → Security auditing (verify closed-source software)

Illegal uses:
  → Software piracy (cracking license protection)
  → Creating exploits for malicious use
```

### Tools

| Tool | Purpose | Type |
|------|---------|------|
| **Ghidra** | Disassembler + decompiler (by NSA, free) | Static |
| **IDA Pro** | Industry-standard disassembler | Static |
| **radare2/Cutter** | Open-source reverse engineering | Static |
| **x64dbg** | Windows debugger | Dynamic |
| **GDB** | Linux debugger | Dynamic |
| **strace/ltrace** | System/library call tracing | Dynamic |

### Basic Analysis Commands

```bash
# Check file type
file suspicious_binary

# View readable strings in binary
strings suspicious_binary | head -50

# Check linked libraries
ldd suspicious_binary

# Trace system calls
strace ./suspicious_binary

# Trace library calls
ltrace ./suspicious_binary

# Disassemble with objdump
objdump -d suspicious_binary | head -100

# Debug with GDB
gdb ./suspicious_binary
(gdb) break main
(gdb) run
(gdb) disassemble
(gdb) info registers
(gdb) step
```

---

## 17.2 Malware Analysis

### Types of Analysis

| Type | Method | Speed | Depth |
|------|--------|-------|-------|
| **Static** | Examine without running | Fast | Surface-level |
| **Dynamic** | Run in sandbox, observe behavior | Medium | Behavioral |
| **Code Review** | Reverse engineer and read code | Slow | Deep understanding |

### Static Analysis Workflow

```
1. Calculate hash (MD5/SHA256)
   → Search VirusTotal for known malware

2. Check file type
   → file malware_sample
   → Is it really what it claims to be?

3. Extract strings
   → strings malware_sample
   → Look for URLs, IPs, registry keys, file paths

4. Check imports
   → What API functions does it use?
   → Network functions → communicates externally
   → File functions → reads/writes files
   → Registry functions → persistence mechanism

5. Check with YARA rules
   → Pattern matching against known malware signatures
```

### Dynamic Analysis — Sandbox Setup

```
Safe analysis environment:
  ┌─────────────────────────────────────┐
  │        HOST MACHINE                  │
  │  ┌──────────────────────────────┐   │
  │  │      VIRTUAL MACHINE         │   │
  │  │  (isolated, no internet*)    │   │
  │  │                              │   │
  │  │  1. Take VM snapshot         │   │
  │  │  2. Run malware sample       │   │
  │  │  3. Monitor with tools:      │   │
  │  │     - Process Monitor        │   │
  │  │     - Wireshark              │   │
  │  │     - RegShot (registry)     │   │
  │  │  4. Analyze behavior         │   │
  │  │  5. Revert to snapshot       │   │
  │  └──────────────────────────────┘   │
  └─────────────────────────────────────┘

*Or use INetSim to simulate internet services
```

### Indicators of Compromise (IOC)

```
What to look for:
  → Suspicious IP addresses / domains
  → Unusual file hashes
  → Registry modifications
  → Scheduled tasks / startup entries
  → Unusual processes or services
  → Network connections to C2 (Command & Control) servers
  → Modified system files
```

---

## 17.3 Zero-Day Vulnerabilities

### Definition
A **zero-day** is a vulnerability unknown to the vendor — there are "zero days" of available patches.

### Lifecycle

```
1. Discovery     → Researcher or attacker finds vulnerability
2. Exploit Dev   → Working exploit code is created
3. Attack/Report → Used in attacks OR reported to vendor
4. Vendor Aware  → Vendor begins working on patch
5. Patch Release → Fix available
6. Deployment    → Users apply the patch

Timeline risk:
  Discovery ─────────── Patch Release
       └─── DANGER ZONE (no fix available) ───┘
```

### Famous Zero-Days

| Name | Year | Target | Impact |
|------|------|--------|--------|
| **Stuxnet** | 2010 | Iran nuclear facilities | Destroyed centrifuges using 4 zero-days |
| **EternalBlue** | 2017 | Windows SMB | Led to WannaCry ransomware pandemic |
| **Log4Shell** | 2021 | Log4j (Java logging) | RCE in millions of applications |
| **Spring4Shell** | 2022 | Spring Framework | RCE in Java web applications |
| **MOVEit** | 2023 | MOVEit file transfer | Mass data theft by Cl0p group |

---

## 17.4 Security Architecture & Design

### Defense in Depth

```
Layer 1: PHYSICAL     → Locked doors, CCTV, biometrics
Layer 2: PERIMETER    → Firewalls, DMZ, IPS
Layer 3: NETWORK      → Segmentation, VLANs, NAC
Layer 4: HOST         → OS hardening, AV/EDR, patching
Layer 5: APPLICATION  → Secure coding, WAF, input validation
Layer 6: DATA         → Encryption, DLP, access controls
Layer 7: PEOPLE       → Security awareness training, policies

Each layer compensates if another fails.
```

### Security Design Principles

| Principle | Meaning | Example |
|-----------|---------|---------|
| **Least Privilege** | Minimum access needed | Web app DB user has only SELECT |
| **Defense in Depth** | Multiple security layers | Firewall + IDS + WAF + EDR |
| **Fail Secure** | System fails to secure state | Firewall crash → blocks all traffic |
| **Separation of Duties** | No single person has all access | One person approves, another deploys |
| **Open Design** | Security shouldn't rely on secrecy | AES algorithm is public, still secure |
| **Complete Mediation** | Check every access request | Zero Trust model |
| **Economy of Mechanism** | Keep security simple | Simple firewall rules over complex ones |

---

## 17.5 Threat Intelligence

### Definition
**Threat Intelligence** (TI) is evidence-based knowledge about existing or emerging threats that helps organizations make informed security decisions.

### Types

| Type | Audience | Content | Example |
|------|----------|---------|---------|
| **Strategic** | Executives | High-level trends, risks | "Ransomware attacks increased 150%" |
| **Tactical** | Security team | TTPs (Tactics, Techniques, Procedures) | MITRE ATT&CK mappings |
| **Operational** | SOC analysts | Specific campaign details | "APT29 targeting healthcare via phishing" |
| **Technical** | Security tools | IOCs | IP addresses, file hashes, domains |

### MITRE ATT&CK Framework

```
A knowledge base of adversary tactics and techniques based on real-world observations.

Tactics (the WHY — attacker goals):
  1. Reconnaissance        → Gather information
  2. Resource Development  → Set up infrastructure
  3. Initial Access        → Get into the network
  4. Execution             → Run malicious code
  5. Persistence           → Maintain access
  6. Privilege Escalation  → Get higher permissions
  7. Defense Evasion       → Avoid detection
  8. Credential Access     → Steal credentials
  9. Discovery             → Learn about the environment
  10. Lateral Movement     → Move through network
  11. Collection           → Gather target data
  12. C2 (Command & Control) → Communicate with implants
  13. Exfiltration         → Steal data
  14. Impact               → Disrupt/destroy
```

---

## 17.6 Incident Response

### NIST Incident Response Process

```
┌───────────────────────────────────────────────────────┐
│ 1. PREPARATION                                         │
│    → IR plan, team roles, tools ready, playbooks       │
├───────────────────────────────────────────────────────┤
│ 2. DETECTION & ANALYSIS                                │
│    → Identify incident, determine scope and severity   │
├───────────────────────────────────────────────────────┤
│ 3. CONTAINMENT                                         │
│    → Short-term: isolate affected systems              │
│    → Long-term: apply temporary fixes                  │
├───────────────────────────────────────────────────────┤
│ 4. ERADICATION                                         │
│    → Remove malware, close vulnerabilities              │
│    → Reset compromised credentials                     │
├───────────────────────────────────────────────────────┤
│ 5. RECOVERY                                            │
│    → Restore systems from clean backups                │
│    → Monitor for re-infection                          │
├───────────────────────────────────────────────────────┤
│ 6. LESSONS LEARNED                                     │
│    → What happened, what worked, what to improve       │
│    → Update IR plan and security controls              │
└───────────────────────────────────────────────────────┘
```

---

## 17.7 Red Team vs Blue Team vs Purple Team

| Team | Role | Activities |
|------|------|-----------|
| **Red Team** | Offense (attackers) | Penetration testing, social engineering, physical security testing |
| **Blue Team** | Defense (defenders) | Monitoring, incident response, hardening, threat hunting |
| **Purple Team** | Collaboration | Red + Blue work together to improve both attack and defense |

```
Red Team:  "We got in through a phishing email and escalated to domain admin"
Blue Team: "We detected the phishing, but missed the lateral movement"
Purple:    "Let's improve detection for lateral movement techniques"
```

---

## 17.8 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is the MITRE ATT&CK framework?**
> A globally accessible knowledge base of adversary tactics and techniques based on real-world observations. It maps the lifecycle of an attack from initial access to impact, helping defenders understand and detect threats.

**Q: What is the difference between static and dynamic malware analysis?**
> Static analysis examines malware without running it (file hashes, strings, imports). Dynamic analysis runs malware in a sandbox and observes its behavior (network connections, file changes, processes created).

**Q: What is incident response?**
> A structured approach to handling security breaches: Preparation → Detection → Containment → Eradication → Recovery → Lessons Learned (NIST framework).

---

## 17.9 Practice & Assessment

### MCQs

**Q1.** A zero-day vulnerability is:
- A) A vulnerability that's been patched
- B) A vulnerability unknown to the vendor with no patch available
- C) A vulnerability that only lasts one day
- D) A low-severity vulnerability

**Answer:** B) Unknown to vendor, no patch available.

---

**Q2.** Ghidra is:
- A) A network scanner
- B) A reverse engineering tool by NSA
- C) A password cracking tool
- D) A web application firewall

**Answer:** B) A reverse engineering tool by NSA.

---

**Q3.** The NIST incident response process starts with:
- A) Containment
- B) Detection
- C) Preparation
- D) Recovery

**Answer:** C) Preparation

---

**Q4.** Purple team is:
- A) A new type of hacker
- B) Collaboration between red and blue teams
- C) Government security team
- D) Malware analysis team

**Answer:** B) Collaboration between red and blue teams

---

> **Next Topic:** [18 - Cybersecurity Cheat Sheet](18-cybersecurity-cheat-sheet.md)
