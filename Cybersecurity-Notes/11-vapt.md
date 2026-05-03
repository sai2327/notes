# 11. Vulnerability Assessment & Penetration Testing (VAPT)

## Table of Contents
- [11.1 What is VAPT?](#111-what-is-vapt)
- [11.2 Vulnerability Assessment](#112-vulnerability-assessment)
- [11.3 Penetration Testing](#113-penetration-testing)
- [11.4 VAPT Methodology](#114-vapt-methodology)
- [11.5 Tools & Frameworks](#115-tools--frameworks)
- [11.6 Common Mistakes & Interview Tips](#116-common-mistakes--interview-tips)
- [11.7 Practice & Assessment](#117-practice--assessment)

---

## 11.1 What is VAPT?

**VAPT** = **Vulnerability Assessment** + **Penetration Testing**

| Aspect | Vulnerability Assessment (VA) | Penetration Testing (PT) |
|--------|------------------------------|--------------------------|
| Goal | Find and list vulnerabilities | Exploit vulnerabilities to prove impact |
| Depth | Broad (wide coverage) | Deep (focused exploitation) |
| Approach | Automated + manual scanning | Manual + automated exploitation |
| Output | List of vulnerabilities with severity | Proof of exploitation + business impact |
| Analogy | Doctor doing a full body checkup | Doctor performing surgery on found issue |
| Risk | Low (non-intrusive) | Medium-High (may cause disruption) |

```
VA: "You have a weak lock on your front door" (identifies the problem)
PT: "I picked the lock and walked in" (proves the problem is real)
```

---

## 11.2 Vulnerability Assessment

### Process

```
1. SCOPE DEFINITION → What systems to scan?
2. DISCOVERY → Find live hosts, services, applications
3. SCANNING → Run vulnerability scanners
4. ANALYSIS → Review results, eliminate false positives
5. REPORTING → Document findings with severity ratings
6. REMEDIATION → Fix vulnerabilities
7. RESCAN → Verify fixes
```

### Severity Ratings (CVSS)

**CVSS** (Common Vulnerability Scoring System) — industry standard for rating vulnerabilities.

| Score | Severity | Action | Example |
|-------|----------|--------|---------|
| 9.0 – 10.0 | Critical | Fix immediately | Remote Code Execution, no auth needed |
| 7.0 – 8.9 | High | Fix within days | SQL Injection, privilege escalation |
| 4.0 – 6.9 | Medium | Fix within weeks | XSS, information disclosure |
| 0.1 – 3.9 | Low | Fix when convenient | Missing headers, verbose errors |
| 0.0 | Informational | Awareness only | Software version disclosure |

### Vulnerability Scanning Tools

```bash
# Nmap with vulnerability scripts
nmap --script vuln 192.168.1.0/24

# OpenVAS (open-source vulnerability scanner)
# GUI-based — access at https://localhost:9392

# Nessus (commercial, free for home)
# Download from tenable.com

# Nikto (web server scanner)
nikto -h http://target.com

# WPScan (WordPress vulnerability scanner)
wpscan --url http://wordpress-site.com --enumerate vp,u
```

---

## 11.3 Penetration Testing

### Types

| Type | Description | Test Scope |
|------|-------------|-----------|
| **Network Pentest** | Test internal/external network | Firewalls, routers, servers |
| **Web App Pentest** | Test web applications | OWASP Top 10 vulnerabilities |
| **Wireless Pentest** | Test Wi-Fi security | WPA2 cracking, rogue APs |
| **Social Engineering** | Test human factor | Phishing campaigns, physical access |
| **Mobile App Pentest** | Test mobile applications | API security, data storage |
| **Cloud Pentest** | Test cloud configurations | AWS/Azure/GCP misconfigs |

### Standards

| Standard | Description |
|----------|-------------|
| **OWASP Testing Guide** | Web application testing methodology |
| **PTES** (Penetration Testing Execution Standard) | General pentest methodology |
| **OSSTMM** (Open Source Security Testing Methodology Manual) | Comprehensive security testing |
| **NIST SP 800-115** | US government technical guide |

---

## 11.4 VAPT Methodology

### Step-by-Step

```
┌─────────────────────────────────────────────────────────┐
│ 1. PRE-ENGAGEMENT                                        │
│    → Scope, rules of engagement, legal authorization     │
├─────────────────────────────────────────────────────────┤
│ 2. INFORMATION GATHERING                                 │
│    → OSINT, DNS, WHOIS, technology stack                 │
├─────────────────────────────────────────────────────────┤
│ 3. VULNERABILITY SCANNING                                │
│    → Nessus, OpenVAS, Nmap scripts, Nikto               │
├─────────────────────────────────────────────────────────┤
│ 4. EXPLOITATION                                          │
│    → Metasploit, SQLMap, manual testing                  │
├─────────────────────────────────────────────────────────┤
│ 5. POST-EXPLOITATION                                     │
│    → Privilege escalation, lateral movement, data access │
├─────────────────────────────────────────────────────────┤
│ 6. REPORTING                                             │
│    → Executive summary, technical details, remediation   │
├─────────────────────────────────────────────────────────┤
│ 7. REMEDIATION VERIFICATION                              │
│    → Rescan/retest to confirm fixes                      │
└─────────────────────────────────────────────────────────┘
```

---

## 11.5 Tools & Frameworks

| Phase | Tools |
|-------|-------|
| Recon | Nmap, theHarvester, Shodan, Maltego, subfinder |
| Scanning | Nessus, OpenVAS, Nikto, WPScan |
| Exploitation | Metasploit, SQLMap, Burp Suite, Hydra |
| Post-Exploit | Mimikatz, BloodHound, LinPEAS, WinPEAS |
| Reporting | Dradis, Serpico, custom templates |

---

## 11.6 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is the difference between VA and PT?**
> VA identifies and lists vulnerabilities (scanning). PT actually exploits them to demonstrate real-world impact. VA is broad; PT is deep.

**Q: What is CVSS?**
> Common Vulnerability Scoring System — a standardized way to rate vulnerability severity from 0.0 to 10.0, considering exploitability, impact, and environmental factors.

**Q: What framework do you follow for web app testing?**
> OWASP Testing Guide — it provides a comprehensive methodology for testing each of the OWASP Top 10 vulnerabilities plus additional categories.

---

## 11.7 Practice & Assessment

### MCQs

**Q1.** A CVSS score of 9.5 is classified as:
- A) Low
- B) Medium
- C) High
- D) Critical

**Answer:** D) Critical

---

**Q2.** The main difference between VA and PT is:
- A) VA is free, PT is paid
- B) VA identifies vulnerabilities, PT exploits them
- C) VA is manual, PT is automated
- D) VA is for networks only

**Answer:** B) VA identifies, PT exploits

---

> **Next Topic:** [12 - System Security](12-system-security.md)
