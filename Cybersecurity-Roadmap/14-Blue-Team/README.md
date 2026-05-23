# 🛡️ Blue Team — Defense & Detection

## SOC Operations, Threat Hunting, and Incident Response

---

## Overview

Blue Team is the defensive side of cybersecurity — detecting attacks, responding to incidents, hunting for threats, and building detection capabilities.

---

## SOC (Security Operations Center)

### SOC Analyst Tiers

| Tier | Role | Responsibilities |
|------|------|-----------------|
| Tier 1 | Alert Triage | Monitor SIEM, initial investigation, escalate |
| Tier 2 | Incident Response | Deep investigation, containment, remediation |
| Tier 3 | Threat Hunting | Proactive hunting, detection engineering, research |
| SOC Lead | Management | Strategy, process improvement, team coordination |

---

## SIEM (Security Information and Event Management)

### What SIEM Does

```
┌─────────────────────────────────────────────────┐
│              DATA SOURCES                         │
│  Firewalls, IDS, Endpoints, Servers, Cloud       │
└──────────────────────┬──────────────────────────┘
                       │ Logs/Events
                       ▼
┌─────────────────────────────────────────────────┐
│                 SIEM PLATFORM                     │
│  ┌──────────┬──────────┬─────────────────────┐  │
│  │ Collect  │ Normalize│ Correlate           │  │
│  │ & Parse  │ & Store  │ & Alert             │  │
│  └──────────┴──────────┴─────────────────────┘  │
└──────────────────────┬──────────────────────────┘
                       │ Alerts
                       ▼
┌─────────────────────────────────────────────────┐
│              SOC ANALYSTS                         │
│  Investigate → Triage → Respond → Remediate      │
└─────────────────────────────────────────────────┘
```

### Popular SIEM Platforms

| Platform | Type | Best For |
|----------|------|----------|
| Splunk | Commercial | Enterprise, powerful SPL |
| ELK Stack | Open Source | Cost-effective, customizable |
| Microsoft Sentinel | Cloud | Azure environments |
| Wazuh | Open Source | Endpoint + SIEM |
| QRadar | Commercial | Large enterprises |

### Splunk Queries (SPL)

```spl
# Search for failed logins
index=windows EventCode=4625
| stats count by src_ip, Account_Name
| sort -count

# Detect brute force (>10 failures in 5 min)
index=windows EventCode=4625
| bin _time span=5m
| stats count by src_ip, _time
| where count > 10

# PowerShell execution monitoring
index=windows EventCode=4104
| search ScriptBlockText="*Invoke-Mimikatz*" OR ScriptBlockText="*IEX*"

# Detect lateral movement (PsExec)
index=windows EventCode=7045 Service_Name="PSEXESVC"
```

---

## Threat Hunting

### Hunting Hypothesis Examples

| Hypothesis | Data Source | What to Look For |
|-----------|-------------|------------------|
| Attackers using PowerShell for recon | Windows Event 4104 | Encoded commands, unusual scripts |
| Data exfiltration via DNS | DNS logs | Unusually long queries, high volume |
| Persistence via scheduled tasks | Windows Event 4698 | New tasks running scripts |
| Lateral movement via RDP | Event 4624 (Type 10) | Unusual source IPs, off-hours |

### MITRE ATT&CK for Hunting

```
For each technique, ask:
1. What data sources show this activity?
2. What does normal look like?
3. What would abnormal look like?
4. How can I detect it?
5. How can I validate the detection?
```

---

## Incident Response

### IR Process (NIST)

```
1. PREPARATION
   - IR plan, team, tools, playbooks
   
2. DETECTION & ANALYSIS
   - Identify the incident
   - Determine scope and impact
   - Collect evidence
   
3. CONTAINMENT
   - Short-term: Isolate affected systems
   - Long-term: Apply fixes while maintaining evidence
   
4. ERADICATION
   - Remove the threat
   - Patch vulnerabilities
   - Remove malware/backdoors
   
5. RECOVERY
   - Restore systems from clean backups
   - Monitor for re-infection
   - Return to normal operations
   
6. LESSONS LEARNED
   - Post-incident review
   - Update procedures
   - Improve defenses
```

### Key Windows Event IDs for Detection

| Event ID | Description | Security Relevance |
|----------|-------------|-------------------|
| 4624 | Successful logon | Track who logged in |
| 4625 | Failed logon | Brute force detection |
| 4648 | Explicit credential logon | Lateral movement |
| 4672 | Special privileges assigned | Admin logon |
| 4698 | Scheduled task created | Persistence |
| 4720 | User account created | Unauthorized accounts |
| 4732 | Member added to group | Privilege escalation |
| 7045 | Service installed | Persistence/lateral movement |
| 4104 | PowerShell script block | Script execution |
| 1102 | Audit log cleared | Covering tracks |

---

## Log Analysis

### Linux Log Investigation

```bash
# Failed SSH attempts
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn

# Successful logins
grep "Accepted" /var/log/auth.log

# Sudo usage
grep "sudo:" /var/log/auth.log | grep "COMMAND"

# Web server attacks
grep -E "(union|select|script|\.\.\/)" /var/log/apache2/access.log

# Cron job execution
grep "CRON" /var/log/syslog
```

---

## Detection Engineering

### Sigma Rules (Universal Detection Format)

```yaml
title: Suspicious PowerShell Download
status: experimental
description: Detects PowerShell downloading content from the internet
logsource:
    category: process_creation
    product: windows
detection:
    selection:
        CommandLine|contains|all:
            - 'powershell'
            - 'downloadstring'
    condition: selection
level: high
tags:
    - attack.execution
    - attack.t1059.001
```

---

## Blue Team Tools

| Tool | Purpose |
|------|---------|
| Splunk/ELK | SIEM - log aggregation and search |
| Wazuh | Host-based IDS + SIEM |
| Suricata/Snort | Network IDS/IPS |
| YARA | Malware detection rules |
| Sigma | Universal detection rules |
| Volatility | Memory forensics |
| Velociraptor | Endpoint visibility and hunting |
| TheHive | Incident response platform |
| MISP | Threat intelligence sharing |

---

## Exercises

1. Set up ELK Stack and ingest Windows event logs
2. Write 5 Sigma detection rules for common attacks
3. Perform threat hunting using MITRE ATT&CK as a guide
4. Investigate a simulated incident from start to finish
5. Create an incident response playbook for ransomware

---

## Practice Platforms

| Platform | Focus |
|----------|-------|
| LetsDefend | SOC Analyst simulation |
| CyberDefenders | Blue team challenges |
| Blue Team Labs Online | Investigations |
| Splunk BOTS | Splunk-based investigations |
| Security Blue Team | Certification and training |

---

**Next:** → [15-Red-Team](../15-Red-Team/README.md)

*"The best defense is understanding the offense."*
