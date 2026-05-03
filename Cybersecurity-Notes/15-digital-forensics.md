# 15. Digital Forensics

## Table of Contents
- [15.1 What is Digital Forensics?](#151-what-is-digital-forensics)
- [15.2 Types of Digital Forensics](#152-types-of-digital-forensics)
- [15.3 Forensic Process](#153-forensic-process)
- [15.4 Evidence Collection & Handling](#154-evidence-collection--handling)
- [15.5 Forensic Tools & Commands](#155-forensic-tools--commands)
- [15.6 Log Analysis](#156-log-analysis)
- [15.7 Common Mistakes & Interview Tips](#157-common-mistakes--interview-tips)
- [15.8 Practice & Assessment](#158-practice--assessment)

---

## 15.1 What is Digital Forensics?

**Digital Forensics** is the process of collecting, preserving, analyzing, and presenting digital evidence in a way that is legally admissible.

### Why It Matters

```
When a cyber attack happens → you need to answer:
  1. WHAT happened?         → What systems were affected?
  2. WHEN did it happen?    → Timeline of events
  3. WHO did it?            → Attacker identification
  4. HOW did they get in?   → Attack vector
  5. WHAT was taken/damaged? → Impact assessment
  6. Can we PROVE it?       → Legal evidence
```

---

## 15.2 Types of Digital Forensics

| Type | What Is Examined | Example Use Case |
|------|-----------------|-----------------|
| **Computer Forensics** | Hard drives, files, OS artifacts | Recovering deleted files |
| **Network Forensics** | Network traffic, logs, packets | Tracing data exfiltration |
| **Mobile Forensics** | Phones, tablets, apps | Extracting messages, call logs |
| **Memory Forensics** | RAM contents | Finding running malware |
| **Email Forensics** | Email headers, attachments | Tracing phishing source |
| **Database Forensics** | DB logs, transactions | Detecting data theft |
| **Cloud Forensics** | Cloud logs, VMs, storage | Investigating cloud breaches |

---

## 15.3 Forensic Process

```
┌──────────────────────────────────────────────────────┐
│ 1. IDENTIFICATION                                     │
│    → Recognize that an incident occurred               │
│    → Identify relevant devices and data sources        │
├──────────────────────────────────────────────────────┤
│ 2. PRESERVATION                                       │
│    → Secure the scene (don't touch original evidence) │
│    → Create forensic images (bit-by-bit copies)       │
│    → Document chain of custody                         │
├──────────────────────────────────────────────────────┤
│ 3. COLLECTION                                         │
│    → Acquire evidence using forensic tools             │
│    → Capture volatile data first (RAM → Disk)          │
│    → Hash everything (integrity verification)          │
├──────────────────────────────────────────────────────┤
│ 4. EXAMINATION                                        │
│    → Analyze forensic images (not originals!)          │
│    → Recover deleted files, hidden data                │
│    → Build timeline of events                          │
├──────────────────────────────────────────────────────┤
│ 5. ANALYSIS                                           │
│    → Correlate findings across sources                 │
│    → Identify attack vector and scope                  │
│    → Determine attribution if possible                 │
├──────────────────────────────────────────────────────┤
│ 6. REPORTING                                          │
│    → Document findings clearly                         │
│    → Include methodology and tools used                │
│    → Present in legally admissible format               │
└──────────────────────────────────────────────────────┘
```

### Order of Volatility

Collect the most volatile data first — it disappears fastest.

```
Most volatile (collect FIRST):
  1. CPU registers, cache
  2. RAM (running processes, network connections)
  3. Network state (routing tables, ARP cache)
  4. Running processes
  5. Disk (temporary files, swap space)
  6. Disk (file system data)
  7. Remote logging and monitoring data
  8. Physical configuration, network topology
  9. Archival media (backups, printouts)
Least volatile (collect LAST)
```

---

## 15.4 Evidence Collection & Handling

### Chain of Custody

Every piece of evidence must have a documented chain:
```
WHO collected it → WHEN → WHERE → HOW → WHO had access → WHERE is it stored

If chain of custody is broken → evidence may be thrown out in court
```

### Forensic Imaging

```bash
# Create forensic disk image using dd
sudo dd if=/dev/sda of=/forensics/evidence.img bs=4M status=progress

# Create image with dcfldd (forensic version of dd — includes hashing)
sudo dcfldd if=/dev/sda of=/forensics/evidence.img hash=md5,sha256 \
  hashlog=/forensics/evidence.hash

# Create image with Guymager (GUI tool in Linux)
# Start Guymager → Right-click drive → "Acquire Image"

# Verify image integrity
md5sum /forensics/evidence.img
sha256sum /forensics/evidence.img
# Compare with hash taken at collection time — MUST MATCH
```

---

## 15.5 Forensic Tools & Commands

### Tool Overview

| Tool | Purpose | Platform |
|------|---------|----------|
| **Autopsy** | GUI forensic analysis platform | Windows/Linux |
| **Sleuth Kit** | Command-line forensic tools | Linux |
| **Volatility** | Memory forensics | Cross-platform |
| **FTK Imager** | Forensic imaging | Windows |
| **Wireshark** | Network forensics | Cross-platform |
| **ExifTool** | Metadata extraction from files | Cross-platform |

### Linux Forensic Commands

```bash
# ═══════════════════════════════════════
# FILE ANALYSIS
# ═══════════════════════════════════════
# Determine file type (don't trust extensions!)
file suspicious_document.pdf
# Output: suspicious_document.pdf: PE32 executable ← It's actually malware!

# Calculate file hash
md5sum malware_sample
sha256sum malware_sample

# View file metadata
exiftool document.pdf
exiftool image.jpg              # GPS location, camera, timestamps

# Find recently modified files
find / -mtime -1 -type f        # Modified in last 24 hours
find / -ctime -1 -type f        # Changed in last 24 hours

# Search for hidden files
find / -name ".*" -type f       # Files starting with dot

# ═══════════════════════════════════════
# MEMORY FORENSICS (Volatility)
# ═══════════════════════════════════════
# List processes from memory dump
volatility -f memory.dmp --profile=Win10x64 pslist

# List network connections
volatility -f memory.dmp --profile=Win10x64 netscan

# Dump suspicious process
volatility -f memory.dmp --profile=Win10x64 procdump -p 1234 -D output/

# Find command history
volatility -f memory.dmp --profile=Win10x64 cmdscan

# ═══════════════════════════════════════
# DISK FORENSICS
# ═══════════════════════════════════════
# List deleted files (Sleuth Kit)
fls -r -d evidence.img

# Recover deleted file by inode
icat evidence.img 12345 > recovered_file.txt

# File system timeline
fls -r -m "/" evidence.img > timeline.body
mactime -b timeline.body > timeline.csv
```

---

## 15.6 Log Analysis

### Important Log Locations

| OS | Log File | Contents |
|----|----------|----------|
| Linux | `/var/log/auth.log` | Authentication events (login, sudo) |
| Linux | `/var/log/syslog` | System events |
| Linux | `/var/log/apache2/access.log` | Web server access |
| Linux | `/var/log/kern.log` | Kernel messages |
| Windows | Security Event Log | Login, policy changes |
| Windows | System Event Log | System errors, services |
| Windows | Application Event Log | Application errors |

### Log Analysis Commands

```bash
# Failed SSH login attempts
grep "Failed password" /var/log/auth.log | tail -20

# Count failed logins per IP
grep "Failed password" /var/log/auth.log | \
  awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10

# Successful logins
grep "Accepted" /var/log/auth.log

# Web server — most accessed URLs
awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head -10

# Web server — potential SQL injection attempts
grep -i "union\|select\|drop\|insert\|delete\|update\|exec\|--" \
  /var/log/apache2/access.log

# Check for suspicious cron jobs
cat /etc/crontab
ls -la /etc/cron.d/
crontab -l
```

---

## 15.7 Common Mistakes & Interview Tips

### Common Forensics Mistakes

| Mistake | Why It's Bad |
|---------|-------------|
| Analyzing original evidence directly | Modifies timestamps, corrupts evidence |
| Not documenting chain of custody | Evidence inadmissible in court |
| Collecting disk before RAM | Volatile data lost when system powers off |
| Forgetting to hash evidence | Can't prove evidence wasn't tampered |
| Not taking screenshots/notes | Memory is unreliable for legal proceedings |

### Interview Questions

**Q: What is chain of custody?**
> A documented record of who handled evidence, when, where, and how. It proves evidence integrity and is required for legal admissibility.

**Q: Why do you image a disk instead of examining it directly?**
> To preserve the original evidence. Direct analysis can modify timestamps and data. We work on forensic images (exact copies) and keep the original untouched.

**Q: What is order of volatility?**
> The order in which evidence should be collected based on how quickly it disappears. RAM is most volatile (lost on power off), disk is less volatile, backups are least volatile.

---

## 15.8 Practice & Assessment

### MCQs

**Q1.** In digital forensics, which should be collected FIRST?
- A) Hard drive data
- B) RAM contents
- C) Backup tapes
- D) Printed documents

**Answer:** B) RAM contents — most volatile, lost on power off.

---

**Q2.** Chain of custody is important because:
- A) It speeds up the investigation
- B) It ensures evidence is legally admissible
- C) It reduces the cost of investigation
- D) It's only needed for physical evidence

**Answer:** B) It ensures evidence is legally admissible.

---

**Q3.** The `file` command in Linux is useful in forensics because:
- A) It shows file permissions
- B) It identifies true file type regardless of extension
- C) It encrypts files
- D) It deletes files securely

**Answer:** B) It identifies true file type regardless of extension.

---

> **Next Topic:** [16 - Cyber Laws & Ethics](16-cyber-laws-ethics.md)
