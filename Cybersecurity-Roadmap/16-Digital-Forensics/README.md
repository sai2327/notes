# 🔎 Digital Forensics

## Investigating Cyber Incidents — Evidence Collection and Analysis

---

## Overview

Digital forensics is the science of collecting, preserving, and analyzing digital evidence to investigate security incidents, criminal activity, or policy violations.

---

## Forensics Principles

| Principle | Description |
|-----------|-------------|
| **Preserve evidence** | Never modify original evidence |
| **Chain of custody** | Document who handled evidence and when |
| **Documentation** | Record every step of analysis |
| **Reproducibility** | Others should reach same conclusions |
| **Integrity** | Verify evidence hasn't been altered (hashing) |

---

## Types of Forensics

| Type | Focus | Tools |
|------|-------|-------|
| **Disk Forensics** | Hard drives, SSDs | Autopsy, FTK, EnCase |
| **Memory Forensics** | RAM analysis | Volatility, Rekall |
| **Network Forensics** | Packet captures | Wireshark, NetworkMiner |
| **Mobile Forensics** | Phones, tablets | Cellebrite, AXIOM |
| **Cloud Forensics** | Cloud logs/artifacts | AWS CloudTrail, Azure logs |

---

## Disk Forensics

### Creating Forensic Image

```bash
# Create bit-for-bit copy (NEVER work on original!)
dd if=/dev/sda of=/evidence/disk.img bs=4M status=progress

# Better tool: dc3dd (with hashing)
dc3dd if=/dev/sda of=/evidence/disk.img hash=sha256 log=acquisition.log

# Verify integrity
sha256sum /dev/sda
sha256sum /evidence/disk.img
# Hashes MUST match!

# Mount read-only for analysis
mount -o ro,noexec,loop /evidence/disk.img /mnt/evidence/
```

### Autopsy (GUI Forensics Tool)

```
1. Create new case
2. Add data source (disk image)
3. Run ingest modules:
   - Hash calculation
   - Keyword search
   - File type identification
   - Web artifacts
   - Email parsing
   - Deleted file recovery
4. Examine results:
   - Timeline analysis
   - File system browsing
   - Deleted files
   - Web history
   - Communications
```

### Key Artifacts (Windows)

| Artifact | Location | Contains |
|----------|----------|----------|
| Registry hives | `C:\Windows\System32\config\` | System config, user activity |
| Event logs | `C:\Windows\System32\winevt\Logs\` | System events |
| Prefetch | `C:\Windows\Prefetch\` | Program execution evidence |
| Amcache | `C:\Windows\AppCompat\Programs\` | Program execution history |
| MFT | `$MFT` (root of NTFS) | File metadata, timestamps |
| USN Journal | `$UsnJrnl` | File changes |
| Browser history | `%AppData%\Local\...` | Web activity |
| Jump Lists | `%AppData%\Recent\` | Recently accessed files |

---

## Memory Forensics

### Volatility 3 (Primary Tool)

```bash
# Identify OS profile
vol -f memory.dmp windows.info

# List processes
vol -f memory.dmp windows.pslist
vol -f memory.dmp windows.pstree

# Find hidden processes
vol -f memory.dmp windows.psscan

# Network connections
vol -f memory.dmp windows.netscan

# Command line history
vol -f memory.dmp windows.cmdline

# Extract password hashes
vol -f memory.dmp windows.hashdump

# Dump a process
vol -f memory.dmp windows.memmap --pid 1234 --dump

# Find injected code
vol -f memory.dmp windows.malfind

# Registry analysis
vol -f memory.dmp windows.registry.hivelist

# DLL list for a process
vol -f memory.dmp windows.dlllist --pid 1234
```

### What to Look for in Memory

| Artifact | Indicates |
|----------|-----------|
| Unexpected processes | Malware running |
| Injected code (malfind) | Process injection |
| Network connections | C2 communication |
| Loaded DLLs | DLL injection |
| Registry keys | Persistence |
| Command history | Attacker actions |
| Cleartext passwords | Credential access |

---

## Timeline Analysis

```bash
# Create super timeline with Plaso
log2timeline.py timeline.plaso disk.img
psort.py -o l2tcsv timeline.plaso -w timeline.csv

# Filter timeline for specific period
psort.py timeline.plaso "date > '2024-01-15' AND date < '2024-01-16'" -w filtered.csv

# Key events to correlate:
# - User logon times
# - Program execution
# - File creation/modification
# - Network connections
# - Registry changes
```

---

## Forensics Methodology

```
1. Identification
   - What happened? What systems are affected?

2. Preservation
   - Acquire evidence (disk images, memory dumps)
   - Document chain of custody
   - Hash everything

3. Analysis
   - Timeline reconstruction
   - Artifact analysis
   - Malware identification
   - User activity reconstruction

4. Reporting
   - Findings and conclusions
   - Evidence documentation
   - Timeline of events
   - Recommendations
```

---

## Exercises

1. Analyze a disk image from CyberDefenders (cyberdefenders.org)
2. Perform memory forensics with Volatility on a sample memory dump
3. Build a timeline from system artifacts
4. Recover deleted files from a disk image
5. Write a forensics report for a simulated incident

---

**Next:** → [17-Cryptography](../17-Cryptography/README.md)

*"In forensics, every bit tells a story. Your job is to read it."*
