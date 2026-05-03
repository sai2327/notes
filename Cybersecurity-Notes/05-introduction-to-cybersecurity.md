# 05. Introduction to Cybersecurity

## Table of Contents
- [5.1 What is Cybersecurity?](#51-what-is-cybersecurity)
- [5.2 Why Cybersecurity Matters](#52-why-cybersecurity-matters)
- [5.3 Types of Hackers](#53-types-of-hackers)
- [5.4 Cyber Threats Overview](#54-cyber-threats-overview)
- [5.5 Security Domains](#55-security-domains)
- [5.6 Career Paths & Certifications](#56-career-paths--certifications)
- [5.7 Common Mistakes & Interview Tips](#57-common-mistakes--interview-tips)
- [5.8 Practice & Assessment](#58-practice--assessment)

---

## 5.1 What is Cybersecurity?

### Definition
**Cybersecurity** is the practice of protecting computers, servers, networks, mobile devices, and data from malicious attacks, unauthorized access, and damage.

Think of it like this: just as you lock your house, install cameras, and have an alarm system — cybersecurity does the same for the digital world.

### Key Components

```
┌──────────────────────────────────────────────────────────┐
│                    CYBERSECURITY                          │
├──────────────┬──────────────┬──────────────┬─────────────┤
│   Network    │ Application  │    Data      │  Endpoint   │
│  Security    │  Security    │  Security    │  Security   │
├──────────────┼──────────────┼──────────────┼─────────────┤
│ Firewalls    │ Secure code  │ Encryption   │ Antivirus   │
│ IDS/IPS      │ Web app      │ Access       │ Device      │
│ VPN          │ testing      │ controls     │ management  │
└──────────────┴──────────────┴──────────────┴─────────────┘
```

### Real-World Importance

| Year | Incident | Impact |
|------|----------|--------|
| 2017 | WannaCry Ransomware | 200,000+ computers in 150 countries |
| 2020 | SolarWinds Hack | US government agencies compromised |
| 2021 | Colonial Pipeline | Major US fuel pipeline shut down |
| 2023 | MOVEit Breach | 2,000+ organizations, 60M+ people affected |

---

## 5.2 Why Cybersecurity Matters

### For Individuals
- **Identity theft** — Stolen personal data used for fraud
- **Financial loss** — Bank accounts drained, credit card fraud
- **Privacy** — Personal photos, messages, medical records exposed
- **Reputation** — Social media accounts hijacked

### For Organizations
- **Financial damage** — Average data breach costs $4.45 million (IBM 2023)
- **Legal consequences** — Fines under GDPR, HIPAA, PCI-DSS
- **Reputation loss** — Customer trust destroyed
- **Operational disruption** — Ransomware can halt business for weeks

### For Nations
- **Critical infrastructure** — Power grids, water supply, hospitals
- **National security** — Military secrets, intelligence
- **Cyber warfare** — State-sponsored attacks between countries

---

## 5.3 Types of Hackers

### Hacker Classification

| Type | Also Called | Intent | Legal? | Example |
|------|-----------|--------|--------|---------|
| **White Hat** | Ethical Hacker | Protect systems, find vulnerabilities | ✅ Yes (with permission) | Penetration tester hired by a company |
| **Black Hat** | Cracker | Steal data, cause damage, profit | ❌ No (criminal) | Ransomware attacker |
| **Grey Hat** | — | Finds vulnerabilities without permission, may report | ⚠️ Borderline | Finds a bug in a website, reports it but didn't have authorization |
| **Script Kiddie** | — | Uses others' tools without understanding | ❌ Usually no | Downloads a DDoS tool and attacks a gaming server |
| **Hacktivist** | — | Hacking for political/social causes | ❌ No | Anonymous group targeting governments |
| **State-Sponsored** | APT (Advanced Persistent Threat) | Government-backed cyber operations | ❌ Illegal internationally | APT28 (Russia), APT41 (China) |
| **Insider Threat** | — | Employee with malicious intent | ❌ No | Disgruntled employee stealing company data |

### Ethical Hacker vs Malicious Hacker

```
                    ┌─────────────────────┐
                    │   Same Skills,      │
                    │   Different Intent   │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              ▼                                  ▼
    ┌──────────────────┐              ┌──────────────────┐
    │   WHITE HAT       │              │   BLACK HAT       │
    │ ✅ Has permission  │              │ ❌ No permission   │
    │ ✅ Reports bugs    │              │ ❌ Exploits bugs   │
    │ ✅ Fixes issues    │              │ ❌ Steals data     │
    │ ✅ Gets paid       │              │ ❌ Gets arrested   │
    │    legally         │              │                    │
    └──────────────────┘              └──────────────────┘
```

---

## 5.4 Cyber Threats Overview

### Threat Categories

| Category | Description | Examples |
|----------|-------------|---------|
| **Malware** | Malicious software | Virus, worm, trojan, ransomware |
| **Social Engineering** | Manipulating people | Phishing, pretexting, baiting |
| **Network Attacks** | Exploiting network weaknesses | MITM, DDoS, ARP spoofing |
| **Web Attacks** | Targeting web applications | SQLi, XSS, CSRF |
| **Password Attacks** | Cracking/stealing credentials | Brute force, credential stuffing |
| **Insider Threats** | Threats from within organization | Data theft by employees |
| **Physical Attacks** | Physical access exploitation | USB drops, shoulder surfing |

### Attack Motivation

```
┌────────────────────────────────────────┐
│           WHY DO ATTACKERS HACK?        │
├──────────────┬─────────────────────────┤
│ 💰 Financial  │ Ransomware, fraud       │
│ 🕵️ Espionage  │ State secrets, IP theft │
│ 📢 Activism   │ Political statements    │
│ 😈 Fun/Ego    │ "Because I can"         │
│ 💣 Destruction│ Wipe data, disrupt      │
│ 🎯 Revenge    │ Disgruntled insider     │
└──────────────┴─────────────────────────┘
```

---

## 5.5 Security Domains

### The 8 Domains of Cybersecurity (CISSP Framework)

| Domain | Focus |
|--------|-------|
| Security & Risk Management | Policies, governance, compliance |
| Asset Security | Data classification, handling |
| Security Architecture | Designing secure systems |
| Communication & Network Security | Securing network traffic |
| Identity & Access Management | Authentication, authorization |
| Security Assessment & Testing | Vulnerability assessment, audits |
| Security Operations | Monitoring, incident response |
| Software Development Security | Secure coding practices |

### The CIA Triad (Foundation of Everything)

```
           Confidentiality
          "Keep secrets safe"
                 ▲
                / \
               / C \
              /  I  \
             /  A    \
            /          \
  Integrity ◄──────────► Availability
 "Data is accurate"    "Systems are up"
```

Every security control maps back to protecting one or more of these.

---

## 5.6 Career Paths & Certifications

### Career Roadmap

```
ENTRY LEVEL                    MID LEVEL                   SENIOR LEVEL
─────────────                  ─────────                   ────────────
SOC Analyst (L1)          →    SOC Analyst (L2/L3)    →    SOC Manager
Security Analyst          →    Penetration Tester     →    Red Team Lead
IT Support + Security     →    Incident Responder     →    CISO
Help Desk                 →    Security Engineer      →    Security Architect
                          →    Threat Hunter          →    Principal Engineer
```

### Key Certifications

| Certification | Level | Focus | Cost (~) |
|--------------|-------|-------|----------|
| CompTIA Security+ | Beginner | Broad security foundation | $390 |
| CEH (EC-Council) | Intermediate | Ethical hacking | $1,199 |
| CompTIA CySA+ | Intermediate | Security analytics | $390 |
| OSCP (OffSec) | Advanced | Hands-on penetration testing | $1,599 |
| CISSP (ISC²) | Expert | Security management | $749 |
| GIAC (SANS) | Various | Specialized areas | $2,000+ |

---

## 5.7 Common Mistakes & Interview Tips

### Common Beginner Mistakes

| Mistake | Why It's Wrong | Fix |
|---------|---------------|-----|
| Hacking without permission | It's illegal, even "for fun" | Use labs: TryHackMe, HackTheBox |
| Skipping networking basics | Can't hack what you don't understand | Learn OSI, TCP/IP first |
| Only learning tools, not concepts | Tools change; concepts don't | Understand the "why" before the "how" |
| No documentation | Can't remember or prove your work | Always take notes and screenshots |
| Ignoring defense | Offense is fun but defense pays | Learn blue team alongside red team |

### Interview Questions & Answers

**Q: What is cybersecurity?**
> Cybersecurity is the practice of protecting systems, networks, and data from digital attacks. It involves technologies, processes, and people working together to safeguard digital assets.

**Q: What is the difference between a vulnerability, a threat, and a risk?**
> - **Vulnerability**: A weakness in a system (e.g., unpatched software)
> - **Threat**: Something that can exploit a vulnerability (e.g., a hacker)
> - **Risk**: The potential for loss when a threat exploits a vulnerability (e.g., data breach)

**Q: What is the CIA Triad?**
> The three core goals of security: **Confidentiality** (only authorized access), **Integrity** (data is accurate and unaltered), **Availability** (systems are accessible when needed).

**Q: What is the difference between IDS and IPS?**
> **IDS** (Intrusion Detection System) monitors and alerts on suspicious activity. **IPS** (Intrusion Prevention System) monitors AND actively blocks threats. IDS is passive; IPS is active.

---

## 5.8 Practice & Assessment

### MCQs

**Q1.** A hacker who finds a vulnerability without permission and reports it is called:
- A) White hat
- B) Black hat
- C) Grey hat
- D) Script kiddie

**Answer:** C) Grey hat

---

**Q2.** The CIA Triad stands for:
- A) Central Intelligence Agency
- B) Confidentiality, Integrity, Availability
- C) Cryptography, Identity, Access
- D) Control, Inspection, Authentication

**Answer:** B) Confidentiality, Integrity, Availability

---

**Q3.** Which certification is considered the best entry-level cybersecurity cert?
- A) OSCP
- B) CISSP
- C) CompTIA Security+
- D) CEH

**Answer:** C) CompTIA Security+

---

**Q4.** WannaCry was a type of:
- A) Phishing attack
- B) Ransomware
- C) DDoS attack
- D) SQL injection

**Answer:** B) Ransomware

---

**Q5.** An employee who steals company data is classified as:
- A) Script kiddie
- B) Hacktivist
- C) Insider threat
- D) State-sponsored hacker

**Answer:** C) Insider threat

---

### Scenario-Based Questions

**Scenario 1:** A company discovers that 10,000 customer credit card numbers have been leaked online. Which aspect of CIA was violated?
> **Answer:** Confidentiality — unauthorized parties gained access to sensitive data.

**Scenario 2:** A hospital's electronic health records system goes down for 8 hours due to a DDoS attack. Patients can't be treated properly. Which CIA component is affected?
> **Answer:** Availability — the system was not accessible when needed.

**Scenario 3:** An attacker modifies a bank transaction from $100 to $10,000 during transfer. Which CIA component is violated?
> **Answer:** Integrity — the data was altered without authorization.

---

> **Next Topic:** [06 - Cyber Threats & Attacks](06-cyber-threats-attacks.md)
